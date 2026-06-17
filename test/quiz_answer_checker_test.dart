import 'package:flutter_test/flutter_test.dart';
import 'package:nihongo_master/utils/quiz_answer_checker.dart';

void main() {
  group('QuizAnswerChecker', () {
    test('matches exact answers', () {
      expect(QuizAnswerChecker.isCorrect('は', 'は'), isTrue);
      expect(QuizAnswerChecker.isCorrect('Hello', 'Hello'), isTrue);
    });

    test('ignores case and punctuation', () {
      expect(QuizAnswerChecker.isCorrect('hello!', 'Hello'), isTrue);
      expect(QuizAnswerChecker.isCorrect('は。', 'は'), isTrue);
    });

    test('rejects wrong answers', () {
      expect(QuizAnswerChecker.isCorrect('を', 'は'), isFalse);
      expect(QuizAnswerChecker.isCorrect('', 'は'), isFalse);
    });
  });
}
