import 'dart:async';
import 'dart:convert';
import 'package:socket_io_client/socket_io_client.dart';

class WebSocketService {
  late final Socket _socket;
  bool _connected = false;

  // StreamController cho những ai muốn lắng nghe toàn bộ sự kiện
  final _streamController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get stream => _streamController.stream;

  // Map lưu danh sách hàm callback, mỗi type có thể có nhiều callback
  final Map<String, List<void Function(Map<String, dynamic>)>> _eventListeners =
      {};

  /// Kết nối WebSocket (gọi một lần, ví dụ ở main() hoặc khi app khởi động)
  void connect(String url, {String? token, String? deviceId}) {
    if (_connected) return; // tránh connect nhiều lần

    // Cấu hình Socket.IO
    _socket = io(
        url,
        OptionBuilder()
            .setTransports([
              'websocket'
            ]) // Chỉ sử dụng WebSocket, không fallback về polling
            // Pass token in both query and auth to make sure server gets it
            .setQuery({'token': token})
            .setAuth({'token': token})
            .setExtraHeaders({'token': token})
            .enableAutoConnect() // Tự động kết nối
            .enableReconnection() // Tự động kết nối lại khi mất kết nối
            .build());

    _connected = true;

    // Xử lý các sự kiện cơ bản
    _socket.onConnect((_) {
      print('Kết nối Socket.IO thành công');
    });

    _socket.onDisconnect((_) {
      print('Socket.IO bị ngắt kết nối');
      _connected = false;
      _notifyCallbacks('error', {'message': 'Kết nối WebSocket bị đóng'});
    });

    _socket.onConnectError((err) {
      print('Lỗi kết nối Socket.IO: $err');
      _notifyCallbacks('error', {'message': 'Lỗi kết nối: $err'});
    });

    _socket.onError((err) {
      print('Socket.IO error: $err');
      _notifyCallbacks('error', {'message': err.toString()});
    });

    // Xử lý các sự kiện từ server
    _socket.on('new_message', (data) {
      try {
        // Cho trường hợp data có thể là String
        final mapData = data is String ? jsonDecode(data) : data;

        if (mapData is Map<String, dynamic>) {
          _notifyCallbacks('new_message', mapData);
          _streamController.add({'type': 'new_message', 'data': mapData});
        }
      } catch (e) {
        _notifyCallbacks('error', {'message': 'Lỗi xử lý new_message: $e'});
      }
    });

    // Xử lý các event từ server (thêm các event khác từ backend nếu cần)
    final serverEvents = [
      'groupCreated',
      'memberAdded',
      'memberRemoved',
      'memberLeft',
      'message_read',
      'message_deleted',
      'message_edited',
      'groupNameUpdated',
      'groupAvatarUpdated',
      'conversationDeleted',
      'nicknameUpdated',
      'roleUpdated',
      'friend_request',
      'friend_request_accepted',
      'typing_start',
      'typing_end',
      'direct_message',
      'joined_conversation',
      'error'
    ];

    for (final event in serverEvents) {
      _socket.on(event, (data) {
        try {
          // Xử lý dữ liệu có thể là String (từ server gửi xuống)
          final mapData = data is String ? jsonDecode(data) : data;

          if (mapData is Map<String, dynamic>) {
            _notifyCallbacks(event, mapData);
            _streamController.add({'type': event, 'data': mapData});
          }
        } catch (e) {
          _notifyCallbacks('error', {'message': 'Lỗi xử lý $event: $e'});
        }
      });
    }
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

  /// Hàm gửi dữ liệu lên server (socket.emit)
  void send(String type, Map<String, dynamic> data) {
    if (!_connected) return;
    _socket.emit(type, {'type': type, 'data': data});
  }

  /// Hàm tham gia vào room (cuộc hội thoại)
  void joinConversation(String conversationId) {
    if (!_connected) return;
    _socket.emit('join_conversation', {
      'data': {'conversationId': conversationId}
    });
  }

  /// Hàm rời khỏi room (cuộc hội thoại)
  void leaveConversation(String conversationId) {
    if (!_connected) return;
    _socket.emit('leave_conversation', conversationId);
  }

  /// Gửi trạng thái đang nhập
  void sendTypingStart(String conversationId) {
    if (!_connected) return;
    _socket.emit('typing_start', conversationId);
  }

  /// Gửi trạng thái dừng nhập
  void sendTypingEnd(String conversationId) {
    if (!_connected) return;
    _socket.emit('typing_end', conversationId);
  }

  /// Gửi tin nhắn
  void sendMessage(String conversationId, Map<String, dynamic> messageData) {
    if (!_connected) return;
    // Cấu trúc data cần phải khớp với mong đợi của server
    final data = {
      'conversationId': conversationId,
      ...messageData,
    };
    _socket.emit('send_message', {'data': data});
  }

  /// Đóng kết nối
  void dispose() {
    if (_connected) {
      _socket.disconnect();
      _streamController.close();
      _connected = false;
    }
  }
}
