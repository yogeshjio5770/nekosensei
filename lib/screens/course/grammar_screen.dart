import 'package:flutter/material.dart';

class GrammarScreen extends StatelessWidget {
  const GrammarScreen({super.key, required this.topicId});

  final String topicId;

  static const _topics = {
    'gram_structure': {
      'title': 'Sentence Structure',
      'sections': [
        {
          'heading': 'SOV Word Order',
          'body':
              'Japanese uses Subject-Object-Verb order. The verb always comes at the end.',
        },
        {
          'heading': 'Example',
          'body': '私は本を読みます。\nWatashi wa hon wo yomimasu.\n"I read a book."',
        },
      ],
    },
    'gram_particles': {
      'title': 'Particles',
      'sections': [
        {
          'heading': 'は (wa) — Topic marker',
          'body': 'Marks what the sentence is about.',
        },
        {
          'heading': 'を (wo) — Object marker',
          'body': 'Marks the direct object of a verb.',
        },
        {
          'heading': 'に (ni) — Direction/Time',
          'body': 'Indicates direction, time, or indirect object.',
        },
      ],
    },
  };

  @override
  Widget build(BuildContext context) {
    final topic = _topics[topicId] ?? {'title': 'Grammar', 'sections': []};
    final sections = topic['sections'] as List;

    return Scaffold(
      appBar: AppBar(title: Text(topic['title'] as String)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (final section in sections)
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      section['heading'] as String,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(section['body'] as String),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Practice Exercises'),
          ),
        ],
      ),
    );
  }
}
