
import 'lib/data/lesson_quizzes.dart';
import 'lib/data/expanded_content.dart';
import 'lib/data/course_repository.dart';

void main() {
  print('=== hiraganaCharacters: ${CourseRepository.hiraganaCharacters.length}');
  final kanaForLesson = ExpandedContent.kanaForLesson('hira_basic', CourseRepository.hiraganaCharacters);
  print('=== kanaForLesson: ${kanaForLesson.length}');
  final quiz = LessonQuizzes.forLesson('hira_basic');
  print('=== Quiz: ${quiz.questions.length} questions');
  for (final q in quiz.questions) {
    print('Question type: ${q.type}, question: ${q.question}, options: ${q.options}');
  }
}
