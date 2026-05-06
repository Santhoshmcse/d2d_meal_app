class CreateEmployeeRequest {

  final String name;

  final String employeeType;

  final int employeeRefId;

  final int deptId;

  final String doj;

  final int desigId;

  final int locationId;

  final String biometricId;

  CreateEmployeeRequest({

    required this.name,

    required this.employeeType,

    required this.employeeRefId,

    required this.deptId,

    required this.doj,

    required this.desigId,

    required this.locationId,

    required this.biometricId,
  });

  Map<String, dynamic> toJson() {

    return {

      "name": name,

      "employeeType": employeeType,

      "employeeRefId": employeeRefId,

      "deptId": deptId,

      "doj": doj,

      "desigId": desigId,

      "locationId": locationId,

      "biometricId": biometricId,
    };
  }
}