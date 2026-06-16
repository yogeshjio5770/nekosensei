import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../config/constants.dart';

class AdminAnalyticsScreen extends StatelessWidget {
  const AdminAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: FutureBuilder(
        future: _loadStats(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final stats = snapshot.data ?? {};

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _StatCard(
                title: 'Total Users',
                value: '${stats['users'] ?? 0}',
                icon: Icons.people,
              ),
              _StatCard(
                title: 'Certificates Issued',
                value: '${stats['certificates'] ?? 0}',
                icon: Icons.workspace_premium,
              ),
              _StatCard(
                title: 'Exam Attempts',
                value: '${stats['exams'] ?? 0}',
                icon: Icons.quiz,
              ),
              _StatCard(
                title: 'Pass Rate',
                value: '${stats['passRate'] ?? 0}%',
                icon: Icons.trending_up,
              ),
            ],
          );
        },
      ),
    );
  }

  Future<Map<String, dynamic>> _loadStats() async {
    final firestore = FirebaseFirestore.instance;
    final users = await firestore.collection('users').count().get();
    final certs = await firestore.collection('certificates').count().get();
    final exams = await firestore.collection('exam_results').get();
    final passed = exams.docs.where((d) => d.data()['passed'] == true).length;
    final total = exams.docs.length;

    return {
      'users': users.count,
      'certificates': certs.count,
      'exams': total,
      'passRate': total > 0 ? (passed / total * 100).round() : 0,
    };
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary, size: 32),
        title: Text(title),
        trailing: Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
        ),
      ),
    );
  }
}
