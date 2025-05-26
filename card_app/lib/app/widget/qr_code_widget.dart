import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodeWidget extends StatelessWidget {
  final String qrData;

  const QRCodeWidget({super.key, required this.qrData});

  @override
  Widget build(BuildContext context) {
    if (qrData.isEmpty) {
      return Center(
        child: Text(
          "Không có dữ liệu để tạo mã QR",
          style: TextStyle(color: Colors.red, fontSize: 16),
        ),
      );
    }

    return QrImageView(
      data: qrData,
      version: QrVersions.auto,
      size: 200.0,
    );
  }
}
