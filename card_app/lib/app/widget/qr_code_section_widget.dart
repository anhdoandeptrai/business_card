import 'package:card_app/app/theme/app_theme.dart';
import 'package:card_app/app/view/share/share_card_view.dart';
import 'package:card_app/app/widget/qr_code_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QRCodeSectionWidget extends StatelessWidget {
  final String qrData;

  const QRCodeSectionWidget({required this.qrData, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Điều hướng đến màn hình ShareCardView khi nhấn vào mã QR
        if (qrData.isNotEmpty) {
          Get.to(() => ShareCardView(qrData: qrData));
        } else {
          Get.snackbar(
            "Lỗi",
            "Danh thiếp đang ở trạng thái Inactive hoặc không có dữ liệu để chia sẻ mã QR.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppTheme.errorColor,
            colorText: AppTheme.textPrimaryColor,
          );
        }
      },
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.primaryColor, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: qrData.isNotEmpty
                ? QRCodeWidget(qrData: qrData)
                : Center(
                    child: Text(
                      "Danh thiếp đang ở trạng thái Inactive",
                      style:
                          TextStyle(color: AppTheme.errorColor, fontSize: 16),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
