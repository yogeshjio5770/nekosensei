import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'sfx_service.dart';

/// Japanese TTS + polished UI sound effects.
class AudioService {
  AudioService({
    FlutterTts? tts,
    AudioPlayer? assetPlayer,
    SfxService? sfx,
  })  : _tts = tts ?? FlutterTts(),
        _assetPlayer = assetPlayer ?? AudioPlayer(),
        _sfx = sfx ?? SfxService();

  final FlutterTts _tts;
  final AudioPlayer _assetPlayer;
  final SfxService _sfx;
  bool _initialized = false;

  /// Asset WAV files are optional; default off until probe succeeds.
  bool _assetSfxAvailable = false;

  /// Native speaker recordings in assets/audio/native/ (optional).
  bool _nativeAudioAvailable = false;

  final Set<String> _missingNativeKeys = {};

  /// Natural learning speed (slightly faster but still clear).
  static const double normalRate = 0.75;
  static const double slowRate = 0.5;

  Future<void> initialize() async {
    if (_initialized) return;
    try {
      await _tts.setLanguage('ja-JP');
      await _tts.setSpeechRate(normalRate);
      await _tts.setPitch(1.1); // Slightly higher pitch for clarity
      await _tts.setVolume(1.0);
      await _tts.awaitSpeakCompletion(false); // Don't block UI
      if (kIsWeb) {
        // Web Speech API needs an explicit voice when available.
        final voices = await _tts.getVoices;
        if (voices is List) {
          for (final v in voices) {
            if (v is Map &&
                (v['locale']?.toString().startsWith('ja') ?? false)) {
              await _tts.setVoice({'name': v['name'], 'locale': v['locale']});
              break;
            }
          }
        }
      }
    } catch (_) {
      try {
        await _tts.setLanguage('en-US');
      } catch (_) {}
    }

    // audioplayers on web double-prefixes asset paths (assets/assets/…) — use programmatic SFX.
    if (!kIsWeb) {
      _assetSfxAvailable = await _probeAsset('audio/correct.wav');
      _nativeAudioAvailable = await _probeAsset('audio/native/sample.mp3') ||
          await _probeAsset('audio/native/sample.wav');
    }

    _initialized = true;
  }

  Future<bool> _probeAsset(String path) async {
    try {
      await rootBundle.load('assets/$path');
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> speakJapanese(String text, {double? rate}) async {
    if (text.trim().isEmpty) return;
    await initialize();

    if (_nativeAudioAvailable) {
      final nativePlayed = await _playNativeJapanese(text);
      if (nativePlayed) return;
    }

    try {
      await _tts.setLanguage('ja-JP');
    } catch (_) {}
    await _tts.setSpeechRate(rate ?? normalRate);
    await _tts.stop();
    try {
      await _tts.speak(text);
    } catch (e) {
      debugPrint('TTS speak failed: $e');
    }
  }

  Future<bool> _playNativeJapanese(String text) async {
    if (!_nativeAudioAvailable || kIsWeb) return false;

    final key = _audioKey(text);
    if (_missingNativeKeys.contains(key)) return false;

    for (final path in [
      'audio/native/$key.mp3',
      'audio/native/$key.wav',
    ]) {
      if (await _probeAsset(path)) {
        return _playAsset(path);
      }
    }
    _missingNativeKeys.add(key);
    return false;
  }

  String _audioKey(String text) {
    final cleaned = text
        .trim()
        .replaceAll(RegExp(r'[^\w\u3040-\u30FF\u4E00-\u9FFF]'), '_')
        .toLowerCase();
    return cleaned.isEmpty ? 'default' : cleaned;
  }

  Future<void> speakSlow(String text) => speakJapanese(text, rate: slowRate);

  Future<void> stop() async {
    await _tts.stop();
    await _assetPlayer.stop();
  }

  Future<void> playCorrect() async {
    await HapticFeedback.lightImpact();
    if (_assetSfxAvailable && await _playAsset('audio/correct.wav')) return;
    await _sfx.playCorrect();
  }

  Future<void> playWrong() async {
    await HapticFeedback.heavyImpact();
    if (_assetSfxAvailable && await _playAsset('audio/wrong.wav')) return;
    await _sfx.playWrong();
  }

  Future<void> playSuccess() async {
    await HapticFeedback.mediumImpact();
    if (_assetSfxAvailable && await _playAsset('audio/success.wav')) return;
    await _sfx.playSuccess();
  }

  Future<void> playTap() async {
    if (_assetSfxAvailable && await _playAsset('audio/tap.wav')) return;
    await _sfx.playTap();
  }

  Future<bool> _playAsset(String path) async {
    if (kIsWeb) return false;
    try {
      if (!await _probeAsset(path)) return false;
      await _assetPlayer.stop();
      await _assetPlayer.play(AssetSource(path));
      return true;
    } catch (_) {
      return false;
    }
  }

  void dispose() {
    _assetPlayer.dispose();
    _sfx.dispose();
  }
}
