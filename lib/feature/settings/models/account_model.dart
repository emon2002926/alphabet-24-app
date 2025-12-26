class AccountModel {
  final String fullName;
  final String email;
  final String phoneNumber;
  final String profilePicture;
  final String profilePictureUrl;
  final bool isPremium;

  AccountModel({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.profilePicture,
    required this.profilePictureUrl,
    required this.isPremium,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      fullName: json['full_name'] ?? "",
      email: json['email'] ?? "",
      phoneNumber: json['phone_number'] ?? "",
      profilePicture: json['profile_picture'] ?? "",
      profilePictureUrl: json['profile_picture_url'] ?? "",
      isPremium: json['is_premium'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'email': email,
      'phone_number': phoneNumber,
      'profile_picture': profilePicture,
      'profile_picture_url': profilePictureUrl,
      'is_premium': isPremium,
    };
  }
}