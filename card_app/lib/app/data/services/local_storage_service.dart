import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/business_card.dart';

class LocalStorageService {
  static const String _keyBusinessCard = "business_card";

  // Save all business cards
  Future<void> saveAllBusinessCards(List<BusinessCard> cards) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = cards.map((card) => jsonEncode(card.toJson())).toList();
    await prefs.setStringList('all_business_cards', jsonList);
  }

  // Load all business cards
  Future<List<BusinessCard>> loadAllBusinessCards() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList('all_business_cards');

    if (jsonList == null || jsonList.isEmpty) {
      return [];
    }

    return jsonList.map((jsonStr) {
      final data = jsonDecode(jsonStr);
      return BusinessCard.fromJson(data);
    }).toList();
  }

  // Legacy method - Save a single business card
  Future<void> saveBusinessCard(BusinessCard card) async {
    final prefs = await SharedPreferences.getInstance();
    final allCards = await loadAllBusinessCards();

    // Check if card exists
    final index = allCards.indexWhere((c) => c.id == card.id);
    if (index >= 0) {
      allCards[index] = card;
    } else {
      allCards.add(card);
    }

    await saveAllBusinessCards(allCards);

    // Keep backward compatibility
    await prefs.setString('business_card', jsonEncode(card.toJson()));
  }

  // Legacy method - Load a single business card
  Future<BusinessCard?> loadBusinessCard() async {
    final prefs = await SharedPreferences.getInstance();
    final cardJson = prefs.getString('business_card');
    if (cardJson == null) {
      // Try to load from all cards
      final allCards = await loadAllBusinessCards();
      if (allCards.isNotEmpty) {
        return allCards.firstWhere((card) => card.isActive,
            orElse: () => allCards.first);
      }
      return null;
    }

    final data = jsonDecode(cardJson);
    return BusinessCard.fromJson(data);
  }

  // Legacy method - Delete a single business card
  Future<void> deleteBusinessCard() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('business_card');

    // Also remove from all cards if it's the only one
    final allCards = await loadAllBusinessCards();
    if (allCards.length == 1) {
      await prefs.remove('all_business_cards');
    }
  }
}
