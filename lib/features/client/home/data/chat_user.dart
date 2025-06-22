class ChatUser {

  final String userName;
  final String id;

  ChatUser({required this.userName,required this.id});

  Map<String, dynamic> toJson() {
    return {"userName": this.userName, "id": this.id,};
  }

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(userName: json["userName"], id: json["id"],);
  }



}