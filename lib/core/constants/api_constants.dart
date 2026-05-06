class ApiConstants {
  static const String baseUrl =
      'https://d2d-api-stage-500330630733.asia-south1.run.app';

  /// AUTH
  static const String login = '/api/v1/auth/login';

  /// EMPLOYEES
  static const String employees = '/api/admin/employees/paginated';

  static const String createEmployee = '/api/admin/employees';

  static const String searchEmployees = '/api/admin/employees/search';

  /// MASTERS
  static const String departments = '/api/departments';

  static const String designations = '/api/v1/designations';

  static const String locations = '/api/locations';
}
