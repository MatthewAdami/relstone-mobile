import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'profile_screen.dart';
import '../config/api_config.dart';
import '../services/api_client.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Brand   colors
  static const Color primaryNavy = Color(0xFF1A3A5C);
  static const Color accentBlue  = Color(0xFF2E7EBE);
  static const Color textDark    = Color(0xFF1C2B3A);
  static const Color textMuted   = Color(0xFF6B7E92);
  static const Color bg          = Color(0xFFF4F6F9);

  // ── Loaded from route arguments ───────────────────────────
  Map<String, dynamic>? _user;
  String? _token;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map<String, dynamic>) {
      _user  = args['user']  as Map<String, dynamic>?;
      _token = args['token'] as String?;
    }
  }

  // ── Helpers ───────────────────────────────────────────────
  String get _userName  => _user?['name']  ?? _user?['email'] ?? 'User';
  String get _userEmail => _user?['email'] ?? '';
  String get _studentId =>
      (_user?['studentId'] ??
       _user?['_id']       ??
       _user?['id']        ??
       '').toString();

  String get _initials {
    final name = _userName.trim();
    if (name.isEmpty) return 'U';
    final parts = name.split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name[0].toUpperCase();
  }

  void _goToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProfileScreen(
          studentId: _studentId,
          token: _token ?? '',
          user: _user,
        ),
      ),
    );
  }

  void _logout() {
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      drawer: _AppSidebar(onLogout: _logout),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        titleSpacing: 16,
        title: Image.asset(
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
        actions: [
          IconButton(
            tooltip: 'Cart',
            onPressed: () => Navigator.pushNamed(context, '/cart'),
            icon: const Icon(Icons.shopping_cart_outlined, color: primaryNavy),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12, left: 4),
            child: GestureDetector(
              onTap: _goToProfile,
              child: Tooltip(
                message: _userName,
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: primaryNavy,
                  child: Text(
                    _initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // ── Welcome banner ────────────────────────────────────
          if (_user != null)
            Container(
              margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: accentBlue.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: accentBlue.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: primaryNavy,
                    child: Text(
                      _initials,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome back, ${_userName.split(' ').first}!',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: primaryNavy,
                          ),
                        ),
                        Text(_userEmail,
                            style: const TextStyle(fontSize: 12, color: textMuted)),
                        Text(
                          'ID: ${_user?['studentId'] ?? '—'}',
                          style: const TextStyle(fontSize: 12, color: textMuted),
                        ),
                        Text(
                          _user?['mobilePhone'] ?? '',
                          style: const TextStyle(fontSize: 12, color: textMuted),
                        ),
                        Text(
                          _user?['mailingAddress'] ?? '',
                          style: const TextStyle(fontSize: 11, color: textMuted),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: _goToProfile,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      backgroundColor: primaryNavy,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text(
                      'Profile',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),

          _HeroSection(onSalesLicense: () {}, onBrokerLicense: () {}),
          const SizedBox(height: 18),

          const _SectionTitle(
            eyebrow: 'OUR SERVICES',
            title: 'To get started, choose one of the selections below',
            subtitle:
                'California-specific real estate and insurance education tailored to your needs and goals.',
          ),
          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: const [
                _ServiceCard(
                  icon: Icons.schedule_rounded,
                  title: '45 Hour DRE Renewal CE',
                  subtitle: 'Complete your continuing education to renew your license',
                  cta: 'Get Started',
                ),
                SizedBox(height: 12),
                _ServiceCard(
                  icon: Icons.school_rounded,
                  title: 'Become an Agent',
                  subtitle: 'Get your California Real Estate Sales License',
                  cta: 'Get Started',
                ),
                SizedBox(height: 12),
                _ServiceCard(
                  icon: Icons.workspace_premium_rounded,
                  title: 'Become a Broker',
                  subtitle: 'Advance your career with a Broker License',
                  cta: 'Get Started',
                ),
                SizedBox(height: 12),
                _ServiceCard(
                  icon: Icons.menu_book_rounded,
                  title: 'Sales Agent Exam Prep',
                  subtitle: 'Prepare for your state exam with confidence',
                  cta: 'Get Started',
                ),
                SizedBox(height: 12),
                _ServiceCard(
                  icon: Icons.local_offer_rounded,
                  title: 'Insurance CE',
                  subtitle: 'Renew your insurance license in multiple states',
                  cta: 'Select a State',
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _GuaranteeCard(),
          ),

          const SizedBox(height: 22),
          const _SectionTitle(title: 'Why Choose Relstone?', subtitle: ''),
          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: const [
                _WhyChooseCard(title: 'Competitive Pricing', subtitle: 'Best value for quality education'),
                SizedBox(height: 12),
                _WhyChooseCard(title: 'California Specific', subtitle: 'Tailored to CA real estate laws'),
                SizedBox(height: 12),
                _WhyChooseCard(title: 'DRE Approved', subtitle: 'Fully accredited courses'),
                SizedBox(height: 12),
                _WhyChooseCard(title: 'Online & Books', subtitle: 'Learn your way, anytime'),
              ],
            ),
          ),

          const SizedBox(height: 22),
          const _SectionTitle(title: 'Student Testimonials', subtitle: ''),
          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: const [
                _TestimonialCard(
                  quote: 'I liked the ease of the course and having all the required information at your fingertips anytime.',
                  name: 'John N.',
                  role: 'Future DRE Sales Agent',
                  linkText: 'on Sales Agent Licensing Package',
                ),
                SizedBox(height: 12),
                _TestimonialCard(
                  quote: 'You guys have the best course. Not only did I enjoy reading through material but I also passed the big test the very first time!',
                  name: 'Sarah M.',
                  role: 'DRE Broker',
                  linkText: 'on Broker Licensing Package',
                ),
                SizedBox(height: 12),
                _TestimonialCard(
                  quote: 'I liked the videos, for me it was a better way of studying and picked up on things I either forgot or did not know.',
                  name: 'Brian G.',
                  role: 'Real Estate Professional',
                  linkText: 'on 45-Hour CE Package',
                ),
              ],
            ),
          ),

          const SizedBox(height: 26),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const _FooterSection(),
          ),
          const SizedBox(height: 18),
        ],
      ),
    );
  }
}

/* ─── SIDEBAR ──────────────────────────────────────────────────────── */
class _AppSidebar extends StatelessWidget {
  final VoidCallback onLogout;
  const _AppSidebar({required this.onLogout});

  static const Color navBg = Color(0xFF0B1A2A);

  void _go(BuildContext context, String route) async {
    Navigator.pop(context);

    // Retrieve stored user data
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userStr = prefs.getString('user');

    Map<String, dynamic>? user;
    if (userStr != null) {
      try {
        user = jsonDecode(userStr);
      } catch (e) {
        print('Error decoding user: $e');
      }
    }

    // Navigate with arguments if user data exists
    if (user != null && token != null) {
      Navigator.pushNamed(
        context,
        route,
        arguments: {
          'user': user,
          'token': token,
        },
      );
    } else {
      Navigator.pushNamed(context, route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: navBg,
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 12),
              child: Image.asset(
                'assets/relstone_logo.png',
                height: 26,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Text('RELSTONE',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.4)),
              ),
            ),
            const Divider(color: Colors.white12, height: 1),

            // ✅ States with dropdown panel
            _NavExpansion(
              title: 'States',
              initiallyExpanded: true,
              children: [
                _StatesDropdownPanel(
                  onSelectState: (slug) {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/insurance-state', arguments: slug);
                  },
                ),
              ],
            ),

            _NavExpansion(title: 'California Real Estate', children: [
              _NavItem(title: 'Sales License',       onTap: () => _go(context, '/sales')),
              _NavItem(title: 'Broker License',      onTap: () => _go(context, '/broker')),
              _NavItem(title: '45 Hour DRE Renewal', onTap: () => _go(context, '/dre-ce')),
            ]),
            _NavItem(title: 'Exam Prep',   onTap: () => _go(context, '/exam-prep')),
            _NavExpansion(title: 'Insurance CE', children: [
              _NavItem(title: 'Select a State', onTap: () => _go(context, '/insurance-state')),
              _NavItem(title: 'Courses',        onTap: () => _go(context, '/insurance-courses')),
            ]),
            _NavItem(title: 'CFP Renewal', onTap: () => _go(context, '/cfp-renewal')),
            _NavItem(title: 'About Us',    onTap: () => _go(context, '/about')),
            _NavItem(title: 'Contact Us',  onTap: () => _go(context, '/contact')),

            const SizedBox(height: 10),
            const Divider(color: Colors.white12, height: 1),
            _NavItem(
              title: 'Log out',
              color: Colors.redAccent,
              onTap: () {
                Navigator.pop(context);
                onLogout();
              },
            ),
            const SizedBox(height: 10),
            const Divider(color: Colors.white12, height: 1),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 18),
              child: Text('© 2026 Relstone. All rights reserved.',
                  style: TextStyle(color: Colors.white70, fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }
}

/* ─── NAV ITEM ─────────────────────────────────────────────────────── */
class _NavItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final Color? color;
  const _NavItem({required this.title, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      title: Text(title,
          style: TextStyle(color: color ?? Colors.white, fontWeight: FontWeight.w600)),
      onTap: onTap,
    );
  }
}

/* ─── NAV EXPANSION ────────────────────────────────────────────────── */
class _NavExpansion extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final bool initiallyExpanded;

  const _NavExpansion({
    required this.title,
    required this.children,
    this.initiallyExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: ExpansionTile(
        initiallyExpanded: initiallyExpanded,
        maintainState: true,
        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
        childrenPadding: const EdgeInsets.only(left: 10, bottom: 8),
        collapsedIconColor: Colors.white70,
        iconColor: Colors.white70,
        title: Text(title,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        children: children,
      ),
    );
  }
}

/* ─── STATES DROPDOWN PANEL ────────────────────────────────────────── */
class _StatesDropdownPanel extends StatefulWidget {
  final ValueChanged<String>? onSelectState;
  const _StatesDropdownPanel({this.onSelectState});

  @override
  State<_StatesDropdownPanel> createState() => _StatesDropdownPanelState();
}

class _StatesDropdownPanelState extends State<_StatesDropdownPanel> {
  List<_StateOption> _states = [];

  @override
  void initState() {
    super.initState();
    _fetchStatesInBackground();
  }

  Future<void> _fetchStatesInBackground() async {
    try {
      final result = await ApiClient.get(ApiConfig.insuranceStates);
      final int status = result['statusCode'] as int;
      final Map<String, dynamic> data = result['data'] as Map<String, dynamic>;

      if (status >= 200 && status < 300) {
        final statesList = data['data'];
        if (statesList is List && statesList.isNotEmpty) {
          final fetched = statesList
              .map((e) => _StateOption.fromJson(e as Map<String, dynamic>))
              .where((s) => s.name.isNotEmpty && s.slug.isNotEmpty)
              .toList();
          if (fetched.isNotEmpty && mounted) {
            setState(() => _states = fetched);
          }
        }
      }
    } catch (_) {
      // keep empty list if API fails
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(8, 6, 8, 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF16253A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'SELECT A STATE',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 12,
              letterSpacing: 1.5,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          if (_states.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(color: Colors.white38, strokeWidth: 2),
                ),
              ),
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                final count = constraints.maxWidth >= 560 ? 3 : constraints.maxWidth >= 360 ? 2 : 1;
                return GridView.builder(
                  itemCount: _states.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: count,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: count == 1 ? 4.4 : 2.8,
                  ),
                  itemBuilder: (context, index) {
                    final state = _states[index];
                    return _StateTile(
                      title: state.name,
                      onTap: () => widget.onSelectState?.call(state.slug),
                    );
                  },
                );
              },
            ),
        ],
      ),
    );
  }
}

class _StateTile extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  const _StateTile({required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF2B3648),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFFE2E6EC),
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StateOption {
  final String name;
  final String slug;
  const _StateOption({required this.name, required this.slug});

  factory _StateOption.fromJson(Map<String, dynamic> json) {
    return _StateOption(
      name: (json['name'] ?? '').toString(),
      slug: (json['slug'] ?? '').toString(),
    );
  }
}

/* ─── HERO ─────────────────────────────────────────────────────────── */
class _HeroSection extends StatelessWidget {
  final VoidCallback onSalesLicense;
  final VoidCallback onBrokerLicense;
  const _HeroSection({required this.onSalesLicense, required this.onBrokerLicense});

  static const Color primaryNavy = Color(0xFF1A3A5C);
  static const Color accentBlue  = Color(0xFF2E7EBE);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [primaryNavy.withOpacity(0.95), accentBlue.withOpacity(0.85)],
        ),
        boxShadow: [
          BoxShadow(color: primaryNavy.withOpacity(0.12), blurRadius: 30, offset: const Offset(0, 10)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Welcome to Relstone!',
                style: TextStyle(color: Colors.white70, fontSize: 12.5, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            const Text('Providing Education Online,\nA Simple Way!',
                style: TextStyle(color: Colors.white, fontSize: 24, height: 1.15, fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            Text(
              'With real estate education tailored to your needs and goals, you can advance your career.',
              style: TextStyle(color: Colors.white.withOpacity(0.88), fontSize: 13.5, height: 1.45),
            ),
            const SizedBox(height: 14),
            const Text(
              'DRE CE Sponsor ID #1035 • DRE Pre-License Sponsor #S0199',
              style: TextStyle(color: Colors.white70, fontSize: 11.5, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: onSalesLicense,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: primaryNavy,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Sales License', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: onBrokerLicense,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: BorderSide(color: Colors.white.withOpacity(0.7)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Broker License', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/* ─── SECTION TITLE ────────────────────────────────────────────────── */
class _SectionTitle extends StatelessWidget {
  final String? eyebrow;
  final String title;
  final String subtitle;
  const _SectionTitle({this.eyebrow, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          if (eyebrow != null && eyebrow!.isNotEmpty) ...[
            Text(eyebrow!,
                style: const TextStyle(fontSize: 11, letterSpacing: 1.8, fontWeight: FontWeight.w700, color: Color(0xFF6B7E92))),
            const SizedBox(height: 10),
          ],
          Text(title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1C2B3A), height: 1.15)),
          if (subtitle.trim().isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13.5, color: Color(0xFF6B7E92), height: 1.45)),
          ],
        ],
      ),
    );
  }
}

/* ─── SERVICE CARD ─────────────────────────────────────────────────── */
class _ServiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String cta;
  const _ServiceCard({required this.icon, required this.title, required this.subtitle, required this.cta});

  static const Color primaryNavy = Color(0xFF1A3A5C);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: primaryNavy.withOpacity(0.06), blurRadius: 18, offset: const Offset(0, 8))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(color: primaryNavy.withOpacity(0.08), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: primaryNavy),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.w800, color: primaryNavy)),
                  const SizedBox(height: 6),
                  Text(subtitle, style: const TextStyle(fontSize: 13, color: Color(0xFF6B7E92), height: 1.35)),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryNavy,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(cta, style: const TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ─── GUARANTEE ────────────────────────────────────────────────────── */
class _GuaranteeCard extends StatelessWidget {
  const _GuaranteeCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEFFAF2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF52D07D), width: 1.2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: const Color(0xFF16A34A), borderRadius: BorderRadius.circular(18)),
              child: const Icon(Icons.check_rounded, color: Colors.white),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Our 100% Money-back Guarantee',
                      style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w900, color: Color(0xFF1C2B3A))),
                  SizedBox(height: 8),
                  Text(
                    "Your enrollment poses no risk. If you're dissatisfied at any time during your one-year enrollment, call us for a full refund — no questions asked.",
                    style: TextStyle(fontSize: 13, color: Color(0xFF6B7E92), height: 1.45),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ─── WHY CHOOSE ───────────────────────────────────────────────────── */
class _WhyChooseCard extends StatelessWidget {
  final String title;
  final String subtitle;
  const _WhyChooseCard({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: const Color(0xFF1A3A5C).withOpacity(0.06), blurRadius: 18, offset: const Offset(0, 8))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(color: const Color(0xFF16A34A), borderRadius: BorderRadius.circular(17)),
              child: const Icon(Icons.check_rounded, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Color(0xFF1A3A5C))),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(fontSize: 13, color: Color(0xFF6B7E92))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ─── TESTIMONIAL ──────────────────────────────────────────────────── */
class _TestimonialCard extends StatelessWidget {
  final String quote;
  final String name;
  final String role;
  final String linkText;
  const _TestimonialCard({required this.quote, required this.name, required this.role, required this.linkText});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: const Color(0xFF1A3A5C).withOpacity(0.06), blurRadius: 18, offset: const Offset(0, 8))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: List.generate(5, (_) => const Icon(Icons.star_rounded, size: 18, color: Color(0xFFF5B301)))),
            const SizedBox(height: 10),
            Text('"$quote"',
                style: const TextStyle(fontSize: 13.5, color: Color(0xFF1A3A5C), height: 1.45, fontStyle: FontStyle.italic)),
            const SizedBox(height: 14),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Text(name, style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w900, color: Color(0xFF1A3A5C))),
            const SizedBox(height: 4),
            Text(role, style: const TextStyle(fontSize: 12.5, color: Color(0xFF6B7E92))),
            const SizedBox(height: 8),
            Text(linkText, style: const TextStyle(fontSize: 12.5, color: Color(0xFF2E7EBE), fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}

/* ─── FOOTER ───────────────────────────────────────────────────────── */
class _FooterSection extends StatelessWidget {
  const _FooterSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF0B1A2A), borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.home_work_rounded, color: Colors.white),
              SizedBox(width: 10),
              Text('RELSTONE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Providing quality education for California Real Estate and Insurance professionals.',
            style: TextStyle(color: Colors.white70, height: 1.45, fontSize: 13),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _SocialIcon(icon: FontAwesomeIcons.facebook,  color: const Color(0xFF1877F2), label: 'Facebook',  url: 'https://www.facebook.com/RelstoneSD'),
              const SizedBox(width: 10),
              _SocialIcon(icon: FontAwesomeIcons.linkedin,  color: const Color(0xFF0A66C2), label: 'LinkedIn',  url: 'https://www.linkedin.com/company/relstone/posts/?feedView=all'),
              const SizedBox(width: 10),
              _SocialIcon(icon: FontAwesomeIcons.xTwitter,  color: const Color(0xFFE7E7E7), label: 'X / Twitter', url: 'https://twitter.com/relstone'),
              const SizedBox(width: 10),
              _SocialIcon(icon: FontAwesomeIcons.tiktok,    color: const Color(0xFFEE1D52), label: 'TikTok',    url: 'https://tiktok.com/@relstone'),
              const SizedBox(width: 10),
              _SocialIcon(icon: FontAwesomeIcons.instagram, color: const Color(0xFFE1306C), label: 'Instagram', url: 'https://instagram.com/relstone'),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(color: Colors.white12),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _FooterChip('Contact Us',     () => Navigator.pushNamed(context, '/contact')),
              _FooterChip('Privacy Policy', () {}),
              _FooterChip('Refund Policy',  () {}),
              _FooterChip('Terms of Use',   () {}),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(color: Colors.white12),
          const SizedBox(height: 10),
          const Text('© 2026 Relstone. All rights reserved.',
              style: TextStyle(color: Color(0xFF6B7E92), fontSize: 12)),
        ],
      ),
    );
  }
}

/* ─── SOCIAL ICON ──────────────────────────────────────────────────── */
class _SocialIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String url;
  const _SocialIcon({required this.icon, required this.color, required this.label, required this.url});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      child: InkWell(
        onTap: () async {
          final uri = Uri.parse(url);
          try {
            await launchUrl(uri, mode: LaunchMode.externalNonBrowserApplication);
          } catch (_) {
            await launchUrl(uri, mode: LaunchMode.platformDefault);
          }
        },
        borderRadius: BorderRadius.circular(999),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            border: Border.all(color: color.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Center(child: FaIcon(icon, color: color, size: 17)),
        ),
      ),
    );
  }
}

/* ─── FOOTER CHIP ──────────────────────────────────────────────────── */
class _FooterChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _FooterChip(this.label, this.onTap);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(border: Border.all(color: Colors.white24), borderRadius: BorderRadius.circular(999)),
        child: Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12.5, fontWeight: FontWeight.w600)),
      ),
    );
  }
}