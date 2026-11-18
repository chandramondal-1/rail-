import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:railpulse/app/theme/app_theme.dart';
import 'package:railpulse/l10n/app_localizations.dart';
import 'package:railpulse/shared/widgets/demo_banner.dart';
import 'package:railpulse/shared/widgets/empty_state.dart';
import 'package:railpulse/shared/widgets/status_pill.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    theme: AppTheme.light(),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );
}

void main() {
  testWidgets('demo banner is clearly labelled', (tester) async {
    await tester.pumpWidget(_wrap(const DemoBanner(isDemo: true)));
    await tester.pumpAndSettle();

    expect(find.text('Demo data'), findsOneWidget);
    expect(
      find.textContaining('Live railway data is not connected'),
      findsOneWidget,
    );
  });

  testWidgets('demo banner collapses when data is live', (tester) async {
    await tester.pumpWidget(_wrap(const DemoBanner(isDemo: false)));
    await tester.pumpAndSettle();

    expect(find.text('Demo data'), findsNothing);
  });

  testWidgets('status pill renders its label', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const StatusPill(
          label: 'On time',
          background: Color(0xFFDCFCE7),
          foreground: Color(0xFF15803D),
        ),
      ),
    );

    expect(find.text('On time'), findsOneWidget);
  });

  testWidgets('empty state shows title and body', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const EmptyState(
          icon: Icons.train_outlined,
          title: 'Nothing here',
          body: 'Search for a train to begin.',
        ),
      ),
    );

    expect(find.text('Nothing here'), findsOneWidget);
    expect(find.text('Search for a train to begin.'), findsOneWidget);
  });
}
