import 'package:flutter/material.dart' hide ThemeMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';
import '../services/progress_service.dart';
import '../services/groq_service.dart';
import '../services/exam_service.dart';
import '../services/certificate_service.dart';
import '../services/audio_service.dart';
import '../services/speech_service.dart';
import '../services/spaced_repetition_service.dart';
import '../services/daily_lesson_service.dart';
import '../services/app_bootstrap.dart';
import '../models/user_model.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());
final progressServiceProvider =
    Provider<ProgressService>((ref) => ProgressService());
final groqServiceProvider = Provider<GroqService>((ref) => GroqService());
final examServiceProvider = Provider<ExamService>((ref) => ExamService());
final certificateServiceProvider =
    Provider<CertificateService>((ref) => CertificateService());
final audioServiceProvider = Provider<AudioService>((ref) {
  final service = AudioService();
  ref.onDispose(service.dispose);
  return service;
});
final speechServiceProvider = Provider<SpeechService>((ref) => SpeechService());
final spacedRepetitionProvider =
    Provider<SpacedRepetitionService>((ref) => SpacedRepetitionService());
final dailyLessonProvider =
    Provider<DailyLessonService>((ref) => DailyLessonService());

final authStateProvider = StreamProvider((ref) {
  if (!AppBootstrap.firebaseReady) {
    return Stream.value(null);
  }
  return ref.watch(authServiceProvider).authStateChanges;
});

final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  if (!AppBootstrap.firebaseReady) return null;

  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (_) => ref.read(authServiceProvider).getCurrentUserProfile(),
    loading: () => null,
    error: (_, __) => null,
  );
});

final themeModeProvider = StateProvider<AppThemeMode>((ref) => AppThemeMode.system);

enum AppThemeMode { light, dark, system }
