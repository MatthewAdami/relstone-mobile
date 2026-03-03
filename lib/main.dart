import 'package:flutter/material.dart';
import 'package:relstone_mobile/home__screen/home_screen.dart';
import 'package:relstone_mobile/login_screen/login_screen.dart';
import 'package:relstone_mobile/sign_up_screen/sign_up_screen.dart';
import 'package:relstone_mobile/verify_email_screen/verify_email_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',          // 👈 starting screen
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/homescreen': (context) => const HomeScreen(),  // 👈 using HomeScreen instead of SignUpScreen
        '/verify-email': (context) => const VerifyEmailScreen(),
      },
    );
  }
}