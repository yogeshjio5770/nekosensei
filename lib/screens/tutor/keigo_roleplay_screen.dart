import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../config/constants.dart';
import '../../models/lesson_models.dart';
import '../../providers/app_providers.dart';
import '../../widgets/common/neko_mascot.dart';

class KeigoRoleplayScreen extends ConsumerStatefulWidget {
  const KeigoRoleplayScreen({super.key});

  @override
  ConsumerState<KeigoRoleplayScreen> createState() => _KeigoRoleplayScreenState();
}

class _KeigoRoleplayScreenState extends ConsumerState<KeigoRoleplayScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final _messages = <ChatMessage>[];
  bool _isLoading = false;
  String _selectedRole = 'boss';

  final Map<String, String> _roles = {
    'boss': 'Strict Boss (Requires Keigo/Desu/Masu)',
    'friend': 'Best Friend (Requires Casual/Da)',
    'clerk': 'Store Clerk (Requires Teineigo)',
  };

  String get _currentSystemPrompt {
    if (_selectedRole == 'boss') {
      return '''
You are the strict Japanese Boss of a company. 
You are speaking to your employee (the user).
The user MUST use polite Japanese (Keigo / Desu / Masu form).
If they use casual Japanese (Da / Dictionary form), you must get very angry and reprimand them in Japanese!
If they use correct Keigo, be a stern but approving boss.
Keep responses to 1-2 sentences. Include romaji.
''';
    } else if (_selectedRole == 'friend') {
      return '''
You are the user's best friend. 
You are speaking to the user.
The user MUST use casual Japanese (Da / Dictionary form).
If they use polite Japanese (Desu / Masu form), ask them why they are being so formal and weird!
Keep responses to 1-2 sentences. Include romaji.
''';
    } else {
      return '''
You are a polite store clerk in Japan.
You are helping the user (customer) buy something.
Keep responses very polite (Sonkeigo / Kenjougo). 
If the user uses polite Japanese, praise them.
Keep responses to 1-2 sentences. Include romaji.
''';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage([String? text]) async {
    final message = text ?? _controller.text.trim();
    if (message.isEmpty || _isLoading) return;

    _controller.clear();
    setState(() {
      _messages.add(ChatMessage(
        id: const Uuid().v4(),
        content: message,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isLoading = true;
    });
    _scrollToBottom();

    try {
      final response = await ref.read(groqServiceProvider).sendMessage(
            history: _messages,
            userMessage: message,
            customSystemPrompt: _currentSystemPrompt,
          );
      setState(() {
        _messages.add(ChatMessage(
          id: const Uuid().v4(),
          content: response,
          isUser: false,
          timestamp: DateTime.now(),
        ));
      });
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(
          id: const Uuid().v4(),
          content: 'Error connecting to roleplay server.',
          isUser: false,
          timestamp: DateTime.now(),
        ));
      });
    } finally {
      setState(() => _isLoading = false);
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keigo Roleplay'),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Row(
              children: [
                const Icon(Icons.theater_comedy),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedRole,
                      isExpanded: true,
                      items: _roles.entries.map((e) {
                        return DropdownMenuItem(
                          value: e.key,
                          child: Text(e.value),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _selectedRole = val;
                            _messages.clear(); // Restart scenario
                          });
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_messages.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    NekoMascot(
                      size: 100,
                      mood: _selectedRole == 'boss' ? MascotMood.thinking : MascotMood.happy,
                    ),
                    const SizedBox(height: 24),
                    Text('Start speaking to the ${_roles[_selectedRole]!.split(" (").first}!'),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length + (_isLoading ? 1 : 0),
                itemBuilder: (_, i) {
                  if (i == _messages.length && _isLoading) {
                    return const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Typing...'),
                    );
                  }
                  final msg = _messages[i];
                  return Align(
                    alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: msg.isUser ? AppColors.primary : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        msg.content,
                        style: TextStyle(color: msg.isUser ? Colors.white : Colors.black),
                      ),
                    ),
                  );
                },
              ),
            ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Type your reply...',
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _isLoading ? null : () => _sendMessage(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
