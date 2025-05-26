import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:card_app/app/data/models/business_card.dart';
import 'package:card_app/app/theme/app_theme.dart';
import 'package:card_app/app/viewmodel/home_viewmodel.dart';
import 'package:card_app/app/data/services/auth_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fl_chart/fl_chart.dart';

class ReportsTabView extends StatefulWidget {
  @override
  _ReportsTabViewState createState() => _ReportsTabViewState();
}

class _ReportsTabViewState extends State<ReportsTabView> {
  final HomeViewModel homeViewModel = Get.find<HomeViewModel>();
  final AuthService authService = Get.find<AuthService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "BÁO CÁO THỐNG KÊ",
          style: TextStyle(
            color: AppTheme.titleColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Obx(() {
        final List<BusinessCard> cards = homeViewModel.allCards;

        if (cards.isEmpty) {
          return _buildEmptyReports();
        }

        return _buildReportsContent(cards);
      }),
    );
  }

  Widget _buildEmptyReports() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            FontAwesomeIcons.chartBar,
            size: 80,
            color: Colors.grey,
          ),
          SizedBox(height: 20),
          Text(
            "Chưa có dữ liệu báo cáo",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Tạo danh thiếp và chia sẻ để có dữ liệu thống kê",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildReportsContent(List<BusinessCard> cards) {
    // Calculate total views and scans
    int totalQrScans = cards.fold(0, (sum, card) => sum + card.qrScans);
    int totalProfileViews =
        cards.fold(0, (sum, card) => sum + card.profileViews);

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary Cards
          Row(
            children: [
              _buildSummaryCard(
                "Tổng lượt quét QR",
                totalQrScans.toString(),
                FontAwesomeIcons.qrcode,
                AppTheme.primaryColor,
              ),
              SizedBox(width: 10),
              _buildSummaryCard(
                "Tổng lượt xem thẻ",
                totalProfileViews.toString(),
                FontAwesomeIcons.eye,
                AppTheme.secondaryColor,
              ),
            ],
          ),
          SizedBox(height: 24),

          // Chart
          Container(
            height: 250,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Phân tích lượt xem theo danh thiếp",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 16),
                Expanded(
                  child: _buildBarChart(cards),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),

          // Cards List with Statistics
          Text(
            "Chi tiết theo danh thiếp",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 12),
          ...cards.map((card) => _buildCardStatItem(card)).toList(),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
      String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 18),
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChart(List<BusinessCard> cards) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: cards.isNotEmpty
            ? cards
                    .map((c) => c.qrScans > c.profileViews
                        ? c.qrScans.toDouble()
                        : c.profileViews.toDouble())
                    .reduce((a, b) => a > b ? a : b) *
                1.2
            : 10,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.grey.shade800,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${rodIndex == 0 ? "Lượt quét QR: " : "Lượt xem: "}${rod.toY.round()}',
                TextStyle(color: Colors.white),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                final index = value.toInt();
                if (index >= 0 && index < cards.length) {
                  // Short display name for card (first 6 chars)
                  return Text(
                    cards[index].name.length > 6
                        ? cards[index].name.substring(0, 6) + "..."
                        : cards[index].name,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  );
                }
                return const Text('');
              },
              reservedSize: 28,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                );
              },
              reservedSize: 30,
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(cards.length, (index) {
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: cards[index].qrScans.toDouble(),
                color: AppTheme.primaryColor,
                width: 12,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                ),
              ),
              BarChartRodData(
                toY: cards[index].profileViews.toDouble(),
                color: AppTheme.secondaryColor,
                width: 12,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildCardStatItem(BusinessCard card) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
        border: Border.all(
          color: card.isActive
              ? AppTheme.successColor.withOpacity(0.3)
              : AppTheme.errorColor.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: card.isActive
                    ? AppTheme.successColor.withOpacity(0.2)
                    : AppTheme.errorColor.withOpacity(0.2),
                child: Text(
                  card.name.isNotEmpty ? card.name[0].toUpperCase() : "?",
                  style: TextStyle(
                    color: card.isActive
                        ? AppTheme.successColor
                        : AppTheme.errorColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      card.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0, // Fixed the undefined variable a16
                      ),
                    ),
                    Text(
                      "${card.jobTitle} tại ${card.companyName}",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: card.isActive
                      ? AppTheme.successColor.withOpacity(0.1)
                      : AppTheme.errorColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: card.isActive
                        ? AppTheme.successColor
                        : AppTheme.errorColor,
                    width: 1,
                  ),
                ),
                child: Text(
                  card.isActive ? "Active" : "Inactive",
                  style: TextStyle(
                    color: card.isActive
                        ? AppTheme.successColor
                        : AppTheme.errorColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              _buildStatItem("Lượt quét QR", card.qrScans.toString(),
                  Icons.qr_code, AppTheme.primaryColor),
              SizedBox(width: 24),
              _buildStatItem("Lượt xem", card.profileViews.toString(),
                  Icons.remove_red_eye, AppTheme.secondaryColor),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          SizedBox(width: 4),
          Text(
            label + ": ",
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
