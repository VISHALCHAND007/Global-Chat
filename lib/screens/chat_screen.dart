import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Global chat 💬"),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.logout_outlined)),
        ],
      ),
      body: ListView.builder(
        itemCount: 48,
        itemBuilder: (ctx, ind) => Container(
          padding: const EdgeInsets.all(10),
          child: Text("This works..."),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FirebaseFirestore.instance.collection('chats/VqEdFwD8iabYMUDAlh6K/messages').snapshots().listen((snapshot) {
            snapshot.docs.forEach((item) {
              print("${item['text']}");
            });
          });
        },
        child: Icon(Icons.send),
      ),
    );
  }
}
