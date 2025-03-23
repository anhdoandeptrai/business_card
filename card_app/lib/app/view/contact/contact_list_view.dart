import 'package:flutter/material.dart';

class ContactListView extends StatelessWidget {
  final List<Map<String, String>> contacts = [
    {
      "name": "John Doe",
      "jobTitle": "Software Engineer",
      "company": "TechCorp"
    },
    {
      "name": "Jane Smith",
      "jobTitle": "Product Manager",
      "company": "InnovateX"
    },
  ]; // Danh sách danh bạ mẫu

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Xóa nút quay lại
        title: Text("Danh sách danh bạ"),
        backgroundColor: Colors.blue.shade400,
      ),
      body: contacts.isEmpty
          ? Center(child: Text("Chưa có danh bạ nào"))
          : ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final contact = contacts[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(contact["name"]![0]), // Chữ cái đầu tiên
                  ),
                  title: Text(contact["name"]!),
                  subtitle:
                      Text("${contact["jobTitle"]} - ${contact["company"]}"),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () {
                    // Điều hướng đến màn hình chi tiết danh bạ (nếu cần)
                  },
                );
              },
            ),
    );
  }
}
