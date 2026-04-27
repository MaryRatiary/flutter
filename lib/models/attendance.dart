class Attendance {
  final int? id;
  final int studentId;
  final String date;
  final bool isPresent;
  final String className;

  Attendance({
    this.id,
    required this.studentId,
    required this.date,
    required this.isPresent,
    required this.className,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'studentId': studentId,
      'date': date,
      'isPresent': isPresent ? 1 : 0,
      'className': className,
    };
  }

  factory Attendance.fromMap(Map<String, dynamic> map) {
    return Attendance(
      id: map['id'],
      studentId: map['studentId'],
      date: map['date'],
      isPresent: map['isPresent'] == 1,
      className: map['className'],
    );
  }
}
