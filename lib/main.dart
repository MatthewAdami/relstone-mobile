import 'package:flutter/material.dart';
import 'package:relstone_mobile/home__screen/home_screen.dart';
import 'package:relstone_mobile/login_screen/login_screen.dart';
import 'package:relstone_mobile/pages/cart_page.dart';
import 'package:relstone_mobile/pages/insurance_state_page.dart';
import 'package:relstone_mobile/sign_up_screen.dart';
import 'package:relstone_mobile/verify_email_screen.dart';
<<<<<<< HEAD
import 'package:relstone_mobile/forgot_password_screen.dart';
import 'package:relstone_mobile/states_screen.dart';
import 'package:relstone_mobile/contact_screen.dart';
import 'package:relstone_mobile/profile_screen.dart';
import 'package:relstone_mobile/checkout_screen.dart';
=======
>>>>>>> 8d920e3b1b9adeec7b96a156b594f71235330096

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    final name = settings.name ?? '';

    if (name.startsWith('/insurance-state/')) {
      final slug = name.substring('/insurance-state/'.length);
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => InsuranceStatePage(initialSlug: slug),
      );
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
<<<<<<< HEAD
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
=======
      initialRoute: '/login',          // 👈 starting screen
      onGenerateRoute: _onGenerateRoute,
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/homescreen': (context) => const HomeScreen(),  // 👈 using HomeScreen instead of SignUpScreen
        '/insurance-state': (context) => const InsuranceStatePage(),
        '/cart': (context) => const CartPage(),
        '/verify-email': (context) => const VerifyEmailScreen(),
>>>>>>> 8d920e3b1b9adeec7b96a156b594f71235330096
      },
    );
  }
}