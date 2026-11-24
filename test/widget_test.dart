import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_mini_portal/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Home and tabs render', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const StudentPortalApp());
    await tester.pumpAndSettle();
    expect(find.text('Привіт, студенте! 👋'), findsOneWidget);
    await tester.tap(find.text('Завдання').last);
    await tester.pumpAndSettle();
    expect(find.text('Завдання та дедлайни'), findsWidgets);
    await tester.tap(find.text('Профіль').last);
    await tester.pumpAndSettle();
    expect(find.text('Мій профіль'), findsOneWidget);
    await tester.tap(find.text('Здоров’я').last);
    await tester.pumpAndSettle();
    expect(find.text('Здоров’я та фокус'), findsOneWidget);
  });
}
