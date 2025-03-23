import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:get/get.dart';

class ScanQRCodeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quét mã QR"),
        backgroundColor: Colors.blue.shade400,
      ),
      body: MobileScanner(
        onDetect: (barcode, args) {
          if (barcode.rawValue != null) {
            final String qrCode = barcode.rawValue!;
            // Logic lưu danh thiếp bằng mã QR
            Get.snackbar("Thành công", "Danh thiếp đã được lưu: $qrCode");
          }
        },
      ),
    );
  }
}
