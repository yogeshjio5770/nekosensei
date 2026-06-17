import 'package:flutter/material.dart';
import '../../data/course_repository.dart';
import '../../utils/platform_layout.dart';

class KanaScreen extends StatelessWidget {
  const KanaScreen({super.key, required this.type});

  final String type;

  @override
  Widget build(BuildContext context) {
    final chars = type == 'hiragana'
        ? CourseRepository.hiraganaCharacters
        : CourseRepository.katakanaCharacters;
    final title = type == 'hiragana' ? 'Hiragana Chart' : 'Katakana Chart';

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Chart'),
              Tab(text: 'Flashcards'),
              Tab(text: 'Writing'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _KanaChart(chars: chars),
            _Flashcards(chars: chars),
            _WritingPractice(chars: chars),
          ],
        ),
      ),
    );
  }
}

class _KanaChart extends StatelessWidget {
  const _KanaChart({required this.chars});
  final List<dynamic> chars;

  @override
  Widget build(BuildContext context) {
    final columns = PlatformLayout.isDesktop(context)
        ? 8
        : PlatformLayout.isWide(context)
            ? 6
            : 5;
    return GridView.builder(
      padding: PlatformLayout.pagePadding(context),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        childAspectRatio: 0.85,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: chars.length,
      itemBuilder: (_, i) {
        final c = chars[i];
        return Card(
          child: InkWell(
            onTap: () {},
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(c.character, style: const TextStyle(fontSize: 28)),
                Text(c.romaji, style: Theme.of(context).textTheme.bodySmall),
                IconButton(
                  icon: const Icon(Icons.volume_up, size: 18),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Flashcards extends StatefulWidget {
  const _Flashcards({required this.chars});
  final List<dynamic> chars;

  @override
  State<_Flashcards> createState() => _FlashcardsState();
}

class _FlashcardsState extends State<_Flashcards> {
  int _index = 0;
  bool _showRomaji = false;

  @override
  Widget build(BuildContext context) {
    final c = widget.chars[_index];
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: Padding(
          padding: PlatformLayout.pagePadding(context),
          child: Column(
            children: [
              Text(
                '${_index + 1} / ${widget.chars.length}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => setState(() => _showRomaji = !_showRomaji),
                child: Card(
                  elevation: 4,
                  child: Container(
                    width: double.infinity,
                    height: 280,
                    alignment: Alignment.center,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _showRomaji
                          ? Text(
                              c.romaji,
                              key: const ValueKey('romaji'),
                              style: Theme.of(context).textTheme.displayLarge,
                            )
                          : Text(
                              c.character,
                              key: const ValueKey('char'),
                              style: const TextStyle(fontSize: 96),
                            ),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton.filled(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: _index > 0
                        ? () => setState(() {
                              _index--;
                              _showRomaji = false;
                            })
                        : null,
                  ),
                  Text('Tap to flip'),
                  IconButton.filled(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: _index < widget.chars.length - 1
                        ? () => setState(() {
                              _index++;
                              _showRomaji = false;
                            })
                        : null,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WritingPractice extends StatelessWidget {
  const _WritingPractice({required this.chars});
  final List<dynamic> chars;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: PlatformLayout.pagePadding(context),
      itemCount: chars.length,
      itemBuilder: (_, i) {
        final c = chars[i];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Text(c.character, style: const TextStyle(fontSize: 32)),
            title: Text('Practice writing "${c.character}" (${c.romaji})'),
            trailing: const Icon(Icons.edit),
            onTap: () {},
          ),
        );
      },
    );
  }
}
