import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remindly_app/theme/app_theme.dart';
import 'package:remindly_app/theme/tokens.dart';
import 'package:remindly_app/widgets/empty_state.dart';

void main() {
  test('tombol utama pill dan field label mengambang', () {
    final theme = AppTheme.light();
    final shape = theme.filledButtonTheme.style?.shape?.resolve(
      <WidgetState>{},
    );
    expect(shape, isA<StadiumBorder>());
    expect(
      theme.inputDecorationTheme.floatingLabelBehavior,
      FloatingLabelBehavior.auto,
    );
    expect(
      theme.filledButtonTheme.style?.minimumSize?.resolve(<WidgetState>{}),
      const Size(AppTokens.touchTarget, AppTokens.touchTarget),
    );
  });

  testWidgets('reduced motion mematikan animasi kosong', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: EmptyState(message: 'Kosong', onAdd: () {}),
        ),
      ),
    );

    final animasi = tester.widget<TweenAnimationBuilder<double>>(
      find.byType(TweenAnimationBuilder<double>),
    );
    expect(animasi.duration, Duration.zero);
    expect(find.text('Kosong'), findsOneWidget);
  });

  testWidgets('empty state bergerak dengan token motion', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: EmptyState(message: 'Kosong', onAdd: () {}),
      ),
    );

    final animasi = tester.widget<TweenAnimationBuilder<double>>(
      find.byType(TweenAnimationBuilder<double>),
    );
    expect(animasi.duration, AppTokens.motionMedium);
  });
}
