import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/constants.dart';
import '../../models/lesson_models.dart';
import '../../providers/app_providers.dart';

class ExamResultScreen extends ConsumerWidget {
  const ExamResultScreen({super.key, required this.extra});

  final Map<String, dynamic> extra;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = extra['result'] as ExamResult;
    final certificate = extra['certificate'] as CertificateModel?;
    final levelId = extra['levelId'] as String;
    final levelInfo = AppConstants.certificateLevels[levelId];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              Icon(
                result.passed ? Icons.workspace_premium : Icons.sentiment_dissatisfied,
                size: 80,
                color: result.passed ? AppColors.xpGold : AppColors.error,
              ),
              const SizedBox(height: 24),
              Text(
                result.passed ? 'Congratulations!' : 'Not quite yet',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                '${result.totalScore} / ${AppConstants.examTotalMarks}',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
              ),
              Text(
                result.passed
                    ? 'You passed the ${levelInfo?.title ?? levelId} exam!'
                    : 'Passing score: ${AppConstants.examPassingScore}/100',
              ),
              const SizedBox(height: 24),
              ...result.sectionScores.entries.map(
                (e) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(e.key),
                      Text('${e.value}/${AppConstants.examSectionMarks}'),
                    ],
                  ),
                ),
              ),
              if (certificate != null) ...[
                const SizedBox(height: 24),
                Card(
                  color: AppColors.success.withValues(alpha: 0.1),
                  child: ListTile(
                    leading: const Icon(Icons.verified, color: AppColors.success),
                    title: Text('${certificate.levelTitle} Certificate Earned!'),
                    subtitle: Text('ID: ${certificate.id}'),
                    trailing: const Icon(Icons.download),
                    onTap: () async {
                      final pdf = await ref
                          .read(certificateServiceProvider)
                          .generateCertificatePdf(
                            certificate: certificate,
                            verificationUrl:
                                '${AppConstants.verifyDomain}/${certificate.id}',
                          );
                      await ref
                          .read(certificateServiceProvider)
                          .shareCertificate(
                            pdf,
                            'certificate_${certificate.id}.pdf',
                          );
                    },
                  ),
                ),
              ],
              const Spacer(),
              ElevatedButton(
                onPressed: () => context.go('/home'),
                child: const Text('Back to Home'),
              ),
              if (!result.passed)
                TextButton(
                  onPressed: () => context.pop(),
                  child: const Text('Retry Exam'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
