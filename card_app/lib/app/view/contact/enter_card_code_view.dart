import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EnterCardCodeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextEditingController codeController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text("Nhập mã danh thiếp"),
        backgroundColor: Colors.blue.shade400,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: codeController,
              decoration: InputDecoration(
                labelText: "Nhập mã danh thiếp",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Logic lưu danh thiếp bằng mã
                Get.snackbar("Thành công", "Danh thiếp đã được lưu!");
              },
              child: Text("Lưu danh thiếp"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
