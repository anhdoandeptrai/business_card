import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        backgroundColor: Colors.blue.shade400,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Logo
            Image.asset(
              'assets/logo.png',
              height: 100,
              width: 100,
            ),
            SizedBox(height: 20),
            // Email / Phone Field
            TextField(
              decoration: InputDecoration(
                labelText: "Email / Phone",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            // Password Field
            TextField(
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            // Login Button
            ElevatedButton(
              onPressed: () {
                Get.offNamed(AppRoutes.home);
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                backgroundColor: Colors.blue.shade400,
              ),
              child: Text("Login", style: TextStyle(fontSize: 18)),
            ),
            SizedBox(height: 10),
            // Forgot Password
            TextButton(
              onPressed: () => Get.toNamed(AppRoutes.forgotPassword),
              child: Text("Forgot Password?"),
            ),
          ],
        ),
      ),
    );
  }
}
