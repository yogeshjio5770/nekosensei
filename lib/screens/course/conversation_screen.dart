import 'package:flutter/material.dart';
import '../../utils/platform_layout.dart';

class ConversationScreen extends StatelessWidget {
  const ConversationScreen({super.key, required this.topicId});

  final String topicId;

  static const _topics = {
    'conv_greetings': {
      'title': 'Greetings',
      'dialogue': [
        {'jp': 'おはようございます。', 'en': 'Good morning.', 'speaker': 'A'},
        {'jp': 'おはようございます。', 'en': 'Good morning.', 'speaker': 'B'},
        {'jp': 'こんにちは。', 'en': 'Hello.', 'speaker': 'A'},
        {'jp': 'こんにちは。', 'en': 'Hello.', 'speaker': 'B'},
      ],
    },
    'conv_shopping': {
      'title': 'Shopping',
      'dialogue': [
        {'jp': 'これはいくらですか。', 'en': 'How much is this?', 'speaker': 'Customer'},
        {'jp': '500円です。', 'en': 'It is 500 yen.', 'speaker': 'Shopkeeper'},
        {'jp': 'ください。', 'en': 'Please give me (this).', 'speaker': 'Customer'},
      ],
    },
  };

  @override
  Widget build(BuildContext context) {
    final topic = _topics[topicId] ?? {'title': 'Conversation', 'dialogue': []};
    final dialogue = topic['dialogue'] as List;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(topic['title'] as String),
          bottom: const TabBar(
            tabs: [Tab(text: 'Dialogue'), Tab(text: 'Role Play')],
          ),
        ),
        body: TabBarView(
          children: [
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: PlatformLayout.contentWidth(context)),
                child: ListView.builder(
                  padding: PlatformLayout.pagePadding(context),
                  itemCount: dialogue.length,
                  itemBuilder: (_, i) {
                    final line = dialogue[i] as Map;
                    return Align(
                      alignment: line['speaker'] == 'A' ||
                              line['speaker'] == 'Customer'
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        constraints: BoxConstraints(
                          maxWidth: PlatformLayout.isWide(context)
                              ? 520
                              : MediaQuery.of(context).size.width * 0.75,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              line['jp'] as String,
                              style: const TextStyle(fontSize: 18),
                            ),
                            Text(line['en'] as String),
                            IconButton(
                              icon: const Icon(Icons.volume_up, size: 20),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: Padding(
                  padding: PlatformLayout.pagePadding(context),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.record_voice_over, size: 64),
                      const SizedBox(height: 16),
                      Text(
                        'Role Play Practice',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Practice the dialogue by playing each role. '
                        'Use the AI Tutor for conversation practice!',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.mic),
                        label: const Text('Start Role Play'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
