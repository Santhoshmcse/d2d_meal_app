import 'package:flutter/material.dart';
import 'package:d2d_meal_app/core/theme/app_colors.dart';

class EmployeeDropdown extends StatelessWidget {
  final String label;
  final IconData icon;
  final int value;
  final List<DropdownMenuItem<int>> items;
  final Function(int?) onChanged;

  const EmployeeDropdown({
    super.key,
    required this.label,
    required this.icon,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<int>(
        value: value == 0 ? null : value,
        dropdownColor: const Color(0xFF0D1F11),
        isExpanded: true,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: AppColors.darkInput(label, icon),
        items: items,
        onChanged: onChanged,
        validator: (v) => v == null ? "Please Select $label" : null,
      ),
    );
  }
}
