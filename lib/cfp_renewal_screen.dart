import 'package:flutter/material.dart';
import 'services/cart_service.dart';
import 'services/cfp_service.dart';
import 'widgets/relstone_footer.dart';

class CFPRenewalScreen extends StatefulWidget {
  const CFPRenewalScreen({super.key});

  @override
  State<CFPRenewalScreen> createState() => _CFPRenewalScreenState();
}

class _CFPRenewalScreenState extends State<CFPRenewalScreen> {
  // ── Brand colors ──────────────────────────────────────────
  static const Color primaryNavy = Color(0xFF1A3A5C);
  static const Color accentBlue = Color(0xFF2E7EBE);
  static const Color navBg = Color(0xFF0B1A2A);
  static const Color cardBg = Color(0xFF132030);
  static const Color cardBorder = Color(0xFF1E3448);
  static const Color textMuted = Color(0xFF6B7E92);
  static const Color bgLight = Color(0xFFF4F6F9);

  final CartService _cart = CartService.instance;

  // ── State for packages   and courses ──────────────────────────────────────
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _packages = [];
  List<Map<String, dynamic>> _courses = [];
  final Map<String, bool> _textbookSelections = {};

  @override
  void initState() {
    super.initState();
    _cart.addListener(_onCartChanged);
    _cart.ensureLoaded();
    _fetchCFPData();
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

  Future<void> _fetchCFPData() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final result = await CFPService.getCFPRenewalData();

      if (result['success'] != true) {
        throw Exception(result['error'] ?? 'Failed to load CFP renewal data');
      }

      // Extract courses and packages from unified response
      final coursesData = (result['courses'] as List?) ?? [];
      final packagesData = (result['packages'] as List?) ?? [];

      setState(() {
        _courses = coursesData
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
        _packages = packagesData
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
        _loading = false;
      });
    } catch (e) {
      // Load demo data on error for development/testing
      setState(() {
        _courses = [
          {
            'name': 'Ethics and Standards',
            'description': 'Required CFP® CE course',
            'creditHours': 3,
            'price': 89.00,
            'courseType': 'Ethics',
            'stateSlug': 'cfp-renewal',
            '_id': 'demo-course-001'
          }
        ];
        _packages = [
          {
            'name': 'CFP CE: Renewal Combo for the CFP Professional',
            'description': 'All-inclusive package with all required CE hours including ethics.',
            'hours': 30,
            'price': 239.00,
            'badge': '30 Hours',
            'coursesIncluded': [
              'Ethics and Standards',
              'Insurance Law in the U.S., 2nd Ed.',
              'Business Continuation Insurance'
            ],
            '_id': 'demo-pkg-001'
          }
        ];
        _error = e.toString().replaceFirst('Exception: ', '');
        _loading = false;
      });
    }
  }

  bool _isInCart(String id) => _cart.isInCart(id);

  int _packageHours(Map<String, dynamic> package) {
    final rawHours = package['hours'] ?? package['totalHours'] ?? package['creditHours'];
    return _num(rawHours).toInt();
  }

  Future<void> _togglePackageCart(Map<String, dynamic> package) async {
    final id = (package['_id'] ?? '').toString();
    if (id.isEmpty) return;

    if (_cart.isInCart(id)) {
      await _cart.removeFromCart(id);
      return;
    }

    await _cart.addToCart(
      CartItem(
        id: id,
        type: 'package',
        name: (package['name'] ?? '').toString(),
        stateSlug: 'cfp',
        stateName: 'CFP Renewal',
        price: _num(package['price']),
        creditHours: _packageHours(package),
        withTextbook: false,
        textbookPrice: 0,
      ),
    );
  }

  Future<void> _toggleCourseCart(Map<String, dynamic> course) async {
    final id = (course['_id'] ?? '').toString();
    if (id.isEmpty) return;

    if (_cart.isInCart(id)) {
      await _cart.removeFromCart(id);
      return;
    }

    final creditHours = course['creditHours'] ?? course['hours'] ?? 0;
    final hasPrintedTextbook = course['hasPrintedTextbook'] == true;
    final wantsTextbook = _textbookSelections[id] == true;
    final textbookPrice = _num(course['printedTextbookPrice'] ?? course['textbookPrice']);

    await _cart.addToCart(
      CartItem(
        id: id,
        type: 'course',
        name: (course['name'] ?? '').toString(),
        stateSlug: 'cfp-renewal',
        stateName: 'CFP Renewal',
        price: _num(course['price']),
        creditHours: _num(creditHours).toInt(),
        withTextbook: hasPrintedTextbook && wantsTextbook,
        textbookPrice: hasPrintedTextbook && wantsTextbook ? textbookPrice : 0,
      ),
    );
  }

  double _num(dynamic v) {
    if (v is num) return v.toDouble();
    return double.tryParse(v?.toString() ?? '') ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: navBg,
      appBar: AppBar(
        backgroundColor: navBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            Image.asset(
              'assets/relstone_logo.png',
              height: 26,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Text(
                'RELSTONE',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.4,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Cart',
            onPressed: () => Navigator.pushNamed(context, '/cart'),
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(color: Colors.white.withValues(alpha: 0.08), height: 1),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header Section ──────────────────────────────────────
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    navBg,
                    navBg.withValues(alpha: 0.9),
                  ],
                ),
              ),
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'RELSTONE® · CFP® BOARD SPONSOR #91 · SINCE 1974',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF6B8FAF),
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                        color: Colors.white,
                      ),
                      children: [
                        TextSpan(text: 'Save Your '),
                        TextSpan(
                          text: 'CFP®\nCertification!',
                          style: TextStyle(color: accentBlue),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Studies show that median revenue of CFP® professionals is significantly '
                    'higher than non-CFP® professionals. Don\'t let your certification lapse.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFB4C6D8),
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            // ── Stats Section ──────────────────────────────────────
            Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: cardBorder, width: 1),
              ),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
              child: Row(
                children: [
                  Expanded(child: _StatItem(value: '30', label: 'Course\nHours')),
                  Container(width: 1, height: 40, color: cardBorder),
                  Expanded(child: _StatItem(value: '4M+', label: 'Courses\nCompleted')),
                  Container(width: 1, height: 40, color: cardBorder),
                  Expanded(child: _StatItem(value: '50+', label: 'Years\nExperience')),
                  Container(width: 1, height: 40, color: cardBorder),
                  Expanded(child: _StatItem(value: '#91', label: 'CFP® Board\nSponsor')),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Content Section ──────────────────────────────────────
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: bgLight,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),

                  // ── Why Choose RELSTONE®? Section ──────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Why Choose RELSTONE®?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: primaryNavy,
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'We know how hard you work to serve your clients, and we\'re committed to\nmaking your CFP® certification renewal as easy as possible.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: textMuted,
                              fontSize: 14,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ── Feature Cards Grid ──────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        // Responsive grid: 1 column on mobile, 2-3 on tablet/desktop
                        final crossAxisCount = constraints.maxWidth < 600
                            ? 1
                            : (constraints.maxWidth < 900 ? 2 : 3);

                        // All 6 cards
                        final cards = [
                          _FeatureCard(
                            icon: Icons.check_circle,
                            title: 'Fully Approved',
                            description: 'All courses approved for CFP® certification renewal. Registered with CFP® Board as Sponsor #91.',
                          ),
                          _FeatureCard(
                            icon: Icons.layers,
                            title: 'Triple Duty Credits',
                            description: 'Use the same courses to renew your CFP® certificate, insurance license, and in many states, your CPA license.',
                          ),
                          _FeatureCard(
                            icon: Icons.schedule,
                            title: 'Your Pace, Your Way',
                            description: 'Complete courses online or with printed books delivered to you. Finish as fast as you wish with no time pressure.',
                          ),
                          _FeatureCard(
                            icon: Icons.military_tech,
                            title: 'Proven Track Record',
                            description: 'Over 4 million courses completed across the U.S. since 1974. Trusted by professionals nationwide.',
                          ),
                          _FeatureCard(
                            icon: Icons.shield,
                            title: 'Risk-Free Guarantee',
                            description: '30-day money-back guarantee. If you\'re not satisfied, we\'ll refund your investment completely.',
                          ),
                          _FeatureCard(
                            icon: Icons.headset_mic,
                            title: '5-Star Customer Service',
                            description: 'Real experts averaging 20+ years of CE experience, available 7 days a week to help you.',
                          ),
                        ];

                        // Build rows with consistent heights
                        final rows = <Widget>[];
                        for (int i = 0; i < cards.length; i += crossAxisCount) {
                          final rowCards = cards.skip(i).take(crossAxisCount).toList();
                          rows.add(
                            IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  for (int j = 0; j < rowCards.length; j++) ...[
                                    Expanded(
                                      child: rowCards[j],
                                    ),
                                    if (j < rowCards.length - 1) const SizedBox(width: 16),
                                  ],
                                ],
                              ),
                            ),
                          );
                          if (i + crossAxisCount < cards.length) {
                            rows.add(const SizedBox(height: 16));
                          }
                        }

                        return Column(
                          children: rows,
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 48),

                  // ── CFP CE Hour Requirements Section ──────────────────
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F1A28),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final isWideScreen = constraints.maxWidth >= 600;

                        if (isWideScreen) {
                          // Desktop/Tablet: Side by side layout
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: _RequirementsList(),
                              ),
                              const SizedBox(width: 24),
                              Flexible(
                                flex: 1,
                                child: _DropdownButton(),
                              ),
                            ],
                          );
                        } else {
                          // Mobile: Stacked layout
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _RequirementsList(),
                              const SizedBox(height: 20),
                              _DropdownButton(),
                            ],
                          );
                        }
                      },
                    ),
                  ),

                  const SizedBox(height: 48),

                  // ── Complete CE Package Section ──────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Complete CE Package',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: primaryNavy,
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            height: 3,
                            width: 60,
                            decoration: BoxDecoration(
                              color: accentBlue,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Best value — everything you need to renew in one bundle.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: textMuted,
                              fontSize: 14,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ── Package Cards ──────────────────────────────────
                  if (_loading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(accentBlue),
                        ),
                      ),
                    )
                  else if (_packages.isNotEmpty) ...[
                    if (_error != null)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF3E0),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFFFB74D)),
                          ),
                          child: Text(
                            'Showing fallback data: $_error',
                            style: const TextStyle(
                              color: Color(0xFF8A5200),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ..._packages.map((package) => LayoutBuilder(
                          builder: (context, constraints) {
                            final isWide = constraints.maxWidth >= 900;
                            final card = _PackageCard(
                              package: package,
                              isInCart: _isInCart((package['_id'] ?? '').toString()),
                              onToggleCart: () => _togglePackageCart(package),
                            );

                            if (!isWide) {
                              return card;
                            }

                            return Center(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 980),
                                child: card,
                              ),
                            );
                          },
                        ))
                  ] else if (_error != null)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: Column(
                          children: [
                            Icon(Icons.error_outline, color: textMuted, size: 48),
                            const SizedBox(height: 16),
                            Text(
                              'Failed to load packages',
                              style: TextStyle(
                                color: textMuted,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _error!,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: textMuted, fontSize: 14),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _fetchCFPData,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: accentBlue,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: Text(
                          'No packages available at this time',
                          style: TextStyle(
                            color: textMuted,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(height: 64),

                  // ── Individual CFP® CE Courses Section ──────────────────────
                  Container(
                    color: bgLight,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Individual CFP® CE Courses',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: primaryNavy,
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            height: 3,
                            width: 60,
                            decoration: BoxDecoration(
                              color: accentBlue,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Pay only for the hours you need. All prices include the \$1.25/hr CFP® reporting fee.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: textMuted,
                              fontSize: 14,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ── Course Cards Grid ──────────────────────────────────
                  if (_courses.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final isWide = constraints.maxWidth >= 900;

                          if (isWide) {
                            return IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  for (int i = 0; i < _courses.length; i++) ...[
                                    Expanded(
                                      child: _CourseCard(
                                        course: _courses[i],
                                        isInCart: _isInCart((_courses[i]['_id'] ?? '').toString()),
                                        showTextbook: _textbookSelections[(_courses[i]['_id'] ?? '').toString()] ?? false,
                                        onToggleTextbook: (value) {
                                          final key = (_courses[i]['_id'] ?? '').toString();
                                          if (key.isEmpty) return;
                                          setState(() {
                                            _textbookSelections[key] = value;
                                          });
                                        },
                                        onToggleCart: () => _toggleCourseCart(_courses[i]),
                                      ),
                                    ),
                                    if (i < _courses.length - 1) const SizedBox(width: 12),
                                  ],
                                ],
                              ),
                            );
                          }

                          return Column(
                            children: [
                              for (int i = 0; i < _courses.length; i++) ...[
                                _CourseCard(
                                  course: _courses[i],
                                  isInCart: _isInCart((_courses[i]['_id'] ?? '').toString()),
                                  showTextbook: _textbookSelections[(_courses[i]['_id'] ?? '').toString()] ?? false,
                                  onToggleTextbook: (value) {
                                    final key = (_courses[i]['_id'] ?? '').toString();
                                    if (key.isEmpty) return;
                                    setState(() {
                                      _textbookSelections[key] = value;
                                    });
                                  },
                                  onToggleCart: () => _toggleCourseCart(_courses[i]),
                                ),
                                if (i < _courses.length - 1) const SizedBox(height: 16),
                              ],
                            ],
                          );
                        },
                      ),
                    ),
                  ] else if (!_loading)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: Text(
                          'No individual courses available',
                          style: TextStyle(
                            color: textMuted,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(height: 40),
                  const RelstoneFooter(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({super.key, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF2E7EBE),
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF6B8FAF),
            fontSize: 8,
            fontWeight: FontWeight.w600,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _CFPRenewalScreenState.accentBlue.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: _CFPRenewalScreenState.accentBlue,
              size: 28,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              color: _CFPRenewalScreenState.primaryNavy,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(
              color: _CFPRenewalScreenState.textMuted,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _RequirementsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CFP® CE Hour Requirements',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 20),
        _RequirementItem(text: '30 Hours of CE required every 2 years for CFP certification renewal.'),
        SizedBox(height: 12),
        _RequirementItem(text: '2 of the 30 hours must be from a pre-approved CFP Code of Ethics and/or Practice Standards program.'),
        SizedBox(height: 12),
        _RequirementItem(text: 'Hours may NOT be carried over from one Reporting Period to the next.'),
        SizedBox(height: 12),
        _RequirementItem(text: 'Courses may be repeated in a different compliance period.'),
        SizedBox(height: 12),
        _RequirementItem(text: 'We report hours completed directly to the CFP Board every Wednesday.'),
        SizedBox(height: 12),
        _RequirementItem(text: 'All prices include the CFP-imposed reporting fee of \$1.25 per hour.'),
      ],
    );
  }
}

class _RequirementItem extends StatelessWidget {
  final String text;

  const _RequirementItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.check_box,
          color: Color(0xFF00C853),
          size: 18,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _DropdownButton extends StatefulWidget {
  @override
  State<_DropdownButton> createState() => _DropdownButtonState();
}

class _DropdownButtonState extends State<_DropdownButton> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF1A2A3C),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFF2E7EBE).withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Full Requirements & Notes',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(
                  _isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
        if (_isExpanded) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A2A3C),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _RequirementRow(
                  label: 'Total Hours / Period',
                  value: '30 Hours / 2 Years',
                ),
                const SizedBox(height: 12),
                _RequirementRow(
                  label: 'Ethics Requirement',
                  value: '2 hours must be CFP® Code of Ethics and/or Practice Standards (pre-approved program)',
                ),
                const SizedBox(height: 12),
                _RequirementRow(
                  label: 'Renewal Deadline',
                  value: 'Two-year reporting period ending the last day of the CFP® Certificant\'s renewal month.',
                ),
                const SizedBox(height: 12),
                _RequirementRow(
                  label: 'Carryover',
                  value: 'Hours may NOT be carried over from one Reporting Period to the next.',
                ),
                const SizedBox(height: 16),
                const _RequirementNote(text: 'Certificants can check CE hours at www.CFP.net/login.'),
                const SizedBox(height: 8),
                const _RequirementNote(text: 'If all required CE hours are reported by sponsors, no additional self-reporting is needed.'),
                const SizedBox(height: 8),
                const _RequirementNote(text: 'Complete your exam at least 15 days before your renewal date.'),
                const SizedBox(height: 8),
                const _RequirementNote(text: 'Reporting fees effective January 2023: \$1.25 per hour (included in all prices).'),
                const SizedBox(height: 8),
                const _RequirementNote(text: 'Grades required: 70% for standard courses; 80% for CFP® Code of Ethics courses.'),
                const SizedBox(height: 8),
                const _RequirementNote(text: 'Find us on the official CFP® website as "Cal-State Exams, Inc."'),
                const SizedBox(height: 8),
                const _RequirementNote(text: 'Can also be used toward insurance license renewal and (in many states) CPA renewal.'),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _RequirementRow extends StatelessWidget {
  final String label;
  final String value;

  const _RequirementRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF6B8FAF),
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _RequirementNote extends StatelessWidget {
  final String text;

  const _RequirementNote({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.check_box,
          color: Color(0xFF00C853),
          size: 16,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _PackageCard extends StatelessWidget {
  final Map<String, dynamic> package;
  final bool isInCart;
  final VoidCallback onToggleCart;

  const _PackageCard({
    required this.package,
    required this.isInCart,
    required this.onToggleCart,
  });

  @override
  Widget build(BuildContext context) {
    final name = (package['name'] ?? '').toString();
    final rawHours = package['hours'] ?? package['totalHours'] ?? package['creditHours'];
    final hours = rawHours is num
        ? rawHours.toDouble()
        : double.tryParse(rawHours?.toString() ?? '') ?? 0;
    final hoursLabel = hours % 1 == 0
        ? hours.toInt().toString()
        : hours.toStringAsFixed(1);
    final price = (package['price'] is num)
        ? (package['price'] as num).toDouble()
        : 0.0;
    final courses = (package['coursesIncluded'] is List)
        ? (package['coursesIncluded'] as List)
            .map((e) => e.toString())
            .toList()
        : <String>[];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _CFPRenewalScreenState.accentBlue,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              color: _CFPRenewalScreenState.primaryNavy,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          if (courses.isNotEmpty) ...[
            const Text(
              'COURSES INCLUDED:',
              style: TextStyle(
                color: _CFPRenewalScreenState.textMuted,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            ...courses.map(
              (c) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  c,
                  style: const TextStyle(
                    color: _CFPRenewalScreenState.primaryNavy,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
          Row(
            children: [
              Text(
                '$hoursLabel Hours',
                style: const TextStyle(
                  color: _CFPRenewalScreenState.accentBlue,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Text(
                '\$${price.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: _CFPRenewalScreenState.primaryNavy,
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onToggleCart,
              icon: Icon(
                isInCart ? Icons.check_circle : Icons.shopping_cart_outlined,
              ),
              label: Text(isInCart ? 'In Cart' : 'Add to Cart'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isInCart
                    ? Colors.green
                    : _CFPRenewalScreenState.accentBlue,
                foregroundColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'All prices include CFP reporting fees (\$1.25/hr)',
            style: TextStyle(
              color: _CFPRenewalScreenState.textMuted,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _CourseCard extends StatelessWidget {
  final Map<String, dynamic> course;
  final bool isInCart;
  final bool showTextbook;
  final ValueChanged<bool> onToggleTextbook;
  final VoidCallback onToggleCart;

  const _CourseCard({
    required this.course,
    required this.isInCart,
    required this.showTextbook,
    required this.onToggleTextbook,
    required this.onToggleCart,
  });

  @override
  Widget build(BuildContext context) {
    final name = (course['name'] ?? '').toString();
    final description = (course['description'] ?? '').toString();
    final rawHours = course['creditHours'] ?? course['hours'] ?? 0;
    final hours = rawHours is num
        ? rawHours.toDouble()
        : double.tryParse(rawHours.toString()) ?? 0;
    final hoursLabel = hours % 1 == 0
        ? hours.toInt().toString()
        : hours.toStringAsFixed(1);
    final price = (course['price'] is num)
        ? (course['price'] as num).toDouble()
        : 0.0;
    final courseType = (course['courseType'] ?? '').toString();
    final isEthics = courseType.toLowerCase().trim() == 'ethics';
    final hasPrintedTextbook = course['hasPrintedTextbook'] == true;
    final printedTextbookPrice = (course['printedTextbookPrice'] is num)
        ? (course['printedTextbookPrice'] as num).toDouble()
        : 0.0;
    final displayPrice = price + (hasPrintedTextbook && showTextbook ? printedTextbookPrice : 0);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _CFPRenewalScreenState.accentBlue.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (courseType.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isEthics
                    ? const Color(0xFFFFF3CD)
                    : _CFPRenewalScreenState.accentBlue.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isEthics
                      ? const Color(0xFFD4A63A)
                      : _CFPRenewalScreenState.accentBlue.withValues(alpha: 0.45),
                ),
              ),
              child: Text(
                courseType,
                style: TextStyle(
                  color: isEthics
                      ? const Color(0xFF8A5A00)
                      : _CFPRenewalScreenState.accentBlue,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          if (courseType.isNotEmpty) const SizedBox(height: 10),
          Text(
            name,
            style: const TextStyle(
              color: _CFPRenewalScreenState.primaryNavy,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                '$hoursLabel Hours',
                style: const TextStyle(
                  color: _CFPRenewalScreenState.accentBlue,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Text(
                '\$${displayPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: _CFPRenewalScreenState.primaryNavy,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          if (description.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              description,
              style: const TextStyle(
                color: _CFPRenewalScreenState.textMuted,
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ],
          if (hasPrintedTextbook) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Checkbox(
                  value: showTextbook,
                  onChanged: (value) => onToggleTextbook(value ?? false),
                ),
                Expanded(
                  child: Text(
                    'Receive Printed Textbooks (+\$${printedTextbookPrice.toStringAsFixed(2)})',
                    style: const TextStyle(
                      color: _CFPRenewalScreenState.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onToggleCart,
              icon: Icon(
                isInCart ? Icons.check_circle : Icons.shopping_cart_outlined,
              ),
              label: Text(isInCart ? 'In Cart' : 'Add to Cart'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isInCart
                    ? Colors.green
                    : _CFPRenewalScreenState.accentBlue,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}





