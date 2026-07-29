import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gate_vpn/main.dart';

void main() {
  testWidgets('App renders successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: GateVpnApp(),
      ),
    );

    // Verify that the main app widget is rendered.
    expect(find.byType(GateVpnApp), findsOneWidget);
  });
}
