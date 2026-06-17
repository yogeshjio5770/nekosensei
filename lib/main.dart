import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'config/theme.dart';
import 'config/routes.dart';
import 'config/constants.dart';
import 'providers/app_providers.dart';
import 'services/app_bootstrap.dart';
import 'services/app_update_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
  };

  await AppBootstrap.initialize();
  runApp(const ProviderScope(child: NekoSenseiApp()));
}

class NekoSenseiApp extends ConsumerStatefulWidget {
  const NekoSenseiApp({super.key});

  @override
  ConsumerState<NekoSenseiApp> createState() => _NekoSenseiAppState();
}

class _NekoSenseiAppState extends ConsumerState<NekoSenseiApp> {
  @override
  void initState() {
    super.initState();
    // Check for updates after the app is initialized
    Future.delayed(const Duration(seconds: 2), () {
      AppUpdateService(ref).checkForUpdates();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final router = createRouter();

    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: switch (themeMode) {
        AppThemeMode.light => ThemeMode.light,
        AppThemeMode.dark => ThemeMode.dark,
        AppThemeMode.system => ThemeMode.system,
      },
      routerConfig: router,
      builder: (context, child) {
        return Stack(
          children: [
            MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.noScaling,
              ),
              child: child ?? const SizedBox.shrink(),
            ),
            const UpdateDialog(),
          ],
        );
      },
    );
  }
}
