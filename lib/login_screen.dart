import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../config/api_config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// ── Auth Service ──────────────────────────────────────────────────────────────
class AuthService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId: '1014271969521-ja4r7himsc6aoujf6djusu994fi4t3gj.apps.googleusercontent.com',
    scopes: ['email', 'profile'],
    forceCodeForRefreshToken: true, // ← forces account picker
  );

  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(ApiConfig.login),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
      await prefs.setString('user', jsonEncode(data['user']));
      return {'success': true, 'user': data['user']};
    } else if (response.statusCode == 403 && data['needsVerification'] == true) {
      return {
        'success': false,
        'needsVerification': true,
        'userId': data['userId'],
        'message': data['message'],
      };
    } else {
      return {
        'success': false,
        'message': data['message'] ?? 'Login failed. Please try again.',
      };
    }
  }

  static Future<Map<String, dynamic>> loginWithGoogle() async {
    try {
      // ── Force account picker every time ──────────────
      await _googleSignIn.disconnect().catchError((_) {});
      await _googleSignIn.signOut();

      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account == null) return {'success': false, 'cancelled': true};

      final GoogleSignInAuthentication auth = await account.authentication;
      final String? idToken = auth.idToken;
      if (idToken == null) return {'success': false, 'message': 'Failed to get Google token'};

      final response = await http.post(
        Uri.parse(ApiConfig.googleMobile),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'idToken': idToken}),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['token'] != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        await prefs.setString('user', jsonEncode(data['user']));
        return {'success': true, 'user': data['user'], 'token': data['token']};
      }
      return {'success': false, 'message': data['message'] ?? 'Google sign-in failed'};
    } catch (e) {
      return {'success': false, 'message': 'Google sign-in error: $e'};
    }
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');
    await _googleSignIn.disconnect().catchError((_) {});
    await _googleSignIn.signOut();
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userStr = prefs.getString('user');
    if (userStr == null) return null;
    return jsonDecode(userStr);
  }
}

// ── Login Screen ──────────────────────────────────────────────────────────────
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _googleLoading = false;
  String? _errorMessage;

  static const Color primaryNavy = Color(0xFF1A3A5C);
  static const Color accentBlue  = Color(0xFF2E7EBE);
  static const Color borderGray  = Color(0xFFDDE2EA);
  static const Color textDark    = Color(0xFF1C2B3A);
  static const Color textMuted   = Color(0xFF6B7E92);
  static const Color errorRed    = Color(0xFFE05252);

  late final AnimationController _animController;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnim =
        CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim =
        Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero).animate(
            CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _navigateToHome(Map<String, dynamic> user, String token) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/homescreen',
      (route) => false,
      arguments: {'user': user, 'token': token},
    );
  }

  // ── Email/password login ──────────────────────────────────
  void _handleLogin() async {
    setState(() => _errorMessage = null);
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final result = await AuthService.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      if (!mounted) return;
      setState(() => _isLoading = false);

      if (result['success'] == true) {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token') ?? '';
        final user =
            jsonDecode(prefs.getString('user') ?? '{}') as Map<String, dynamic>;
        if (!mounted) return;
        _navigateToHome(user, token);
        return;
      }
      if (result['needsVerification'] == true) {
        Navigator.pushNamed(context, '/verify-email', arguments: {
          'userId': result['userId']?.toString(),
          'email': _emailController.text.trim(),
        });
        return;
      }
      setState(() => _errorMessage = result['message'] ?? 'Login failed.');
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'Cannot connect to server. Check API URL & internet.';
      });
    }
  }

  // ── Google login ──────────────────────────────────────────
  void _handleGoogleLogin() async {
    setState(() {
      _googleLoading = true;
      _errorMessage = null;
    });
    try {
      final result = await AuthService.loginWithGoogle();
      if (!mounted) return;
      setState(() => _googleLoading = false);

      if (result['cancelled'] == true) return;

      if (result['success'] == true) {
        _navigateToHome(
          result['user'] as Map<String, dynamic>,
          result['token'] as String,
        );
        return;
      }
      setState(
          () => _errorMessage = result['message'] ?? 'Google sign-in failed.');
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _googleLoading = false;
        _errorMessage = 'Google sign-in error: $e';
      });
    }
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
              Color(0xFFE8EEF5)
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 420,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              color: primaryNavy.withOpacity(0.08),
                              blurRadius: 40,
                              offset: const Offset(0, 12)),
                          BoxShadow(
                              color: primaryNavy.withOpacity(0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 2)),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Top accent bar
                          Container(
                            height: 5,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                              gradient: LinearGradient(
                                  colors: [primaryNavy, accentBlue]),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(40, 40, 40, 44),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Logo
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 20),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF7F9FC),
                                      borderRadius:
                                          BorderRadius.circular(12),
                                      border: Border.all(
                                          color: borderGray, width: 1),
                                    ),
                                    child: Image.asset(
                                      'assets/relstone_logo.png',
                                      height: 100,
                                      fit: BoxFit.contain,
                                      errorBuilder: (_, __, ___) =>
                                          _buildTextLogo(),
                                    ),
                                  ),
                                  const SizedBox(height: 28),

                                  const Text('Welcome Back',
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w700,
                                          color: textDark,
                                          letterSpacing: -0.3)),
                                  const SizedBox(height: 6),
                                  const Text(
                                      'Sign in to your Relstone account',
                                      style: TextStyle(
                                          fontSize: 14, color: textMuted)),
                                  const SizedBox(height: 32),

                                  // Error banner
                                  if (_errorMessage != null) ...[
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14, vertical: 12),
                                      decoration: BoxDecoration(
                                        color: errorRed.withOpacity(0.08),
                                        borderRadius:
                                            BorderRadius.circular(10),
                                        border: Border.all(
                                            color:
                                                errorRed.withOpacity(0.3)),
                                      ),
                                      child: Row(children: [
                                        const Icon(
                                            Icons.error_outline_rounded,
                                            color: errorRed,
                                            size: 18),
                                        const SizedBox(width: 10),
                                        Expanded(
                                            child: Text(_errorMessage!,
                                                style: const TextStyle(
                                                    fontSize: 13,
                                                    color: errorRed,
                                                    fontWeight:
                                                        FontWeight.w500))),
                                      ]),
                                    ),
                                    const SizedBox(height: 20),
                                  ],

                                  // Email
                                  _buildLabel('Email Address'),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _emailController,
                                    keyboardType:
                                        TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                    style: const TextStyle(
                                        fontSize: 14, color: textDark),
                                    decoration: _inputDecoration(
                                        hint: 'you@example.com',
                                        icon: Icons.mail_outline_rounded),
                                    onChanged: (_) {
                                      if (_errorMessage != null)
                                        setState(
                                            () => _errorMessage = null);
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty)
                                        return 'Please enter your email';
                                      if (!RegExp(
                                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                          .hasMatch(value))
                                        return 'Enter a valid email';
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 20),

                                  // Password
                                  _buildLabel('Password'),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _passwordController,
                                    obscureText: _obscurePassword,
                                    textInputAction: TextInputAction.done,
                                    onFieldSubmitted: (_) => _handleLogin(),
                                    style: const TextStyle(
                                        fontSize: 14, color: textDark),
                                    decoration: _inputDecoration(
                                            hint: '••••••••',
                                            icon: Icons.lock_outline_rounded)
                                        .copyWith(
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscurePassword
                                              ? Icons.visibility_off_outlined
                                              : Icons.visibility_outlined,
                                          color: textMuted,
                                          size: 20,
                                        ),
                                        onPressed: () => setState(() =>
                                            _obscurePassword =
                                                !_obscurePassword),
                                      ),
                                    ),
                                    onChanged: (_) {
                                      if (_errorMessage != null)
                                        setState(
                                            () => _errorMessage = null);
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty)
                                        return 'Please enter your password';
                                      if (value.length < 6)
                                        return 'Password must be at least 6 characters';
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 12),

                                  // Forgot password
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () => Navigator.pushNamed(
                                          context, '/forgot-password'),
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        minimumSize: Size.zero,
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: const Text('Forgot password?',
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: accentBlue,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                  ),
                                  const SizedBox(height: 28),

                                  // Sign In button
                                  SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: ElevatedButton(
                                      onPressed:
                                          _isLoading ? null : _handleLogin,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: primaryNavy,
                                        foregroundColor: Colors.white,
                                        disabledBackgroundColor:
                                            primaryNavy.withOpacity(0.6),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                      ),
                                      child: _isLoading
                                          ? const SizedBox(
                                              width: 22,
                                              height: 22,
                                              child: CircularProgressIndicator(
                                                  strokeWidth: 2.5,
                                                  color: Colors.white))
                                          : const Text('Sign In',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 0.3)),
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  // OR divider
                                  Row(children: [
                                    const Expanded(
                                        child: Divider(color: borderGray)),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      child: Text('or',
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey.shade500)),
                                    ),
                                    const Expanded(
                                        child: Divider(color: borderGray)),
                                  ]),
                                  const SizedBox(height: 16),

                                  // Google Sign-In button
                                  SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: OutlinedButton(
                                      onPressed: (_googleLoading ||
                                              _isLoading)
                                          ? null
                                          : _handleGoogleLogin,
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(
                                            color: borderGray),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        backgroundColor: Colors.white,
                                      ),
                                      child: _googleLoading
                                          ? const SizedBox(
                                              width: 22,
                                              height: 22,
                                              child: CircularProgressIndicator(
                                                  strokeWidth: 2.5,
                                                  color: primaryNavy))
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 22,
                                                  height: 22,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                    border: Border.all(
                                                        color: borderGray),
                                                  ),
                                                  child: const Center(
                                                    child: Text('G',
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: Color(
                                                              0xFFDB4437),
                                                        )),
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                const Text(
                                                    'Continue with Google',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: textDark)),
                                              ],
                                            ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),

                                  // Register link
                                  Wrap(
                                    alignment: WrapAlignment.center,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      const Text("Don't have an account? ",
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: textMuted)),
                                      GestureDetector(
                                        onTap: () => Navigator.pushNamed(
                                            context, '/signup'),
                                        child: const Text('Create one',
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: accentBlue,
                                                fontWeight:
                                                    FontWeight.w600)),
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
                    const Text(
                        '© 2026 Relstone Real Estate License Services',
                        style: TextStyle(
                            fontSize: 12, color: Color(0xFF8FA3B8))),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(text,
          style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: textDark,
              letterSpacing: 0.1)),
    );
  }

  InputDecoration _inputDecoration(
      {required String hint, required IconData icon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle:
          const TextStyle(color: Color(0xFFB0BCC9), fontSize: 14),
      prefixIcon: Icon(icon, color: const Color(0xFF8FA3B8), size: 20),
      filled: true,
      fillColor: const Color(0xFFF7F9FC),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderGray)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderGray)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: accentBlue, width: 1.5)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorRed)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorRed, width: 1.5)),
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
              borderRadius: BorderRadius.circular(8)),
          child: const Center(
              child: Text('R',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold))),
        ),
        const SizedBox(width: 10),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('RELSTONE',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: primaryNavy,
                    letterSpacing: 1.5)),
            Text('Real Estate License Services',
                style: TextStyle(
                    fontSize: 9,
                    color: textMuted,
                    letterSpacing: 0.5)),
          ],
        ),
      ],
    );
  }
}