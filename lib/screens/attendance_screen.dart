import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/student_provider.dart';
import '../providers/attendance_provider.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  String _selectedClass = 'Mathematics 101';
  final List<String> _classes = ['Mathematics 101', 'Physics 202', 'Computer Science 303', 'History 101'];
  final String _today = DateTime.now().toString().split(' ')[0];

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mark Attendance'),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).primaryColor.withOpacity(0.05),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedClass,
                    decoration: const InputDecoration(labelText: 'Select Class'),
                    items: _classes.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                    onChanged: (val) => setState(() => _selectedClass = val!),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('Date', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    Text(_today, style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer2<StudentProvider, AttendanceProvider>(
              builder: (context, studentProvider, attendanceProvider, child) {
                final students = studentProvider.students;
                
                if (students.isEmpty) {
                  return const Center(child: Text('No students found.'));
                }

                return ListView.builder(
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    final student = students[index];
                    final isPresent = attendanceProvider.currentSessionAttendance[student.id!] ?? false;
                    
                    return CheckboxListTile(
                      title: Text(student.name),
                      subtitle: Text(student.major),
                      value: isPresent,
                      onChanged: (_) => attendanceProvider.toggleAttendance(student.id!),
                      secondary: CircleAvatar(
                        backgroundImage: student.profilePictureUrl.isNotEmpty
                            ? NetworkImage(student.profilePictureUrl)
                            : null,
                        child: student.profilePictureUrl.isEmpty ? Text(student.name[0]) : null,
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: ElevatedButton(
              onPressed: () async {
                await context.read<AttendanceProvider>().saveAttendance(_selectedClass, _today);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Attendance saved successfully!')),
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('SAVE ATTENDANCE'),
            ),
          ),
        ],
      ),
    );
  }
}
