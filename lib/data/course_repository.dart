import '../models/lesson_models.dart';
import 'expanded_vocabulary.dart';
import 'n5_vocabulary.dart';
import 'massive_n5_vocabulary.dart';
import 'n4_vocabulary.dart';
import 'n3_vocabulary.dart';
import 'n2_vocabulary.dart';
import 'n1_vocabulary.dart';

class CourseRepository {
  static const modules = [
    ModuleModel(
      id: 'n5_foundations',
      title: 'N5: Foundations',
      description: 'Hiragana, Katakana, and essential basics.',
      order: 1,
      iconName: 'あ',
      color: 0xFFFF5252,
      lessonIds: [],
    ),
    ModuleModel(
      id: 'n5_vocabulary',
      title: 'N5: Vocabulary',
      description: '800 essential words for daily life.',
      order: 2,
      iconName: '語',
      color: 0xFFFF7043,
      lessonIds: [],
    ),
    ModuleModel(
      id: 'n5_kanji',
      title: 'N5: Kanji',
      description: '100 basic Kanji characters.',
      order: 3,
      iconName: '漢',
      color: 0xFFFFAB00,
      lessonIds: [],
    ),
    ModuleModel(
      id: 'n5_grammar',
      title: 'N5: Grammar',
      description: '80 essential grammar points.',
      order: 4,
      iconName: '文',
      color: 0xFF58CC02,
      lessonIds: [],
    ),
    ModuleModel(
      id: 'n5_practice',
      title: 'N5: Practice & Review',
      description: 'Quizzes, tests, and JLPT prep.',
      order: 5,
      iconName: '試',
      color: 0xFF2962FF,
      lessonIds: [],
    ),
    ModuleModel(
      id: 'n4_vocabulary',
      title: 'N4: Vocabulary',
      description: '1,000 new words for everyday conversations.',
      order: 6,
      iconName: '語',
      color: 0xFF1565C0,
      lessonIds: [],
    ),
    ModuleModel(
      id: 'n4_kanji',
      title: 'N4: Kanji',
      description: '200 new Kanji characters.',
      order: 7,
      iconName: '漢',
      color: 0xFF00BCD4,
      lessonIds: [],
    ),
    ModuleModel(
      id: 'n4_grammar',
      title: 'N4: Grammar',
      description: '120 intermediate grammar points.',
      order: 8,
      iconName: '文',
      color: 0xFF009688,
      lessonIds: [],
    ),
    ModuleModel(
      id: 'n4_practice',
      title: 'N4: Practice & Review',
      description: 'N4 JLPT preparation.',
      order: 9,
      iconName: '試',
      color: 0xFF4CAF50,
      lessonIds: [],
    ),
    ModuleModel(
      id: 'n3_vocabulary',
      title: 'N3: Vocabulary',
      description: '2,000 new words for natural Japanese.',
      order: 10,
      iconName: '語',
      color: 0xFF8BC34A,
      lessonIds: [],
    ),
    ModuleModel(
      id: 'n3_kanji',
      title: 'N3: Kanji',
      description: '350 intermediate Kanji.',
      order: 11,
      iconName: '漢',
      color: 0xFFCDDC39,
      lessonIds: [],
    ),
    ModuleModel(
      id: 'n3_grammar',
      title: 'N3: Grammar',
      description: '180 grammar points for N3.',
      order: 12,
      iconName: '文',
      color: 0xFFFFEB3B,
      lessonIds: [],
    ),
    ModuleModel(
      id: 'n3_practice',
      title: 'N3: Practice & Review',
      description: 'N3 JLPT practice.',
      order: 13,
      iconName: '試',
      color: 0xFFFF9800,
      lessonIds: [],
    ),
    ModuleModel(
      id: 'n2_vocabulary',
      title: 'N2: Vocabulary',
      description: '3,000 words for business & books.',
      order: 14,
      iconName: '語',
      color: 0xFFFF5722,
      lessonIds: [],
    ),
    ModuleModel(
      id: 'n2_kanji',
      title: 'N2: Kanji',
      description: '350 advanced Kanji.',
      order: 15,
      iconName: '漢',
      color: 0xFF795548,
      lessonIds: [],
    ),
    ModuleModel(
      id: 'n2_grammar',
      title: 'N2: Grammar',
      description: '250 upper-intermediate grammar.',
      order: 16,
      iconName: '文',
      color: 0xFF607D8B,
      lessonIds: [],
    ),
    ModuleModel(
      id: 'n2_practice',
      title: 'N2: Practice & Review',
      description: 'N2 JLPT preparation.',
      order: 17,
      iconName: '試',
      color: 0xFF9E9E9E,
      lessonIds: [],
    ),
    ModuleModel(
      id: 'n1_vocabulary',
      title: 'N1: Vocabulary',
      description: '3,000+ words for academic/professional.',
      order: 18,
      iconName: '語',
      color: 0xFF3F51B5,
      lessonIds: [],
    ),
    ModuleModel(
      id: 'n1_kanji',
      title: 'N1: Kanji',
      description: '1,000+ expert-level Kanji.',
      order: 19,
      iconName: '漢',
      color: 0xFF673AB7,
      lessonIds: [],
    ),
    ModuleModel(
      id: 'n1_grammar',
      title: 'N1: Grammar',
      description: '350 advanced grammar points.',
      order: 20,
      iconName: '文',
      color: 0xFFE91E63,
      lessonIds: [],
    ),
    ModuleModel(
      id: 'n1_practice',
      title: 'N1: Practice & Review',
      description: 'N1 JLPT final preparation.',
      order: 21,
      iconName: '試',
      color: 0xFF00BCD4,
      lessonIds: [],
    ),
  ];

  static List<KanaCharacter> get hiraganaCharacters => [
    for (final row in _hiraganaRows)
      for (final item in row)
        KanaCharacter(
          character: item['char']!,
          romaji: item['romaji']!,
          type: 'hiragana',
        ),
  ];

  static List<KanaCharacter> get katakanaCharacters => [
    for (final row in _katakanaRows)
      for (final item in row)
        KanaCharacter(
          character: item['char']!,
          romaji: item['romaji']!,
          type: 'katakana',
        ),
  ];

  static const _hiraganaRows = [
    [
      {'char': 'あ', 'romaji': 'a'},
      {'char': 'い', 'romaji': 'i'},
      {'char': 'う', 'romaji': 'u'},
      {'char': 'え', 'romaji': 'e'},
      {'char': 'お', 'romaji': 'o'},
    ],
    [
      {'char': 'か', 'romaji': 'ka'},
      {'char': 'き', 'romaji': 'ki'},
      {'char': 'く', 'romaji': 'ku'},
      {'char': 'け', 'romaji': 'ke'},
      {'char': 'こ', 'romaji': 'ko'},
    ],
    [
      {'char': 'さ', 'romaji': 'sa'},
      {'char': 'し', 'romaji': 'shi'},
      {'char': 'す', 'romaji': 'su'},
      {'char': 'せ', 'romaji': 'se'},
      {'char': 'そ', 'romaji': 'so'},
    ],
    [
      {'char': 'た', 'romaji': 'ta'},
      {'char': 'ち', 'romaji': 'chi'},
      {'char': 'つ', 'romaji': 'tsu'},
      {'char': 'て', 'romaji': 'te'},
      {'char': 'と', 'romaji': 'to'},
    ],
    [
      {'char': 'な', 'romaji': 'na'},
      {'char': 'に', 'romaji': 'ni'},
      {'char': 'ぬ', 'romaji': 'nu'},
      {'char': 'ね', 'romaji': 'ne'},
      {'char': 'の', 'romaji': 'no'},
    ],
    [
      {'char': 'は', 'romaji': 'ha'},
      {'char': 'ひ', 'romaji': 'hi'},
      {'char': 'ふ', 'romaji': 'fu'},
      {'char': 'へ', 'romaji': 'he'},
      {'char': 'ほ', 'romaji': 'ho'},
    ],
    [
      {'char': 'ま', 'romaji': 'ma'},
      {'char': 'み', 'romaji': 'mi'},
      {'char': 'む', 'romaji': 'mu'},
      {'char': 'め', 'romaji': 'me'},
      {'char': 'も', 'romaji': 'mo'},
    ],
    [
      {'char': 'や', 'romaji': 'ya'},
      {'char': 'ゆ', 'romaji': 'yu'},
      {'char': 'よ', 'romaji': 'yo'},
    ],
    [
      {'char': 'ら', 'romaji': 'ra'},
      {'char': 'り', 'romaji': 'ri'},
      {'char': 'る', 'romaji': 'ru'},
      {'char': 'れ', 'romaji': 're'},
      {'char': 'ろ', 'romaji': 'ro'},
    ],
    [
      {'char': 'わ', 'romaji': 'wa'},
      {'char': 'を', 'romaji': 'wo'},
      {'char': 'ん', 'romaji': 'n'},
    ],
  ];

  static const _katakanaRows = [
    [
      {'char': 'ア', 'romaji': 'a'},
      {'char': 'イ', 'romaji': 'i'},
      {'char': 'ウ', 'romaji': 'u'},
      {'char': 'エ', 'romaji': 'e'},
      {'char': 'オ', 'romaji': 'o'},
    ],
    [
      {'char': 'カ', 'romaji': 'ka'},
      {'char': 'キ', 'romaji': 'ki'},
      {'char': 'ク', 'romaji': 'ku'},
      {'char': 'ケ', 'romaji': 'ke'},
      {'char': 'コ', 'romaji': 'ko'},
    ],
    [
      {'char': 'サ', 'romaji': 'sa'},
      {'char': 'シ', 'romaji': 'shi'},
      {'char': 'ス', 'romaji': 'su'},
      {'char': 'セ', 'romaji': 'se'},
      {'char': 'ソ', 'romaji': 'so'},
    ],
    [
      {'char': 'タ', 'romaji': 'ta'},
      {'char': 'チ', 'romaji': 'chi'},
      {'char': 'ツ', 'romaji': 'tsu'},
      {'char': 'テ', 'romaji': 'te'},
      {'char': 'ト', 'romaji': 'to'},
    ],
    [
      {'char': 'ナ', 'romaji': 'na'},
      {'char': 'ニ', 'romaji': 'ni'},
      {'char': 'ヌ', 'romaji': 'nu'},
      {'char': 'ネ', 'romaji': 'ne'},
      {'char': 'ノ', 'romaji': 'no'},
    ],
    [
      {'char': 'ハ', 'romaji': 'ha'},
      {'char': 'ヒ', 'romaji': 'hi'},
      {'char': 'フ', 'romaji': 'fu'},
      {'char': 'ヘ', 'romaji': 'he'},
      {'char': 'ホ', 'romaji': 'ho'},
    ],
    [
      {'char': 'マ', 'romaji': 'ma'},
      {'char': 'ミ', 'romaji': 'mi'},
      {'char': 'ム', 'romaji': 'mu'},
      {'char': 'メ', 'romaji': 'me'},
      {'char': 'モ', 'romaji': 'mo'},
    ],
    [
      {'char': 'ヤ', 'romaji': 'ya'},
      {'char': 'ユ', 'romaji': 'yu'},
      {'char': 'ヨ', 'romaji': 'yo'},
    ],
    [
      {'char': 'ラ', 'romaji': 'ra'},
      {'char': 'リ', 'romaji': 'ri'},
      {'char': 'ル', 'romaji': 'ru'},
      {'char': 'レ', 'romaji': 're'},
      {'char': 'ロ', 'romaji': 'ro'},
    ],
    [
      {'char': 'ワ', 'romaji': 'wa'},
      {'char': 'ヲ', 'romaji': 'wo'},
      {'char': 'ン', 'romaji': 'n'},
    ],
  ];

  static List<VocabularyItem> get vocabulary => [
    ..._coreVocabulary,
    ...ExpandedVocabulary.extra,
    ...N5Vocabulary.extra,
    ...MassiveN5Vocabulary.words,
    ...N4Vocabulary.words,
    ...N3Vocabulary.words,
    ...N2Vocabulary.words,
    ...N1Vocabulary.words,
  ];

  static const _coreVocabulary = [
    // Numbers
    const VocabularyItem(
      japanese: '一',
      romaji: 'ichi',
      english: 'One',
      category: 'numbers',
      kanji: '一',
      exampleSentence: '一つください。',
      exampleRomaji: 'Hitotsu kudasai.',
      exampleEnglish: 'One please.',
    ),
    const VocabularyItem(japanese: '二', romaji: 'ni', english: 'Two', category: 'numbers', kanji: '二'),
    const VocabularyItem(japanese: '三', romaji: 'san', english: 'Three', category: 'numbers', kanji: '三'),
    // Colors
    const VocabularyItem(
      japanese: '赤',
      romaji: 'aka',
      english: 'Red',
      category: 'colors',
      kanji: '赤',
      exampleSentence: '赤い車です。',
      exampleRomaji: 'Akai kuruma desu.',
      exampleEnglish: 'It is a red car.',
    ),
    const VocabularyItem(japanese: '青', romaji: 'ao', english: 'Blue', category: 'colors', kanji: '青'),
    const VocabularyItem(japanese: '白', romaji: 'shiro', english: 'White', category: 'colors', kanji: '白'),
    // Family
    const VocabularyItem(
      japanese: '父',
      romaji: 'chichi',
      english: 'Father (my)',
      category: 'family',
      kanji: '父',
      exampleSentence: '父は医者です。',
      exampleRomaji: 'Chichi wa isha desu.',
      exampleEnglish: 'My father is a doctor.',
    ),
    const VocabularyItem(japanese: '母', romaji: 'haha', english: 'Mother (my)', category: 'family', kanji: '母'),
    // Food
    const VocabularyItem(
      japanese: 'ご飯',
      romaji: 'gohan',
      english: 'Rice / Meal',
      category: 'food',
      exampleSentence: 'ご飯を食べます。',
      exampleRomaji: 'Gohan wo tabemasu.',
      exampleEnglish: 'I eat rice/a meal.',
    ),
    const VocabularyItem(japanese: '水', romaji: 'mizu', english: 'Water', category: 'food', kanji: '水'),
    // Animals
    const VocabularyItem(
      japanese: '猫',
      romaji: 'neko',
      english: 'Cat',
      category: 'animals',
      kanji: '猫',
      exampleSentence: '猫が好きです。',
      exampleRomaji: 'Neko ga suki desu.',
      exampleEnglish: 'I like cats.',
    ),
    const VocabularyItem(japanese: '犬', romaji: 'inu', english: 'Dog', category: 'animals', kanji: '犬'),
    // Time
    const VocabularyItem(
      japanese: '月曜日',
      romaji: 'getsuyoubi',
      english: 'Monday',
      category: 'time',
      exampleSentence: '月曜日に学校があります。',
      exampleRomaji: 'Getsuyoubi ni gakkou ga arimasu.',
      exampleEnglish: 'There is school on Monday.',
    ),
    const VocabularyItem(japanese: '一月', romaji: 'ichigatsu', english: 'January', category: 'time'),
    // Objects
    const VocabularyItem(
      japanese: '本',
      romaji: 'hon',
      english: 'Book',
      category: 'objects',
      kanji: '本',
      exampleSentence: '本を読みます。',
      exampleRomaji: 'Hon wo yomimasu.',
      exampleEnglish: 'I read a book.',
    ),
    const VocabularyItem(japanese: '机', romaji: 'tsukue', english: 'Desk', category: 'objects', kanji: '机'),
  ];

  static List<VocabularyItem> vocabularyByCategory(String category) =>
      vocabulary.where((v) => v.category == category).toList();

  static const vocabularyCategories = [
    ('numbers', 'Numbers', '123'),
    ('colors', 'Colors', '🎨'),
    ('family', 'Family', '👨‍👩‍👧'),
    ('food', 'Food', '🍱'),
    ('animals', 'Animals', '🐱'),
    ('time', 'Days & Months', '📅'),
    ('objects', 'Common Objects', '📦'),
    ('verbs', 'Verbs', '🏃'),
    ('adjectives', 'Adjectives', '✨'),
    ('places', 'Places', '🏫'),
    ('directions', 'Directions', '🧭'),
    ('general', 'General Vocab', '📝'),
    ('clothing', 'Clothing', '👕'),
    ('transport', 'Transport', '🚃'),
    ('school', 'School', '📚'),
  ];

  static int get totalLessonCount => _allLessons.length;

  static bool isModuleComplete(String moduleId, List<String> completedLessons) {
    final lessons = getLessonsForModule(moduleId);
    if (lessons.isEmpty) return false;
    return lessons.every((l) => completedLessons.contains(l.id));
  }

  static List<String> newlyCompletedModules(List<String> completedLessons) {
    return modules
        .where((m) =>
            isModuleComplete(m.id, completedLessons) &&
            completedLessons.isNotEmpty)
        .map((m) => m.id)
        .toList();
  }

  static List<LessonModel> getLessonsForModule(String moduleId) {
    return _allLessons.where((l) => l.moduleId == moduleId).toList()
      ..sort((a, b) => a.order.compareTo(b.order));
  }

  static LessonModel? getLesson(String lessonId) {
    try {
      return _allLessons.firstWhere((l) => l.id == lessonId);
    } catch (_) {
      return null;
    }
  }

  static ModuleModel? getModule(String moduleId) {
    try {
      return modules.firstWhere((m) => m.id == moduleId);
    } catch (_) {
      return null;
    }
  }

  static final List<LessonModel> _allLessons = [
    // N5: FOUNDATIONS (50 lessons total)
    ...List.generate(10, (i) => LessonModel(id: 'hira_row_${i+1}', moduleId: 'n5_foundations', title: 'Hiragana Row ${i+1}', description: 'Learn row ${i+1} of Hiragana.', order: i+1)),
    ...List.generate(10, (i) => LessonModel(id: 'kata_row_${i+1}', moduleId: 'n5_foundations', title: 'Katakana Row ${i+1}', description: 'Learn row ${i+1} of Katakana.', order: i+11)),
    LessonModel(id: 'hira_dakuten', moduleId: 'n5_foundations', title: 'Dakuten & Handakuten', description: 'Voiced and semi-voiced Hiragana characters.', order: 21),
    LessonModel(id: 'kata_dakuten', moduleId: 'n5_foundations', title: 'Katakana Dakuten', description: 'Voiced Katakana characters.', order: 22),
    ...List.generate(10, (i) => LessonModel(id: 'pronunciation_${i+1}', moduleId: 'n5_foundations', title: 'Pronunciation Lesson ${i+1}', description: 'Master Japanese pronunciation ${i+1}.', order: i+23)),
    ...List.generate(15, (i) => LessonModel(id: 'foundations_conv_${i+1}', moduleId: 'n5_foundations', title: 'Basic Conversation ${i+1}', description: 'Practice basic Japanese conversation ${i+1}.', order: i+33)),
    LessonModel(id: 'hira_quiz', moduleId: 'n5_foundations', title: 'Hiragana Mastery Quiz', description: 'Test your Hiragana knowledge.', order: 48),
    LessonModel(id: 'kata_quiz', moduleId: 'n5_foundations', title: 'Katakana Mastery Quiz', description: 'Test your Katakana knowledge.', order: 49),
    LessonModel(id: 'foundations_final', moduleId: 'n5_foundations', title: 'Foundations Final Quiz', description: 'Test all your foundations knowledge.', order: 50),

    // N5: VOCABULARY (120 lessons total)
    ...List.generate(120, (i) => LessonModel(id: 'n5_vocab_${i+1}', moduleId: 'n5_vocabulary', title: 'N5 Vocabulary ${i+1}', description: 'Learn N5 vocabulary ${i+1}.', order: i+1)),

    // N5: KANJI (100 lessons total)
    ...List.generate(100, (i) => LessonModel(id: 'n5_kanji_${i+1}', moduleId: 'n5_kanji', title: 'N5 Kanji ${i+1}', description: 'Learn N5 Kanji character ${i+1}.', order: i+1)),

    // N5: GRAMMAR (80 lessons total)
    ...List.generate(80, (i) => LessonModel(id: 'n5_gram_${i+1}', moduleId: 'n5_grammar', title: 'N5 Grammar ${i+1}', description: 'Master N5 grammar point ${i+1}.', order: i+1)),

    // N5: PRACTICE & REVIEW (50 lessons total)
    ...List.generate(50, (i) => LessonModel(id: 'n5_practice_${i+1}', moduleId: 'n5_practice', title: 'N5 Practice ${i+1}', description: 'Review and practice N5 content ${i+1}.', order: i+1)),

    // N4: VOCABULARY (120 lessons total)
    ...List.generate(120, (i) => LessonModel(id: 'n4_vocab_${i+1}', moduleId: 'n4_vocabulary', title: 'N4 Vocabulary ${i+1}', description: 'Learn N4 vocabulary ${i+1}.', order: i+1)),

    // N4: KANJI (100 lessons total)
    ...List.generate(100, (i) => LessonModel(id: 'n4_kanji_${i+1}', moduleId: 'n4_kanji', title: 'N4 Kanji ${i+1}', description: 'Learn N4 Kanji character ${i+1}.', order: i+1)),

    // N4: GRAMMAR (120 lessons total)
    ...List.generate(120, (i) => LessonModel(id: 'n4_gram_${i+1}', moduleId: 'n4_grammar', title: 'N4 Grammar ${i+1}', description: 'Master N4 grammar point ${i+1}.', order: i+1)),

    // N4: PRACTICE & REVIEW (50 lessons total)
    ...List.generate(50, (i) => LessonModel(id: 'n4_practice_${i+1}', moduleId: 'n4_practice', title: 'N4 Practice ${i+1}', description: 'Review and practice N4 content ${i+1}.', order: i+1)),

    // N3: VOCABULARY (150 lessons total)
    ...List.generate(150, (i) => LessonModel(id: 'n3_vocab_${i+1}', moduleId: 'n3_vocabulary', title: 'N3 Vocabulary ${i+1}', description: 'Learn N3 vocabulary ${i+1}.', order: i+1)),

    // N3: KANJI (100 lessons total)
    ...List.generate(100, (i) => LessonModel(id: 'n3_kanji_${i+1}', moduleId: 'n3_kanji', title: 'N3 Kanji ${i+1}', description: 'Learn N3 Kanji character ${i+1}.', order: i+1)),

    // N3: GRAMMAR (120 lessons total)
    ...List.generate(120, (i) => LessonModel(id: 'n3_gram_${i+1}', moduleId: 'n3_grammar', title: 'N3 Grammar ${i+1}', description: 'Master N3 grammar point ${i+1}.', order: i+1)),

    // N3: PRACTICE & REVIEW (50 lessons total)
    ...List.generate(50, (i) => LessonModel(id: 'n3_practice_${i+1}', moduleId: 'n3_practice', title: 'N3 Practice ${i+1}', description: 'Review and practice N3 content ${i+1}.', order: i+1)),

    // N2: VOCABULARY (150 lessons total)
    ...List.generate(150, (i) => LessonModel(id: 'n2_vocab_${i+1}', moduleId: 'n2_vocabulary', title: 'N2 Vocabulary ${i+1}', description: 'Learn N2 vocabulary ${i+1}.', order: i+1)),

    // N2: KANJI (100 lessons total)
    ...List.generate(100, (i) => LessonModel(id: 'n2_kanji_${i+1}', moduleId: 'n2_kanji', title: 'N2 Kanji ${i+1}', description: 'Learn N2 Kanji character ${i+1}.', order: i+1)),

    // N2: GRAMMAR (120 lessons total)
    ...List.generate(120, (i) => LessonModel(id: 'n2_gram_${i+1}', moduleId: 'n2_grammar', title: 'N2 Grammar ${i+1}', description: 'Master N2 grammar point ${i+1}.', order: i+1)),

    // N2: PRACTICE & REVIEW (50 lessons total)
    ...List.generate(50, (i) => LessonModel(id: 'n2_practice_${i+1}', moduleId: 'n2_practice', title: 'N2 Practice ${i+1}', description: 'Review and practice N2 content ${i+1}.', order: i+1)),

    // N1: VOCABULARY (150 lessons total)
    ...List.generate(150, (i) => LessonModel(id: 'n1_vocab_${i+1}', moduleId: 'n1_vocabulary', title: 'N1 Vocabulary ${i+1}', description: 'Learn N1 vocabulary ${i+1}.', order: i+1)),

    // N1: KANJI (150 lessons total)
    ...List.generate(150, (i) => LessonModel(id: 'n1_kanji_${i+1}', moduleId: 'n1_kanji', title: 'N1 Kanji ${i+1}', description: 'Learn N1 Kanji character ${i+1}.', order: i+1)),

    // N1: GRAMMAR (120 lessons total)
    ...List.generate(120, (i) => LessonModel(id: 'n1_gram_${i+1}', moduleId: 'n1_grammar', title: 'N1 Grammar ${i+1}', description: 'Master N1 grammar point ${i+1}.', order: i+1)),

    // N1: PRACTICE & REVIEW (50 lessons total)
    ...List.generate(50, (i) => LessonModel(id: 'n1_practice_${i+1}', moduleId: 'n1_practice', title: 'N1 Practice ${i+1}', description: 'Review and practice N1 content ${i+1}.', order: i+1)),
  ];
}
