class ProfileUser {
  final String uid;
  final String name;
  final String email;
  final String profileImage;
  final String phone;
  final String ?startTime;
  final String ?endTime;
  final bool isOpen;
  final String ?longitude;
  final String? latitude;
  final String ?location;

  ProfileUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.profileImage,
    required this.phone,
    required this.startTime,
    required this.endTime,
    required this.isOpen,
    required this.longitude,
    required this.latitude,
    required this.location,
  });

  factory ProfileUser.fromMap(Map<String, dynamic> map) {
    return ProfileUser(
      uid: map['uid'] ?? '',
      name: map['userName'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'],
      profileImage: map['profileImage'] ?? '',
      startTime:map['startTime']??'',
      endTime: map['endTime']??'',
      isOpen: map['isOpen']??false,
      longitude: map['longitude']??'',
      latitude: map['latitude']??'',
      location: map['location']??''
    );
  }


}