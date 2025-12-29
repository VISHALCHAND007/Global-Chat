import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:global_chat/widgets/messages.dart';
import 'package:global_chat/widgets/send_message.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {

    void logout() async {
      final prefs = await SharedPreferences.getInstance();
      FirebaseAuth.instance.signOut();
      prefs.remove("username");
    }

    // void printUsername() async {
    //   final prefs = await SharedPreferences.getInstance();
    //   if (kDebugMode) print("username:: ${prefs.getString("username")}");
    // }
    //
    // printUsername();

    return Scaffold(
      appBar: AppBar(
        title: Text("Global chat 💬"),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (ctx) => [
              PopupMenuItem(
                value: "logout",
                child: Row(
                  children: [
                    Text("Logout"),
                    SizedBox(width: 12),
                    Icon(Icons.logout),
                  ],
                ),
              ),
            ],
            onSelected: (identifier) {
              if (identifier == "logout") logout();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: Messages()),
          SendMessage(),
        ],
      ),
    );
  }
}
