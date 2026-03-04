import 'package:flutter/material.dart';
import 'services/auth_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _agreedToPrivacy = false;
  bool _showPrivacyError = false;

  // Relstone brand colors
  static const Color primaryNavy = Color(0xFF1A3A5C);
  static const Color accentBlue = Color(0xFF2E7EBE);
  static const Color borderGray = Color(0xFFDDE2EA);
  static const Color textDark = Color(0xFF1C2B3A);
  static const Color textMuted = Color(0xFF6B7E92);

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Show Data Privacy Policy Popup
  void _showPrivacyDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: 500,
            constraints: const BoxConstraints(maxHeight: 600),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    gradient: LinearGradient(
                      colors: [primaryNavy, accentBlue],
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.privacy_tip_outlined,
                          color: Colors.white, size: 24),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'Data Privacy Policy',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close,
                            color: Colors.white, size: 20),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),

                // Content
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _privacySection(
                          icon: Icons.info_outline_rounded,
                          title: 'Introduction',
                          content:
                              'Relstone Real Estate License Services ("Relstone", "we", "us", or "our") is committed to protecting your personal data. This policy explains how we collect, use, and safeguard your information when you create an account and use our services.',
                        ),
                        _privacySection(
                          icon: Icons.data_usage_outlined,
                          title: 'Data We Collect',
                          content:
                              'We collect personal information including your full name, email address, phone number, and password. This information is necessary to create and manage your Relstone account and deliver our services to you.',
                        ),
                        _privacySection(
                          icon: Icons.verified_user_outlined,
                          title: 'Purpose of Collection',
                          content:
                              'Your data is collected for the following purposes:\n• Account creation and authentication\n• Communication regarding your license applications\n• Sending service notifications and updates\n• Improving our platform and user experience\n• Compliance with applicable legal requirements',
                        ),
                        _privacySection(
                          icon: Icons.share_outlined,
                          title: 'Data Sharing',
                          content:
                              'We do not sell, trade, or transfer your personal data to third parties without your consent, except as required by applicable law or to trusted service partners who assist in operating our platform under strict confidentiality agreements.',
                        ),
                        _privacySection(
                          icon: Icons.lock_outline_rounded,
                          title: 'Data Security',
                          content:
                              'We implement industry-standard security measures including encryption, secure servers, and access controls to protect your personal data against unauthorized access, alteration, disclosure, or destruction.',
                        ),
                        _privacySection(
                          icon: Icons.storage_outlined,
                          title: 'Data Retention',
                          content:
                              'We retain your personal data only for as long as necessary to fulfill the purposes outlined in this policy or as required by law. You may request deletion of your account and associated data at any time.',
                        ),
                        _privacySection(
                          icon: Icons.gavel_outlined,
                          title: 'Your Rights',
                          content:
                              'You have the following rights regarding your personal data:\n• Access — request a copy of your data\n• Correction — update inaccurate information\n• Deletion — request removal of your data\n• Portability — receive your data in a portable format\n• Objection — opt out of certain data processing activities',
                        ),
                        _privacySection(
                          icon: Icons.cookie_outlined,
                          title: 'Cookies & Tracking',
                          content:
                              'We may use cookies and similar technologies to enhance your experience, analyze usage patterns, and improve our services. You can manage cookie preferences through your device or browser settings.',
                        ),
                        _privacySection(
                          icon: Icons.update_outlined,
                          title: 'Policy Updates',
                          content:
                              'We may update this privacy policy from time to time. We will notify you of any significant changes via email or a prominent notice within the app. Continued use of our services after changes constitutes acceptance of the updated policy.',
                        ),
                        _privacySection(
                          icon: Icons.contact_mail_outlined,
                          title: 'Contact Us',
                          content:
                              'If you have any questions or concerns about this privacy policy or how we handle your data, please contact us at privacy@relstone.com.',
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),

                // Footer buttons
                Container(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Color(0xFFDDE2EA)),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: borderGray),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding:
                                const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text(
                            'Close',
                            style: TextStyle(
                              color: textMuted,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _agreedToPrivacy = true;
                              _showPrivacyError = false;
                            });
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryNavy,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding:
                                const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text(
                            'I Agree',
                            style: TextStyle(fontWeight: FontWeight.w600),
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
      },
    );
  }

  Widget _privacySection({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: accentBlue, size: 18),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: primaryNavy,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 26),
            child: Text(
              content,
              style: const TextStyle(
                fontSize: 13,
                color: textMuted,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Register then go to Verify Email (matches your backend)
  Future<void> _handleSignUp() async {
    final isFormValid = _formKey.currentState!.validate();

    if (!_agreedToPrivacy) {
      setState(() => _showPrivacyError = true);
    }
    if (!isFormValid || !_agreedToPrivacy) return;

    setState(() => _isLoading = true);

    final result = await AuthService.register(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result['success'] == true) {
      // ✅ Always go to verify-email after signup
      Navigator.pushNamed(
        context,
        '/verify-email',
        arguments: {
          'userId': result['userId'],
          'email': _emailController.text.trim(),
        },
      );
      return;
    }

    final msg = (result['message'] ?? 'Registration failed').toString();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFEEF2F7),
              Color(0xFFF8FAFC),
              Color(0xFFE8EEF5),
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Sign Up Card
                Container(
                  width: 460,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: primaryNavy.withOpacity(0.08),
                        blurRadius: 40,
                        offset: const Offset(0, 12),
                      ),
                      BoxShadow(
                        color: primaryNavy.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Top gradient accent bar
                      Container(
                        height: 5,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          gradient: LinearGradient(
                            colors: [primaryNavy, accentBlue],
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(40, 40, 40, 44),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // ── LOGO ──
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 20),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF7F9FC),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: borderGray, width: 1),
                                ),
                                child: Image.asset(
                                  'assets/relstone_logo.png',
                                  height: 100,
                                  fit: BoxFit.contain,
                                  errorBuilder:
                                      (context, error, stackTrace) =>
                                          _buildTextLogo(),
                                ),
                              ),

                              const SizedBox(height: 28),

                              // Heading
                              const Text(
                                'Create Account',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: textDark,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'Join Relstone Real Estate License Services',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: textMuted,
                                ),
                              ),

                              const SizedBox(height: 32),

                              // ── First Name ──
                              _buildLabel('First Name'),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _firstNameController,
                                style: const TextStyle(
                                    fontSize: 14, color: textDark),
                                decoration: _inputDecoration(
                                  hint: 'John',
                                  icon: Icons.person_outline_rounded,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your first name';
                                  }
                                  if (value.length < 2) {
                                    return 'First name must be at least 2 characters';
                                  }
                                  final nameRegex = RegExp(r"^[a-zA-Z\s'-]+$");
                                  if (!nameRegex.hasMatch(value)) {
                                    return 'First name must contain letters only';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 20),

                              // ── Last Name ──
                              _buildLabel('Last Name'),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _lastNameController,
                                style: const TextStyle(
                                    fontSize: 14, color: textDark),
                                decoration: _inputDecoration(
                                  hint: 'Doe',
                                  icon: Icons.person_outline_rounded,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your last name';
                                  }
                                  if (value.length < 2) {
                                    return 'Last name must be at least 2 characters';
                                  }
                                  final nameRegex = RegExp(r"^[a-zA-Z\s'-]+$");
                                  if (!nameRegex.hasMatch(value)) {
                                    return 'Last name must contain letters only';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 20),

                              // ── Email ──
                              _buildLabel('Email Address'),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                style: const TextStyle(
                                    fontSize: 14, color: textDark),
                                decoration: _inputDecoration(
                                  hint: 'you@example.com',
                                  icon: Icons.mail_outline_rounded,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  final emailRegex = RegExp(
                                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                                  if (!emailRegex.hasMatch(value)) {
                                    return 'Enter a valid email (e.g. name@example.com)';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 20),

                              // ── Password ──
                              _buildLabel('Password'),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                style: const TextStyle(
                                    fontSize: 14, color: textDark),
                                decoration: _inputDecoration(
                                  hint: '••••••••',
                                  icon: Icons.lock_outline_rounded,
                                ).copyWith(
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: textMuted,
                                      size: 20,
                                    ),
                                    onPressed: () => setState(() =>
                                        _obscurePassword = !_obscurePassword),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a password';
                                  }
                                  if (value.length < 8) {
                                    return 'Password must be at least 8 characters';
                                  }
                                  if (!RegExp(r'[A-Z]').hasMatch(value)) {
                                    return 'Password must have at least 1 uppercase letter';
                                  }
                                  if (!RegExp(r'[0-9]').hasMatch(value)) {
                                    return 'Password must have at least 1 number';
                                  }
                                  if (!RegExp(r'[!@#\$&*~%^()_\-+=]')
                                      .hasMatch(value)) {
                                    return 'Password must have at least 1 special character';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 20),

                              // ── Data Privacy Checkbox ──
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: _showPrivacyError
                                      ? const Color(0xFFFFF0F0)
                                      : _agreedToPrivacy
                                          ? const Color(0xFFF0F7FF)
                                          : const Color(0xFFF7F9FC),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: _showPrivacyError
                                        ? const Color(0xFFE05252)
                                        : _agreedToPrivacy
                                            ? accentBlue
                                            : borderGray,
                                    width: 1.5,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 22,
                                          height: 22,
                                          child: Checkbox(
                                            value: _agreedToPrivacy,
                                            onChanged: (value) {
                                              setState(() {
                                                _agreedToPrivacy =
                                                    value ?? false;
                                                if (_agreedToPrivacy) {
                                                  _showPrivacyError = false;
                                                }
                                              });
                                            },
                                            activeColor: primaryNavy,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            materialTapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Wrap(
                                            children: [
                                              const Text(
                                                'I have read and agree to the ',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: textMuted,
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: _showPrivacyDialog,
                                                child: const Text(
                                                  'Data Privacy Policy',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: accentBlue,
                                                    fontWeight: FontWeight.w600,
                                                    decoration: TextDecoration
                                                        .underline,
                                                  ),
                                                ),
                                              ),
                                              const Text(
                                                ' of Relstone Real Estate License Services.',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: textMuted,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (_showPrivacyError)
                                      const Padding(
                                        padding: EdgeInsets.only(
                                            top: 8, left: 32),
                                        child: Text(
                                          'You must agree to the Data Privacy Policy to continue',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFFE05252),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 24),

                              // ── Sign Up Button ──
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed:
                                      _isLoading ? null : _handleSignUp,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryNavy,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: _isLoading
                                      ? const SizedBox(
                                          width: 22,
                                          height: 22,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Text(
                                          'Create Account',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.3,
                                          ),
                                        ),
                                ),
                              ),

                              const SizedBox(height: 24),

                              // Divider
                              Row(
                                children: [
                                  const Expanded(
                                      child: Divider(color: borderGray)),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: Text(
                                      'or',
                                      style: TextStyle(
                                          fontSize: 13, color: textMuted),
                                    ),
                                  ),
                                  const Expanded(
                                      child: Divider(color: borderGray)),
                                ],
                              ),

                              const SizedBox(height: 20),

                              // ── Login link ──
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Already have an account? ',
                                    style: TextStyle(
                                        fontSize: 13, color: textMuted),
                                  ),
                                  GestureDetector(
                                    onTap: () => Navigator.pop(context),
                                    child: const Text(
                                      'Sign In',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: accentBlue,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // Footer
                const Text(
                  '© 2026 Relstone Real Estate License Services',
                  style: TextStyle(fontSize: 12, color: Color(0xFF8FA3B8)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: textDark,
          letterSpacing: 0.1,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({required String hint, required IconData icon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFFB0BCC9), fontSize: 14),
      prefixIcon: Icon(icon, color: const Color(0xFF8FA3B8), size: 20),
      filled: true,
      fillColor: const Color(0xFFF7F9FC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: borderGray),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: borderGray),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: accentBlue, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE05252)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE05252), width: 1.5),
      ),
    );
  }

  Widget _buildTextLogo() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: primaryNavy,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: Text(
              'R',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'RELSTONE',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: primaryNavy,
                letterSpacing: 1.5,
              ),
            ),
            Text(
              'Real Estate License Services',
              style: TextStyle(
                fontSize: 9,
                color: textMuted,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ],
    );
  }
}