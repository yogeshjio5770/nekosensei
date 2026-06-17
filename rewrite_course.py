import os

new_content = """import '../models/lesson_models.dart';
import 'expanded_vocabulary.dart';
import 'n5_vocabulary.dart';
import 'massive_n5_vocabulary.dart';

class CourseRepository {
  static const modules = [
    ModuleModel(
      id: 'unit_1',
      title: 'Unit 1: The Basics',
      description: 'Hiragana, basic numbers, and simple greetings.',
      order: 1,
      iconName: 'あ',
      color: 0xFFE53935,
      lessonIds: [], // Populated dynamically
    ),
    ModuleModel(
      id: 'unit_2',
      title: 'Unit 2: Getting Around',
      description: 'Katakana, places, and basic sentence structures.',
      order: 2,
      iconName: 'ア',
      color: 0xFF1565C0,
      lessonIds: [],
    ),
    ModuleModel(
      id: 'unit_3',
      title: 'Unit 3: Daily Life',
      description: 'Time, food, verbs, and daily conversations.',
      order: 3,
      iconName: '日',
      color: 0xFFFFB300,
      lessonIds: [],
    ),
    ModuleModel(
      id: 'unit_4',
      title: 'Unit 4: Expressing Yourself',
      description: 'Adjectives, shopping, and common objects.',
      order: 4,
      iconName: '話',
      color: 0xFF58CC02,
      lessonIds: [],
    ),
    ModuleModel(
      id: 'unit_5',
      title: 'Unit 5: Sentences & Travel',
      description: 'Particles, tenses, and travel conversations.',
      order: 5,
      iconName: '文',
      color: 0xFFFF9600,
      lessonIds: [],
    ),
    ModuleModel(
      id: 'unit_6',
      title: 'Unit 6: Reading & Kanji',
      description: 'Reading passages, school vocab, and Kanji basics.',
      order: 6,
      iconName: '読',
      color: 0xFFCE82FF,
      lessonIds: [],
    ),
    ModuleModel(
      id: 'unit_7',
      title: 'Unit 7: N5 Mastery',
      description: 'JLPT prep, grammar review, and timed tests.',
      order: 7,
      iconName: '試',
      color: 0xFFFF4B4B,
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
    // UNIT 1: THE BASICS
    const LessonModel(id: 'hira_basic', moduleId: 'unit_1', title: 'Basic Hiragana', description: 'Learn あ-row through た-row characters.', order: 1),
    const LessonModel(id: 'vocab_numbers', moduleId: 'unit_1', title: 'Numbers', description: 'Learn essential numbers vocabulary.', order: 2),
    const LessonModel(id: 'conv_greetings', moduleId: 'unit_1', title: 'Greetings', description: 'Essential Japanese greetings and responses.', order: 3),
    const LessonModel(id: 'hira_dakuten', moduleId: 'unit_1', title: 'Dakuten & Handakuten', description: 'Voiced and semi-voiced Hiragana characters.', order: 4),
    const LessonModel(id: 'gram_structure', moduleId: 'unit_1', title: 'Sentence Structure', description: 'SOV word order and basic sentence patterns.', order: 5),
    const LessonModel(id: 'hira_quiz', moduleId: 'unit_1', title: 'Hiragana Mastery Quiz', description: 'Test your Hiragana knowledge.', order: 6),

    // UNIT 2: GETTING AROUND
    const LessonModel(id: 'kata_basic', moduleId: 'unit_2', title: 'Basic Katakana', description: 'Learn ア-row through タ-row characters.', order: 1),
    const LessonModel(id: 'vocab_places', moduleId: 'unit_2', title: 'Places', description: 'Learn essential places vocabulary.', order: 2),
    const LessonModel(id: 'gram_particles', moduleId: 'unit_2', title: 'Particles', description: 'は, を, に, で, が and more.', order: 3),
    const LessonModel(id: 'vocab_directions', moduleId: 'unit_2', title: 'Directions', description: 'Learn essential directions vocabulary.', order: 4),
    const LessonModel(id: 'kata_dakuten', moduleId: 'unit_2', title: 'Katakana Dakuten', description: 'Voiced Katakana characters.', order: 5),

    // UNIT 3: DAILY LIFE
    const LessonModel(id: 'vocab_food', moduleId: 'unit_3', title: 'Food', description: 'Learn essential food vocabulary.', order: 1),
    const LessonModel(id: 'vocab_time', moduleId: 'unit_3', title: 'Days & Months', description: 'Learn essential days & months vocabulary.', order: 2),
    const LessonModel(id: 'gram_verbs', moduleId: 'unit_3', title: 'Verbs', description: 'Verb groups and conjugation basics.', order: 3),
    const LessonModel(id: 'vocab_verbs', moduleId: 'unit_3', title: 'Action Verbs', description: 'Learn essential verbs vocabulary.', order: 4),
    const LessonModel(id: 'conv_daily', moduleId: 'unit_3', title: 'Daily Conversations', description: 'Common everyday expressions.', order: 5),

    // UNIT 4: EXPRESSING YOURSELF
    const LessonModel(id: 'vocab_adjectives', moduleId: 'unit_4', title: 'Adjectives', description: 'Learn essential adjectives vocabulary.', order: 1),
    const LessonModel(id: 'gram_adjectives', moduleId: 'unit_4', title: 'Adjective Grammar', description: 'い-adjectives and な-adjectives.', order: 2),
    const LessonModel(id: 'vocab_colors', moduleId: 'unit_4', title: 'Colors', description: 'Learn essential colors vocabulary.', order: 3),
    const LessonModel(id: 'vocab_objects', moduleId: 'unit_4', title: 'Common Objects', description: 'Learn essential common objects vocabulary.', order: 4),
    const LessonModel(id: 'conv_shopping', moduleId: 'unit_4', title: 'Shopping', description: 'Buy items and ask about prices.', order: 5),

    // UNIT 5: SENTENCES & TRAVEL
    const LessonModel(id: 'gram_questions', moduleId: 'unit_5', title: 'Questions', description: 'Forming questions with か and question words.', order: 1),
    const LessonModel(id: 'vocab_transport', moduleId: 'unit_5', title: 'Transport', description: 'Learn essential transport vocabulary.', order: 2),
    const LessonModel(id: 'conv_travel', moduleId: 'unit_5', title: 'Travel', description: 'Navigate stations, hotels, and directions.', order: 3),
    const LessonModel(id: 'gram_tenses', moduleId: 'unit_5', title: 'Tenses', description: 'Present, past, and future expressions.', order: 4),
    const LessonModel(id: 'vocab_clothing', moduleId: 'unit_5', title: 'Clothing', description: 'Learn essential clothing vocabulary.', order: 5),
    const LessonModel(id: 'vocab_general', moduleId: 'unit_5', title: 'General Vocab', description: 'Learn essential general vocab vocabulary.', order: 6),

    // UNIT 6: READING & KANJI
    const LessonModel(id: 'read_kanji', moduleId: 'unit_6', title: 'Basic Kanji', description: 'Introduction to essential N5 Kanji.', order: 1),
    const LessonModel(id: 'vocab_family', moduleId: 'unit_6', title: 'Family', description: 'Learn essential family vocabulary.', order: 2),
    const LessonModel(id: 'vocab_school', moduleId: 'unit_6', title: 'School', description: 'Learn essential school vocabulary.', order: 3),
    const LessonModel(id: 'read_passages', moduleId: 'unit_6', title: 'Short Passages', description: 'Read simple Japanese paragraphs.', order: 4),
    const LessonModel(id: 'read_comprehension', moduleId: 'unit_6', title: 'Comprehension', description: 'Answer questions about what you read.', order: 5),
    const LessonModel(id: 'read_writing', moduleId: 'unit_6', title: 'Writing Exercises', description: 'Practice writing sentences and paragraphs.', order: 6),

    // UNIT 7: N5 MASTERY
    const LessonModel(id: 'vocab_animals', moduleId: 'unit_7', title: 'Animals', description: 'Learn essential animals vocabulary.', order: 1),
    const LessonModel(id: 'jlpt_vocab', moduleId: 'unit_7', title: 'Vocabulary Review', description: 'Review all N5 vocabulary.', order: 2),
    const LessonModel(id: 'jlpt_grammar', moduleId: 'unit_7', title: 'Grammar Review', description: 'Review all N5 grammar points.', order: 3),
    const LessonModel(id: 'jlpt_practice', moduleId: 'unit_7', title: 'Practice Tests', description: 'Full-length practice exams.', order: 4),
    const LessonModel(id: 'jlpt_timed', moduleId: 'unit_7', title: 'Timed Quizzes', description: 'Speed drills under time pressure.', order: 5, estimatedMinutes: 15),
  ];
}
"""

with open(r'c:\duolingo\lib\data\course_repository.dart', 'w', encoding='utf-8') as f:
    f.write(new_content)
print("Updated course_repository.dart")
