import 'package:chat_app/common/api.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';

class HttpService {
  final _dio = Dio(
    BaseOptions(baseUrl: Api.baseUrl),
  );

  // Keep track of refresh callbacks
  final Map<String, List<FreshDataCallback>> _refreshCallbacks = {};

  HttpService() {
    _initializeCache();
  }

  Future<void> _initializeCache() async {
    try {
      // Create a proper path for cache storage
      final directory = await getApplicationDocumentsDirectory();
      final cacheDir = Directory('${directory.path}/dio_cache');

      // Ensure the directory exists
      if (!await cacheDir.exists()) {
        await cacheDir.create(recursive: true);
      }

      // Tạo custom cache store sử dụng Hive
      final cacheStore = HiveCacheStore(cacheDir.path);
      await cacheStore.init();

      // Configure cache with Stale-While-Revalidate strategy
      final cacheOptions = CacheOptions(
        store: cacheStore,
        // Sử dụng refreshForceCache để triển khai Stale-While-Revalidate
        policy: CachePolicy.refreshForceCache,
        hitCacheOnErrorExcept: [401, 403],
        maxStale: const Duration(days: 7),
        priority: CachePriority.normal,
      );

      // Create and add the cache interceptor
      final dioCacheInterceptor = DioCacheInterceptor(
        options: cacheOptions,
      );

      // Add cache interceptor to dio
      _dio.interceptors.add(dioCacheInterceptor);

      // Add response interceptor để xử lý callback
      _dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            print('Dio Request: ${options.uri}');
            return handler.next(options);
          },
          onResponse: (response, handler) {
            print('Dio Response: ${response.statusCode}');

            // Kiểm tra nếu đây là dữ liệu mới (không phải từ cache)
            final extra = response.extra;
            if (extra.containsKey('responseDate')) {
              final responseDate = extra['responseDate'] as DateTime;
              final now = DateTime.now();
              final diff = now.difference(responseDate);

              // Nếu dữ liệu mới (dưới 2 giây) thì gọi callback
              if (diff.inSeconds < 2) {
                final requestKey = _getRequestKey(
                  response.requestOptions.path,
                  response.requestOptions.queryParameters,
                );

                if (_refreshCallbacks.containsKey(requestKey)) {
                  // Thông báo cho tất cả callback đã đăng ký cho request này
                  for (final callback in _refreshCallbacks[requestKey]!) {
                    callback(response.data);
                  }
                }
              }
            }

            return handler.next(response);
          },
          onError: (DioException e, handler) {
            print('Dio Error: ${e.message}');
            return handler.next(e);
          },
        ),
      );
    } catch (e) {
      print('Failed to initialize cache: $e');
      // Fall back to logging interceptor only
      _dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            print('Dio Request: ${options.uri}');
            return handler.next(options);
          },
          onResponse: (response, handler) {
            print('Dio Response: ${response.statusCode}');
            return handler.next(response);
          },
          onError: (DioException e, handler) {
            print('Dio Error: ${e.message}');
            return handler.next(e);
          },
        ),
      );
    }
  }

  // Generate a unique key for each request based on URL and parameters
  String _getRequestKey(String url, Map<String, dynamic>? queryParameters) {
    return '$url${queryParameters != null ? '_${queryParameters.toString()}' : ''}';
  }

  // Register a callback for when fresh data is available
  void registerFreshDataCallback(String url,
      Map<String, dynamic>? queryParameters, FreshDataCallback callback) {
    final requestKey = _getRequestKey(url, queryParameters);
    _refreshCallbacks[requestKey] ??= [];
    _refreshCallbacks[requestKey]!.add(callback);
  }

  // Remove a callback when no longer needed
  void removeFreshDataCallback(String url,
      Map<String, dynamic>? queryParameters, FreshDataCallback callback) {
    final requestKey = _getRequestKey(url, queryParameters);
    if (_refreshCallbacks.containsKey(requestKey)) {
      _refreshCallbacks[requestKey]!.remove(callback);
      if (_refreshCallbacks[requestKey]!.isEmpty) {
        _refreshCallbacks.remove(requestKey);
      }
    }
  }

  // Get request with stale-while-revalidate support
  Future<Response> get({
    required String url,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    FreshDataCallback? onFreshData,
  }) async {
    Response response;
    try {
      // Register refresh callback if provided
      if (onFreshData != null) {
        registerFreshDataCallback(url, queryParameters, onFreshData);
      }

      response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: Options(
          headers: headers ?? await getHeaders(),
        ),
      );

      // Clean up callback after request is complete
      if (onFreshData != null) {
        removeFreshDataCallback(url, queryParameters, onFreshData);
      }
    } on DioException catch (error) {
      response = _handleDioError(error);
    }

    return response;
  }

  // Post request with stale-while-revalidate support
  Future<Response> post({
    required String url,
    dynamic data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    String contentType = 'application/json',
    FreshDataCallback? onFreshData,
  }) async {
    Response response;
    try {
      // Register refresh callback if provided
      if (onFreshData != null) {
        registerFreshDataCallback(url, queryParameters, onFreshData);
      }

      response = await _dio.post(
        url,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          headers: headers ?? await getHeaders(contentType: contentType),
        ),
      );

      // Clean up callback after request is complete
      if (onFreshData != null) {
        removeFreshDataCallback(url, queryParameters, onFreshData);
      }
    } on DioException catch (error) {
      response = _handleDioError(error);
    }

    return response;
  }

  // Post request with file
  Future<Response> postFile({
    required String url,
    required FormData data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    FreshDataCallback? onFreshData,
  }) async {
    Response response;
    try {
      // Register refresh callback if provided
      if (onFreshData != null) {
        registerFreshDataCallback(url, queryParameters, onFreshData);
      }

      response = await _dio.post(
        url,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          headers:
              headers ?? await getHeaders(contentType: 'multipart/form-data'),
        ),
      );

      // Clean up callback after request is complete
      if (onFreshData != null) {
        removeFreshDataCallback(url, queryParameters, onFreshData);
      }
    } on DioException catch (error) {
      response = _handleDioError(error);
    }

    return response;
  }

  // Put request with stale-while-revalidate support
  Future<Response> put({
    required String url,
    dynamic data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    String contentType = 'application/json',
    FreshDataCallback? onFreshData,
  }) async {
    Response response;
    try {
      // Register refresh callback if provided
      if (onFreshData != null) {
        registerFreshDataCallback(url, queryParameters, onFreshData);
      }

      response = await _dio.put(
        url,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          headers: headers ?? await getHeaders(contentType: contentType),
        ),
      );

      // Clean up callback after request is complete
      if (onFreshData != null) {
        removeFreshDataCallback(url, queryParameters, onFreshData);
      }
    } on DioException catch (error) {
      response = _handleDioError(error);
    }

    return response;
  }

  // Put request with file
  Future<Response> putFile({
    required String url,
    required FormData data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    FreshDataCallback? onFreshData,
  }) async {
    Response response;
    try {
      // Register refresh callback if provided
      if (onFreshData != null) {
        registerFreshDataCallback(url, queryParameters, onFreshData);
      }

      response = await _dio.put(
        url,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          headers:
              headers ?? await getHeaders(contentType: 'multipart/form-data'),
        ),
      );

      // Clean up callback after request is complete
      if (onFreshData != null) {
        removeFreshDataCallback(url, queryParameters, onFreshData);
      }
    } on DioException catch (error) {
      response = _handleDioError(error);
    }

    return response;
  }

  // Delete request with stale-while-revalidate support
  Future<Response> delete({
    required String url,
    dynamic data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    String contentType = 'application/json',
    FreshDataCallback? onFreshData,
  }) async {
    Response response;
    try {
      // Register refresh callback if provided
      if (onFreshData != null) {
        registerFreshDataCallback(url, queryParameters, onFreshData);
      }

      response = await _dio.delete(
        url,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          headers: headers ?? await getHeaders(contentType: contentType),
        ),
      );

      // Clean up callback after request is complete
      if (onFreshData != null) {
        removeFreshDataCallback(url, queryParameters, onFreshData);
      }
    } on DioException catch (error) {
      response = _handleDioError(error);
    }

    return response;
  }

  // Patch request with stale-while-revalidate support
  Future<Response> patch({
    required String url,
    dynamic data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    String contentType = 'application/json',
    FreshDataCallback? onFreshData,
  }) async {
    Response response;
    try {
      // Register refresh callback if provided
      if (onFreshData != null) {
        registerFreshDataCallback(url, queryParameters, onFreshData);
      }

      response = await _dio.patch(
        url,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          headers: headers ?? await getHeaders(contentType: contentType),
        ),
      );

      // Clean up callback after request is complete
      if (onFreshData != null) {
        removeFreshDataCallback(url, queryParameters, onFreshData);
      }
    } on DioException catch (error) {
      response = _handleDioError(error);
    }

    return response;
  }

  // Get headers
  Future<Map<String, String>> getHeaders({
    contentType = 'application/json',
  }) async {
    final userToken = await AuthService().getToken();
    print('User token: $userToken');
    return {
      'Authorization': 'Bearer $userToken',
      'Content-Type': contentType,
    };
  }

  // Handle Dio error
  Response _handleDioError(DioException error) {
    if (error.response != null) {
      final statusCode = error.response?.statusCode ?? 400;
      final errorMessage = error.response?.data is Map
          ? error.response?.data['message']
          : error.response?.statusMessage ?? 'Unknown error';

      print('Error: $errorMessage, Status Code: $statusCode');

      return Response(
        requestOptions: error.requestOptions,
        statusCode: statusCode,
        statusMessage: errorMessage,
        data: error.response?.data,
      );
    } else {
      String? fallbackMessage;

      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          fallbackMessage =
              "Connection timeout. Please check your internet connection and try again";
          break;
        case DioExceptionType.sendTimeout:
          fallbackMessage =
              "Send timeout. Please check your internet connection and try again";
          break;
        case DioExceptionType.receiveTimeout:
          fallbackMessage =
              "Receive timeout. Please check your internet connection and try again";
          break;
        case DioExceptionType.cancel:
          fallbackMessage = "Request to server was cancelled. Please try again";
          break;
        case DioExceptionType.unknown:
          fallbackMessage = "Unexpected error occurred. Please try again";
          break;
        default:
          fallbackMessage = error.message ?? "An unexpected error occurred";
      }

      print('Error: $fallbackMessage');

      return Response(
        requestOptions: error.requestOptions,
        statusCode: 400,
        statusMessage: fallbackMessage,
      );
    }
  }
}

typedef FreshDataCallback<T> = void Function(T freshData);

// Triển khai custom CacheStore sử dụng Hive
class HiveCacheStore implements CacheStore {
  static const String _boxName = 'dio_cache';
  late Box<dynamic> _box;
  final String? _path;

  HiveCacheStore([this._path]);

  @override
  Future<void> close() async {
    await _box.close();
  }

  @override
  Future<void> clean(
      {CachePriority? priorityOrBelow, bool staleOnly = false}) async {
    if (priorityOrBelow != null || staleOnly) {
      final filterFn = _buildFilterFunction(
          priorityOrBelow: priorityOrBelow, staleOnly: staleOnly);
      final keys = _box.keys.where((key) {
        final item = _box.get(key);
        if (item == null) return false;
        return filterFn(_cacheResponseFromJson(item));
      }).toList();

      await _box.deleteAll(keys);
    } else {
      await _box.clear();
    }
  }

  @override
  Future<void> delete(String key, {bool staleOnly = false}) async {
    if (!staleOnly) {
      await _box.delete(key);
    } else {
      final entry = _box.get(key);
      if (entry == null) return;

      final cacheResponse = _cacheResponseFromJson(entry);
      if (_isStale(cacheResponse)) {
        await _box.delete(key);
      }
    }
  }

  @override
  Future<void> deleteFromPath(RegExp pattern,
      {Map<String, String?>? queryParams}) async {
    final keys = _box.keys.where((k) {
      final key = k.toString();
      if (!pattern.hasMatch(key)) return false;

      // Check query params if needed
      if (queryParams != null && queryParams.isNotEmpty) {
        final value = _box.get(k);
        if (value == null) return false;

        final response = _cacheResponseFromJson(value);

        final uri = Uri.parse(response.url);
        for (final entry in queryParams.entries) {
          if (entry.value != null) {
            if (uri.queryParameters[entry.key] != entry.value) return false;
          } else {
            if (!uri.queryParameters.containsKey(entry.key)) return false;
          }
        }
      }

      return true;
    }).toList();

    await _box.deleteAll(keys);
  }

  @override
  Future<bool> exists(String key) async {
    return _box.containsKey(key);
  }

  @override
  Future<CacheResponse?> get(String key) async {
    final value = _box.get(key);
    if (value == null) return null;
    return _cacheResponseFromJson(value);
  }

  Future<List<CacheResponse>> getAll(
      {CachePriority? priorityOrBelow, bool staleOnly = false}) async {
    final filterFn = _buildFilterFunction(
        priorityOrBelow: priorityOrBelow, staleOnly: staleOnly);
    return _box.values
        .map((item) => _cacheResponseFromJson(item))
        .where(filterFn)
        .toList();
  }

  @override
  Future<List<CacheResponse>> getFromPath(RegExp pattern,
      {Map<String, String?>? queryParams}) async {
    final results = <CacheResponse>[];

    for (final key in _box.keys) {
      final keyStr = key.toString();
      if (!pattern.hasMatch(keyStr)) continue;

      final value = _box.get(key);
      if (value == null) continue;

      final response = _cacheResponseFromJson(value);

      // Check query params if needed
      if (queryParams != null && queryParams.isNotEmpty) {
        final uri = Uri.parse(response.url);
        bool matches = true;

        for (final entry in queryParams.entries) {
          if (entry.value != null) {
            if (uri.queryParameters[entry.key] != entry.value) {
              matches = false;
              break;
            }
          } else {
            if (!uri.queryParameters.containsKey(entry.key)) {
              matches = false;
              break;
            }
          }
        }

        if (!matches) continue;
      }

      results.add(response);
    }

    return results;
  }

  @override
  bool pathExists(String prefix, RegExp pattern,
      {Map<String, String?>? queryParams}) {
    for (final key in _box.keys) {
      final keyStr = key.toString();
      if (!keyStr.startsWith(prefix)) continue;
      if (!pattern.hasMatch(keyStr)) continue;

      // Check query params if needed
      if (queryParams != null && queryParams.isNotEmpty) {
        final value = _box.get(key);
        if (value == null) continue;

        final response = _cacheResponseFromJson(value);

        final uri = Uri.parse(response.url);
        bool matches = true;

        for (final entry in queryParams.entries) {
          if (entry.value != null) {
            if (uri.queryParameters[entry.key] != entry.value) {
              matches = false;
              break;
            }
          } else {
            if (!uri.queryParameters.containsKey(entry.key)) {
              matches = false;
              break;
            }
          }
        }

        if (!matches) continue;
      }

      return true;
    }

    return false;
  }

  @override
  Future<void> set(CacheResponse response) async {
    await _box.put(response.key, _cacheResponseToJson(response));
  }

  Future<void> init() async {
    // Khởi tạo đường dẫn mặc định nếu không được cung cấp
    String path = _path ?? '${Directory.systemTemp.path}/dio_cache';

    // Khởi tạo Hive
    Hive.init(path);
    _box = await Hive.openBox<dynamic>(_boxName);
  }

  // Hàm helper để chuyển đổi CacheResponse thành Map
  Map<String, dynamic> _cacheResponseToJson(CacheResponse response) {
    return {
      'key': response.key,
      'content': base64.encode(response.content ?? []),
      'headers': response.headers,
      'etag': response.eTag,
      'lastModified': response.lastModified,
      'maxStale': response.maxStale?.difference(DateTime.now()).inMilliseconds,
      'date': response.date?.millisecondsSinceEpoch ?? 0,
      'priority': response.priority.index,
      'requestDate': response.requestDate.millisecondsSinceEpoch,
      'responseDate': response.responseDate.millisecondsSinceEpoch,
      'url': response.url,
      'cacheControl': response.cacheControl.toHeader(),
      'expires': response.expires?.millisecondsSinceEpoch,
    };
  }

  // Hàm helper để chuyển đổi Map thành CacheResponse
  CacheResponse _cacheResponseFromJson(dynamic json) {
    if (json is! Map) {
      throw Exception('Invalid cache data format');
    }

    // Tạo headers nếu có - chuyển từ Map thành List<int> nếu cần
    final headersMap = json['headers'];
    List<int>? headersList;
    if (headersMap != null) {
      // Chuyển đổi Map headers thành chuỗi JSON, sau đó thành List<int>
      final headersJson = jsonEncode(headersMap);
      headersList = utf8.encode(headersJson);
    }

    return CacheResponse(
      key: json['key'] as String,
      content: base64.decode(json['content'] as String),
      headers: headersList,
      eTag: json['eTag'] as String?,
      lastModified: json['lastModified'] as String?,
      maxStale: json['maxStale'] != null
          ? DateTime.now().add(Duration(milliseconds: json['maxStale'] as int))
          : null,
      date: json['date'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['date'] as int)
          : DateTime.now(),
      priority: CachePriority.values[json['priority'] as int],
      requestDate:
          DateTime.fromMillisecondsSinceEpoch(json['requestDate'] as int),
      responseDate:
          DateTime.fromMillisecondsSinceEpoch(json['responseDate'] as int),
      url: json['url'] as String? ?? '',
      cacheControl:
          CacheControl.fromHeader(json['cacheControl'] as List<String>? ?? []),
      expires: json['expires'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['expires'] as int)
          : null,
    );
  }

  // Hàm lọc cache theo điều kiện
  bool Function(CacheResponse) _buildFilterFunction(
      {CachePriority? priorityOrBelow, bool staleOnly = false}) {
    return (CacheResponse response) {
      if (priorityOrBelow != null &&
          response.priority.index > priorityOrBelow.index) {
        return false;
      }
      if (staleOnly && !_isStale(response)) {
        return false;
      }
      return true;
    };
  }

  // Kiểm tra xem response có bị cũ (stale) hay không
  bool _isStale(CacheResponse response) {
    if (response.maxStale == null) return false;
    final now = DateTime.now();
    final staleTime = response.maxStale!;
    return now.isAfter(staleTime);
  }
}
