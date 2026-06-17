import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/course_repository.dart';
import '../../providers/app_providers.dart';
import '../../utils/platform_layout.dart';

class ModuleDetailScreen extends ConsumerWidget {
  const ModuleDetailScreen({super.key, required this.moduleId});

  final String moduleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final module = CourseRepository.getModule(moduleId);
    if (module == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Module not found')),
      );
    }

    final lessons = CourseRepository.getLessonsForModule(moduleId);
    final userAsync = ref.watch(currentUserProvider);
    final completed = userAsync.value?.completedLessons ?? [];

    return Scaffold(
      appBar: AppBar(title: Text(module.title)),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: PlatformLayout.contentWidth(context)),
          child: ListView(
            padding: PlatformLayout.pagePadding(context),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        module.description,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 16),
                      if (moduleId == 'hiragana' || moduleId == 'katakana')
                        OutlinedButton.icon(
                          onPressed: () => context.push(
                            '/kana/${moduleId == 'hiragana' ? 'hiragana' : 'katakana'}',
                          ),
                          icon: const Icon(Icons.grid_on),
                          label: Text('View ${module.title} Chart'),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text('Lessons', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              ...lessons.asMap().entries.map((entry) {
                final i = entry.key;
                final lesson = entry.value;
                final isComplete = completed.contains(lesson.id);
                final isLocked = i > 0 &&
                    !completed.contains(lessons[i - 1].id) &&
                    !isComplete;

                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isComplete
                          ? Colors.green.withValues(alpha: 0.2)
                          : isLocked
                              ? Colors.grey.withValues(alpha: 0.2)
                              : Color(module.color).withValues(alpha: 0.2),
                      child: Icon(
                        isComplete
                            ? Icons.check
                            : isLocked
                                ? Icons.lock
                                : Icons.play_arrow,
                        color: isComplete
                            ? Colors.green
                            : isLocked
                                ? Colors.grey
                                : Color(module.color),
                      ),
                    ),
                    title: Text(lesson.title),
                    subtitle: Text(
                      '${lesson.estimatedMinutes} min • ${lesson.xpReward} XP',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    enabled: !isLocked,
                    onTap: isLocked
                        ? null
                        : () => context.push('/lesson/${lesson.id}'),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
