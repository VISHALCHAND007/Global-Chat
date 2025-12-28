import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SendMessage extends StatefulWidget {
  const SendMessage({super.key});

  @override
  State<SendMessage> createState() => _SendMessageState();
}

class _SendMessageState extends State<SendMessage> {
  var _typedMessage = "";
  final _messageController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  late final focusScope = FocusScope.of(context);

  void _sendMessage() async {
    final prefs = await SharedPreferences.getInstance();
    focusScope.unfocus();
    FirebaseFirestore.instance.collection("chat").add({
      "text": _typedMessage,
      "userId": _auth.currentUser?.uid,
      "createdAt": Timestamp.now(),
      "username": prefs.getString("username"),
    });
    _messageController.clear();
    _typedMessage = "";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(label: Text("Send a message...")),
              controller: _messageController,
              onChanged: (value) {
                setState(() {
                  _typedMessage = value;
                });
              },
            ),
          ),
          IconButton(
            onPressed: _typedMessage.isEmpty ? null : _sendMessage,
            icon: Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
