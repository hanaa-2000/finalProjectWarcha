class AppointmentModel {

  final String  address;
  final String latitude;
  final String longtude;
  final String clientName;
  final String carBrand;
  final String carModel;
  final String phone;
  final String problem;
  final String id;
  final String userId;
  final String workshopId;
  final String dateTime;
   final bool ?isBooked;
  AppointmentModel(this.isBooked, {required this.address,required this.latitude,required this.clientName,required this.longtude,required this.carBrand,required this.carModel,required this.phone,
    required this.problem,required this.id ,required this.userId,required this.dateTime,required this.workshopId});

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      json['isBooked'],
      address: json["address"],
      latitude: json['latitude'],
      longtude: json['longtude'],
      clientName: json['clientName'],
      carBrand: json["carBrand"],
      carModel: json["carModel"],
      phone: json["phone"],
      problem: json["problem"],
      id: json['id'],
      dateTime: json['dateTime'],
      userId: json["userId"],
      workshopId: json["workshopId"],

    );
  }

  Map<String, dynamic> toJson() {
    return {

      "isBooked":this.isBooked,
      "address": this.address,
      "latitude": this.latitude,
      "longtude": this.longtude,
      "clientName":this.clientName,
      "carBrand": this.carBrand,
      "carModel": this.carModel,
      "phone": this.phone,
      "problem": this.problem,
      "id": this.id,
      "userId": this.userId,
      "workshopId": this.workshopId,
      "dateTime": this.dateTime,
    };
  }

  AppointmentModel copyWith({
    bool? isBooked,
    String? clientName,
    String? address,
    String? latitude,
    String? longitude,
    String? carBrand,
    String? carModel,
    String? phone,
    String? problem,
    String? id,
    String? userId,
    String? dateTime,
    String? workshopId,
  }) {
    return AppointmentModel(
       isBooked ?? this.isBooked,
      clientName: clientName ?? this.clientName,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longtude: longitude ?? this.longtude,
      carBrand: carBrand ?? this.carBrand,
      carModel: carModel ?? this.carModel,
      phone: phone ?? this.phone,
      problem: problem ?? this.problem,
      id: id ?? this.id,
      userId: userId ?? this.userId,
      dateTime: dateTime?? this.dateTime ,
      workshopId: workshopId ?? this.workshopId,
    );
  }
}