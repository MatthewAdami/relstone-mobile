import 'package:flutter/material.dart';

import '../services/cart_service.dart';

class RelstoneHeader extends StatelessWidget implements PreferredSizeWidget {
  const RelstoneHeader({
    super.key,
    this.showCart = true,
    this.showCartBadge = false,
    this.titleWidget,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.iconTheme,
    this.titleSpacing = 16,
    this.backgroundColor = Colors.white,
    this.elevation = 0.5,
    this.trailingSpacing = 6,
  });

  final bool showCart;
  final bool showCartBadge;
  final Widget? titleWidget;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final IconThemeData? iconTheme;
  final double titleSpacing;
  final Color backgroundColor;
  final double elevation;
  final double trailingSpacing;

  static const Color primaryNavy = Color(0xFF1A3A5C);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: elevation,
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      iconTheme: iconTheme ?? const IconThemeData(color: primaryNavy),
      titleSpacing: titleSpacing,
      title: titleWidget ?? _buildLogoTitle(),
      actions: _buildActions(context),
    );
  }

  Widget _buildLogoTitle() {
    return Row(
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
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    if (!showCart) return const [];

    final iconButton = IconButton(
      tooltip: 'Cart',
      onPressed: () => Navigator.pushNamed(context, '/cart'),
      icon: const Icon(Icons.shopping_cart_outlined, color: primaryNavy),
    );

    final cartWidget = showCartBadge
        ? ListenableBuilder(
            listenable: CartService.instance,
            builder: (context, _) {
              final count = CartService.instance.cartCount;
              return Badge(
                label: Text('$count'),
                isLabelVisible: count > 0,
                child: iconButton,
              );
            },
          )
        : iconButton;

    return [
      cartWidget,
      SizedBox(width: trailingSpacing),
    ];
  }
}