import 'package:flutter/material.dart';

import '../services/cart_service.dart';
import '../widgets/main_layout.dart';
import '../widgets/app_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Brand colors
  static const Color primaryNavy = Color(0xFF1A3A5C);
  static const Color accentBlue = Color(0xFF2E7EBE);
  static const Color textDark = Color(0xFF1C2B3A);
  static const Color textMuted = Color(0xFF6B7E92);
  static const Color bg = Color(0xFFF4F6F9);

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      drawer: const AppDrawer(),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          _HeroSection(
            onSalesLicense: () {
              Navigator.pushNamed(context, '/sales');
            },
            onBrokerLicense: () {
              Navigator.pushNamed(context, '/broker');
            },
          ),
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
                  title: "Become an Agent",
                  subtitle: "Get your California Real Estate Sales License",
                  cta: "Get Started",
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
                        // TODO: Hook up to routes
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

