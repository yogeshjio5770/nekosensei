import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../config/constants.dart';
import '../../screens/onboarding/onboarding_screen.dart';
import '../../widgets/common/neko_mascot.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _bounceController;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _navigateNext();
  }

  Future<void> _navigateNext() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    final onboarded = await OnboardingScreen.isComplete();
    if (!mounted) return;
    context.go(onboarded ? '/login' : '/onboarding');
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.secondary,
              AppColors.secondaryDark,
              Color(0xFF0A1628),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              AnimatedBuilder(
                animation: _bounceController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, -8 * _bounceController.value),
                    child: child,
                  );
                },
                child: const NekoLogo(size: 200, borderRadius: 32)
                    .animate()
                    .scale(
                      duration: 700.ms,
                      curve: Curves.elasticOut,
                      begin: const Offset(0.5, 0.5),
                    )
                    .fadeIn(),
              ),
              const SizedBox(height: 28),
              Text(
                AppConstants.appName,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: AppColors.primary.withValues(alpha: 0.8),
                          blurRadius: 0,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
              ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.3),
              const SizedBox(height: 8),
              Text(
                AppConstants.appTagline,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white70,
                    ),
              ).animate().fadeIn(delay: 500.ms),
              const SizedBox(height: 12),
              Text(
                '#1 Japanese Learning App',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.accent,
                      fontWeight: FontWeight.bold,
                    ),
              ).animate().fadeIn(delay: 700.ms),
              const Spacer(),
              const SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  color: AppColors.accent,
                  strokeWidth: 3,
                ),
              ).animate().fadeIn(delay: 800.ms),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
