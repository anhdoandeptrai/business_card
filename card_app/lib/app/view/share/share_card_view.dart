import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widget/qr_code_widget.dart';

class ShareCardView extends StatelessWidget {
  final String qrData;

  ShareCardView({required this.qrData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chia sẻ Danh Thiếp"),
        backgroundColor: Colors.blue.shade400,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Quét mã QR để nhận thông tin danh thiếp",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue.shade300, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: QRCodeWidget(qrData: qrData),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                // Logic chia sẻ mã QR
                Get.snackbar(
                    "Chia sẻ", "Chức năng chia sẻ đang được phát triển");
              },
              icon: Icon(Icons.share),
              label: Text("Chia sẻ"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade400,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
