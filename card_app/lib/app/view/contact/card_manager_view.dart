import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:get/get.dart';

class CardCodeManagerView extends StatefulWidget {
  @override
  _CardCodeManagerViewState createState() => _CardCodeManagerViewState();
}

class _CardCodeManagerViewState extends State<CardCodeManagerView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
        automaticallyImplyLeading: false, // Xóa nút quay lại
        title: Text("Quản lý mã danh thiếp"),
        backgroundColor: Colors.blue.shade400,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.code), text: "Nhập mã"),
            Tab(icon: Icon(Icons.qr_code_scanner), text: "Quét QR"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildEnterCardCodeView(), // Tab Nhập mã danh thiếp
          _buildScanQRCodeView(), // Tab Quét mã QR
        ],
      ),
    );
  }

  Widget _buildEnterCardCodeView() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: codeController,
            decoration: InputDecoration(
              labelText: "Nhập mã danh thiếp",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Logic lưu danh thiếp bằng mã
              if (codeController.text.isNotEmpty) {
                Get.snackbar("Thành công", "Danh thiếp đã được lưu!");
                codeController.clear();
              } else {
                Get.snackbar("Lỗi", "Vui lòng nhập mã danh thiếp!");
              }
            },
            child: Text("Lưu danh thiếp"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanQRCodeView() {
    return MobileScanner(
      onDetect: (barcode, args) {
        if (barcode.rawValue != null) {
          final String qrCode = barcode.rawValue!;
          // Logic lưu danh thiếp bằng mã QR
          Get.snackbar("Thành công", "Danh thiếp đã được lưu: $qrCode");
        }
      },
    );
  }
}
