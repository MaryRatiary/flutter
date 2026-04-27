import 'package:flutter/material.dart';
import '../models/attendance.dart';
import '../data/database_helper.dart';

class AttendanceProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  Map<int, bool> _currentSessionAttendance = {}; // studentId -> isPresent
  List<Attendance> _history = [];
  bool _isLoading = false;

  Map<int, bool> get currentSessionAttendance => _currentSessionAttendance;
  List<Attendance> get history => _history;
  bool get isLoading => _isLoading;

  void toggleAttendance(int studentId) {
    _currentSessionAttendance[studentId] = !(_currentSessionAttendance[studentId] ?? false);
    notifyListeners();
  }

  Future<void> saveAttendance(String className, String date) async {
    _isLoading = true;
    notifyListeners();
    
    for (var entry in _currentSessionAttendance.entries) {
      await _dbHelper.insertAttendance(Attendance(
        studentId: entry.key,
        date: date,
        isPresent: entry.value,
        className: className,
      ));
    }
    
    _currentSessionAttendance.clear();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchAttendanceHistory(String className, String date) async {
    _isLoading = true;
    notifyListeners();
    _history = await _dbHelper.getAttendanceForClass(className, date);
    _isLoading = false;
    notifyListeners();
  }
}
