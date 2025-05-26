import 'package:card_app/app/widget/business_card_popup.dart';
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../data/models/business_card.dart';
import 'scan_qr_code_view.dart';

class CardContactManagerView extends StatefulWidget {
  @override
  _CardContactManagerViewState createState() => _CardContactManagerViewState();
}

class _CardContactManagerViewState extends State<CardContactManagerView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController codeController = TextEditingController();
  late List<BusinessCard> contacts;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Tạo dữ liệu mẫu BusinessCard
    contacts = [
      BusinessCard(
        name: "Nguyễn Văn A",
        jobTitle: "Giám đốc Marketing",
        companyName: "Công ty TNHH ABC",
        phone: "0901234567",
        email: "nguyenvana@example.com",
        website: "example.com",
        linkedin: "linkedin.com/in/nguyenvana",
        facebook: "facebook.com/nguyenvana",
        instagram: "instagram.com/nguyenvana",
        youtube: "youtube.com/c/nguyenvana",
        isActive: true,
        qrScans: 150,
        profileViews: 320,
      ),
      BusinessCard(
        name: "Trần Thị B",
        jobTitle: "Trưởng phòng Nhân sự",
        companyName: "Công ty Cổ phần XYZ",
        phone: "0987654321",
        email: "tranthib@example.com",
        website: "xyz-company.com",
        linkedin: "linkedin.com/in/tranthib",
        facebook: "facebook.com/tranthib",
        instagram: "instagram.com/tranthib",
        youtube: "",
        isActive: true,
        qrScans: 80,
        profileViews: 150,
      ),
      BusinessCard(
        name: "Lê Văn C",
        jobTitle: "Kỹ sư phần mềm",
        companyName: "Tech Solutions",
        phone: "0912345678",
        email: "levanc@techsolutions.com",
        website: "techsolutions.com",
        linkedin: "linkedin.com/in/levanc",
        facebook: "",
        instagram: "instagram.com/levanc",
        youtube: "",
        isActive: false,
        qrScans: 45,
        profileViews: 100,
      ),
    ];
  }

  @override
  void dispose() {
    _tabController.dispose();
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "QUẢN LÝ DANH BẠ",
          style: TextStyle(
            color: AppTheme.titleColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppTheme.primaryColor,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              icon: Icon(Icons.list),
              text: "Danh bạ",
            ),
            Tab(
              icon: Icon(Icons.qr_code_scanner),
              text: "Quét QR",
            ),
          ],
          labelColor: AppTheme.textPrimaryColor,
          unselectedLabelColor: AppTheme.iconInactiveColor,
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          indicatorColor: AppTheme.titleColor,
          indicatorWeight: 3,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildContactListView(),
          ScanQRCodeView(),
        ],
      ),
    );
  }

  // Tab 1: Danh bạ - Đã được cập nhật để sử dụng BusinessCard
  Widget _buildContactListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: contacts.length,
      itemBuilder: (context, index) {
        final contact = contacts[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8.0),
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: BorderSide(
              color: contact.isActive
                  ? AppTheme.successColor
                  : AppTheme.errorColor,
              width: 1,
            ),
          ),
          child: ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            leading: CircleAvatar(
              backgroundColor:
                  contact.isActive ? AppTheme.secondaryColor : Colors.grey,
              child: Text(
                contact.name.isNotEmpty ? contact.name[0].toUpperCase() : "?",
                style: TextStyle(color: Colors.white),
              ),
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    contact.name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: contact.isActive
                        ? AppTheme.successColor
                        : AppTheme.errorColor.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    contact.isActive ? "ON" : "OFF",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4),
                Text("${contact.jobTitle} tại ${contact.companyName}"),
                SizedBox(height: 2),
                Text(contact.phone),
              ],
            ),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            isThreeLine: true,
            onTap: () {
              // Hiển thị popup khi chọn một liên hệ
              BusinessCardPopup.showBusinessCardDetails(context, contact);
            },
          ),
        );
      },
    );
  }
}
