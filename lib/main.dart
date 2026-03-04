import 'package:flutter/material.dart';
import 'package:relstone_mobile/home__screen/home_screen.dart';
import 'package:relstone_mobile/login_screen/login_screen.dart';
import 'package:relstone_mobile/pages/cart_page.dart';
import 'package:relstone_mobile/pages/insurance_state_page.dart';
import 'package:relstone_mobile/sign_up_screen/sign_up_screen.dart';
import 'package:relstone_mobile/verify_email_screen/verify_email_screen.dart';

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
      initialRoute: '/login',          // 👈 starting screen
      onGenerateRoute: _onGenerateRoute,
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/homescreen': (context) => const HomeScreen(),  // 👈 using HomeScreen instead of SignUpScreen
        '/insurance-state': (context) => const InsuranceStatePage(),
        '/cart': (context) => const CartPage(),
        '/verify-email': (context) => const VerifyEmailScreen(),
      },
    );
  }
}