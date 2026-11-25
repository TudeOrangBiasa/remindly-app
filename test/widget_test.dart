import 'package:flutter_test/flutter_test.dart';
import 'package:remindly_app/app.dart';

void main() {
  testWidgets('RemindlyApp tampil beranda', (tester) async {
    await tester.pumpWidget(const RemindlyApp());
    expect(find.text('Beranda'), findsWidgets);
  });
}
