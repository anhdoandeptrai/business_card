import 'package:get/get.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import '../data/models/business_card.dart';
import '../data/services/local_storage_service.dart';
import '../data/services/auth_service.dart';
import '../view/card/create_card_view.dart';

class HomeViewModel extends GetxController {
  final LocalStorageService _localStorageService = LocalStorageService();
  final AuthService _authService = Get.find<AuthService>();

  final Rx<BusinessCard?> businessCard = Rx<BusinessCard?>(null);
  final RxString qrData = ''.obs; // Define qrData as an observable string
  final RxList<BusinessCard> contacts =
      <BusinessCard>[].obs; // Danh sách danh bạ
  final Rx<File?> avatar = Rx<File?>(null); // Avatar được quản lý bằng GetX

  // New fields to support multiple cards for manager role
  final RxList<BusinessCard> allCards = <BusinessCard>[].obs;
  final Rx<BusinessCard?> selectedCard = Rx<BusinessCard?>(null);

  // Danh sách liên hệ
  final RxList<BusinessCard> contactsList = <BusinessCard>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadBusinessCards(); // Load all cards instead of just one
  }

  // Load all business cards for managers, or just the active one for regular users
  Future<void> _loadBusinessCards() async {
    final cards = await _localStorageService.loadAllBusinessCards();

    if (cards.isNotEmpty) {
      allCards.value = cards;

      // For regular users, set the active card as the selected/main card
      if (!_authService.isManager) {
        businessCard.value = cards.firstWhereOrNull((card) => card.isActive);
      } else {
        // For managers, set the first card as selected by default
        selectedCard.value = cards.firstOrNull;
        businessCard.value = selectedCard.value;
      }
    }

    _generateQRCodeData(); // Generate QR data for the selected card
  }

  // Lưu danh thiếp
  Future<void> saveBusinessCard(BusinessCard card) async {
    // Check if this is a new card or updating existing one
    final existingIndex = allCards.indexWhere((c) => c.id == card.id);

    if (existingIndex >= 0) {
      // Update existing card
      allCards[existingIndex] = card;
    } else {
      // Add new card if user has permission or it's their first card
      final bool isPremium =
          _authService.currentUser.value?.subscription.hasActiveSubscription ??
              false;
      final int maxCards =
          isPremium ? 10 : 1; // Premium users can have up to 10 cards

      if (_authService.isManager ||
          allCards.length < maxCards ||
          allCards.isEmpty) {
        allCards.add(card);
      } else {
        // Show message that user needs to upgrade or has reached premium limit
        String message = isPremium
            ? "Bạn đã đạt giới hạn số lượng thẻ cho tài khoản Premium."
            : "Bạn đã đạt giới hạn số lượng thẻ. Vui lòng nâng cấp tài khoản để tạo thêm.";

        Get.snackbar(
          "Giới hạn tài khoản",
          message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: Duration(seconds: 5),
          mainButton: isPremium
              ? null
              : TextButton(
                  child: Text(
                    "NÂNG CẤP",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Get.toNamed('/subscription');
                  },
                ),
        );

        return; // Don't save the card
      }
    }

    // Ensure only one card is active for regular users
    if (!_authService.isManager &&
        !(_authService.currentUser.value?.subscription.hasActiveSubscription ??
            false)) {
      // If this is a new active card, deactivate all others
      if (card.isActive) {
        for (var i = 0; i < allCards.length; i++) {
          if (allCards[i].id != card.id && allCards[i].isActive) {
            final updatedCard = BusinessCard(
              id: allCards[i].id,
              name: allCards[i].name,
              jobTitle: allCards[i].jobTitle,
              companyName: allCards[i].companyName,
              phone: allCards[i].phone,
              email: allCards[i].email,
              website: allCards[i].website,
              linkedin: allCards[i].linkedin,
              facebook: allCards[i].facebook,
              instagram: allCards[i].instagram,
              youtube: allCards[i].youtube,
              isActive: false, // Deactivate
              qrScans: allCards[i].qrScans,
              profileViews: allCards[i].profileViews,
            );
            allCards[i] = updatedCard;
          }
        }
      }
    }

    // Update local storage
    await _localStorageService.saveAllBusinessCards(allCards);

    // Update current selected card if needed
    if (selectedCard.value?.id == card.id) {
      selectedCard.value = card;
      businessCard.value = card;
      _generateQRCodeData();
    }
  }

  // Select a specific card (for manager role)
  void selectCard(BusinessCard card) {
    selectedCard.value = card;
    businessCard.value = card;
    _generateQRCodeData();
  }

  // Delete a specific business card
  Future<void> deleteBusinessCard([BusinessCard? cardToDelete]) async {
    final card = cardToDelete ?? businessCard.value;

    if (card != null) {
      // Remove the card from allCards list
      allCards.removeWhere((c) => c.id == card.id);
      await _localStorageService.saveAllBusinessCards(allCards);

      // Handle updating the selected and displayed card
      if (selectedCard.value?.id == card.id ||
          businessCard.value?.id == card.id) {
        // The deleted card was either selected or displayed on Home
        if (allCards.isEmpty) {
          // If no cards left, set both to null
          selectedCard.value = null;
          businessCard.value = null;
          qrData.value = '';
        } else {
          // Select the first available card
          selectedCard.value = allCards.first;
          businessCard.value = allCards.first;
          _generateQRCodeData();
        }
      }

      // If the card pool is empty, make sure both values are null
      if (allCards.isEmpty) {
        selectedCard.value = null;
        businessCard.value = null;
        qrData.value = '';
      }

      // Notify UI about changes
      allCards.refresh();
    }
  }

  // Chuyển đến màn hình tạo danh thiếp
  void goToCreateCard() {
    Get.to(() => CreateCardView());
  }

  // Chuyển đến màn hình hồ sơ
  void goToProfile() {
    Get.toNamed('/profile');
  }

  // Chuyển đổi trạng thái thẻ (Active/Inactive)
  void toggleCardStatus([BusinessCard? card]) {
    final targetCard = card ?? businessCard.value;

    if (targetCard != null) {
      final index = allCards.indexWhere((c) => c.id == targetCard.id);
      if (index >= 0) {
        // Create a new card instance with toggled status
        final updatedCard = BusinessCard(
          id: targetCard.id,
          name: targetCard.name,
          jobTitle: targetCard.jobTitle,
          companyName: targetCard.companyName,
          phone: targetCard.phone,
          email: targetCard.email,
          website: targetCard.website,
          linkedin: targetCard.linkedin,
          facebook: targetCard.facebook,
          instagram: targetCard.instagram,
          youtube: targetCard.youtube,
          isActive: !targetCard.isActive,
          qrScans: targetCard.qrScans,
          profileViews: targetCard.profileViews,
        );

        allCards[index] = updatedCard;

        // Update selected card if necessary
        if (selectedCard.value?.id == updatedCard.id) {
          selectedCard.value = updatedCard;
          businessCard.value = updatedCard;
        }

        _localStorageService.saveAllBusinessCards(allCards);
        _generateQRCodeData();
      }
    }
  }

  // Generate QR code data
  void _generateQRCodeData() {
    if (businessCard.value != null && businessCard.value!.isActive) {
      final card = businessCard.value!;
      qrData.value = jsonEncode({
        "id": card.id,
        "name": card.name,
        "jobTitle": card.jobTitle,
        "companyName": card.companyName,
        "phone": card.phone,
        "email": card.email,
        "website": card.website,
        "linkedin": card.linkedin,
        "facebook": card.facebook,
        "instagram": card.instagram,
        "youtube": card.youtube,
      });
    } else {
      qrData.value = '';
    }
  }

  void updateAvatar(File? newAvatar) {
    avatar.value = newAvatar;
  }

  void addContact(BusinessCard scannedCard) {}
}
