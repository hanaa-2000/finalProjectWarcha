import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http ;
import 'package:warcha_final_progect/core/theme/color_app.dart';

class ChatBotScreen extends StatefulWidget {
  @override
  _ChatBotScreenState createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _chatHistory = [];
  final String apiKey =
      "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";
  final String apiUrl = "https://openrouter.ai/api/v1/chat/completions";

  Future<void> sendMessage() async {
    String userMessage = _controller.text.trim();
    if (userMessage.isEmpty) return;

    setState(() {
      _chatHistory.add({"role": "user", "content": userMessage});
      _controller.clear();
    });

    final headers = {
      "Authorization": "Bearer $apiKey",
      "Content-Type": "application/json",
    };
    final data = {"model": "deepseek/deepseek-chat", "messages": _chatHistory};

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(data),
      );

      final responseBody = utf8.decode(response.bodyBytes); // ✅ decode UTF-8
      final responseData = jsonDecode(responseBody);

      if (responseData["choices"] != null &&
          responseData["choices"].isNotEmpty) {
        setState(() {
          _chatHistory.add({
            "role": "assistant",
            "content": responseData["choices"][0]["message"]["content"],
          });
        });
      } else {
        setState(() {
          _chatHistory.add({
            "role": "assistant",
            "content": "⚠️ استجابة غير متوقعة من الخادم.",
          });
        });
      }
    } catch (e) {
      setState(() {
        _chatHistory.add({
          "role": "assistant",
          "content": "❌ خطأ في الاتصال بالخادم: $e",
        });
      });
    }
  }

  void clearChat() {
    setState(() {
      _chatHistory.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          title: Text("🤖 Mechanic chat")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _chatHistory.length,
              itemBuilder: (context, index) {
                final message = _chatHistory[index];
                final isUser = message["role"] == "user";
                return ListTile(
                  title: Align(
                    alignment:
                        isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.blue[100] : Colors.green[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(message["content"] ?? ""),
                    ),
                  ),
                );
              },
            ),
          ),
          Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onSubmitted: (_) => sendMessage(),
                    decoration: InputDecoration(hintText: 'message send...',
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(color: ColorApp.greyLight,width: 2),

                    ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: ColorApp.greyLight,width: 2),

                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: ColorApp.greyLight,width: 2),

                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: ColorApp.greyLight,width: 2),

                      ),
                    ),
                  ),
                ),
                IconButton(icon: Icon(Icons.send,color: Colors.blue,), onPressed: sendMessage),
                IconButton(icon: Icon(Icons.delete ,color: Colors.red,), onPressed: clearChat),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
