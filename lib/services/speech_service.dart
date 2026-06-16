import 'package:speech_to_text/speech_to_text.dart';

/// Speech recognition for speaking practice — compare learner vs expected.
class SpeechService {
  SpeechService({SpeechToText? speech})
      : _speech = speech ?? SpeechToText();

  final SpeechToText _speech;
  bool _available = false;

  Future<bool> initialize() async {
    _available = await _speech.initialize(
      onError: (_) {},
      onStatus: (_) {},
    );
    return _available;
  }

  bool get isAvailable => _available;

  Future<void> listen({
    required void Function(String text) onResult,
    required void Function(bool isListening) onListening,
    String localeId = 'ja_JP',
  }) async {
    if (!_available) await initialize();
    if (!_available) return;

    await _speech.listen(
      onResult: (result) => onResult(result.recognizedWords),
      localeId: localeId,
      listenMode: ListenMode.confirmation,
      cancelOnError: true,
      partialResults: true,
    );
    onListening(true);
  }

  Future<void> stop() async {
    await _speech.stop();
  }

  /// Fuzzy match for Japanese speaking — romaji or partial Japanese OK.
  static bool matchesExpected(String spoken, String expected, {String? romaji}) {
    final s = _normalize(spoken);
    final e = _normalize(expected);
    final r = romaji != null ? _normalize(romaji) : '';

    if (s.isEmpty) return false;
    if (s == e || s.contains(e) || e.contains(s)) return true;
    if (r.isNotEmpty && (s.contains(r) || r.contains(s))) return true;

    // Character overlap for Japanese
    final spokenChars = s.replaceAll(RegExp(r'[\s\-]'), '');
    final expectedChars = e.replaceAll(RegExp(r'[\s\-]'), '');
    if (spokenChars.isEmpty || expectedChars.isEmpty) return false;

    var matches = 0;
    for (final c in spokenChars.split('')) {
      if (expectedChars.contains(c)) matches++;
    }
    return matches / expectedChars.length >= 0.5;
  }

  static String _normalize(String input) =>
      input.toLowerCase().trim().replaceAll(RegExp(r'[.,!?。、！？]'), '');
}
