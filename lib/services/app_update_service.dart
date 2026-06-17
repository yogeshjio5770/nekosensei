import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:ota_update/ota_update.dart';
import 'package:package_info_plus/package_info_plus.dart';

// Provider to manage update state
final updateProvider = StateProvider<Map<String, dynamic>?>((ref) => null);

class AppUpdateService {
  // Replace with your GitHub username and repo name
  static const String githubOwner = 'yogeshjio5770';
  static const String githubRepo = 'nekosensei';

  final Ref ref;

  AppUpdateService(this.ref);

  Future<void> checkForUpdates() async {
    if (!Platform.isAndroid) {
      return;
    }

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
            ref.read(updateProvider.notifier).state = {
              'version': latestVersion,
              'url': apkAsset['browser_download_url'] as String,
            };
          }
        }
      }
    } catch (e) {
      debugPrint('Update check failed: $e');
    }
  }

  bool _isVersionGreater(String latest, String current) {
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

  Future<void> installUpdate(String apkUrl) async {
    try {
      await OtaUpdate().execute(
        apkUrl,
        destinationName: 'app-update.apk',
      );
    } catch (e) {
      debugPrint('Update failed: $e');
    }
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
          onPressed: () {
            ref.read(updateProvider.notifier).state = null;
            AppUpdateService(ref).installUpdate(update['url']);
          },
          child: const Text('Update Now'),
        ),
      ],
    );
  }
}
