// import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lantojitos_app/main.dart';

void main() {
  testWidgets('Smoke test: la app arranca y muestra el título',
      (WidgetTester tester) async {
    await tester.pumpWidget(const LantojitosApp());
    expect(find.text("L'ANTOJITOS"), findsOneWidget);
  });
}
