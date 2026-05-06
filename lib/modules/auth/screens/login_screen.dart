import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:d2d_meal_app/modules/auth/services/auth_service.dart';
import 'package:d2d_meal_app/modules/dashboard/screens/dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController emailController =
  TextEditingController();

  final TextEditingController passwordController =
  TextEditingController();

  bool isLoading = false;

  bool isPasswordHidden = true;

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Stack(

        children: [

          /// Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1566073771259-6a8506099945',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),

          /// Dark Overlay
          Container(
            color: Colors.black.withOpacity(0.5),
          ),

          /// Login Card
          Center(

            child: Container(

              margin: const EdgeInsets.all(20),

              padding: const EdgeInsets.all(25),

              decoration: BoxDecoration(

                color: Colors.white,

                borderRadius: BorderRadius.circular(30),
              ),

              child: Column(

                mainAxisSize: MainAxisSize.min,

                children: [

                  const Icon(
                    Icons.restaurant,
                    size: 70,
                    color: Colors.green,
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    "Welcome Back",

                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Sign in to continue",

                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// Email Field
                  TextField(

                    controller: emailController,

                    decoration: InputDecoration(

                      hintText: "Email",

                      border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// Password Field
                  TextField(

                    controller: passwordController,

                    obscureText: isPasswordHidden,

                    decoration: InputDecoration(

                      hintText: "Password",

                      border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(12),
                      ),

                      suffixIcon: IconButton(

                        icon: Icon(

                          isPasswordHidden
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),

                        onPressed: () {

                          setState(() {

                            isPasswordHidden =
                            !isPasswordHidden;
                          });
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// Login Button
                  SizedBox(

                    width: double.infinity,

                    height: 55,

                    child: ElevatedButton(

                      onPressed: () async {

                        setState(() {
                          isLoading = true;
                        });

                        try {

                          final response =
                          await AuthService.login(

                            email:
                            emailController.text.trim(),

                            password:
                            passwordController.text.trim(),
                          );

                          final prefs =
                          await SharedPreferences
                              .getInstance();

                          await prefs.setString(
                            'token',
                            response.data['accessToken'],
                          );

                          setState(() {
                            isLoading = false;
                          });

                          Navigator.push(
                            context,

                            MaterialPageRoute(
                              builder: (context) =>
                              const DashboardScreen(),
                            ),
                          );

                        } catch (e) {

                          setState(() {
                            isLoading = false;
                          });

                          print(e.toString());

                          ScaffoldMessenger.of(context)
                              .showSnackBar(

                            const SnackBar(
                              content:
                              Text("Login Failed"),
                            ),
                          );
                        }
                      },

                      style: ElevatedButton.styleFrom(

                        backgroundColor: Colors.green,

                        shape: RoundedRectangleBorder(

                          borderRadius:
                          BorderRadius.circular(15),
                        ),
                      ),

                      child: isLoading

                          ? const CircularProgressIndicator(
                        color: Colors.white,
                      )

                          : const Text(

                        "LOGIN",

                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}