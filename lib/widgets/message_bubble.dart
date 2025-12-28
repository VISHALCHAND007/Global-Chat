import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatBubble extends StatelessWidget {
  ChatBubble({
    required this.message,
    required this.userId,
    required this.username,
    required this.timestamp,
    super.key,
  });

  final String message;
  final String userId;
  final _auth = FirebaseAuth.instance;
  final String username;
  final Timestamp timestamp;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);
    final isMe = _auth.currentUser?.uid == userId;

    return Row(
      mainAxisAlignment: isMe ? .end : .start,
      children: [
        Container(
          width: width * .45,
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
              bottomLeft: isMe ? Radius.circular(12) : Radius.circular(0),
              bottomRight: !isMe ? Radius.circular(12) : Radius.circular(0),
            ),
            color: isMe
                ? theme.colorScheme.primaryContainer
                : theme.colorScheme.secondaryContainer,
          ),
          child: Column(
            crossAxisAlignment: isMe ? .end : .start,
            children: [
              Text(
                "~ $username",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                  fontSize: 11,
                ),
              ),
              Text(message, style: TextStyle(fontSize: 16)),
              SizedBox(height: 5,),
              Align(
                alignment: isMe ? Alignment.centerLeft : Alignment.centerRight,
                child: Text(
                  DateFormat("MMM dd, yyy hh:mm a").format(timestamp.toDate()),
                  style: TextStyle(
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
