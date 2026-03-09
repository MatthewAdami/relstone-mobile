import 'package:flutter/material.dart';

import '../config/api_config.dart';
import '../services/api_client.dart';
import '../services/auth_service.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  static const Color navBg = Color(0xFF0B1A2A);

  void _go(BuildContext context, String route, {Object? arguments}) {
    Navigator.popAndPushNamed(context, route, arguments: arguments);
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
              initiallyExpanded: true,
              children: [
                _NavItem(
                  title: "Select a State",
                  onTap: () => _go(context, "/states"),
                ),
                _StatesDropdownPanel(
                  onSelectState: (slug) {
                    Navigator.of(context).pop();
                    Navigator.of(context, rootNavigator: true).pushNamed(
                      '/insurance-state',
                      arguments: slug,
                    );
                  },
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

            _NavItem(
              title: "Log out",
              color: Colors.redAccent,
              onTap: () async {
                Navigator.pop(context);
                await AuthService.logout();
                Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
              },
            ),

            const SizedBox(height: 10),
            const Divider(color: Colors.white12, height: 1),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 18),
              child: Text(
                '© 2026 Relstone. All rights reserved.',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavExpansion extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final bool initiallyExpanded;

  const _NavExpansion({
    required this.title,
    required this.children,
    this.initiallyExpanded = false,
  });

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
        iconColor: Colors.white60,
        collapsedIconColor: Colors.white60,
        initiallyExpanded: initiallyExpanded,
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14.5,
          ),
        ),
        children: children,
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final Color color;

  const _NavItem({
    required this.title,
    this.onTap,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      title: Text(
        title,
        style: TextStyle(
          color: color,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: onTap,
    );
  }
}

class _StatesDropdownPanel extends StatefulWidget {
  final Function(String slug)? onSelectState;

  const _StatesDropdownPanel({this.onSelectState});

  @override
  State<_StatesDropdownPanel> createState() => _StatesDropdownPanelState();
}

class _StatesDropdownPanelState extends State<_StatesDropdownPanel> {
  List<Map<String, dynamic>> _states = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchStatesInBackground();
  }

  Future<void> _fetchStatesInBackground() async {
    setState(() {
      _loading = true;
      _states = [];
    });

    try {
      final result = await _fetchStates();
      setState(() {
        _states = result;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _states = [];
        _loading = false;
      });
    }
  }

  Future<List<Map<String, dynamic>>> _fetchStates() async {
    try {
      final response = await ApiClient.get(ApiConfig.insuranceStates);
      final statusCode = response['statusCode'] as int? ?? 500;
      final data = response['data'] as Map<String, dynamic>? ?? {};

      if (statusCode < 200 || statusCode >= 300) {
        throw Exception(data['message']?.toString() ?? 'Failed to load states');
      }

        // Support both API shapes:
        // - { states: [...] }  (current backend)
        // - { data: [...] }    (legacy clients)
        final rawStates = (data['states'] as List<dynamic>?) ??
          (data['data'] as List<dynamic>?) ??
          const [];
      return rawStates
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    } catch (err) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              color: Colors.white60,
              strokeWidth: 2,
            ),
          ),
        ),
      );
    }

    if (_states.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(12.0),
        child: Text(
          'No states available.',
          style: TextStyle(color: Colors.white60, fontSize: 12),
        ),
      );
    }

    return Column(
      children: _states.map((state) {
        final name = (state['name'] ?? '').toString();
        final slug = (state['slug'] ?? '').toString();

        return ListTile(
          dense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 24),
          title: Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          onTap: () {
            if (widget.onSelectState != null) {
              widget.onSelectState!(slug);
            }
          },
        );
      }).toList(),
    );
  }
}
