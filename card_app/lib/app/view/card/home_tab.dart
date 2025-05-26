import 'package:card_app/app/theme/app_theme.dart';
import 'package:card_app/app/viewmodel/home_viewmodel.dart';
import 'package:card_app/app/widget/header_widget.dart';
import 'package:card_app/app/widget/profile_section_widget.dart';
import 'package:card_app/app/widget/qr_code_section_widget.dart';
import 'package:card_app/app/widget/social_icons_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeTab extends StatelessWidget {
  final HomeViewModel viewModel;

  const HomeTab({required this.viewModel, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (viewModel.businessCard.value == null) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon minh họa
              Icon(
                Icons.credit_card,
                size: 100,
                color: AppTheme.buttonColor,
              ),
              SizedBox(height: 20),
              // Văn bản hướng dẫn
              Text(
                "Bạn chưa tạo danh thiếp nào!",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                "Hãy tạo danh thiếp đầu tiên của bạn.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              // Nút tạo danh thiếp
              ElevatedButton.icon(
                onPressed: viewModel.goToCreateCard,
                icon: Icon(Icons.add, color: Colors.white),
                label: Text(
                  "Tạo Danh Thiếp",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.buttonColor,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        );
      }

      final card = viewModel.businessCard.value!;
      return SingleChildScrollView(
        child: Column(
          children: [
            HeaderWidget(),
            ProfileSectionWidget(card: card, viewModel: viewModel),
            QRCodeSectionWidget(qrData: viewModel.qrData.value),
            SocialIconsWidget(card: card),
          ],
        ),
      );
    });
  }

  void _showDeleteConfirmation() {
    Get.dialog(
      AlertDialog(
        title: Text("Xác nhận"),
        content: Text("Bạn có chắc chắn muốn xóa thông tin danh thiếp này?"),
        actions: [
          TextButton(
            onPressed: () => Get.back(), // Đóng dialog
            child: Text("Hủy"),
          ),
          TextButton(
            onPressed: () {
              viewModel.deleteBusinessCard(); // Xóa danh thiếp
              Get.back(); // Đóng dialog
            },
            child: Text("Xóa", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
