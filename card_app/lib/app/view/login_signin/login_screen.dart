import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import '../../data/services/auth_service.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService = Get.find<AuthService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Đăng nhập"),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: SingleChildScrollView(
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

            // Username / Email Field
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: "Tên đăng nhập / Email",
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      BorderSide(color: AppTheme.primaryColor, width: 2),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Password Field
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: "Mật khẩu",
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      BorderSide(color: AppTheme.primaryColor, width: 2),
                ),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),

            // Role selection hint
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.primaryLightColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.primaryLightColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Thông tin đăng nhập mẫu:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textDarkColor,
                    ),
                  ),
                  SizedBox(height: 8),
                  _buildLoginInfo(
                    "Tài khoản thường:",
                    "regular_user / password123",
                  ),
                  SizedBox(height: 4),
                  _buildLoginInfo(
                    "Tài khoản premium:",
                    "premium_user / password123",
                  ),
                  SizedBox(height: 4),
                  _buildLoginInfo(
                    "Tài khoản quản lý:",
                    "manager / manager123",
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Login Button
            ElevatedButton(
              onPressed: () => _login(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.buttonColor,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "Đăng nhập",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            SizedBox(height: 10),

            // Forgot Password
            TextButton(
              onPressed: () => Get.toNamed(AppRoutes.forgotPassword),
              child: Text("Quên mật khẩu?"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginInfo(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: AppTheme.textDarkColor,
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.blue[700],
            ),
          ),
        ),
      ],
    );
  }

  void _login() async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      Get.snackbar(
        "Lỗi",
        "Vui lòng nhập đầy đủ thông tin đăng nhập",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    // Simulate network delay
    await Future.delayed(Duration(seconds: 1));

    // Attempt login
    final success = await authService.login(username, password);

    // Close loading dialog
    Get.back();

    if (success) {
      // Navigate to home screen
      Get.offAllNamed(AppRoutes.home);

      // Show welcome message
      Get.snackbar(
        "Đăng nhập thành công",
        "Chào mừng ${authService.currentUser.value?.fullName}",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
      );
    } else {
      // Show error message
      Get.snackbar(
        "Lỗi đăng nhập",
        "Tên đăng nhập hoặc mật khẩu không chính xác",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }
}
