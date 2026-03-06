import 'package:flutter/material.dart';
import 'package:relstone_mobile/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  // Brand colors (same as HomeScreen)
  static const Color primaryNavy = Color(0xFF1A3A5C);
  static const Color accentBlue = Color(0xFF2E7EBE);
  static const Color textDark = Color(0xFF1C2B3A);
  static const Color textMuted = Color(0xFF6B7E92);
  static const Color bg = Color(0xFFF4F6F9);

  Future<void> _callTollFree() async {
    final uri = Uri.parse('tel:18008775445');
    await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      backgroundColor: bg,

      // ✅ Sidebar / Drawer    (same as ContactScreen)
      drawer: const _AboutAppSidebar(),

      // ✅ AppBar (same as ContactScreen)
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
        actions: [
          IconButton(
            tooltip: "Cart",
            onPressed: () => Navigator.pushNamed(context, '/cart'),
            icon: const Icon(Icons.shopping_cart_outlined, color: primaryNavy),
          ),
          const SizedBox(width: 6),
        ],
      ),

      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Website-style hero header
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF071A2B), Color(0xFF143A5C)],
              ),
            ),
            padding: EdgeInsets.fromLTRB(isMobile ? 10 : 20, isMobile ? 12 : 44, isMobile ? 10 : 20, isMobile ? 10 : 26),
            child: Column(
              children: [
                Text(
                  'ABOUT US',
                  style: TextStyle(
                    color: const Color(0xFF2EA7FF),
                    fontSize: isMobile ? 9 : 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: isMobile ? 5 : 14),
                Text(
                  'Real Estate & Insurance\nSchools',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isMobile ? 20 : 64,
                    fontWeight: FontWeight.w800,
                    height: 1.02,
                    letterSpacing: -1.1,
                  ),
                ),
                SizedBox(height: isMobile ? 0 : 4),
                Text(
                  'Since 1978',
                  style: TextStyle(
                    color: const Color(0xFF2EA7FF),
                    fontSize: isMobile ? 22 : 58,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1.0,
                  ),
                ),
                SizedBox(height: isMobile ? 5 : 14),
                Text(
                  'Real Estate License Services - helping agents, brokers, adjusters, CFPs, and\nCPAs complete their continuing education for over 47 years.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFFC5D4E3),
                    fontSize: isMobile ? 8 : 28,
                    height: isMobile ? 1.35 : 1.35,
                  ),
                ),
                SizedBox(height: isMobile ? 8 : 22),
                InkWell(
                  onTap: _callTollFree,
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: isMobile ? 10 : 22, vertical: isMobile ? 7 : 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2B4E70).withOpacity(0.35),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.white.withOpacity(0.18)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.call, color: const Color(0xFF2EA7FF), size: isMobile ? 14 : 26),
                        SizedBox(width: isMobile ? 5 : 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'CALL TOLL-FREE',
                              style: TextStyle(
                                color: const Color(0xFFAFC3D8),
                                fontSize: isMobile ? 7 : 12,
                                letterSpacing: 1.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 1),
                            Text(
                              '1-800-877-5445',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isMobile ? 12 : 32,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.2,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: isMobile ? 5 : 14),
                Text(
                  '7 Days a Week: 6 am-10 pm Pacific  ·  9 am-1 am Eastern',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: const Color(0xFF95AFC6), fontSize: isMobile ? 8 : 15),
                ),
              ],
            ),
          ),

          Container(
            color: const Color(0xFF071726),
            padding: EdgeInsets.symmetric(vertical: isMobile ? 8 : 12, horizontal: isMobile ? 8 : 12),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 700;

                if (isWide) {
                  // Wide screen: single row with all 4 cards
                  return IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: const [
                        Expanded(child: _StatBox(number: '47+', label: 'Years in Business')),
                        SizedBox(width: 6),
                        Expanded(child: _StatBox(number: '4M+', label: 'Courses Completed')),
                        SizedBox(width: 6),
                        Expanded(child: _StatBox(number: '47', label: 'States Served')),
                        SizedBox(width: 6),
                        Expanded(child: _StatBox(number: '1978', label: 'Founded')),
                      ],
                    ),
                  );
                } else {
                  // Mobile: 2x2 grid
                  return Column(
                    children: [
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: const [
                            Expanded(child: _StatBox(number: '47+', label: 'Years in Business')),
                            SizedBox(width: 6),
                            Expanded(child: _StatBox(number: '4M+', label: 'Courses Completed')),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: const [
                            Expanded(child: _StatBox(number: '47', label: 'States Served')),
                            SizedBox(width: 6),
                            Expanded(child: _StatBox(number: '1978', label: 'Founded')),
                          ],
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),

          SizedBox(height: isMobile ? 20 : 28),

          // Three Info Cards
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 700;

                if (isWide) {
                  // Wide screen: single row with equal height
                  return IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: _InfoCard(
                            icon: Icons.school_rounded,
                            title: 'How to Get Your CA Real Estate License',
                            description: 'Complete state-approved courses online or with textbooks. We guide you through every step.',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _InfoCard(
                            icon: Icons.star_rounded,
                            title: '4+ Million Courses Completed',
                            description: 'Using the most effective learning format to help you pass fast and succeed!',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _InfoCard(
                            icon: Icons.emoji_events_rounded,
                            title: 'Trusted Since 1974',
                            description: '47+ years of proven success in insurance CE and CFP® certification courses.',
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  // Mobile: stacked with same width
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _InfoCard(
                        icon: Icons.school_rounded,
                        title: 'How to Get Your CA Real Estate License',
                        description: 'Complete state-approved courses online or with textbooks. We guide you through every step.',
                      ),
                      const SizedBox(height: 12),
                      _InfoCard(
                        icon: Icons.star_rounded,
                        title: '4+ Million Courses Completed',
                        description: 'Using the most effective learning format to help you pass fast and succeed!',
                      ),
                      const SizedBox(height: 12),
                      _InfoCard(
                        icon: Icons.emoji_events_rounded,
                        title: 'Trusted Since 1974',
                        description: '47+ years of proven success in insurance CE and CFP® certification courses.',
                      ),
                    ],
                  );
                }
              },
            ),
          ),

          const SizedBox(height: 24),

          // Choose RELSTONE For Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _ChooseRelstoneSection(),
          ),
          const SizedBox(height: 24),

          // Why We're the #1 Choice Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                // Section Header
                Text(
                  'Why We\'re the #1 Choice',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: const Color(0xFF1C2B3A),
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 16),
                // Blue underline
                Center(
                  child: Container(
                    width: 60,
                    height: 3,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4A9EE0),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Description
                Text(
                  'Have you checked how long most continuing education insurance schools have been in business? Most you\'ll find online have appeared fairly recently. But RELSTONE® has been helping insurance agents, adjusters, CFPs and CPAs to successfully complete insurance CE courses for the past 47 years!',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF6B7E92),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 24),
                // Four Feature Cards in a grid
                _WhyChooseGrid(),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // New sections: Proven Effective & Since 1978
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 700;

                if (isWide) {
                  // Wide screen: side by side
                  return IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: _DetailCard(
                            icon: Icons.verified_user_rounded,
                            title: 'Proven Effective',
                            description: 'Since 1974, our courses have been used by hundreds of thousands to successfully complete their insurance CE. Over the last 47 years, our textbooks, courses, and exams have been extensively tested by professionals from 47 states. Our founder is a long-time educator and popular college professor — he created these courses himself and stands 100% behind every one.',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _DetailCard(
                            icon: Icons.apartment_rounded,
                            title: 'Since 1978 — San Diego, CA',
                            description: 'Real Estate License Services (through C.E. Credits, Inc.) has been offering state-approved insurance license and CFP® certificate courses in 47 states and the District of Columbia. We\'ve also been helping California real estate agents and brokers get and renew their licenses for more than 43 years.',
                            footerWidget: Container(
                              margin: const EdgeInsets.only(top: 12),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                color: const Color(0xFF4A9EE0).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: const [
                                  Icon(
                                    Icons.location_on,
                                    color: Color(0xFF4A9EE0),
                                    size: 16,
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'San Diego, California — since 1978',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Color(0xFF4A9EE0),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        height: 1.3,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  // Mobile: stacked
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _DetailCard(
                        icon: Icons.verified_user_rounded,
                        title: 'Proven Effective',
                        description: 'Since 1974, our courses have been used by hundreds of thousands to successfully complete their insurance CE. Over the last 47 years, our textbooks, courses, and exams have been extensively tested by professionals from 47 states. Our founder is a long-time educator and popular college professor — he created these courses himself and stands 100% behind every one.',
                      ),
                      const SizedBox(height: 12),
                      _DetailCard(
                        icon: Icons.apartment_rounded,
                        title: 'Since 1978 — San Diego, CA',
                        description: 'Real Estate License Services (through C.E. Credits, Inc.) has been offering state-approved insurance license and CFP® certificate courses in 47 states and the District of Columbia. We\'ve also been helping California real estate agents and brokers get and renew their licenses for more than 43 years.',
                        footerWidget: Container(
                          margin: const EdgeInsets.only(top: 12),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4A9EE0).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: const [
                              Icon(
                                Icons.location_on,
                                color: Color(0xFF4A9EE0),
                                size: 16,
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'San Diego, California — since 1978',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Color(0xFF4A9EE0),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    height: 1.3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),

          const SizedBox(height: 24),

          // Testimonials (static data)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: _TestimonialsSection(),
          ),

          const SizedBox(height: 24),

          // Footer
          const _AboutFooterSection(),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

/* ───────────────────────────────────────────────────────────── */
/* STAT BOX COMPONENT (for hero section) */
/* ───────────────────────────────────────────────────────────── */

class _StatBox extends StatefulWidget {
  final String number;
  final String label;

  const _StatBox({
    required this.number,
    required this.label,
  });

  @override
  State<_StatBox> createState() => _StatBoxState();
}

class _StatBoxState extends State<_StatBox> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        height: double.infinity,
        padding: EdgeInsets.symmetric(vertical: isMobile ? 12 : 18, horizontal: isMobile ? 8 : 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(_isHovered ? 0.15 : 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withOpacity(_isHovered ? 0.4 : 0.2),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.number,
              style: TextStyle(
                color: const Color(0xFF4A9EE0),
                fontSize: isMobile ? 20 : 28,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.8,
              ),
            ),
            SizedBox(height: isMobile ? 3 : 4),
            Text(
              widget.label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: isMobile ? 10 : 12,
                fontWeight: FontWeight.w500,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ───────────────────────────────────────────────────────────── */
/* INFO CARD COMPONENT (3 cards below stats) */
/* ───────────────────────────────────────────────────────────── */

class _InfoCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  State<_InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<_InfoCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isHovered
                ? const Color(0xFF4A9EE0).withOpacity(0.5)
                : const Color(0xFFE0E5EB),
            width: 1,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: const Color(0xFF4A9EE0).withOpacity(0.2),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF4A9EE0).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                widget.icon,
                color: const Color(0xFF4A9EE0),
                size: 24,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              widget.title,
              style: const TextStyle(
                color: Color(0xFF1C2B3A),
                fontSize: 17,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.description,
              style: const TextStyle(
                color: Color(0xFF6B7E92),
                fontSize: 13,
                fontWeight: FontWeight.w400,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ───────────────────────────────────────────────────────────── */
/* CHOOSE RELSTONE FOR SECTION */
/* ───────────────────────────────────────────────────────────── */

class _ChooseRelstoneSection extends StatelessWidget {
  const _ChooseRelstoneSection();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 700;

        if (isWide) {
          // Wide screen: side by side
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF0B1A2A),
                  const Color(0xFF1A3A5C),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Choose RELSTONE® For:',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Proven effective state-approved Insurance CE and CFP® Certificate courses for 47 states and District of Columbia. Convenient online or home study (with textbooks) — since 1974.',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Get your California Real Estate Salesperson or Broker License, or renew your license with Real Estate Continuing Education credits online or home study (with textbooks) — in San Diego since 1978.',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 18),
                      _ChecklistItem('Insurance License'),
                      _ChecklistItem('CFP® Certificate'),
                      _ChecklistItem('Real Estate License'),
                      _ChecklistItem('CPA Renewal Courses'),
                      _ChecklistItem('State Approved'),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  flex: 2,
                  child: _LargeStatCard(),
                ),
              ],
            ),
          );
        } else {
          // Narrow screen: stacked with centered stat card
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF0B1A2A),
                  const Color(0xFF1A3A5C),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Choose RELSTONE® For:',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Proven effective state-approved Insurance CE and CFP® Certificate courses for 47 states and District of Columbia. Convenient online or home study (with textbooks) — since 1974.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Get your California Real Estate Salesperson or Broker License, or renew your license with Real Estate Continuing Education credits online or home study (with textbooks) — in San Diego since 1978.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 18),
                _ChecklistItem('Insurance License'),
                _ChecklistItem('CFP® Certificate'),
                _ChecklistItem('Real Estate License'),
                _ChecklistItem('CPA Renewal Courses'),
                _ChecklistItem('State Approved'),
                const SizedBox(height: 20),
                // Center the stat card on mobile
                Center(
                  child: _LargeStatCard(),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

class _ChecklistItem extends StatelessWidget {
  final String text;

  const _ChecklistItem(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle,
            color: Color(0xFF4ADE80),
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _LargeStatCard extends StatefulWidget {
  const _LargeStatCard();

  @override
  State<_LargeStatCard> createState() => _LargeStatCardState();
}

class _LargeStatCardState extends State<_LargeStatCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.all(isMobile ? 20 : 26),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF1E3A5C),
              const Color(0xFF2A4A62),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF4A9EE0).withOpacity(0.3),
            width: 1,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: const Color(0xFF4A9EE0).withOpacity(0.3),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
        ),
        child: Column(
          children: [
            Text(
              '4,000,000+',
              style: TextStyle(
                color: const Color(0xFF4A9EE0),
                fontSize: isMobile ? 32 : 38,
                fontWeight: FontWeight.bold,
                letterSpacing: -1.5,
              ),
            ),
            SizedBox(height: isMobile ? 10 : 12),
            Text(
              'Courses Successfully Completed!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: isMobile ? 15 : 17,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),
            SizedBox(height: isMobile ? 8 : 10),
            Text(
              'Trusted by professionals nationwide since 1978',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: isMobile ? 11 : 12,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ───────────────────────────────────────────────────────────── */
/* WHY CHOOSE GRID COMPONENT */
/* ───────────────────────────────────────────────────────────── */

class _WhyChooseGrid extends StatelessWidget {
  const _WhyChooseGrid();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 700;

        if (isWide) {
          // Wide screen: 2x2 grid with equal height rows
          return Column(
            children: [
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: _WhyChooseCard(
                        icon: Icons.bolt_rounded,
                        title: 'Easy',
                        description: 'Easy to work at your own pace online courses (printed textbooks also available), and shorter exams.',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _WhyChooseCard(
                        icon: Icons.check_circle_rounded,
                        title: 'Effective',
                        description: 'Learn at your own pace and easily re-read anything — with the most effective and fastest learning format!',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: _WhyChooseCard(
                        icon: Icons.attach_money_rounded,
                        title: 'Affordable',
                        description: 'We\'ll beat any advertised price.',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _WhyChooseCard(
                        icon: Icons.headset_mic_rounded,
                        title: '5-Star Customer Service',
                        description: 'Call 1-800-877-5445 to speak directly with an experienced CE advisor. No phone menus — just real people.',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        } else {
          // Narrow screen: single column with equal width cards
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _WhyChooseCard(
                icon: Icons.bolt_rounded,
                title: 'Easy',
                description: 'Easy to work at your own pace online courses (printed textbooks also available), and shorter exams.',
              ),
              const SizedBox(height: 12),
              _WhyChooseCard(
                icon: Icons.check_circle_rounded,
                title: 'Effective',
                description: 'Learn at your own pace and easily re-read anything — with the most effective and fastest learning format!',
              ),
              const SizedBox(height: 12),
              _WhyChooseCard(
                icon: Icons.attach_money_rounded,
                title: 'Affordable',
                description: 'We\'ll beat any advertised price.',
              ),
              const SizedBox(height: 12),
              _WhyChooseCard(
                icon: Icons.headset_mic_rounded,
                title: '5-Star Customer Service',
                description: 'Call 1-800-877-5445 to speak directly with an experienced CE advisor. No phone menus — just real people.',
              ),
            ],
          );
        }
      },
    );
  }
}

/* ───────────────────────────────────────────────────────────── */
/* WHY CHOOSE CARD COMPONENT */
/* ───────────────────────────────────────────────────────────── */

class _WhyChooseCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;

  const _WhyChooseCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  State<_WhyChooseCard> createState() => _WhyChooseCardState();
}

class _WhyChooseCardState extends State<_WhyChooseCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border(
            top: BorderSide(
              color: _isHovered
                  ? const Color(0xFF4A9EE0)
                  : const Color(0xFF4A9EE0),
              width: _isHovered ? 4 : 3,
            ),
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: const Color(0xFF4A9EE0).withOpacity(0.2),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFF0F2537),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                widget.icon,
                color: const Color(0xFF4A9EE0),
                size: 22,
              ),
            ),
            const SizedBox(height: 14),
            // Title
            Text(
              widget.title,
              style: const TextStyle(
                color: Color(0xFF1C2B3A),
                fontSize: 17,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 10),
            // Description
            Text(
              widget.description,
              style: const TextStyle(
                color: Color(0xFF6B7E92),
                fontSize: 13,
                fontWeight: FontWeight.w400,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ───────────────────────────────────────────────────────────── */
/* DETAIL CARD COMPONENT (for Proven Effective & Since 1978 sections) */
/* ───────────────────────────────────────────────────────────── */

class _DetailCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  final Widget? footerWidget;

  const _DetailCard({
    required this.icon,
    required this.title,
    required this.description,
    this.footerWidget,
  });

  @override
  State<_DetailCard> createState() => _DetailCardState();
}

class _DetailCardState extends State<_DetailCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isHovered
                ? const Color(0xFF4A9EE0).withOpacity(0.5)
                : const Color(0xFFE0E5EB),
            width: 1,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: const Color(0xFF4A9EE0).withOpacity(0.2),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF0F2537),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                widget.icon,
                color: const Color(0xFF4A9EE0),
                size: 24,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.title,
              style: const TextStyle(
                color: Color(0xFF1C2B3A),
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.description,
              style: const TextStyle(
                color: Color(0xFF6B7E92),
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 1.6,
              ),
            ),
            if (widget.footerWidget != null) ...[
              const SizedBox(height: 16),
              widget.footerWidget!,
            ],
          ],
        ),
      ),
    );
  }
}

/* ───────────────────────────────────────────────────────────── */
/* TESTIMONIALS SECTION */
/* ───────────────────────────────────────────────────────────── */

class _TestimonialsSection extends StatelessWidget {
  const _TestimonialsSection();

  @override
  Widget build(BuildContext context) {
    final items = <({String quote, String name, String location})>[
      (
        quote:
            'Very thorough information for the insurance industry, and the staff at Relstone are extremely professional and helpful.',
        name: 'Diana Miller Mccravy',
        location: 'Villa Rica, GA'
      ),
      (
        quote:
            'Easy access and the printable book was easy to print as well. Whenever I had a question someone was always available to answer.',
        name: 'Adrian J.',
        location: 'Gretna, LA'
      ),
      (
        quote:
            'Relstone was very easy to use. Reasonably priced, 50-question exams - just the right length. Good website to get your continuing ed.',
        name: 'Quentin Lazaro',
        location: 'Lincoln, NE'
      ),
      (
        quote:
            'Have been using RELSTONE for my Insurance and CFP CEs for over 7 years and am very happy. Its friendly, clear and to the point.',
        name: 'Placido Blanco',
        location: 'Tampa, FL'
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 700;
        return Column(
          children: [
            Text(
              'See What Our Customers Say!',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: const Color(0xFF1C2B3A),
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Container(
                width: 56,
                height: 3,
                decoration: BoxDecoration(
                  color: const Color(0xFF4A9EE0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Testimonials are dynamically loaded from customer reviews.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF6B7E92),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 18),
            if (isWide)
              Column(
                children: [
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(child: _TestimonialCard(data: items[0])),
                        const SizedBox(width: 12),
                        Expanded(child: _TestimonialCard(data: items[1])),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(child: _TestimonialCard(data: items[2])),
                        const SizedBox(width: 12),
                        Expanded(child: _TestimonialCard(data: items[3])),
                      ],
                    ),
                  ),
                ],
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _TestimonialCard(data: items[0]),
                  const SizedBox(height: 12),
                  _TestimonialCard(data: items[1]),
                  const SizedBox(height: 12),
                  _TestimonialCard(data: items[2]),
                  const SizedBox(height: 12),
                  _TestimonialCard(data: items[3]),
                ],
              ),
          ],
        );
      },
    );
  }
}

class _TestimonialCard extends StatelessWidget {
  final ({String quote, String name, String location}) data;

  const _TestimonialCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDCE6EF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.format_quote, color: Color(0xFF9CCFF5), size: 30),
          const SizedBox(height: 6),
          const Text(
            '★★★★★',
            style: TextStyle(
              color: Color(0xFFF59E0B),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            data.quote,
            style: const TextStyle(
              color: Color(0xFF1C2B3A),
              fontSize: 14,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFDCE6EF)),
          const SizedBox(height: 10),
          Text(
            data.name,
            style: const TextStyle(
              color: Color(0xFF0F1F2E),
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            data.location,
            style: const TextStyle(
              color: Color(0xFF6B7E92),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

/* ───────────────────────────────────────────────────────────── */
/* SIDEBAR */
/* ───────────────────────────────────────────────────────────── */

class _AboutAppSidebar extends StatelessWidget {
  const _AboutAppSidebar();

  static const Color navBg = Color(0xFF0B1A2A);

  void _go(BuildContext context, String route) async {
    Navigator.pop(context); // close drawer

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

            const SizedBox(height: 10),
            const Divider(color: Colors.white12, height: 1),

            // ✅ LOG OUT
            _NavItem(
              title: "Log out",
              color: Colors.redAccent,
              onTap: () async {
                Navigator.pop(context); // close drawer
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/login', (route) => false);
              },
            ),

            const SizedBox(height: 10),
            const Divider(color: Colors.white12, height: 1),
          ],
        ),
      ),
    );
  }
}

/* ───────────────────────────────────────────────────────────── */
/* NAVIGATION COMPONENTS (reused from ContactScreen) */
/* ───────────────────────────────────────────────────────────── */

class _NavExpansion extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _NavExpansion({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        expansionTileTheme: const ExpansionTileThemeData(
          backgroundColor: Colors.transparent,
          collapsedBackgroundColor: Colors.transparent,
        ),
      ),
      child: ExpansionTile(
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconColor: Colors.white70,
        collapsedIconColor: Colors.white70,
        children: children,
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final Color color;

  const _NavItem({
    required this.title,
    required this.onTap,
    this.color = Colors.white70,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Text(
          title,
          style: TextStyle(
            color: color,
            fontSize: 14.5,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

/* ───────────────────────────────────────────────────────────── */
/* FOOTER */
/* ───────────────────────────────────────────────────────────── */

class _AboutFooterSection extends StatelessWidget {
  const _AboutFooterSection();

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
              _AboutSocialIcon(icon: FontAwesomeIcons.facebook, color: const Color(0xFF1877F2), label: 'Facebook', url: 'https://www.facebook.com/RelstoneSD'),
              const SizedBox(width: 10),
              _AboutSocialIcon(icon: FontAwesomeIcons.linkedin, color: const Color(0xFF0A66C2), label: 'LinkedIn', url: 'https://www.linkedin.com/company/relstone/posts/?feedView=all'),
              const SizedBox(width: 10),
              _AboutSocialIcon(icon: FontAwesomeIcons.xTwitter, color: const Color(0xFFE7E7E7), label: 'X / Twitter', url: 'https://twitter.com/relstone'),
              const SizedBox(width: 10),
              _AboutSocialIcon(icon: FontAwesomeIcons.tiktok, color: const Color(0xFFEE1D52), label: 'TikTok', url: 'https://tiktok.com/@relstone'),
              const SizedBox(width: 10),
              _AboutSocialIcon(icon: FontAwesomeIcons.instagram, color: const Color(0xFFE1306C), label: 'Instagram', url: 'https://instagram.com/relstone'),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(color: Colors.white12),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _FooterChip('Contact Us', () => Navigator.pushNamed(context, '/contact')),
              _FooterChip('Privacy Policy', () {}),
              _FooterChip('Refund Policy', () {}),
              _FooterChip('Terms of Use', () {}),
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
class _AboutSocialIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String url;
  const _AboutSocialIcon({required this.icon, required this.color, required this.label, required this.url});

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

