import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:chip_companion/l10n/app_localizations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> pumpForLocale(WidgetTester tester, Locale locale,
      void Function(BuildContext ctx, AppLocalizations loc) check) async {
    late BuildContext captured;
    await tester.pumpWidget(
      MaterialApp(
        locale: locale,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (ctx) {
            captured = ctx;
            final loc = AppLocalizations.of(ctx)!;
            // Render one localized string to ensure widget tree builds fine.
            return Scaffold(body: Center(child: Text(loc.appTitle)));
          },
        ),
      ),
    );

    await tester.pumpAndSettle();
    final loc = AppLocalizations.of(captured)!;
    check(captured, loc);
  }

  testWidgets('Supported locales load with non-empty strings', (tester) async {
    final locales = const [
      Locale('en'),
      Locale('es'),
      Locale('fr'),
      Locale('he'),
      Locale('ru'),
    ];

    for (final locale in locales) {
  await pumpForLocale(tester, locale, (ctx, loc) {
        expect(loc.appTitle, isNotEmpty, reason: 'appTitle should not be empty for ${locale.languageCode}');
        expect(loc.helpTitle, isNotEmpty, reason: 'helpTitle should not be empty for ${locale.languageCode}');
        expect(loc.educationalOnly, isNotEmpty, reason: 'educationalOnly should not be empty for ${locale.languageCode}');
      });
    }
  });

  testWidgets('Spanish specific translation is correct for educationalOnly', (tester) async {
  await pumpForLocale(tester, const Locale('es'), (ctx, loc) {
      expect(loc.educationalOnly, 'Validación de formato y directorio de registros');
    });
  });

  testWidgets('Hebrew renders RTL', (tester) async {
  await pumpForLocale(tester, const Locale('he'), (ctx, loc) {
      expect(Directionality.of(ctx), TextDirection.rtl);
    });
  });
}
