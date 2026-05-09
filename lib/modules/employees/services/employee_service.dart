import 'package:dio/dio.dart';

import 'package:d2d_meal_app/core/constants/api_constants.dart';
import 'package:d2d_meal_app/core/network/api_service.dart';
import 'package:d2d_meal_app/modules/employees/models/employee_model.dart';

class EmployeeService {
  // ─── READ ─────────────────────────────────────────────────────────────────

  static Future<List<EmployeeModel>> getEmployees({
    int page = 0,
    int size = 20,
  }) async {
    final response = await ApiService.dio.get(
      ApiConstants.employees,
      queryParameters: {
        'page': page,
        'size': size,
        'sort': 'id',
      },
    );
    final List data = response.data['content'];
    return data.map((e) => EmployeeModel.fromJson(e)).toList();
  }

  static Future<List<EmployeeModel>> searchEmployees({
    required String keyword,
    int page = 0,
    int size = 20,
  }) async {
    final response = await ApiService.dio.get(
      ApiConstants.searchEmployees,
      queryParameters: {
        'keyword': keyword,
        'page': page,
        'size': size,
        'sort': 'id',
      },
    );
    final List data = response.data['content'];
    return data.map((e) => EmployeeModel.fromJson(e)).toList();
  }

  // ─── CREATE ───────────────────────────────────────────────────────────────

  static Future<Response> createEmployee({
    required Map<String, dynamic> data,
  }) async {
    return ApiService.dio.post(
      ApiConstants.createEmployee,
      data: data,
    );
  }

  // ─── UPDATE ───────────────────────────────────────────────────────────────

  static Future<void> updateEmployee({
    required int id,
    required Map<String, dynamic> data,
  }) async {
    await ApiService.dio.put(
      '${ApiConstants.createEmployee}/$id',
      data: data,
    );
  }

  // ─── DELETE ───────────────────────────────────────────────────────────────

  static Future<void> deleteEmployee({required int id}) async {
    await ApiService.dio.delete('${ApiConstants.createEmployee}/$id');
  }

  // ─── TOGGLE ACTIVE ────────────────────────────────────────────────────────

  /// Toggles the employee's active status.
  /// Sends a PATCH request to /api/admin/employees/{id}/toggle
  static Future<void> toggleEmployeeStatus({required int id}) async {
    await ApiService.dio.patch(
      '${ApiConstants.createEmployee}/$id/toggle',
    );
  }

  // ─── PHOTO ────────────────────────────────────────────────────────────────

  static Future<void> uploadEmployeePhoto({
    required int employeeId,
    required String filePath,
  }) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath),
    });
    await ApiService.dio.post(
      '${ApiConstants.createEmployee}/$employeeId/photo',
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );
  }
}
