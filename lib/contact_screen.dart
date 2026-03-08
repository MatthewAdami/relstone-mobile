import 'package:flutter/material.dart';
import 'package:relstone_mobile/home__screen/home_screen.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({Key? key}) : super(key: key);

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

      // ✅ Sidebar / Drawer (same as HomeScreen)
      drawer: const _ContactAppSidebar(),

      // ✅ AppBar (same as HomeScreen)
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
          // Contact Us Header
          Container(
            width: double.infinity,
            color: const Color(0xFF1E3A5F), // Dark blue background
            padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Contact Us',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "We're here to help with any questions",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white70,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Content area - All cards with consistent width
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ✅ GET IN TOUCH SECTION  - Card Design
                    Container(
                      width: double.infinity,
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
                            'Get In Touch',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: primaryNavy,
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Have questions about our courses or need assistance with your account? Our team is ready to help.',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: textDark,
                              fontSize: 15,
                              height: 1.6,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Email
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.email_outlined, color: accentBlue, size: 20),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Email',
                                      style: TextStyle(
                                        color: primaryNavy,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'support@relstone.com',
                                      style: TextStyle(
                                        color: accentBlue,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Hours
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.schedule_outlined, color: accentBlue, size: 20),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Hours',
                                      style: TextStyle(
                                        color: primaryNavy,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Monday – Friday: 9am – 5pm PST',
                                      style: TextStyle(
                                        color: textDark,
                                        fontSize: 14,
                                        height: 1.5,
                                      ),
                                    ),
                                    Text(
                                      'Saturday – Sunday: Closed',
                                      style: TextStyle(
                                        color: textDark,
                                        fontSize: 14,
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

                    // ✅ LICENSING INFORMATION SECTION - Card Design
                    Container(
                      width: double.infinity,
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
                            'Licensing Information',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: primaryNavy,
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 20),
                          _LicenseInfoRow('DRE CE Sponsor ID', '#1035'),
                          const SizedBox(height: 16),
                          _LicenseInfoRow('DRE Pre-License Sponsor', '#S0199'),
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

                    // ✅ CONTACT FORM SECTION - Card Design
                    Container(
                      width: double.infinity,
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
                            'Send Us a Message',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: primaryNavy,
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Have a question or feedback? We\'d love to hear from you. Fill out the form below and we\'ll get back to you as soon as possible.',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: textDark,
                              fontSize: 14,
                              height: 1.6,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Name Field
                          _CustomTextField(
                            label: 'Full Name',
                            hint: 'John Doe',
                          ),
                          const SizedBox(height: 20),

                          // Email Field
                          _CustomTextField(
                            label: 'Email Address',
                            hint: 'john@example.com',
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 20),

                          // Message Field
                          _CustomTextField(
                            label: 'Message',
                            hint: 'Your message here...',
                            maxLines: 5,
                          ),
                          const SizedBox(height: 28),

                          // Submit Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Message sent! We\'ll get back to you soon.'),
                                    backgroundColor: Color(0xFF2E7EBE),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: accentBlue,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 2,
                              ),
                              child: Text(
                                'Send Message',
                                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                );
              },
            ),
          ),

          const SizedBox(height: 22),

          // ✅ Footer (same as HomeScreen)
          const _ContactFooterSection(),

          const SizedBox(height: 10), // Add bottom padding to footer
        ],
      ),
    );
  }
}

/* ───────────────────────────────────────────────────────────── */
/* SIDEBAR */
/* ───────────────────────────────────────────────────────────── */

class _ContactAppSidebar extends StatelessWidget {
  const _ContactAppSidebar();

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
/* NAVIGATION COMPONENTS (reused from HomeScreen) */
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

class _ContactFooterSection extends StatelessWidget {
  const _ContactFooterSection();

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

/* ───────────────────────────────────────────────────────────── */
/* CUSTOM FORM COMPONENTS */
/* ───────────────────────────────────────────────────────────── */

class _CustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  final int maxLines;
  final TextInputType keyboardType;

  const _CustomTextField({
    required this.label,
    required this.hint,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    const Color primaryNavy = Color(0xFF1A3A5C);
    const Color accentBlue = Color(0xFF2E7EBE);
    const Color textDark = Color(0xFF1C2B3A);
    const Color textMuted = Color(0xFF6B7E92);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: primaryNavy,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: textMuted,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE0E5EB), width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE0E5EB), width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: accentBlue, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            filled: true,
            fillColor: Colors.white,
          ),
          style: const TextStyle(
            fontSize: 14,
            color: textDark,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

class _LicenseInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _LicenseInfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    const Color primaryNavy = Color(0xFF1A3A5C);
    const Color accentBlue = Color(0xFF2E7EBE);
    const Color textDark = Color(0xFF1C2B3A);

    return LayoutBuilder(
      builder: (context, constraints) {
        // On screens smaller than 400px, stack vertically
        bool isSmallScreen = constraints.maxWidth < 400;

        return isSmallScreen
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: textDark,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F5FA),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: accentBlue.withOpacity(0.3), width: 1),
                    ),
                    child: Text(
                      value,
                      style: const TextStyle(
                        color: accentBlue,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      label,
                      style: const TextStyle(
                        color: textDark,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F5FA),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: accentBlue.withOpacity(0.3), width: 1),
                    ),
                    child: Text(
                      value,
                      style: const TextStyle(
                        color: accentBlue,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ],
              );
      },
    );
  }
}



