import 'dart:convert';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/widgets.dart';
import '../models/business_card.dart';

class QRCodeService {
  // Tạo chuỗi QR từ danh thiếp (dạng JSON)
  String generateQRData(BusinessCard card) {
    return jsonEncode(card.toJson());
  }

  // Render mã QR thành hình ảnh
  Widget generateQRImage(String qrData, {double size = 200}) {
    return QrImageView(
      data: qrData,
      version: QrVersions.auto,
      size: size,
    );
  }
}
