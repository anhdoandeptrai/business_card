import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Forgot Password")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Enter your email or phone to reset password"),
            TextField(decoration: InputDecoration(labelText: "Email / Phone")),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: Text("Send Reset Link"),
            ),
          ],
        ),
      ),
    );
  }
}
