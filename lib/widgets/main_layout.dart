import 'package:flutter/material.dart';

import 'relstone_header.dart';

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
      appBar: const RelstoneHeader(showCartBadge: true),
      body: body,
    );
  }
}
