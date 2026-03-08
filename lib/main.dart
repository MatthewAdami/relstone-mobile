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
import 'package:relstone_mobile/about_screen.dart';
import 'package:relstone_mobile/profile_screen.dart';
import 'package:relstone_mobile/checkout_screen.dart' as checkout;
import 'package:relstone_mobile/services/cart_service.dart' as cart;
import 'package:relstone_mobile/all_products_screen.dart';
import 'package:relstone_mobile/splash_screen.dart';
import 'package:relstone_mobile/insurance_ce_screen.dart';
import 'package:relstone_mobile/refund_policy_screen.dart';
import 'sales_license_screen.dart';
import 'real_estate_ce_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await cart.CartService.instance.ensureLoaded();
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
        '/about':           (context) => AboutScreen(),
        '/refund-policy':   (context) => const RefundPolicyScreen(),
        '/insurance-ce':    (context) => const InsuranceCEScreen(),
        '/insurance-state': (context) => const InsuranceCEScreen(),
        '/cart':            (context) => const CartPage(),
        // Placeholder routes for future   implementation
        '/sales':                (context) => const StatesScreen(),
        '/broker':               (context) => const StatesScreen(),
        '/dre-ce':               (context) => const StatesScreen(),
        '/exam-prep':            (context) => const StatesScreen(),
        '/insurance-states':     (context) => const InsuranceCEScreen(),
        '/insurance-courses':    (context) => const InsuranceCEScreen(),
        '/cfp-renewal':          (context) => const StatesScreen(),
        '/all-products': (context) => const AllProductsScreen(),
        '/':            (context) => const SplashScreen(), 
        '/sales-license': (context) => const SalesLicenseScreen(),
        '/real-estate-ce': (context) => const RealEstateCEScreen(),
      },

      // ── Dynamic routes  (arguments required) ───────────────────
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
              builder: (_) => checkout.CheckoutScreen(
                cartItems: _toCheckoutItems(args?['cartItems']),
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

List<checkout.CartItem> _toCheckoutItems(dynamic rawItems) {
  if (rawItems is! List) return const [];

  return rawItems.where((e) => e != null).map((e) {
    if (e is checkout.CartItem) {
      return e;
    }

    if (e is cart.CartItem) {
      return checkout.CartItem(
        id: e.id,
        name: e.name,
        type: e.type,
        price: e.price,
        creditHours: e.creditHours,
        withTextbook: e.withTextbook,
        textbookPrice: e.textbookPrice,
      );
    }

    if (e is Map) {
      final map = Map<String, dynamic>.from(e);
      return checkout.CartItem(
        id: (map['id'] ?? '').toString(),
        name: (map['name'] ?? '').toString(),
        type: (map['type'] ?? '').toString(),
        price: (map['price'] is num)
            ? (map['price'] as num).toDouble()
            : double.tryParse((map['price'] ?? '0').toString()) ?? 0,
        creditHours: (map['creditHours'] is num)
            ? (map['creditHours'] as num).toInt()
            : int.tryParse((map['creditHours'] ?? '0').toString()) ?? 0,
        withTextbook: map['withTextbook'] == true,
        textbookPrice: (map['textbookPrice'] is num)
            ? (map['textbookPrice'] as num).toDouble()
            : double.tryParse((map['textbookPrice'] ?? '0').toString()) ?? 0,
      );
    }

    return const checkout.CartItem(
      id: '',
      name: '',
      type: '',
      price: 0,
    );
  }).where((item) => item.id.isNotEmpty).toList();
}