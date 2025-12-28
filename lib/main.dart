import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:global_chat/screens/auth_screen.dart';
import 'package:global_chat/screens/chat_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Global Chat',
      theme: ThemeData(
        colorScheme: .fromSeed(
          seedColor: Colors.deepPurpleAccent,
          error: Color(0xEFDF4330),
          secondaryContainer: Color(0xFF90CB82),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.blueGrey,
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, authSnapshot) {
          return Container(
            color: Theme.of(context).colorScheme.primaryFixedDim,
            child: SafeArea(
              child: authSnapshot.hasData ? ChatScreen() : AuthScreen(),
            ),
          );
        },
      ),
    );
  }
}
