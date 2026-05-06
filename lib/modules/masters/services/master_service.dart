import 'package:d2d_meal_app/core/constants/api_constants.dart';

import 'package:d2d_meal_app/core/network/api_service.dart';

import 'package:d2d_meal_app/modules/masters/models/department_model.dart';

import 'package:d2d_meal_app/modules/masters/models/designation_model.dart';

import 'package:d2d_meal_app/modules/masters/models/location_model.dart';

class MasterService {

  /// Departments
  static Future<List<DepartmentModel>>
  getDepartments() async {

    final response =
    await ApiService.dio.get(

      ApiConstants.departments,

      queryParameters: {

        'page': 0,

        'size': 100,
      },
    );

    final List data =
    response.data['content'];

    return data.map(

          (e) =>
          DepartmentModel.fromJson(e),

    ).toList();
  }

  /// Designations
  static Future<List<DesignationModel>>
  getDesignations() async {

    final response =
    await ApiService.dio.get(

      ApiConstants.designations,

      queryParameters: {

        'page': 0,

        'size': 100,
      },
    );

    final List data =
    response.data['content'];

    return data.map(

          (e) =>
          DesignationModel.fromJson(e),

    ).toList();
  }

  /// Locations
  static Future<List<LocationModel>>
  getLocations() async {

    final response =
    await ApiService.dio.get(

      ApiConstants.locations,

      queryParameters: {

        'page': 0,

        'size': 100,
      },
    );

    final List data =
    response.data['content'];

    return data.map(

          (e) =>
          LocationModel.fromJson(e),

    ).toList();
  }
}