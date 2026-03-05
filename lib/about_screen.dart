import 'package:flutter/material.dart';
import 'package:relstone_mobile/home_screen.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  // Brand colors (same as HomeScreen)
  static const Color primaryNavy = Color(0xFF1A3A5C);
  static const Color accentBlue = Color(0xFF2E7EBE);
  static const Color textDark = Color(0xFF1C2B3A);
  static const Color textMuted = Color(0xFF6B7E92);
  static const Color bg = Color(0xFFF4F6F9);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,

      // ✅ Sidebar / Drawer (same as ContactScreen)
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
          // About Us Header
          Container(
            width: double.infinity,
            color: const Color(0xFF1E3A5F), // Dark blue background
            padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'About Relstone',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "California's Most Trusted Real Estate & Insurance Education Provider Since 1974",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white70,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Content area
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ OUR STORY SECTION
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
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
                      Text(
                        'Our Story',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: primaryNavy,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Relstone was founded in 1974 with a simple mission: provide high-quality, accessible professional education that helps real estate agents and insurance professionals succeed in their careers.',
                        textAlign: TextAlign.justify,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: textDark,
                          fontSize: 15,
                          height: 1.6,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'For over 50 years, we have been at the forefront of continuing education in California. What started as a small classroom operation has grown into a comprehensive online learning platform serving thousands of students each year across more than 40 states.',
                        textAlign: TextAlign.justify,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: textDark,
                          fontSize: 15,
                          height: 1.6,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Our team consists of licensed professionals, experienced educators, and industry experts who understand the challenges facing today\'s real estate and insurance professionals. We continuously update our course content to reflect the latest laws, regulations, and industry best practices.',
                        textAlign: TextAlign.justify,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: textDark,
                          fontSize: 15,
                          height: 1.6,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'When you choose Relstone, you\'re not just buying a course – you\'re investing in your professional future with a company that has helped over 100,000 professionals maintain their licenses and advance their careers.',
                        textAlign: TextAlign.justify,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: textDark,
                          fontSize: 15,
                          height: 1.6,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // ✅ BLUE DIVIDER
                Container(
                  height: 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, accentBlue, Colors.transparent],
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // ✅ AT A GLANCE SECTION
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
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
                      Text(
                        'At a Glance',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: primaryNavy,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Responsive stat cards with equal size
                      Column(
                        children: [
                          IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: _StatCard(
                                    number: '50+',
                                    label: 'Years in Business',
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _StatCard(
                                    number: '100K+',
                                    label: 'Students Served',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: _StatCard(
                                    number: '40+',
                                    label: 'States Covered',
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _StatCard(
                                    number: '500+',
                                    label: 'Course Options',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // ✅ BLUE DIVIDER
                Container(
                  height: 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, accentBlue, Colors.transparent],
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // ✅ WHY PROFESSIONALS CHOOSE RELSTONE SECTION
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
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
                      Text(
                        'Why Professionals Choose Relstone',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: primaryNavy,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Dynamic-sized cards (1 per row)
                      Column(
                        spacing: 16,
                        children: [
                          _FeatureCard(
                            title: 'State Approved',
                            description: 'All courses are officially approved by the California Department of Real Estate (DRE Sponsor #1035, Pre-License #S0199) and state insurance departments. Your completion is automatically reported to the appropriate licensing authority.',
                          ),
                          _FeatureCard(
                            title: '100% Online',
                            description: 'Study anywhere, anytime on any device. Our courses work on computers, tablets, and smartphones. No need to travel to a classroom – complete your continuing education from the comfort of your home or office.',
                          ),
                          _FeatureCard(
                            title: 'Self-Paced Learning',
                            description: 'Work at your own speed. There are no set class times or schedules. Log in and out as often as you like – your progress is automatically saved. Most students complete their courses in just a few days.',
                          ),
                          _FeatureCard(
                            title: 'Instant Certificates',
                            description: 'Download your certificate of completion immediately after passing your final exam. No waiting for mail delivery. For DRE courses, we electronically report your completion within 24-48 hours.',
                          ),
                          _FeatureCard(
                            title: 'Money Back Guarantee',
                            description: 'We stand behind our courses with a 30-day satisfaction guarantee. If you\'re not completely satisfied with your purchase, contact us within 30 days for a full refund – no questions asked.',
                          ),
                          _FeatureCard(
                            title: 'Price Match Guarantee',
                            description: 'We guarantee the lowest prices on all courses. If you find the same state-approved course for less elsewhere, we\'ll match that price. Quality education shouldn\'t break the bank.',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // ✅ BLUE DIVIDER
                Container(
                  height: 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, accentBlue, Colors.transparent],
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // ✅ OUR COURSES SECTION
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
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
                      Text(
                        'Our Courses',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: primaryNavy,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // California Real Estate Section
                      Text(
                        'California Real Estate',
                        style: const TextStyle(
                          color: primaryNavy,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'We offer complete packages for real estate professionals including:',
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          color: textDark,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _CourseListItem('Sales License Pre-Licensing Courses'),
                      _CourseListItem('Broker License Pre-Licensing Courses'),
                      _CourseListItem('45-Hour Renewal CE Packages'),
                      _CourseListItem('Individual CE Elective Courses'),
                      _CourseListItem('State & National Exam Prep'),
                      const SizedBox(height: 24),
                      // Insurance Continuing Education Section
                      Text(
                        'Insurance Continuing Education',
                        style: const TextStyle(
                          color: primaryNavy,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Fulfill your license renewal requirements with our state-approved insurance CE courses covering:',
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          color: textDark,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _CourseListItem('Property & Casualty'),
                      _CourseListItem('Life & Health'),
                      _CourseListItem('Ethics Requirements'),
                      _CourseListItem('State-Specific Topics'),
                      _CourseListItem('Annuity Training'),
                      const SizedBox(height: 20),
                      Text(
                        'All courses meet mandatory requirements set by state insurance departments.',
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          color: textDark,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // ✅ BLUE DIVIDER
                Container(
                  height: 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, accentBlue, Colors.transparent],
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // ✅ OUR COMMITMENT SECTION
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
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
                      Text(
                        'Our Commitment',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: primaryNavy,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'At Relstone, we believe continuing education should be convenient, affordable, and valuable. We\'re committed to:',
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          color: textDark,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _CommitmentItem(
                        title: 'Quality Content',
                        description: 'Our courses are written by industry professionals and updated regularly to reflect current laws and best practices.',
                      ),
                      const SizedBox(height: 18),
                      _CommitmentItem(
                        title: 'Student Support',
                        description: 'Our customer service team is available to help you with enrollment, technical issues, or any questions about your courses.',
                      ),
                      const SizedBox(height: 18),
                      _CommitmentItem(
                        title: 'Compliance',
                        description: 'We ensure all courses meet or exceed state requirements so you can renew your license with confidence.',
                      ),
                      const SizedBox(height: 18),
                      _CommitmentItem(
                        title: 'Value',
                        description: 'We offer competitive pricing, bundle discounts, and our price match guarantee to ensure you get the best value.',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),

          const SizedBox(height: 22),

          // ✅ Footer (same as ContactScreen)
          const _AboutFooterSection(),

          const SizedBox(height: 10), // Add bottom padding to footer
        ],
      ),
    );
  }
}

/* ───────────────────────────────────────────────────────────── */
/* FEATURE CARD COMPONENT */
/* ───────────────────────────────────────────────────────────── */

class _FeatureCard extends StatefulWidget {
  final String title;
  final String description;

  const _FeatureCard({
    required this.title,
    required this.description,
  });

  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    const Color primaryNavy = Color(0xFF1A3A5C);
    const Color accentBlue = Color(0xFF2E7EBE);
    const Color textDark = Color(0xFF1C2B3A);
    const Color bg = Color(0xFFF4F6F9);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color(0xFFE0E5EB),
            width: 1,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: accentBlue.withOpacity(0.15),
                    blurRadius: 14,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                color: accentBlue,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.description,
              textAlign: TextAlign.justify,
              style: const TextStyle(
                color: textDark,
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
/* STAT CARD COMPONENT */
/* ───────────────────────────────────────────────────────────── */

class _StatCard extends StatefulWidget {
  final String number;
  final String label;

  const _StatCard({
    required this.number,
    required this.label,
  });

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    const Color primaryNavy = Color(0xFF1A3A5C);
    const Color accentBlue = Color(0xFF2E7EBE);
    const Color bg = Color(0xFFF4F6F9);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color(0xFFE0E5EB),
            width: 1,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: accentBlue.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.number,
              style: const TextStyle(
                color: accentBlue,
                fontSize: 26,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: primaryNavy,
                fontSize: 13,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.2,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ───────────────────────────────────────────────────────────── */
/* COURSE LIST ITEM COMPONENT */
/* ───────────────────────────────────────────────────────────── */

class _CourseListItem extends StatelessWidget {
  final String text;

  const _CourseListItem(this.text);

  @override
  Widget build(BuildContext context) {
    const Color textDark = Color(0xFF1C2B3A);

    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '•',
            style: TextStyle(
              color: textDark,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: textDark,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* ───────────────────────────────────────────────────────────── */
/* COMMITMENT ITEM COMPONENT */
/* ───────────────────────────────────────────────────────────── */

class _CommitmentItem extends StatelessWidget {
  final String title;
  final String description;

  const _CommitmentItem({
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    const Color primaryNavy = Color(0xFF1A3A5C);
    const Color textDark = Color(0xFF1C2B3A);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: primaryNavy,
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          description,
          textAlign: TextAlign.justify,
          style: const TextStyle(
            color: textDark,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

/* ───────────────────────────────────────────────────────────── */
/* SIDEBAR */
/* ───────────────────────────────────────────────────────────── */

class _AboutAppSidebar extends StatelessWidget {
  const _AboutAppSidebar();

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

  static const Color textMuted = Color(0xFF6B7E92);

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
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _FooterChip("Contact Us", () {
                Navigator.pushNamed(context, '/contact');
              }),
              _FooterChip("Privacy Policy", () {}),
              _FooterChip("Refund Policy", () {}),
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


















