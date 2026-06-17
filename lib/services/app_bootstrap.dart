import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../firebase_options.dart';
import 'audio_service.dart';
import 'notification_service.dart';
import 'app_update_service.dart';

/// Safe app startup — never crash on missing .env or Firebase in dev.
class AppBootstrap {
  AppBootstrap._();

  static bool firebaseReady = false;
  static bool dotenvReady = false;

  static Future<void> initialize() async {
    await _loadEnv();
    await _initFirebase();
    try {
      await NotificationService().initialize();
    } catch (e) {
      debugPrint('Notifications skipped: $e');
    }
    try {
      await AudioService().initialize();
    } catch (e) {
      debugPrint('Audio init warning: $e');
    }
  }

  static Future<void> _loadEnv() async {
    try {
      await dotenv.load(fileName: '.env');
      dotenvReady = true;
    } catch (_) {
      try {
        await dotenv.load(fileName: '.env.example');
      } catch (e) {
        debugPrint('Env not loaded — using defaults');
      }
    }
  }

  static Future<void> _initFirebase() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      firebaseReady = true;
    } catch (e) {
      debugPrint('Firebase not configured — demo mode available: $e');
      firebaseReady = false;
    }
  }
}
