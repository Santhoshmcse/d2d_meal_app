import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/add_employee_controller.dart';

import 'employee_dropdown.dart';

import 'employee_textfield.dart';

class EmployeeFormWidget
    extends StatelessWidget {

  const EmployeeFormWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    final controller =
    Get.find<AddEmployeeController>();

    return Form(

      key: controller.formKey,

      child: Column(
        children: [

          /// PHOTO
          Obx(
                () => Column(
              children: [

                GestureDetector(

                  onTap:
                  controller.pickImage,

                  child: CircleAvatar(

                    radius: 55,

                    backgroundColor:
                    Colors.grey.shade300,

                    backgroundImage:

                    controller.selectedImage
                        .value !=
                        null

                        ? FileImage(
                      controller
                          .selectedImage
                          .value!,
                    )

                        : null,

                    child:

                    controller.selectedImage
                        .value ==
                        null

                        ? const Icon(
                      Icons.camera_alt,
                      size: 40,
                      color:
                      Colors.black54,
                    )

                        : null,
                  ),
                ),

                const SizedBox(height: 10),

                TextButton.icon(

                  onPressed:
                  controller.pickImage,

                  icon: const Icon(
                    Icons.camera_alt,
                  ),

                  label: Text(

                    controller.selectedImage
                        .value ==
                        null

                        ? "Capture Photo"

                        : "Update Photo",
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),

          /// NAME
          EmployeeTextField(

            controller:
            controller.nameController,

            label: "Employee Name",

            validator: (value) {

              if (value == null ||
                  value.trim().isEmpty) {

                return "Employee Name Required";
              }

              return null;
            },
          ),

          /// EMPLOYEE REF ID
          EmployeeTextField(

            controller:
            controller
                .employeeRefIdController,

            label: "Employee Ref ID",

            validator: (value) {

              if (value == null ||
                  value.trim().isEmpty) {

                return "Employee Ref ID Required";
              }

              return null;
            },
          ),

          /// BIOMETRIC ID
          EmployeeTextField(

            controller:
            controller
                .biometricIdController,

            label: "Biometric ID",

            validator: (value) {

              if (value == null ||
                  value.trim().isEmpty) {

                return "Biometric ID Required";
              }

              return null;
            },
          ),

          /// DOJ
          EmployeeTextField(

            controller:
            controller.dojController,

            label: "DOJ (YYYY-MM-DD)",

            validator: (value) {

              if (value == null ||
                  value.trim().isEmpty) {

                return "DOJ Required";
              }

              return null;
            },
          ),

          /// DEPARTMENT
          Obx(
                () => EmployeeDropdown(

              label: "Department",

              value:
              controller.deptId.value,

              items: const [

                DropdownMenuItem(
                  value: 1,
                  child: Text("GENERAL"),
                ),

                DropdownMenuItem(
                  value: 16,
                  child: Text("CUTTING"),
                ),

                DropdownMenuItem(
                  value: 17,
                  child: Text("TAILORING"),
                ),

                DropdownMenuItem(
                  value: 19,
                  child: Text("HOSTEL"),
                ),
              ],

              onChanged: (value) {

                controller.deptId.value =
                value!;
              },
            ),
          ),

          /// DESIGNATION
          Obx(
                () => EmployeeDropdown(

              label: "Designation",

              value:
              controller.desigId.value,

              items: const [

                DropdownMenuItem(
                  value: 12,
                  child: Text("HELPER"),
                ),

                DropdownMenuItem(
                  value: 27,
                  child: Text("TAILOR"),
                ),

                DropdownMenuItem(
                  value: 75,
                  child: Text("HOSTEL STAFF"),
                ),
              ],

              onChanged: (value) {

                controller.desigId.value =
                value!;
              },
            ),
          ),

          /// LOCATION
          Obx(
                () => EmployeeDropdown(

              label: "Location",

              value:
              controller.locationId.value,

              items: const [

                DropdownMenuItem(
                  value: 1,
                  child: Text("MAIN"),
                ),
              ],

              onChanged: (value) {

                controller.locationId.value =
                value!;
              },
            ),
          ),

          /// EMPLOYEE TYPE
          Obx(
                () {

              final employeeTypes = [

                "HOSTELLER",
                "STAFF",
                "WORKER",
              ];

              /// fallback
              if (!employeeTypes.contains(
                controller.employeeType.value,
              )) {

                controller.employeeType.value =
                "HOSTELLER";
              }

              return DropdownButtonFormField<
                  String>(

                value:
                controller
                    .employeeType.value,

                decoration: InputDecoration(

                  labelText:
                  "Employee Type",

                  border:
                  OutlineInputBorder(

                    borderRadius:
                    BorderRadius.circular(
                      12,
                    ),
                  ),
                ),

                items:

                employeeTypes.map((type) {

                  return DropdownMenuItem<
                      String>(

                    value: type,

                    child: Text(type),
                  );

                }).toList(),

                onChanged: (value) {

                  if (value != null) {

                    controller
                        .employeeType.value =
                        value;
                  }
                },
              );
            },
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}