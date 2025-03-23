import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../viewmodel/home_viewmodel.dart';
import '../card/edit_card_view.dart';

class ProfileSettingsView extends StatefulWidget {
  @override
  _ProfileSettingsViewState createState() => _ProfileSettingsViewState();
}

class _ProfileSettingsViewState extends State<ProfileSettingsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final HomeViewModel viewModel = Get.put(HomeViewModel());

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // Chỉ còn 2 tab
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Xóa nút quay lại
        title: Text("Hồ sơ & Cài đặt"),
        backgroundColor: Colors.blue.shade400,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.person), text: "Hồ sơ"),
            Tab(icon: Icon(Icons.settings), text: "Cài đặt"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildProfileTab(), // Tab Thông tin cá nhân
          _buildSettingsTab(), // Tab Cài đặt (bao gồm Đăng xuất)
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    return Obx(() {
      final card = viewModel.businessCard.value;

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/logo.png'),
                  ),
                ),
                Positioned(
                  right: 0,
                  child: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == "edit") {
                        if (card != null) {
                          Get.to(() => EditCardView(card: card));
                        }
                      } else if (value == "delete") {
                        _showDeleteConfirmation();
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
                    child: Icon(Icons.more_vert, size: 24),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                card?.name ?? "Unknown",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
    });
  }

  void _showDeleteConfirmation() {
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

  Widget _buildSettingsTab() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        SwitchListTile(
          title: Text("Chế độ tối"),
          value: false,
          onChanged: (value) {
            // Logic bật/tắt chế độ tối
          },
        ),
        SwitchListTile(
          title: Text("Thông báo"),
          value: true,
          onChanged: (value) {
            // Logic bật/tắt thông báo
          },
        ),
        ListTile(
          leading: Icon(Icons.privacy_tip),
          title: Text("Quyền riêng tư"),
          onTap: () {
            // Điều hướng đến màn hình quyền riêng tư
          },
        ),
        const SizedBox(height: 20),
        // Logout Button
        Center(
          child: ElevatedButton(
            onPressed: () {
              Get.dialog(
                AlertDialog(
                  title: Text("Xác nhận"),
                  content: Text("Bạn có chắc chắn muốn đăng xuất?"),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: Text("Hủy"),
                    ),
                    TextButton(
                      onPressed: () {
                        // Logic đăng xuất
                        Get.offAllNamed('/welcome');
                      },
                      child: Text("Đăng xuất",
                          style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade400,
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            ),
            child: Text("Đăng xuất", style: TextStyle(fontSize: 18)),
          ),
        ),
      ],
    );
  }
}
