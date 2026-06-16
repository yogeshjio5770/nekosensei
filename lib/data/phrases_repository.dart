/// Essential phrases for fast speaking & understanding — NekoSensei advantage over Duolingo.
class PhrasesRepository {
  PhrasesRepository._();

  static const dailyPhrases = [
    DailyPhrase(
      japanese: 'こんにちは',
      romaji: 'Konnichiwa',
      english: 'Hello',
      context: 'Use from late morning to evening',
    ),
    DailyPhrase(
      japanese: 'ありがとうございます',
      romaji: 'Arigatou gozaimasu',
      english: 'Thank you very much',
      context: 'Polite thank you',
    ),
    DailyPhrase(
      japanese: 'すみません',
      romaji: 'Sumimasen',
      english: 'Excuse me / Sorry',
      context: 'Get attention or apologize',
    ),
    DailyPhrase(
      japanese: 'はい',
      romaji: 'Hai',
      english: 'Yes',
      context: 'Agreement',
    ),
    DailyPhrase(
      japanese: 'いいえ',
      romaji: 'Iie',
      english: 'No',
      context: 'Decline politely',
    ),
    DailyPhrase(
      japanese: 'おはようございます',
      romaji: 'Ohayou gozaimasu',
      english: 'Good morning',
      context: 'Before noon',
    ),
    DailyPhrase(
      japanese: 'こんばんは',
      romaji: 'Konbanwa',
      english: 'Good evening',
      context: 'After sunset',
    ),
    DailyPhrase(
      japanese: 'さようなら',
      romaji: 'Sayounara',
      english: 'Goodbye',
      context: 'Farewell',
    ),
  ];

  static const speakDrills = [
    SpeakDrillEntry(
      japanese: 'はじめまして',
      romaji: 'Hajimemashite',
      english: 'Nice to meet you',
      hint: 'Ha-ji-me-ma-shi-te',
    ),
    SpeakDrillEntry(
      japanese: '私は学生です',
      romaji: 'Watashi wa gakusei desu',
      english: 'I am a student',
      hint: 'Wa-ta-shi wa ga-ku-sei de-su',
    ),
    SpeakDrillEntry(
      japanese: '日本語を勉強しています',
      romaji: 'Nihongo wo benkyou shite imasu',
      english: 'I am studying Japanese',
      hint: 'Ni-hon-go wo ben-kyou shi-te i-ma-su',
    ),
    SpeakDrillEntry(
      japanese: 'これはいくらですか',
      romaji: 'Kore wa ikura desu ka',
      english: 'How much is this?',
      hint: 'Ko-re wa i-ku-ra de-su ka',
    ),
    SpeakDrillEntry(
      japanese: 'トイレはどこですか',
      romaji: 'Toire wa doko desu ka',
      english: 'Where is the bathroom?',
      hint: 'To-i-re wa do-ko de-su ka',
    ),
    SpeakDrillEntry(
      japanese: '美味しい',
      romaji: 'Oishii',
      english: 'Delicious',
      hint: 'Oi-shii',
    ),
    SpeakDrillEntry(
      japanese: '助けてください',
      romaji: 'Tasukete kudasai',
      english: 'Please help me',
      hint: 'Ta-su-ke-te ku-da-sai',
    ),
    SpeakDrillEntry(
      japanese: '分かりました',
      romaji: 'Wakarimashita',
      english: 'I understand',
      hint: 'Wa-ka-ri-ma-shi-ta',
    ),
  ];

  static const conversationScenarios = [
    ConversationScenario(
      id: 'cafe',
      title: 'Ordering at a Café',
      lines: [
        ScenarioLine(
          speaker: 'Staff',
          japanese: 'いらっしゃいませ！',
          romaji: 'Irasshaimase!',
          english: 'Welcome!',
        ),
        ScenarioLine(
          speaker: 'You',
          japanese: 'コーヒーを一つください',
          romaji: 'Koohii wo hitotsu kudasai',
          english: 'One coffee please',
          isUserLine: true,
        ),
        ScenarioLine(
          speaker: 'Staff',
          japanese: 'かしこまりました',
          romaji: 'Kashikomarimashita',
          english: 'Certainly',
        ),
      ],
    ),
    ConversationScenario(
      id: 'intro',
      title: 'Meeting Someone New',
      lines: [
        ScenarioLine(
          speaker: 'You',
          japanese: 'はじめまして。田中です',
          romaji: 'Hajimemashite. Tanaka desu',
          english: 'Nice to meet you. I am Tanaka',
          isUserLine: true,
        ),
        ScenarioLine(
          speaker: 'Other',
          japanese: 'はじめまして。よろしくお願いします',
          romaji: 'Hajimemashite. Yoroshiku onegaishimasu',
          english: 'Nice to meet you too',
        ),
      ],
    ),
  ];
}

class DailyPhrase {
  const DailyPhrase({
    required this.japanese,
    required this.romaji,
    required this.english,
    required this.context,
  });

  final String japanese;
  final String romaji;
  final String english;
  final String context;
}

class SpeakDrillEntry {
  const SpeakDrillEntry({
    required this.japanese,
    required this.romaji,
    required this.english,
    required this.hint,
  });

  final String japanese;
  final String romaji;
  final String english;
  final String hint;
}

class ConversationScenario {
  const ConversationScenario({
    required this.id,
    required this.title,
    required this.lines,
  });

  final String id;
  final String title;
  final List<ScenarioLine> lines;
}

class ScenarioLine {
  const ScenarioLine({
    required this.speaker,
    required this.japanese,
    required this.romaji,
    required this.english,
    this.isUserLine = false,
  });

  final String speaker;
  final String japanese;
  final String romaji;
  final String english;
  final bool isUserLine;
}
