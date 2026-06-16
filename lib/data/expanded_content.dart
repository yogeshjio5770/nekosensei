import '../models/lesson_models.dart';

/// Rich lesson content: kana extensions, grammar, conversations, reading.
class ExpandedContent {
  ExpandedContent._();

  static const hiraganaDakuten = [
    KanaCharacter(character: 'が', romaji: 'ga', type: 'hiragana'),
    KanaCharacter(character: 'ぎ', romaji: 'gi', type: 'hiragana'),
    KanaCharacter(character: 'ぐ', romaji: 'gu', type: 'hiragana'),
    KanaCharacter(character: 'げ', romaji: 'ge', type: 'hiragana'),
    KanaCharacter(character: 'ご', romaji: 'go', type: 'hiragana'),
    KanaCharacter(character: 'ざ', romaji: 'za', type: 'hiragana'),
    KanaCharacter(character: 'じ', romaji: 'ji', type: 'hiragana'),
    KanaCharacter(character: 'ず', romaji: 'zu', type: 'hiragana'),
    KanaCharacter(character: 'ぜ', romaji: 'ze', type: 'hiragana'),
    KanaCharacter(character: 'ぞ', romaji: 'zo', type: 'hiragana'),
    KanaCharacter(character: 'だ', romaji: 'da', type: 'hiragana'),
    KanaCharacter(character: 'ぢ', romaji: 'di', type: 'hiragana'),
    KanaCharacter(character: 'づ', romaji: 'du', type: 'hiragana'),
    KanaCharacter(character: 'で', romaji: 'de', type: 'hiragana'),
    KanaCharacter(character: 'ど', romaji: 'do', type: 'hiragana'),
    KanaCharacter(character: 'ば', romaji: 'ba', type: 'hiragana'),
    KanaCharacter(character: 'び', romaji: 'bi', type: 'hiragana'),
    KanaCharacter(character: 'ぶ', romaji: 'bu', type: 'hiragana'),
    KanaCharacter(character: 'べ', romaji: 'be', type: 'hiragana'),
    KanaCharacter(character: 'ぼ', romaji: 'bo', type: 'hiragana'),
    KanaCharacter(character: 'ぱ', romaji: 'pa', type: 'hiragana'),
    KanaCharacter(character: 'ぴ', romaji: 'pi', type: 'hiragana'),
    KanaCharacter(character: 'ぷ', romaji: 'pu', type: 'hiragana'),
    KanaCharacter(character: 'ぺ', romaji: 'pe', type: 'hiragana'),
    KanaCharacter(character: 'ぽ', romaji: 'po', type: 'hiragana'),
  ];

  static const katakanaDakuten = [
    KanaCharacter(character: 'ガ', romaji: 'ga', type: 'katakana'),
    KanaCharacter(character: 'ギ', romaji: 'gi', type: 'katakana'),
    KanaCharacter(character: 'グ', romaji: 'gu', type: 'katakana'),
    KanaCharacter(character: 'ゲ', romaji: 'ge', type: 'katakana'),
    KanaCharacter(character: 'ゴ', romaji: 'go', type: 'katakana'),
    KanaCharacter(character: 'ザ', romaji: 'za', type: 'katakana'),
    KanaCharacter(character: 'ジ', romaji: 'ji', type: 'katakana'),
    KanaCharacter(character: 'ズ', romaji: 'zu', type: 'katakana'),
    KanaCharacter(character: 'ゼ', romaji: 'ze', type: 'katakana'),
    KanaCharacter(character: 'ゾ', romaji: 'zo', type: 'katakana'),
    KanaCharacter(character: 'ダ', romaji: 'da', type: 'katakana'),
    KanaCharacter(character: 'バ', romaji: 'ba', type: 'katakana'),
    KanaCharacter(character: 'パ', romaji: 'pa', type: 'katakana'),
    KanaCharacter(character: 'ビ', romaji: 'bi', type: 'katakana'),
    KanaCharacter(character: 'プ', romaji: 'pu', type: 'katakana'),
  ];

  static const hiraganaCombo = [
    KanaCharacter(character: 'きゃ', romaji: 'kya', type: 'hiragana'),
    KanaCharacter(character: 'きゅ', romaji: 'kyu', type: 'hiragana'),
    KanaCharacter(character: 'きょ', romaji: 'kyo', type: 'hiragana'),
    KanaCharacter(character: 'しゃ', romaji: 'sha', type: 'hiragana'),
    KanaCharacter(character: 'しゅ', romaji: 'shu', type: 'hiragana'),
    KanaCharacter(character: 'しょ', romaji: 'sho', type: 'hiragana'),
    KanaCharacter(character: 'ちゃ', romaji: 'cha', type: 'hiragana'),
    KanaCharacter(character: 'ちゅ', romaji: 'chu', type: 'hiragana'),
    KanaCharacter(character: 'ちょ', romaji: 'cho', type: 'hiragana'),
    KanaCharacter(character: 'にゃ', romaji: 'nya', type: 'hiragana'),
    KanaCharacter(character: 'にゅ', romaji: 'nyu', type: 'hiragana'),
    KanaCharacter(character: 'にょ', romaji: 'nyo', type: 'hiragana'),
    KanaCharacter(character: 'ひゃ', romaji: 'hya', type: 'hiragana'),
    KanaCharacter(character: 'みゃ', romaji: 'mya', type: 'hiragana'),
    KanaCharacter(character: 'りゃ', romaji: 'rya', type: 'hiragana'),
  ];

  static const katakanaCombo = [
    KanaCharacter(character: 'キャ', romaji: 'kya', type: 'katakana'),
    KanaCharacter(character: 'キュ', romaji: 'kyu', type: 'katakana'),
    KanaCharacter(character: 'キョ', romaji: 'kyo', type: 'katakana'),
    KanaCharacter(character: 'シャ', romaji: 'sha', type: 'katakana'),
    KanaCharacter(character: 'シュ', romaji: 'shu', type: 'katakana'),
    KanaCharacter(character: 'ショ', romaji: 'sho', type: 'katakana'),
    KanaCharacter(character: 'チャ', romaji: 'cha', type: 'katakana'),
    KanaCharacter(character: 'チュ', romaji: 'chu', type: 'katakana'),
    KanaCharacter(character: 'チョ', romaji: 'cho', type: 'katakana'),
    KanaCharacter(character: 'ニャ', romaji: 'nya', type: 'katakana'),
    KanaCharacter(character: 'ヒャ', romaji: 'hya', type: 'katakana'),
    KanaCharacter(character: 'リャ', romaji: 'rya', type: 'katakana'),
  ];

  static const grammarTopics = {
    'gram_structure': (
      'Sentence Structure (SOV)',
      'Japanese uses Subject–Object–Verb order.\n\n'
          '私は本を読みます。\n'
          'Watashi wa hon wo yomimasu.\n'
          '"I read a book."\n\n'
          'Tip: The verb always comes last.',
    ),
    'gram_particles': (
      'Essential Particles',
      'は (wa) — topic marker\n'
          'を (wo) — direct object\n'
          'に (ni) — direction / time\n'
          'で (de) — location / means\n'
          'が (ga) — subject emphasis\n'
          'の (no) — possession',
    ),
    'gram_verbs': (
      'Verb Groups',
      'Group 1 (u-verbs): 行く iku, 書く kaku\n'
          'Group 2 (ru-verbs): 食べる taberu, 見る miru\n'
          'Group 3 (irregular): する suru, 来る kuru\n\n'
          'ます-form: 食べます tabemasu (polite present)',
    ),
    'gram_adjectives': (
      'Adjectives',
      'い-adjectives: 高い takai (expensive/tall)\n'
          '  Past: 高かった takakatta\n\n'
          'な-adjectives: 静か shizuka (quiet)\n'
          '  + noun: 静かな部屋 shizuka na heya',
    ),
    'gram_questions': (
      'Forming Questions',
      'Add か at the end:\n'
          '学生ですか？ Gakusei desu ka? — Are you a student?\n\n'
          'Question words:\n'
          '何 nani — what\n'
          'どこ doko — where\n'
          'いつ itsu — when\n'
          'だれ dare — who',
    ),
    'gram_tenses': (
      'Tenses & Time',
      'Present: 食べます tabemasu — eat / will eat\n'
          'Past: 食べました tabemashita — ate\n'
          'Future: 明日行きます ashita ikimasu — will go tomorrow\n\n'
          'Negative: 食べません tabemasen — do not eat',
    ),
  };

  static const conversationPhrases = {
    'conv_greetings': [
      ('おはようございます', 'Ohayou gozaimasu', 'Good morning'),
      ('こんにちは', 'Konnichiwa', 'Hello (daytime)'),
      ('こんばんは', 'Konbanwa', 'Good evening'),
      ('おやすみなさい', 'Oyasumi nasai', 'Good night'),
      ('さようなら', 'Sayounara', 'Goodbye'),
    ],
    'conv_intro': [
      ('はじめまして', 'Hajimemashite', 'Nice to meet you'),
      ('私は…です', 'Watashi wa … desu', 'I am …'),
      ('よろしくお願いします', 'Yoroshiku onegaishimasu', 'Please treat me well'),
      ('どちらから来ましたか', 'Dochira kara kimashita ka', 'Where are you from?'),
    ],
    'conv_shopping': [
      ('これはいくらですか', 'Kore wa ikura desu ka', 'How much is this?'),
      ('安いです', 'Yasui desu', 'It is cheap'),
      ('高いです', 'Takai desu', 'It is expensive'),
      ('カードで払えますか', 'Kaado de haraemasu ka', 'Can I pay by card?'),
    ],
    'conv_restaurant': [
      ('メニューをください', 'Menyuu wo kudasai', 'Menu please'),
      ('これをください', 'Kore wo kudasai', 'This one please'),
      ('お会計お願いします', 'Okaikei onegaishimasu', 'Check please'),
      ('美味しい', 'Oishii', 'Delicious'),
    ],
    'conv_travel': [
      ('駅はどこですか', 'Eki wa doko desu ka', 'Where is the station?'),
      ('切符をください', 'Kippu wo kudasai', 'A ticket please'),
      ('ホテルはどこですか', 'Hoteru wa doko desu ka', 'Where is the hotel?'),
      ('道に迷いました', 'Michi ni mayoimashita', 'I am lost'),
    ],
    'conv_daily': [
      ('元気ですか', 'Genki desu ka', 'How are you?'),
      ('大丈夫です', 'Daijoubu desu', 'I am fine'),
      ('また明日', 'Mata ashita', 'See you tomorrow'),
      ('頑張って', 'Ganbatte', 'Good luck / do your best'),
    ],
  };

  static const readingPassages = {
    'read_passages': (
      'My Daily Routine',
      '私は毎朝七時に起きます。朝ごはんを食べて、学校へ行きます。\n'
          'Watashi wa maiasa shichiji ni okimasu. Asagohan wo tabete, gakkou e ikimasu.\n\n'
          'I wake up at 7 every morning. I eat breakfast and go to school.',
    ),
    'read_comprehension': (
      'At the Park',
      '今日は公園で友達と遊びました。天気がとても良かったです。\n'
          'Kyou wa kouen de tomodachi to asobimashita. Tenki ga totemo yokatta desu.\n\n'
          'Today I played with friends at the park. The weather was very nice.',
    ),
    'read_writing': (
      'Writing Practice',
      'Write about yourself using this template:\n\n'
          '私は___です。___から来ました。\n'
          '___が好きです。\n\n'
          'Watashi wa ___ desu. ___ kara kimashita.\n'
          '___ ga suki desu.',
    ),
    'read_kanji': (
      'Essential N5 Kanji',
      '日 hi — day / sun\n'
          '月 tsuki — month / moon\n'
          '火 hi — fire\n'
          '水 mizu — water\n'
          '木 ki — tree\n'
          '人 hito — person\n'
          '大 oo — big\n'
          '小 chii — small\n'
          '学 gaku — study\n'
          '校 kou — school',
    ),
  };

  static List<KanaCharacter> kanaForLesson(String lessonId, List<KanaCharacter> basic) {
    return switch (lessonId) {
      'hira_basic' || 'kata_basic' => basic.take(25).toList(),
      'hira_dakuten' => hiraganaDakuten,
      'kata_dakuten' => katakanaDakuten,
      'hira_combo' => hiraganaCombo,
      'kata_combo' => katakanaCombo,
      'hira_quiz' || 'kata_quiz' => basic,
      _ => basic.take(20).toList(),
    };
  }
}
