import 'package:get/get.dart';
import '../data/models/business_card.dart';
import '../data/services/local_storage_service.dart';
import '../data/services/qr_code_service.dart';
import '../view/card/create_card_view.dart';

class HomeViewModel extends GetxController {
  final LocalStorageService _localStorageService = LocalStorageService();
  final QRCodeService _qrCodeService = QRCodeService();

  var businessCard = Rxn<BusinessCard>(); // Lưu danh thiếp hiện tại
  var qrData = ''.obs; // Dữ liệu QR

  @override
  void onInit() {
    super.onInit();
    _loadBusinessCard(); // Tải danh thiếp khi khởi tạo
  }

  // Tải danh thiếp từ LocalStorage
  Future<void> _loadBusinessCard() async {
    final card = await _localStorageService.loadBusinessCard();
    businessCard.value = card;
    if (card != null) {
      qrData.value = _qrCodeService.generateQRData(card);
    }
  }

  // Lưu danh thiếp
  Future<void> saveBusinessCard(BusinessCard card) async {
    await _localStorageService.saveBusinessCard(card);
    businessCard.value = card; // Cập nhật dữ liệu trong ViewModel
    qrData.value = _qrCodeService.generateQRData(card);
  }

  // Xóa danh thiếp
  Future<void> deleteBusinessCard() async {
    await _localStorageService.deleteBusinessCard();
    businessCard.value = null; // Xóa dữ liệu trong ViewModel
    qrData.value = '';
  }

  // Chuyển đến màn hình tạo danh thiếp
  void goToCreateCard() {
    Get.to(() => CreateCardView());
  }

  // Chuyển đến màn hình hồ sơ
  void goToProfile() {
    Get.toNamed('/profile');
  }
}
