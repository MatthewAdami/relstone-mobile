import 'package:flutter/material.dart';

class SalesLicenseScreen extends StatefulWidget {
  const SalesLicenseScreen({super.key});

  @override
  State<SalesLicenseScreen> createState() => _SalesLicenseScreenState();
}

class _SalesLicenseScreenState extends State<SalesLicenseScreen> {
  // ── Brand colors (same as HomeScreen) ────────────────────
  static const Color primaryNavy = Color(0xFF1A3A5C);
  static const Color accentBlue  = Color(0xFF2E7EBE);
  static const Color textDark    = Color(0xFF1C2B3A);
  static const Color textMuted   = Color(0xFF6B7E92);
  static const Color bg          = Color(0xFFF4F6F9);
  static const Color green       = Color(0xFF22C55E);

  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Sales License', 'Broker License', 'CA Insurance CE', 'CA Real Estate CE'];

  // ── Hardcoded products ────────────────────────────────────
  final List<Map<String, dynamic>> _products = [
    {
      'category': 'Sales License',
      'type': 'Package',
      'title': 'Sales Course Package',
      'description': '360-hour California real estate package. Includes 8 courses: California Real Estate Principles, California Real Estate Practice, California Real Estate Business...',
      'price': 0.0,
      'fromPrice': true,
    },
    {
      'category': 'Broker License',
      'type': 'Course',
      'title': 'California Real Estate Principles',
      'description': 'DRE-approved 45-hour course. 18 chapters covering Property ownership, estates, transfer of title, encumbrances, contracts, agency, financing, appraisal, fair housing, escrow,...',
      'price': 98.0,
      'fromPrice': false,
    },
    {
      'category': 'Sales License',
      'type': 'Course',
      'title': 'California Real Estate Practice',
      'description': 'DRE-approved 45-hour course covering listing agreements, buyer representation, advertising, escrow and closing procedures, and more.',
      'price': 98.0,
      'fromPrice': false,
    },
    {
      'category': 'Sales License',
      'type': 'Course',
      'title': 'California Real Estate Finance',
      'description': 'DRE-approved 45-hour course. Topics include mortgage types, loan qualification, interest rates, government programs, investment analysis, and more.',
      'price': 98.0,
      'fromPrice': false,
    },
    {
      'category': 'Broker License',
      'type': 'Package',
      'title': 'Broker License Package',
      'description': 'Complete 8-course broker license package. Covers all DRE requirements for obtaining your California Broker license including advanced real estate topics.',
      'price': 349.0,
      'fromPrice': false,
    },
    {
      'category': 'CA Real Estate CE',
      'type': 'Package',
      'title': '45-Hour CE Renewal Package',
      'description': 'Complete 45-hour continuing education package for DRE license renewal. Includes Ethics, Agency, Trust Funds, Fair Housing, and elective courses.',
      'price': 49.0,
      'fromPrice': false,
    },
    {
      'category': 'CA Insurance CE',
      'type': 'Course',
      'title': 'CA Insurance Ethics',
      'description': '4-hour California Insurance Ethics course. Covers ethical conduct, consumer protection, and professional responsibility for insurance licensees.',
      'price': 24.0,
      'fromPrice': false,
    },
    {
      'category': 'CA Insurance CE',
      'type': 'Course',
      'title': 'CA Life & Health Insurance CE',
      'description': '20-hour continuing education for California Life & Health insurance license renewal. Covers policy types, regulations, and client needs analysis.',
      'price': 39.0,
      'fromPrice': false,
    },
  ];

  List<Map<String, dynamic>> get _filtered {
    if (_selectedCategory == 'All') return _products;
    return _products.where((p) => p['category'] == _selectedCategory).toList();
  }

  // ── Category counts ───────────────────────────────────────
  int _countFor(String cat) {
    if (cat == 'All') return _products.length;
    return _products.where((p) => p['category'] == cat).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: primaryNavy, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: const Text(
          'Sales License',
          style: TextStyle(
            color: primaryNavy,
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Cart',
            onPressed: () => Navigator.pushNamed(context, '/cart'),
            icon: const Icon(Icons.shopping_cart_outlined, color: primaryNavy),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // ── Hero Banner ───────────────────────────────────
          Container(
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: primaryNavy,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: primaryNavy.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Avatar ──
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: const Color(0xFF7C3AED),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text(
                          'SL',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Sales License Pre-Licensing',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '135-hour package: Real Estate Principles, Practice & Finance. DRE-approved for salesperson license.',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.75),
                              fontSize: 12.5,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    // ── Course count badge ──
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF7C3AED),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        '12 Courses',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                const Divider(color: Colors.white12, height: 1),
                const SizedBox(height: 14),

                // ── Category filter chips ──
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _categories.skip(1).map((cat) {
                      final isActive = _selectedCategory == cat;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedCategory = cat),
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            color: isActive
                                ? Colors.white
                                : Colors.white.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isActive
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                cat,
                                style: TextStyle(
                                  color: isActive ? primaryNavy : Colors.white,
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: isActive
                                      ? primaryNavy.withOpacity(0.12)
                                      : Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '${_countFor(cat)}',
                                  style: TextStyle(
                                    color: isActive ? primaryNavy : Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // ── Results count ─────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Row(
              children: [
                Text(
                  '${_filtered.length} ${_filtered.length == 1 ? 'product' : 'products'}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: textMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (_selectedCategory != 'All') ...[
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: () => setState(() => _selectedCategory = 'All'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: accentBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _selectedCategory,
                            style: const TextStyle(
                              fontSize: 11,
                              color: accentBlue,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.close_rounded, size: 12, color: accentBlue),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // ── Product Grid ──────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final cols = constraints.maxWidth >= 600 ? 2 : 1;
                if (cols == 1) {
                  return Column(
                    children: _filtered
                        .map((p) => Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: _ProductCard(product: p),
                            ))
                        .toList(),
                  );
                }
                // 2-column grid for tablets
                final rows = <Widget>[];
                for (int i = 0; i < _filtered.length; i += 2) {
                  rows.add(
                    Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _ProductCard(product: _filtered[i])),
                          const SizedBox(width: 14),
                          if (i + 1 < _filtered.length)
                            Expanded(child: _ProductCard(product: _filtered[i + 1]))
                          else
                            const Expanded(child: SizedBox()),
                        ],
                      ),
                    ),
                  );
                }
                return Column(children: rows);
              },
            ),
          ),
        ],
      ),
    );
  }
}

/* ─── PRODUCT CARD ─────────────────────────────────────────────────── */
class _ProductCard extends StatefulWidget {
  final Map<String, dynamic> product;
  const _ProductCard({required this.product});

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> {
  bool _inCart = false;

  static const Color primaryNavy = Color(0xFF1A3A5C);
  static const Color accentBlue  = Color(0xFF2E7EBE);
  static const Color textMuted   = Color(0xFF6B7E92);
  static const Color green       = Color(0xFF22C55E);

  String get _category => widget.product['category'] as String;
  String get _type     => widget.product['type'] as String;
  String get _title    => widget.product['title'] as String;
  String get _desc     => widget.product['description'] as String;
  double get _price    => widget.product['price'] as double;
  bool get _fromPrice  => widget.product['fromPrice'] as bool;

  String get _priceLabel {
    if (_fromPrice) return 'From: \$${_price.toStringAsFixed(0)}';
    return '\$${_price.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: green.withOpacity(0.3), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: primaryNavy.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Category badge ──
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: green.withOpacity(0.12),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: green.withOpacity(0.4)),
              ),
              child: Text(
                _category.toUpperCase(),
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                  color: green.withOpacity(0.85),
                  letterSpacing: 0.8,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ── Inner title card ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F9FC),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _category.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 10,
                      color: textMuted,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: primaryNavy,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ── Description ──
            Text(
              _desc,
              style: const TextStyle(
                fontSize: 12.5,
                color: textMuted,
                height: 1.45,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 14),

            // ── Price ──
            Text(
              _priceLabel,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: _fromPrice && _price == 0 ? green : green,
              ),
            ),

            const SizedBox(height: 14),

            // ── Add to Cart button ──
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => setState(() => _inCart = !_inCart),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _inCart ? green : primaryNavy,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  _inCart ? '✓ Added to Cart' : 'ADD TO CART',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}