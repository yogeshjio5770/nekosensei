import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/constants.dart';
import '../../providers/app_providers.dart';
import '../../utils/platform_layout.dart';

class CertificateDetailScreen extends ConsumerWidget {
  const CertificateDetailScreen({super.key, required this.certId});

  final String certId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: ref.read(examServiceProvider).verifyCertificate(certId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final cert = snapshot.data;
        if (cert == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Certificate not found')),
          );
        }

        return Scaffold(
          appBar: AppBar(title: const Text('Your Certificate')),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Padding(
                padding: PlatformLayout.pagePadding(context),
                child: Column(
                  children: [
                    const Icon(Icons.workspace_premium, size: 80, color: Colors.amber),
                    const SizedBox(height: 16),
                    Text(
                      cert.levelTitle,
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    Text(cert.studentName, textAlign: TextAlign.center),
                    const SizedBox(height: 8),
                    Text('Score: ${cert.finalScore}/100'),
                    Text('ID: ${cert.id}', textAlign: TextAlign.center),
                    Text('Issued: ${cert.issuedAt.toString().split(' ').first}'),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final pdf = await ref
                              .read(certificateServiceProvider)
                              .generateCertificatePdf(
                                certificate: cert,
                                verificationUrl:
                                    '${AppConstants.verifyDomain}/${cert.id}',
                              );
                          await ref.read(certificateServiceProvider).shareCertificate(
                                pdf,
                                'certificate_${cert.id}.pdf',
                              );
                        },
                        icon: const Icon(Icons.download),
                        label: const Text('Download PDF'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
