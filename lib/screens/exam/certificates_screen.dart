import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/constants.dart';
import '../../providers/app_providers.dart';
import '../../utils/platform_layout.dart';

class CertificatesScreen extends ConsumerWidget {
  const CertificatesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Certificates')),
      body: userAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Error')),
        data: (user) {
          if (user == null) return const SizedBox.shrink();

          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: PlatformLayout.contentWidth(context)),
              child: ListView(
                padding: PlatformLayout.pagePadding(context),
                children: [
                  Text(
                    'Level-Based Certificates',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Earn certificates as you progress through JLPT levels. '
                    'Each certificate validates your skills at that level.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  ...AppConstants.certificateLevels.entries.map((entry) {
                    final level = entry.value;
                    final earned = user.certificateLevels.contains(entry.key);
                    final canTake = level.requiredModuleIds
                        .every((m) => user.completedModules.contains(m));
                    final hasPrereq = level.prerequisiteLevel == null ||
                        user.certificateLevels
                            .contains(level.prerequisiteLevel);

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Color(level.color).withValues(alpha: 0.2),
                          child: Icon(
                            earned ? Icons.verified : Icons.lock_outline,
                            color: Color(level.color),
                          ),
                        ),
                        title: Text(level.title),
                        subtitle: Text(
                          earned
                              ? 'Certificate earned'
                              : canTake && hasPrereq
                                  ? 'Ready to take exam'
                                  : 'Complete required modules',
                        ),
                        trailing: earned
                            ? const Icon(Icons.download)
                            : canTake && hasPrereq
                                ? const Icon(Icons.quiz)
                                : null,
                        onTap: () {
                          if (earned) {
                            context.push('/certificate/${entry.key}');
                          } else if (canTake && hasPrereq) {
                            context.push('/exam/${entry.key}');
                          }
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
