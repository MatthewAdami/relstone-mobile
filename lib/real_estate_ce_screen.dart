import 'package:flutter/material.dart';
import 'package:relstone_mobile/widgets/relstone_header.dart';

class RealEstateCEScreen extends StatefulWidget {
  const RealEstateCEScreen({super.key});

  @override
  State<RealEstateCEScreen> createState() => _RealEstateCEScreenState();
}

class _RealEstateCEScreenState extends State<RealEstateCEScreen> {
  // ── Brand colors ──────────────────────────────────────────
  static const Color primaryNavy = Color(0xFF1A3A5C);
  static const Color accentBlue  = Color(0xFF2E7EBE);
  static const Color textMuted   = Color(0xFF6B7E92);
  static const Color bg          = Color(0xFFF4F6F9);
  static const Color green       = Color(0xFF22C55E);
  static const Color amber       = Color(0xFFF5B301);

  String _selectedCategory = 'All';
  final List<String> _categories = [
    'All',
    'Broker License',
    'CA Insurance CE',
    'Sales License',
  ];

  // ── Hardcoded products ────────────────────────────────────
  final List<Map<String, dynamic>> _products = [
    {
      'category': 'CA Real Estate CE',
      'badge': 'CE RENEWAL',
      'title': 'California License Renewal – Business Opportunities',
      'description': 'DRE-approved continuing education for California real estate license renewal. Online, self-paced.',
      'price': 98.0,
      'rating': 5.0,
    },
    {
      'category': 'CA Real Estate CE',
      'badge': 'CE RENEWAL',
      'title': 'Renew California License – (Mortgage Lending)',
      'description': 'DRE-approved General-hour continuing education for California real estate license renewal. Online, self-paced.',
      'price': 98.0,
      'rating': 3.0,
    },
    {
      'category': 'CA Real Estate CE',
      'badge': 'CE RENEWAL',
      'title': '45-Hour CE Renewal Package',
      'description': 'Complete 45-hour DRE-approved continuing education package. Includes Ethics, Agency, Trust Funds, Fair Housing, and Risk Management.',
      'price': 49.0,
      'rating': 4.5,
    },
    {
      'category': 'CA Real Estate CE',
      'badge': 'CE RENEWAL',
      'title': 'Ethics in Real Estate',
      'description': 'DRE-approved 3-hour Ethics course required for all California real estate license renewals. Covers ethical conduct and professional responsibility.',
      'price': 18.0,
      'rating': 4.0,
    },
    {
      'category': 'Broker License',
      'badge': 'BROKER',
      'title': 'Advanced Real Estate Finance',
      'description': 'DRE-approved elective course for Broker license. Covers mortgage markets, investment analysis, and advanced financing structures.',
      'price': 98.0,
      'rating': 4.0,
    },
    {
      'category': 'Broker License',
      'badge': 'BROKER',
      'title': 'Real Estate Property Management',
      'description': 'DRE-approved course covering landlord-tenant law, lease agreements, maintenance responsibilities, and property management best practices.',
      'price': 98.0,
      'rating': 4.5,
    },
    {
      'category': 'CA Insurance CE',
      'badge': 'INSURANCE CE',
      'title': 'CA Property & Casualty CE',
      'description': '24-hour continuing education for California Property & Casualty insurance license renewal. Covers policy types, endorsements, and claims handling.',
      'price': 39.0,
      'rating': 3.5,
    },
    {
      'category': 'Sales License',
      'badge': 'SALES LICENSE',
      'title': 'California Real Estate Practice',
      'description': 'DRE-approved 45-hour course covering listing agreements, buyer representation, advertising, escrow and closing procedures.',
      'price': 98.0,
      'rating': 5.0,
    },
  ];

  List<Map<String, dynamic>> get _filtered {
    if (_selectedCategory == 'All') return _products;
    return _products.where((p) => p['category'] == _selectedCategory).toList();
  }

  int _countFor(String cat) {
    if (cat == 'All') return _products.length;
    return _products.where((p) => p['category'] == cat).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: const RelstoneHeader(
        titleSpacing: 0,
        trailingSpacing: 8,
        titleWidget: Text(
          'CA Real Estate CE',
          style: TextStyle(
            color: primaryNavy,
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // ── Hero Banner ───────────────────────────────────
          Container(
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF0F2942),
                  primaryNavy.withOpacity(0.92),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: green.withOpacity(0.4), width: 1.5),
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
                    // ── CE Avatar ──
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text(
                          'CE',
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
                            'CA Real Estate CE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Complete your 45-hour renewal requirement. Includes Ethics, Agency, Fair Housing, Trust Funds & Risk Management.',
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
                        color: green,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        '4 Courses',
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
                Divider(color: Colors.white.withOpacity(0.12), height: 1),
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
                              child: _CEProductCard(product: p),
                            ))
                        .toList(),
                  );
                }
                final rows = <Widget>[];
                for (int i = 0; i < _filtered.length; i += 2) {
                  rows.add(
                    Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _CEProductCard(product: _filtered[i])),
                          const SizedBox(width: 14),
                          if (i + 1 < _filtered.length)
                            Expanded(child: _CEProductCard(product: _filtered[i + 1]))
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

/* ─── CE PRODUCT CARD ──────────────────────────────────────────────── */
class _CEProductCard extends StatefulWidget {
  final Map<String, dynamic> product;
  const _CEProductCard({required this.product});

  @override
  State<_CEProductCard> createState() => _CEProductCardState();
}

class _CEProductCardState extends State<_CEProductCard> {
  bool _inCart = false;

  static const Color primaryNavy = Color(0xFF1A3A5C);
  static const Color accentBlue  = Color(0xFF2E7EBE);
  static const Color textMuted   = Color(0xFF6B7E92);
  static const Color green       = Color(0xFF22C55E);
  static const Color amber       = Color(0xFFF5B301);

  String get _badge    => widget.product['badge'] as String;
  String get _category => widget.product['category'] as String;
  String get _title    => widget.product['title'] as String;
  String get _desc     => widget.product['description'] as String;
  double get _price    => widget.product['price'] as double;
  double get _rating   => (widget.product['rating'] as num).toDouble();

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
            // ── Badge ──
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: amber.withOpacity(0.12),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: amber.withOpacity(0.5)),
              ),
              child: Text(
                _badge,
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                  color: amber.withOpacity(0.9),
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
                  const SizedBox(height: 8),
                  // ── Star Rating ──
                  Row(
                    children: List.generate(5, (i) {
                      final filled = i < _rating.floor();
                      final half = !filled && i < _rating;
                      return Icon(
                        half
                            ? Icons.star_half_rounded
                            : filled
                                ? Icons.star_rounded
                                : Icons.star_outline_rounded,
                        color: amber,
                        size: 18,
                      );
                    }),
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
              '\$${_price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: green,
              ),
            ),

            const SizedBox(height: 14),

            // ── Add to Cart ──
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