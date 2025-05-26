import 'package:card_app/app/view/card/home_tab.dart';
import 'package:card_app/app/view/contact/card_contact_manager_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../viewmodel/home_viewmodel.dart';
import '../../theme/app_theme.dart';

import '../../widget/drawer_component.dart';
import '../../view/reports/reports_tab_view.dart'; // New import

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
      HomeTab(viewModel: viewModel), // Tab Home
      ReportsTabView(), // Tab Reports (thay thế cho Tab Contact)
      CardContactManagerView(), // Tab Card Contact Manager{
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: _currentIndex == 0 // Chỉ hiển thị AppBar khi ở tab Home
          ? AppBar(
              title: Text(
                "EZNECT",
                style: TextStyle(
                  color: AppTheme.titleColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: AppTheme.primaryColor,
              leading: Builder(
                builder: (context) => IconButton(
                  icon: Icon(Icons.menu, color: AppTheme.iconActiveColor),
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
            icon: Icon(Icons.bar_chart), // Changed from contacts to bar_chart
            label: "Báo cáo", // Changed from "Contact" to "Báo cáo"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.manage_accounts),
            label: "Manager",
          ),
        ],
        selectedItemColor: AppTheme.iconActiveColor,
        unselectedItemColor: AppTheme.iconInactiveColor,
        backgroundColor: AppTheme.primaryColor,
        type: BottomNavigationBarType.fixed,
      ),
      drawer: DrawerComponent(viewModel: viewModel), // Luôn hiển thị Drawer
    );
  }
}
