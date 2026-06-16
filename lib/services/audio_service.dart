import 'package:audioplayers/audioplayers.dart';
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
  bool _useAssetSfx = true;

  Future<void> initialize() async {
    if (_initialized) return;
    try {
      await _tts.setLanguage('ja-JP');
      await _tts.setSpeechRate(0.45);
      await _tts.setPitch(1.05);
      await _tts.setVolume(1.0);
    } catch (_) {
      await _tts.setLanguage('en-US');
    }
    _useAssetSfx = await _probeAsset('audio/correct.wav');
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

  Future<void> speakJapanese(String text, {double rate = 0.45}) async {
    if (text.trim().isEmpty) return;
    await initialize();
    try {
      await _tts.setLanguage('ja-JP');
    } catch (_) {}
    await _tts.setSpeechRate(rate);
    await _tts.stop();
    await _tts.speak(text);
  }

  Future<void> speakSlow(String text) => speakJapanese(text, rate: 0.32);

  Future<void> stop() async {
    await _tts.stop();
    await _assetPlayer.stop();
  }

  Future<void> playCorrect() async {
    await HapticFeedback.lightImpact();
    if (_useAssetSfx) {
      final ok = await _playAsset('audio/correct.wav');
      if (ok) return;
    }
    await _sfx.playCorrect();
  }

  Future<void> playWrong() async {
    await HapticFeedback.heavyImpact();
    if (_useAssetSfx) {
      final ok = await _playAsset('audio/wrong.wav');
      if (ok) return;
    }
    await _sfx.playWrong();
  }

  Future<void> playSuccess() async {
    await HapticFeedback.mediumImpact();
    if (_useAssetSfx) {
      final ok = await _playAsset('audio/success.wav');
      if (ok) return;
    }
    await _sfx.playSuccess();
  }

  Future<void> playTap() async {
    if (_useAssetSfx) {
      final ok = await _playAsset('audio/tap.wav');
      if (ok) return;
    }
    await _sfx.playTap();
  }

  Future<bool> _playAsset(String path) async {
    try {
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
