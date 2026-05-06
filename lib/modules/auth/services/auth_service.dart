import 'package:dio/dio.dart';

import 'package:d2d_meal_app/core/constants/api_constants.dart';
import 'package:d2d_meal_app/core/network/api_service.dart';

class AuthService {

  static Future<Response> login({

    required String email,
    required String password,

  }) async {

    return await ApiService.dio.post(

      ApiConstants.login,

      data: {

        "email": email,

        "password": password,
      },
    );
  }
}