import 'package:cloud_firestore/cloud_firestore.dart';

class AccessoriesModel {
  final String image;
  final String companyName;
  final String specifications;
  final String countryManufacture;
  final String yearManufacture;
  final String price;
  final String id;
  final String workshopName;
  final String workshopId;
  final String? location;
  final String phone;
  final String ?latitude;
  final String ?longitude;
  final List<String>? bookedBy; // قائمة العملاء الذين حجزوا المنتج
  //final List<String>? bookingsProduct;
  AccessoriesModel({
    this.bookedBy,
    required this.image,required this.companyName,required this.specifications,required this.workshopId,
    required this.countryManufacture,required this.yearManufacture,required this.price,required this.id, this.location, this.latitude,  this.longitude , required this.phone,required this.workshopName
  });
  factory AccessoriesModel.fromDocument(DocumentSnapshot json, String id) {
    final data = json.data() as Map<String, dynamic>;

    return AccessoriesModel(
        image: data["image"]as String,
        companyName: data["companyName"] as String,
        specifications: data["specifications"],
        countryManufacture: data["countryManufacture"],
        yearManufacture: data["yearManufacture"],
        price:data["price"],
        id: json.id,
        location: data['location']??'',
        latitude: data['latitude']??'',
      longitude: data['longitude']??'',
      phone: data['phone'],
      workshopName: data['userName'],
      workshopId: data['workshopId'],
      bookedBy: data['bookedBy'] != null
          ? List<String>.from(data['bookedBy'])
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "image": this.image,
      "companyName": this.companyName,
      "specifications": this.specifications,
      "countryManufacture": this.countryManufacture,
      "yearManufacture": this.yearManufacture,
      "price": this.price,
      "id": this.id,
      'userName':this.workshopName,
      'workshopId':this.workshopId,
      "phone":this.phone,
      "longitude":this.longitude,
      "latitude":this.latitude,
      "location":this.location,
      "bookedBy": bookedBy ?? [],
    };
  }


  factory AccessoriesModel.fromJson(Map<String, dynamic> json, String docId) {
    return AccessoriesModel(
      image: json["image"] as String,
      companyName: json["companyName"] as String,
      specifications: json["specifications"],
      countryManufacture: json["countryManufacture"],
      yearManufacture: json["yearManufacture"],
      price: json["price"],
      id: docId,
      location: json['location'] ?? '',
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
      phone: json['phone'],
      workshopName: json['userName'],
      workshopId: json['workshopId'],
      bookedBy: json['bookedBy'] != null
          ? List<String>.from(json['bookedBy'])
          : [],
    );
  }



}