import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/employee_model.dart';
import '../services/employee_service.dart';

class EmployeeController extends GetxController {

  final ScrollController scrollController =
  ScrollController();

  final TextEditingController searchController =
  TextEditingController();

  RxList<EmployeeModel> employees =
      <EmployeeModel>[].obs;

  RxList<EmployeeModel> filteredEmployees =
      <EmployeeModel>[].obs;

  RxBool isLoading = true.obs;

  RxBool isLoadMore = false.obs;

  int currentPage = 0;

  final int pageSize = 500;

  RxBool hasMore = true.obs;

  @override
  void onInit() {

    super.onInit();

    loadEmployees();

    scrollController.addListener(() {

      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200 &&
          !isLoadMore.value &&
          hasMore.value) {

        loadMoreEmployees();
      }
    });
  }

  /// Initial Load
  Future<void> loadEmployees() async {

    try {

      isLoading.value = true;

      final data =
      await EmployeeService.getEmployees(

        page: currentPage,

        size: pageSize,
      );

      employees.value = data;

      filteredEmployees.value = data;

      if (data.length < pageSize) {
        hasMore.value = false;
      }

    } catch (e) {

      Get.snackbar(
        "Error",
        e.toString(),
      );

    } finally {

      isLoading.value = false;
    }
  }

  /// Pagination
  Future<void> loadMoreEmployees() async {

    isLoadMore.value = true;

    currentPage++;

    try {

      final data =
      await EmployeeService.getEmployees(

        page: currentPage,

        size: pageSize,
      );

      if (data.isEmpty) {

        hasMore.value = false;

      } else {

        employees.addAll(data);

        filteredEmployees.value =
            employees.toList();
      }

    } catch (e) {

      Get.snackbar(
        "Error",
        e.toString(),
      );

    } finally {

      isLoadMore.value = false;
    }
  }

  /// Search
  Future<void> searchEmployee(
      String value) async {

    if (value.trim().isEmpty) {

      filteredEmployees.value =
          employees;

      return;
    }

    try {

      final data =
      await EmployeeService
          .searchEmployees(

        keyword: value,
      );

      filteredEmployees.value =
          data;

    } catch (e) {

      Get.snackbar(
        "Error",
        e.toString(),
      );
    }
  }

  /// Refresh
  Future<void> refreshEmployees() async {

    currentPage = 0;

    hasMore.value = true;

    employees.clear();

    filteredEmployees.clear();

    await loadEmployees();
  }

  @override
  void onClose() {

    scrollController.dispose();

    searchController.dispose();

    super.onClose();
  }
}