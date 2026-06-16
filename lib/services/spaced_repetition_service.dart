import 'package:shared_preferences/shared_preferences.dart';
import '../data/course_repository.dart';
import '../models/lesson_models.dart';

/// Spaced repetition — surfaces weak items for quick review (beats passive apps).
class SpacedRepetitionService {
  static const _prefix = 'srs_';

  Future<void> recordReview(String itemId, bool correct) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_prefix$itemId';
    final data = prefs.getString(key);
    var ease = 2.5;
    var interval = 1;
    var reps = 0;

    if (data != null) {
      final parts = data.split('|');
      ease = double.tryParse(parts[0]) ?? 2.5;
      interval = int.tryParse(parts[1]) ?? 1;
      reps = int.tryParse(parts[2]) ?? 0;
    }

    if (correct) {
      reps++;
      interval = reps == 1 ? 1 : reps == 2 ? 3 : (interval * ease).round();
      ease = (ease + 0.1).clamp(1.3, 3.0);
    } else {
      reps = 0;
      interval = 1;
      ease = (ease - 0.2).clamp(1.3, 3.0);
    }

    final nextReview = DateTime.now().add(Duration(days: interval));
    await prefs.setString(
      key,
      '$ease|$interval|$reps|${nextReview.toIso8601String()}',
    );
  }

  Future<List<ReviewItem>> getDueItems({int limit = 10}) async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final items = <ReviewItem>[];

    for (final v in CourseRepository.vocabulary) {
      final key = '$_prefix${v.japanese}';
      final data = prefs.getString(key);
      var due = true;

      if (data != null) {
        final parts = data.split('|');
        if (parts.length >= 4) {
          final next = DateTime.tryParse(parts[3]);
          due = next == null || !next.isAfter(now);
        }
      }

      if (due) {
        items.add(ReviewItem(
          id: v.japanese,
          japanese: v.japanese,
          romaji: v.romaji,
          english: v.english,
          type: ReviewItemType.vocabulary,
        ));
      }
    }

    for (final k in CourseRepository.hiraganaCharacters.take(20)) {
      items.add(ReviewItem(
        id: 'hira_${k.character}',
        japanese: k.character,
        romaji: k.romaji,
        english: k.romaji,
        type: ReviewItemType.kana,
      ));
    }

    return items.take(limit).toList();
  }
}

enum ReviewItemType { vocabulary, kana, phrase }

class ReviewItem {
  const ReviewItem({
    required this.id,
    required this.japanese,
    required this.romaji,
    required this.english,
    required this.type,
  });

  final String id;
  final String japanese;
  final String romaji;
  final String english;
  final ReviewItemType type;
}
