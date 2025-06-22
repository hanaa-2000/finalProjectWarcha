import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {

  final String image;
  final String companyName;
  final String specifications;
  final String countryManufacture;
  final String yearManufacture;
  final String price;
  final String id;
  final List<BookingModel> ?bookingModel;

  ProductModel(

      {this.bookingModel,
    required this.image,required this.companyName,required this.specifications,
    required this.countryManufacture,required this.yearManufacture,required this.price,required this.id
});
  factory ProductModel.fromDocument(DocumentSnapshot json) {
    return ProductModel(
      image: json["image"]as String,
      companyName: json["companyName"] as String,
      specifications: json["specifications"],
      countryManufacture: json["countryManufacture"],
      yearManufacture: json["yearManufacture"],
      price:json["price"],
      id: json.id);
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
      "bookedBy":bookingModel,
    };
  }


}

class BookingModel {
  final String customerId;
  final String clientName;
  final String clientPhone;

  BookingModel({
    required this.customerId,
    required this.clientName,
    required this.clientPhone,
  });
}
