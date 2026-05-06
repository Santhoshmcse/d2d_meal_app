import 'package:dio/dio.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:d2d_meal_app/core/constants/api_constants.dart';

class ApiService {

  static final Dio dio = Dio(

    BaseOptions(

      baseUrl: ApiConstants.baseUrl,

      connectTimeout:
      const Duration(seconds: 30),

      receiveTimeout:
      const Duration(seconds: 30),

      headers: {

        'Content-Type':
        'application/json',
      },
    ),
  );

  static void setInterceptor() {

    dio.interceptors.add(

      InterceptorsWrapper(

        onRequest:
            (options, handler) async {

          final prefs =
          await SharedPreferences
              .getInstance();

          final token =
          prefs.getString('token');

          print(token);

          if (token != null) {

            options.headers[
            'Authorization'
            ] = 'Bearer $token';
          }

          return handler.next(options);
        },
      ),
    );
  }
}