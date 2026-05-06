class EmployeeModel {

  final int id;

  final String employeeCode;

  final String name;

  final int deptId;

  final String? deptName;

  final int desigId;

  final String? desigName;

  final int locationId;

  final String? locationName;

  final String employeeType;

  final String? photoUrl;

  final String doj;

  final int employeeRefId;

  final String? biometricId;

  final bool active;

  EmployeeModel({

    required this.id,

    required this.employeeCode,

    required this.name,

    required this.deptId,

    this.deptName,

    required this.desigId,

    this.desigName,

    required this.locationId,

    this.locationName,

    required this.employeeType,

    this.photoUrl,

    required this.doj,

    required this.employeeRefId,

    this.biometricId,

    required this.active,
  });

  factory EmployeeModel.fromJson(
      Map<String, dynamic> json) {

    return EmployeeModel(

      id: json['id'] ?? 0,

      employeeCode:
      json['employeeCode'] ?? '',

      name:
      json['name'] ?? '',

      deptId:
      json['deptId'] ?? 0,

      deptName:
      json['deptName'],

      desigId:
      json['desigId'] ?? 0,

      desigName:
      json['desigName'],

      locationId:
      json['locationId'] ?? 0,

      locationName:
      json['locationName'],

      employeeType:
      json['employeeType'] ?? '',

      photoUrl:
      json['photoUrl'],

      doj:
      json['doj'] ?? '',

      employeeRefId:
      json['employeeRefId'] ?? 0,

      biometricId:
      json['biometricId'],

      active:
      json['active'] ?? false,
    );
  }
}