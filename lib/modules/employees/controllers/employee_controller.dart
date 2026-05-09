import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../models/employee_model.dart';
import '../models/create_employee_request.dart';
import '../services/employee_service.dart';

// ═══════════════════════════════════════════════════════════════════════════
//  1.  EmployeeController  —  List screen (search, paginate, delete, toggle)
// ═══════════════════════════════════════════════════════════════════════════

class EmployeeController extends GetxController {

  final ScrollController scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();

  final RxList<EmployeeModel> employees         = <EmployeeModel>[].obs;
  final RxList<EmployeeModel> filteredEmployees = <EmployeeModel>[].obs;

  final RxBool   isLoading    = true.obs;
  final RxBool   isLoadMore   = false.obs;
  final RxBool   hasMore      = true.obs;
  final RxString errorMessage = ''.obs;
  final RxBool   hasSearchText = false.obs; // ✅ tracks search bar clear button

  int currentPage = 0;
  static const int pageSize = 20;

  @override
  void onInit() {
    super.onInit();
    loadEmployees();
    scrollController.addListener(() {
      final pos = scrollController.position;
      if (pos.pixels >= pos.maxScrollExtent - 200 &&
          !isLoadMore.value &&
          hasMore.value &&
          errorMessage.value.isEmpty) {
        loadMoreEmployees();
      }
    });
  }

  Future<void> loadEmployees() async {
    try {
      isLoading.value    = true;
      errorMessage.value = '';
      currentPage        = 0;
      hasMore.value      = true;
      final data = await EmployeeService.getEmployees(page: 0, size: pageSize);
      employees.value         = data;
      filteredEmployees.value = data;
      if (data.length < pageSize) hasMore.value = false;
    } catch (e) {
      errorMessage.value = _friendlyError(e);
      _showError(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMoreEmployees() async {
    isLoadMore.value = true;
    currentPage++;
    try {
      final data = await EmployeeService.getEmployees(page: currentPage, size: pageSize);
      if (data.isEmpty) {
        hasMore.value = false;
      } else {
        employees.addAll(data);
        if (searchController.text.trim().isEmpty) {
          filteredEmployees.value = List.from(employees);
        }
      }
    } catch (e) {
      currentPage--;
      _showError(_friendlyError(e));
    } finally {
      isLoadMore.value = false;
    }
  }

  Future<void> refreshEmployees() async {
    searchController.clear();
    await loadEmployees();
  }

  Future<void> searchEmployee(String value) async {
    hasSearchText.value = value.isNotEmpty; // ✅ update Rx flag
    if (value.trim().isEmpty) {
      filteredEmployees.value = List.from(employees);
      return;
    }
    try {
      final data = await EmployeeService.searchEmployees(keyword: value);
      filteredEmployees.value = data;
    } catch (e) {
      _showError(_friendlyError(e));
    }
  }

  Future<void> deleteEmployee(int id) async {
    try {
      await EmployeeService.deleteEmployee(id: id);
      employees.removeWhere((e) => e.id == id);
      filteredEmployees.removeWhere((e) => e.id == id);
      _showSuccess('Employee deleted successfully');
    } catch (e) {
      _showError(_friendlyError(e));
    }
  }

  Future<void> toggleEmployeeStatus(EmployeeModel employee) async {
    try {
      await EmployeeService.toggleEmployeeStatus(id: employee.id);
      final updated = EmployeeModel(
        id: employee.id, employeeCode: employee.employeeCode,
        name: employee.name, deptId: employee.deptId, deptName: employee.deptName,
        desigId: employee.desigId, desigName: employee.desigName,
        locationId: employee.locationId, locationName: employee.locationName,
        employeeType: employee.employeeType, photoUrl: employee.photoUrl,
        doj: employee.doj, employeeRefId: employee.employeeRefId,
        biometricId: employee.biometricId, active: !employee.active,
      );
      _replaceIn(employees, updated);
      _replaceIn(filteredEmployees, updated);
      _showSuccess(updated.active
          ? '${employee.name} marked as Active'
          : '${employee.name} marked as Inactive');
    } catch (e) {
      _showError(_friendlyError(e));
    }
  }

  void _replaceIn(RxList<EmployeeModel> list, EmployeeModel updated) {
    final idx = list.indexWhere((e) => e.id == updated.id);
    if (idx != -1) list[idx] = updated;
  }

  @override
  void onClose() {
    scrollController.dispose();
    searchController.dispose();
    super.onClose();
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  2.  AddEmployeeController  —  Add screen
// ═══════════════════════════════════════════════════════════════════════════

class AddEmployeeController extends GetxController {

  final formKey = GlobalKey<FormState>();

  final nameController          = TextEditingController();
  final employeeRefIdController = TextEditingController();
  final biometricIdController   = TextEditingController();
  final dojController           = TextEditingController();

  RxInt    deptId       = 1.obs;
  RxInt    desigId      = 12.obs;
  RxInt    locationId   = 1.obs;
  RxString employeeType = 'HOSTELLER'.obs;

  Rx<File?> selectedImage = Rx<File?>(null);
  RxBool    isLoading     = false.obs;

  Future<void> pickImage() async {
    try {
      final picked = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 70,
      );
      if (picked != null) selectedImage.value = File(picked.path);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> createEmployee() async {
    if (!formKey.currentState!.validate()) return;
    try {
      isLoading.value = true;
      final request = CreateEmployeeRequest(
        name:          nameController.text.trim(),
        employeeType:  employeeType.value,
        employeeRefId: int.tryParse(employeeRefIdController.text) ?? 0,
        deptId:        deptId.value,
        doj:           dojController.text.trim(),
        desigId:       desigId.value,
        locationId:    locationId.value,
        biometricId:   biometricIdController.text.trim(),
      );
      final response = await EmployeeService.createEmployee(data: request.toJson());
      final employeeId = response.data['id'];
      if (selectedImage.value != null) {
        await EmployeeService.uploadEmployeePhoto(
          employeeId: employeeId,
          filePath:   selectedImage.value!.path,
        );
      }
      Get.snackbar("Success", "Employee Added Successfully",
          snackPosition: SnackPosition.BOTTOM);
      await Future.delayed(const Duration(milliseconds: 500));
      Get.back(result: true);
    } catch (e) {
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

// ═══════════════════════════════════════════════════════════════════════════
//  3.  EditEmployeeController  —  Edit screen
// ═══════════════════════════════════════════════════════════════════════════

class EditEmployeeController extends GetxController {

  final EmployeeModel employee;
  EditEmployeeController({required this.employee});

  final formKey = GlobalKey<FormState>();

  late TextEditingController employeeCodeController;
  late TextEditingController employeeNameController;
  late TextEditingController biometricIdController;
  late TextEditingController dojController;

  late RxInt    departmentId;
  late RxInt    designationId;
  late RxInt    locationId;
  late RxString employeeType;
  late RxBool   isActive;

  Rx<File?> selectedImage = Rx<File?>(null);
  RxBool    isLoading     = false.obs;

  @override
  void onInit() {
    super.onInit();
    employeeCodeController = TextEditingController(text: employee.employeeCode);
    employeeNameController = TextEditingController(text: employee.name);
    biometricIdController  = TextEditingController(text: employee.biometricId ?? '');
    dojController          = TextEditingController(text: employee.doj);
    departmentId  = employee.deptId.obs;
    designationId = employee.desigId.obs;
    locationId    = employee.locationId.obs;
    employeeType  = employee.employeeType.obs;
    isActive      = employee.active.obs;
  }

  Future<void> pickImage() async {
    try {
      final picked = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 70,
      );
      if (picked != null) selectedImage.value = File(picked.path);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  void toggleStatus(bool value) => isActive.value = value;

  Future<void> updateEmployee() async {
    if (!formKey.currentState!.validate()) return;
    try {
      isLoading.value = true;
      await EmployeeService.updateEmployee(
        id: employee.id,
        data: {
          "employeeCode": employeeCodeController.text.trim(),
          "name":         employeeNameController.text.trim(),
          "employeeType": employeeType.value,
          "active":       isActive.value,
          "biometricId":  biometricIdController.text.trim(),
          "doj":          dojController.text.trim(),
          "deptId":       departmentId.value,
          "desigId":      designationId.value,
          "locationId":   locationId.value,
        },
      );
      if (selectedImage.value != null) {
        await EmployeeService.uploadEmployeePhoto(
          employeeId: employee.id,
          filePath:   selectedImage.value!.path,
        );
      }
      Get.snackbar("Success", "Employee Updated Successfully",
          snackPosition: SnackPosition.BOTTOM);
      await Future.delayed(const Duration(milliseconds: 500));
      Get.back(result: true);
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    employeeCodeController.dispose();
    employeeNameController.dispose();
    biometricIdController.dispose();
    dojController.dispose();
    super.onClose();
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  Shared helpers  (private to this file)
// ═══════════════════════════════════════════════════════════════════════════

String _friendlyError(Object e) {
  final msg = e.toString();
  if (msg.contains('SocketException') || msg.contains('Connection'))
    return 'No internet connection.';
  if (msg.contains('401')) return 'Session expired. Please login again.';
  if (msg.contains('403')) return 'You do not have permission.';
  if (msg.contains('404')) return 'Resource not found.';
  if (msg.contains('500')) return 'Server error. Please try again later.';
  return 'Something went wrong. Please try again.';
}

void _showError(String message) {
  Get.snackbar('Error', message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.colorScheme.errorContainer,
      colorText: Get.theme.colorScheme.onErrorContainer,
      icon: const Icon(Icons.error_outline_rounded),
      duration: const Duration(seconds: 4),
      margin: const EdgeInsets.all(12),
      borderRadius: 10);
}

void _showSuccess(String message) {
  Get.snackbar('Success', message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade100,
      colorText: Colors.green.shade900,
      icon: const Icon(Icons.check_circle_outline_rounded, color: Colors.green),
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(12),
      borderRadius: 10);
}