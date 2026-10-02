import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:attendance_tracker/providers/attendance_provider.dart';

void main() {
  late AttendanceProvider provider;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    provider = AttendanceProvider();
  });

  tearDown(() {
    provider.dispose();
  });

  test('Initially contains five sample students', () {
    expect(provider.totalStudents, 5);
    expect(provider.presentStudents, 3);
    expect(provider.absentStudents, 2);
  });

  test('Adds a new student successfully', () {
    final added = provider.addStudent(
      name: 'Sanju',
      rollNumber: '106',
      department: 'CSE',
      email: 'sanju@example.com',
    );

    expect(added, isTrue);
    expect(provider.totalStudents, 6);
    expect(provider.studentDetails.containsKey('Sanju'), isTrue);
    expect(provider.attendance['Sanju'], isFalse);
  });

  test('Prevents duplicate student names', () {
    final added = provider.addStudent(
      name: 'Rahul',
      rollNumber: '107',
      department: 'ECE',
      email: 'rahul2@example.com',
    );

    expect(added, isFalse);
    expect(provider.totalStudents, 5);
  });

  test('Updates student attendance correctly', () {
    provider.updateAttendance('Priya', true);

    expect(provider.attendance['Priya'], isTrue);
    expect(provider.presentStudents, 4);
    expect(provider.absentStudents, 1);
  });

  test('Marks all students absent', () {
    provider.markAllAbsent();

    expect(provider.presentStudents, 0);
    expect(provider.absentStudents, 5);
    expect(provider.attendancePercentage, 0);
  });
}
