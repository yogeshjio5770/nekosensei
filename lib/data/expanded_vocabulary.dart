import '../models/lesson_models.dart';

/// Extended N5 vocabulary — 8+ words per category for richer lessons.
class ExpandedVocabulary {
  ExpandedVocabulary._();

  static const extra = <VocabularyItem>[
    // Numbers
    VocabularyItem(japanese: '四', romaji: 'yon', english: 'Four', category: 'numbers', kanji: '四'),
    VocabularyItem(japanese: '五', romaji: 'go', english: 'Five', category: 'numbers', kanji: '五'),
    VocabularyItem(japanese: '六', romaji: 'roku', english: 'Six', category: 'numbers', kanji: '六'),
    VocabularyItem(japanese: '七', romaji: 'nana', english: 'Seven', category: 'numbers', kanji: '七'),
    VocabularyItem(japanese: '八', romaji: 'hachi', english: 'Eight', category: 'numbers', kanji: '八'),
    VocabularyItem(japanese: '九', romaji: 'kyuu', english: 'Nine', category: 'numbers', kanji: '九'),
    VocabularyItem(japanese: '十', romaji: 'juu', english: 'Ten', category: 'numbers', kanji: '十'),
    VocabularyItem(
      japanese: '百',
      romaji: 'hyaku',
      english: 'Hundred',
      category: 'numbers',
      kanji: '百',
      exampleSentence: '百円です。',
      exampleRomaji: 'Hyaku en desu.',
      exampleEnglish: 'It is 100 yen.',
    ),
    // Colors
    VocabularyItem(japanese: '黒', romaji: 'kuro', english: 'Black', category: 'colors', kanji: '黒'),
    VocabularyItem(japanese: '緑', romaji: 'midori', english: 'Green', category: 'colors', kanji: '緑'),
    VocabularyItem(japanese: '黄色', romaji: 'kiiro', english: 'Yellow', category: 'colors'),
    VocabularyItem(japanese: '茶色', romaji: 'chairo', english: 'Brown', category: 'colors'),
    VocabularyItem(japanese: 'ピンク', romaji: 'pinku', english: 'Pink', category: 'colors'),
    VocabularyItem(japanese: '灰色', romaji: 'haiiro', english: 'Gray', category: 'colors'),
    // Family
    VocabularyItem(japanese: '兄', romaji: 'ani', english: 'Older brother', category: 'family', kanji: '兄'),
    VocabularyItem(japanese: '姉', romaji: 'ane', english: 'Older sister', category: 'family', kanji: '姉'),
    VocabularyItem(japanese: '弟', romaji: 'otouto', english: 'Younger brother', category: 'family', kanji: '弟'),
    VocabularyItem(japanese: '妹', romaji: 'imouto', english: 'Younger sister', category: 'family', kanji: '妹'),
    VocabularyItem(japanese: '祖父', romaji: 'sofu', english: 'Grandfather', category: 'family', kanji: '祖父'),
    VocabularyItem(japanese: '祖母', romaji: 'sobo', english: 'Grandmother', category: 'family', kanji: '祖母'),
    // Food
    VocabularyItem(japanese: 'パン', romaji: 'pan', english: 'Bread', category: 'food'),
    VocabularyItem(japanese: '肉', romaji: 'niku', english: 'Meat', category: 'food', kanji: '肉'),
    VocabularyItem(japanese: '魚', romaji: 'sakana', english: 'Fish', category: 'food', kanji: '魚'),
    VocabularyItem(japanese: '野菜', romaji: 'yasai', english: 'Vegetables', category: 'food', kanji: '野菜'),
    VocabularyItem(japanese: '果物', romaji: 'kudamono', english: 'Fruit', category: 'food', kanji: '果物'),
    VocabularyItem(japanese: 'お茶', romaji: 'ocha', english: 'Tea', category: 'food'),
    VocabularyItem(japanese: 'コーヒー', romaji: 'koohii', english: 'Coffee', category: 'food'),
    // Animals
    VocabularyItem(japanese: '鳥', romaji: 'tori', english: 'Bird', category: 'animals', kanji: '鳥'),
    VocabularyItem(japanese: '馬', romaji: 'uma', english: 'Horse', category: 'animals', kanji: '馬'),
    VocabularyItem(japanese: '魚', romaji: 'sakana', english: 'Fish', category: 'animals', kanji: '魚'),
    VocabularyItem(japanese: '象', romaji: 'zou', english: 'Elephant', category: 'animals', kanji: '象'),
    VocabularyItem(japanese: 'うさぎ', romaji: 'usagi', english: 'Rabbit', category: 'animals'),
    VocabularyItem(japanese: 'パンダ', romaji: 'panda', english: 'Panda', category: 'animals'),
    // Time
    VocabularyItem(japanese: '火曜日', romaji: 'kayoubi', english: 'Tuesday', category: 'time'),
    VocabularyItem(japanese: '水曜日', romaji: 'suiyoubi', english: 'Wednesday', category: 'time'),
    VocabularyItem(japanese: '今日', romaji: 'kyou', english: 'Today', category: 'time', kanji: '今日'),
    VocabularyItem(japanese: '明日', romaji: 'ashita', english: 'Tomorrow', category: 'time', kanji: '明日'),
    VocabularyItem(japanese: '昨日', romaji: 'kinou', english: 'Yesterday', category: 'time', kanji: '昨日'),
    VocabularyItem(japanese: '二月', romaji: 'nigatsu', english: 'February', category: 'time'),
    VocabularyItem(japanese: '三月', romaji: 'sangatsu', english: 'March', category: 'time'),
    // Objects
    VocabularyItem(japanese: 'ペン', romaji: 'pen', english: 'Pen', category: 'objects'),
    VocabularyItem(japanese: '電話', romaji: 'denwa', english: 'Telephone', category: 'objects', kanji: '電話'),
    VocabularyItem(japanese: '車', romaji: 'kuruma', english: 'Car', category: 'objects', kanji: '車'),
    VocabularyItem(japanese: '時計', romaji: 'tokei', english: 'Clock', category: 'objects', kanji: '時計'),
    VocabularyItem(japanese: '椅子', romaji: 'isu', english: 'Chair', category: 'objects', kanji: '椅子'),
    VocabularyItem(japanese: 'ドア', romaji: 'doa', english: 'Door', category: 'objects'),
  ];
}
