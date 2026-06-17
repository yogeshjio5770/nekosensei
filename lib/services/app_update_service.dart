import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

// Provider to manage update state
final updateProvider = StateProvider<Map<String, dynamic>?>((ref) => null);

class AppUpdateService {
  // Replace with your GitHub username and repo name
  static const String githubOwner = 'yogeshjio5770';
  static const String githubRepo = 'nekosensei';

  static Future<Map<String, dynamic>?> checkForUpdates() async {
    try {
      // Fetch the latest release from GitHub
      final response = await http.get(
        Uri.parse('https://api.github.com/repos/$githubOwner/$githubRepo/releases/latest'),
      );

      if (response.statusCode == 200) {
        final release = jsonDecode(response.body);
        final latestVersion = release['tag_name'] as String;
        final apkAsset = release['assets'].firstWhere(
          (asset) => asset['name'].endsWith('.apk'),
          orElse: () => null,
        );

        if (apkAsset != null) {
          final currentPackage = await PackageInfo.fromPlatform();
          final currentVersion = currentPackage.version;

          if (_isVersionGreater(latestVersion, currentVersion)) {
            return {
              'version': latestVersion,
              'url': apkAsset['browser_download_url'] as String,
            };
          }
        }
      }
    } catch (e) {
      debugPrint('Update check failed: $e');
    }
    return null;
  }

  static bool _isVersionGreater(String latest, String current) {
    // Remove 'v' prefix if present
    final cleanLatest = latest.replaceFirst('v', '');
    final cleanCurrent = current.replaceFirst('v', '');

    final latestParts = cleanLatest.split('.').map((s) => int.tryParse(s) ?? 0).toList();
    final currentParts = cleanCurrent.split('.').map((s) => int.tryParse(s) ?? 0).toList();

    for (int i = 0; i < latestParts.length && i < currentParts.length; i++) {
      if (latestParts[i] > currentParts[i]) {
        return true;
      } else if (latestParts[i] < currentParts[i]) {
        return false;
      }
    }
    return latestParts.length > currentParts.length;
  }
}

// Widget to show update dialog
class UpdateDialog extends ConsumerWidget {
  const UpdateDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final update = ref.watch(updateProvider);

    if (update == null) {
      return const SizedBox.shrink();
    }

    return AlertDialog(
      title: const Text('Update Available'),
      content: Text('A new version (${update['version']}) is available!'),
      actions: [
        TextButton(
          onPressed: () {
            ref.read(updateProvider.notifier).state = null;
          },
          child: const Text('Later'),
        ),
        ElevatedButton(
          onPressed: () async {
            final url = Uri.parse(update['url']);
            if (await canLaunchUrl(url)) {
              await launchUrl(url, mode: LaunchMode.externalApplication);
            }
            ref.read(updateProvider.notifier).state = null;
          },
          child: const Text('Download'),
        ),
      ],
    );
  }
}
