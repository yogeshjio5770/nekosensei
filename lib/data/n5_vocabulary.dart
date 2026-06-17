import '../models/lesson_models.dart';

/// N5-level vocabulary expansion — pushes toward full beginner coverage.
class N5Vocabulary {
  N5Vocabulary._();

  static const extra = <VocabularyItem>[
    // Verbs
    VocabularyItem(japanese: '行く', romaji: 'iku', english: 'To go', category: 'verbs', kanji: '行く'),
    VocabularyItem(japanese: '来る', romaji: 'kuru', english: 'To come', category: 'verbs', kanji: '来る'),
    VocabularyItem(japanese: '食べる', romaji: 'taberu', english: 'To eat', category: 'verbs', kanji: '食べる'),
    VocabularyItem(japanese: '飲む', romaji: 'nomu', english: 'To drink', category: 'verbs', kanji: '飲む'),
    VocabularyItem(japanese: '見る', romaji: 'miru', english: 'To see / watch', category: 'verbs', kanji: '見る'),
    VocabularyItem(japanese: '聞く', romaji: 'kiku', english: 'To listen / ask', category: 'verbs', kanji: '聞く'),
    VocabularyItem(japanese: '話す', romaji: 'hanasu', english: 'To speak', category: 'verbs', kanji: '話す'),
    VocabularyItem(japanese: '読む', romaji: 'yomu', english: 'To read', category: 'verbs', kanji: '読む'),
    VocabularyItem(japanese: '書く', romaji: 'kaku', english: 'To write', category: 'verbs', kanji: '書く'),
    VocabularyItem(japanese: '買う', romaji: 'kau', english: 'To buy', category: 'verbs', kanji: '買う'),
    VocabularyItem(japanese: '売る', romaji: 'uru', english: 'To sell', category: 'verbs', kanji: '売る'),
    VocabularyItem(japanese: '勉強する', romaji: 'benkyou suru', english: 'To study', category: 'verbs'),
    VocabularyItem(japanese: '働く', romaji: 'hataraku', english: 'To work', category: 'verbs', kanji: '働く'),
    VocabularyItem(japanese: '休む', romaji: 'yasumu', english: 'To rest', category: 'verbs', kanji: '休む'),
    VocabularyItem(japanese: '起きる', romaji: 'okiru', english: 'To wake up', category: 'verbs', kanji: '起きる'),
    VocabularyItem(japanese: '寝る', romaji: 'neru', english: 'To sleep', category: 'verbs', kanji: '寝る'),
    VocabularyItem(japanese: '待つ', romaji: 'matsu', english: 'To wait', category: 'verbs', kanji: '待つ'),
    VocabularyItem(japanese: '教える', romaji: 'oshieru', english: 'To teach', category: 'verbs', kanji: '教える'),
    VocabularyItem(japanese: '習う', romaji: 'narau', english: 'To learn', category: 'verbs', kanji: '習う'),
    VocabularyItem(japanese: '分かる', romaji: 'wakaru', english: 'To understand', category: 'verbs', kanji: '分かる'),

    // Adjectives
    VocabularyItem(japanese: '大きい', romaji: 'ookii', english: 'Big', category: 'adjectives'),
    VocabularyItem(japanese: '小さい', romaji: 'chiisai', english: 'Small', category: 'adjectives'),
    VocabularyItem(japanese: '新しい', romaji: 'atarashii', english: 'New', category: 'adjectives'),
    VocabularyItem(japanese: '古い', romaji: 'furui', english: 'Old', category: 'adjectives', kanji: '古い'),
    VocabularyItem(japanese: '高い', romaji: 'takai', english: 'Expensive / tall', category: 'adjectives', kanji: '高い'),
    VocabularyItem(japanese: '安い', romaji: 'yasui', english: 'Cheap', category: 'adjectives', kanji: '安い'),
    VocabularyItem(japanese: '暑い', romaji: 'atsui', english: 'Hot (weather)', category: 'adjectives'),
    VocabularyItem(japanese: '寒い', romaji: 'samui', english: 'Cold', category: 'adjectives'),
    VocabularyItem(japanese: '楽しい', romaji: 'tanoshii', english: 'Fun', category: 'adjectives'),
    VocabularyItem(japanese: '難しい', romaji: 'muzukashii', english: 'Difficult', category: 'adjectives', kanji: '難しい'),
    VocabularyItem(japanese: '易しい', romaji: 'yasashii', english: 'Easy', category: 'adjectives'),
    VocabularyItem(japanese: '元気', romaji: 'genki', english: 'Healthy / energetic', category: 'adjectives', kanji: '元気'),
    VocabularyItem(japanese: '静か', romaji: 'shizuka', english: 'Quiet', category: 'adjectives', kanji: '静か'),
    VocabularyItem(japanese: 'きれい', romaji: 'kirei', english: 'Beautiful / clean', category: 'adjectives'),
    VocabularyItem(japanese: '忙しい', romaji: 'isogashii', english: 'Busy', category: 'adjectives', kanji: '忙しい'),

    // Places
    VocabularyItem(japanese: '学校', romaji: 'gakkou', english: 'School', category: 'places', kanji: '学校'),
    VocabularyItem(japanese: '病院', romaji: 'byouin', english: 'Hospital', category: 'places', kanji: '病院'),
    VocabularyItem(japanese: '銀行', romaji: 'ginkou', english: 'Bank', category: 'places', kanji: '銀行'),
    VocabularyItem(japanese: '郵便局', romaji: 'yuubinkyoku', english: 'Post office', category: 'places'),
    VocabularyItem(japanese: '駅', romaji: 'eki', english: 'Station', category: 'places', kanji: '駅'),
    VocabularyItem(japanese: '空港', romaji: 'kuukou', english: 'Airport', category: 'places', kanji: '空港'),
    VocabularyItem(japanese: '図書館', romaji: 'toshokan', english: 'Library', category: 'places', kanji: '図書館'),
    VocabularyItem(japanese: '公園', romaji: 'kouen', english: 'Park', category: 'places', kanji: '公園'),
    VocabularyItem(japanese: '店', romaji: 'mise', english: 'Shop', category: 'places', kanji: '店'),
    VocabularyItem(japanese: 'レストラン', romaji: 'resutoran', english: 'Restaurant', category: 'places'),
    VocabularyItem(japanese: 'ホテル', romaji: 'hoteru', english: 'Hotel', category: 'places'),
    VocabularyItem(japanese: '家', romaji: 'ie', english: 'House / home', category: 'places', kanji: '家'),
    VocabularyItem(japanese: '会社', romaji: 'kaisha', english: 'Company', category: 'places', kanji: '会社'),
    VocabularyItem(japanese: 'トイレ', romaji: 'toire', english: 'Toilet', category: 'places'),
    VocabularyItem(japanese: '映画館', romaji: 'eigakan', english: 'Movie theater', category: 'places'),

    // Greetings & phrases
    VocabularyItem(japanese: 'こんにちは', romaji: 'konnichiwa', english: 'Hello', category: 'greetings'),
    VocabularyItem(japanese: 'おはよう', romaji: 'ohayou', english: 'Good morning', category: 'greetings'),
    VocabularyItem(japanese: 'こんばんは', romaji: 'konbanwa', english: 'Good evening', category: 'greetings'),
    VocabularyItem(japanese: 'さようなら', romaji: 'sayounara', english: 'Goodbye', category: 'greetings'),
    VocabularyItem(japanese: 'ありがとう', romaji: 'arigatou', english: 'Thank you', category: 'greetings'),
    VocabularyItem(japanese: 'すみません', romaji: 'sumimasen', english: 'Excuse me / sorry', category: 'greetings'),
    VocabularyItem(japanese: 'はい', romaji: 'hai', english: 'Yes', category: 'greetings'),
    VocabularyItem(japanese: 'いいえ', romaji: 'iie', english: 'No', category: 'greetings'),
    VocabularyItem(japanese: 'お願いします', romaji: 'onegaishimasu', english: 'Please', category: 'greetings'),
    VocabularyItem(japanese: 'いただきます', romaji: 'itadakimasu', english: 'Thanks for the meal', category: 'greetings'),

    // Body
    VocabularyItem(japanese: '頭', romaji: 'atama', english: 'Head', category: 'body', kanji: '頭'),
    VocabularyItem(japanese: '目', romaji: 'me', english: 'Eye', category: 'body', kanji: '目'),
    VocabularyItem(japanese: '耳', romaji: 'mimi', english: 'Ear', category: 'body', kanji: '耳'),
    VocabularyItem(japanese: '口', romaji: 'kuchi', english: 'Mouth', category: 'body', kanji: '口'),
    VocabularyItem(japanese: '手', romaji: 'te', english: 'Hand', category: 'body', kanji: '手'),
    VocabularyItem(japanese: '足', romaji: 'ashi', english: 'Foot / leg', category: 'body', kanji: '足'),
    VocabularyItem(japanese: '心', romaji: 'kokoro', english: 'Heart / mind', category: 'body', kanji: '心'),
    VocabularyItem(japanese: '体', romaji: 'karada', english: 'Body', category: 'body', kanji: '体'),
    VocabularyItem(japanese: '歯', romaji: 'ha', english: 'Tooth', category: 'body', kanji: '歯'),
    VocabularyItem(japanese: '鼻', romaji: 'hana', english: 'Nose', category: 'body', kanji: '鼻'),

    // Weather & nature
    VocabularyItem(japanese: '天気', romaji: 'tenki', english: 'Weather', category: 'weather', kanji: '天気'),
    VocabularyItem(japanese: '雨', romaji: 'ame', english: 'Rain', category: 'weather', kanji: '雨'),
    VocabularyItem(japanese: '雪', romaji: 'yuki', english: 'Snow', category: 'weather', kanji: '雪'),
    VocabularyItem(japanese: '風', romaji: 'kaze', english: 'Wind', category: 'weather', kanji: '風'),
    VocabularyItem(japanese: '晴れ', romaji: 'hare', english: 'Sunny', category: 'weather', kanji: '晴れ'),
    VocabularyItem(japanese: '海', romaji: 'umi', english: 'Sea', category: 'weather', kanji: '海'),
    VocabularyItem(japanese: '山', romaji: 'yama', english: 'Mountain', category: 'weather', kanji: '山'),
    VocabularyItem(japanese: '川', romaji: 'kawa', english: 'River', category: 'weather', kanji: '川'),
    VocabularyItem(japanese: '空', romaji: 'sora', english: 'Sky', category: 'weather', kanji: '空'),
    VocabularyItem(japanese: '花', romaji: 'hana', english: 'Flower', category: 'weather', kanji: '花'),

    // Clothing
    VocabularyItem(japanese: '服', romaji: 'fuku', english: 'Clothes', category: 'clothing', kanji: '服'),
    VocabularyItem(japanese: '靴', romaji: 'kutsu', english: 'Shoes', category: 'clothing', kanji: '靴'),
    VocabularyItem(japanese: '帽子', romaji: 'boushi', english: 'Hat', category: 'clothing', kanji: '帽子'),
    VocabularyItem(japanese: 'シャツ', romaji: 'shatsu', english: 'Shirt', category: 'clothing'),
    VocabularyItem(japanese: 'ズボン', romaji: 'zubon', english: 'Pants', category: 'clothing'),
    VocabularyItem(japanese: 'スカート', romaji: 'sukaato', english: 'Skirt', category: 'clothing'),
    VocabularyItem(japanese: 'コート', romaji: 'kooto', english: 'Coat', category: 'clothing'),
    VocabularyItem(japanese: '眼鏡', romaji: 'megane', english: 'Glasses', category: 'clothing', kanji: '眼鏡'),

    // Transportation
    VocabularyItem(japanese: '電車', romaji: 'densha', english: 'Train', category: 'transport', kanji: '電車'),
    VocabularyItem(japanese: 'バス', romaji: 'basu', english: 'Bus', category: 'transport'),
    VocabularyItem(japanese: '自転車', romaji: 'jitensha', english: 'Bicycle', category: 'transport', kanji: '自転車'),
    VocabularyItem(japanese: '飛行機', romaji: 'hikouki', english: 'Airplane', category: 'transport', kanji: '飛行機'),
    VocabularyItem(japanese: 'タクシー', romaji: 'takushii', english: 'Taxi', category: 'transport'),
    VocabularyItem(japanese: '地下鉄', romaji: 'chikatetsu', english: 'Subway', category: 'transport', kanji: '地下鉄'),
    VocabularyItem(japanese: '道', romaji: 'michi', english: 'Road', category: 'transport', kanji: '道'),
    VocabularyItem(japanese: '信号', romaji: 'shingou', english: 'Traffic light', category: 'transport', kanji: '信号'),

    // School
    VocabularyItem(japanese: '先生', romaji: 'sensei', english: 'Teacher', category: 'school', kanji: '先生'),
    VocabularyItem(japanese: '学生', romaji: 'gakusei', english: 'Student', category: 'school', kanji: '学生'),
    VocabularyItem(japanese: '宿題', romaji: 'shukudai', english: 'Homework', category: 'school', kanji: '宿題'),
    VocabularyItem(japanese: '試験', romaji: 'shiken', english: 'Exam', category: 'school', kanji: '試験'),
    VocabularyItem(japanese: '教室', romaji: 'kyoushitsu', english: 'Classroom', category: 'school', kanji: '教室'),
    VocabularyItem(japanese: '鉛筆', romaji: 'enpitsu', english: 'Pencil', category: 'school', kanji: '鉛筆'),
    VocabularyItem(japanese: 'ノート', romaji: 'nooto', english: 'Notebook', category: 'school'),
    VocabularyItem(japanese: '辞書', romaji: 'jisho', english: 'Dictionary', category: 'school', kanji: '辞書'),
  ];

  static const extraCategories = [
    ('verbs', 'Verbs', '🏃'),
    ('adjectives', 'Adjectives', '✨'),
    ('places', 'Places', '🏙️'),
    ('greetings', 'Greetings', '👋'),
    ('body', 'Body', '🧍'),
    ('weather', 'Weather & Nature', '🌤️'),
    ('clothing', 'Clothing', '👕'),
    ('transport', 'Transport', '🚃'),
    ('school', 'School', '📚'),
  ];
}
