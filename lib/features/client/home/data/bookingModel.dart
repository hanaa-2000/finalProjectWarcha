// lib/features/booking/models/booking_state.dart
class BookingState {
  final String workshopId;
  final bool isBooked;

  BookingState({required this.workshopId, required this.isBooked});

  // تحويل البيانات إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'workshopId': workshopId,
      'isBooked': isBooked,
    };
  }

  // إنشاء الكائن من JSON
  factory BookingState.fromJson(Map<String, dynamic> json) {
    return BookingState(
      workshopId: json['workshopId'],
      isBooked: json['isBooked'],
    );
  }
}
