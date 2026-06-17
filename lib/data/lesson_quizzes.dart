import '../models/lesson_models.dart';
import 'course_repository.dart';
import 'expanded_content.dart';

/// Per-lesson quiz bank — each lesson gets unique questions, not the generic default.
class LessonQuizzes {
  LessonQuizzes._();

  static QuizModel forLesson(String lessonId) {
    return _cache[lessonId] ?? _buildQuiz(lessonId);
  }

  static final _cache = <String, QuizModel>{};

  static QuizModel _buildQuiz(String lessonId) {
    final quiz = switch (true) {
      _ when lessonId.startsWith('hira_') => _kanaQuiz(lessonId, 'hiragana'),
      _ when lessonId.startsWith('kata_') => _kanaQuiz(lessonId, 'katakana'),
      _ when lessonId.startsWith('vocab_') =>
        _vocabQuiz(lessonId.replaceFirst('vocab_', '')),
      _ when lessonId.startsWith('gram_') => _grammarQuiz(lessonId),
      _ when lessonId.startsWith('conv_') => _conversationQuiz(lessonId),
      _ when lessonId.startsWith('read_') => _readingQuiz(lessonId),
      _ when lessonId.startsWith('jlpt_') => _jlptQuiz(lessonId),
      _ => _fallbackQuiz(lessonId),
    };
    _cache[lessonId] = quiz;
    return quiz;
  }

  static QuizModel _kanaQuiz(String lessonId, String type) {
    final basic = type == 'hiragana'
        ? CourseRepository.hiraganaCharacters
        : CourseRepository.katakanaCharacters;
    final chars = ExpandedContent.kanaForLesson(lessonId, basic);
    final questions = <QuizQuestion>[];
    final step = (chars.length / 5).ceil().clamp(1, chars.length);

    for (var i = 0; i < 5; i++) {
      final idx = (i * step).clamp(0, chars.length - 1);
      final target = chars[idx];
      questions.add(QuizQuestion(
        id: '${lessonId}_q$i',
        type: QuestionType.multipleChoice,
        question: 'What is the romaji for ${target.character}?',
        correctAnswer: target.romaji,
        options: _romajiOptions(target.romaji, chars),
        explanation: '${target.character} = ${target.romaji}',
      ));
    }

    if (chars.length >= 4) {
      final matchChars = chars.take(4).toList();
      questions.add(QuizQuestion(
        id: '${lessonId}_match',
        type: QuestionType.matchWord,
        question: 'Match each character to its romaji',
        correctAnswer: 'matched',
        matchPairs: {
          for (final c in matchChars) c.character: c.romaji,
        },
      ));
    }

    if (lessonId.endsWith('_quiz')) {
      questions.add(QuizQuestion(
        id: '${lessonId}_listen',
        type: QuestionType.listening,
        question: 'Listen: Which character is this? (さ)',
        correctAnswer: 'sa',
        options: ['sa', 'shi', 'su', 'ta'],
        explanation: 'さ (sa) — hiragana "sa" sound.',
      ));
    }

    return QuizModel(
      id: 'quiz_$lessonId',
      lessonId: lessonId,
      title: 'Kana Quiz',
      questions: questions,
    );
  }

  static QuizModel _vocabQuiz(String category) {
    final words = CourseRepository.vocabularyByCategory(category);
    if (words.isEmpty) return _fallbackQuiz('vocab_$category');

    final questions = words.take(5).map((w) {
      final wrong = words.where((x) => x.english != w.english).toList();
      wrong.shuffle();
      return QuizQuestion(
        id: 'vq_${w.japanese}',
        type: QuestionType.multipleChoice,
        question: 'What does ${w.japanese} (${w.romaji}) mean?',
        correctAnswer: w.english,
        options: [w.english, ...wrong.take(3).map((x) => x.english)]..shuffle(),
        explanation: '${w.japanese} — ${w.english}',
      );
    }).toList();

    if (words.length >= 4) {
      final matchWords = words.take(4).toList();
      questions.add(QuizQuestion(
        id: 'vq_match_$category',
        type: QuestionType.matchWord,
        question: 'Match each Japanese word to its meaning',
        correctAnswer: 'matched',
        matchPairs: {
          for (final w in matchWords) w.japanese: w.english,
        },
      ));
    }

    if (questions.length < 6 && words.length >= 2) {
      questions.add(QuizQuestion(
        id: 'vq_listen_$category',
        type: QuestionType.listening,
        question: 'Listen: ${words.first.japanese}',
        correctAnswer: words.first.english,
        options: [
          words.first.english,
          ...words.skip(1).take(3).map((w) => w.english),
        ]..shuffle(),
      ));
    }

    return QuizModel(
      id: 'quiz_vocab_$category',
      lessonId: 'vocab_$category',
      title: '${category[0].toUpperCase()}${category.substring(1)} Quiz',
      questions: questions,
    );
  }

  static QuizModel _grammarQuiz(String lessonId) {
    final topic = ExpandedContent.grammarTopics[lessonId];
    final title = topic?.$1 ?? 'Grammar';
    final questions = switch (lessonId) {
      'gram_particles' => [
        const QuizQuestion(
          id: 'gp1',
          type: QuestionType.fillInBlank,
          question: '私___ 学生です。(I am a student)',
          correctAnswer: 'は',
          options: ['は', 'を', 'に', 'で'],
          explanation: 'は marks the topic.',
        ),
        const QuizQuestion(
          id: 'gp2',
          type: QuestionType.multipleChoice,
          question: 'Which particle marks the direct object?',
          correctAnswer: 'を',
          options: ['は', 'を', 'の', 'か'],
        ),
        const QuizQuestion(
          id: 'gp3',
          type: QuestionType.multipleChoice,
          question: '学校___ 行きます (go to school)',
          correctAnswer: 'に',
          options: ['に', 'で', 'を', 'は'],
          explanation: 'に marks direction.',
        ),
      ],
      'gram_verbs' => [
        const QuizQuestion(
          id: 'gv1',
          type: QuestionType.multipleChoice,
          question: 'Polite form of 食べる (taberu)?',
          correctAnswer: '食べます',
          options: ['食べます', '食べる', '食べた', '食べない'],
        ),
        const QuizQuestion(
          id: 'gv2',
          type: QuestionType.multipleChoice,
          question: 'Which is an irregular verb?',
          correctAnswer: 'する',
          options: ['行く', '食べる', 'する', '書く'],
        ),
      ],
      'gram_adjectives' => [
        const QuizQuestion(
          id: 'ga1',
          type: QuestionType.multipleChoice,
          question: 'Which is an い-adjective?',
          correctAnswer: '高い',
          options: ['高い', '静か', 'きれい', '元気'],
        ),
        const QuizQuestion(
          id: 'ga2',
          type: QuestionType.multipleChoice,
          question: 'Past tense of 高い (takai)?',
          correctAnswer: '高かった',
          options: ['高かった', '高い', '高く', '高いでした'],
        ),
      ],
      'gram_questions' => [
        const QuizQuestion(
          id: 'gq1',
          type: QuestionType.multipleChoice,
          question: 'How do you turn a statement into a question?',
          correctAnswer: 'Add か',
          options: ['Add か', 'Add ね', 'Add の', 'Add よ'],
        ),
        const QuizQuestion(
          id: 'gq2',
          type: QuestionType.multipleChoice,
          question: 'What does どこ mean?',
          correctAnswer: 'Where',
          options: ['What', 'Where', 'When', 'Who'],
        ),
      ],
      'gram_tenses' => [
        const QuizQuestion(
          id: 'gt1',
          type: QuestionType.multipleChoice,
          question: 'Past polite form of 食べます?',
          correctAnswer: '食べました',
          options: ['食べました', '食べます', '食べません', '食べる'],
        ),
        const QuizQuestion(
          id: 'gt2',
          type: QuestionType.multipleChoice,
          question: 'Negative polite form of 行きます?',
          correctAnswer: '行きません',
          options: ['行きません', '行きました', '行かない', '行きます'],
        ),
      ],
      _ => [
        const QuizQuestion(
          id: 'gs1',
          type: QuestionType.multipleChoice,
          question: 'Japanese word order is…',
          correctAnswer: 'Subject-Object-Verb',
          options: ['Subject-Verb-Object', 'Subject-Object-Verb', 'Verb-Subject-Object', 'Object-Subject-Verb'],
        ),
        const QuizQuestion(
          id: 'gs2',
          type: QuestionType.fillInBlank,
          question: '私は本___ 読みます。(I read a book)',
          correctAnswer: 'を',
          options: ['を', 'は', 'に', 'で'],
        ),
      ],
    };

    return QuizModel(
      id: 'quiz_$lessonId',
      lessonId: lessonId,
      title: '$title Quiz',
      questions: questions,
    );
  }

  static QuizModel _conversationQuiz(String lessonId) {
    final phrases = ExpandedContent.conversationPhrases[lessonId] ?? [];
    if (phrases.isEmpty) return _fallbackQuiz(lessonId);

    final questions = phrases.take(4).map((p) {
      final others = phrases.where((x) => x.$3 != p.$3).toList()..shuffle();
      return QuizQuestion(
        id: 'cq_${p.$1}',
        type: QuestionType.multipleChoice,
        question: 'What does "${p.$1}" mean?',
        correctAnswer: p.$3,
        options: [p.$3, ...others.take(3).map((x) => x.$3)]..shuffle(),
        explanation: '${p.$2} — ${p.$3}',
      );
    }).toList();

    questions.add(QuizQuestion(
      id: 'cq_listen_$lessonId',
      type: QuestionType.listening,
      question: 'Listen: ${phrases.first.$1}',
      correctAnswer: phrases.first.$3,
      options: [
        phrases.first.$3,
        ...phrases.skip(1).take(3).map((p) => p.$3),
      ]..shuffle(),
    ));

    return QuizModel(
      id: 'quiz_$lessonId',
      lessonId: lessonId,
      title: 'Conversation Quiz',
      questions: questions,
    );
  }

  static QuizModel _readingQuiz(String lessonId) {
    final passage = ExpandedContent.readingPassages[lessonId];
    final questions = switch (lessonId) {
      'read_kanji' => [
        const QuizQuestion(
          id: 'rk1',
          type: QuestionType.multipleChoice,
          question: 'What does 日 mean?',
          correctAnswer: 'Day / Sun',
          options: ['Day / Sun', 'Month', 'Fire', 'Water'],
        ),
        const QuizQuestion(
          id: 'rk2',
          type: QuestionType.multipleChoice,
          question: 'What does 人 mean?',
          correctAnswer: 'Person',
          options: ['Person', 'Tree', 'Big', 'School'],
        ),
        const QuizQuestion(
          id: 'rk_draw_1',
          type: QuestionType.kanjiDraw,
          question: 'Draw the Kanji for "Day / Sun"',
          correctAnswer: '日',
        ),
        const QuizQuestion(
          id: 'rk_draw_2',
          type: QuestionType.kanjiDraw,
          question: 'Draw the Kanji for "Person"',
          correctAnswer: '人',
        ),
        const QuizQuestion(
          id: 'rk3',
          type: QuestionType.multipleChoice,
          question: '学校 (gakkou) means…',
          correctAnswer: 'School',
          options: ['School', 'Student', 'Teacher', 'Book'],
        ),
      ],
      'read_passages' || 'read_comprehension' => [
        QuizQuestion(
          id: 'rp1',
          type: QuestionType.multipleChoice,
          question: 'This passage is about…',
          correctAnswer: passage?.$1 ?? 'Daily life',
          options: [passage?.$1 ?? 'Daily life', 'Shopping', 'Travel', 'Cooking'],
        ),
        const QuizQuestion(
          id: 'rp2',
          type: QuestionType.multipleChoice,
          question: '私 means…',
          correctAnswer: 'I / me',
          options: ['I / me', 'You', 'They', 'We'],
        ),
      ],
      _ => [
        const QuizQuestion(
          id: 'rw1',
          type: QuestionType.multipleChoice,
          question: 'When writing about yourself, start with…',
          correctAnswer: '私は',
          options: ['私は', 'あなたは', '彼は', '彼女は'],
        ),
      ],
    };

    return QuizModel(
      id: 'quiz_$lessonId',
      lessonId: lessonId,
      title: 'Reading Quiz',
      questions: questions,
    );
  }

  static QuizModel _jlptQuiz(String lessonId) {
    final questions = switch (lessonId) {
      'jlpt_vocab' => [
        const QuizQuestion(
          id: 'jv1',
          type: QuestionType.multipleChoice,
          question: 'N5: 猫 means…',
          correctAnswer: 'Cat',
          options: ['Cat', 'Dog', 'Bird', 'Fish'],
        ),
        const QuizQuestion(
          id: 'jv2',
          type: QuestionType.multipleChoice,
          question: 'N5: 本 means…',
          correctAnswer: 'Book',
          options: ['Book', 'Pen', 'Desk', 'Door'],
        ),
        const QuizQuestion(
          id: 'jv3',
          type: QuestionType.multipleChoice,
          question: 'N5: 水 means…',
          correctAnswer: 'Water',
          options: ['Water', 'Rice', 'Bread', 'Meat'],
        ),
      ],
      'jlpt_grammar' => [
        const QuizQuestion(
          id: 'jg1',
          type: QuestionType.fillInBlank,
          question: 'N5: 私___ 田中です',
          correctAnswer: 'は',
          options: ['は', 'を', 'に', 'で'],
        ),
        const QuizQuestion(
          id: 'jg2',
          type: QuestionType.multipleChoice,
          question: 'N5 polite verb ending?',
          correctAnswer: 'ます',
          options: ['ます', 'る', 'た', 'ない'],
        ),
      ],
      'jlpt_timed' => [
        for (var i = 0; i < 5; i++)
          QuizQuestion(
            id: 'jt$i',
            type: QuestionType.multipleChoice,
            question: 'Quick! ${['一', '二', '三', '猫', '本'][i]} means?',
            correctAnswer: ['One', 'Two', 'Three', 'Cat', 'Book'][i],
            options: _quickOptions(['One', 'Two', 'Three', 'Cat', 'Book'][i]),
          ),
      ],
      _ => [
        const QuizQuestion(
          id: 'jp1',
          type: QuestionType.multipleChoice,
          question: 'JLPT N5 tests which level?',
          correctAnswer: 'Beginner',
          options: ['Beginner', 'Intermediate', 'Advanced', 'Native'],
        ),
        const QuizQuestion(
          id: 'jp2',
          type: QuestionType.multipleChoice,
          question: 'Passing score on NekoSensei exams?',
          correctAnswer: '70%',
          options: ['50%', '60%', '70%', '90%'],
        ),
      ],
    };

    return QuizModel(
      id: 'quiz_$lessonId',
      lessonId: lessonId,
      title: 'JLPT Quiz',
      passingScore: lessonId == 'jlpt_timed' ? 80 : 70,
      questions: questions,
    );
  }

  static List<String> _romajiOptions(String correct, List<KanaCharacter> pool) {
    final all = pool.map((c) => c.romaji).toSet().toList();
    all.remove(correct);
    all.shuffle();
    return [correct, ...all.take(3)]..shuffle();
  }

  static List<String> _quickOptions(String correct) {
    const pool = ['One', 'Two', 'Three', 'Cat', 'Book', 'Dog', 'Water', 'Hello'];
    final opts = pool.where((o) => o != correct).toList()..shuffle();
    return [correct, ...opts.take(3)]..shuffle();
  }

  static QuizModel _fallbackQuiz(String lessonId) {
    return QuizModel(
      id: 'quiz_$lessonId',
      lessonId: lessonId,
      title: 'Lesson Quiz',
      questions: const [
        QuizQuestion(
          id: 'q1',
          type: QuestionType.multipleChoice,
          question: 'What does こんにちは mean?',
          correctAnswer: 'Hello',
          options: ['Goodbye', 'Hello', 'Thank you', 'Sorry'],
          explanation: 'こんにちは (konnichiwa) means Hello.',
        ),
        QuizQuestion(
          id: 'q2',
          type: QuestionType.multipleChoice,
          question: 'Which script is used for native Japanese words?',
          correctAnswer: 'Hiragana',
          options: ['Kanji', 'Hiragana', 'Katakana', 'Romaji'],
          explanation: 'Hiragana is used for native Japanese words and grammar.',
        ),
        QuizQuestion(
          id: 'q3',
          type: QuestionType.fillInBlank,
          question: 'Fill in: 私___ 学生です。(I am a student)',
          correctAnswer: 'は',
          options: ['は', 'を', 'に', 'で'],
          explanation: 'は (wa) is the topic particle.',
        ),
        QuizQuestion(
          id: 'q4',
          type: QuestionType.listening,
          question: 'Listen: What greeting is this? (こんにちは)',
          correctAnswer: 'Hello',
          options: ['Good morning', 'Hello', 'Good night', 'Goodbye'],
          explanation: 'こんにちは (konnichiwa) — Hello (daytime).',
        ),
        QuizQuestion(
          id: 'q5',
          type: QuestionType.multipleChoice,
          question: 'How do you say "Thank you" politely?',
          correctAnswer: 'ありがとうございます',
          options: ['さようなら', 'ありがとうございます', 'すみません', 'おはよう'],
          explanation: 'ありがとうございます — Thank you very much.',
        ),
      ],
    );
  }
}
