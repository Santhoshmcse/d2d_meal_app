import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:d2d_meal_app/modules/employees/models/employee_model.dart';
import 'package:d2d_meal_app/modules/employees/services/employee_service.dart';
import 'package:d2d_meal_app/modules/masters/models/department_model.dart';
import 'package:d2d_meal_app/modules/masters/models/designation_model.dart';
import 'package:d2d_meal_app/modules/masters/models/location_model.dart';
import 'package:d2d_meal_app/modules/masters/services/master_service.dart';
import 'package:d2d_meal_app/core/theme/app_colors.dart';

class EditEmployeeScreen extends StatefulWidget {
  final EmployeeModel employee;

  const EditEmployeeScreen({super.key, required this.employee});

  @override
  State<EditEmployeeScreen> createState() => _EditEmployeeScreenState();
}

class _EditEmployeeScreenState extends State<EditEmployeeScreen> {
  late TextEditingController nameController;
  late TextEditingController biometricController;
  late TextEditingController dojController;

  bool isLoading = false;
  File? selectedImage;

  List<DepartmentModel> departments = [];
  List<DesignationModel> designations = [];
  List<LocationModel> locations = [];

  int? selectedDeptId;
  int? selectedDesigId;
  int? selectedLocationId;
  String employeeType = 'STAFF';
  bool active = true;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.employee.name);
    biometricController =
        TextEditingController(text: widget.employee.biometricId ?? '');
    dojController = TextEditingController(text: widget.employee.doj);
    selectedDeptId = widget.employee.deptId;
    selectedDesigId = widget.employee.desigId;
    selectedLocationId = widget.employee.locationId;
    employeeType = widget.employee.employeeType;
    active = widget.employee.active;
    loadMasters();
  }

  @override
  void dispose() {
    nameController.dispose();
    biometricController.dispose();
    dojController.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 70,
      );
      if (pickedFile != null) {
        setState(() => selectedImage = File(pickedFile.path));
      }
    } catch (e) {
      debugPrint('$e');
    }
  }

  Future<void> loadMasters() async {
    try {
      departments = await MasterService.getDepartments();
      designations = await MasterService.getDesignations();
      locations = await MasterService.getLocations();
      setState(() {});
    } catch (e) {
      debugPrint('$e');
    }
  }

  Future<void> updateEmployee() async {
    setState(() => isLoading = true);
    try {
      await EmployeeService.updateEmployee(
        id: widget.employee.id,
        data: {
          'name': nameController.text,
          'deptId': selectedDeptId,
          'desigId': selectedDesigId,
          'employeeType': employeeType,
          'doj': dojController.text,
          'employeeRefId': widget.employee.id,
          'locationId': selectedLocationId,
          'biometricId': biometricController.text,
          'active': active,
        },
      );
      if (selectedImage != null) {
        await EmployeeService.uploadEmployeePhoto(
          employeeId: widget.employee.id,
          filePath: selectedImage!.path,
        );
      }
      if (mounted) {
        _showSnack('Employee Updated Successfully', isError: false);
        Navigator.pop(context, true);
      }
    } catch (e) {
      debugPrint('$e');
      _showSnack('Update Failed. Please try again.');
    }
    if (mounted) setState(() => isLoading = false);
  }

  void _showSnack(String msg, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(msg, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
        backgroundColor:
        isError ? AppColors.accentRed.withOpacity(0.9) : AppColors.green1,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bgCard,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 18,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Edit Employee',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 17,
              ),
            ),
            Text(
              widget.employee.employeeCode,
              style: TextStyle(
                color: Colors.white.withOpacity(0.45),
                fontSize: 11,
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.glassBorder),
        ),
      ),
      body: Column(
        children: [
          // ── Scrollable Form ────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _PhotoSection(
                    employee: widget.employee,
                    selectedImage: selectedImage,
                    onTap: pickImage,
                  ),

                  const SizedBox(height: 28),
                  _SectionHeader(
                      icon: Icons.person_outline_rounded,
                      label: 'Personal Info'),
                  const SizedBox(height: 12),

                  _DarkTextField(
                    controller: nameController,
                    label: 'Employee Name',
                    icon: Icons.badge_outlined,
                  ),
                  const SizedBox(height: 14),
                  _DarkTextField(
                    controller: dojController,
                    label: 'Date of Joining',
                    icon: Icons.calendar_today_outlined,
                  ),
                  const SizedBox(height: 14),
                  _DarkTextField(
                    controller: biometricController,
                    label: 'Biometric ID',
                    icon: Icons.fingerprint_rounded,
                  ),

                  const SizedBox(height: 28),
                  _SectionHeader(
                      icon: Icons.corporate_fare_rounded,
                      label: 'Organisation'),
                  const SizedBox(height: 12),

                  _DarkDropdown<int>(
                    value: selectedDeptId,
                    label: 'Department',
                    icon: Icons.work_outline_rounded,
                    items: departments
                        .map((d) => DropdownMenuItem(
                        value: d.id, child: Text(d.name)))
                        .toList(),
                    onChanged: (v) => setState(() => selectedDeptId = v),
                  ),
                  const SizedBox(height: 14),
                  _DarkDropdown<int>(
                    value: selectedDesigId,
                    label: 'Designation',
                    icon: Icons.military_tech_outlined,
                    items: designations
                        .map((d) => DropdownMenuItem(
                        value: d.id, child: Text(d.name)))
                        .toList(),
                    onChanged: (v) => setState(() => selectedDesigId = v),
                  ),
                  const SizedBox(height: 14),
                  _DarkDropdown<int>(
                    value: selectedLocationId,
                    label: 'Location',
                    icon: Icons.location_on_outlined,
                    items: locations
                        .map((l) => DropdownMenuItem(
                        value: l.id, child: Text(l.name)))
                        .toList(),
                    onChanged: (v) => setState(() => selectedLocationId = v),
                  ),
                  const SizedBox(height: 14),
                  _DarkDropdown<String>(
                    value: employeeType,
                    label: 'Employee Type',
                    icon: Icons.category_outlined,
                    items: const [
                      DropdownMenuItem(
                          value: 'STAFF', child: Text('STAFF')),
                      DropdownMenuItem(
                          value: 'HOSTELLER', child: Text('HOSTELLER')),
                      DropdownMenuItem(
                          value: 'WORKER', child: Text('WORKER')),
                    ],
                    onChanged: (v) => setState(() => employeeType = v!),
                  ),

                  const SizedBox(height: 28),
                  _SectionHeader(
                      icon: Icons.toggle_on_rounded, label: 'Status'),
                  const SizedBox(height: 12),

                  _ActiveToggleTile(
                    active: active,
                    onChanged: (v) => setState(() => active = v),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // ── Fixed Bottom Button ────────────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              border: Border(
                  top: BorderSide(color: AppColors.glassBorder)),
            ),
            child: _GradientButton(
              label: 'UPDATE EMPLOYEE',
              isLoading: isLoading,
              onPressed: updateEmployee,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Photo Section ────────────────────────────────────────────────────────────

class _PhotoSection extends StatelessWidget {
  const _PhotoSection({
    required this.employee,
    required this.selectedImage,
    required this.onTap,
  });

  final EmployeeModel employee;
  final File? selectedImage;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final hasNetworkPhoto =
        employee.photoUrl != null && employee.photoUrl!.isNotEmpty;

    ImageProvider? imageProvider;
    if (selectedImage != null) {
      imageProvider = FileImage(selectedImage!);
    } else if (hasNetworkPhoto) {
      imageProvider = NetworkImage(employee.photoUrl!);
    }

    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: imageProvider == null
                        ? AppColors.primaryGradient
                        : null,
                    border:
                    Border.all(color: AppColors.green1, width: 2.5),
                    boxShadow: AppColors.greenGlow(blur: 24),
                    image: imageProvider != null
                        ? DecorationImage(
                        image: imageProvider, fit: BoxFit.cover)
                        : null,
                  ),
                  child: imageProvider == null
                      ? Center(
                    child: Text(
                      employee.name.isNotEmpty
                          ? employee.name[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  )
                      : null,
                ),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.primaryGradient,
                    border: Border.all(color: AppColors.bg, width: 2),
                  ),
                  child: const Icon(Icons.camera_alt_rounded,
                      color: Colors.white, size: 16),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: onTap,
            child: Text(
              hasNetworkPhoto ? 'Update Photo' : 'Upload Photo',
              style: const TextStyle(
                color: AppColors.green1,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Section Header ───────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.green1, size: 15),
        const SizedBox(width: 7),
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: AppColors.green1,
            fontWeight: FontWeight.w700,
            fontSize: 11,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
            child: Container(height: 1, color: AppColors.glassBorder)),
      ],
    );
  }
}

// ─── Dark TextField ───────────────────────────────────────────────────────────

class _DarkTextField extends StatelessWidget {
  const _DarkTextField({
    required this.controller,
    required this.label,
    required this.icon,
  });
  final TextEditingController controller;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: AppColors.darkInput(label, icon),
    );
  }
}

// ─── Dark Dropdown ────────────────────────────────────────────────────────────

class _DarkDropdown<T> extends StatelessWidget {
  const _DarkDropdown({
    required this.value,
    required this.label,
    required this.icon,
    required this.items,
    required this.onChanged,
  });
  final T? value;
  final String label;
  final IconData icon;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      dropdownColor: AppColors.bgCard,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      iconEnabledColor: Colors.white38,
      isExpanded: true, // ✅ Fixes RenderFlex overflow on right
      decoration: AppColors.darkInput(label, icon),
      items: items,
      onChanged: onChanged,
    );
  }
}

// ─── Active Toggle Tile ───────────────────────────────────────────────────────

class _ActiveToggleTile extends StatelessWidget {
  const _ActiveToggleTile({required this.active, required this.onChanged});
  final bool active;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: SwitchListTile(
        value: active,
        onChanged: onChanged,
        activeColor: AppColors.green1,
        inactiveThumbColor: AppColors.accentRed,
        inactiveTrackColor: AppColors.accentRed.withOpacity(0.28),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        title: Text(
          active ? 'Active' : 'Inactive',
          style: TextStyle(
            color: active ? AppColors.accentTeal : AppColors.accentRed,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        subtitle: Text(
          active ? 'Employee can log meals' : 'Employee cannot log meals',
          style: TextStyle(
            color: Colors.white.withOpacity(0.38),
            fontSize: 12,
          ),
        ),
        secondary: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active
                ? AppColors.accentTeal.withOpacity(0.12)
                : AppColors.accentRed.withOpacity(0.12),
          ),
          child: Icon(
            active ? Icons.check_circle_outline : Icons.cancel_outlined,
            color: active ? AppColors.accentTeal : AppColors.accentRed,
            size: 20,
          ),
        ),
      ),
    );
  }
}

// ─── Gradient Button ──────────────────────────────────────────────────────────

class _GradientButton extends StatelessWidget {
  const _GradientButton({
    required this.label,
    required this.isLoading,
    required this.onPressed,
  });
  final String label;
  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        height: 54,
        decoration: BoxDecoration(
          gradient: isLoading
              ? AppColors.disabledGradient
              : AppColors.primaryGradientH,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isLoading ? [] : AppColors.greenGlow(),
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: Colors.white,
            ),
          )
              : Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 15,
              letterSpacing: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}