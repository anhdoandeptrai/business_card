import 'dart:math';

class BusinessCard {
  String id; // Add unique ID field
  String name;
  String jobTitle;
  String companyName;
  String phone;
  String email;
  String website;
  String linkedin;
  String facebook;
  String instagram;
  String youtube;
  bool isActive;
  int qrScans;
  int profileViews;

  BusinessCard({
    String? id,
    required this.name,
    required this.jobTitle,
    required this.companyName,
    required this.phone,
    required this.email,
    required this.website,
    required this.linkedin,
    required this.facebook,
    required this.instagram,
    required this.youtube,
    this.isActive = true,
    this.qrScans = 0,
    this.profileViews = 0,
  }) : id = id ?? _generateId();

  // Generate a random ID if none provided
  static String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString() +
        Random().nextInt(1000).toString();
  }

  // Convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "jobTitle": jobTitle,
      "companyName": companyName,
      "phone": phone,
      "email": email,
      "website": website,
      "linkedin": linkedin,
      "facebook": facebook,
      "instagram": instagram,
      "youtube": youtube,
      "isActive": isActive,
      "qrScans": qrScans,
      "profileViews": profileViews,
    };
  }

  // Create object from JSON
  factory BusinessCard.fromJson(Map<String, dynamic> json) {
    return BusinessCard(
      id: json["id"] ?? _generateId(),
      name: json["name"] ?? "",
      jobTitle: json["jobTitle"] ?? "",
      companyName: json["companyName"] ?? "",
      phone: json["phone"] ?? "",
      email: json["email"] ?? "",
      website: json["website"] ?? "",
      linkedin: json["linkedin"] ?? "",
      facebook: json["facebook"] ?? "",
      instagram: json["instagram"] ?? "",
      youtube: json["youtube"] ?? "",
      isActive: json["isActive"] ?? true,
      qrScans: json["qrScans"] ?? 0,
      profileViews: json["profileViews"] ?? 0,
    );
  }

  // Clone method for creating a copy
  BusinessCard clone() {
    return BusinessCard(
      id: _generateId(), // New ID for clones
      name: name,
      jobTitle: jobTitle,
      companyName: companyName,
      phone: phone,
      email: email,
      website: website,
      linkedin: linkedin,
      facebook: facebook,
      instagram: instagram,
      youtube: youtube,
      isActive: isActive,
      qrScans: 0, // Reset stats for clones
      profileViews: 0,
    );
  }
}
