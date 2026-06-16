import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/constants.dart';
import '../../providers/app_providers.dart';

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
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Icon(Icons.workspace_premium, size: 80, color: Colors.amber),
                const SizedBox(height: 16),
                Text(
                  cert.levelTitle,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(cert.studentName),
                const SizedBox(height: 8),
                Text('Score: ${cert.finalScore}/100'),
                Text('ID: ${cert.id}'),
                Text('Issued: ${cert.issuedAt.toString().split(' ').first}'),
                const Spacer(),
                ElevatedButton.icon(
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
              ],
            ),
          ),
        );
      },
    );
  }
}
