import 'package:get/get.dart';
import '../data/models/business_card.dart';
import 'home_viewmodel.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class CreateCardViewModel extends GetxController {
  final HomeViewModel homeViewModel = Get.find<HomeViewModel>();
  final ImagePicker _picker = ImagePicker();

  var name = ''.obs;
  var jobTitle = ''.obs;
  var companyName = ''.obs;
  var phone = ''.obs;
  var email = ''.obs;
  var website = ''.obs;
  var linkedin = ''.obs;
  var facebook = ''.obs;
  var instagram = ''.obs;
  var youtube = ''.obs;
  final RxString address = "".obs;

  final Rx<File?> logo = Rx<File?>(null);
  final Rx<File?> avatar = Rx<File?>(null);

  @override
  void onInit() {
    super.onInit();
    // Nếu có danh thiếp, tải dữ liệu vào các trường
    final card = homeViewModel.businessCard.value;
    if (card != null) {
      name.value = card.name;
      jobTitle.value = card.jobTitle;
      companyName.value = card.companyName;
      phone.value = card.phone;
      email.value = card.email;
      website.value = card.website;
      linkedin.value = card.linkedin;
      facebook.value = card.facebook;
      instagram.value = card.instagram;
      youtube.value = card.youtube;
    }
  }

  // Lưu danh thiếp
  Future<void> saveBusinessCard() async {
    BusinessCard card = BusinessCard(
      name: name.value,
      jobTitle: jobTitle.value,
      companyName: companyName.value,
      phone: phone.value,
      email: email.value,
      website: website.value,
      linkedin: linkedin.value,
      facebook: facebook.value,
      instagram: instagram.value,
      youtube: youtube.value,
    );

    await homeViewModel.saveBusinessCard(card); // Đồng bộ hóa với HomeViewModel
  }

  // Xóa danh thiếp
  Future<void> deleteBusinessCard() async {
    await homeViewModel.deleteBusinessCard(); // Đồng bộ hóa với HomeViewModel
    clearFields();
  }

  // Xóa dữ liệu trong các trường
  void clearFields() {
    name.value = '';
    jobTitle.value = '';
    companyName.value = '';
    phone.value = '';
    email.value = '';
    website.value = '';
    linkedin.value = '';
    facebook.value = '';
    instagram.value = '';
    youtube.value = '';
  }

  // Phương thức để chọn logo
  void pickLogo() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {
      logo.value = File(image.path);
    }
  }

  // Phương thức để chọn avatar
  void pickAvatar() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {
      avatar.value = File(image.path);
    }
  }
}
