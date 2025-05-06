import 'dart:convert';
import 'dart:ui';

import 'package:chat_app/common/enum.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/requests/auth_request.dart';
import 'package:chat_app/router/routes.dart';
import 'package:chat_app/services/navigator_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';

class FirebaseService {
  static final FirebaseMessaging fcm = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static final AuthRequest _authRequest = AuthRequest();
  static const String webPushKey =
      'BLULY-SFYt2bEaB42XJUE6M_RvF8rZQvadTYUiT2jOKuCYUoM19XzOvAyAfzEYf-4SGsOfFb32LNb2RZ51SHuRw';

  static Future<void> init() async {
    try {
      // Khởi tạo Firebase
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      // Khởi tạo FCM (Firebase Cloud Messaging)
      final messaging = FirebaseMessaging.instance;

      // Xin quyền nhận notification
      final settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: true,
        sound: true,
      );

      // Cấu hình kênh thông báo trên Android
      const androidChannel = AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'This channel is used for important notifications.',
        importance: Importance.high,
      );

      // Khởi tạo local notifications
      await _localNotificationsPlugin.initialize(
        const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
          iOS: DarwinInitializationSettings(),
        ),
      );

      // Tạo kênh thông báo trên Android
      await _localNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(androidChannel);

      // Nhận FCM token
      final token = await messaging.getToken();
      print('FCM Token: $token');

      // Xử lý thông báo khi app đang chạy foreground
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Received foreground message: ${message.notification?.title}');

        // Hiển thị thông báo local
        if (message.notification != null) {
          _localNotificationsPlugin.show(
            message.hashCode,
            message.notification!.title,
            message.notification!.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                androidChannel.id,
                androidChannel.name,
                channelDescription: androidChannel.description,
                icon: '@mipmap/ic_launcher',
              ),
              iOS: const DarwinNotificationDetails(),
            ),
          );
        }
      });

      print('Firebase initialized successfully');
    } catch (e) {
      print('Error initializing Firebase: $e');
    }
  }

  static Future<String?> get fcmToken async =>
      await fcm.getToken(vapidKey: webPushKey); // Lấy token FCM

  static Future<void> syncFCMToken() async {
    // Lấy token
    String? token = await fcm.getToken();

    // Gửi token lên server nếu có
    if (token != null) {
      print("Gửi FCM Token: $token");
      await _authRequest.sendFCMTokenToServer(token);
    }
  }

  static Future<void> deleteFCMTokenOnServer() async {
    // Lấy token
    try {
      String? token = await fcm.getToken(vapidKey: webPushKey);

      // Xóa token trên server nếu có
      if (token != null) {
        print("Xóa FCM Token: $token");
        await _authRequest.deleteFCMTokenOnServer(token);
      }
    } catch (e) {
      print("Lỗi khi lấy token: $e");
    }
  }

  // Code xử lý khi nhân thông báo trên background trong này, không dùng anymous function
  @pragma('vm:entry-point')
  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    // await Firebase.initializeApp();

    print("Handling a background message: ${message.messageId}");
  }

  static Future<void> handleNotificationNavigation(RemoteMessage message,
      {bool fromBackground = true}) async {
    if (message.data.isEmpty) return;

    final NotificationType notificationType =
        NotificationType.values.firstWhere(
      (element) => element.value == message.data['type'],
      orElse: () => NotificationType.unknown,
    );
    if (notificationType == NotificationType.unknown) return;

    final context = navigatorKey.currentState?.context;
    if (context == null) return;

    switch (notificationType) {
      case NotificationType.newFriendRequest:
        // Chuyển hướng đến trang bạn bè
        if (fromBackground) {
          context.go(Routes.friend);
        } else {
          context.push(Routes.friend, extra: message.data);
        }
        break;
      default:
    }
  }

  static Future<void> setupInteractedMessage() async {
    // Xử lý khi app đang terminate
    RemoteMessage? initialMessage = await fcm.getInitialMessage();
    if (initialMessage != null) {
      await handleNotificationNavigation(initialMessage);
      // if (callback != null) callback(initialMessage);
      _notifyCallbacks(initialMessage); // Gọi callback
    }

    // Xử lý khi app ở background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      await handleNotificationNavigation(message);
      // if (callback != null) callback(message);
      _notifyCallbacks(message); // Gọi callback
    });

    // Xử lý khi app ở foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      // Hiển thị local notification
      await showLocalNotification(message);
      // if (callback != null) callback(message);
      _notifyCallbacks(message); // Gọi callback
    });
  }

  static Future<void> showLocalNotification(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await _localNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title ?? '',
      message.notification?.body ?? '',
      notificationDetails,
      payload: message.data.toString(),
    );
  }

  // Thêm sự kiện xử lý khi người dùng nhấn vào thông báo
  static Future<void> handleNotificationClick(String? payload) async {
    if (payload == null) return;

    try {
      // Chuẩn hóa payload thành JSON hợp lệ
      final String jsonPayload = payload
          .replaceAllMapped(RegExp(r'([a-zA-Z0-9_]+):'),
              (match) => '"${match[1]}":') // Thêm dấu ngoặc kép cho khóa
          .replaceAllMapped(
              RegExp(r':\s*([^,\}\s]+)'),
              (match) =>
                  ': "${match[1]}"') // Thêm dấu ngoặc kép cho giá trị chuỗi
          .replaceAll("'", '"'); // Thay dấu nháy đơn thành nháy kép

      // Decode payload
      final Map<String, dynamic> data =
          Map<String, dynamic>.from(jsonDecode(jsonPayload));
      final RemoteMessage simulatedMessage = RemoteMessage(data: data);

      // Gọi hàm điều hướng
      await handleNotificationNavigation(simulatedMessage,
          fromBackground: false);
    } catch (e) {
      print("Error decoding payload: $e");
    }
  }

  /////////////////////////////////////////////
  // callback
  // Danh sách các callback
  static final List<Function(RemoteMessage)> _onMessageCallbacks = [];

  // Đăng ký callback
  static void registerOnMessageCallback(Function(RemoteMessage) callback) {
    if (!_onMessageCallbacks.contains(callback)) {
      _onMessageCallbacks.add(callback);
    }
  }

  // Hủy đăng ký callback
  static void unregisterOnMessageCallback(Function(RemoteMessage) callback) {
    _onMessageCallbacks.remove(callback);
  }

  // Gọi tất cả callback
  static void _notifyCallbacks(RemoteMessage message) {
    for (final callback in _onMessageCallbacks) {
      callback(message);
    }
  }
}
