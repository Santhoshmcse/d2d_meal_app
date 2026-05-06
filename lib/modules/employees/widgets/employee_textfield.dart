import 'package:flutter/material.dart';

class EmployeeTextField extends StatelessWidget {

  final TextEditingController controller;

  final String label;

  final String? Function(String?)? validator;

  const EmployeeTextField({
    super.key,
    required this.controller,
    required this.label,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 16,
      ),

      child: TextFormField(
        controller: controller,

        validator: validator,

        decoration: InputDecoration(
          labelText: label,

          border: OutlineInputBorder(
            borderRadius:
            BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}