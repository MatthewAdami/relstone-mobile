import 'package:flutter/material.dart';
import '../config/api_config.dart';
import '../services/api_client.dart';
import '../services/cart_service.dart';
import '../widgets/relstone_header.dart';

// ── Brand Colors ─────────────────────────────────────────────────────
const Color _navy    = Color(0xFF1A3A5C);
const Color _blue    = Color(0xFF2E7EBE);
const Color _green   = Color(0xFF22C55E);
const Color _muted   = Color(0xFF6B7E92);
const Color _bg      = Color(0xFFF4F6F9);
const Color _white   = Colors.white;

class AllProductsScreen extends StatefulWidget {
  final String initialSearch;
  const AllProductsScreen({super.key, this.initialSearch = ''});
 

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  final CartService _cart = CartService.instance;

  List<Map<String, dynamic>> _allData = [];
  bool _loading = true;
  String? _error;

  // ── Filters ───────────────────────────────────────────────
  String _search       = '';
  String _filterType   = 'all';   // all | course | package
  String _filterCat    = 'all';   // all | General | Ethics
  String _selectedState = 'all';

  double _priceMin = 0;
  double _priceMax = 300;
  double _globalMin = 0;
  double _globalMax = 300;

  final TextEditingController _searchController = TextEditingController();

  @override
void initState() {
  super.initState();
  _search = widget.initialSearch;
  _searchController.text = widget.initialSearch;
  _cart.addListener(_onCartChanged);
  _cart.ensureLoaded();
  _fetchAll();
}

  @override
  void dispose() {
    _cart.removeListener(_onCartChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onCartChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _fetchAll() async {
    setState(() { _loading = true; _error = null; });

    try {
      // 1. Fetch all states
      final statesRes = await ApiClient.get(ApiConfig.insuranceStates);
      final statesStatus = statesRes['statusCode'] as int? ?? 500;
      final statesData   = statesRes['data']       as Map<String, dynamic>? ?? {};

      if (statesStatus < 200 || statesStatus >= 300) {
        throw Exception(statesData['message']?.toString() ?? 'Failed to load states');
      }

        final statesList = (statesData['states'] as List?) ??
          (statesData['data'] as List?) ??
          const [];

      // 2. Fetch full data for each state
      final List<Map<String, dynamic>> fullData = [];
      for (final s in statesList) {
        final slug = (s['slug'] ?? '').toString();
        if (slug.isEmpty) continue;

        final r = await ApiClient.get(ApiConfig.insuranceStateFull(slug));
        final rStatus = r['statusCode'] as int? ?? 500;
        final rData   = r['data']       as Map<String, dynamic>? ?? {};

        if (rStatus >= 200 && rStatus < 300) {
          final d = (rData['data'] as Map<String, dynamic>?) ?? rData;
          fullData.add(d);
        }
      }

      // 3. Compute global price bounds
      final allPrices = <double>[];
      for (final d in fullData) {
        for (final c in (d['courses'] as List? ?? [])) {
          final p = _toDouble((c as Map)['price']);
          if (p > 0) allPrices.add(p);
        }
        for (final p in (d['packages'] as List? ?? [])) {
          final price = _toDouble((p as Map)['price']);
          if (price > 0) allPrices.add(price);
        }
      }

      double gMin = 0, gMax = 300;
      if (allPrices.isNotEmpty) {
        gMin = allPrices.reduce((a, b) => a < b ? a : b).floorToDouble();
        gMax = allPrices.reduce((a, b) => a > b ? a : b).ceilToDouble();
      }

      setState(() {
        _allData     = fullData;
        _globalMin   = gMin;
        _globalMax   = gMax;
        _priceMin    = gMin;
        _priceMax    = gMax;
        _loading     = false;
      });
    } catch (e) {
      setState(() {
        _error   = e.toString().replaceFirst('Exception: ', '');
        _loading = false;
      });
    }
  }

  // ── Filtering ─────────────────────────────────────────────
  List<Map<String, dynamic>> get _filtered {
    final q = _search.toLowerCase();

    return _allData.where((d) {
      final state = d['state'] as Map<String, dynamic>? ?? {};
      if (_selectedState != 'all' && state['slug'] != _selectedState) return false;

      final courses  = _filteredCourses(d['courses']  as List? ?? [], q);
      final packages = _filteredPackages(d['packages'] as List? ?? [], q);
      return courses.isNotEmpty || packages.isNotEmpty;
    }).map((d) {
      final q2 = _search.toLowerCase();
      return {
        ...d,
        'courses':  _filteredCourses(d['courses']  as List? ?? [], q2),
        'packages': _filteredPackages(d['packages'] as List? ?? [], q2),
      };
    }).toList();
  }

  List<Map<String, dynamic>> _filteredCourses(List raw, String q) {
    return raw
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .where((c) {
          if (_filterType == 'package') return false;
          if (q.isNotEmpty && !(c['name'] ?? '').toString().toLowerCase().contains(q)) return false;
          if (_filterCat != 'all' && c['courseType'] != _filterCat) return false;
          final price = _toDouble(c['price']);
          return price >= _priceMin && price <= _priceMax;
        })
        .toList();
  }

  List<Map<String, dynamic>> _filteredPackages(List raw, String q) {
    return raw
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .where((p) {
          if (_filterType == 'course') return false;
          if (q.isNotEmpty && !(p['name'] ?? '').toString().toLowerCase().contains(q)) return false;
          final price = _toDouble(p['price']);
          return price >= _priceMin && price <= _priceMax;
        })
        .toList();
  }

  bool get _hasFilters =>
      _search.isNotEmpty      ||
      _filterType  != 'all'   ||
      _filterCat   != 'all'   ||
      _selectedState != 'all' ||
      _priceMin > _globalMin  ||
      _priceMax < _globalMax;

  void _clearFilters() {
    setState(() {
      _search        = '';
      _filterType    = 'all';
      _filterCat     = 'all';
      _selectedState = 'all';
      _priceMin      = _globalMin;
      _priceMax      = _globalMax;
      _searchController.clear();
    });
  }

  double _toDouble(dynamic v) {
    if (v is num) return v.toDouble();
    return double.tryParse(v?.toString() ?? '') ?? 0;
  }

  List<String> _stringList(dynamic v) {
    if (v is! List) return const [];
    return v.map((e) => e.toString()).toList();
  }

  int get _totalProducts => _filtered.fold(0, (sum, d) =>
      sum + (d['courses'] as List).length + (d['packages'] as List).length);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: const RelstoneHeader(showCartBadge: true),
      body: Column(
        children: [
          // ── Page Header ───────────────────────────────────
          Container(
            width: double.infinity,
            color: _navy,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'All Relstone Products',
                  style: TextStyle(color: _white, fontSize: 22, fontWeight: FontWeight.w800),
                ),
                SizedBox(height: 4),
                Text(
                  'Browse our complete catalog of insurance CE courses and packages across all states.',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),

          // ── Filter Bar ────────────────────────────────────
          Container(
            color: _white,
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: Column(
              children: [
                // Search
                TextField(
                  controller: _searchController,
                  onChanged: (v) => setState(() => _search = v),
                  decoration: InputDecoration(
                    hintText: 'Search courses and packages...',
                    hintStyle: const TextStyle(color: _muted, fontSize: 13),
                    prefixIcon: const Icon(Icons.search, color: _muted, size: 20),
                    suffixIcon: _search.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close, size: 18),
                            onPressed: () => setState(() {
                              _search = '';
                              _searchController.clear();
                            }),
                          )
                        : null,
                    filled: true,
                    fillColor: _bg,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // State dropdown
                if (_allData.isNotEmpty)
                  DropdownButtonFormField<String>(
                    initialValue: _selectedState,
                    decoration: InputDecoration(
                      labelText: 'State',
                      labelStyle: const TextStyle(fontSize: 12, color: _muted),
                      filled: true,
                      fillColor: _bg,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: [
                      const DropdownMenuItem(value: 'all', child: Text('All States')),
                      ..._allData.map((d) {
                        final state = d['state'] as Map<String, dynamic>? ?? {};
                        return DropdownMenuItem(
                          value: state['slug']?.toString() ?? '',
                          child: Text(state['name']?.toString() ?? ''),
                        );
                      }),
                    ],
                    onChanged: (v) => setState(() => _selectedState = v ?? 'all'),
                  ),
                const SizedBox(height: 8),

                // Type toggles
                Row(
                  children: [
                    const Text('Type:', style: TextStyle(fontSize: 12, color: _muted, fontWeight: FontWeight.w600)),
                    const SizedBox(width: 8),
                    ...[('all', 'All'), ('course', 'Courses'), ('package', 'Packages')].map(
                      (t) => Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: _ToggleChip(
                          label: t.$2,
                          active: _filterType == t.$1,
                          onTap: () => setState(() => _filterType = t.$1),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Category toggles
                Row(
                  children: [
                    const Text('Category:', style: TextStyle(fontSize: 12, color: _muted, fontWeight: FontWeight.w600)),
                    const SizedBox(width: 8),
                    ...[('all', 'All'), ('General', 'General'), ('Ethics', 'Ethics')].map(
                      (c) => Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: _ToggleChip(
                          label: c.$2,
                          active: _filterCat == c.$1,
                          onTap: () => setState(() => _filterCat = c.$1),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Price range
                if (!_loading && _globalMax > _globalMin) ...[
                  Row(
                    children: [
                      const Icon(Icons.attach_money, size: 16, color: _muted),
                      const Text('Price:', style: TextStyle(fontSize: 12, color: _muted, fontWeight: FontWeight.w600)),
                      const SizedBox(width: 8),
                      Text(
                        '\$${_priceMin.toInt()} – \$${_priceMax.toInt()}',
                        style: const TextStyle(fontSize: 12, color: _navy, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  RangeSlider(
                    values: RangeValues(_priceMin, _priceMax),
                    min: _globalMin,
                    max: _globalMax,
                    divisions: (_globalMax - _globalMin).toInt().clamp(1, 200),
                    activeColor: _blue,
                    inactiveColor: _blue.withOpacity(0.2),
                    onChanged: (v) => setState(() {
                      _priceMin = v.start;
                      _priceMax = v.end;
                    }),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('\$${_globalMin.toInt()}', style: const TextStyle(fontSize: 11, color: _muted)),
                      Text('\$${_globalMax.toInt()}', style: const TextStyle(fontSize: 11, color: _muted)),
                    ],
                  ),
                ],

                // Clear filters
                if (_hasFilters)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: _clearFilters,
                      icon: const Icon(Icons.close, size: 14),
                      label: const Text('Clear All Filters', style: TextStyle(fontSize: 12)),
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                    ),
                  ),
              ],
            ),
          ),

          // ── Results meta ──────────────────────────────────
          if (!_loading && _error == null)
            Container(
              color: _bg,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Row(
                children: [
                  Text(
                    'Showing $_totalProducts product${_totalProducts != 1 ? 's' : ''} '
                    'across ${_filtered.length} state${_filtered.length != 1 ? 's' : ''}',
                    style: const TextStyle(fontSize: 12, color: _muted),
                  ),
                  if (_hasFilters)
                    const Text(' (filtered)', style: TextStyle(fontSize: 12, color: _blue, fontWeight: FontWeight.w600)),
                ],
              ),
            ),

          // ── Body ──────────────────────────────────────────
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator(color: _blue))
                : _error != null
                    ? _ErrorView(error: _error!, onRetry: _fetchAll)
                    : _filtered.isEmpty
                        ? _EmptyView(onClear: _clearFilters)
                        : ListView.builder(
                            padding: const EdgeInsets.all(12),
                            itemCount: _filtered.length,
                            itemBuilder: (context, i) {
                              final d       = _filtered[i];
                              final state   = d['state']    as Map<String, dynamic>? ?? {};
                              final courses  = d['courses']  as List<Map<String, dynamic>>;
                              final packages = d['packages'] as List<Map<String, dynamic>>;
                              return _StateSection(
                                stateName:  state['name']?.toString() ?? '',
                                courses:    courses,
                                packages:   packages,
                                cart:       _cart,
                                defaultOpen: i == 0 || _hasFilters,
                                stringList: _stringList,
                                toDouble:   _toDouble,
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}

// ── Toggle Chip ───────────────────────────────────────────────────────
class _ToggleChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _ToggleChip({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: active ? _navy : _bg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: active ? _navy : Colors.grey.shade300),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: active ? _white : _muted,
          ),
        ),
      ),
    );
  }
}

// ── State Section ─────────────────────────────────────────────────────
class _StateSection extends StatefulWidget {
  
  final String stateName;
  final List<Map<String, dynamic>> courses;
  final List<Map<String, dynamic>> packages;
  final CartService cart;
  final bool defaultOpen;
  final List<String> Function(dynamic) stringList;
  final double Function(dynamic) toDouble;

  const _StateSection({
    required this.stateName,
    required this.courses,
    required this.packages,
    required this.cart,
    required this.defaultOpen,
    required this.stringList,
    required this.toDouble,
  });

  @override
  State<_StateSection> createState() => _StateSectionState();
}

class _StateSectionState extends State<_StateSection> {
  late bool _open;
  final Map<String, bool> _textbookSelections = {};

  @override
  void initState() {
    super.initState();
    _open = widget.defaultOpen;
  }

  String _price(double v) => v.toStringAsFixed(2);

  String _itemId(Map<String, dynamic> item, {required String type}) {
    final rawId = (item['_id'] ?? '').toString().trim();
    if (rawId.isNotEmpty) return rawId;

    final name = (item['name'] ?? item['shortName'] ?? '').toString().trim();
    final normalized = name
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-|-$'), '');
    final price = widget.toDouble(item['price']).toStringAsFixed(2);

    return '$type|${widget.stateName}|$normalized|$price';
  }

  Future<void> _toggleCourse(Map<String, dynamic> course) async {
    final id = _itemId(course, type: 'course');

    if (widget.cart.isInCart(id)) {
      await widget.cart.removeFromCart(id);
    } else {
      await widget.cart.addToCart(CartItem(
        id: id,
        type: 'course',
        name: (course['name'] ?? course['shortName'] ?? '').toString(),
        stateSlug: '',
        stateName: widget.stateName,
        price: widget.toDouble(course['price']),
        creditHours: widget.toDouble(course['creditHours']).toInt(),
        withTextbook: _textbookSelections[id] ?? false,
        textbookPrice: widget.toDouble(course['printedTextbookPrice']),
      ));
    }
    setState(() {});
  }

  Future<void> _togglePackage(Map<String, dynamic> pkg) async {
    final id = _itemId(pkg, type: 'package');

    if (widget.cart.isInCart(id)) {
      await widget.cart.removeFromCart(id);
    } else {
      await widget.cart.addToCart(CartItem(
        id: id,
        type: 'package',
        name: (pkg['name'] ?? '').toString(),
        stateSlug: '',
        stateName: widget.stateName,
        price: widget.toDouble(pkg['price']),
        creditHours: widget.toDouble(pkg['totalHours']).toInt(),
        withTextbook: false,
        textbookPrice: 0,
      ));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.courses.length + widget.packages.length;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: _white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: _navy.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          // Header
          InkWell(
            onTap: () => setState(() => _open = !_open),
            borderRadius: _open
                ? const BorderRadius.vertical(top: Radius.circular(14))
                : BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.stateName,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: _navy),
                        ),
                        Text(
                          '$total product${total != 1 ? 's' : ''}',
                          style: const TextStyle(fontSize: 12, color: _muted),
                        ),
                      ],
                    ),
                  ),
                  Icon(_open ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: _muted),
                ],
              ),
            ),
          ),

          if (_open) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Packages
                  if (widget.packages.isNotEmpty) ...[
                    Row(
                      children: const [
                        Icon(Icons.layers_rounded, color: _blue, size: 16),
                        SizedBox(width: 6),
                        Text('Packages', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: _navy)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...widget.packages.map((pkg) {
                      final id     = _itemId(pkg, type: 'package');
                      final inCart = widget.cart.isInCart(id);
                      final bullets = widget.stringList(pkg['coursesIncluded']);
                      return _ProductCard(
                        type: 'package',
                        title: (pkg['name'] ?? '').toString(),
                        subtitle: '${(pkg['totalHours'] ?? 0)} Credit Hours',
                        price: '\$${_price(widget.toDouble(pkg['price']))}',
                        bullets: bullets,
                        inCart: inCart,
                        onCartPressed: () => _togglePackage(pkg),
                      );
                    }),
                    const SizedBox(height: 12),
                  ],

                  // Courses
                  if (widget.courses.isNotEmpty) ...[
                    Row(
                      children: const [
                        Icon(Icons.menu_book_rounded, color: _blue, size: 16),
                        SizedBox(width: 6),
                        Text('Individual Courses', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: _navy)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...widget.courses.map((course) {
                      final id          = _itemId(course, type: 'course');
                      final inCart      = widget.cart.isInCart(id);
                      final hasTextbook = course['hasPrintedTextbook'] == true;
                      final tbPrice     = widget.toDouble(course['printedTextbookPrice']);
                      final basePrice   = widget.toDouble(course['price']);
                      final withTb      = _textbookSelections[id] ?? false;
                      final totalPrice  = basePrice + (withTb ? tbPrice : 0);

                      return _ProductCard(
                        type: 'course',
                        title: (course['name'] ?? course['shortName'] ?? '').toString(),
                        subtitle: '${(course['creditHours'] ?? 0)} Credit Hours • ${(course['courseType'] ?? 'General')}',
                        price: '\$${_price(totalPrice)}',
                        inCart: inCart,
                        extra: hasTextbook && tbPrice > 0
                            ? CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                value: withTb,
                                onChanged: (_) => setState(() {
                                  _textbookSelections[id] = !(withTb);
                                }),
                                title: Text(
                                  'Add Printed Textbook (+\$${_price(tbPrice)})',
                                  style: const TextStyle(fontSize: 12, color: _muted),
                                ),
                                controlAffinity: ListTileControlAffinity.leading,
                              )
                            : null,
                        onCartPressed: () => _toggleCourse(course),
                      );
                    }),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Product Card ──────────────────────────────────────────────────────
class _ProductCard extends StatelessWidget {
  final String type;
  final String title;
  final String subtitle;
  final String price;
  final List<String> bullets;
  final bool inCart;
  final VoidCallback onCartPressed;
  final Widget? extra;

  const _ProductCard({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.price,
    this.bullets = const [],
    required this.inCart,
    required this.onCartPressed,
    this.extra,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: inCart ? _green.withOpacity(0.04) : _bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: inCart ? _green.withOpacity(0.4) : Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: type == 'package' ? _navy.withOpacity(0.1) : _blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      type == 'package' ? Icons.layers_rounded : Icons.menu_book_rounded,
                      size: 11,
                      color: type == 'package' ? _navy : _blue,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      type == 'package' ? 'Package' : 'Course',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: type == 'package' ? _navy : _blue,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text(
                price,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: _navy),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: _navy)),
          const SizedBox(height: 2),
          Text(subtitle, style: const TextStyle(fontSize: 12, color: _blue)),

          if (bullets.isNotEmpty) ...[
            const SizedBox(height: 8),
            ...bullets.map((b) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle_outline, size: 14, color: _green),
                  const SizedBox(width: 6),
                  Expanded(child: Text(b, style: const TextStyle(fontSize: 12, color: _muted))),
                ],
              ),
            )),
          ],

          if (extra != null) ...[
            const SizedBox(height: 6),
            extra!,
          ],

          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onCartPressed,
              icon: Icon(inCart ? Icons.check_circle : Icons.shopping_cart_outlined, size: 16),
              label: Text(inCart ? 'In Cart' : 'Add to Cart'),
              style: ElevatedButton.styleFrom(
                backgroundColor: inCart ? _green : _navy,
                foregroundColor: _white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Error View ────────────────────────────────────────────────────────
class _ErrorView extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;
  const _ErrorView({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 12),
            Text('Failed to load products: $error',
                textAlign: TextAlign.center,
                style: const TextStyle(color: _muted)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(backgroundColor: _navy, foregroundColor: _white),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Empty View ────────────────────────────────────────────────────────
class _EmptyView extends StatelessWidget {
  final VoidCallback onClear;
  const _EmptyView({required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off_rounded, color: _muted, size: 48),
            const SizedBox(height: 12),
            const Text('No products found', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: _navy)),
            const SizedBox(height: 6),
            const Text('Try adjusting your search or filters.', style: TextStyle(color: _muted)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onClear,
              style: ElevatedButton.styleFrom(backgroundColor: _navy, foregroundColor: _white),
              child: const Text('Clear All Filters'),
            ),
          ],
        ),
      ),
    );
  }
}