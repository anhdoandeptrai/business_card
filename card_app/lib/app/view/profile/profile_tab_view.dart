import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../viewmodel/home_viewmodel.dart';
import '../card/edit_card_view.dart';
import '../../theme/app_theme.dart'; // Thêm import này

class ProfileTabView extends StatefulWidget {
  @override
  _ProfileTabViewState createState() => _ProfileTabViewState();
}

class _ProfileTabViewState extends State<ProfileTabView> {
  final HomeViewModel viewModel = Get.find<HomeViewModel>();
  final ImagePicker _picker = ImagePicker();

  // Hàm chọn ảnh từ thư viện hoặc chụp ảnh mới
  Future<void> _pickAvatar() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery, // Hoặc ImageSource.camera để chụp ảnh
      imageQuality: 80, // Giảm chất lượng ảnh để tối ưu dung lượng
    );

    if (pickedFile != null) {
      final File newAvatar = File(pickedFile.path);
      viewModel.updateAvatar(newAvatar); // Cập nhật avatar trong ViewModel
    }
  }

  void _showDeleteConfirmation(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: Text("Xác nhận"),
        content: Text("Bạn có chắc chắn muốn xóa thông tin hồ sơ này?"),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("Hủy"),
          ),
          TextButton(
            onPressed: () {
              viewModel.deleteBusinessCard();
              Get.back();
            },
            child: Text("Xóa", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Xóa nút quay lại
        title: Text(
          "THÔNG TIN CÁ NHÂN",
          style: TextStyle(
            color: AppTheme.titleColor, // Sử dụng màu từ AppTheme
            fontWeight:
                FontWeight.bold, // Tùy chọn: làm đậm text để nổi bật hơn
          ),
        ),
        backgroundColor:
            AppTheme.primaryColor, // Thay đổi từ Colors.blue.shade400
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              final card = viewModel.businessCard.value;
              if (value == "edit" && card != null) {
                Get.to(() => EditCardView(card: card));
              } else if (value == "delete") {
                _showDeleteConfirmation(context);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: "edit",
                child: Text("Sửa thông tin"),
              ),
              PopupMenuItem(
                value: "delete",
                child: Text("Xóa thông tin"),
              ),
            ],
            icon: Icon(Icons.more_vert, color: AppTheme.iconActiveColor),
          ),
        ],
      ),
      body: Obx(() {
        final avatar = viewModel.avatar.value;
        final card = viewModel.businessCard.value;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Avatar
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: avatar != null
                          ? FileImage(avatar) // Hiển thị ảnh đã chọn
                          : AssetImage('assets/logo.png')
                              as ImageProvider, // Hiển thị ảnh mặc định
                    ),
                    // Icon camera
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap:
                            _pickAvatar, // Chọn avatar khi nhấn vào icon camera
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black.withOpacity(0.5), // Màu nền mờ
                          ),
                          padding: EdgeInsets.all(6),
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  card?.name ?? "Unknown",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDarkColor, // Thêm màu text
                  ),
                ),
              ),
              Center(
                child: Text(
                  card?.email ?? "Unknown",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Icon(FontAwesomeIcons.building),
                title: Text("Công ty: ${card?.companyName ?? "Unknown"}"),
              ),
              ListTile(
                leading: Icon(FontAwesomeIcons.briefcase),
                title: Text("Chức danh: ${card?.jobTitle ?? "Unknown"}"),
              ),
              ListTile(
                leading: Icon(FontAwesomeIcons.phone),
                title: Text("Số điện thoại: ${card?.phone ?? "Unknown"}"),
              ),
              ListTile(
                leading: Icon(FontAwesomeIcons.globe),
                title: Text("Website: ${card?.website ?? "Unknown"}"),
              ),
              ListTile(
                leading: Icon(FontAwesomeIcons.linkedin),
                title: Text("LinkedIn: ${card?.linkedin ?? "Unknown"}"),
              ),
              ListTile(
                leading: Icon(FontAwesomeIcons.facebook),
                title: Text("Facebook: ${card?.facebook ?? "Unknown"}"),
              ),
              ListTile(
                leading: Icon(FontAwesomeIcons.instagram),
                title: Text("Instagram: ${card?.instagram ?? "Unknown"}"),
              ),
              ListTile(
                leading: Icon(FontAwesomeIcons.youtube),
                title: Text("YouTube: ${card?.youtube ?? "Unknown"}"),
              ),
            ],
          ),
        );
      }),
    );
  }
}
