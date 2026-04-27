class Student {
  final int? id;
  final String name;
  final String email;
  final String phone;
  final String enrollmentDate;
  final String major;
  final String profilePictureUrl;
  final List<String> documents; // List of file paths or URLs

  Student({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.enrollmentDate,
    required this.major,
    required this.profilePictureUrl,
    this.documents = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'enrollmentDate': enrollmentDate,
      'major': major,
      'profilePictureUrl': profilePictureUrl,
      'documents': documents.join(','), // Simple CSV storage for demo
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      enrollmentDate: map['enrollmentDate'],
      major: map['major'],
      profilePictureUrl: map['profilePictureUrl'],
      documents: map['documents'] != null && map['documents'].toString().isNotEmpty
          ? map['documents'].toString().split(',')
          : [],
    );
  }

  Student copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? enrollmentDate,
    String? major,
    String? profilePictureUrl,
    List<String>? documents,
  }) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      enrollmentDate: enrollmentDate ?? this.enrollmentDate,
      major: major ?? this.major,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      documents: documents ?? this.documents,
    );
  }
}
