class BusinessCard {
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

  BusinessCard({
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
  });

  // Convert object to JSON
  Map<String, dynamic> toJson() {
    return {
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
    };
  }

  // Create object from JSON
  factory BusinessCard.fromJson(Map<String, dynamic> json) {
    return BusinessCard(
      name: json["name"],
      jobTitle: json["jobTitle"],
      companyName: json["companyName"],
      phone: json["phone"],
      email: json["email"],
      website: json["website"],
      linkedin: json["linkedin"],
      facebook: json["facebook"],
      instagram: json["instagram"],
      youtube: json["youtube"],
    );
  }
}
