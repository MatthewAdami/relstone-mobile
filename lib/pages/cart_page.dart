import 'package:flutter/material.dart';

import '../services/cart_service.dart';
import '../widgets/relstone_header.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartService _cart = CartService.instance;

  static const Color _bg = Color(0xFFF4F6F9);
  static const Color _navy = Color(0xFF1A3A5C);
  static const Color _muted = Color(0xFF6B7E92);

  @override
  void initState() {
    super.initState();
    _cart.addListener(_onCartChanged);
    _cart.ensureLoaded();
  }

  @override
  void dispose() {
    _cart.removeListener(_onCartChanged);
    super.dispose();
  }

  void _onCartChanged() {
    if (!mounted) return;
    setState(() {});
  }

  String _money(double value) => value.toStringAsFixed(2);

  Future<void> _setQuantity(CartItem item, int quantity) async {
    final next = quantity.clamp(1, 99);
    await _cart.addToCart(item.copyWith(quantity: next));
  }

  Future<void> _toggleTextbook(CartItem item) async {
    await _cart.toggleTextbook(item.id);
  }

  void _goToCheckout() {
    Navigator.pushNamed(
      context,
      '/checkout',
      arguments: {
        'cartItems': _cart.items,
        'cartTotal': _cart.cartTotal,
        'totalCreditHours': _cart.totalCreditHours,
        'clearCart': () => _cart.clearCart(),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = _cart.items;

    return Scaffold(
      backgroundColor: _bg,
      appBar: RelstoneHeader(
        showCart: false,
        titleWidget: Text(
          'My Cart (${_cart.cartCount})',
          style: const TextStyle(
            color: _navy,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: !_cart.loaded
          ? const Center(child: CircularProgressIndicator())
          : items.isEmpty
              ? _buildEmptyState()
              : SafeArea(
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final item = items[index];
                            final unit = item.price + (item.withTextbook ? item.textbookPrice : 0);
                            final total = unit * item.quantity;

                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x14000000),
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    style: const TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF1F2937),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${item.stateName} • ${item.type.toUpperCase()}',
                                    style: const TextStyle(
                                      color: _muted,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF1F5F9),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          '${item.creditHours} Credit Hours',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: _navy,
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                        visualDensity: VisualDensity.compact,
                                        onPressed: item.quantity > 1
                                            ? () => _setQuantity(item, item.quantity - 1)
                                            : null,
                                        icon: const Icon(Icons.remove_circle_outline),
                                      ),
                                      Text(
                                        '${item.quantity}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      IconButton(
                                        visualDensity: VisualDensity.compact,
                                        onPressed: item.quantity < 99
                                            ? () => _setQuantity(item, item.quantity + 1)
                                            : null,
                                        icon: const Icon(Icons.add_circle_outline),
                                      ),
                                    ],
                                  ),
                                  if (item.textbookPrice > 0) ...[
                                    const SizedBox(height: 6),
                                    CheckboxListTile(
                                      contentPadding: EdgeInsets.zero,
                                      controlAffinity: ListTileControlAffinity.leading,
                                      value: item.withTextbook,
                                      onChanged: (_) => _toggleTextbook(item),
                                      title: Text(
                                        'Add Printed Textbook (+\$${_money(item.textbookPrice)})',
                                        style: const TextStyle(fontSize: 13.5),
                                      ),
                                    ),
                                  ],
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Text(
                                        '\$${_money(total)}',
                                        style: const TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.w800,
                                          color: Color(0xFF111827),
                                        ),
                                      ),
                                      const Spacer(),
                                      TextButton.icon(
                                        onPressed: () => _cart.removeFromCart(item.id),
                                        icon: const Icon(Icons.delete_outline),
                                        label: const Text('Remove'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      _buildSummary(),
                    ],
                  ),
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.shopping_cart_outlined, size: 56, color: _muted),
            const SizedBox(height: 10),
            const Text(
              'Your cart is empty',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: _navy,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Add courses or packages to continue to checkout.',
              textAlign: TextAlign.center,
              style: TextStyle(color: _muted),
            ),
            const SizedBox(height: 14),
            FilledButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/insurance-ce'),
              icon: const Icon(Icons.explore_outlined),
              label: const Text('Browse Courses'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary() {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                'Total Credit Hours',
                style: TextStyle(color: _muted),
              ),
              const Spacer(),
              Text(
                '${_cart.totalCreditHours}',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: _navy,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Text(
                'Order Total',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Text(
                '\$${_money(_cart.cartTotal)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: _navy,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _goToCheckout,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: _navy,
              ),
              child: const Text(
                'Proceed to Checkout',
                style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          TextButton(
            onPressed: () => _cart.clearCart(),
            child: const Text('Clear cart'),
          ),
        ],
      ),
    );
  }
}
