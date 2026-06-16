import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_providers.dart';

/// Defer provider reads until after first frame — avoids initState ref issues.
void safeInitServices(WidgetRef ref, List<Future<void> Function()> tasks) {
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    for (final task in tasks) {
      try {
        await task();
      } catch (_) {}
    }
  });
}

void useLessonServices(WidgetRef ref) {
  safeInitServices(ref, [
    () => ref.read(audioServiceProvider).initialize(),
    () => ref.read(speechServiceProvider).initialize(),
  ]);
}
