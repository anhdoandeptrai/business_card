import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:url_launcher/url_launcher.dart';
import '../../data/models/business_card.dart';
import '../../viewmodel/home_viewmodel.dart';
import '../../widget/qr_code_widget.dart';
import '../contact/contact_list_view.dart';
import '../contact/card_manager_view.dart';
import '../setting/profile_settings_view.dart';
import '../share/share_card_view.dart';
import 'edit_card_view.dart';

class HomeView extends StatefulWidget {
  HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeViewModel viewModel = Get.put(HomeViewModel());
  int _currentIndex = 0; // Chỉ số của tab hiện tại

  final List<Widget> _tabs = []; // Danh sách các màn hình

  @override
  void initState() {
    super.initState();
    _tabs.addAll([
      _buildHomeTab(), // Tab Home
      ContactListView(), // Tab Contact
      CardCodeManagerView(), // Tab Manager
      ProfileSettingsView(), // Tab Hồ sơ & Cài đặt
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: _currentIndex == 0 // Chỉ hiển thị AppBar khi ở tab Home
          ? AppBar(
              title: Text("Business Card"),
              backgroundColor: Colors.blue.shade400,
              leading: Builder(
                builder: (context) => IconButton(
                  icon: Icon(Icons.menu, color: Colors.white),
                  onPressed: () {
                    Scaffold.of(context).openDrawer(); // Mở Drawer
                  },
                ),
              ),
            )
          : null, // Không hiển thị AppBar ở các tab khác
      body: _tabs[_currentIndex], // Hiển thị màn hình tương ứng với tab
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            label: "Contact",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.manage_accounts),
            label: "Manager",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
        selectedItemColor: Colors.blue.shade400,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
      ),
      drawer: _currentIndex == 0
          ? _buildDrawer()
          : null, // Chỉ hiển thị Drawer ở tab Home
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue.shade400,
            ),
            child: Text(
              "Menu",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.edit, color: Colors.blue),
            title: Text("Sửa thông tin"),
            onTap: () {
              Navigator.of(context).pop(); // Đóng Drawer
              Get.to(() => EditCardView(card: viewModel.businessCard.value!));
            },
          ),
          ListTile(
            leading: Icon(Icons.delete, color: Colors.red),
            title: Text("Xóa thông tin"),
            onTap: () {
              Navigator.of(context).pop(); // Đóng Drawer
              _showDeleteConfirmation();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHomeTab() {
    return Obx(() {
      if (viewModel.businessCard.value == null) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon minh họa
              Icon(
                Icons.credit_card, // Thay thế hình ảnh bằng icon
                size: 100,
                color: Colors.blue.shade300,
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
                "Hãy nhấn vào nút bên dưới để tạo danh thiếp đầu tiên của bạn.",
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
                  backgroundColor: Colors.blue.shade400,
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
            _buildHeader(),
            _buildProfileSection(card),
            _buildQRCodeSection(viewModel.qrData.value),
            _buildSocialIcons(card),
          ],
        ),
      );
    });
  }

  Widget _buildHeader() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/header_background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage('assets/logo.png'),
        ),
      ),
    );
  }

  Widget _buildProfileSection(BusinessCard card) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              card.name.isNotEmpty ? card.name : "Unknown",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 8),
          Center(
            child: Text(
              card.jobTitle.isNotEmpty ? card.jobTitle : "Unknown",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ),
          SizedBox(height: 8),
          Center(
            child: Text(
              card.companyName.isNotEmpty ? card.companyName : "Unknown",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
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

  Widget _buildQRCodeSection(String qrData) {
    return GestureDetector(
      onTap: () {
        // Điều hướng đến màn hình ShareCardView khi nhấn vào mã QR
        Get.to(() => ShareCardView(qrData: qrData));
      },
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(
                  color: Colors.blue.shade300, width: 2), // Màu viền nhạt hơn
              borderRadius: BorderRadius.circular(10),
            ),
            child: QRCodeWidget(qrData: qrData),
          ),
          ElevatedButton.icon(
            onPressed: () {
              // Logic lưu QR
            },
            icon: Icon(Icons.save, color: Colors.white),
            label: Text(
              "Save Contact",
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade400, // Màu nhạt hơn
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcons(BusinessCard card) {
    final icons = [
      {'icon': FontAwesomeIcons.phone, 'url': 'tel:${card.phone}'},
      {'icon': FontAwesomeIcons.solidMessage, 'url': 'sms:${card.phone}'},
      {'icon': FontAwesomeIcons.solidEnvelope, 'url': 'mailto:${card.email}'},
      {'icon': FontAwesomeIcons.globe, 'url': card.website},
      {'icon': FontAwesomeIcons.linkedin, 'url': card.linkedin},
      {'icon': FontAwesomeIcons.facebook, 'url': card.facebook},
      {'icon': FontAwesomeIcons.instagram, 'url': card.instagram},
      {'icon': FontAwesomeIcons.youtube, 'url': card.youtube},
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: icons.sublist(0, 4).map((e) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    _buildIconButton(e['icon'] as IconData, e['url'] as String),
              );
            }).toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: icons.sublist(4).map((e) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    _buildIconButton(e['icon'] as IconData, e['url'] as String),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, String url) {
    return GestureDetector(
      onTap: () async {
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          Get.dialog(AlertDialog(
            title: Text("Lỗi"),
            content: Text("Thết bị không hỗ trợ chức năng này"),
          ));
        }
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blue.shade700,
        ),
        child: Icon(icon, color: Colors.white, size: 30),
      ),
    );
  }
}
