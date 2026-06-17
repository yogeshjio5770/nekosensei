import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> initialize() async {
    if (kIsWeb) {
      await _initializeWeb();
      return;
    }
    await _initializeMobile();
  }

  Future<void> _initializeWeb() async {
    try {
      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        debugPrint('User granted push notification permission (web)');
        await _setupToken();
        _listenToTokenRefreshes();
      }

      FirebaseMessaging.onMessage.listen(_logForegroundMessage);

      _auth.authStateChanges().listen((user) {
        if (user != null) _setupToken();
      });
    } catch (e) {
      debugPrint('Web notifications unavailable (service worker or HTTPS): $e');
    }
  }

  Future<void> _initializeMobile() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted push notification permission');
      await _setupToken();
      _listenToTokenRefreshes();
    } else {
      debugPrint('User declined or has not accepted permission');
    }

    FirebaseMessaging.onMessage.listen(_logForegroundMessage);
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    _auth.authStateChanges().listen((user) {
      if (user != null) _setupToken();
    });
  }

  void _logForegroundMessage(RemoteMessage message) {
    debugPrint('Got a message whilst in the foreground!');
    debugPrint('Message data: ${message.data}');
    if (message.notification != null) {
      debugPrint('Message also contained a notification: ${message.notification}');
    }
  }

  Future<void> _setupToken() async {
    try {
      final token = await _messaging.getToken();
      if (token != null) {
        await saveTokenToDatabase(token);
      }
    } catch (e) {
      debugPrint('Error getting FCM token: $e');
    }
  }

  void _listenToTokenRefreshes() {
    _messaging.onTokenRefresh.listen((newToken) {
      saveTokenToDatabase(newToken);
    }).onError((err) {
      debugPrint('Error on token refresh: $err');
    });
  }

  Future<void> saveTokenToDatabase(String token) async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        await _firestore.collection('users').doc(user.uid).update({
          'fcmToken': token,
        });
        debugPrint('Saved FCM token to Firestore for user: ${user.uid}');
      } catch (e) {
        debugPrint('Failed to save FCM token: $e');
      }
    }
  }
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Handling a background message: ${message.messageId}');
}
