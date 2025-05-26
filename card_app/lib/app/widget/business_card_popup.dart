import 'package:flutter/material.dart';
import '../data/models/business_card.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

class BusinessCardPopup {
  static Future<void> showBusinessCardDetails(
      BuildContext context, BusinessCard card) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: _buildDialogContent(context, card),
        );
      },
    );
  }

  static Widget _buildDialogContent(BuildContext context, BusinessCard card) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: Offset(0.0, 10.0),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Thông tin danh thiếp',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            Divider(),

            // Thông tin cá nhân
            _sectionTitle('Thông tin cá nhân/nghề nghiệp'),
            _infoRow('Họ và tên', card.name),
            _infoRow('Chức vụ', card.jobTitle),
            _infoRow('Công ty', card.companyName),
            SizedBox(height: 10),

            // Thông tin liên hệ
            _sectionTitle('Thông tin liên hệ'),
            _contactRow(
                'Điện thoại', card.phone, Icons.phone, 'tel:${card.phone}'),
            _contactRow(
                'Email', card.email, Icons.email, 'mailto:${card.email}'),
            _contactRow('Website', card.website, Icons.language,
                _formatUrl(card.website)),
            SizedBox(height: 10),

            // Mạng xã hội
            _sectionTitle('Mạng xã hội'),
            _contactRow('LinkedIn', card.linkedin, Icons.link,
                _formatUrl(card.linkedin)),
            _contactRow('Facebook', card.facebook, Icons.facebook,
                _formatUrl(card.facebook)),
            _contactRow('Instagram', card.instagram, Icons.camera_alt,
                _formatUrl(card.instagram)),
            _contactRow('YouTube', card.youtube, Icons.video_library,
                _formatUrl(card.youtube)),
            SizedBox(height: 10),

            // Thống kê
            _sectionTitle('Thống kê'),
            _infoRow(
                'Trạng thái', card.isActive ? 'Hoạt động' : 'Không hoạt động'),
            _infoRow('Lượt quét QR', '${card.qrScans} lượt'),
            _infoRow('Lượt xem hồ sơ', '${card.profileViews} lượt'),
            SizedBox(height: 20),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  icon: Icon(Icons.share),
                  label: Text('Chia sẻ'),
                  onPressed: () {
                    Get.back();
                    Get.snackbar(
                        'Thông báo', 'Chức năng chia sẻ đang được phát triển');
                  },
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  icon: Icon(Icons.qr_code),
                  label: Text('Xem mã QR'),
                  onPressed: () {
                    Get.back();
                    Get.snackbar('Thông báo',
                        'Chức năng xem mã QR đang được phát triển');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blue[800],
        ),
      ),
    );
  }

  static Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label + ':',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : 'Không có',
              style: TextStyle(
                color: value.isNotEmpty ? Colors.black : Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _contactRow(
      String label, String value, IconData icon, String url) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label + ':',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: value.isNotEmpty
                ? InkWell(
                    onTap: () => _launchUrl(url),
                    child: Row(
                      children: [
                        Icon(icon, size: 16, color: Colors.blue),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            value,
                            style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Text(
                    'Không có',
                    style: TextStyle(color: Colors.grey),
                  ),
          ),
        ],
      ),
    );
  }

  static Future<void> _launchUrl(String url) async {
    if (url.isEmpty) return;

    try {
      await launchUrl(Uri.parse(url));
    } catch (e) {
      print('Không thể mở liên kết: $url');
    }
  }

  static String _formatUrl(String url) {
    if (url.isEmpty) return '';
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return url;
    }
    return 'https://$url';
  }
}
