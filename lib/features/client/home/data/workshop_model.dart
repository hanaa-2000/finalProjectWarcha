class WorkshopModel {
  final String id;
  final String ?image;
  final String ?location;
  final String name;
  final String phone;
  final String ?longitude;
  final String? latitude;
  final bool ?isOpen;
  final String ?endTime;
  final String ? startTime;

  bool ?isBooked; // نجعلها قابلة للتعديل


  WorkshopModel({
    required this.id,
    required this.name,
    required this.phone,
    this.location,
    this.image,
     this.isOpen,
     this.latitude,
     this.longitude,
    this.isBooked,
    this.startTime,
    this.endTime,
  });

  factory WorkshopModel.fromJson(Map<String, dynamic> json, String docId) {
    return WorkshopModel(
        id: docId,
        name: json['userName'] ?? '',
        image: json['profileImage']??'',
        phone: json['phone'],
        isOpen: json['isOpen']??false,
        latitude: json['latitude']??'',
        longitude: json['longitude']??'',
        location: json['location']??'',
      isBooked: json['isBooked'],
      endTime: json["startTime"],
      startTime: json['endTime']

    );
  }
  factory WorkshopModel.simpleFromJson(Map<String, dynamic> json) {
    return WorkshopModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'],
      phone: json['phone'] ?? '',
      isOpen: json['isOpen'] ?? false,
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
      location: json['location'] ?? '',
      isBooked: json['isBooked'],
      endTime: json["endTime"],
      startTime: json['startTime'],
    );
  }


  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "image": this.image,
      "location": this.location,
      "name": this.name,
      "phone": this.phone,
      "longitude": this.longitude,
      "latitude": this.latitude,
      "isOpen": this.isOpen,
      "endTime": this.endTime,
      "startTime": this.startTime,
      "isBooked": this.isBooked,
    };
  }


}

