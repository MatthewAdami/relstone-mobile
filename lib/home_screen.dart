import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
<<<<<<< HEAD
import 'package:url_launcher/url_launcher.dart';
import 'profile_screen.dart';
=======
import 'package:relstone_mobile/sales_license_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'profile_screen.dart';
import 'all_products_screen.dart';
import 'my_courses_screen.dart'; // ✅ ADD THIS IMPORT
>>>>>>> test-dev
import '../config/api_config.dart';
import '../services/api_client.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Brand colors
  static const Color primaryNavy = Color(0xFF1A3A5C);
  static const Color accentBlue  = Color(0xFF2E7EBE);
  static const Color textDark    = Color(0xFF1C2B3A);
  static const Color textMuted   = Color(0xFF6B7E92);
  static const Color bg          = Color(0xFFF4F6F9);

<<<<<<< HEAD
  // ── Loaded from route arguments ───────────────────────────
  Map<String, dynamic>? _user;
  String? _token;

=======
  Map<String, dynamic>? _user;
  String? _token;

  final TextEditingController _searchController = TextEditingController();

>>>>>>> test-dev
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map<String, dynamic>) {
      _user  = args['user']  as Map<String, dynamic>?;
      _token = args['token'] as String?;
    }
  }

<<<<<<< HEAD
  // ── Helpers ───────────────────────────────────────────────
  String get _userName  => _user?['name']  ?? _user?['email'] ?? 'User';
  String get _userEmail => _user?['email'] ?? '';
  String get _studentId =>
      (_user?['studentId'] ??
       _user?['_id']       ??
       _user?['id']        ??
       '').toString();
=======
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String get _userName  => _user?['name']  ?? _user?['email'] ?? 'User';
  String get _userEmail => _user?['email'] ?? '';
  String get _studentId =>
      (_user?['studentId'] ?? _user?['_id'] ?? _user?['id'] ?? '').toString();
>>>>>>> test-dev

  String get _initials {
    final name = _userName.trim();
    if (name.isEmpty) return 'U';
    final parts = name.split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name[0].toUpperCase();
  }

<<<<<<< HEAD
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
=======
  void _logout() {
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  void _goToAllProducts({String query = ''}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AllProductsScreen(initialSearch: query)),
    );
    _searchController.clear();
  }

  // ── Profile bottom sheet ──────────────────────────────────
  void _showProfileSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ProfileSheet(
        user: _user ?? {},
        token: _token ?? '',
        studentId: _studentId,
        onLogout: _logout,
      ),
    );
  }
>>>>>>> test-dev

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
<<<<<<< HEAD
            style: TextStyle(
              color: primaryNavy,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
=======
            style: TextStyle(color: primaryNavy, fontWeight: FontWeight.w800, letterSpacing: 1.2),
>>>>>>> test-dev
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Cart',
            onPressed: () => Navigator.pushNamed(context, '/cart'),
            icon: const Icon(Icons.shopping_cart_outlined, color: primaryNavy),
          ),
<<<<<<< HEAD
          Padding(
            padding: const EdgeInsets.only(right: 12, left: 4),
            child: GestureDetector(
              onTap: _goToProfile,
=======
          // ── Profile avatar — now opens bottom sheet ───────
          Padding(
            padding: const EdgeInsets.only(right: 12, left: 4),
            child: GestureDetector(
              onTap: _showProfileSheet, // ← changed from _goToProfile
>>>>>>> test-dev
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
<<<<<<< HEAD
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
=======
          // ── SEARCH BAR ────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(color: primaryNavy.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 4)),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onSubmitted: (v) => _goToAllProducts(query: v.trim()),
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Search courses, packages, states...',
                  hintStyle: const TextStyle(color: textMuted, fontSize: 14),
                  prefixIcon: const Icon(Icons.search_rounded, color: textMuted, size: 22),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => _goToAllProducts(query: _searchController.text.trim()),
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(color: primaryNavy, borderRadius: BorderRadius.circular(8)),
                        child: const Text('Browse All',
                            style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.grey.shade200)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: accentBlue, width: 1.5)),
                ),
              ),
            ),
          ),

          // ── Quick Tags ────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                _QuickTag(label: '🗺️ All States', onTap: () => _goToAllProducts()),
                _QuickTag(label: '📦 Packages',   onTap: () => _goToAllProducts(query: 'package')),
                _QuickTag(label: '⚖️ Ethics',      onTap: () => _goToAllProducts(query: 'Ethics')),
                _QuickTag(label: '📘 General',     onTap: () => _goToAllProducts(query: 'General')),
              ],
            ),
          ),

          _HeroSection(
                      onSalesLicense: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SalesLicenseScreen()),
                        );
                      },
                      onBrokerLicense: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (_) => const BrokerLicenseScreen()),
                        // );
                      },
                ),
>>>>>>> test-dev
          const SizedBox(height: 18),

          const _SectionTitle(
            eyebrow: 'OUR SERVICES',
            title: 'To get started, choose one of the selections below',
<<<<<<< HEAD
            subtitle:
                'California-specific real estate and insurance education tailored to your needs and goals.',
=======
            subtitle: 'California-specific real estate and insurance education tailored to your needs and goals.',
>>>>>>> test-dev
          ),
          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: const [
<<<<<<< HEAD
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
=======
                _ServiceCard(icon: Icons.schedule_rounded,          title: '45 Hour DRE Renewal CE',   subtitle: 'Complete your continuing education to renew your license', cta: 'Get Started'),
                SizedBox(height: 12),
                _ServiceCard(icon: Icons.school_rounded,            title: 'Become an Agent',           subtitle: 'Get your California Real Estate Sales License',            cta: 'Get Started'),
                SizedBox(height: 12),
                _ServiceCard(icon: Icons.workspace_premium_rounded, title: 'Become a Broker',           subtitle: 'Advance your career with a Broker License',               cta: 'Get Started'),
                SizedBox(height: 12),
                _ServiceCard(icon: Icons.menu_book_rounded,         title: 'Sales Agent Exam Prep',     subtitle: 'Prepare for your state exam with confidence',             cta: 'Get Started'),
                SizedBox(height: 12),
                _ServiceCard(icon: Icons.local_offer_rounded,       title: 'Insurance CE',              subtitle: 'Renew your insurance license in multiple states',         cta: 'Select a State'),
>>>>>>> test-dev
              ],
            ),
          ),

          const SizedBox(height: 22),
<<<<<<< HEAD
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _GuaranteeCard(),
          ),
=======
          Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: _GuaranteeCard()),
>>>>>>> test-dev

          const SizedBox(height: 22),
          const _SectionTitle(title: 'Why Choose Relstone?', subtitle: ''),
          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: const [
                _WhyChooseCard(title: 'Competitive Pricing', subtitle: 'Best value for quality education'),
                SizedBox(height: 12),
<<<<<<< HEAD
                _WhyChooseCard(title: 'California Specific', subtitle: 'Tailored to CA real estate laws'),
                SizedBox(height: 12),
                _WhyChooseCard(title: 'DRE Approved', subtitle: 'Fully accredited courses'),
                SizedBox(height: 12),
                _WhyChooseCard(title: 'Online & Books', subtitle: 'Learn your way, anytime'),
=======
                _WhyChooseCard(title: 'California Specific',  subtitle: 'Tailored to CA real estate laws'),
                SizedBox(height: 12),
                _WhyChooseCard(title: 'DRE Approved',         subtitle: 'Fully accredited courses'),
                SizedBox(height: 12),
                _WhyChooseCard(title: 'Online & Books',       subtitle: 'Learn your way, anytime'),
>>>>>>> test-dev
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
<<<<<<< HEAD
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
=======
                _TestimonialCard(quote: 'I liked the ease of the course and having all the required information at your fingertips anytime.', name: 'John N.', role: 'Future DRE Sales Agent', linkText: 'on Sales Agent Licensing Package'),
                SizedBox(height: 12),
                _TestimonialCard(quote: 'You guys have the best course. Not only did I enjoy reading through material but I also passed the big test the very first time!', name: 'Sarah M.', role: 'DRE Broker', linkText: 'on Broker Licensing Package'),
                SizedBox(height: 12),
                _TestimonialCard(quote: 'I liked the videos, for me it was a better way of studying and picked up on things I either forgot or did not know.', name: 'Brian G.', role: 'Real Estate Professional', linkText: 'on 45-Hour CE Package'),
>>>>>>> test-dev
              ],
            ),
          ),

          const SizedBox(height: 26),
<<<<<<< HEAD
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const _FooterSection(),
          ),
=======
          Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: const _FooterSection()),
>>>>>>> test-dev
          const SizedBox(height: 18),
        ],
      ),
    );
  }
}

<<<<<<< HEAD
=======
// ══════════════════════════════════════════════════════════════
//  PROFILE BOTTOM SHEET
// ══════════════════════════════════════════════════════════════
class _ProfileSheet extends StatelessWidget {
  final Map<String, dynamic> user;
  final String token;
  final String studentId;
  final VoidCallback onLogout;

  const _ProfileSheet({
    required this.user,
    required this.token,
    required this.studentId,
    required this.onLogout,
  });

  static const Color _navy     = Color(0xFF1A3A5C);
  static const Color _navyDark = Color(0xFF0B1A2A);
  static const Color _blue     = Color(0xFF2563EB);
  static const Color _green    = Color(0xFF16A34A);
  static const Color _red      = Color(0xFFDC2626);
  static const Color _muted    = Color(0xFF6B7280);
  static const Color _bg       = Color(0xFFF4F6F9);
  static const Color _border   = Color(0xFFE5E7EB);

  String get _name  => (user['name']  ?? 'User').toString();
  String get _email => (user['email'] ?? '').toString();

  String get _initials {
    final parts = _name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return _name.isNotEmpty ? _name[0].toUpperCase() : 'U';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Drag handle ──────────────────────────────────
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40, height: 4,
              decoration: BoxDecoration(color: _border, borderRadius: BorderRadius.circular(99)),
            ),
          ),

          // ── User hero ────────────────────────────────────
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [_navyDark, _navy, Color(0xFF1A4A6C)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                // Avatar
                Container(
                  width: 58, height: 58,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(0.4), width: 2),
                  ),
                  child: Center(
                    child: Text(_initials,
                        style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(width: 14),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_name,
                          style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700),
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 3),
                      Text(_email,
                          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12),
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                      if (studentId.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white.withOpacity(0.25)),
                          ),
                          child: Text('ID: $studentId',
                              style: const TextStyle(color: Colors.white, fontSize: 10,
                                  fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // ── Menu items ───────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                // My Courses
                _menuTile(
                  context,
                  icon: Icons.school_rounded,
                  iconBg: const Color(0xFFEFF6FF),
                  iconColor: _blue,
                  title: 'My Courses',
                  subtitle: 'View enrolled courses & take exams',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(
                        builder: (_) => const MyCoursesScreen()));
                  },
                ),
                const SizedBox(height: 8),
                // My Profile
                _menuTile(
                  context,
                  icon: Icons.person_rounded,
                  iconBg: const Color(0xFFF0FDF4),
                  iconColor: _green,
                  title: 'My Profile',
                  subtitle: 'Personal info, license & order history',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(
                        builder: (_) => ProfileScreen(
                          studentId: studentId,
                          token: token,
                          user: user,
                        )));
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),
          const Divider(height: 1, indent: 16, endIndent: 16),
          const SizedBox(height: 4),

          // ── Sign out ─────────────────────────────────────
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            leading: Container(
              width: 42, height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.logout_rounded, color: _red, size: 20),
            ),
            title: const Text('Sign Out',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _red)),
            subtitle: const Text('Log out of your account',
                style: TextStyle(fontSize: 12, color: _muted)),
            trailing: const Icon(Icons.chevron_right_rounded, color: _muted, size: 20),
            onTap: () async {
              Navigator.pop(context);
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              if (context.mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
              }
            },
          ),

          SizedBox(height: MediaQuery.of(context).padding.bottom + 12),
        ],
      ),
    );
  }

  Widget _menuTile(
    BuildContext context, {
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: const Color(0xFFF4F6F9),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          child: Row(
            children: [
              Container(
                width: 42, height: 42,
                decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF111827))),
                    const SizedBox(height: 2),
                    Text(subtitle,
                        style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Color(0xFF6B7280), size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Quick Tag ─────────────────────────────────────────────────────────
class _QuickTag extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _QuickTag({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF2E7EBE).withOpacity(0.4)),
        ),
        child: Text(label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF1A3A5C), fontWeight: FontWeight.w600)),
      ),
    );
  }
}

>>>>>>> test-dev
/* ─── SIDEBAR ──────────────────────────────────────────────────────── */
class _AppSidebar extends StatelessWidget {
  final VoidCallback onLogout;
  const _AppSidebar({required this.onLogout});

  static const Color navBg = Color(0xFF0B1A2A);

<<<<<<< HEAD
  void _go(BuildContext context, String route) {
    Navigator.pop(context);
    Navigator.pushNamed(context, route);
=======
  void _go(BuildContext context, String route) async {
    Navigator.pop(context);
    final prefs   = await SharedPreferences.getInstance();
    final token   = prefs.getString('token');
    final userStr = prefs.getString('user');
    Map<String, dynamic>? user;
    if (userStr != null) {
      try { user = jsonDecode(userStr); } catch (e) { print('Error decoding user: $e'); }
    }
    if (user != null && token != null) {
      Navigator.pushNamed(context, route, arguments: {'user': user, 'token': token});
    } else {
      Navigator.pushNamed(context, route);
    }
>>>>>>> test-dev
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
<<<<<<< HEAD
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
=======
              child: Image.asset('assets/relstone_logo.png', height: 26, fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Text('RELSTONE',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 1.4))),
            ),
            const Divider(color: Colors.white12, height: 1),

            _NavExpansion(title: 'States', initiallyExpanded: true, children: [
              _StatesDropdownPanel(
                onSelectState: (slug) {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/insurance-state', arguments: slug);
                },
              ),
            ]),
            _NavExpansion(title: 'California Real Estate', children: [
              _NavItem(title: 'Sales License',       onTap: () => _go(context, '/sales-license')),
              _NavItem(title: 'Broker License',      onTap: () => _go(context, '/broker')),
              _NavItem(title: '45 Hour DRE Renewal', onTap: () => _go(context, '/real-estate-ce')),
            ]),
            _NavItem(title: 'Exam Prep',    onTap: () => _go(context, '/exam-prep')),
            _NavExpansion(title: 'Insurance CE', children: [
              _NavItem(title: 'Select a State', onTap: () => _go(context, '/insurance-state')),
            ]),
            _NavItem(title: 'CFP Renewal',  onTap: () => _go(context, '/cfp-renewal')),
            _NavItem(title: 'About Us',     onTap: () => _go(context, '/about')),
            _NavItem(title: 'Contact Us',   onTap: () => _go(context, '/contact')),
            _NavItem(title: 'All Products', onTap: () => _go(context, '/all-products')),
            _NavItem(title: 'Exam Portal',  onTap: () => _go(context, '/exam-portal')),
            const SizedBox(height: 10),
            const Divider(color: Colors.white12, height: 1),
            _NavItem(title: 'Log out', color: Colors.redAccent, onTap: () { Navigator.pop(context); onLogout(); }),
>>>>>>> test-dev
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

  const _NavExpansion({required this.title, required this.children, this.initiallyExpanded = false});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent, splashColor: Colors.transparent, highlightColor: Colors.transparent),
      child: ExpansionTile(
        initiallyExpanded: initiallyExpanded,
        maintainState: true,
        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
        childrenPadding: const EdgeInsets.only(left: 10, bottom: 8),
        collapsedIconColor: Colors.white70,
        iconColor: Colors.white70,
<<<<<<< HEAD
        title: Text(title,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
=======
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
>>>>>>> test-dev
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
<<<<<<< HEAD
          if (fetched.isNotEmpty && mounted) {
            setState(() => _states = fetched);
          }
        }
      }
    } catch (_) {
      // keep empty list if API fails
    }
=======
          if (fetched.isNotEmpty && mounted) setState(() => _states = fetched);
        }
      }
    } catch (_) {}
>>>>>>> test-dev
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(8, 6, 8, 6),
      padding: const EdgeInsets.all(10),
<<<<<<< HEAD
      decoration: BoxDecoration(
        color: const Color(0xFF16253A),
        borderRadius: BorderRadius.circular(12),
      ),
=======
      decoration: BoxDecoration(color: const Color(0xFF16253A), borderRadius: BorderRadius.circular(12)),
>>>>>>> test-dev
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('SELECT A STATE',
              style: TextStyle(color: Colors.white54, fontSize: 12, letterSpacing: 1.5, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          if (_states.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
<<<<<<< HEAD
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
=======
              child: Center(child: SizedBox(width: 20, height: 20,
                  child: CircularProgressIndicator(color: Colors.white38, strokeWidth: 2))),
            )
          else
            LayoutBuilder(builder: (context, constraints) {
              final count = constraints.maxWidth >= 560 ? 3 : constraints.maxWidth >= 360 ? 2 : 1;
              return GridView.builder(
                itemCount: _states.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: count, crossAxisSpacing: 8, mainAxisSpacing: 8,
                  childAspectRatio: count == 1 ? 4.4 : 2.8,
                ),
                itemBuilder: (context, index) => _StateTile(
                  title: _states[index].name,
                  onTap: () => widget.onSelectState?.call(_states[index].slug),
                ),
              );
            }),
>>>>>>> test-dev
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
            child: Text(title, maxLines: 2, overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFFE2E6EC), fontSize: 13, fontWeight: FontWeight.w700)),
          ),
        ),
      ),
    );
  }
}

class _StateOption {
<<<<<<< HEAD
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

=======
  final String name, slug;
  const _StateOption({required this.name, required this.slug});
  factory _StateOption.fromJson(Map<String, dynamic> json) =>
      _StateOption(name: (json['name'] ?? '').toString(), slug: (json['slug'] ?? '').toString());
}

>>>>>>> test-dev
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
<<<<<<< HEAD
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [primaryNavy.withOpacity(0.95), accentBlue.withOpacity(0.85)],
        ),
        boxShadow: [
          BoxShadow(color: primaryNavy.withOpacity(0.12), blurRadius: 30, offset: const Offset(0, 10)),
        ],
=======
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [primaryNavy.withOpacity(0.95), accentBlue.withOpacity(0.85)]),
        boxShadow: [BoxShadow(color: primaryNavy.withOpacity(0.12), blurRadius: 30, offset: const Offset(0, 10))],
>>>>>>> test-dev
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
<<<<<<< HEAD
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
=======
            Text('With real estate education tailored to your needs and goals, you can advance your career.',
                style: TextStyle(color: Colors.white.withOpacity(0.88), fontSize: 13.5, height: 1.45)),
            const SizedBox(height: 14),
            const Text('DRE CE Sponsor ID #1035 • DRE Pre-License Sponsor #S0199',
                style: TextStyle(color: Colors.white70, fontSize: 11.5, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            Row(children: [
              Expanded(child: ElevatedButton(onPressed: onSalesLicense,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: primaryNavy,
                      elevation: 0, padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: const Text('Sales License', style: TextStyle(fontWeight: FontWeight.w700)))),
              const SizedBox(width: 10),
              Expanded(child: OutlinedButton(onPressed: onBrokerLicense,
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.white,
                      side: BorderSide(color: Colors.white.withOpacity(0.7)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: const Text('Broker License', style: TextStyle(fontWeight: FontWeight.w700)))),
            ]),
>>>>>>> test-dev
          ],
        ),
      ),
    );
  }
}

/* ─── SECTION TITLE ────────────────────────────────────────────────── */
class _SectionTitle extends StatelessWidget {
  final String? eyebrow;
<<<<<<< HEAD
  final String title;
  final String subtitle;
=======
  final String title, subtitle;
>>>>>>> test-dev
  const _SectionTitle({this.eyebrow, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
<<<<<<< HEAD
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
=======
      child: Column(children: [
        if (eyebrow != null && eyebrow!.isNotEmpty) ...[
          Text(eyebrow!, style: const TextStyle(fontSize: 11, letterSpacing: 1.8, fontWeight: FontWeight.w700, color: Color(0xFF6B7E92))),
          const SizedBox(height: 10),
>>>>>>> test-dev
        ],
        Text(title, textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1C2B3A), height: 1.15)),
        if (subtitle.trim().isNotEmpty) ...[
          const SizedBox(height: 10),
          Text(subtitle, textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13.5, color: Color(0xFF6B7E92), height: 1.45)),
        ],
      ]),
    );
  }
}

/* ─── SERVICE CARD ─────────────────────────────────────────────────── */
class _ServiceCard extends StatelessWidget {
  final IconData icon;
<<<<<<< HEAD
  final String title;
  final String subtitle;
  final String cta;
=======
  final String title, subtitle, cta;
>>>>>>> test-dev
  const _ServiceCard({required this.icon, required this.title, required this.subtitle, required this.cta});

  static const Color primaryNavy = Color(0xFF1A3A5C);

  @override
  Widget build(BuildContext context) {
    return Container(
<<<<<<< HEAD
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
=======
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: primaryNavy.withOpacity(0.06), blurRadius: 18, offset: const Offset(0, 8))]),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(width: 44, height: 44,
              decoration: BoxDecoration(color: primaryNavy.withOpacity(0.08), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: primaryNavy)),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.w800, color: primaryNavy)),
            const SizedBox(height: 6),
            Text(subtitle, style: const TextStyle(fontSize: 13, color: Color(0xFF6B7E92), height: 1.35)),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: primaryNavy, foregroundColor: Colors.white,
                    elevation: 0, padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: Text(cta, style: const TextStyle(fontWeight: FontWeight.w700))),
          ])),
        ]),
>>>>>>> test-dev
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
      decoration: BoxDecoration(color: const Color(0xFFEFFAF2), borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF52D07D), width: 1.2)),
      child: Padding(
        padding: const EdgeInsets.all(16),
<<<<<<< HEAD
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
=======
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(width: 36, height: 36,
              decoration: BoxDecoration(color: const Color(0xFF16A34A), borderRadius: BorderRadius.circular(18)),
              child: const Icon(Icons.check_rounded, color: Colors.white)),
          const SizedBox(width: 12),
          const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Our 100% Money-back Guarantee',
                style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w900, color: Color(0xFF1C2B3A))),
            SizedBox(height: 8),
            Text("Your enrollment poses no risk. If you're dissatisfied at any time during your one-year enrollment, call us for a full refund — no questions asked.",
                style: TextStyle(fontSize: 13, color: Color(0xFF6B7E92), height: 1.45)),
          ])),
        ]),
>>>>>>> test-dev
      ),
    );
  }
}

/* ─── WHY CHOOSE ───────────────────────────────────────────────────── */
class _WhyChooseCard extends StatelessWidget {
<<<<<<< HEAD
  final String title;
  final String subtitle;
=======
  final String title, subtitle;
>>>>>>> test-dev
  const _WhyChooseCard({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
<<<<<<< HEAD
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
=======
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: const Color(0xFF1A3A5C).withOpacity(0.06), blurRadius: 18, offset: const Offset(0, 8))]),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(children: [
          Container(width: 34, height: 34,
              decoration: BoxDecoration(color: const Color(0xFF16A34A), borderRadius: BorderRadius.circular(17)),
              child: const Icon(Icons.check_rounded, color: Colors.white)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Color(0xFF1A3A5C))),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(fontSize: 13, color: Color(0xFF6B7E92))),
          ])),
        ]),
>>>>>>> test-dev
      ),
    );
  }
}

<<<<<<< HEAD
=======
/* ─── TESTIMONIAL ──────────────────────────────────────────────────── */
class _TestimonialCard extends StatelessWidget {
  final String quote, name, role, linkText;
  const _TestimonialCard({required this.quote, required this.name, required this.role, required this.linkText});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: const Color(0xFF1A3A5C).withOpacity(0.06), blurRadius: 18, offset: const Offset(0, 8))]),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: List.generate(5, (_) => const Icon(Icons.star_rounded, size: 18, color: Color(0xFFF5B301)))),
          const SizedBox(height: 10),
          Text('"$quote"', style: const TextStyle(fontSize: 13.5, color: Color(0xFF1A3A5C), height: 1.45, fontStyle: FontStyle.italic)),
          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Text(name, style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w900, color: Color(0xFF1A3A5C))),
          const SizedBox(height: 4),
          Text(role, style: const TextStyle(fontSize: 12.5, color: Color(0xFF6B7E92))),
          const SizedBox(height: 8),
          Text(linkText, style: const TextStyle(fontSize: 12.5, color: Color(0xFF2E7EBE), fontWeight: FontWeight.w700)),
        ]),
      ),
    );
  }
}

>>>>>>> test-dev
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
<<<<<<< HEAD
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
=======
          const Row(children: [
            Icon(Icons.home_work_rounded, color: Colors.white), SizedBox(width: 10),
            Text('RELSTONE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
          ]),
          const SizedBox(height: 10),
          const Text('Providing quality education for California Real Estate and Insurance professionals.',
              style: TextStyle(color: Colors.white70, height: 1.45, fontSize: 13)),
          const SizedBox(height: 14),
          Row(children: [
            _SocialIcon(icon: FontAwesomeIcons.facebook,  color: const Color(0xFF1877F2), label: 'Facebook',    url: 'https://www.facebook.com/RelstoneSD'),
            const SizedBox(width: 10),
            _SocialIcon(icon: FontAwesomeIcons.linkedin,  color: const Color(0xFF0A66C2), label: 'LinkedIn',    url: 'https://www.linkedin.com/company/relstone/posts/?feedView=all'),
            const SizedBox(width: 10),
            _SocialIcon(icon: FontAwesomeIcons.xTwitter,  color: const Color(0xFFE7E7E7), label: 'X / Twitter', url: 'https://twitter.com/relstone'),
            const SizedBox(width: 10),
            _SocialIcon(icon: FontAwesomeIcons.tiktok,    color: const Color(0xFFEE1D52), label: 'TikTok',      url: 'https://tiktok.com/@relstone'),
            const SizedBox(width: 10),
            _SocialIcon(icon: FontAwesomeIcons.instagram, color: const Color(0xFFE1306C), label: 'Instagram',   url: 'https://instagram.com/relstone'),
          ]),
          const SizedBox(height: 14),
          const Divider(color: Colors.white12),
          const SizedBox(height: 10),
          Wrap(spacing: 10, runSpacing: 10, children: [
            _FooterChip('Contact Us',     () => Navigator.pushNamed(context, '/contact')),
            _FooterChip('Privacy Policy', () {}),
            _FooterChip('Refund Policy',  () {}),
            _FooterChip('Terms of Use',   () {}),
          ]),
>>>>>>> test-dev
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
<<<<<<< HEAD
  final String label;
  final String url;
=======
  final String label, url;
>>>>>>> test-dev
  const _SocialIcon({required this.icon, required this.color, required this.label, required this.url});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      child: InkWell(
        onTap: () async {
          final uri = Uri.parse(url);
<<<<<<< HEAD
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
=======
          try { await launchUrl(uri, mode: LaunchMode.externalNonBrowserApplication); }
          catch (_) { await launchUrl(uri, mode: LaunchMode.platformDefault); }
        },
        borderRadius: BorderRadius.circular(999),
        child: Container(
          width: 40, height: 40,
          decoration: BoxDecoration(color: color.withOpacity(0.15),
              border: Border.all(color: color.withOpacity(0.5)), borderRadius: BorderRadius.circular(999)),
>>>>>>> test-dev
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