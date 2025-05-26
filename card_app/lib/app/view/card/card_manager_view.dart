import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../viewmodel/home_viewmodel.dart';
import '../../theme/app_theme.dart';
import '../../data/models/business_card.dart';
import '../../data/services/auth_service.dart';
import '../card/edit_card_view.dart';
import '../card/create_card_view.dart';
import '../../widget/business_card_popup.dart';

class CardManagerView extends StatelessWidget {
  final HomeViewModel viewModel = Get.find<HomeViewModel>();
  final AuthService authService = Get.find<AuthService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "QUẢN LÝ DANH THIẾP",
          style: TextStyle(
            color: AppTheme.titleColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Column(
        children: [
          _buildCardCounter(),
          Expanded(
            child: Obx(() {
              if (viewModel.allCards.isEmpty) {
                return _buildEmptyState();
              }
              return _buildCardsList();
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Check if user can create more cards
          if (authService.canCreateMoreCards || viewModel.allCards.isEmpty) {
            Get.to(() => CreateCardView());
          } else {
            _showSubscriptionDialog(context);
          }
        },
        backgroundColor: AppTheme.buttonColor,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildCardCounter() {
    return Container(
      padding: EdgeInsets.all(16),
      color: AppTheme.primaryColor.withOpacity(0.1),
      child: Obx(() {
        final cardCount = viewModel.allCards.length;
        final isPremium =
            authService.currentUser.value?.subscription.hasActiveSubscription ??
                false;
        final maxCards = authService.isManager ? "∞" : (isPremium ? "∞" : "1");
        final canCreateMore =
            authService.canCreateMoreCards || viewModel.allCards.isEmpty;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Danh thiếp của bạn",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Row(
              children: [
                Text(
                  "Số lượng: ",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "$cardCount / $maxCards",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: canCreateMore
                        ? AppTheme.successColor
                        : AppTheme.errorColor,
                  ),
                ),
                if (!canCreateMore && !authService.isManager && !isPremium)
                  IconButton(
                    icon: Icon(Icons.upgrade, color: AppTheme.buttonColor),
                    onPressed: () => Get.toNamed('/subscription'),
                    tooltip: "Nâng cấp tài khoản",
                  ),
              ],
            ),
          ],
        );
      }),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.credit_card,
            size: 80,
            color: Colors.grey,
          ),
          SizedBox(height: 20),
          Text(
            "Chưa có danh thiếp nào",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Nhấn nút + để tạo danh thiếp đầu tiên",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => Get.to(() => CreateCardView()),
            icon: Icon(Icons.add),
            label: Text("Tạo danh thiếp"),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.buttonColor,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardsList() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: viewModel.allCards.length,
      itemBuilder: (context, index) {
        final card = viewModel.allCards[index];
        final isSelected = viewModel.selectedCard.value?.id == card.id;

        return Card(
          margin: EdgeInsets.only(bottom: 12),
          elevation: isSelected ? 4 : 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isSelected ? AppTheme.primaryColor : Colors.transparent,
              width: isSelected ? 2 : 0,
            ),
          ),
          child: InkWell(
            onTap: () {
              viewModel.selectCard(card);
              Get.back(); // Close the manager view
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  // Card icon or avatar
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: card.isActive
                          ? AppTheme.primaryColor.withOpacity(0.1)
                          : Colors.grey.shade200,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: card.isActive
                            ? AppTheme.primaryColor
                            : Colors.grey.shade400,
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        card.name.isNotEmpty ? card.name[0].toUpperCase() : "?",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: card.isActive
                              ? AppTheme.primaryColor
                              : Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),

                  // Card details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                card.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: card.isActive
                                    ? AppTheme.successColor.withOpacity(0.1)
                                    : AppTheme.errorColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                card.isActive ? "Active" : "Inactive",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: card.isActive
                                      ? AppTheme.successColor
                                      : AppTheme.errorColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            if (isSelected)
                              Container(
                                margin: EdgeInsets.only(left: 4),
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.check,
                                  size: 16,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Text(
                          "${card.jobTitle} tại ${card.companyName}",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.remove_red_eye,
                                size: 14, color: Colors.grey[600]),
                            SizedBox(width: 4),
                            Text(
                              "${card.profileViews}",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(width: 12),
                            Icon(Icons.qr_code,
                                size: 14, color: Colors.grey[600]),
                            SizedBox(width: 4),
                            Text(
                              "${card.qrScans}",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Actions
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      switch (value) {
                        case 'view':
                          BusinessCardPopup.showBusinessCardDetails(
                              context, card);
                          break;
                        case 'edit':
                          Get.to(() => EditCardView(card: card));
                          break;
                        case 'toggle':
                          viewModel.toggleCardStatus(card);
                          break;
                        case 'delete':
                          _showDeleteConfirmation(context, card);
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'view',
                        child: Row(
                          children: [
                            Icon(Icons.visibility, size: 18),
                            SizedBox(width: 8),
                            Text("Xem"),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 18),
                            SizedBox(width: 8),
                            Text("Chỉnh sửa"),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'toggle',
                        child: Row(
                          children: [
                            Icon(
                              card.isActive
                                  ? Icons.toggle_off
                                  : Icons.toggle_on,
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Text(card.isActive ? "Vô hiệu hóa" : "Kích hoạt"),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 18, color: Colors.red),
                            SizedBox(width: 8),
                            Text("Xóa", style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, BusinessCard card) {
    Get.dialog(
      AlertDialog(
        title: Text("Xác nhận"),
        content: Text("Bạn có chắc chắn muốn xóa danh thiếp '${card.name}'?"),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("Hủy"),
          ),
          TextButton(
            onPressed: () {
              viewModel.deleteBusinessCard(card);
              Get.back();
            },
            child: Text("Xóa", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showSubscriptionDialog(BuildContext context) {
    final bool isPremium =
        authService.currentUser.value?.subscription.hasActiveSubscription ??
            false;

    if (isPremium) {
      Get.dialog(
        AlertDialog(
          title: Text("Giới hạn đạt mức"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.info_outline,
                color: AppTheme.infoColor,
                size: 50,
              ),
              SizedBox(height: 16),
              Text(
                "Bạn đã tạo đến giới hạn số lượng danh thiếp cho tài khoản Premium.",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                "Vui lòng liên hệ hỗ trợ kỹ thuật để nâng cấp hạn mức.",
                textAlign: TextAlign.center,
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text("Đóng"),
            ),
          ],
        ),
      );
    } else {
      Get.dialog(
        AlertDialog(
          title: Text("Nâng cấp tài khoản"),
          content: Text(
            "Bạn đã đạt giới hạn số lượng danh thiếp. Vui lòng nâng cấp tài khoản để tạo thêm danh thiếp mới.",
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text("Đóng"),
            ),
            ElevatedButton(
              onPressed: () {
                Get.back();
                Get.toNamed('/subscription');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.buttonColor,
              ),
              child: Text("Nâng cấp ngay"),
            ),
          ],
        ),
      );
    }
  }
}
