import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/student.dart';
import '../providers/student_provider.dart';

class StudentFormScreen extends StatefulWidget {
  final Student? student;

  const StudentFormScreen({super.key, this.student});

  @override
  State<StudentFormScreen> createState() => _StudentFormScreenState();
}

class _StudentFormScreenState extends State<StudentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _majorController;
  late TextEditingController _dateController;
  late TextEditingController _imageController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.student?.name ?? '');
    _emailController = TextEditingController(text: widget.student?.email ?? '');
    _phoneController = TextEditingController(text: widget.student?.phone ?? '');
    _majorController = TextEditingController(text: widget.student?.major ?? '');
    _dateController = TextEditingController(text: widget.student?.enrollmentDate ?? DateTime.now().toString().split(' ')[0]);
    _imageController = TextEditingController(text: widget.student?.profilePictureUrl ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _majorController.dispose();
    _dateController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      final student = Student(
        id: widget.student?.id,
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        major: _majorController.text,
        enrollmentDate: _dateController.text,
        profilePictureUrl: _imageController.text,
        documents: _imageController.text.isNotEmpty ? [_imageController.text] : [], // Simple logic for demo
      );

      if (widget.student == null) {
        context.read<StudentProvider>().addStudent(student);
      } else {
        context.read<StudentProvider>().updateStudent(student);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.student == null ? 'Add Student' : 'Edit Student'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextField(_nameController, 'Full Name', Icons.person, 'Please enter name'),
              const SizedBox(height: 16),
              _buildTextField(_emailController, 'Email Address', Icons.email, 'Please enter email', keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 16),
              _buildTextField(_phoneController, 'Phone Number', Icons.phone, 'Please enter phone', keyboardType: TextInputType.phone),
              const SizedBox(height: 16),
              _buildTextField(_majorController, 'Major/Program', Icons.school, 'Please enter major'),
              const SizedBox(height: 16),
              _buildTextField(_imageController, 'Profile Picture URL', Icons.image, null, hintText: 'Enter URL (Optional)'),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveForm,
                child: Text(widget.student == null ? 'CREATE PROFILE' : 'SAVE CHANGES'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon,
    String? validatorText, {
    TextInputType keyboardType = TextInputType.text,
    String? hintText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Theme.of(context).primaryColor),
            hintText: hintText ?? label,
          ),
          validator: validatorText != null
              ? (value) {
                  if (value == null || value.isEmpty) return validatorText;
                  return null;
                }
              : null,
        ),
      ],
    );
  }
}
