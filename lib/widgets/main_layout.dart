import 'package:flutter/material.dart';

import '../services/cart_service.dart';

class MainLayout extends StatelessWidget {
  final Widget body;
  final Widget? drawer;
  final String? title;

  const MainLayout({
    super.key,
    required this.body,
    this.drawer,
    this.title,
  });

  static const Color primaryNavy = Color(0xFF1A3A5C);
  static const Color bg = Color(0xFFF4F6F9);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      drawer: drawer,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        titleSpacing: 16,
        title: Row(
          children: [
            Image.asset(
              'assets/relstone_logo.png',
              height: 28,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Text(
                'RELSTONE',
                style: TextStyle(
                  color: primaryNavy,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ],
        ),
        actions: [
          ListenableBuilder(
            listenable: CartService.instance,
            builder: (context, _) {
              final count = CartService.instance.cartCount;
              return Badge(
                label: Text('$count'),
                isLabelVisible: count > 0,
                child: IconButton(
                  tooltip: "Cart",
                  onPressed: () => Navigator.pushNamed(context, '/cart'),
                  icon: const Icon(Icons.shopping_cart_outlined, color: primaryNavy),
                ),
              );
            },
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: body,
    );
  }
}
