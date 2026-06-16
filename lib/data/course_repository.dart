import '../models/lesson_models.dart';
import 'expanded_vocabulary.dart';

class CourseRepository {
  static const modules = [
    ModuleModel(
      id: 'hiragana',
      title: 'Hiragana',
      description: 'Master all 46 Hiragana characters with pronunciation and writing practice.',
      order: 1,
      iconName: 'あ',
      color: 0xFFE53935,
      lessonIds: ['hira_basic', 'hira_dakuten', 'hira_combo', 'hira_quiz'],
    ),
    ModuleModel(
      id: 'katakana',
      title: 'Katakana',
      description: 'Learn Katakana used for foreign words and emphasis.',
      order: 2,
      iconName: 'ア',
      color: 0xFF1565C0,
      lessonIds: ['kata_basic', 'kata_dakuten', 'kata_combo', 'kata_quiz'],
    ),
    ModuleModel(
      id: 'vocabulary',
      title: 'Basic Vocabulary',
      description: 'Essential words for daily life — numbers, colors, family, and more.',
      order: 3,
      iconName: '語',
      color: 0xFFFFB300,
      lessonIds: [
        'vocab_numbers',
        'vocab_colors',
        'vocab_family',
        'vocab_food',
        'vocab_animals',
        'vocab_time',
        'vocab_objects',
      ],
    ),
    ModuleModel(
      id: 'grammar',
      title: 'Grammar',
      description: 'Sentence structure, particles, verbs, adjectives, and tenses.',
      order: 4,
      iconName: '文',
      color: 0xFF58CC02,
      lessonIds: [
        'gram_structure',
        'gram_particles',
        'gram_verbs',
        'gram_adjectives',
        'gram_questions',
        'gram_tenses',
      ],
    ),
    ModuleModel(
      id: 'conversations',
      title: 'Conversations',
      description: 'Real-world dialogues for greetings, shopping, travel, and daily life.',
      order: 5,
      iconName: '話',
      color: 0xFFFF9600,
      lessonIds: [
        'conv_greetings',
        'conv_intro',
        'conv_shopping',
        'conv_restaurant',
        'conv_travel',
        'conv_daily',
      ],
    ),
    ModuleModel(
      id: 'reading_writing',
      title: 'Reading & Writing',
      description: 'Short passages, comprehension, writing exercises, and basic Kanji.',
      order: 6,
      iconName: '読',
      color: 0xFFCE82FF,
      lessonIds: ['read_passages', 'read_comprehension', 'read_writing', 'read_kanji'],
    ),
    ModuleModel(
      id: 'jlpt_prep',
      title: 'JLPT N5 Preparation',
      description: 'Practice tests, vocabulary review, grammar review, and timed quizzes.',
      order: 7,
      iconName: '試',
      color: 0xFFFF4B4B,
      lessonIds: ['jlpt_vocab', 'jlpt_grammar', 'jlpt_practice', 'jlpt_timed'],
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
    const VocabularyItem(
      japanese: '二',
      romaji: 'ni',
      english: 'Two',
      category: 'numbers',
      kanji: '二',
    ),
    const VocabularyItem(
      japanese: '三',
      romaji: 'san',
      english: 'Three',
      category: 'numbers',
      kanji: '三',
    ),
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
    const VocabularyItem(
      japanese: '青',
      romaji: 'ao',
      english: 'Blue',
      category: 'colors',
      kanji: '青',
    ),
    const VocabularyItem(
      japanese: '白',
      romaji: 'shiro',
      english: 'White',
      category: 'colors',
      kanji: '白',
    ),
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
    const VocabularyItem(
      japanese: '母',
      romaji: 'haha',
      english: 'Mother (my)',
      category: 'family',
      kanji: '母',
    ),
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
    const VocabularyItem(
      japanese: '水',
      romaji: 'mizu',
      english: 'Water',
      category: 'food',
      kanji: '水',
    ),
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
    const VocabularyItem(
      japanese: '犬',
      romaji: 'inu',
      english: 'Dog',
      category: 'animals',
      kanji: '犬',
    ),
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
    const VocabularyItem(
      japanese: '一月',
      romaji: 'ichigatsu',
      english: 'January',
      category: 'time',
    ),
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
    const VocabularyItem(
      japanese: '机',
      romaji: 'tsukue',
      english: 'Desk',
      category: 'objects',
      kanji: '机',
    ),
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
  ];

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

  static final _allLessons = <LessonModel>[
    // Hiragana
    const LessonModel(
      id: 'hira_basic',
      moduleId: 'hiragana',
      title: 'Basic Hiragana',
      description: 'Learn あ-row through た-row characters.',
      order: 1,
    ),
    const LessonModel(
      id: 'hira_dakuten',
      moduleId: 'hiragana',
      title: 'Dakuten & Handakuten',
      description: 'Voiced and semi-voiced Hiragana characters.',
      order: 2,
    ),
    const LessonModel(
      id: 'hira_combo',
      moduleId: 'hiragana',
      title: 'Combination Characters',
      description: 'や, ゆ, よ combination sounds.',
      order: 3,
    ),
    const LessonModel(
      id: 'hira_quiz',
      moduleId: 'hiragana',
      title: 'Hiragana Mastery Quiz',
      description: 'Test your Hiragana knowledge.',
      order: 4,
    ),
    // Katakana
    const LessonModel(
      id: 'kata_basic',
      moduleId: 'katakana',
      title: 'Basic Katakana',
      description: 'Learn ア-row through タ-row characters.',
      order: 1,
    ),
    const LessonModel(
      id: 'kata_dakuten',
      moduleId: 'katakana',
      title: 'Katakana Dakuten',
      description: 'Voiced Katakana characters.',
      order: 2,
    ),
    const LessonModel(
      id: 'kata_combo',
      moduleId: 'katakana',
      title: 'Katakana Combinations',
      description: 'Combination Katakana sounds.',
      order: 3,
    ),
    const LessonModel(
      id: 'kata_quiz',
      moduleId: 'katakana',
      title: 'Katakana Mastery Quiz',
      description: 'Test your Katakana knowledge.',
      order: 4,
    ),
    // Vocabulary lessons
    for (final cat in vocabularyCategories)
      LessonModel(
        id: 'vocab_${cat.$1}',
        moduleId: 'vocabulary',
        title: cat.$2,
        description: 'Learn essential ${cat.$2.toLowerCase()} vocabulary.',
        order: vocabularyCategories.indexOf(cat) + 1,
      ),
    // Grammar
    const LessonModel(
      id: 'gram_structure',
      moduleId: 'grammar',
      title: 'Sentence Structure',
      description: 'SOV word order and basic sentence patterns.',
      order: 1,
    ),
    const LessonModel(
      id: 'gram_particles',
      moduleId: 'grammar',
      title: 'Particles',
      description: 'は, を, に, で, が and more.',
      order: 2,
    ),
    const LessonModel(
      id: 'gram_verbs',
      moduleId: 'grammar',
      title: 'Verbs',
      description: 'Verb groups and conjugation basics.',
      order: 3,
    ),
    const LessonModel(
      id: 'gram_adjectives',
      moduleId: 'grammar',
      title: 'Adjectives',
      description: 'い-adjectives and な-adjectives.',
      order: 4,
    ),
    const LessonModel(
      id: 'gram_questions',
      moduleId: 'grammar',
      title: 'Questions',
      description: 'Forming questions with か and question words.',
      order: 5,
    ),
    const LessonModel(
      id: 'gram_tenses',
      moduleId: 'grammar',
      title: 'Tenses',
      description: 'Present, past, and future expressions.',
      order: 6,
    ),
    // Conversations
    const LessonModel(
      id: 'conv_greetings',
      moduleId: 'conversations',
      title: 'Greetings',
      description: 'Essential Japanese greetings and responses.',
      order: 1,
    ),
    const LessonModel(
      id: 'conv_intro',
      moduleId: 'conversations',
      title: 'Self Introduction',
      description: 'Introduce yourself in Japanese.',
      order: 2,
    ),
    const LessonModel(
      id: 'conv_shopping',
      moduleId: 'conversations',
      title: 'Shopping',
      description: 'Buy items and ask about prices.',
      order: 3,
    ),
    const LessonModel(
      id: 'conv_restaurant',
      moduleId: 'conversations',
      title: 'Restaurant',
      description: 'Order food and interact with staff.',
      order: 4,
    ),
    const LessonModel(
      id: 'conv_travel',
      moduleId: 'conversations',
      title: 'Travel',
      description: 'Navigate stations, hotels, and directions.',
      order: 5,
    ),
    const LessonModel(
      id: 'conv_daily',
      moduleId: 'conversations',
      title: 'Daily Conversations',
      description: 'Common everyday expressions.',
      order: 6,
    ),
    // Reading & Writing
    const LessonModel(
      id: 'read_passages',
      moduleId: 'reading_writing',
      title: 'Short Passages',
      description: 'Read simple Japanese paragraphs.',
      order: 1,
    ),
    const LessonModel(
      id: 'read_comprehension',
      moduleId: 'reading_writing',
      title: 'Comprehension',
      description: 'Answer questions about what you read.',
      order: 2,
    ),
    const LessonModel(
      id: 'read_writing',
      moduleId: 'reading_writing',
      title: 'Writing Exercises',
      description: 'Practice writing sentences and paragraphs.',
      order: 3,
    ),
    const LessonModel(
      id: 'read_kanji',
      moduleId: 'reading_writing',
      title: 'Basic Kanji',
      description: 'Introduction to essential N5 Kanji.',
      order: 4,
    ),
    // JLPT Prep
    const LessonModel(
      id: 'jlpt_vocab',
      moduleId: 'jlpt_prep',
      title: 'Vocabulary Review',
      description: 'Review all N5 vocabulary.',
      order: 1,
    ),
    const LessonModel(
      id: 'jlpt_grammar',
      moduleId: 'jlpt_prep',
      title: 'Grammar Review',
      description: 'Review all N5 grammar points.',
      order: 2,
    ),
    const LessonModel(
      id: 'jlpt_practice',
      moduleId: 'jlpt_prep',
      title: 'Practice Tests',
      description: 'Full-length practice exams.',
      order: 3,
    ),
    const LessonModel(
      id: 'jlpt_timed',
      moduleId: 'jlpt_prep',
      title: 'Timed Quizzes',
      description: 'Speed drills under time pressure.',
      order: 4,
      estimatedMinutes: 15,
    ),
  ];
}
