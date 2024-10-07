import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:user_auth_try7/intro_page.dart';
import 'package:user_auth_try7/login.dart';
import 'package:user_auth_try7/menu.dart'; // Import MenuPage

class AuthGate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()), // Loading indicator
          );
        }

        if (snapshot.hasData) {
          // User is logged in, navigate to OptionsPage
          return const IntroPage();
        } else {
          // User is not logged in, navigate to LoginPage
          return const LoginPage();
        }
      },
    );
  }
}
