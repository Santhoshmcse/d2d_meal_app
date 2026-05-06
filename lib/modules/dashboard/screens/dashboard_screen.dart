import 'package:flutter/material.dart';

import 'package:d2d_meal_app/modules/employees/screens/employee_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Dashboard"),
        centerTitle: true,
      ),

      body: Padding(

        padding: const EdgeInsets.all(16),

        child: GridView.count(

          crossAxisCount: 2,

          crossAxisSpacing: 15,

          mainAxisSpacing: 15,

          children: [

            /// Employees
            GestureDetector(

              onTap: () {

                Navigator.push(

                  context,

                  MaterialPageRoute(

                    builder: (context) =>
                        EmployeeScreen(),
                  ),
                );
              },

              child: dashboardCard(

                title: "Employees",

                icon: Icons.people,

                color: Colors.blue,
              ),
            ),

            /// Meal Punch
            dashboardCard(

              title: "Meal Punch",

              icon: Icons.restaurant,

              color: Colors.green,
            ),

            /// Inventory
            dashboardCard(

              title: "Inventory",

              icon: Icons.inventory,

              color: Colors.orange,
            ),

            /// Reports
            dashboardCard(

              title: "Reports",

              icon: Icons.bar_chart,

              color: Colors.purple,
            ),
          ],
        ),
      ),
    );
  }

  Widget dashboardCard({

    required String title,

    required IconData icon,

    required Color color,

  }) {

    return Container(

      decoration: BoxDecoration(

        color: color,

        borderRadius: BorderRadius.circular(20),
      ),

      child: Column(

        mainAxisAlignment: MainAxisAlignment.center,

        children: [

          Icon(
            icon,
            color: Colors.white,
            size: 50,
          ),

          const SizedBox(height: 10),

          Text(

            title,

            style: const TextStyle(

              color: Colors.white,

              fontSize: 18,

              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}