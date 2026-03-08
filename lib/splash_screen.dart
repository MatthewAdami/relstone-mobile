import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _fadeAnim;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );

    _scaleAnim = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutBack),
    );

    _animController.forward();
    _checkAuth();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _checkAuth() async {
    // Wait for animation + minimum splash time
    await Future.delayed(const Duration(milliseconds: 1800));

    if (!mounted) return;

    final prefs   = await SharedPreferences.getInstance();
    final token   = prefs.getString('token');
    final userStr = prefs.getString('user');

    if (token != null && userStr != null) {
      // ✅ Token found — auto login, go to HomeScreen
      Map<String, dynamic>? user;
      try {
        user = jsonDecode(userStr) as Map<String, dynamic>;
      } catch (_) {
        user = null;
      }

      if (!mounted) return;

      Navigator.pushReplacementNamed(
        context,
        '/homescreen',
        arguments: {
          'user':  user,
          'token': token,
        },
      );
    } else {
      // ❌ No token — go to login
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1A2A),
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: ScaleTransition(
            scale: _scaleAnim,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Logo / Icon ───────────────────────────
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A3A5C),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF2E7EBE).withOpacity(0.3),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/relstone_logo.png',
                      width: 60,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Text(
                        'R',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 42,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // ── Brand Name ────────────────────────────
                const Text(
                  'RELSTONE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 4,
                  ),
                ),

                const SizedBox(height: 6),

                // ── Tagline ───────────────────────────────
                const Text(
                  'Real Estate License Services',
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.5,
                  ),
                ),

                const SizedBox(height: 48),

                // ── Loading Indicator ─────────────────────
                SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: const Color(0xFF2E7EBE).withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}