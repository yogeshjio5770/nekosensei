import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/constants.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        children: [
          _AdminCard(
            icon: Icons.menu_book,
            title: 'Manage Lessons',
            onTap: () => context.push('/admin/lessons'),
          ),
          _AdminCard(
            icon: Icons.quiz,
            title: 'Upload Quizzes',
            onTap: () => context.push('/admin/lessons'),
          ),
          _AdminCard(
            icon: Icons.people,
            title: 'Manage Users',
            onTap: () => context.push('/admin/users'),
          ),
          _AdminCard(
            icon: Icons.analytics,
            title: 'Analytics',
            onTap: () => context.push('/admin/analytics'),
          ),
          _AdminCard(
            icon: Icons.workspace_premium,
            title: 'Certificates',
            onTap: () => context.push('/certificates'),
          ),
          _AdminCard(
            icon: Icons.track_changes,
            title: 'Student Progress',
            onTap: () => context.push('/admin/analytics'),
          ),
        ],
      ),
    );
  }
}

class _AdminCard extends StatelessWidget {
  const _AdminCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: AppColors.primary),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
