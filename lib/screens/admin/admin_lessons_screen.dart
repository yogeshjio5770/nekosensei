import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/course_repository.dart';

class AdminLessonsScreen extends StatefulWidget {
  const AdminLessonsScreen({super.key});

  @override
  State<AdminLessonsScreen> createState() => _AdminLessonsScreenState();
}

class _AdminLessonsScreenState extends State<AdminLessonsScreen> {
  final _firestore = FirebaseFirestore.instance;

  Future<void> _seedModules() async {
    for (final module in CourseRepository.modules) {
      await _firestore.collection('modules').doc(module.id).set({
        'title': module.title,
        'description': module.description,
        'order': module.order,
        'lessonIds': module.lessonIds,
      });
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Modules seeded to Firestore')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Lessons')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _seedModules,
        icon: const Icon(Icons.cloud_upload),
        label: const Text('Seed to Firestore'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: CourseRepository.modules.length,
        itemBuilder: (_, i) {
          final module = CourseRepository.modules[i];
          final lessons = CourseRepository.getLessonsForModule(module.id);
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ExpansionTile(
              title: Text(module.title),
              subtitle: Text('${lessons.length} lessons'),
              children: lessons
                  .map(
                    (l) => ListTile(
                      title: Text(l.title),
                      subtitle: Text(l.id),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {},
                      ),
                    ),
                  )
                  .toList(),
            ),
          );
        },
      ),
    );
  }
}
