import 'package:flutter/material.dart';

class EmployeeDropdown extends StatelessWidget {

  final String label;

  final int value;

  final List<DropdownMenuItem<int>> items;

  final Function(int?) onChanged;

  const EmployeeDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 16,
      ),

      child: DropdownButtonFormField<int>(

        value:
        value == 0 ? null : value,

        items: items,

        onChanged: onChanged,

        decoration: InputDecoration(
          labelText: label,

          border: OutlineInputBorder(
            borderRadius:
            BorderRadius.circular(12),
          ),
        ),

        validator: (value) {

          if (value == null) {
            return "Please Select $label";
          }

          return null;
        },
      ),
    );
  }
}