import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/constants.dart';
import '../../providers/app_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);
    final themeMode = ref.watch(themeModeProvider);

    return userAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text('Error')),
      data: (user) {
        if (user == null) return const SizedBox.shrink();

        return Scaffold(
          appBar: AppBar(title: const Text('Profile')),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                      backgroundImage: user.photoUrl != null
                          ? NetworkImage(user.photoUrl!)
                          : null,
                      child: user.photoUrl == null
                          ? Text(
                              user.name[0].toUpperCase(),
                              style: const TextStyle(fontSize: 32),
                            )
                          : null,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      user.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(user.email),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _StatTile(
                icon: Icons.star,
                label: 'XP Points',
                value: '${user.xpPoints}',
              ),
              _StatTile(
                icon: Icons.trending_up,
                label: 'Level',
                value: '${user.levelFromXp}',
              ),
              _StatTile(
                icon: Icons.local_fire_department,
                label: 'Daily Streak',
                value: '${user.dailyStreak} days',
              ),
              _StatTile(
                icon: Icons.check_circle,
                label: 'Lessons Completed',
                value: '${user.completedLessons.length}',
              ),
              const Divider(height: 32),
              ListTile(
                leading: const Icon(Icons.auto_awesome, color: AppColors.accent),
                title: const Text('Why NekoSensei beats Duolingo'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/why-nekosensei'),
              ),
              ListTile(
                leading: const Icon(Icons.analytics_outlined),
                title: const Text('Progress Analytics'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/progress'),
              ),
              ListTile(
                leading: const Icon(Icons.workspace_premium),
                title: const Text('My Certificates'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/certificates'),
              ),
              ListTile(
                leading: const Icon(Icons.leaderboard),
                title: const Text('Leaderboard'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/leaderboard'),
              ),
              if (user.isAdmin)
                ListTile(
                  leading: const Icon(Icons.admin_panel_settings),
                  title: const Text('Admin Dashboard'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/admin'),
                ),
              const Divider(height: 32),
              ListTile(
                leading: const Icon(Icons.dark_mode),
                title: const Text('Dark Mode'),
                trailing: DropdownButton<AppThemeMode>(
                  value: themeMode,
                  underline: const SizedBox.shrink(),
                  items: const [
                    DropdownMenuItem(
                      value: AppThemeMode.system,
                      child: Text('System'),
                    ),
                    DropdownMenuItem(
                      value: AppThemeMode.light,
                      child: Text('Light'),
                    ),
                    DropdownMenuItem(
                      value: AppThemeMode.dark,
                      child: Text('Dark'),
                    ),
                  ],
                  onChanged: (mode) {
                    if (mode != null) {
                      ref.read(themeModeProvider.notifier).state = mode;
                    }
                  },
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () async {
                  await ref.read(authServiceProvider).signOut();
                  if (context.mounted) context.go('/login');
                },
                icon: const Icon(Icons.logout),
                label: const Text('Sign Out'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(label),
        trailing: Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }
}
