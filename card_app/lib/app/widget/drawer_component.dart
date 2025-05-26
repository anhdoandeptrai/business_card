import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme/app_theme.dart';
import '../view/card/card_manager_view.dart';
import '../viewmodel/home_viewmodel.dart';
import '../data/services/auth_service.dart';

class DrawerComponent extends StatelessWidget {
  final HomeViewModel viewModel;
  final AuthService authService = Get.find<AuthService>();

  DrawerComponent({required this.viewModel, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
            ),
            child: Obx(() {
              final avatar = viewModel.avatar.value;
              final user = authService.currentUser.value;
              final roleName = authService.isManager
                  ? 'Tài khoản Quản lý'
                  : 'Tài khoản Thường';
              final userName = user?.fullName ?? 'Người dùng';

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: avatar != null
                        ? FileImage(avatar)
                        : AssetImage('assets/logo.png') as ImageProvider,
                  ),
                  SizedBox(height: 10),
                  Text(
                    userName,
                    style: TextStyle(
                      color: AppTheme.textPrimaryColor,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: authService.isManager
                          ? AppTheme.successColor.withOpacity(0.2)
                          : AppTheme.primaryLightColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      roleName,
                      style: TextStyle(
                        fontSize: 12,
                        color: authService.isManager
                            ? AppTheme.successColor
                            : AppTheme.primaryColor,
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),

          // Quản lý danh thiếp - For both roles
          ListTile(
            leading: Icon(Icons.credit_card, color: AppTheme.primaryColor),
            title: Text("Quản lý danh thiếp"),
            onTap: () {
              Navigator.of(context).pop(); // Đóng Drawer
              Get.to(() => CardManagerView());
            },
          ),

          // Nâng cấp tài khoản - Luôn hiển thị, nhưng thay đổi hành vi dựa trên tài khoản
          Obx(() {
            final bool isPremium = authService
                    .currentUser.value?.subscription.hasActiveSubscription ??
                false;
            return ListTile(
              leading: Icon(isPremium ? Icons.stars : Icons.upgrade,
                  color: isPremium ? Colors.amber : Colors.orange),
              title:
                  Text(isPremium ? "Tài khoản Premium" : "Nâng cấp tài khoản"),
              onTap: () {
                Navigator.of(context).pop(); // Đóng Drawer
                Get.toNamed('/subscription');
              },
            );
          }),

          Divider(),

          // Settings
          ListTile(
            leading: Icon(Icons.settings, color: Colors.grey[700]),
            title: Text("Cài đặt"),
            onTap: () {
              Navigator.of(context).pop(); // Đóng Drawer
              // Navigate to settings
            },
          ),

          // Logout
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text("Đăng xuất"),
            onTap: () {
              Navigator.of(context).pop(); // Đóng Drawer
              _showLogoutConfirmation(context);
            },
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: Text("Xác nhận đăng xuất"),
        content: Text("Bạn có chắc chắn muốn đăng xuất?"),
        actions: [
          TextButton(
            onPressed: () => Get.back(), // Đóng dialog
            child: Text("Hủy"),
          ),
          TextButton(
            onPressed: () {
              authService.logout();
              Get.offAllNamed('/welcome'); // Đăng xuất và về màn hình welcome
            },
            child: Text("Đăng xuất", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
