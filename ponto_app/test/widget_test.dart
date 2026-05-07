import 'package:flutter_test/flutter_test.dart';

import 'package:ponto_app/main.dart';

void main() {
  testWidgets('App mostra tela de login inicialmente', (WidgetTester tester) async {
    await tester.pumpWidget(const PontoApp());
    expect(find.text('Entrar'), findsOneWidget);
    expect(find.text('Nome'), findsOneWidget);
    expect(find.text('Código de matrícula'), findsOneWidget);
  });
}
