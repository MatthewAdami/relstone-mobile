import 'package:flutter/material.dart';

import '../config/api_config.dart';
import '../services/api_client.dart';
import '../services/cart_service.dart';
import '../widgets/main_layout.dart';
import '../widgets/sidebar.dart';

class InsuranceStatePage extends StatefulWidget {
  final String? initialSlug;

  const InsuranceStatePage({super.key, this.initialSlug});

  @override
  State<InsuranceStatePage> createState() => _InsuranceStatePageState();
}

class _InsuranceStatePageState extends State<InsuranceStatePage> {
  String? _slug;
  bool _loading = true;
  String? _error;
  final CartService _cart = CartService.instance;

  Map<String, dynamic>? _stateData;
  List<Map<String, dynamic>> _courses = [];
  List<Map<String, dynamic>> _packages = [];

  final Map<String, bool> _textbookSelections = {};

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)?.settings.arguments;
    final nextSlug = widget.initialSlug ?? (args is String ? args : null);

    if (_slug == nextSlug) return;

    _slug = nextSlug;
    if (_slug == null || _slug!.isEmpty) {
      setState(() {
        _loading = false;
        _error = null;
      });
      return;
    }

    _fetchData();
  }

  Future<void> _fetchData() async {
    if (_slug == null || _slug!.isEmpty) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final result = await ApiClient.get(ApiConfig.insuranceStateFull(_slug!));
      final status = result['statusCode'] as int? ?? 500;
      final data = result['data'] as Map<String, dynamic>? ?? <String, dynamic>{};

      if (status < 200 || status >= 300) {
        throw Exception(data['message']?.toString() ?? 'Failed to load state data');
      }

      final full = data['data'] as Map<String, dynamic>?;
      if (full == null) {
        throw Exception('Invalid API response shape');
      }

      final state = full['state'] as Map<String, dynamic>? ?? <String, dynamic>{};
      final coursesRaw = full['courses'] as List? ?? const [];
      final packagesRaw = full['packages'] as List? ?? const [];

      setState(() {
        _stateData = state;
        _courses = coursesRaw
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
        _packages = packagesRaw
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _loading = false;
      });
    }
  }

  bool _isInCart(String id) => _cart.isInCart(id);

  void _toggleTextbook(String id) {
    setState(() {
      _textbookSelections[id] = !(_textbookSelections[id] ?? false);
    });

    if (_cart.isInCart(id)) {
      _cart.toggleTextbook(id);
    }
  }

  Future<void> _toggleCourseCart(Map<String, dynamic> course) async {
    final id = (course['_id'] ?? '').toString();
    if (id.isEmpty) return;

    if (_cart.isInCart(id)) {
      await _cart.removeFromCart(id);
      return;
    }

    final stateName = (_stateData?['name'] ?? '').toString();
    await _cart.addToCart(
      CartItem(
        id: id,
        type: 'course',
        name: (course['name'] ?? course['shortName'] ?? '').toString(),
        stateSlug: _slug ?? '',
        stateName: stateName,
        price: _num(course['price']),
        creditHours: _num(course['creditHours']).toInt(),
        withTextbook: _textbookSelections[id] ?? false,
        textbookPrice: _num(course['printedTextbookPrice']),
        quantity: 1,
      ),
    );
  }

  Future<void> _togglePackageCart(Map<String, dynamic> pkg) async {
    final id = (pkg['_id'] ?? '').toString();
    if (id.isEmpty) return;

    if (_cart.isInCart(id)) {
      await _cart.removeFromCart(id);
      return;
    }

    final stateName = (_stateData?['name'] ?? '').toString();
    await _cart.addToCart(
      CartItem(
        id: id,
        type: 'package',
        name: (pkg['name'] ?? '').toString(),
        stateSlug: _slug ?? '',
        stateName: stateName,
        price: _num(pkg['price']),
        creditHours: _num(pkg['totalHours']).toInt(),
        withTextbook: false,
        textbookPrice: 0,
        quantity: 1,
      ),
    );
  }

  double _num(dynamic v) {
    if (v is num) return v.toDouble();
    return double.tryParse(v?.toString() ?? '') ?? 0;
  }

  String _price(double v) => v.toStringAsFixed(2);

  String _coursePrice(Map<String, dynamic> course) {
    final id = (course['_id'] ?? '').toString();
    final base = _num(course['price']);
    final addon = (_textbookSelections[id] ?? false)
        ? _num(course['printedTextbookPrice'])
        : 0;
    return _price(base + addon);
  }

  List<String> _stringList(dynamic v) {
    if (v is! List) return const [];
    return v.map((e) => e.toString()).toList();
  }

  @override
  Widget build(BuildContext context) {
    final stateName = (_stateData?['name'] ?? 'Insurance') as String;

    if (_loading) {
      return MainLayout(
        drawer: const Sidebar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return MainLayout(
        drawer: const Sidebar(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text('❌ $_error', textAlign: TextAlign.center),
          ),
        ),
      );
    }

    if (_slug == null || _slug!.isEmpty) {
      return MainLayout(
        drawer: const Sidebar(),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text('Please select a state from the sidebar.'),
          ),
        ),
      );
    }

    if (_stateData == null || _stateData!.isEmpty) {
      return MainLayout(
        drawer: const Sidebar(),
        body: const Center(child: Text('No state data found.')),
      );
    }

    final introBullets = _stringList(_stateData!['introBullets']);
    final ceBullets = _stringList(_stateData!['ceBullets']);
    final req = (_stateData!['requirements'] as Map<String, dynamic>?) ??
        <String, dynamic>{};
    final reqNotes = _stringList(req['notes']);
    final exam = (_stateData!['examInstructions'] as Map<String, dynamic>?) ??
        <String, dynamic>{};
    final examOnline = _stringList(exam['online']);

    return MainLayout(
      drawer: const Sidebar(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionCard(
            title: (_stateData!['heroTitle'] ?? '$stateName Insurance CE').toString(),
            child: Text(
              (_stateData!['providerInfo'] ?? '').toString(),
              style: const TextStyle(color: Color(0xFF4B5563)),
            ),
          ),
          _SectionCard(
            title: 'Why Relstone for $stateName Insurance CE',
            child: Column(
              children: introBullets
                  .map((b) => _BulletRow(text: b, icon: Icons.check))
                  .toList(),
            ),
          ),
          _SectionCard(
            title: '$stateName Insurance Continuing Education Courses',
            child: Column(
              children: ceBullets
                  .map((b) => _BulletRow(text: b, icon: Icons.check))
                  .toList(),
            ),
          ),
          _SectionCard(
            title: '$stateName Insurance CE Guide',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _MiniInfoCard(
                      label: 'Producers',
                      value: (req['producerHours'] ?? '').toString(),
                      note: (req['producerEthicsHours'] ?? '').toString(),
                    ),
                    _MiniInfoCard(
                      label: 'Service Reps',
                      value: (req['serviceRepHours'] ?? '').toString(),
                      note: (req['serviceRepEthicsHours'] ?? '').toString(),
                    ),
                    _MiniInfoCard(
                      label: 'Renewal Deadline',
                      value: '',
                      note: (req['renewalDeadline'] ?? '').toString(),
                    ),
                    _MiniInfoCard(
                      label: 'Carry Over',
                      value: '',
                      note: (req['carryOverHours'] ?? '').toString(),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...reqNotes.map((n) => _BulletRow(text: n, icon: Icons.check)),
              ],
            ),
          ),
          _SectionCard(
            title: 'To Take Your Final Exam Online',
            child: Column(
              children: [
                ...examOnline.asMap().entries.map(
                  (e) => ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      radius: 14,
                      backgroundColor: const Color(0xFF2EABFE),
                      child: Text(
                        '${e.key + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    title: Text(e.value),
                  ),
                ),
                if ((exam['faxInfo'] ?? '').toString().isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF6FF),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFF2EABFE)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.print, color: Color(0xFF2EABFE)),
                        const SizedBox(width: 8),
                        Expanded(child: Text((exam['faxInfo'] ?? '').toString())),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          if (_packages.isNotEmpty)
            _SectionCard(
              title: 'Complete CE Packages — Renew Your $stateName Insurance License',
              child: Column(
                children: _packages.map((pkg) {
                  final id = (pkg['_id'] ?? '').toString();
                  final inCart = _isInCart(id);
                  final coursesIncluded = _stringList(pkg['coursesIncluded']);

                  return _ProductCard(
                    title: (pkg['name'] ?? '').toString(),
                    subtitle: '${(pkg['totalHours'] ?? 0)} Credit Hours',
                    bullets: coursesIncluded,
                    price: '\$${_price(_num(pkg['price']))}',
                    inCart: inCart,
                    onCartPressed: () => _togglePackageCart(pkg),
                  );
                }).toList(),
              ),
            ),
          if (_courses.isNotEmpty)
            _SectionCard(
              title: 'Individual Courses',
              child: Column(
                children: _courses.map((course) {
                  final id = (course['_id'] ?? '').toString();
                  final inCart = _isInCart(id);
                  final hasTextbook = course['hasPrintedTextbook'] == true;
                  final textbookPrice = _num(course['printedTextbookPrice']);

                  return _ProductCard(
                    title: (course['shortName'] ?? course['name'] ?? '').toString(),
                    subtitle:
                        '${(course['creditHours'] ?? 0)} Credit Hours • ${(course['courseType'] ?? 'General')}',
                    description: (course['description'] ?? '').toString(),
                    price: '\$${_coursePrice(course)}',
                    inCart: inCart,
                    extra: hasTextbook
                        ? CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            value: _textbookSelections[id] ?? false,
                            onChanged: (_) => _toggleTextbook(id),
                            title: Text(
                              'Add Printed Textbook (+\$${_price(textbookPrice)})',
                              style: const TextStyle(fontSize: 13),
                            ),
                            controlAffinity: ListTileControlAffinity.leading,
                          )
                        : null,
                    onCartPressed: () => _toggleCourseCart(course),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.5,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }
}

class _BulletRow extends StatelessWidget {
  final String text;
  final IconData icon;

  const _BulletRow({required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF22C55E), size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class _MiniInfoCard extends StatelessWidget {
  final String label;
  final String value;
  final String note;

  const _MiniInfoCard({
    required this.label,
    required this.value,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF2EABFE),
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
          if (value.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ),
          if (note.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(note, style: const TextStyle(color: Color(0xFF6B7280))),
            ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? description;
  final List<String> bullets;
  final String price;
  final bool inCart;
  final VoidCallback onCartPressed;
  final Widget? extra;

  const _ProductCard({
    required this.title,
    required this.subtitle,
    this.description,
    this.bullets = const [],
    required this.price,
    required this.inCart,
    required this.onCartPressed,
    this.extra,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: Color(0xFF2EABFE))),
          if ((description ?? '').isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(description!, style: const TextStyle(color: Color(0xFF6B7280))),
          ],
          if (bullets.isNotEmpty) ...[
            const SizedBox(height: 8),
            ...bullets.map((b) => _BulletRow(text: b, icon: Icons.check)),
          ],
          if (extra != null) ...[
            const SizedBox(height: 8),
            extra!,
          ],
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                price,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              ),
              ElevatedButton.icon(
                onPressed: onCartPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      inCart ? const Color(0xFF22C55E) : const Color(0xFF091925),
                  foregroundColor: Colors.white,
                ),
                icon: Icon(inCart ? Icons.check_circle : Icons.shopping_cart),
                label: Text(inCart ? 'Added' : 'Add to Cart'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}