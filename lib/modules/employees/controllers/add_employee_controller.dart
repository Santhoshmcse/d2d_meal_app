import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:image_picker/image_picker.dart';

import '../models/create_employee_request.dart';

import '../services/employee_service.dart';

class AddEmployeeController extends GetxController {
  final formKey = GlobalKey<FormState>();

  /// TEXT CONTROLLERS
  final nameController = TextEditingController();

  final employeeRefIdController = TextEditingController();

  final biometricIdController = TextEditingController();

  final dojController = TextEditingController();

  /// DROPDOWNS
  RxInt deptId = 1.obs;

  RxInt desigId = 12.obs;

  RxInt locationId = 1.obs;

  RxString employeeType = 'HOSTELLER'.obs;

  /// IMAGE
  Rx<File?> selectedImage = Rx<File?>(null);

  /// LOADING
  RxBool isLoading = false.obs;

  /// PICK IMAGE FROM CAMERA
  Future<void> pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,

        imageQuality: 70,
      );

      if (pickedFile != null) {
        selectedImage.value = File(pickedFile.path);
      }
    } catch (e) {
      print(e);

      Get.snackbar("Error", e.toString());
    }
  }

  /// CREATE EMPLOYEE
  Future<void> createEmployee() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      isLoading.value = true;

      final request = CreateEmployeeRequest(
        name: nameController.text.trim(),

        employeeType: employeeType.value,

        employeeRefId: int.tryParse(employeeRefIdController.text) ?? 0,

        deptId: deptId.value,

        doj: dojController.text.trim(),

        desigId: desigId.value,

        locationId: locationId.value,

        biometricId: biometricIdController.text.trim(),
      );

      /// CREATE EMPLOYEE
      final response = await EmployeeService.createEmployee(
        data: request.toJson(),
      );

      print("CREATE RESPONSE => ${response.data}");

      /// EMPLOYEE ID
      final employeeId = response.data['id'];

      /// UPLOAD PHOTO
      if (selectedImage.value != null) {
        await EmployeeService.uploadEmployeePhoto(
          employeeId: employeeId,

          filePath: selectedImage.value!.path,
        );

        print("PHOTO UPLOADED SUCCESS");
      }

      Get.snackbar(
        "Success",

        "Employee Added Successfully",

        snackPosition: SnackPosition.BOTTOM,
      );

      await Future.delayed(const Duration(milliseconds: 500));

      Get.back(result: true);
    } catch (e) {
      print("CREATE ERROR => $e");

      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();

    employeeRefIdController.dispose();

    biometricIdController.dispose();

    dojController.dispose();

    super.onClose();
  }
}
