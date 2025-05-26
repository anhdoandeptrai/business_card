import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_theme.dart';
import '../../data/services/auth_service.dart';

class SubscriptionView extends StatelessWidget {
  final AuthService authService = Get.find<AuthService>();

  @override
  Widget build(BuildContext context) {
    // Kiểm tra nếu người dùng đã là premium
    final bool isPremium =
        authService.currentUser.value?.subscription.hasActiveSubscription ??
            false;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isPremium ? "TÀI KHOẢN PREMIUM" : "NÂNG CẤP TÀI KHOẢN",
          style: TextStyle(
            color: AppTheme.titleColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: isPremium ? _buildPremiumView() : _buildUpgradeView(),
    );
  }

  // Hiển thị thông tin tài khoản Premium
  Widget _buildPremiumView() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.3),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(
                  Icons.verified,
                  size: 70,
                  color: Colors.amber,
                ),
                SizedBox(height: 10),
                Text(
                  "Tài khoản Premium",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Bạn đang sử dụng gói tài khoản cao cấp với đầy đủ tính năng",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 30),

          Text(
            "Đặc quyền của bạn",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),

          // Danh sách đặc quyền
          _buildPremiumFeature("Tạo không giới hạn danh thiếp",
              "Tạo nhiều danh thiếp cho các mục đích khác nhau"),
          _buildPremiumFeature("Đầy đủ tùy chọn thiết kế",
              "Tùy chỉnh danh thiếp với nhiều tùy chọn thiết kế hơn"),
          _buildPremiumFeature("Báo cáo chi tiết",
              "Xem thống kê chi tiết về lượt sử dụng danh thiếp của bạn"),
          _buildPremiumFeature(
              "Xuất dữ liệu", "Xuất dữ liệu và báo cáo để phân tích nâng cao"),
          _buildPremiumFeature("Hỗ trợ ưu tiên",
              "Được hỗ trợ kỹ thuật với mức độ ưu tiên cao hơn"),

          SizedBox(height: 30),

          Text(
            "Gói Premium có hiệu lực đến: 31/12/2024",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumFeature(String title, String description) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: AppTheme.successColor,
            size: 30,
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Màn hình nâng cấp cho tài khoản thường
  Widget _buildUpgradeView() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          SizedBox(height: 24),
          _buildPricingPlans(),
          SizedBox(height: 24),
          _buildFeatureComparison(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            "Mở khóa tất cả tính năng",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Nâng cấp tài khoản để tạo nhiều danh thiếp và sử dụng tất cả tính năng cao cấp",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingPlans() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Chọn gói phù hợp với bạn",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        _buildPricingCard(
          title: "Cơ bản",
          price: "0đ",
          period: "Miễn phí",
          features: [
            "Tạo 1 danh thiếp",
            "Chia sẻ qua mã QR",
            "Số lượt xem hồ sơ giới hạn",
            "Không có báo cáo chi tiết",
          ],
          isActive: true,
          isRecommended: false,
        ),
        SizedBox(height: 16),
        _buildPricingCard(
          title: "Premium",
          price: "199.000đ",
          period: "1 năm",
          features: [
            "Tạo không giới hạn danh thiếp",
            "Đầy đủ tùy chọn thiết kế",
            "Báo cáo chi tiết",
            "Xuất dữ liệu báo cáo",
            "Hỗ trợ kỹ thuật ưu tiên",
          ],
          isActive: false,
          isRecommended: true,
          onTap: _handleSubscription,
        ),
      ],
    );
  }

  Widget _buildPricingCard({
    required String title,
    required String price,
    required String period,
    required List<String> features,
    required bool isActive,
    bool isRecommended = false,
    VoidCallback? onTap,
  }) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isRecommended
              ? AppTheme.buttonColor
              : Colors.grey.withOpacity(0.3),
          width: isRecommended ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isRecommended
                ? AppTheme.buttonColor.withOpacity(0.2)
                : Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isRecommended ? AppTheme.buttonColor : Colors.black,
                ),
              ),
              if (isRecommended)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.buttonColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    "Khuyên dùng",
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.buttonColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                price,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 4),
              Text(
                "/ " + period,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          ...features.map((feature) => _buildFeatureItem(feature)),
          SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isActive ? null : onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isRecommended ? AppTheme.buttonColor : Colors.grey.shade300,
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                isActive ? "Gói hiện tại" : "Nâng cấp ngay",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String feature) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: AppTheme.successColor,
            size: 18,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              feature,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureComparison() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "So sánh tính năng",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        Table(
          border: TableBorder.all(
            color: Colors.grey.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          columnWidths: {
            0: FlexColumnWidth(3),
            1: FlexColumnWidth(2),
            2: FlexColumnWidth(2),
          },
          children: [
            _buildTableRow(
              "Tính năng",
              "Cơ bản",
              "Premium",
              isHeader: true,
            ),
            _buildTableRow(
              "Số lượng danh thiếp",
              "1",
              "Không giới hạn",
            ),
            _buildTableRow(
              "Báo cáo chi tiết",
              "Không",
              "Có",
            ),
            _buildTableRow(
              "Tùy chọn thiết kế",
              "Cơ bản",
              "Đầy đủ",
            ),
            _buildTableRow(
              "Xuất dữ liệu",
              "Không",
              "Có",
            ),
            _buildTableRow(
              "Hỗ trợ kỹ thuật",
              "Tiêu chuẩn",
              "Ưu tiên",
            ),
          ],
        ),
      ],
    );
  }

  TableRow _buildTableRow(
    String feature,
    String basic,
    String premium, {
    bool isHeader = false,
  }) {
    return TableRow(
      decoration: BoxDecoration(
        color: isHeader ? Colors.grey.withOpacity(0.1) : null,
      ),
      children: [
        TableCell(
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              feature,
              style: TextStyle(
                fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Center(
              child: Text(
                basic,
                style: TextStyle(
                  fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Center(
              child: Text(
                premium,
                style: TextStyle(
                  fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _handleSubscription() {
    // Mock payment process
    Get.dialog(
      AlertDialog(
        title: Text("Xác nhận thanh toán"),
        content: Text(
            "Bạn sẽ được chuyển đến trang thanh toán để nâng cấp tài khoản Premium."),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("Hủy"),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _showPaymentSuccess();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.buttonColor,
            ),
            child: Text("Thanh toán ngay"),
          ),
        ],
      ),
    );
  }

  void _showPaymentSuccess() {
    // Mock successful payment
    authService.upgradeSubscription();

    Get.dialog(
      AlertDialog(
        title: Text("Thanh toán thành công"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_outline,
              color: AppTheme.successColor,
              size: 70,
            ),
            SizedBox(height: 16),
            Text(
              "Chúc mừng! Tài khoản của bạn đã được nâng cấp lên Premium",
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.offAllNamed('/home');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.buttonColor,
            ),
            child: Text("Bắt đầu sử dụng"),
          ),
        ],
      ),
    );
  }
}
