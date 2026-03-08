import 'package:flutter/material.dart';
import 'package:relstone_mobile/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:relstone_mobile/widgets/relstone_footer.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController? _nameController;
  TextEditingController? _emailController;
  TextEditingController? _subjectController;
  TextEditingController? _messageController;
  bool _hasAttemptedSubmit = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _subjectController = TextEditingController();
    _messageController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController?.dispose();
    _emailController?.dispose();
    _subjectController?.dispose();
    _messageController?.dispose();
    super.dispose();
  }

  // Brand colors    (same as HomeScreen)
  static const Color primaryNavy = Color(0xFF1A3A5C);
  static const Color accentBlue = Color(0xFF2E7EBE);
  static const Color textDark = Color(0xFF1C2B3A);
  static const Color textMuted = Color(0xFF6B7E92);
  static const Color bg = Color(0xFFF4F6F9);

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  String? _emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }

    final email = value.trim();
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!emailRegex.hasMatch(email)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  void _resetContactForm() {
    _formKey.currentState?.reset();
    _nameController?.clear();
    _emailController?.clear();
    _subjectController?.clear();
    _messageController?.clear();
    setState(() {
      _hasAttemptedSubmit = false;
    });
  }

  Future<void> _showSuccessDialog() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          titlePadding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
          contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
          actionsPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          title: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: accentBlue.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: accentBlue, size: 20),
              ),
              const SizedBox(width: 10),
              const Text(
                'Message Sent',
                style: TextStyle(
                  color: primaryNavy,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          content: const Text(
            'Your message has been sent successfully. We\'ll get back to you soon!',
            style: TextStyle(
              color: textDark,
              fontSize: 14,
              height: 1.45,
            ),
          ),
          actions: [
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: accentBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );

    if (mounted) {
      _resetContactForm();
    }
  }

  Future<void> _submitContactForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      setState(() {
        _hasAttemptedSubmit = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fix the highlighted fields.'),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: accentBlue),
      ),
    );

    try {
      // Get API base URL from config
      const baseUrl = 'http://localhost:3002'; // Backend runs on port 3002
      const apiPrefix = '/api/v1';

      final response = await http.post(
        Uri.parse('$baseUrl$apiPrefix/contact'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': _nameController?.text.trim(),
          'email': _emailController?.text.trim(),
          'subject': _subjectController?.text.trim(),
          'message': _messageController?.text.trim(),
        }),
      );

      // Close loading dialog
      if (mounted) Navigator.of(context).pop();

      if (response.statusCode == 201) {
        // Success
        await _showSuccessDialog();
      } else {
        // Error from server
        final errorData = json.decode(response.body);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorData['message'] ?? 'Failed to send message'),
              backgroundColor: Colors.redAccent,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      // Close loading dialog
      if (mounted) Navigator.of(context).pop();

      // Network or other error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.redAccent,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

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
          // Website-style gradient header
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF071A2B), Color(0xFF143A5C)],
              ),
            ),
            padding: EdgeInsets.fromLTRB(isMobile ? 20 : 40, isMobile ? 40 : 60, isMobile ? 20 : 40, isMobile ? 40 : 60),
            child: Column(
              children: [
                Text(
                  'SUPPORT',
                  style: TextStyle(
                    color: const Color(0xFF2EA7FF),
                    fontSize: isMobile ? 12 : 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5,
                  ),
                ),
                SizedBox(height: isMobile ? 8 : 16),
                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: isMobile ? 10 : 14,
                  runSpacing: isMobile ? 10 : 12,
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Contact ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isMobile ? 32 : 56,
                              fontWeight: FontWeight.w800,
                              height: 1.1,
                              letterSpacing: -0.5,
                            ),
                          ),
                          TextSpan(
                            text: 'Us',
                            style: TextStyle(
                              color: const Color(0xFF2EA7FF),
                              fontSize: isMobile ? 32 : 56,
                              fontWeight: FontWeight.w800,
                              height: 1.1,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isMobile ? 12 : 20),
                Text(
                  'We\'re here to help with any questions about our courses, your account, or licensing requirements.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFFC5D4E3),
                    fontSize: isMobile ? 14 : 18,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: isMobile ? 14 : 18),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: isMobile ? 280 : 420),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: isMobile ? 14 : 24, vertical: isMobile ? 10 : 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2B4E70).withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
                    ),
                    child: LayoutBuilder(
                      builder: (context, badgeConstraints) {
                        final useCompactLayout = badgeConstraints.maxWidth < 220;

                        if (useCompactLayout) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.access_time, color: const Color(0xFF2EA7FF), size: isMobile ? 18 : 22),
                              SizedBox(height: isMobile ? 6 : 8),
                              Text(
                                'Mon-Fri, 9am-5pm PST',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isMobile ? 13 : 16,
                                  fontWeight: FontWeight.w600,
                                  height: 1.25,
                                ),
                              ),
                            ],
                          );
                        }

                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.access_time, color: const Color(0xFF2EA7FF), size: isMobile ? 18 : 22),
                            SizedBox(width: isMobile ? 8 : 12),
                            Text(
                              'Mon-Fri, 9am-5pm PST',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isMobile ? 14 : 16,
                                fontWeight: FontWeight.w600,
                                height: 1.25,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: isMobile ? 16 : 24),
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
                    // GET IN TOUCH Header
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'GET IN TOUCH',
                            style: TextStyle(
                              color: textMuted,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Have questions about our courses or need assistance with your account? Our team is ready to help.',
                            style: TextStyle(
                              color: textDark,
                              fontSize: 14,
                              height: 1.6,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Email Us Card
                    _ContactInfoCard(
                      icon: Icons.email,
                      iconColor: accentBlue,
                      title: 'Email Us',
                      mainText: 'support@relstone.com',
                      subText: 'We typically respond within 1 business day.',
                      onTap: () async {
                        final uri = Uri.parse('mailto:support@relstone.com');
                        await launchUrl(uri);
                      },
                    ),

                    const SizedBox(height: 12),

                    // Call Us Card
                    _ContactInfoCard(
                      icon: Icons.phone,
                      iconColor: accentBlue,
                      title: 'Call Us',
                      mainText: '1-800-877-5445',
                      subText: 'Real people, no phone menus.',
                      onTap: () async {
                        final uri = Uri.parse('tel:18008775445');
                        await launchUrl(uri);
                      },
                    ),

                    const SizedBox(height: 12),

                    // Hours Card
                    _ContactInfoCard(
                      icon: Icons.access_time,
                      iconColor: accentBlue,
                      title: 'Hours',
                      mainText: 'Monday – Friday: 9am – 5pm PST',
                      subText: 'Saturday – Sunday: Closed',
                      onTap: null,
                    ),

                    const SizedBox(height: 12),

                    // Licensing Information Card
                    _ContactInfoCard(
                      icon: Icons.verified_outlined,
                      iconColor: accentBlue,
                      title: 'Licensing Information',
                      mainText: 'DRE CE Sponsor ID: #1035',
                      subText: 'DRE Pre-License Sponsor: #S0199',
                      onTap: null,
                      stackOnNarrow: false,
                    ),

                    const SizedBox(height: 24),

                    // ✅ BLUE DIVIDER
                    Container(
                      height: 2,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.transparent, accentBlue, Colors.transparent],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ✅ CONTACT FORM SECTION - Card Design
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE0E5EB), width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title with icon (same layout behavior as Licensing Information)
                            LayoutBuilder(
                              builder: (context, titleConstraints) {
                                final isNarrowTitle = titleConstraints.maxWidth < 380;
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: isNarrowTitle ? 44 : 48,
                                      height: isNarrowTitle ? 44 : 48,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF0B1E2E),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Icon(
                                        Icons.send,
                                        color: accentBlue,
                                        size: isNarrowTitle ? 22 : 24,
                                      ),
                                    ),
                                    SizedBox(width: isNarrowTitle ? 10 : 12),
                                    Expanded(
                                      child: Text(
                                        'Send Us a Message',
                                        maxLines: 2,
                                        softWrap: true,
                                        overflow: TextOverflow.visible,
                                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                          color: primaryNavy,
                                          fontWeight: FontWeight.bold,
                                          fontSize: isNarrowTitle ? 16 : (isMobile ? 18 : 20),
                                          letterSpacing: 0,
                                          height: 1.15,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 24),

                            // Name and Email side by side on wider screens
                            LayoutBuilder(
                              builder: (context, constraints) {
                                final isWideEnough = constraints.maxWidth > 500;

                                if (isWideEnough) {
                                  return Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: _CustomTextField(
                                          label: 'Your name',
                                          hint: 'Jane Smith',
                                          controller: _nameController,
                                          validator: _requiredValidator,
                                          autovalidateMode: _hasAttemptedSubmit
                                              ? AutovalidateMode.onUserInteraction
                                              : AutovalidateMode.disabled,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: _CustomTextField(
                                          label: 'Your email',
                                          hint: 'jane@example.com',
                                          keyboardType: TextInputType.emailAddress,
                                          controller: _emailController,
                                          validator: _emailValidator,
                                          autovalidateMode: _hasAttemptedSubmit
                                              ? AutovalidateMode.onUserInteraction
                                              : AutovalidateMode.disabled,
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return Column(
                                    children: [
                                      _CustomTextField(
                                        label: 'Your name',
                                        hint: 'Jane Smith',
                                        controller: _nameController,
                                        validator: _requiredValidator,
                                        autovalidateMode: _hasAttemptedSubmit
                                            ? AutovalidateMode.onUserInteraction
                                            : AutovalidateMode.disabled,
                                      ),
                                      const SizedBox(height: 16),
                                      _CustomTextField(
                                        label: 'Your email',
                                        hint: 'jane@example.com',
                                        keyboardType: TextInputType.emailAddress,
                                        controller: _emailController,
                                        validator: _emailValidator,
                                        autovalidateMode: _hasAttemptedSubmit
                                            ? AutovalidateMode.onUserInteraction
                                            : AutovalidateMode.disabled,
                                      ),
                                    ],
                                  );
                                }
                              },
                            ),
                            const SizedBox(height: 16),

                            // Subject Field
                            _CustomTextField(
                              label: 'Subject',
                              hint: 'How can we help?',
                              controller: _subjectController,
                              validator: _requiredValidator,
                              autovalidateMode: _hasAttemptedSubmit
                                  ? AutovalidateMode.onUserInteraction
                                  : AutovalidateMode.disabled,
                            ),
                            const SizedBox(height: 16),

                            // Message Field
                            _CustomTextField(
                              label: 'Your message',
                              hint: 'Tell us more about your question...',
                              maxLines: 5,
                              controller: _messageController,
                              validator: _requiredValidator,
                              autovalidateMode: _hasAttemptedSubmit
                                  ? AutovalidateMode.onUserInteraction
                                  : AutovalidateMode.disabled,
                            ),
                            const SizedBox(height: 24),

                            // Submit Button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: _submitContactForm,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0B1E2E),
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  elevation: 0,
                                ),
                                icon: const Icon(Icons.send, size: 18, color: Colors.white),
                                label: Text(
                                  'SUBMIT',
                                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                );
              },
            ),
          ),

          const SizedBox(height: 22),

          // Footer
          const RelstoneFooter(),

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
/* CUSTOM FORM COMPONENTS */
/* ───────────────────────────────────────────────────────────── */

class _CustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  final int maxLines;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final AutovalidateMode autovalidateMode;

  const _CustomTextField({
    required this.label,
    required this.hint,
    this.controller,
    this.validator,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.autovalidateMode = AutovalidateMode.disabled,
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
        TextFormField(
          controller: controller,
          validator: validator,
          autovalidateMode: autovalidateMode,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: textMuted,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            errorStyle: const TextStyle(
              color: Colors.redAccent,
              fontSize: 12,
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
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.redAccent, width: 2),
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

class _ContactInfoCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String mainText;
  final String subText;
  final VoidCallback? onTap;
  final bool stackOnNarrow;

  const _ContactInfoCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.mainText,
    required this.subText,
    this.onTap,
    this.stackOnNarrow = false,
  });

  @override
  Widget build(BuildContext context) {
    const Color primaryNavy = Color(0xFF1A3A5C);
    const Color textDark = Color(0xFF1C2B3A);
    const Color textMuted = Color(0xFF6B7E92);

    final textContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: primaryNavy,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          mainText,
          style: TextStyle(
            color: onTap != null ? iconColor : textDark,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subText,
          style: const TextStyle(
            color: textMuted,
            fontSize: 13,
            fontStyle: FontStyle.italic,
            height: 1.4,
          ),
        ),
      ],
    );

    final cardContent = LayoutBuilder(
      builder: (context, constraints) {
        final shouldStack = stackOnNarrow && constraints.maxWidth < 380;

        final iconBox = Container(
          width: shouldStack ? 44 : 48,
          height: shouldStack ? 44 : 48,
          decoration: BoxDecoration(
            color: const Color(0xFF0B1E2E),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: shouldStack ? 22 : 24),
        );

        if (shouldStack) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              iconBox,
              const SizedBox(height: 10),
              textContent,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            iconBox,
            const SizedBox(width: 16),
            Expanded(child: textContent),
          ],
        );
      },
    );

    final container = Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E5EB), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: cardContent,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: container,
      );
    }

    return container;
  }
}
