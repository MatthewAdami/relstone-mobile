import 'package:flutter/material.dart';
import 'package:relstone_mobile/home_screen.dart';
import 'package:relstone_mobile/login_screen.dart';
import 'package:relstone_mobile/sign_up_screen.dart';
import 'package:relstone_mobile/verify_email_screen.dart';
import 'package:relstone_mobile/forgot_password_screen.dart';
import 'package:relstone_mobile/states_screen.dart';
import 'package:relstone_mobile/contact_screen.dart';
import 'package:relstone_mobile/profile_screen.dart';
import 'package:relstone_mobile/checkout_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/checkout', // ✅ Change this to test different screens (e.g., '/login', '/signup', '/homescreen', etc.)

      // ── Static routes (no arguments needed) ──────────────────
      routes: {
        '/login':           (context) => LoginScreen(),
        '/signup':          (context) => SignUpScreen(),
        '/homescreen':      (context) => const HomeScreen(),
        '/verify-email':    (context) => const VerifyEmailScreen(),
        '/forgot-password': (context) => ForgotPasswordScreen(),
        '/states':          (context) => const StatesScreen(),
        '/contact':         (context) => const ContactScreen(),
        // ❌ DO NOT put /checkout or /profile here
      },

      // ── Dynamic routes (arguments required) ──────────────────
      onGenerateRoute: (settings) {
        switch (settings.name) {

          case '/profile': {
            final args = settings.arguments as Map<String, dynamic>?;
            return MaterialPageRoute(
              builder: (_) => ProfileScreen(
                studentId: args?['studentId'] ?? '',
                token:     args?['token']     ?? '',
                user:      args?['user'],
              ),
            );
          }

          case '/checkout': {
            final args = settings.arguments as Map<String, dynamic>?;
            return MaterialPageRoute(
              builder: (_) => CheckoutScreen(
                cartItems:        (args?['cartItems']        as List<CartItem>?) ?? [],
                cartTotal:        (args?['cartTotal']        as double?)         ?? 0.0,
                totalCreditHours: (args?['totalCreditHours'] as int?)            ?? 0,
                clearCart:        (args?['clearCart']        as VoidCallback?)   ?? () {},
              ),
            );
          }

          default:
            return MaterialPageRoute(builder: (_) => LoginScreen());
        }
      },
    );
  }
}