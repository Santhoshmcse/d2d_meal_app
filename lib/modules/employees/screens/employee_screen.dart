import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/employee_controller.dart';

import 'add_employee_screen.dart';

import 'edit_employee_screen.dart';

class EmployeeScreen extends StatelessWidget {

  EmployeeScreen({super.key});

  final EmployeeController controller =
  Get.put(EmployeeController());

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Employees"),
      ),

      floatingActionButton:
      FloatingActionButton(

        onPressed: () async {

          final result = await Get.to(
                () => AddEmployeeScreen(),
          );

          if (result == true) {

            controller.refreshEmployees();
          }
        },

        child: const Icon(Icons.add),
      ),

      body: Obx(() {

        if (controller.isLoading.value) {

          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Column(
          children: [

            /// Search
            Padding(
              padding: const EdgeInsets.all(12),

              child: TextField(
                controller:
                controller.searchController,

                onChanged:
                controller.searchEmployee,

                decoration: InputDecoration(
                  hintText: "Search Employee",

                  prefixIcon:
                  const Icon(Icons.search),

                  border: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            /// List
            Expanded(
              child: ListView.builder(

                controller:
                controller.scrollController,

                itemCount:
                controller.filteredEmployees
                    .length +
                    (controller.isLoadMore.value
                        ? 1
                        : 0),

                itemBuilder: (context, index) {

                  if (index ==
                      controller
                          .filteredEmployees
                          .length) {

                    return const Padding(
                      padding: EdgeInsets.all(20),

                      child: Center(
                        child:
                        CircularProgressIndicator(),
                      ),
                    );
                  }

                  final employee =
                  controller
                      .filteredEmployees[index];

                  return InkWell(

                    onTap: () async {

                      await Get.to(
                            () => EditEmployeeScreen(
                          employee: employee,
                        ),
                      );

                      controller.refreshEmployees();
                    },

                    child: Card(

                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),

                      elevation: 4,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),

                      child: Padding(
                        padding: const EdgeInsets.all(12),

                        child: Row(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,

                          children: [

                            /// Avatar
                            CircleAvatar(

                              radius: 28,

                              backgroundColor:
                              employee.active
                                  ? Colors.green
                                  : Colors.red,

                              backgroundImage:

                              employee.photoUrl != null &&
                                  employee.photoUrl!.isNotEmpty

                                  ? NetworkImage(
                                employee.photoUrl!,
                              )

                                  : null,

                              child:

                              employee.photoUrl == null ||

                                  employee.photoUrl!.isEmpty

                                  ? Text(

                                employee.name.isNotEmpty
                                    ? employee.name
                                    .substring(0, 1)

                                    : "?",

                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              )

                                  : null,
                            ),

                            const SizedBox(width: 15),

                            /// Details
                            Expanded(
                              child: Column(

                                crossAxisAlignment:
                                CrossAxisAlignment.start,

                                children: [

                                  Text(

                                    employee.name,

                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight:
                                      FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  Text(
                                    "Code : ${employee.employeeCode}",
                                  ),

                                  Text(
                                    "Type : ${employee.employeeType}",
                                  ),

                                  Text(
                                    "Department : ${employee.deptName}",
                                  ),

                                  Text(
                                    "Designation : ${employee.desigName}",
                                  ),

                                  Text(
                                    "Location : ${employee.locationName}",
                                  ),

                                  Text(
                                    "DOJ : ${employee.doj}",
                                  ),

                                  Text(
                                    "Biometric : ${employee.biometricId ?? '-'}",
                                  ),

                                  const SizedBox(height: 8),

                                  Row(
                                    children: [

                                      Icon(

                                        employee.active
                                            ? Icons.check_circle
                                            : Icons.cancel,

                                        color:
                                        employee.active
                                            ? Colors.green
                                            : Colors.red,
                                      ),

                                      const SizedBox(width: 5),

                                      Text(

                                        employee.active
                                            ? "Active"
                                            : "Inactive",

                                        style: TextStyle(
                                          color:
                                          employee.active
                                              ? Colors.green
                                              : Colors.red,

                                          fontWeight:
                                          FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}