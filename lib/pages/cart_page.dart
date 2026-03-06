import 'package:flutter/material.dart';

import '../services/cart_service.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartService _cart = CartService.instance;

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

  @override
  Widget build(BuildContext context) {
    final items = _cart.items;

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart (${_cart.cartCount})'),
        actions: [
          if (items.isNotEmpty)
            TextButton(
              onPressed: () => _cart.clearCart(),
              child: const Text('Clear', style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
      body: !_cart.loaded
          ? const Center(child: CircularProgressIndicator())
          : items.isEmpty
              ? const Center(child: Text('Your cart is empty.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: items.length + 1,
                  itemBuilder: (context, index) {
                    if (index == items.length) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Total Credit Hours: ${_cart.totalCreditHours}'),
                              const SizedBox(height: 6),
                              Text(
                                'Total: \$${_money(_cart.cartTotal)}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    final item = items[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text('${item.stateName} • ${item.type}'),
                            const SizedBox(height: 4),
                            Text('Quantity: ${item.quantity}'),
                            const SizedBox(height: 4),
                            Text('Credit Hours: ${item.creditHours}'),
                            const SizedBox(height: 4),
                            Text(
                              'Price: \$${_money((item.price + (item.withTextbook ? item.textbookPrice : 0)) * item.quantity)}',
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton.icon(
                                  onPressed: () => _cart.removeFromCart(item.id),
                                  icon: const Icon(Icons.delete_outline),
                                  label: const Text('Remove'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
