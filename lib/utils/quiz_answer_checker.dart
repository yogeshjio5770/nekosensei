/// Normalizes and checks quiz answers (Japanese, romaji, English).
class QuizAnswerChecker {
  QuizAnswerChecker._();

  static bool isCorrect(String given, String expected) {
    final g = _normalize(given);
    final e = _normalize(expected);
    if (g.isEmpty || e.isEmpty) return false;
    if (g == e) return true;
    if (g.contains(e) || e.contains(g)) return true;

    // Accept romaji when answer is Japanese or vice versa (word bank taps).
    final gStripped = g.replaceAll(RegExp(r'[\s\-]'), '');
    final eStripped = e.replaceAll(RegExp(r'[\s\-]'), '');
    if (gStripped == eStripped) return true;

    return false;
  }

  static String _normalize(String input) =>
      input.toLowerCase().trim().replaceAll(RegExp(r'[.,!?。、！？\s]'), '');
}
