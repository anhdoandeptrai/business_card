import 'package:flutter/material.dart';

class OtpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("OTP Verification"),
        backgroundColor: Colors.orange.shade400,
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
            // OTP Instruction
            Text(
              "Enter the OTP sent to your email/phone",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            // OTP Field
            TextField(
              decoration: InputDecoration(
                labelText: "Enter OTP",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            // Verify Button
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                backgroundColor: Colors.orange.shade400,
              ),
              child: Text("Verify", style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
