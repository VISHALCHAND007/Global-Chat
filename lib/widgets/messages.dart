import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'message_bubble.dart';

class Messages extends StatelessWidget {
  const Messages({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("chat")
            .orderBy("createdAt", descending: true)
            .snapshots(),
        builder: (ctx, chatSnapshot) {
          final documents = chatSnapshot.data?.docs;

          return documents == null || documents.isEmpty
              ? Column(
            mainAxisAlignment: .center,
            children: [
              Image.asset(
                "assets/images/convo.png",
                fit: BoxFit.cover,
                width: 150,
              ),
              Text(
                "This space is waiting for its first message 💬",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ],
          )
              : ListView.builder(
                  reverse: true,
                  itemCount: documents.length,
                  itemBuilder: (ctx, ind) => ChatBubble(
                    key: ValueKey(documents[ind].id),
                    message: documents[ind]["text"],
                    userId: documents[ind]["userId"],
                    username: documents[ind]["username"],
                    timestamp: documents[ind]["createdAt"],
                  ),
                );
        },
      ),
    );
  }
}
