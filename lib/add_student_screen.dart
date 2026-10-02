import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/attendance_provider.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _rollController = TextEditingController();
  final _departmentController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _rollController.dispose();
    _departmentController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter student name';
    }
    if (value.trim().length < 2) {
      return 'Name must contain at least 2 characters';
    }
    return null;
  }

  String? _validateRoll(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter roll number';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value.trim())) {
      return 'Roll number must contain only numbers';
    }
    return null;
  }

  String? _validateDepartment(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter department';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter email address';
    }
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
        .hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  Future<void> _addStudent() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSaving = true);

    final provider = Provider.of<AttendanceProvider>(
      context,
      listen: false,
    );

    final success = provider.addStudent(
      name: _nameController.text,
      rollNumber: _rollController.text,
      department: _departmentController.text,
      email: _emailController.text,
    );

    if (!mounted) return;

    setState(() => _isSaving = false);

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('A student with this name already exists'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Student added successfully!'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Student')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Icon(
                        Icons.person_add,
                        size: 60,
                        color: Colors.indigo,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Add New Student',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _nameController,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          labelText: 'Student Name',
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: _validateName,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _rollController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Roll Number',
                          prefixIcon: Icon(Icons.badge),
                        ),
                        validator: _validateRoll,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _departmentController,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          labelText: 'Department',
                          prefixIcon: Icon(Icons.school),
                        ),
                        validator: _validateDepartment,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email Address',
                          prefixIcon: Icon(Icons.email),
                        ),
                        validator: _validateEmail,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _isSaving ? null : _addStudent,
                          icon: const Icon(Icons.person_add),
                          label: Text(
                            _isSaving ? 'Adding...' : 'Add Student',
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: _isSaving
                            ? null
                            : () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
