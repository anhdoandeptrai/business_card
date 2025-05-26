class User {
  String username;
  String password;
  String fullName;
  DateTime dateOfBirth;
  String gender; // Nam, Nữ, Other
  String phoneNumber;
  String email;
  UserRole role; // Added role field
  Subscription subscription; // Added subscription information

  User({
    required this.username,
    required this.password,
    required this.fullName,
    required this.dateOfBirth,
    required this.gender,
    required this.phoneNumber,
    required this.email,
    this.role = UserRole.regular, // Default to regular user
    this.subscription = const Subscription(),
  });

  // Convert User object to JSON
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'fullName': fullName,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'gender': gender,
      'phoneNumber': phoneNumber,
      'email': email,
      'role': role.toString(),
      'subscription': subscription.toJson(),
    };
  }

  // Create User object from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      password: json['password'],
      fullName: json['fullName'],
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      gender: json['gender'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      role: _parseUserRole(json['role'] ?? 'UserRole.regular'),
      subscription: json['subscription'] != null
          ? Subscription.fromJson(json['subscription'])
          : Subscription(),
    );
  }

  static UserRole _parseUserRole(String roleStr) {
    if (roleStr.contains('manager')) {
      return UserRole.manager;
    }
    return UserRole.regular;
  }

  // Check if user can create more cards
  bool canCreateMoreCards() {
    if (role == UserRole.manager) return true;
    return subscription.hasActiveSubscription;
  }
}

// User role enum
enum UserRole {
  regular,
  manager,
}

// Subscription class to track payment status
class Subscription {
  final bool hasActiveSubscription;
  final DateTime? expiryDate;
  final String? plan;

  const Subscription({
    this.hasActiveSubscription = false,
    this.expiryDate,
    this.plan,
  });

  Map<String, dynamic> toJson() {
    return {
      'hasActiveSubscription': hasActiveSubscription,
      'expiryDate': expiryDate?.toIso8601String(),
      'plan': plan,
    };
  }

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      hasActiveSubscription: json['hasActiveSubscription'] ?? false,
      expiryDate: json['expiryDate'] != null
          ? DateTime.parse(json['expiryDate'])
          : null,
      plan: json['plan'],
    );
  }
}
