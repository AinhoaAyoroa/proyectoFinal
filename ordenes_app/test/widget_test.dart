import 'package:flutter_test/flutter_test.dart';
import 'package:ordenes_app/main.dart';
import 'package:ordenes_app/screens/orden_lista_screen.dart';

void main() {
  testWidgets('Mostrar lista de pedidos pendientes',
      (WidgetTester tester) async {
    await tester.pumpWidget(const OrdersApp());
    await tester.pumpAndSettle();
    expect(find.byType(OrdenListaScreen), findsOneWidget);
  });
}
