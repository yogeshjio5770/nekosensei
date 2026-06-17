import 'package:flutter/material.dart';
import '../../data/course_repository.dart';
import '../../utils/platform_layout.dart';

class VocabularyScreen extends StatelessWidget {
  const VocabularyScreen({super.key, required this.category});

  final String category;

  @override
  Widget build(BuildContext context) {
    final words = CourseRepository.vocabularyByCategory(category);
    final categoryInfo = CourseRepository.vocabularyCategories
        .where((c) => c.$1 == category)
        .firstOrNull;

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryInfo?.$2 ?? category),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: PlatformLayout.contentWidth(context)),
          child: ListView.builder(
            padding: PlatformLayout.pagePadding(context),
            itemCount: words.length,
            itemBuilder: (_, i) {
              final w = words[i];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ExpansionTile(
                  leading: Text(
                    w.japanese,
                    style: const TextStyle(fontSize: 24),
                  ),
                  title: Text(w.english),
                  subtitle: Text(w.romaji),
                  trailing: IconButton(
                    icon: const Icon(Icons.volume_up),
                    onPressed: () {},
                  ),
                  children: [
                    if (w.exampleSentence != null)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              w.exampleSentence!,
                              style: const TextStyle(fontSize: 18),
                            ),
                            if (w.exampleRomaji != null)
                              Text(w.exampleRomaji!,
                                  style: Theme.of(context).textTheme.bodySmall),
                            if (w.exampleEnglish != null)
                              Text(w.exampleEnglish!,
                                  style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull {
    final iterator = this.iterator;
    if (iterator.moveNext()) return iterator.current;
    return null;
  }
}
