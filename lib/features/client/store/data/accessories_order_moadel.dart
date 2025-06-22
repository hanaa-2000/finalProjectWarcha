class AccessoriesOrderModel {
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
  final String ? paymentType;

  AccessoriesOrderModel({required this.image,required this.companyName,required this.specifications,
    required this.countryManufacture,required this.yearManufacture,required this.price,required this.id,
    required  this.workshopName,required this.workshopId,required this.location,required this.phone,
  this.latitude, this.longitude ,this.paymentType});

  factory AccessoriesOrderModel.fromJson(Map<String, dynamic> json) {
    return AccessoriesOrderModel(image: json["image"],
      companyName: json["companyName"],
      specifications: json["specifications"],
      countryManufacture: json["countryManufacture"],
      yearManufacture: json["yearManufacture"],
      price: json["price"],
      id: json["id"],
      workshopName: json["workshopName"],
      workshopId: json["workshopId"],
      location: json["location"],
      phone: json["phone"],
      latitude: json["latitude"],
      longitude: json["longitude"],);
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
      "workshopName": this.workshopName,
      "workshopId": this.workshopId,
      "location": this.location,
      "phone": this.phone,
      "latitude": this.latitude,
      "longitude": this.longitude,
    };
  }


}