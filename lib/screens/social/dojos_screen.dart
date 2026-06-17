import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/constants.dart';
import '../../models/dojo_model.dart';
import '../../providers/app_providers.dart';
import '../../services/dojo_service.dart';
import '../../utils/platform_layout.dart';

class DojosScreen extends ConsumerStatefulWidget {
  const DojosScreen({super.key});

  @override
  ConsumerState<DojosScreen> createState() => _DojosScreenState();
}

class _DojosScreenState extends ConsumerState<DojosScreen> {
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _createDojo() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final user = ref.read(currentUserProvider).value;
    if (user == null) return;

    await ref.read(dojoServiceProvider).createDojo(name, '🐉', user.uid);
    ref.invalidate(currentUserProvider); // refresh to get dojoId
    Navigator.of(context).pop();
  }

  void _showCreateDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create a Dojo'),
        content: TextField(
          controller: _nameController,
          decoration: const InputDecoration(hintText: 'Dojo Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _createDojo,
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider).value;
    final hasDojo = user?.dojoId != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dojos & Guilds'),
        actions: [
          if (!hasDojo)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _showCreateDialog,
            )
        ],
      ),
      body: FutureBuilder<List<DojoModel>>(
        future: ref.read(dojoServiceProvider).getTopDojos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final dojos = snapshot.data ?? [];
          if (dojos.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No Dojos exist yet! Be the first.'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _showCreateDialog,
                    child: const Text('Create Dojo'),
                  ),
                ],
              ),
            );
          }

          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: PlatformLayout.contentWidth(context)),
              child: ListView.builder(
                padding: PlatformLayout.pagePadding(context),
                itemCount: dojos.length,
                itemBuilder: (context, index) {
                  final dojo = dojos[index];
                  final isMyDojo = dojo.id == user?.dojoId;

                  return Card(
                    color: isMyDojo ? AppColors.primary.withValues(alpha: 0.1) : null,
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(dojo.icon),
                      ),
                      title: Text(dojo.name),
                      subtitle: Text('${dojo.totalXp} XP • ${dojo.memberIds.length} Members'),
                      trailing: hasDojo
                          ? (isMyDojo ? const Icon(Icons.star, color: AppColors.primary) : null)
                          : ElevatedButton(
                              onPressed: () async {
                                if (user != null) {
                                  await ref.read(dojoServiceProvider).joinDojo(dojo.id, user.uid);
                                  ref.invalidate(currentUserProvider);
                                  setState(() {});
                                }
                              },
                              child: const Text('Join'),
                            ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
