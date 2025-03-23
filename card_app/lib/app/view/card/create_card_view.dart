import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../viewmodel/create_card_viewmodel.dart';
import 'home_view.dart';

class CreateCardView extends StatelessWidget {
  final CreateCardViewModel viewModel = Get.put(CreateCardViewModel());

  CreateCardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tạo Danh Thiếp"),
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
                _buildTextField("Tên", viewModel.name),
                _buildTextField("Chức danh", viewModel.jobTitle),
                _buildTextField("Công ty", viewModel.companyName),
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
              // Nút lưu
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    viewModel.saveBusinessCard();
                    Get.off(() => HomeView()); // Chuyển đến HomeView
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
  Widget _buildTextField(String label, RxString value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        onChanged: (text) => value.value = text,
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
