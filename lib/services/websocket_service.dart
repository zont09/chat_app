import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  late final WebSocketChannel _channel;
  bool _connected = false;

  // StreamController cho những ai muốn lắng nghe toàn bộ sự kiện
  final _streamController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get stream => _streamController.stream;

  // Map lưu danh sách hàm callback, mỗi type có thể có nhiều callback
  final Map<String, List<void Function(Map<String, dynamic>)>> _eventListeners =
      {};

  /// Kết nối WebSocket (gọi một lần, ví dụ ở main() hoặc khi app khởi động)
  void connect(String url) {
    if (_connected) return; // tránh connect nhiều lần
    _channel = IOWebSocketChannel.connect(Uri.parse(url));
    _connected = true;

    _channel.stream.listen((message) {
      try {
        final jsonData = jsonDecode(message);
        if (jsonData is! Map<String, dynamic>) {
          // Dữ liệu sai định dạng => bắn event error
          _notifyCallbacks('error', {'message': 'Sai format (không phải Map)'});
          return;
        }

        final type = jsonData['type'];
        final data = jsonData['data'];

        // 1. Gọi những callback đăng ký cho type này
        if (type is String) {
          _notifyCallbacks(type, data);
        } else {
          // type không phải String => bắn event error
          _notifyCallbacks('error', {'message': 'type không phải String'});
        }

        // 2. Optionally, đẩy vào stream tổng (cho StreamBuilder)
        _streamController.add(jsonData);
      } catch (e) {
        _notifyCallbacks('error', {'message': 'Lỗi parse JSON: $e'});
      }
    }, onError: (error) {
      _notifyCallbacks('error', {'message': error.toString()});
    }, onDone: () {
      _notifyCallbacks('error', {'message': 'Kết nối WebSocket bị đóng'});
      _connected = false;
    });
  }

  /// Hàm đăng ký callback cho một loại sự kiện
  /// Ví dụ: ws.on("newMessage", (data) => print(data));
  void on(String type, void Function(Map<String, dynamic>) callback) {
    // Nếu chưa có type này, tạo list mới
    if (!_eventListeners.containsKey(type)) {
      _eventListeners[type] = [];
    }
    _eventListeners[type]!.add(callback);
  }

  /// Hàm bỏ đăng ký callback (nếu cần)
  void off(String type, void Function(Map<String, dynamic>) callback) {
    if (_eventListeners.containsKey(type)) {
      _eventListeners[type]!.remove(callback);
    }
  }

  /// Hàm nội bộ, gọi các callback đã đăng ký với type
  void _notifyCallbacks(String type, dynamic data) {
    // Nếu server chỉ gửi data kiểu Map, ta cần ép kiểu cẩn thận
    // Giả sử data phải là Map<String, dynamic>, nếu không có thì dùng {} mặc định
    final mapData = data is Map<String, dynamic> ? data : <String, dynamic>{};

    if (_eventListeners.containsKey(type)) {
      for (var callback in _eventListeners[type]!) {
        callback(mapData);
      }
    }
  }

  /// Hàm gửi dữ liệu lên server
  void send(String type, Map<String, dynamic> data) {
    if (!_connected) return;
    final msg = {'type': type, 'data': data};
    _channel.sink.add(jsonEncode(msg));
  }

  /// Đóng kết nối
  void dispose() {
    if (_connected) {
      _channel.sink.close();
      _streamController.close();
      _connected = false;
    }
  }
}
