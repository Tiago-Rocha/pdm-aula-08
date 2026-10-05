// Tests for the four steps of the class. Run with: flutter test
// They start red. Each step of the class turns one of them green.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tempo_acores/forecast_screen.dart';
import 'package:tempo_acores/island_card.dart';
import 'package:tempo_acores/main.dart';

/// Runs the app in a phone-sized window, tall enough to build every widget.
Future<void> pumpApp(WidgetTester tester) async {
  tester.view.physicalSize = const Size(412, 4000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(const WeatherApp());
}

void main() {
  testWidgets('Passo 1: tocar no DetailCard mostra e esconde o vento',
      (tester) async {
    await pumpApp(tester);
    final card = find.byType(DetailCard);

    expect(find.descendant(of: card, matching: find.text('Vento')), findsNothing,
        reason: 'O cartão começa fechado: sem a linha do vento.');
    await tester.tap(find.descendant(of: card, matching: find.text('Mínima')));
    await tester.pump();
    expect(find.descendant(of: card, matching: find.text('Vento')),
        findsOneWidget,
        reason: 'Depois de um toque, o cartão mostra o vento.');
    await tester.tap(find.descendant(of: card, matching: find.text('Mínima')));
    await tester.pump();
    expect(find.descendant(of: card, matching: find.text('Vento')), findsNothing,
        reason: 'Outro toque esconde-o.');
  });

  testWidgets('Passo 2: o botão °F muda as temperaturas', (tester) async {
    await pumpApp(tester);
    final current = find.byType(CurrentConditions);

    expect(find.descendant(of: current, matching: find.text('23 °C')),
        findsWidgets);
    await tester.tap(find.text('°F'));
    await tester.pump();
    expect(find.descendant(of: current, matching: find.text('73 °F')),
        findsWidgets,
        reason: '23 °C são 73 °F.');
    expect(find.descendant(of: current, matching: find.text('23 °C')),
        findsNothing);
  });

  testWidgets('Passo 3: a pesquisa filtra as ilhas', (tester) async {
    await pumpApp(tester);

    expect(find.byType(IslandCard), findsNWidgets(9));
    await tester.enterText(find.byType(TextField).first, 'ter');
    await tester.pump();
    expect(find.byType(IslandCard), findsOneWidget,
        reason: 'Só a Terceira tem "ter" no nome.');
    await tester.enterText(find.byType(TextField).first, 'xyz');
    await tester.pump();
    expect(find.text('Nenhuma ilha encontrada'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.clear));
    await tester.pump();
    expect(find.byType(IslandCard), findsNWidgets(9),
        reason: 'O botão de limpar volta a mostrar as nove.');
  });

  testWidgets('Passo 4: o formulário vazio não é aceite', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('Subscrever'));
    await tester.pump();
    expect(find.text('Obrigatório'), findsNWidgets(2));
    expect(find.byType(SnackBar), findsNothing);

    await tester.enterText(find.widgetWithText(TextFormField, 'Nome'), 'Ana');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'E-mail'), 'ana@uac.pt');
    await tester.tap(find.text('Subscrever'));
    await tester.pump();
    expect(find.text('Avisos enviados para ana@uac.pt'), findsOneWidget);
  });
}
