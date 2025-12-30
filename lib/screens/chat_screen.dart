import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:global_chat/screens/native_code_screen.dart';
import 'package:global_chat/widgets/messages.dart';
import 'package:global_chat/widgets/send_message.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  void setUpFirebaseMessages() async {
    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();

    // final token = await fcm.getToken();
    // if (kDebugMode) print(token);

    /*
    here we want all users of this global chat to receive notification at once, so token is not required here:
    we will use topic method instead which only requires subscribing to a topic...
     */
    fcm.subscribeToTopic("global-chat");
  }

  @override
  void initState() {
    super.initState();
    setUpFirebaseMessages();
  }

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
                value: "native",
                child: PopupTile(text: "Native", icon: Icons.android),
              ),
              PopupMenuItem(
                value: "logout",
                child: PopupTile(text: "Logout", icon: Icons.logout),
              ),
            ],
            onSelected: (identifier) {
              if (identifier == "logout") logout();
              if (identifier == "native") {
                Navigator.of(context).pushNamed(NativeCodeScreen.routeName);
              }
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

class PopupTile extends StatelessWidget {
  final String text;
  final IconData icon;

  const PopupTile({required this.text, required this.icon, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(children: [Text(text), SizedBox(width: 12), Icon(icon)]);
  }
}
