import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../config/constants.dart';
import '../../providers/app_providers.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Progress Analytics')),
      body: userAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Error')),
        data: (user) {
          if (user == null) return const SizedBox.shrink();

          return StreamBuilder(
            stream: ref
                .read(progressServiceProvider)
                .watchUserAnalytics(user.uid),
            builder: (context, snapshot) {
              final analytics = snapshot.data ?? {};
              final recentScores =
                  (analytics['recentScores'] as List?)?.cast<int>() ?? [];
              final avgScore = analytics['averageScore'] as double? ?? 0;

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text(
                            'Overall Progress',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          LinearProgressIndicator(
                            value: user.progressPercentage / 100,
                            minHeight: 12,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${user.progressPercentage.toStringAsFixed(0)}% complete',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _MetricCard(
                          label: 'Lessons',
                          value: '${analytics['totalLessons'] ?? user.completedLessons.length}',
                          icon: Icons.book,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _MetricCard(
                          label: 'Avg Score',
                          value: '${avgScore.toStringAsFixed(0)}%',
                          icon: Icons.grade,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Recent Quiz Scores',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 200,
                            child: recentScores.isEmpty
                                ? const Center(
                                    child: Text('Complete quizzes to see charts'),
                                  )
                                : BarChart(
                                    BarChartData(
                                      alignment: BarChartAlignment.spaceAround,
                                      maxY: 100,
                                      barGroups: recentScores
                                          .asMap()
                                          .entries
                                          .map(
                                            (e) => BarChartGroupData(
                                              x: e.key,
                                              barRods: [
                                                BarChartRodData(
                                                  toY: e.value.toDouble(),
                                                  color: AppColors.primary,
                                                  width: 16,
                                                  borderRadius:
                                                      const BorderRadius.vertical(
                                                    top: Radius.circular(4),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                          .toList(),
                                      titlesData: FlTitlesData(show: false),
                                      gridData: const FlGridData(show: false),
                                      borderData: FlBorderData(show: false),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Certificates Earned',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 12),
                          if (user.certificateLevels.isEmpty)
                            const Text('No certificates yet')
                          else
                            ...user.certificateLevels.map(
                              (level) => Chip(
                                avatar: const Icon(Icons.verified, size: 18),
                                label: Text(
                                  AppConstants.certificateLevels[level]
                                          ?.title ??
                                      level,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(height: 8),
            Text(value, style: Theme.of(context).textTheme.titleLarge),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
