import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:global_chat/widgets/auth/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  late final scaffoldMessenger = ScaffoldMessenger.of(context);
  late final theme = Theme.of(context);
  var _isLoading = false;

  void _onFormSubmit({
    required String email,
    required String password,
    String? username,
    required bool isLogin,
    required BuildContext ctx,
  }) async {
    UserCredential credential;
    final prefs = await SharedPreferences.getInstance();
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        credential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        //fetching and saving username
        final userData = await _firestore
            .collection("users")
            .doc(credential.user?.uid)
            .get();
        await prefs.setString("username", userData.data()?["username"]);
      } else {
        credential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        prefs.setString("username", username!);
        await _firestore.collection("users").doc(credential.user?.uid).set({
          'email': email,
          'username': username,
          // 'photo': ''
        });
      }
      setState(() {
        _isLoading = false;
      });
    } on FirebaseAuthException catch (error) {
      setState(() {
        _isLoading = false;
      });
      var message = "An error occurred, please check your credentials.";
      if (error.message != null) message = error.message!;

      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(message),
          showCloseIcon: true,
          backgroundColor: theme.colorScheme.error,
        ),
      );
    } catch (error) {
      if (kDebugMode) {
        print("error:: $error");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(onSubmit: _onFormSubmit, isLoading: _isLoading),
    );
  }
}
