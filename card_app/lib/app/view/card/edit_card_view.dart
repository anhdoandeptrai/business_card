import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/business_card.dart';
import '../../viewmodel/home_viewmodel.dart';

class EditCardView extends StatelessWidget {
  final BusinessCard card;
  final HomeViewModel viewModel = Get.find<HomeViewModel>();

  EditCardView({required this.card});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController jobTitleController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  final TextEditingController linkedinController = TextEditingController();
  final TextEditingController facebookController = TextEditingController();
  final TextEditingController instagramController = TextEditingController();
  final TextEditingController youtubeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Gán giá trị ban đầu
    nameController.text = card.name;
    jobTitleController.text = card.jobTitle;
    companyNameController.text = card.companyName;
    phoneController.text = card.phone;
    emailController.text = card.email;
    websiteController.text = card.website;
    linkedinController.text = card.linkedin;
    facebookController.text = card.facebook;
    instagramController.text = card.instagram;
    youtubeController.text = card.youtube;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chỉnh sửa danh thiếp"),
        backgroundColor: Colors.blue.shade600, // Màu nền AppBar
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Nhóm 1: Thông tin cơ bản
              _buildSectionTitle("Thông tin cơ bản"),
              _buildTwoColumnFields([
                _buildTextField("Tên", nameController),
                _buildTextField("Chức danh", jobTitleController),
                _buildTextField("Công ty", companyNameController),
              ]),

              // Nhóm 2: Thông tin liên hệ
              const SizedBox(height: 15),
              _buildSectionTitle("Thông tin liên hệ"),
              _buildTwoColumnFields([
                _buildTextField("Số điện thoại", phoneController),
                _buildTextField("Email", emailController),
                _buildTextField("Website", websiteController),
                _buildTextField("LinkedIn", linkedinController),
                _buildTextField("Facebook", facebookController),
                _buildTextField("Instagram", instagramController),
                _buildTextField("YouTube", youtubeController),
              ]),

              const SizedBox(height: 20),
              // Nút lưu
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Cập nhật thông tin danh thiếp
                    viewModel.saveBusinessCard(
                      BusinessCard(
                        name: nameController.text,
                        jobTitle: jobTitleController.text,
                        companyName: companyNameController.text,
                        phone: phoneController.text,
                        email: emailController.text,
                        website: websiteController.text,
                        linkedin: linkedinController.text,
                        facebook: facebookController.text,
                        instagram: instagramController.text,
                        youtube: youtubeController.text,
                      ),
                    );
                    Get.back(); // Quay lại màn hình trước
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.blue.shade600, // Màu đậm hơn để nổi bật
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
              ),
            ],
          ),
        ),
      ),
    );
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
          color: Colors.blue.shade700, // Màu chữ đậm hơn
        ),
      ),
    );
  }

  // Widget tạo ô nhập dữ liệu
  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey.shade100, // Nền trắng nhạt hơn
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Colors.blue.shade300), // Viền nhạt hơn
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.blue.shade600, width: 2), // Viền khi focus
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
