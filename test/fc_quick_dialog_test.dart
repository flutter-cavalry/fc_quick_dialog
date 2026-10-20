import 'package:fc_quick_dialog/fc_quick_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _nestedNavigatorApp(
  Future<void> Function(BuildContext context) showDialog,
) {
  return MaterialApp(
    home: Navigator(
      onGenerateRoute: (_) => MaterialPageRoute<void>(
        builder: (context) => Scaffold(
          body: Center(
            child: Builder(
              builder: (context) => TextButton(
                onPressed: () async => showDialog(context),
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

Future<void> _openAndDismiss(
  WidgetTester tester, {
  required String dismissText,
}) async {
  await tester.tap(find.text('Open'));
  await tester.pumpAndSettle();
  await tester.tap(find.text(dismissText));
  await tester.pumpAndSettle();
  expect(find.text('Open'), findsOneWidget);
}

void main() {
  testWidgets('confirm returns null when the context is unmounted', (
    tester,
  ) async {
    late BuildContext dialogContext;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            dialogContext = context;
            return const SizedBox();
          },
        ),
      ),
    );
    await tester.pumpWidget(const SizedBox());

    final result = await FcQuickDialog.confirm(
      dialogContext,
      yesText: 'Yes',
      noText: 'No',
    );

    expect(result, isNull);
  });

  testWidgets('info dialog closes without popping a nested route', (
    tester,
  ) async {
    await tester.pumpWidget(
      _nestedNavigatorApp(
        (context) => FcQuickDialog.info(context, okText: 'OK'),
      ),
    );

    await _openAndDismiss(tester, dismissText: 'OK');
  });

  testWidgets('confirm dialog closes without popping a nested route', (
    tester,
  ) async {
    await tester.pumpWidget(
      _nestedNavigatorApp(
        (context) => FcQuickDialog.confirm(
          context,
          yesText: 'Yes',
          noText: 'No',
        ).then((_) {}),
      ),
    );

    await _openAndDismiss(tester, dismissText: 'No');
  });

  testWidgets('error dialog closes without popping a nested route', (
    tester,
  ) async {
    await tester.pumpWidget(
      _nestedNavigatorApp(
        (context) => FcQuickDialog.error(context, error: 'Error', okText: 'OK'),
      ),
    );

    await _openAndDismiss(tester, dismissText: 'OK');
  });

  testWidgets('text input dialog closes without popping a nested route', (
    tester,
  ) async {
    await tester.pumpWidget(
      _nestedNavigatorApp(
        (context) => FcQuickDialog.textInput(
          context,
          title: 'Input',
          okText: 'OK',
          cancelText: 'Cancel',
        ).then((_) {}),
      ),
    );

    await _openAndDismiss(tester, dismissText: 'Cancel');
  });
}
