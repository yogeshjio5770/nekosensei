import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart';

/// Speech recognition for speaking practice — compare learner vs expected.
class SpeechService {
  SpeechService({SpeechToText? speech})
      : _speech = speech ?? SpeechToText();

  final SpeechToText _speech;
  bool _available = false;

  Future<bool> initialize() async {
    _available = await _speech.initialize(
      onError: (error) => debugPrint('[Speech] Error: $error'),
      onStatus: (status) => debugPrint('[Speech] Status: $status'),
    );
    return _available;
  }

  bool get isAvailable => _available;
  bool get isListening => _speech.isListening;

  Future<bool> listen({
    required void Function(String text) onResult,
    required void Function(bool isListening) onListening,
    String localeId = 'ja_JP',
  }) async {
    if (!_available) await initialize();
    if (!_available) {
      debugPrint('[Speech] Not available');
      onListening(false);
      return false;
    }

    try {
      await _speech.listen(
        onResult: (result) {
          debugPrint('[Speech] Result: "${result.recognizedWords}", final: ${result.finalResult}');
          onResult(result.recognizedWords);
          if (result.finalResult) onListening(false);
        },
        onSoundLevelChange: (_) {},
        localeId: localeId,
        listenMode: ListenMode.confirmation,
        cancelOnError: false,
        partialResults: true,
        listenFor: const Duration(seconds: 8),
        pauseFor: const Duration(seconds: 3),
      );
      onListening(true);
      return true;
    } catch (e) {
      debugPrint('[Speech] Listen failed: $e');
      onListening(false);
      return false;
    }
  }

  Future<void> stop() async {
    await _speech.stop();
  }

  /// Fuzzy match for Japanese speaking — romaji or partial Japanese OK.
  static bool matchesExpected(String spoken, String expected, {String? romaji}) {
    final s = _normalize(spoken);
    final e = _normalize(expected);
    final r = romaji != null ? _normalize(romaji) : '';

    debugPrint('[Speech] Check: spoken="$spoken" (norm="$s"), expected="$expected" (norm="$e"), romaji="$romaji" (norm="$r")');

    if (s.isEmpty) {
      debugPrint('[Speech] Spoken is empty');
      return false;
    }
    if (s == e || s.contains(e) || e.contains(s)) {
      debugPrint('[Speech] Exact/contains match');
      return true;
    }
    if (r.isNotEmpty && (s.contains(r) || r.contains(s))) {
      debugPrint('[Speech] Romaji match');
      return true;
    }

    // Character overlap for Japanese
    final spokenChars = s.replaceAll(RegExp(r'[\s\-]'), '');
    final expectedChars = e.replaceAll(RegExp(r'[\s\-]'), '');
    if (spokenChars.isEmpty || expectedChars.isEmpty) {
      debugPrint('[Speech] No chars to compare');
      return false;
    }

    var matches = 0;
    for (final c in spokenChars.split('')) {
      if (expectedChars.contains(c)) matches++;
    }
    final ratio = matches / expectedChars.length;
    debugPrint('[Speech] Overlap: $matches/$expectedChars.length ($ratio)');
    return ratio >= 0.3;
  }

  static String _normalize(String input) =>
      input.toLowerCase().trim().replaceAll(RegExp(r'[.,!?。、！？]'), '');
}
