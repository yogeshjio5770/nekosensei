import 'dart:math';

/// Split Japanese phrases into tap-to-build word tiles (Duolingo-style).
class JapaneseTokens {
  JapaneseTokens._();

  static const _suffixes = ['ください', 'でした', 'ません', 'です', 'ます'];
  static const _particles = {'は', 'が', 'を', 'に', 'で', 'と', 'の', 'か', 'も', 'へ', 'や'};

  static List<String> tokenize(String phrase) {
    final cleaned = phrase.replaceAll(RegExp(r'[。、！？!?.\s]'), '');
    if (cleaned.isEmpty) return [];

    // Single kana / short word — one tile.
    if (cleaned.length <= 2) return [cleaned];

    final tokens = <String>[];
    var i = 0;
    while (i < cleaned.length) {
      var matched = false;
      for (final suffix in _suffixes) {
        if (cleaned.startsWith(suffix, i)) {
          tokens.add(suffix);
          i += suffix.length;
          matched = true;
          break;
        }
      }
      if (matched) continue;

      if (_particles.contains(cleaned[i])) {
        tokens.add(cleaned[i]);
        i++;
        continue;
      }

      final start = i;
      while (i < cleaned.length &&
          !_particles.contains(cleaned[i]) &&
          !_startsSuffix(cleaned, i)) {
        i++;
      }
      if (i > start) {
        tokens.add(cleaned.substring(start, i));
      } else {
        tokens.add(cleaned[i]);
        i++;
      }
    }
    return tokens.where((t) => t.isNotEmpty).toList();
  }

  static bool _startsSuffix(String text, int index) {
    for (final suffix in _suffixes) {
      if (text.startsWith(suffix, index)) return true;
    }
    return false;
  }

  /// Correct tokens + shuffled distractors for word-bank exercises.
  static List<String> buildWordBank(
    List<String> correctTokens, {
    List<String> distractors = const [],
    int maxTiles = 10,
  }) {
    final bank = [...correctTokens, ...distractors];
    bank.shuffle(Random(correctTokens.join().hashCode));
    return bank.take(maxTiles.clamp(correctTokens.length, 12)).toList();
  }

  static String joinTokens(List<String> tokens) => tokens.join('');
}
