import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:attendance_tracker/main.dart';
import 'package:attendance_tracker/providers/attendance_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Attendance Tracker app starts successfully', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AttendanceProvider(),
        child: const AttendanceTrackerApp(),
      ),
    );

    await tester.pump();

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
