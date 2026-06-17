import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nihongo_master/main.dart';

void main() {
  testWidgets('NekoSensei app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: NekoSenseiApp()));
    expect(find.textContaining('NekoSensei'), findsWidgets);
  });
}
