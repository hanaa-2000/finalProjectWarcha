import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:uuid/uuid.dart';

class ChatScreenWorkshop  extends StatefulWidget {
  const ChatScreenWorkshop({super.key, required this.otherUser,});
// final String id;
// final String userName;
  final types.User otherUser;
  @override
  State<ChatScreenWorkshop> createState() => _ChatScreenWorkshopState();
}

class _ChatScreenWorkshopState extends State<ChatScreenWorkshop> {
  late types.Room _room;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initRoom();
  }

  Future<void> _initRoom() async {
    final user = widget.otherUser;

    final existingRooms = await FirebaseChatCore.instance.rooms().first;

    types.Room? room;

    try {
      room = existingRooms.firstWhere(

            (room) =>
        room.type == types.RoomType.direct &&
            room.users.any((u) => u.id == user.id),
      );
    } catch (e) {
      room = null;
    }

    if (room == null) {
      _room = await FirebaseChatCore.instance.createRoom(user);
    } else {
      _room = room;
    }

    setState(() => _isLoading = false);
  }

  void _handleSendPressed(types.PartialText message) {
    if (message.text.trim().isNotEmpty) {
      FirebaseChatCore.instance.sendMessage(
        message,
        _room.id,

      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator(color: Colors.blue,backgroundColor: Colors.white,));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        centerTitle: true,
        title: Text(widget.otherUser.firstName ?? 'Chat'),
      ),
      body: StreamBuilder<types.Room>(
        stream: FirebaseChatCore.instance.room(_room.id,),
        builder: (context, roomSnapshot) {
          if (!roomSnapshot.hasData) return const SizedBox();

          return StreamBuilder<List<types.Message>>(
            stream: FirebaseChatCore.instance.messages(roomSnapshot.data!),
            builder: (context, messageSnapshot) {
              if (!messageSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator(color: Colors.blue,backgroundColor: Colors.white,));
              }

              return Chat(
                messages: messageSnapshot.data!,
                onSendPressed: _handleSendPressed,
                user: types.User(id: FirebaseChatCore.instance.firebaseUser!.uid),

                theme: DefaultChatTheme(
                  primaryColor: Colors.blue,

                ),
               );
            },
          );
        },
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_chat_ui/flutter_chat_ui.dart';
// import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
// import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
//
// class ChatScreen extends StatefulWidget {
//   const ChatScreen({super.key, required this.otherUser});
//
//   final types.User otherUser;
//
//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }
//
// class _ChatScreenState extends State<ChatScreen> {
//   late types.Room _room;
//   bool _isLoading = true;
//   final _chatController = ChatController();
//
//   @override
//   void initState() {
//     super.initState();
//     _initRoom();
//   }
//
//   Future<void> _initRoom() async {
//     final user = widget.otherUser;
//     final existingRooms = await FirebaseChatCore.instance.rooms().first;
//
//     types.Room? room;
//
//     try {
//       room = existingRooms.firstWhere(
//             (room) =>
//         room.type == types.RoomType.direct &&
//             room.users.any((u) => u.id == user.id),
//       );
//     } catch (e) {
//       room = null;
//     }
//
//     if (room == null) {
//       _room = await FirebaseChatCore.instance.createRoom(user);
//     } else {
//       _room = room;
//     }
//
//     FirebaseChatCore.instance.messages(_room).listen((messages) {
//       _chatController.loadMessages(messages);
//     });
//
//     setState(() => _isLoading = false);
//   }
//
//   void _handleSendPressed(types.PartialText message) {
//     FirebaseChatCore.instance.sendMessage(message, _room.id);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading) {
//       return const Scaffold(
//         body: Center(
//           child: CircularProgressIndicator(color: Colors.blue),
//         ),
//       );
//     }
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         surfaceTintColor: Colors.white,
//         centerTitle: true,
//         title: Text(widget.otherUser.firstName ?? 'Chat'),
//       ),
//       body: Chat(
//         chatController: _chatController,
//         // currentUser: types.User(id: FirebaseAuth.instance.currentUser!.uid),
//         // onSendPressed: _handleSendPressed,
//         resolveUser: (id) async {
//           try {
//             //return _room.users.firstWhere((u) => u.id == id);
//           } catch (e) {
//             return null;
//           }
//         },
//         theme: ChatTheme(
//
//           primaryColor: Colors.blue,
//         ), currentUserId:FirebaseAuth.instance.currentUser!.uid
//       ),
//     );
//   }
// }
