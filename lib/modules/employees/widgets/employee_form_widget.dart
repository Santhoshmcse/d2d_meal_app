import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:d2d_meal_app/core/theme/app_colors.dart';
import '../controllers/employee_controller.dart'; // ✅ single import
import 'employee_dropdown.dart';
import 'employee_textfield.dart';

class EmployeeFormWidget extends StatelessWidget {

  // ✅ Controller passed as param — no more Get.find crash
  final AddEmployeeController controller;

  const EmployeeFormWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {

    return Form(
      key: controller.formKey,
      child: Column(
        children: [

          /// ── PHOTO ──────────────────────────────────────────────────
          Obx(() => Column(
            children: [
              GestureDetector(
                onTap: controller.pickImage,
                child: Stack(
                  children: [
                    Container(
                      width: 90, height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppColors.primaryGradient,
                      ),
                      child: controller.selectedImage.value != null
                          ? ClipOval(
                        child: Image.file(
                          controller.selectedImage.value!,
                          fit: BoxFit.cover,
                          width: 90, height: 90,
                        ),
                      )
                          : const Icon(Icons.person_rounded,
                          color: Colors.white, size: 42),
                    ),
                    Positioned(
                      bottom: 2, right: 2,
                      child: Container(
                        width: 28, height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.green1,
                          border: Border.all(color: AppColors.bg, width: 2),
                        ),
                        child: const Icon(Icons.camera_alt_rounded,
                            color: Colors.white, size: 14),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: controller.pickImage,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradientH,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    controller.selectedImage.value == null
                        ? 'Capture Photo'
                        : 'Update Photo',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          )),

          /// ── NAME ───────────────────────────────────────────────────
          EmployeeTextField(
            controller: controller.nameController,
            label: 'Employee Name',
            icon: Icons.person_outline_rounded,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Employee Name Required';
              return null;
            },
          ),

          /// ── EMPLOYEE REF ID ────────────────────────────────────────
          EmployeeTextField(
            controller: controller.employeeRefIdController,
            label: 'Employee Ref ID',
            icon: Icons.badge_outlined,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Employee Ref ID Required';
              return null;
            },
          ),

          /// ── BIOMETRIC ID ───────────────────────────────────────────
          EmployeeTextField(
            controller: controller.biometricIdController,
            label: 'Biometric ID',
            icon: Icons.fingerprint_rounded,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Biometric ID Required';
              return null;
            },
          ),

          /// ── DOJ ────────────────────────────────────────────────────
          EmployeeTextField(
            controller: controller.dojController,
            label: 'DOJ (YYYY-MM-DD)',
            icon: Icons.calendar_today_rounded,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'DOJ Required';
              return null;
            },
          ),

          /// ── DEPARTMENT ─────────────────────────────────────────────
          Obx(() => EmployeeDropdown(
            label: 'Department',
            icon: Icons.domain_rounded,
            value: controller.deptId.value,
            items: const [
              DropdownMenuItem(value: 1,  child: Text('GENERAL')),
              DropdownMenuItem(value: 16, child: Text('CUTTING')),
              DropdownMenuItem(value: 17, child: Text('TAILORING')),
              DropdownMenuItem(value: 19, child: Text('HOSTEL')),
            ],
            onChanged: (v) => controller.deptId.value = v!,
          )),

          /// ── DESIGNATION ────────────────────────────────────────────
          Obx(() => EmployeeDropdown(
            label: 'Designation',
            icon: Icons.work_outline_rounded,
            value: controller.desigId.value,
            items: const [
              DropdownMenuItem(value: 12, child: Text('HELPER')),
              DropdownMenuItem(value: 27, child: Text('TAILOR')),
              DropdownMenuItem(value: 75, child: Text('HOSTEL STAFF')),
            ],
            onChanged: (v) => controller.desigId.value = v!,
          )),

          /// ── LOCATION ───────────────────────────────────────────────
          Obx(() => EmployeeDropdown(
            label: 'Location',
            icon: Icons.location_on_outlined,
            value: controller.locationId.value,
            items: const [
              DropdownMenuItem(value: 1, child: Text('MAIN')),
            ],
            onChanged: (v) => controller.locationId.value = v!,
          )),

          /// ── EMPLOYEE TYPE ───────────────────────────────────────────
          Obx(() {
            const types = ['HOSTELLER', 'STAFF', 'WORKER'];
            if (!types.contains(controller.employeeType.value)) {
              controller.employeeType.value = 'HOSTELLER';
            }
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: DropdownButtonFormField<String>(
                value: controller.employeeType.value,
                dropdownColor: const Color(0xFF0D1F11),
                isExpanded: true,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: AppColors.darkInput('Employee Type', Icons.badge_outlined),
                items: types
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (v) {
                  if (v != null) controller.employeeType.value = v;
                },
              ),
            );
          }),

          const SizedBox(height: 4),
        ],
      ),
    );
  }
}