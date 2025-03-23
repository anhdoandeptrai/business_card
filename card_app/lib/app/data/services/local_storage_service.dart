import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart'; // Thêm import này
import '../models/business_card.dart';

class LocalStorageService {
  static const String _keyBusinessCard = "business_card";

  // Lưu danh thiếp vào SharedPreferences
  Future<void> saveBusinessCard(BusinessCard card) async {
    final prefs = await SharedPreferences.getInstance();
    String cardJson = jsonEncode(card.toJson());
    await prefs.setString(_keyBusinessCard, cardJson);
  }

  // Tải danh thiếp từ SharedPreferences
  Future<BusinessCard?> loadBusinessCard() async {
    final prefs = await SharedPreferences.getInstance();
    String? cardJson = prefs.getString(_keyBusinessCard);
    if (cardJson != null) {
      return BusinessCard.fromJson(jsonDecode(cardJson));
    }
    return null; // Chỉ trả về null nếu không có dữ liệu
  }

  // Xóa danh thiếp khỏi SharedPreferences
  Future<void> deleteBusinessCard() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyBusinessCard);
  }
}
