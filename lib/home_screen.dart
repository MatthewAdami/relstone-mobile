import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'profile_screen.dart';
import 'all_products_screen.dart'; // ✅ ADD THIS
import '../config/api_config.dart';
import '../services/api_client.dart';
import 'sales_license_screen.dart';
import 'real_estate_ce_screen.dart';
=======
import 'package:relstone_mobile/refund_policy_screen.dart';
>>>>>>> 8902ad4c03a57d9bf40cf41846bba8cfa29b0909

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

<<<<<<< HEAD
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

  // ── Loaded from route arguments ───────────────────────────
  Map<String, dynamic>? _user;
  String? _token;

  // ── Search ────────────────────────────────────────────────
  final TextEditingController _searchController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map<String, dynamic>) {
      _user  = args['user']  as Map<String, dynamic>?;
      _token = args['token'] as String?;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
=======
  // Brand colors
  static const Color primaryNavy = Color(0xFF1A3A5C);
  static const Color accentBlue = Color(0xFF2E7EBE);
  static const Color textDark = Color(0xFF1C2B3A);
  static const Color textMuted = Color(0xFF6B7E92);
  static const Color bg = Color(0xFFF4F6F9);
>>>>>>> 8902ad4c03a57d9bf40cf41846bba8cfa29b0909

  // ── Navigate to All Products with optional search query ───
  void _goToAllProducts({String query = ''}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AllProductsScreen(initialSearch: query),
      ),
    );
    _searchController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,

      // ✅ Sidebar / Drawer
      drawer: const _AppSidebar(),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        titleSpacing: 16,
        title: Row(
          children: [
            Image.asset(
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
          ],
        ),

        // ✅ Shopping cart (replaces Log In / Sign Up)
        actions: [
          IconButton(
            tooltip: "Cart",
            onPressed: () => Navigator.pushNamed(context, '/cart'),
            icon: const Icon(Icons.shopping_cart_outlined, color: primaryNavy),
          ),
          const SizedBox(width: 6),
        ],
      ),
<<<<<<< HEAD
     body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // ── Welcome banner (hidden) ───────────────────────────
          // Uncomment below to show the welcome banner again
          // if (_user != null)
          //   Container(
          //     margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
          //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          //     decoration: BoxDecoration(
          //       color: accentBlue.withOpacity(0.08),
          //       borderRadius: BorderRadius.circular(12),
          //       border: Border.all(color: accentBlue.withOpacity(0.2)),
          //     ),
          //     child: Row(
          //       children: [
          //         CircleAvatar(
          //           radius: 20,
          //           backgroundColor: primaryNavy,
          //           child: Text(
          //             _initials,
          //             style: const TextStyle(
          //               color: Colors.white,
          //               fontSize: 14,
          //               fontWeight: FontWeight.w700,
          //             ),
          //           ),
          //         ),
          //         const SizedBox(width: 12),
          //         Expanded(
          //           child: Column(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               Text(
          //                 'Welcome back, ${_userName.split(' ').first}!',
          //                 style: const TextStyle(
          //                   fontSize: 14,
          //                   fontWeight: FontWeight.w700,
          //                   color: primaryNavy,
          //                 ),
          //               ),
          //               Text(_userEmail,
          //                   style: const TextStyle(fontSize: 12, color: textMuted)),
          //               Text(
          //                 'ID: ${_user?['studentId'] ?? '—'}',
          //                 style: const TextStyle(fontSize: 12, color: textMuted),
          //               ),
          //               Text(
          //                 _user?['mobilePhone'] ?? '',
          //                 style: const TextStyle(fontSize: 12, color: textMuted),
          //               ),
          //               Text(
          //                 _user?['mailingAddress'] ?? '',
          //                 style: const TextStyle(fontSize: 11, color: textMuted),
          //                 maxLines: 2,
          //                 overflow: TextOverflow.ellipsis,
          //               ),
          //             ],
          //           ),
          //         ),
          //         TextButton(
          //           onPressed: _goToProfile,
          //           style: TextButton.styleFrom(
          //             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          //             backgroundColor: primaryNavy,
          //             shape: RoundedRectangleBorder(
          //                 borderRadius: BorderRadius.circular(8)),
          //           ),
          //           child: const Text(
          //             'Profile',
          //             style: TextStyle(
          //                 color: Colors.white,
          //                 fontSize: 12,
          //                 fontWeight: FontWeight.w600),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),

          // ── SEARCH BAR ────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: primaryNavy.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
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
                        decoration: BoxDecoration(
                          color: primaryNavy,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Browse All',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: accentBlue, width: 1.5),
                  ),
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

          _HeroSection(onSalesLicense: () {}, onBrokerLicense: () {}),
=======

      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          _HeroSection(
            onSalesLicense: () {
              // TODO: route to sales license page
              // Navigator.pushNamed(context, '/sales');
            },
            onBrokerLicense: () {
              // TODO: route to broker license page
              // Navigator.pushNamed(context, '/broker');
            },
          ),
>>>>>>> 8902ad4c03a57d9bf40cf41846bba8cfa29b0909
          const SizedBox(height: 18),

          _SectionTitle(
            eyebrow: "OUR SERVICES",
            title: "To get started, choose one of the selections below",
            subtitle:
                "California-specific real estate and insurance education tailored to your needs and goals.",
          ),
          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: const [
                _ServiceCard(
                  icon: Icons.schedule_rounded,
                  title: "45 Hour DRE Renewal CE",
                  subtitle:
                      "Complete your continuing education to renew your license",
                  cta: "Get Started",
                ),
                SizedBox(height: 12),
                _ServiceCard(
                  icon: Icons.school_rounded,
<<<<<<< HEAD
                  title: 'Become an Agent',
                  subtitle: 'Get your California Real Estate Sales License',
                  cta: 'Get Started',
                  
=======
                  title: "Become an Agent",
                  subtitle: "Get your California Real Estate Sales License",
                  cta: "Get Started",
>>>>>>> 8902ad4c03a57d9bf40cf41846bba8cfa29b0909
                ),
                SizedBox(height: 12),
                _ServiceCard(
                  icon: Icons.workspace_premium_rounded,
                  title: "Become a Broker",
                  subtitle: "Advance your career with a Broker License",
                  cta: "Get Started",
                ),
                SizedBox(height: 12),
                _ServiceCard(
                  icon: Icons.menu_book_rounded,
                  title: "Sales Agent Exam Prep",
                  subtitle: "Prepare for your state exam with confidence",
                  cta: "Get Started",
                ),
                SizedBox(height: 12),
                _ServiceCard(
                  icon: Icons.local_offer_rounded,
                  title: "Insurance CE",
                  subtitle: "Renew your insurance license in multiple states",
                  cta: "Select a State",
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

          const _SectionTitle(
            title: "Why Choose Relstone?",
            subtitle: "",
          ),

          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: const [
                _WhyChooseCard(
                  title: "Competitive Pricing",
                  subtitle: "Best value for quality education",
                ),
                SizedBox(height: 12),
                _WhyChooseCard(
                  title: "California Specific",
                  subtitle: "Tailored to CA real estate laws",
                ),
                SizedBox(height: 12),
                _WhyChooseCard(
                  title: "DRE Approved",
                  subtitle: "Fully accredited courses",
                ),
                SizedBox(height: 12),
                _WhyChooseCard(
                  title: "Online & Books",
                  subtitle: "Learn your way, anytime",
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),

          const _SectionTitle(
            title: "Student Testimonials",
            subtitle: "",
          ),

          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: const [
                _TestimonialCard(
                  quote:
                      "I liked the ease of the course and having all the required information at your fingertips anytime — online and books.",
                  name: "John N.",
                  role: "Future DRE Sales Agent",
                  linkText: "on Sales Agent Licensing Package",
                ),
                SizedBox(height: 12),
                _TestimonialCard(
                  quote:
                      "You guys have the best course. Not only did I enjoy reading through material but I also passed the big test the very first time!",
                  name: "Sarah M.",
                  role: "DRE Broker",
                  linkText: "on Broker Licensing Package",
                ),
                SizedBox(height: 12),
                _TestimonialCard(
                  quote:
                      "I liked the videos, for me it was a better way of studying and picked up on things I either forgot or did not know.",
                  name: "Brian G.",
                  role: "Real Estate Professional",
                  linkText: "on 45-Hour CE Package",
                ),
              ],
            ),
          ),

          const SizedBox(height: 26),

          const _FooterSection(),
          const SizedBox(height: 18),
        ],
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
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF1A3A5C),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

/* ───────────────────────────────────────────────────────────── */
/* SIDEBAR / DRAWER */
/* ───────────────────────────────────────────────────────────── */

class _AppSidebar extends StatelessWidget {
  const _AppSidebar();

  static const Color navBg = Color(0xFF0B1A2A);

  void _go(BuildContext context, String route) {
    Navigator.pop(context); // close drawer
    Navigator.pushNamed(context, route);
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
              child: Row(
                children: [
                  Image.asset(
                    'assets/relstone_logo.png',
                    height: 26,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Text(
                      "RELSTONE",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white12, height: 1),

            _NavExpansion(
              title: "States",
              children: [
                _NavItem(
                  title: "Select a State",
                  onTap: () => _go(context, "/states"),
                ),
              ],
            ),

<<<<<<< HEAD
            _NavExpansion(title: 'California Real Estate', children: [
              _NavItem(
                        title: 'Sales License',
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const SalesLicenseScreen()),
                          );
                        },
                      ),
              _NavItem(title: 'Broker License',      onTap: () => _go(context, '/broker')),
              _NavItem(
                        title: 'Real State CE',
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const RealEstateCEScreen()),
                          );
                        },
                      ),
            ]),
            _NavItem(title: 'Exam Prep', onTap: () => _go(context, '/exam-prep')),
            _NavExpansion(title: 'Insurance CE', children: [
              _NavItem(title: 'Select a State', onTap: () => _go(context, '/insurance-state')),
              _NavItem(title: 'All Products',   onTap: () => _go(context, '/all-products')),
            ]),
            _NavItem(title: 'CFP Renewal', onTap: () => _go(context, '/cfp-renewal')),
            _NavItem(title: 'About Us',    onTap: () => _go(context, '/about')),
            _NavItem(title: 'Contact Us',  onTap: () => _go(context, '/contact')),
            _NavItem(title: 'All Products',  onTap: () => _go(context, '/all-products')),
=======
            _NavExpansion(
              title: "California Real Estate",
              children: [
                _NavItem(
                  title: "Sales License",
                  onTap: () => _go(context, "/sales"),
                ),
                _NavItem(
                  title: "Broker License",
                  onTap: () => _go(context, "/broker"),
                ),
                _NavItem(
                  title: "45 Hour DRE Renewal CE",
                  onTap: () => _go(context, "/dre-ce"),
                ),
              ],
            ),

            _NavItem(
              title: "Exam Prep",
              onTap: () => _go(context, "/exam-prep"),
            ),

            _NavExpansion(
              title: "Insurance CE",
              children: [
                _NavItem(
                  title: "Select a State",
                  onTap: () => _go(context, "/insurance-states"),
                ),
                _NavItem(
                  title: "Courses",
                  onTap: () => _go(context, "/insurance-courses"),
                ),
              ],
            ),

            _NavItem(
              title: "CFP Renewal",
              onTap: () => _go(context, "/cfp-renewal"),
            ),
            _NavItem(
              title: "About Us",
              onTap: () => _go(context, "/about"),
            ),
            _NavItem(
              title: "Contact Us",
              onTap: () => _go(context, "/contact"),
            ),
>>>>>>> 8902ad4c03a57d9bf40cf41846bba8cfa29b0909

            const SizedBox(height: 10),
            const Divider(color: Colors.white12, height: 1),

<<<<<<< HEAD
=======
            // ✅ LOG OUT
>>>>>>> 8902ad4c03a57d9bf40cf41846bba8cfa29b0909
            _NavItem(
              title: "Log out",
              color: Colors.redAccent,
              onTap: () async {
                Navigator.pop(context); // close drawer

                // TODO: Clear session here if you store token/user
                // Example:
                // final prefs = await SharedPreferences.getInstance();
                // await prefs.clear();

                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/login', (route) => false);
              },
            ),

            const SizedBox(height: 10),
            const Divider(color: Colors.white12, height: 1),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 18),
              child: Text(
                "© 2026 Relstone. All rights reserved.",
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final Color? color;

  const _NavItem({required this.title, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      title: Text(
        title,
        style: TextStyle(
          color: color ?? Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: onTap,
    );
  }
}

class _NavExpansion extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _NavExpansion({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
        childrenPadding: const EdgeInsets.only(left: 10, bottom: 8),
        collapsedIconColor: Colors.white70,
        iconColor: Colors.white70,
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        children: children,
      ),
    );
  }
}

/* ───────────────────────────────────────────────────────────── */
/* HERO */
/* ───────────────────────────────────────────────────────────── */

class _HeroSection extends StatelessWidget {
  final VoidCallback onSalesLicense;
  final VoidCallback onBrokerLicense;

  const _HeroSection({
    required this.onSalesLicense,
    required this.onBrokerLicense,
  });

  static const Color primaryNavy = HomeScreen.primaryNavy;
  static const Color accentBlue = HomeScreen.accentBlue;
  static const Color textMuted = HomeScreen.textMuted;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryNavy.withOpacity(0.95),
            accentBlue.withOpacity(0.85),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: primaryNavy.withOpacity(0.12),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Welcome to Relstone!",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Providing Education Online,\nA Simple Way!",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                height: 1.15,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "With real estate education tailored to your needs and goals, you can advance your career. California broker & sales pre-license courses plus continuing education.",
              style: TextStyle(
                color: Colors.white.withOpacity(0.88),
                fontSize: 13.5,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              "DRE CE Sponsor ID #1035 • DRE Pre-License Sponsor #S0199",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
              ),
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Sales License",
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Broker License",
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "Tip: Use the menu above for courses & states.",
              style: TextStyle(
                color: textMuted.withOpacity(0.2),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ───────────────────────────────────────────────────────────── */
/* SECTION TITLE */
/* ───────────────────────────────────────────────────────────── */

class _SectionTitle extends StatelessWidget {
  final String? eyebrow;
  final String title;
  final String subtitle;

  const _SectionTitle({
    this.eyebrow,
    required this.title,
    required this.subtitle,
  });

  static const Color textDark = HomeScreen.textDark;
  static const Color textMuted = HomeScreen.textMuted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          if (eyebrow != null && eyebrow!.trim().isNotEmpty) ...[
            Text(
              eyebrow!,
              style: const TextStyle(
                fontSize: 11,
                letterSpacing: 1.8,
                fontWeight: FontWeight.w700,
                color: textMuted,
              ),
            ),
            const SizedBox(height: 10),
          ],
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: textDark,
              height: 1.15,
            ),
          ),
          if (subtitle.trim().isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13.5,
                color: textMuted,
                height: 1.45,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/* ───────────────────────────────────────────────────────────── */
/* SERVICE CARD */
/* ───────────────────────────────────────────────────────────── */

class _ServiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String cta;

  const _ServiceCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.cta,
  });

  static const Color primaryNavy = HomeScreen.primaryNavy;
  static const Color textMuted = HomeScreen.textMuted;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primaryNavy.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: primaryNavy.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: primaryNavy),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w800,
                      color: primaryNavy,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: textMuted,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                      onPressed: () {
                        if (title == 'Insurance CE') {
                          Navigator.pushNamed(context, '/insurance-ce');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryNavy,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        cta,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
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

/* ───────────────────────────────────────────────────────────── */
/* GUARANTEE */
/* ───────────────────────────────────────────────────────────── */

class _GuaranteeCard extends StatelessWidget {
  const _GuaranteeCard();

  static const Color textDark = HomeScreen.textDark;
  static const Color textMuted = HomeScreen.textMuted;

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
              decoration: BoxDecoration(
                color: const Color(0xFF16A34A),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(Icons.check_rounded, color: Colors.white),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Our 100% Money-back Guarantee",
                    style: TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w900,
                      color: textDark,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Your enrollment in our Relstone homestudy courses poses no risk. "
                    "If you’re dissatisfied at any time during your one-year enrollment and prior to taking any exams, "
                    "call us for a full refund — no questions asked — and the books/materials are yours to keep.",
                    style: TextStyle(
                      fontSize: 13,
                      color: textMuted,
                      height: 1.45,
                    ),
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

/* ───────────────────────────────────────────────────────────── */
/* WHY CHOOSE */
/* ───────────────────────────────────────────────────────────── */

class _WhyChooseCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const _WhyChooseCard({
    required this.title,
    required this.subtitle,
  });

  static const Color primaryNavy = HomeScreen.primaryNavy;
  static const Color textMuted = HomeScreen.textMuted;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primaryNavy.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: const Color(0xFF16A34A),
                borderRadius: BorderRadius.circular(17),
              ),
              child: const Icon(Icons.check_rounded, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: primaryNavy,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: textMuted,
                    ),
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

/* ───────────────────────────────────────────────────────────── */
/* TESTIMONIAL */
/* ───────────────────────────────────────────────────────────── */

class _TestimonialCard extends StatelessWidget {
  final String quote;
  final String name;
  final String role;
  final String linkText;

  const _TestimonialCard({
    required this.quote,
    required this.name,
    required this.role,
    required this.linkText,
  });

  static const Color primaryNavy = HomeScreen.primaryNavy;
  static const Color textMuted = HomeScreen.textMuted;
  static const Color accentBlue = HomeScreen.accentBlue;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primaryNavy.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: List.generate(
                5,
                (i) => const Icon(Icons.star_rounded,
                    size: 18, color: Color(0xFFF5B301)),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "“$quote”",
              style: const TextStyle(
                fontSize: 13.5,
                color: primaryNavy,
                height: 1.45,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 14),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Text(
              name,
              style: const TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w900,
                color: primaryNavy,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              role,
              style: const TextStyle(
                fontSize: 12.5,
                color: textMuted,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              linkText,
              style: const TextStyle(
                fontSize: 12.5,
                color: accentBlue,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ───────────────────────────────────────────────────────────── */
/* FOOTER */
/* ───────────────────────────────────────────────────────────── */

class _FooterSection extends StatelessWidget {
  const _FooterSection();

  static const Color textMuted = HomeScreen.textMuted;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0B1A2A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.home_work_rounded, color: Colors.white),
              const SizedBox(width: 10),
              const Text(
                "RELSTONE",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            "Providing quality education for\nCalifornia Real Estate and Insurance professionals.",
            style: TextStyle(
              color: Colors.white70,
              height: 1.45,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 14),
<<<<<<< HEAD
          Row(
            children: [
              _SocialIcon(icon: FontAwesomeIcons.facebook,  color: const Color(0xFF1877F2), label: 'Facebook',    url: 'https://www.facebook.com/RelstoneSD'),
              const SizedBox(width: 10),
              _SocialIcon(icon: FontAwesomeIcons.linkedin,  color: const Color(0xFF0A66C2), label: 'LinkedIn',    url: 'https://www.linkedin.com/company/relstone/posts/?feedView=all'),
              const SizedBox(width: 10),
              _SocialIcon(icon: FontAwesomeIcons.xTwitter,  color: const Color(0xFFE7E7E7), label: 'X / Twitter', url: 'https://twitter.com/relstone'),
              const SizedBox(width: 10),
              _SocialIcon(icon: FontAwesomeIcons.tiktok,    color: const Color(0xFFEE1D52), label: 'TikTok',      url: 'https://tiktok.com/@relstone'),
              const SizedBox(width: 10),
              _SocialIcon(icon: FontAwesomeIcons.instagram, color: const Color(0xFFE1306C), label: 'Instagram',   url: 'https://instagram.com/relstone'),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(color: Colors.white12),
          const SizedBox(height: 10),
=======
>>>>>>> 8902ad4c03a57d9bf40cf41846bba8cfa29b0909
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _FooterChip("Contact Us", () {
                Navigator.pushNamed(context, '/contact');
              }),
              _FooterChip("Privacy Policy", () {}),
              _FooterChip("Refund Policy", () {
                showRefundPolicyBottomSheet(context);
              }),
              _FooterChip("Terms of Use", () {}),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(color: Colors.white12),
          const SizedBox(height: 10),
          const Text(
            "© 2026 Relstone. All rights reserved.",
            style: TextStyle(color: textMuted, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

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
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white24),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}