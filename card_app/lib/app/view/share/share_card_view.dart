import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';
import '../../widget/qr_code_widget.dart';
import '../../theme/app_theme.dart';

class ShareCardView extends StatelessWidget {
  final String qrData;
  final ScreenshotController screenshotController = ScreenshotController();

  ShareCardView({required this.qrData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chia sẻ Danh Thiếp",
          style: TextStyle(
            color: AppTheme.titleColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppTheme.primaryColor,
        iconTheme: IconThemeData(color: AppTheme.iconActiveColor),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: AppTheme.backgroundColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Quét mã QR để nhận thông tin danh thiếp",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDarkColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Screenshot(
                controller: screenshotController,
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.cardColor,
                    border: Border.all(
                      color: AppTheme.primaryLightColor,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: QRCodeWidget(qrData: qrData),
                ),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      // Logic chia sẻ mã QR
                      Get.snackbar(
                        "Chia sẻ",
                        "Chức năng chia sẻ đang được phát triển",
                        backgroundColor: AppTheme.infoColor,
                        colorText: AppTheme.textPrimaryColor,
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                    icon: Icon(Icons.share),
                    label: Text("Chia sẻ"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.buttonColor,
                      foregroundColor: AppTheme.textPrimaryColor,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      elevation: 3,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Logic lưu mã QR
                      Get.snackbar(
                        "Lưu QR",
                        "Chức năng lưu đang được phát triển",
                        backgroundColor: AppTheme.successColor,
                        colorText: AppTheme.textPrimaryColor,
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                    icon: Icon(Icons.save),
                    label: Text("Lưu QR"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.secondaryColor,
                      foregroundColor: AppTheme.textPrimaryColor,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      elevation: 3,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                "Chia sẻ danh thiếp của bạn với những người khác",
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textDarkColor.withOpacity(0.7),
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
