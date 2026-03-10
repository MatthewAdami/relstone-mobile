import 'package:flutter/material.dart';
import 'package:relstone_mobile/my_courses_screen.dart';
import 'package:relstone_mobile/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../services/cart_service.dart';


class MainLayout extends StatefulWidget {
  final Widget body;
  final Widget? drawer;
  final String? title;

  const MainLayout({
    super.key,
    required this.body,
    this.drawer,
    this.title,
  });

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  static const Color primaryNavy = Color(0xFF1A3A5C);
  static const Color bg          = Color(0xFFF4F6F9);

  Map<String, dynamic>? _user;
  String? _token;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadUser();
    // Also try from route arguments
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map<String, dynamic>) {
      _user  = args['user']  as Map<String, dynamic>?;
      _token = args['token'] as String?;
    }
  }

  Future<void> _loadUser() async {
    final prefs   = await SharedPreferences.getInstance();
    final token   = prefs.getString('token');
    final userStr = prefs.getString('user');
    if (userStr != null && token != null && mounted) {
      setState(() {
        _token = token;
        _user  = jsonDecode(userStr) as Map<String, dynamic>;
      });
    }
  }

  String get _userName => (_user?['name'] ?? _user?['email'] ?? 'User').toString();
  String get _studentId =>
      (_user?['studentId'] ?? _user?['_id'] ?? _user?['id'] ?? '').toString();

  String get _initials {
    final name  = _userName.trim();
    final parts = name.split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }

  void _showProfileSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ProfileSheet(
        user:      _user      ?? {},
        token:     _token     ?? '',
        studentId: _studentId,
        onLogout:  _logout,
      ),
    );
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      drawer: widget.drawer,
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
            style: TextStyle(
              color: primaryNavy,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
        ),
        actions: [
          // ── Cart icon ──────────────────────────────────────
          ListenableBuilder(
            listenable: CartService.instance,
            builder: (context, _) {
              final count = CartService.instance.cartCount;
              return Badge(
                label: Text('$count'),
                isLabelVisible: count > 0,
                child: IconButton(
                  tooltip: 'Cart',
                  onPressed: () => Navigator.pushNamed(context, '/cart'),
                  icon: const Icon(Icons.shopping_cart_outlined, color: primaryNavy),
                ),
              );
            },
          ),

          // ── Profile avatar ─────────────────────────────────
          Padding(
            padding: const EdgeInsets.only(right: 12, left: 4),
            child: GestureDetector(
              onTap: _showProfileSheet,
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
      body: widget.body,
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  PROFILE BOTTOM SHEET  (same as HomeScreen)
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
              decoration: BoxDecoration(
                  color: _border, borderRadius: BorderRadius.circular(99)),
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
                Container(
                  width: 58, height: 58,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Colors.white.withOpacity(0.4), width: 2),
                  ),
                  child: Center(
                    child: Text(_initials,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_name,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w700),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 3),
                      Text(_email,
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      if (studentId.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.25)),
                          ),
                          child: Text('ID: $studentId',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5)),
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
                _menuTile(
                  context,
                  icon: Icons.school_rounded,
                  iconBg: const Color(0xFFEFF6FF),
                  iconColor: _blue,
                  title: 'My Courses',
                  subtitle: 'View enrolled courses & take exams',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(
                            builder: (_) => const MyCoursesScreen()));
                  },
                ),
                const SizedBox(height: 8),
                _menuTile(
                  context,
                  icon: Icons.person_rounded,
                  iconBg: const Color(0xFFF0FDF4),
                  iconColor: _green,
                  title: 'My Profile',
                  subtitle: 'Personal info, license & order history',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(
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
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _red)),
            subtitle: const Text('Log out of your account',
                style: TextStyle(fontSize: 12, color: _muted)),
            trailing:
                const Icon(Icons.chevron_right_rounded, color: _muted, size: 20),
            onTap: () async {
              Navigator.pop(context);
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              if (context.mounted) {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/login', (_) => false);
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
                decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF111827))),
                    const SizedBox(height: 2),
                    Text(subtitle,
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xFF6B7280))),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded,
                  color: Color(0xFF6B7280), size: 20),
            ],
          ),
        ),
      ),
    );
  }
}