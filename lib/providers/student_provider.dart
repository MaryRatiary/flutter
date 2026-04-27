import 'package:flutter/material.dart';
import '../models/student.dart';
import '../data/database_helper.dart';

class StudentProvider with ChangeNotifier {
  List<Student> _students = [];
  bool _isLoading = false;
  final DatabaseHelper _dbHelper = DatabaseHelper();

  List<Student> get students => _students;
  bool get isLoading => _isLoading;

  Future<void> fetchStudents() async {
    _isLoading = true;
    notifyListeners();
    _students = await _dbHelper.getStudents();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addStudent(Student student) async {
    await _dbHelper.insertStudent(student);
    await fetchStudents();
  }

  Future<void> updateStudent(Student student) async {
    await _dbHelper.updateStudent(student);
    await fetchStudents();
  }

  Future<void> deleteStudent(int id) async {
    await _dbHelper.deleteStudent(id);
    await fetchStudents();
  }

  List<Student> searchStudents(String query) {
    if (query.isEmpty) return _students;
    return _students.where((student) {
      return student.name.toLowerCase().contains(query.toLowerCase()) ||
          student.major.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}
