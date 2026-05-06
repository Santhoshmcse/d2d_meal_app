import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/add_employee_controller.dart';

import '../widgets/employee_form_widget.dart';

class AddEmployeeScreen
    extends StatelessWidget {

  AddEmployeeScreen({
    super.key,
  });

  final controller =
  Get.put(AddEmployeeController());

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Add Employee",
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            Expanded(
              child: SingleChildScrollView(
                child:
                const EmployeeFormWidget(),
              ),
            ),

            Obx(
                  () => SizedBox(

                width: double.infinity,

                height: 50,

                child: ElevatedButton(

                  onPressed:
                  controller
                      .isLoading.value
                      ? null
                      : controller
                      .createEmployee,

                  child:
                  controller
                      .isLoading.value
                      ? const CircularProgressIndicator()
                      : const Text(
                    "Create Employee",
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}