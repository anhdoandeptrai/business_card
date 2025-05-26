import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../data/models/business_card.dart';
import '../widget/business_card_popup.dart';
import 'home_viewmodel.dart';

class QrScanViewModel extends GetxController {
  late HomeViewModel _homeViewModel;
  final Rx<MobileScannerController?> _cameraController =
      Rx<MobileScannerController?>(null);
  MobileScannerController? get cameraController => _cameraController.value;

  // Trạng thái đang quét
  final RxBool _isScanning = true.obs;
  bool get isScanning => _isScanning.value;

  // Trạng thái đèn pin
  final RxBool _isTorchOn = false.obs;
  bool get isTorchOn => _isTorchOn.value;

  // Ngăn quét trùng lặp
  final RxBool _isProcessingQR = false.obs;
  bool get isProcessingQR => _isProcessingQR.value;

  @override
  void onInit() {
    super.onInit();
    try {
      _homeViewModel = Get.find<HomeViewModel>();
    } catch (e) {
      _homeViewModel = Get.put(HomeViewModel());
    }

    // Khởi tạo camera sau một khoảng thời gian ngắn để đảm bảo widget đã được tạo
    Future.delayed(Duration(milliseconds: 100), () {
      _initCamera();
    });
  }

  // Khởi tạo camera
  void _initCamera() {
    // Hủy controller cũ nếu có
    if (_cameraController.value != null) {
      _cameraController.value?.dispose();
      _cameraController.value = null;
    }

    try {
      // Tạo controller mới
      final controller = MobileScannerController();
      _cameraController.value = controller;
    } catch (e) {
      print('Lỗi khi khởi tạo camera: $e');
      Get.snackbar(
        'Lỗi Camera',
        'Không thể khởi tạo camera: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 3),
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    if (_cameraController.value != null) {
      try {
        _cameraController.value?.dispose();
        _cameraController.value = null;
      } catch (e) {
        print('Lỗi khi dispose camera controller: $e');
      }
    }
    super.onClose();
  }

  // Bật/tắt đèn pin
  void toggleTorch() {
    if (_cameraController.value == null) return;

    try {
      _isTorchOn.value = !_isTorchOn.value;
      _cameraController.value?.toggleTorch();
    } catch (e) {
      print('Lỗi khi bật/tắt đèn pin: $e');
      _isTorchOn.value = !_isTorchOn.value; // Đảo lại trạng thái nếu lỗi
    }
  }

  // Xử lý khi phát hiện mã QR
  Future<void> processQrResult(Barcode barcode, BuildContext context) async {
    // Nếu đang xử lý, hoặc không có giá trị, bỏ qua
    if (_isProcessingQR.value || barcode.rawValue == null) {
      return;
    }

    // Đánh dấu đang xử lý
    _isProcessingQR.value = true;

    // Tạm dừng camera
    try {
      _cameraController.value?.stop();
    } catch (e) {
      print('Lỗi khi dừng camera: $e');
    }

    final String qrCode = barcode.rawValue!;

    try {
      // Giải mã thông tin từ QR Code
      final Map<String, dynamic> data = jsonDecode(qrCode);

      // Tạo đối tượng BusinessCard từ dữ liệu quét được
      final BusinessCard scannedCard = BusinessCard.fromJson(data);

      // Lưu vào danh sách danh bạ
      _homeViewModel.addContact(scannedCard);

      // Đợi một chút để UI cập nhật
      await Future.delayed(Duration(milliseconds: 300));

      // Kiểm tra và hiển thị popup
      if (context.mounted) {
        try {
          // Hiển thị popup
          await BusinessCardPopup.showBusinessCardDetails(context, scannedCard);

          // Đợi một chút trước khi khởi tạo lại camera
          await Future.delayed(Duration(milliseconds: 300));

          // Khởi tạo lại camera
          _initCamera();
        } catch (e) {
          print('Lỗi khi hiển thị popup: $e');
          // Khởi tạo lại camera trong trường hợp lỗi
          _initCamera();
        }
      } else {
        // Khởi tạo lại camera nếu context không còn hợp lệ
        _initCamera();
      }
    } catch (e) {
      // Hiển thị lỗi nếu mã QR không hợp lệ
      Get.snackbar(
        "Lỗi",
        "Không thể đọc thông tin từ mã QR: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );

      // Khởi tạo lại camera sau một khoảng thời gian ngắn
      await Future.delayed(Duration(milliseconds: 300));
      _initCamera();
    }

    // Đánh dấu đã xử lý xong
    _isProcessingQR.value = false;
  }
}
