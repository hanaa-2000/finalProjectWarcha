class MessageModel {
  String? id;
  String text;
  String senderId;
  String senderName; // اسم المرسل
  DateTime timestamp;

  MessageModel({
    this.id,
    required this.text,
    required this.senderId,
    required this.senderName,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'senderId': senderId,
      'senderName': senderName, // إضافة اسم المرسل
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json["id"],
      text: json["text"],
      senderId: json["senderId"],
      senderName: json['senderName'],
      timestamp: DateTime.parse(json["timestamp"]),);
  }




}