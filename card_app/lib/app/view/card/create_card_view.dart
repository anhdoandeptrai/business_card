import 'package:card_app/app/widget/qr_code_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'dart:io';
import '../../viewmodel/create_card_viewmodel.dart';
import 'home_view.dart';
import '../../theme/app_theme.dart'; // Thêm import này

class CreateCardView extends StatelessWidget {
  final CreateCardViewModel viewModel = Get.put(CreateCardViewModel());

  CreateCardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "TẠO DANH THIẾP",
          style: TextStyle(
            color: AppTheme.titleColor, // Sử dụng màu từ AppTheme
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Phần chọn avatar và logo
              _buildSectionTitle("Hình ảnh"),
              Row(
                children: [
                  Expanded(
                    child: _buildImagePicker(
                        "Chọn Avatar", viewModel.avatar, viewModel.pickAvatar),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildImagePicker(
                        "Chọn Logo", viewModel.logo, viewModel.pickLogo),
                  ),
                ],
              ),

              // Nhóm 1: Thông tin cơ bản
              const SizedBox(height: 15),
              _buildSectionTitle("Thông tin cơ bản"),
              _buildTwoColumnFields([
                _buildTextField("Tên", viewModel.name),
                _buildTextField("Chức danh", viewModel.jobTitle),
                _buildTextField("Công ty", viewModel.companyName),
                _buildTextField("Địa chỉ", viewModel.address),
              ]),

              // Nhóm 2: Thông tin liên hệ
              const SizedBox(height: 15),
              _buildSectionTitle("Thông tin liên hệ"),
              _buildTwoColumnFields([
                _buildTextField("Số điện thoại", viewModel.phone),
                _buildTextField("Email", viewModel.email),
                _buildTextField("Website", viewModel.website),
                _buildTextField("LinkedIn", viewModel.linkedin),
                _buildTextField("Facebook", viewModel.facebook),
                _buildTextField("Instagram", viewModel.instagram),
                _buildTextField("YouTube", viewModel.youtube),
              ]),

              const SizedBox(height: 20),
              // Nút lưu và nút xem trước
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      viewModel.saveBusinessCard();
                      Get.off(() => HomeView()); // Chuyển đến HomeView
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          AppTheme.buttonColor, // Sử dụng màu từ AppTheme
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Lưu",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _showReviewPopup(context); // Hiển thị popup xem trước
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          AppTheme.buttonColor, // Sử dụng màu từ AppTheme
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Xem trước",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget chọn hình ảnh
  Widget _buildImagePicker(
      String label, Rx<File?> imageFile, Function() onTap) {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            InkWell(
              onTap: onTap,
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blue.shade300),
                ),
                child: imageFile.value == null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_photo_alternate,
                                size: 40, color: Colors.grey.shade600),
                            const SizedBox(height: 5),
                            Text("Chọn hình",
                                style: TextStyle(color: Colors.grey.shade600)),
                          ],
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(9),
                        child: Image.file(
                          imageFile.value!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
              ),
            ),
          ],
        ));
  }

  // Hiển thị popup xem trước danh thiếp
  void _showReviewPopup(BuildContext context) {
    final qrData = _generateQRCodeData();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Container(
            width: 350, // Đặt chiều rộng cố định cho popup
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Tabs để chuyển đổi giữa mặt trước và mặt sau
                DefaultTabController(
                  length: 2,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TabBar(
                        tabs: [
                          Tab(text: 'Mặt trước'),
                          Tab(text: 'Mặt sau'),
                        ],
                        labelColor: Colors.blue.shade600,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: Colors.blue.shade600,
                      ),
                      SizedBox(
                        height: 320, // Chiều cao cố định cho TabBarView
                        child: TabBarView(
                          children: [
                            _buildBackCard(qrData),
                            _buildFrontCard(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        AppTheme.buttonColor, // Sử dụng màu từ AppTheme
                  ),
                  child: const Text('Đóng'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Xây dựng mặt trước card
  Widget _buildFrontCard() {
    return Obx(() => Container(
          margin: const EdgeInsets.symmetric(vertical: 15),
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          height: 220, // Adjust height for standard business card ratio
          decoration: BoxDecoration(
            color: AppTheme.primaryColor, // Sử dụng màu từ AppTheme
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tên công ty ở góc trái
              Text(
                viewModel.companyName.value.isNotEmpty
                    ? viewModel.companyName.value
                    : "COMPANY NAME",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryColor, // Sử dụng màu từ AppTheme
                ),
              ),

              const SizedBox(height: 20),

              // Logo ở giữa
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppTheme.cardColor, // Sử dụng màu từ AppTheme
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.cardColor),
                  ),
                  child: viewModel.logo.value != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(7),
                          child: Image.file(
                            viewModel.logo.value!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Center(
                          child: Icon(Icons.business,
                              size: 60, color: Colors.grey.shade400),
                        ),
                ),
              ),
              const SizedBox(height: 20),

              Text(
                viewModel.address.value.isNotEmpty
                    ? viewModel.address.value
                    : "123 Business Address, City, Country",
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondaryColor, // Sử dụng màu từ AppTheme
                ),
              ),
            ],
          ),
        ));
  }

  // Xây dựng mặt sau card
  Widget _buildBackCard(String qrData) {
    return Obx(() => Container(
          margin: const EdgeInsets.symmetric(vertical: 15),
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          height: 220, // Adjust height for standard business card ratio
          decoration: BoxDecoration(
            color: AppTheme.primaryColor, // Đổi thành màu nền card từ AppTheme
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tên công ty ở trên cùng
              Text(
                viewModel.companyName.value.isNotEmpty
                    ? viewModel.companyName.value
                    : "COMPANY NAME",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryColor, // Sử dụng màu từ AppTheme
                ),
              ),
              const SizedBox(height: 2),
              Divider(
                  height: 1,
                  thickness: 1,
                  color: AppTheme.primaryColor
                      .withOpacity(0.5)), // Thêm màu divider
              const SizedBox(height: 10),

              // Phần avatar và thông tin cá nhân
              Row(
                children: [
                  // Avatar
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                          color: AppTheme
                              .textPrimaryColor), // Sử dụng màu từ AppTheme
                    ),
                    child: viewModel.avatar.value != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(29),
                            child: Image.file(
                              viewModel.avatar.value!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Icon(Icons.person,
                            size: 40,
                            color: AppTheme
                                .textPrimaryColor), // Sử dụng màu từ AppTheme
                  ),

                  const SizedBox(width: 15),

                  // Thông tin người dùng
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          viewModel.name.value.isNotEmpty
                              ? viewModel.name.value
                              : "Your Name",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme
                                .textPrimaryColor, // Sử dụng màu từ AppTheme
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          viewModel.jobTitle.value.isNotEmpty
                              ? viewModel.jobTitle.value
                              : "Job Title",
                          style: TextStyle(
                            fontSize: 13,
                            color: AppTheme
                                .textPrimaryColor, // Sử dụng màu từ AppTheme
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Thông tin liên hệ
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildContactInfo(
                            Icons.email,
                            viewModel.email.value.isNotEmpty
                                ? viewModel.email.value
                                : "email@example.com"),
                        const SizedBox(height: 6),
                        _buildContactInfo(
                            Icons.phone,
                            viewModel.phone.value.isNotEmpty
                                ? viewModel.phone.value
                                : "+84 123 456 789"),
                        const SizedBox(height: 6),
                        _buildContactInfo(
                            Icons.home,
                            viewModel.address.value.isNotEmpty
                                ? viewModel.address.value
                                : "123 Street Address"),
                      ],
                    ),
                  ),

                  // QR Code
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 85, // Giữ nguyên chiều cao
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors
                            .white, // Thêm nền trắng để làm nổi bật QR code
                        border: Border.all(color: AppTheme.textPrimaryColor),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Container(
                          padding: const EdgeInsets.all(
                              4), // Thêm padding cho QR code bên trong
                          child: QRCodeWidget(
                            qrData: qrData,
                            key: UniqueKey(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Social icons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialIcon(
                      FontAwesomeIcons.linkedin, AppTheme.textPrimaryColor),
                  _buildSocialIcon(
                      FontAwesomeIcons.facebook, AppTheme.textPrimaryColor),
                  _buildSocialIcon(
                      FontAwesomeIcons.instagram, AppTheme.textPrimaryColor),
                  _buildSocialIcon(
                      FontAwesomeIcons.youtube, AppTheme.textPrimaryColor),
                  _buildSocialIcon(
                      FontAwesomeIcons.globe, AppTheme.textPrimaryColor),
                ],
              ),
            ],
          ),
        ));
  }

  // Widget hiển thị thông tin liên hệ
  Widget _buildContactInfo(IconData icon, String text) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start, // Quan trọng: căn icon lên phía trên
      children: [
        Icon(icon, size: 16, color: AppTheme.textPrimaryColor),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 12, color: AppTheme.textPrimaryColor),
            maxLines: 4, // Cho phép tối đa 4 dòng
            softWrap: true, // Cho phép xuống dòng
            overflow: TextOverflow.visible, // Hiển thị tất cả nội dung có thể
          ),
        ),
      ],
    );
  }

  // Widget hiển thị icon mạng xã hội
  Widget _buildSocialIcon(IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: FaIcon(
        icon,
        size: 20,
        color: color,
      ),
    );
  }

  // Tạo dữ liệu QR Code
  String _generateQRCodeData() {
    return '''
Name: ${viewModel.name.value.isNotEmpty ? viewModel.name.value : "Unknown"}
Job Title: ${viewModel.jobTitle.value.isNotEmpty ? viewModel.jobTitle.value : "Unknown"}
Company: ${viewModel.companyName.value.isNotEmpty ? viewModel.companyName.value : "Unknown"}
Address: ${viewModel.address.value.isNotEmpty ? viewModel.address.value : "Unknown"}
Phone: ${viewModel.phone.value.isNotEmpty ? viewModel.phone.value : "Unknown"}
Email: ${viewModel.email.value.isNotEmpty ? viewModel.email.value : "Unknown"}
Website: ${viewModel.website.value.isNotEmpty ? viewModel.website.value : "Unknown"}
''';
  }

  // Tiêu đề nhóm thông tin
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blue.shade700,
        ),
      ),
    );
  }

  // Widget tạo ô nhập dữ liệu
  Widget _buildTextField(String label, RxString value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        onChanged: (text) => value.value = text,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue.shade300),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  // Tạo hàng có 2 cột
  Widget _buildTwoColumnFields(List<Widget> fields) {
    return Column(
      children: List.generate((fields.length / 2).ceil(), (index) {
        int first = index * 2;
        int second = first + 1;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
              Expanded(child: fields[first]),
              const SizedBox(width: 10),
              if (second < fields.length) Expanded(child: fields[second]),
            ],
          ),
        );
      }),
    );
  }
}
