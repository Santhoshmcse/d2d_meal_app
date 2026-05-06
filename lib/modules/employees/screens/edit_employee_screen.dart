import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

import 'package:d2d_meal_app/modules/employees/models/employee_model.dart';

import 'package:d2d_meal_app/modules/employees/services/employee_service.dart';

import 'package:d2d_meal_app/modules/masters/models/department_model.dart';

import 'package:d2d_meal_app/modules/masters/models/designation_model.dart';

import 'package:d2d_meal_app/modules/masters/models/location_model.dart';

import 'package:d2d_meal_app/modules/masters/services/master_service.dart';

class EditEmployeeScreen
    extends StatefulWidget {

  final EmployeeModel employee;

  const EditEmployeeScreen({

    super.key,

    required this.employee,
  });

  @override
  State<EditEmployeeScreen>
  createState() =>
      _EditEmployeeScreenState();
}

class _EditEmployeeScreenState
    extends State<EditEmployeeScreen> {

  late TextEditingController
  nameController;

  late TextEditingController
  biometricController;

  late TextEditingController
  dojController;

  bool isLoading = false;

  /// IMAGE
  File? selectedImage;

  /// Dropdown Data
  List<DepartmentModel>
  departments = [];

  List<DesignationModel>
  designations = [];

  List<LocationModel>
  locations = [];

  /// Selected Values
  int? selectedDeptId;

  int? selectedDesigId;

  int? selectedLocationId;

  String employeeType =
      "STAFF";

  bool active = true;

  @override
  void initState() {

    super.initState();

    nameController =
        TextEditingController(

          text: widget.employee.name,
        );

    biometricController =
        TextEditingController(

          text:
          widget.employee
              .biometricId ??
              '',
        );

    dojController =
        TextEditingController(

          text: widget.employee.doj,
        );

    selectedDeptId =
        widget.employee.deptId;

    selectedDesigId =
        widget.employee.desigId;

    selectedLocationId =
        widget.employee.locationId;

    employeeType =
        widget.employee
            .employeeType;

    active =
        widget.employee.active;

    loadMasters();
  }

  /// PICK IMAGE
  Future<void> pickImage() async {

    try {

      final pickedFile =
      await ImagePicker()
          .pickImage(

        source:
        ImageSource.camera,

        imageQuality: 70,
      );

      if (pickedFile != null) {

        setState(() {

          selectedImage =
              File(
                pickedFile.path,
              );
        });
      }

    } catch (e) {

      print(e);
    }
  }

  Future<void> loadMasters() async {

    try {

      departments =
      await MasterService
          .getDepartments();

      designations =
      await MasterService
          .getDesignations();

      locations =
      await MasterService
          .getLocations();

      setState(() {});

    } catch (e) {

      print(e);
    }
  }

  Future<void>
  updateEmployee() async {

    setState(() {

      isLoading = true;
    });

    try {

      /// UPDATE EMPLOYEE
      await EmployeeService
          .updateEmployee(

        id:
        widget.employee.id,

        data: {

          "name":
          nameController.text,

          "deptId":
          selectedDeptId,

          "desigId":
          selectedDesigId,

          "employeeType":
          employeeType,

          "doj":
          dojController.text,

          "employeeRefId":
          widget.employee.id,

          "locationId":
          selectedLocationId,

          "biometricId":
          biometricController
              .text,

          "active":
          active,
        },
      );

      /// UPDATE PHOTO
      if (selectedImage !=
          null) {

        await EmployeeService
            .uploadEmployeePhoto(

          employeeId:
          widget.employee.id,

          filePath:
          selectedImage!
              .path,
        );
      }

      if (mounted) {

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(

          const SnackBar(

            content: Text(
              "Employee Updated",
            ),
          ),
        );

        Navigator.pop(
          context,
          true,
        );
      }

    } catch (e) {

      print(e);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(

        const SnackBar(

          content: Text(
            "Update Failed",
          ),
        ),
      );
    }

    setState(() {

      isLoading = false;
    });
  }

  @override
  Widget build(
      BuildContext context,
      ) {

    return Scaffold(

      appBar: AppBar(

        title: const Text(
          "Edit Employee",
        ),
      ),

      body:
      SingleChildScrollView(

        padding:
        const EdgeInsets.all(
          16,
        ),

        child: Column(

          children: [

            /// PHOTO
            Column(
              children: [

                GestureDetector(

                  onTap:
                  pickImage,

                  child:
                  CircleAvatar(

                    radius: 55,

                    backgroundColor:
                    Colors.grey
                        .shade300,

                    backgroundImage:

                    selectedImage !=
                        null

                        ? FileImage(
                      selectedImage!,
                    )

                        : widget.employee
                        .photoUrl !=
                        null &&
                        widget
                            .employee
                            .photoUrl!
                            .isNotEmpty

                        ? NetworkImage(
                      widget
                          .employee
                          .photoUrl!,
                    )

                        : null,

                    child:

                    selectedImage ==
                        null &&
                        (widget.employee.photoUrl ==
                            null ||
                            widget
                                .employee
                                .photoUrl!
                                .isEmpty)

                        ? const Icon(
                      Icons
                          .camera_alt,

                      size: 40,
                    )

                        : null,
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                TextButton.icon(

                  onPressed:
                  pickImage,

                  icon: const Icon(
                    Icons.camera_alt,
                  ),

                  label: Text(

                    widget.employee
                        .photoUrl ==
                        null ||
                        widget
                            .employee
                            .photoUrl!
                            .isEmpty

                        ? "Upload Photo"

                        : "Update Photo",
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 20,
            ),

            /// Name
            TextField(

              controller:
              nameController,

              decoration:
              const InputDecoration(

                labelText:
                "Employee Name",
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            /// Department
            DropdownButtonFormField<
                int>(

              value:
              selectedDeptId,

              decoration:
              const InputDecoration(

                labelText:
                "Department",
              ),

              items:
              departments.map((
                  dept,
                  ) {

                return DropdownMenuItem(

                  value: dept.id,

                  child: Text(
                    dept.name,
                  ),
                );

              }).toList(),

              onChanged: (value) {

                setState(() {

                  selectedDeptId =
                      value;
                });
              },
            ),

            const SizedBox(
              height: 20,
            ),

            /// Designation
            DropdownButtonFormField<
                int>(

              value:
              selectedDesigId,

              decoration:
              const InputDecoration(

                labelText:
                "Designation",
              ),

              items:
              designations.map((
                  desig,
                  ) {

                return DropdownMenuItem(

                  value: desig.id,

                  child: Text(
                    desig.name,
                  ),
                );

              }).toList(),

              onChanged: (value) {

                setState(() {

                  selectedDesigId =
                      value;
                });
              },
            ),

            const SizedBox(
              height: 20,
            ),

            /// Location
            DropdownButtonFormField<
                int>(

              value:
              selectedLocationId,

              decoration:
              const InputDecoration(

                labelText:
                "Location",
              ),

              items:
              locations.map((
                  location,
                  ) {

                return DropdownMenuItem(

                  value:
                  location.id,

                  child: Text(
                    location.name,
                  ),
                );

              }).toList(),

              onChanged: (value) {

                setState(() {

                  selectedLocationId =
                      value;
                });
              },
            ),

            const SizedBox(
              height: 20,
            ),

            /// Employee Type
            DropdownButtonFormField<
                String>(

              value:
              employeeType,

              decoration:
              const InputDecoration(

                labelText:
                "Employee Type",
              ),

              items: const [

                DropdownMenuItem(

                  value: "STAFF",

                  child:
                  Text("STAFF"),
                ),

                DropdownMenuItem(

                  value:
                  "HOSTELLER",

                  child: Text(
                    "HOSTELLER",
                  ),
                ),

                DropdownMenuItem(

                  value:
                  "WORKER",

                  child:
                  Text("WORKER"),
                ),
              ],

              onChanged: (value) {

                setState(() {

                  employeeType =
                  value!;
                });
              },
            ),

            const SizedBox(
              height: 20,
            ),

            /// DOJ
            TextField(

              controller:
              dojController,

              decoration:
              const InputDecoration(

                labelText: "DOJ",
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            /// Biometric ID
            TextField(

              controller:
              biometricController,

              decoration:
              const InputDecoration(

                labelText:
                "Biometric ID",
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            /// Active
            SwitchListTile(

              value: active,

              title:
              const Text(
                "Active",
              ),

              onChanged: (value) {

                setState(() {

                  active = value;
                });
              },
            ),

            const SizedBox(
              height: 30,
            ),

            /// Update Button
            SizedBox(

              width:
              double.infinity,

              height: 55,

              child:
              ElevatedButton(

                onPressed:

                isLoading
                    ? null
                    : updateEmployee,

                child:

                isLoading

                    ? const CircularProgressIndicator(
                  color:
                  Colors.white,
                )

                    : const Text(
                  "UPDATE",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}