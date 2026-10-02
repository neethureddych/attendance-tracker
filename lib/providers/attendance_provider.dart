import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttendanceProvider extends ChangeNotifier {
  static const String _storageKey = 'attendance_tracker_data';

  final Map<String, bool> _attendance = {
    'Rahul': true,
    'Valli': true,
    'Priya': false,
    'Arjun': true,
    'Sneha': false,
  };

  final Map<String, Map<String, String>> _studentDetails = {
    'Rahul': {
      'rollNumber': '101',
      'department': 'CSE',
      'email': 'rahul@example.com',
    },
    'Valli': {
      'rollNumber': '102',
      'department': 'CSE',
      'email': 'valli@example.com',
    },
    'Priya': {
      'rollNumber': '103',
      'department': 'ECE',
      'email': 'priya@example.com',
    },
    'Arjun': {
      'rollNumber': '104',
      'department': 'CSE',
      'email': 'arjun@example.com',
    },
    'Sneha': {
      'rollNumber': '105',
      'department': 'IT',
      'email': 'sneha@example.com',
    },
  };

  late final Future<void> _ready;

  AttendanceProvider() {
    _ready = _loadData();
  }

  Map<String, bool> get attendance => _attendance;

  Map<String, Map<String, String>> get studentDetails => _studentDetails;

  int get totalStudents => _attendance.length;

  int get presentStudents =>
      _attendance.values.where((present) => present).length;

  int get absentStudents =>
      _attendance.values.where((present) => !present).length;

  double get attendancePercentage {
    if (totalStudents == 0) return 0;
    return (presentStudents / totalStudents) * 100;
  }

  Future<void> _loadData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedData = prefs.getString(_storageKey);

      if (savedData == null) return;

      final decoded = jsonDecode(savedData) as Map<String, dynamic>;
      final savedAttendance = decoded['attendance'] as Map<String, dynamic>;
      final savedDetails = decoded['studentDetails'] as Map<String, dynamic>;

      _attendance
        ..clear()
        ..addAll(
          savedAttendance.map((name, value) => MapEntry(name, value as bool)),
        );

      _studentDetails
        ..clear()
        ..addAll(
          savedDetails.map((name, details) {
            final detailMap = details as Map<String, dynamic>;
            return MapEntry(
              name,
              detailMap.map((key, value) => MapEntry(key, value.toString())),
            );
          }),
        );

      notifyListeners();
    } catch (error) {
      debugPrint('Could not load saved student data: $error');
    }
  }

  Future<void> _saveData() async {
    try {
      await _ready;

      final prefs = await SharedPreferences.getInstance();

      final data = {
        'attendance': _attendance,
        'studentDetails': _studentDetails,
      };

      await prefs.setString(_storageKey, jsonEncode(data));
    } catch (error) {
      debugPrint('Could not save student data: $error');
    }
  }

  void updateAttendance(String student, bool isPresent) {
    if (!_attendance.containsKey(student)) return;

    _attendance[student] = isPresent;
    notifyListeners();
    _saveData();
  }

  void markAllPresent() {
    for (final student in _attendance.keys) {
      _attendance[student] = true;
    }

    notifyListeners();
    _saveData();
  }

  void markAllAbsent() {
    for (final student in _attendance.keys) {
      _attendance[student] = false;
    }

    notifyListeners();
    _saveData();
  }

  bool addStudent({
    required String name,
    required String rollNumber,
    required String department,
    required String email,
  }) {
    final trimmedName = name.trim();
    final trimmedRollNumber = rollNumber.trim();
    final trimmedDepartment = department.trim();
    final trimmedEmail = email.trim();

    if (trimmedName.isEmpty || _attendance.containsKey(trimmedName)) {
      return false;
    }

    _attendance[trimmedName] = false;

    _studentDetails[trimmedName] = {
      'rollNumber': trimmedRollNumber,
      'department': trimmedDepartment,
      'email': trimmedEmail,
    };

    notifyListeners();
    _saveData();

    return true;
  }
}
