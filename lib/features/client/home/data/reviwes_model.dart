import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String? id;
  final String ?userId;
  final String ?nameClient;
  final double rating;
  final String ?comment;
  final DateTime timestamp;

  ReviewModel({
    required this.id,
    required this.nameClient,
    required this.userId,
    required this.rating,
     this.comment,
    required this.timestamp,
  });

  factory ReviewModel.fromMap(Map<String, dynamic> map, String id) {
    return ReviewModel(
      id: id,
      nameClient: map['nameClient']??'',
      userId: map['userId'] ?? '',
      rating: map['rating'] ?? 0,
      comment: map['comment'] ?? '',
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'nameClient':nameClient,
      'rating': rating,
      'comment': comment,
      'timestamp': FieldValue.serverTimestamp(),
    };
  }
}
