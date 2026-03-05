import 'package:flutter/material.dart';
import 'package:relstone_mobile/home_screen.dart';
import 'package:relstone_mobile/login_screen.dart';
import 'package:relstone_mobile/pages/cart_page.dart';
import 'package:relstone_mobile/pages/insurance_state_page.dart';
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
      initialRoute: '/login',

      // ── Static routes ─────────────────────────────────────────
      routes: {
        '/login':           (context) => LoginScreen(),
        '/signup':          (context) => SignUpScreen(),
        '/homescreen':      (context) => const HomeScreen(),
        '/verify-email':    (context) => const VerifyEmailScreen(),
        '/forgot-password': (context) => ForgotPasswordScreen(),
        '/states':          (context) => const StatesScreen(),
        '/contact':         (context) => const ContactScreen(),
        '/insurance-state': (context) => const InsuranceStatePage(),
        '/cart':            (context) => const CartPage(),
      },

      // ── Dynamic routes (arguments required) ───────────────────
      onGenerateRoute: (settings) {
        final name = settings.name ?? '';

        // /insurance-state/california
        if (name.startsWith('/insurance-state/')) {
          final slug = name.substring('/insurance-state/'.length);
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => InsuranceStatePage(initialSlug: slug),
          );
        }

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