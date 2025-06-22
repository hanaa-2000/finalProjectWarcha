class ProfileClientModel {
  final String id;
  final String ?image;
  final String name;
  final String email;
  final String phone;

  ProfileClientModel({
    required this.id,
    required this.name,
    required this.phone,
    this.image,
    required this.email,
  });

  factory ProfileClientModel.fromJson(Map<String, dynamic> json, String docId) {
    return ProfileClientModel(
      id: docId,
      name: json['userName'] ?? '',
      image: json['profileImage']??'',
      phone: json['phone'],
      email: json['email']??'',

    );
  }
}

