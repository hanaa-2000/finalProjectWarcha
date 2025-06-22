import 'dart:developer';

import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // التحقق مما إذا كانت خدمة الموقع مفعلة
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      log("خدمة الموقع غير مفعلة");
      return null;
    }

    // التحقق من أذونات الموقع
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        log("تم رفض إذن الموقع");
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      log("إذن الموقع مرفوض نهائيًا");
      return null;
    }

    // الحصول على الموقع الحالي
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
  }

  bool isEmployeeInAllowedArea(Position userPosition, double areaLat,
      double areaLng, double allowedRadiusByMeters) {
    double distance = Geolocator.distanceBetween(
      userPosition.latitude,
      userPosition.longitude,
      areaLat,
      areaLng,
    );
    bool isAllowedDistance = distance < allowedRadiusByMeters;
    return isAllowedDistance;
  }

  Future<bool> checkEmployeeLocation() async {
    Position? userPosition = await getCurrentLocation();
    if (userPosition == null) {
      log("لا يمكن تحديد موقعك. يرجى تفعيل GPS.");
      return false;
    }

// Blue Tech Location
    double workLat = 30.56055230059906;
    double workLng = 31.018305770515763;
    double allowedRadius = 100;
    bool isInside =
        isEmployeeInAllowedArea(userPosition, workLat, workLng, allowedRadius);

    if (isInside) {
      log("أنت داخل المنطقة المسموح بها، يمكنك متابعة تسجيل الحضور.");
      return true;
    } else {
      log("أنت خارج المنطقة المسموح بها، لا يمكن تسجيل الحضور حاليا.");
      return false;
    }
  }
}
