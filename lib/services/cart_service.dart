import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartItem {
  final String id;
  final String type;
  final String name;
  final String stateSlug;
  final String stateName;
  final double price;
  final int creditHours;
  final bool withTextbook;
  final double textbookPrice;
  final int quantity;

  const CartItem({
    required this.id,
    required this.type,
    required this.name,
    required this.stateSlug,
    required this.stateName,
    required this.price,
    required this.creditHours,
    required this.withTextbook,
    required this.textbookPrice,
    this.quantity = 1,
  });

  CartItem copyWith({
    bool? withTextbook,
    double? textbookPrice,
    int? quantity,
  }) {
    return CartItem(
      id: id,
      type: type,
      name: name,
      stateSlug: stateSlug,
      stateName: stateName,
      price: price,
      creditHours: creditHours,
      withTextbook: withTextbook ?? this.withTextbook,
      textbookPrice: textbookPrice ?? this.textbookPrice,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'name': name,
        'stateSlug': stateSlug,
        'stateName': stateName,
        'price': price,
        'creditHours': creditHours,
        'withTextbook': withTextbook,
        'textbookPrice': textbookPrice,
        'quantity': quantity,
      };

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: (json['id'] ?? '').toString(),
      type: (json['type'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      stateSlug: (json['stateSlug'] ?? '').toString(),
      stateName: (json['stateName'] ?? '').toString(),
      price: (json['price'] is num)
          ? (json['price'] as num).toDouble()
          : double.tryParse((json['price'] ?? '0').toString()) ?? 0,
      creditHours: (json['creditHours'] is num)
          ? (json['creditHours'] as num).toInt()
          : int.tryParse((json['creditHours'] ?? '0').toString()) ?? 0,
      withTextbook: json['withTextbook'] == true,
      textbookPrice: (json['textbookPrice'] is num)
          ? (json['textbookPrice'] as num).toDouble()
          : double.tryParse((json['textbookPrice'] ?? '0').toString()) ?? 0,
      quantity: (json['quantity'] is num)
          ? (json['quantity'] as num).toInt().clamp(1, 999)
          : (int.tryParse((json['quantity'] ?? '1').toString()) ?? 1).clamp(1, 999),
    );
  }
}

class CartService extends ChangeNotifier {
  CartService._();
  static final CartService instance = CartService._();

  static const String _storageKey = 'relstone_cart';

  final List<CartItem> _items = [];
  bool _loaded = false;

  List<CartItem> get items => List.unmodifiable(_items);
  bool get loaded => _loaded;

  int get cartCount => _items.fold(0, (sum, item) => sum + item.quantity);
  double get cartTotal => _items.fold(
        0,
        (sum, item) =>
            sum + ((item.price + (item.withTextbook ? item.textbookPrice : 0)) * item.quantity),
      );
  int get totalCreditHours =>
      _items.fold(0, (sum, item) => sum + (item.creditHours * item.quantity));

  bool isInCart(String id) => _items.any((item) => item.id == id);

  Future<void> ensureLoaded() async {
    if (_loaded) return;
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);

    if (raw != null && raw.isNotEmpty) {
      try {
        final list = jsonDecode(raw);
        if (list is List) {
          _items
            ..clear()
            ..addAll(
              list
                  .whereType<Map>()
                  .map((e) => CartItem.fromJson(Map<String, dynamic>.from(e))),
            );
        }
      } catch (_) {
        await prefs.remove(_storageKey);
      }
    }

    _loaded = true;
    notifyListeners();
  }

  Future<void> addToCart(CartItem item) async {
    await ensureLoaded();
    final index = _items.indexWhere((e) => e.id == item.id);
    if (index >= 0) {
      _items[index] = item;
    } else {
      _items.add(item);
    }
    await _persist();
  }

  Future<void> removeFromCart(String id) async {
    await ensureLoaded();
    _items.removeWhere((e) => e.id == id);
    await _persist();
  }

  Future<void> toggleTextbook(String id) async {
    await ensureLoaded();
    final index = _items.indexWhere((e) => e.id == id);
    if (index < 0) return;
    final current = _items[index];
    _items[index] = current.copyWith(withTextbook: !current.withTextbook);
    await _persist();
  }

  Future<void> clearCart() async {
    await ensureLoaded();
    _items.clear();
    await _persist();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _storageKey,
      jsonEncode(_items.map((e) => e.toJson()).toList()),
    );
    notifyListeners();
  }
}
