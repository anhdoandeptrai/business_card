import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user.dart';

class AuthService extends GetxService {
  final Rx<User?> currentUser = Rx<User?>(null);

  // Simulated users for demo purposes
  final List<User> _demoUsers = [
    User(
      username: 'regular_user',
      password: 'password123',
      fullName: 'Người Dùng Thường',
      dateOfBirth: DateTime(1990, 1, 1),
      gender: 'Nam',
      phoneNumber: '0901234567',
      email: 'regular@example.com',
      role: UserRole.regular,
      subscription: const Subscription(hasActiveSubscription: false),
    ),
    User(
      username: 'premium_user',
      password: 'password123',
      fullName: 'Người Dùng Premium',
      dateOfBirth: DateTime(1992, 5, 15),
      gender: 'Nữ',
      phoneNumber: '0909876543',
      email: 'premium@example.com',
      role: UserRole.regular,
      subscription: const Subscription(
          hasActiveSubscription: true, expiryDate: null, plan: 'Premium'),
    ),
    User(
      username: 'manager',
      password: 'manager123',
      fullName: 'Quản Lý Hệ Thống',
      dateOfBirth: DateTime(1985, 10, 20),
      gender: 'Nam',
      phoneNumber: '0977777777',
      email: 'manager@example.com',
      role: UserRole.manager,
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    _loadUserFromStorage();
  }

  // Login function
  Future<bool> login(String username, String password) async {
    // For demo purposes, find from demo users
    final user = _demoUsers.firstWhereOrNull(
        (user) => user.username == username && user.password == password);

    if (user != null) {
      currentUser.value = user;
      await _saveUserToStorage(user);
      return true;
    }
    return false;
  }

  // Logout function
  Future<void> logout() async {
    currentUser.value = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_user');
  }

  // Check if user is logged in
  bool get isLoggedIn => currentUser.value != null;

  // Check if user is a manager
  bool get isManager => currentUser.value?.role == UserRole.manager;

  // Check if user is premium
  bool get isPremium =>
      currentUser.value?.subscription.hasActiveSubscription ?? false;

  // Check if user can create more cards
  bool get canCreateMoreCards {
    // Manager can create unlimited cards
    if (isManager) return true;

    // Premium users can create up to 10 cards (or any other limit)
    if (isPremium) {
      // Để lấy số lượng thẻ hiện tại, chúng ta cần một cách để đếm
      // Ở đây giả định rằng user premium luôn có thể tạo, nhưng logic thực tế sẽ
      // được kiểm tra trong HomeViewModel.saveBusinessCard
      return true;
    }

    // Regular users can only create 1 card
    return false;
  }

  // Lấy giới hạn danh thiếp dựa trên loại tài khoản
  int getCardLimit() {
    if (isManager) return 999; // Không giới hạn cho manager
    if (isPremium) return 10; // 10 thẻ cho premium
    return 1; // 1 thẻ cho tài khoản thường
  }

  // Load user from SharedPreferences
  Future<void> _loadUserFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('current_user');

    if (userJson != null) {
      try {
        final map = jsonDecode(userJson);
        currentUser.value = User.fromJson(map);
      } catch (e) {
        print('Error loading user: $e');
      }
    }
  }

  // Save user to SharedPreferences
  Future<void> _saveUserToStorage(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode(user.toJson());
    await prefs.setString('current_user', userJson);
  }

  // Upgrade subscription for regular users
  Future<void> upgradeSubscription() async {
    if (currentUser.value != null &&
        currentUser.value!.role == UserRole.regular) {
      final user = currentUser.value!;

      // Create a new user object with updated subscription
      final updatedUser = User(
        username: user.username,
        password: user.password,
        fullName: user.fullName,
        dateOfBirth: user.dateOfBirth,
        gender: user.gender,
        phoneNumber: user.phoneNumber,
        email: user.email,
        role: user.role,
        subscription: Subscription(
          hasActiveSubscription: true,
          expiryDate: DateTime.now().add(Duration(days: 365)),
          plan: 'Premium',
        ),
      );

      currentUser.value = updatedUser;
      await _saveUserToStorage(updatedUser);
    }
  }
}
