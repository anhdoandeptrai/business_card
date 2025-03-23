import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Image.asset(
              'assets/logo.png',
              height: 100,
              width: 100,
            ),
            SizedBox(height: 20),
            // Welcome Text
            Text(
              "Welcome to DBC App",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),
            // Login Button
            ElevatedButton(
              onPressed: () => Get.toNamed(AppRoutes.login),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                backgroundColor: Colors.blue.shade400,
              ),
              child: Text("Login", style: TextStyle(fontSize: 18)),
            ),
            SizedBox(height: 20),
            // Register Button
            ElevatedButton(
              onPressed: () => Get.toNamed(AppRoutes.register),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                backgroundColor: Colors.green.shade400,
              ),
              child: Text("Register", style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
