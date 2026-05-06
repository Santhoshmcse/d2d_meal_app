import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:image_picker/image_picker.dart';

import '../models/employee_model.dart';

import '../services/employee_service.dart';

class EditEmployeeController
    extends GetxController {

  final EmployeeModel employee;

  EditEmployeeController({
    required this.employee,
  });

  final formKey =
  GlobalKey<FormState>();

  /// TEXT CONTROLLERS
  late TextEditingController
  employeeCodeController;

  late TextEditingController
  employeeNameController;

  late TextEditingController
  biometricIdController;

  late TextEditingController
  dojController;

  /// DROPDOWNS
  late RxInt departmentId;

  late RxInt designationId;

  late RxInt locationId;

  late RxString employeeType;

  late RxBool isActive;

  /// IMAGE
  Rx<File?> selectedImage =
  Rx<File?>(null);

  /// LOADING
  RxBool isLoading = false.obs;

  @override
  void onInit() {

    super.onInit();

    employeeCodeController =
        TextEditingController(
          text: employee.employeeCode,
        );

    employeeNameController =
        TextEditingController(
          text: employee.name,
        );

    biometricIdController =
        TextEditingController(
          text:
          employee.biometricId ?? '',
        );

    dojController =
        TextEditingController(
          text: employee.doj,
        );

    departmentId =
        employee.deptId.obs;

    designationId =
        employee.desigId.obs;

    locationId =
        employee.locationId.obs;

    employeeType =
        employee.employeeType.obs;

    isActive =
        employee.active.obs;
  }

  /// PICK IMAGE
  Future<void> pickImage() async {

    try {

      final pickedFile =
      await ImagePicker()
          .pickImage(

        source: ImageSource.camera,

        imageQuality: 70,
      );

      if (pickedFile != null) {

        selectedImage.value =
            File(pickedFile.path);
      }

    } catch (e) {

      print(e);

      Get.snackbar(
        "Error",
        e.toString(),
      );
    }
  }

  /// UPDATE EMPLOYEE
  Future<void> updateEmployee() async {

    if (!formKey.currentState!
        .validate()) {

      return;
    }

    try {

      isLoading.value = true;

      final data = {

        "employeeCode":
        employeeCodeController
            .text
            .trim(),

        "name":
        employeeNameController
            .text
            .trim(),

        "employeeType":
        employeeType.value,

        "active":
        isActive.value,

        "biometricId":
        biometricIdController
            .text
            .trim(),

        "doj":
        dojController.text.trim(),

        "deptId":
        departmentId.value,

        "desigId":
        designationId.value,

        "locationId":
        locationId.value,
      };

      /// UPDATE EMPLOYEE
      await EmployeeService
          .updateEmployee(

        id: employee.id,

        data: data,
      );

      /// UPDATE PHOTO
      if (selectedImage.value !=
          null) {

        await EmployeeService
            .uploadEmployeePhoto(

          employeeId: employee.id,

          filePath:
          selectedImage
              .value!
              .path,
        );

        print(
          "PHOTO UPDATED SUCCESS",
        );
      }

      Get.snackbar(

        "Success",

        "Employee Updated Successfully",

        snackPosition:
        SnackPosition.BOTTOM,
      );

      await Future.delayed(
        const Duration(
          milliseconds: 500,
        ),
      );

      Get.back(result: true);

    } catch (e) {

      print(
        "UPDATE ERROR => $e",
      );

      Get.snackbar(

        "Error",

        e.toString(),

        snackPosition:
        SnackPosition.BOTTOM,
      );

    } finally {

      isLoading.value = false;
    }
  }

  /// TOGGLE STATUS
  void toggleStatus(bool value) {

    isActive.value = value;
  }

  @override
  void onClose() {

    employeeCodeController
        .dispose();

    employeeNameController
        .dispose();

    biometricIdController
        .dispose();

    dojController.dispose();

    super.onClose();
  }
}