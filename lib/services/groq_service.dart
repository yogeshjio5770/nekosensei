import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/lesson_models.dart';

class GroqService {
  GroqService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  static const _baseUrl = 'https://api.groq.com/openai/v1/chat/completions';

  String get _apiKey => dotenv.env['GROQ_API_KEY'] ?? '';
  String get _model =>
      dotenv.env['GROQ_MODEL'] ?? 'llama-3.3-70b-versatile';

  static const _systemPrompt = '''
You are NekoSensei (ねこ先生), a friendly cat-girl Japanese tutor for the NekoSensei app.
You help beginners learn Japanese (JLPT N5-N4 level).

Your capabilities:
- Explain grammar concepts clearly with examples in Japanese, romaji, and English
- Define vocabulary words with pronunciation guides
- Practice conversational Japanese through role-play
- Correct sentences gently, showing the corrected version and explaining why
- Provide personalized study tips based on the learner's questions

Guidelines:
- Keep responses concise but helpful (2-4 paragraphs max unless asked for more)
- Always include romaji when showing Japanese text for beginners
- Use encouraging, supportive tone
- If asked about advanced topics beyond N4, mention they'll learn it in future levels
- Format Japanese examples clearly: 日本語 (nihongo) — English meaning
''';

  Future<String> sendMessage({
    required List<ChatMessage> history,
    required String userMessage,
    String? customSystemPrompt,
  }) async {
    if (_apiKey.isEmpty || _apiKey == 'your_groq_api_key_here') {
      return _mockResponse(userMessage);
    }

    final messages = [
      {'role': 'system', 'content': customSystemPrompt ?? _systemPrompt},
      ...history.where((m) => !m.isLoading).map((m) => {
            'role': m.isUser ? 'user' : 'assistant',
            'content': m.content,
          }),
      {'role': 'user', 'content': userMessage},
    ];

    final response = await _client.post(
      Uri.parse(_baseUrl),
      headers: {
        'Authorization': 'Bearer $_apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': _model,
        'messages': messages,
        'temperature': 0.7,
        'max_tokens': 1024,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Groq API error: ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final choices = data['choices'] as List;
    return choices.first['message']['content'] as String;
  }

  String _mockResponse(String message) {
    final lower = message.toLowerCase();
    if (lower.contains('particle') || lower.contains('は') || lower.contains('wa')) {
      return 'The particle は (wa) marks the topic of a sentence.\n\n'
          'Example: 私は学生です (watashi wa gakusei desu) — "I am a student."\n\n'
          'Note: When used as a particle, は is pronounced "wa", not "ha". '
          'It tells the listener what you\'re talking about, not necessarily the grammatical subject.';
    }
    if (lower.contains('hello') || lower.contains('greeting')) {
      return 'Common Japanese greetings:\n\n'
          '• こんにちは (konnichiwa) — Hello (daytime)\n'
          '• おはようございます (ohayou gozaimasu) — Good morning\n'
          '• こんばんは (konbanwa) — Good evening\n'
          '• はじめまして (hajimemashite) — Nice to meet you\n\n'
          'Try practicing: はじめまして、私は [name] です。';
    }
    return 'こんにちは! I\'m NekoSensei, your cat sensei! にゃん!\n\n'
        'Ask me about grammar, vocabulary, pronunciation, or practice a conversation! '
        'For example: "Explain the particle を" or "How do I introduce myself?"\n\n'
        'Note: Connect your Groq API key in .env for full AI responses.';
  }
}
