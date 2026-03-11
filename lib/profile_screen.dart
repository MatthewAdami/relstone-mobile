import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:relstone_mobile/config/api_config.dart';

// ─── Theme Constants ──────────────────────────────────────────────────
const Color kNavy = Color(0xFF1A3A5C);
const Color kNavyDark = Color(0xFF0B1A2A);
const Color kRedLight = Color(0xFFFDF0EF);
const Color kRedBorder = Color(0xFFF5C6C2);
const Color kDark = Color(0xFF1C2B3A);
const Color kGrey = Color(0xFF6B7E92);
const Color kGreyLight = Color(0xFFF4F6F9);
const Color kGreyBg = Color(0xFFF7F9FC);
const Color kBorder = Color(0xFFDDE2EA);
const Color kGreen = Color(0xFF16A34A);
const Color kGreenLight = Color(0xFFEFFAF2);

class ProfileScreen extends StatefulWidget {
  final String studentId;
  final String token;
  final Map<String, dynamic>? user;

  const ProfileScreen({
    super.key,
    required this.studentId,
    required this.token,
    this.user,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  Map<String, dynamic>? _student;
  List<dynamic> _orders = [];
  List<dynamic> _courses = [];
  bool _isLoading = true;
  bool _isSavingProfile = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    if (widget.user != null) _student = widget.user;
    _fetchStudent();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ── UPDATED: debug prints + studentId guard ───────────────────────
  Future<void> _fetchStudent() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _error = '';
    });

    // ✅ Guard — stop early if no studentId
    if (widget.studentId.isEmpty) {
      if (!mounted) return;
      setState(() {
        _error =
            'No student ID linked to this account.\nAsk admin to link your account.';
        _isLoading = false;
      });
      return;
    }

    try {
      final url = ApiConfig.studentProfile(widget.studentId);

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _student = data;
          _orders = data['orders'] ?? [];
          _courses = data['courses'] ?? [];
        });
      } else {
        setState(() {
          _error =
              'Failed to load profile (${response.statusCode}).\n${response.body}';
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Connection failed: $e';
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  String get _name =>
      (_student?['name'] ?? widget.user?['name'] ?? 'User').toString();
  String get _email =>
      (_student?['email'] ?? widget.user?['email'] ?? '').toString();
  String get _studentId =>
      (_student?['studentId'] ?? widget.user?['studentId'] ?? '').toString();

  Map<String, dynamic> get _profileData => {...?widget.user, ...?_student};

  String get _initials {
    final parts = _name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return _name.isNotEmpty ? _name[0].toUpperCase() : 'U';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kGreyLight,
      body: _isLoading && _student == null
          ? const Center(child: CircularProgressIndicator(color: kNavy))
          : _error.isNotEmpty && _student == null
          ? _buildError()
          : _buildContent(),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
            const SizedBox(height: 12),
            Text(
              _error,
              style: const TextStyle(fontSize: 14, color: kGrey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _fetchStudent,
              style: ElevatedButton.styleFrom(
                backgroundColor: kNavy,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Retry', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return NestedScrollView(
      headerSliverBuilder: (context, _) => [
        _buildSliverAppBar(),
        _buildTabBar(),
      ],
      body: TabBarView(
        controller: _tabController,
        children: [_buildInfoTab(), _buildCoursesTab(), _buildOrdersTab()],
      ),
    );
  }

  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 240,
      pinned: true,
      backgroundColor: kNavy,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 18),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: _isSavingProfile
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.edit_outlined, color: Colors.white, size: 20),
          onPressed: _isSavingProfile ? null : _showEditProfileSheet,
          tooltip: 'Edit Profile',
        ),
        IconButton(
          icon: const Icon(Icons.refresh, color: Colors.white, size: 20),
          onPressed: _fetchStudent,
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [kNavyDark, kNavy, Color(0xFF1A4A6C)],
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 48),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.5),
                      width: 2.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      _initials,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _email,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
                if (_studentId.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.25)),
                    ),
                    child: Text(
                      'ID: $_studentId',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                if (_isLoading) ...[
                  const SizedBox(height: 8),
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      color: Colors.white70,
                      strokeWidth: 2,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  SliverPersistentHeader _buildTabBar() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _TabBarDelegate(
        TabBar(
          controller: _tabController,
          labelColor: kNavy,
          unselectedLabelColor: kGrey,
          indicatorColor: kNavy,
          indicatorWeight: 2.5,
          labelStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(fontSize: 13),
          tabs: [
            const Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person_outline, size: 15),
                  SizedBox(width: 5),
                  Text('Info'),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.school_outlined, size: 15),
                  const SizedBox(width: 5),
                  Text('Courses (${_courses.length})'),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.receipt_outlined, size: 15),
                  const SizedBox(width: 5),
                  Text('Orders (${_orders.length})'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTab() {
    final s = _profileData;
    final fullName =
        _present(_firstNonEmpty(s, const ['name'])) ??
        [
          _present(_firstNonEmpty(s, const ['firstName', 'first_name'])),
          _present(_firstNonEmpty(s, const ['lastName', 'last_name'])),
        ].where((part) => part != null && part.toString().isNotEmpty).join(' ');
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSection('Personal Information', [
            _row('Student ID', s['studentId']),
            _row('Full Name', fullName),
            _row('Email', s['email']),
            _row('Mobile Phone', s['mobilePhone']),
            _row('Work Phone', s['workPhone']),
            _row('Home Phone', s['homePhone']),
          ]),
          const SizedBox(height: 14),
          _buildSection('Address', [
            _row('Street Address', s['streetAddress']),
            _row('City', s['city']),
            _row('State', s['state']),
            _row('Postal Code', s['postalCode']),
            _row('Mailing Address', s['mailingAddress']),
          ]),
          const SizedBox(height: 14),
          _buildSection('License & Identification', [
            _row('DRE Number', s['dreNumber']),
            _row('NMLS ID', s['nmlsId']),
            _row('License Number', s['licenseNumber']),
            _row('CFP Number', s['cfpNumber']),
            _row('NPN Number', s['npnNumber']),
            _row('Company', s['companyName']),
          ]),
          const SizedBox(height: 14),
          _buildSection('Account Details', [
            _row('Access', s['accessDenied'] == 'Y' ? 'Denied' : 'Allowed'),
            _row('Email Opt-Out', s['emailOptOut']),
            _row('Okay to Call', s['okayToCall']),
            _row('First Order Date', s['firstOrderDate']),
            _row('Record Type', s['recordType']),
          ]),
          const SizedBox(height: 14),
          _buildSection('Additional User Details', [
            _row('User ID', _firstNonEmpty(s, const ['userId', '_id', 'id'])),
            _row(
              'First Name',
              _firstNonEmpty(s, const ['firstName', 'first_name']),
            ),
            _row(
              'Last Name',
              _firstNonEmpty(s, const ['lastName', 'last_name']),
            ),
            _row('Role', _firstNonEmpty(s, const ['role', 'userRole'])),
            _row(
              'Account Status',
              _firstNonEmpty(s, const ['status', 'accountStatus']),
            ),
            _row(
              'Email Verified',
              _firstNonEmpty(s, const [
                'isVerified',
                'emailVerified',
                'verified',
              ]),
            ),
            _row(
              'Verified At',
              _firstNonEmpty(s, const ['verifiedAt', 'emailVerifiedAt']),
            ),
            _row(
              'Created At',
              _firstNonEmpty(s, const ['createdAt', 'created_at']),
            ),
            _row(
              'Updated At',
              _firstNonEmpty(s, const ['updatedAt', 'updated_at']),
            ),
            _row(
              'Last Login',
              _firstNonEmpty(s, const ['lastLogin', 'lastLoginAt']),
            ),
          ]),
          if ((s['mainNotes'] ?? '').toString().isNotEmpty) ...[
            const SizedBox(height: 14),
            _buildNotesCard('Notes', s['mainNotes']),
          ],
          if ((s['teleNotes'] ?? '').toString().isNotEmpty) ...[
            const SizedBox(height: 14),
            _buildNotesCard('Telemarketing Notes', s['teleNotes']),
          ],
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildCoursesTab() {
    if (_courses.isEmpty) {
      return _emptyState('No courses enrolled yet.', Icons.school_outlined);
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _courses.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) {
        final c = _courses[i];
        final status = (c['status'] ?? 'Unknown').toString();
        final done = status.toLowerCase().contains('complet');

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: kBorder, width: 1.5),
          ),
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: done ? kGreenLight : kRedLight,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: done ? kGreen : Colors.redAccent,
                      ),
                    ),
                  ),
                  if ((c['completionDate'] ?? '').toString().isNotEmpty)
                    Text(
                      'Done: ${c['completionDate']}',
                      style: const TextStyle(fontSize: 11, color: kGrey),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                c['courseTitle'] ?? 'Untitled Course',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: kDark,
                ),
              ),
              if ((c['examTitle'] ?? '').toString().isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  c['examTitle'].toString(),
                  style: const TextStyle(fontSize: 12, color: kGrey),
                ),
              ],
              const SizedBox(height: 12),
              const Divider(color: kBorder, height: 1),
              const SizedBox(height: 12),
              Row(
                children: [
                  _miniInfo(
                    Icons.calendar_today_outlined,
                    'Registered',
                    c['registrationDate'],
                  ),
                  const SizedBox(width: 16),
                  _miniInfo(
                    Icons.event_outlined,
                    'Expires',
                    c['expirationDate'],
                  ),
                  const SizedBox(width: 16),
                  _miniInfo(Icons.quiz_outlined, 'Quiz', c['quizStatus']),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOrdersTab() {
    if (_orders.isEmpty) {
      return _emptyState('No orders found.', Icons.receipt_outlined);
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _orders.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) {
        final o = _orders[i];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: kBorder, width: 1.5),
          ),
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order #${o['orderNumber'] ?? '—'}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: kNavy,
                    ),
                  ),
                  Text(
                    o['date'] ?? '',
                    style: const TextStyle(fontSize: 12, color: kGrey),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                o['description'] ?? 'No description',
                style: const TextStyle(fontSize: 13, color: kDark),
              ),
              const SizedBox(height: 12),
              const Divider(color: kBorder, height: 1),
              const SizedBox(height: 12),
              Row(
                children: [
                  _priceChip('Price', o['price']),
                  const SizedBox(width: 8),
                  _priceChip('Discount', o['discount']),
                  const SizedBox(width: 8),
                  _priceChip('Total', o['total'], highlight: true),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────

  Widget _buildSection(String title, List<_InfoRow> rows) {
    final visible = rows
        .where((r) => (r.value ?? '').toString().trim().isNotEmpty)
        .toList();
    if (visible.isEmpty) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kBorder, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: kNavy,
                letterSpacing: 0.3,
              ),
            ),
          ),
          const Divider(color: kBorder, height: 1),
          ...visible.map((r) => _buildRow(r.label, r.value)),
        ],
      ),
    );
  }

  _InfoRow _row(String label, dynamic value) =>
      _InfoRow(label: label, value: _present(value));

  dynamic _firstNonEmpty(Map<String, dynamic> source, List<String> keys) {
    for (final key in keys) {
      final value = source[key];
      if (value == null) continue;
      final raw = value.toString().trim();
      if (raw.isNotEmpty && raw.toLowerCase() != 'null') return value;
    }
    return null;
  }

  dynamic _present(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value ? 'Yes' : 'No';

    final raw = value.toString().trim();
    if (raw.isEmpty || raw.toLowerCase() == 'null') return null;

    if (raw == 'Y') return 'Yes';
    if (raw == 'N') return 'No';
    if (raw.toLowerCase() == 'true') return 'Yes';
    if (raw.toLowerCase() == 'false') return 'No';

    final dt = DateTime.tryParse(raw);
    if (dt != null) {
      final local = dt.toLocal();
      final y = local.year.toString().padLeft(4, '0');
      final m = local.month.toString().padLeft(2, '0');
      final d = local.day.toString().padLeft(2, '0');
      final hh = local.hour.toString().padLeft(2, '0');
      final mm = local.minute.toString().padLeft(2, '0');
      return '$y-$m-$d $hh:$mm';
    }

    return raw;
  }

  Future<void> _showEditProfileSheet() async {
    final current = _profileData;
    final updated = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _EditProfileSheet(initial: current),
    );

    if (updated == null || updated.isEmpty) return;
    await _saveProfile(updated);
  }

  Future<void> _saveProfile(Map<String, dynamic> updates) async {
    if (widget.studentId.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Missing student ID. Cannot save profile.'),
        ),
      );
      return;
    }

    if (!mounted) return;
    setState(() => _isSavingProfile = true);

    try {
      final url = ApiConfig.studentProfile(widget.studentId);
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      };

      var response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(updates),
      );

      if (response.statusCode == 404 || response.statusCode == 405) {
        response = await http.patch(
          Uri.parse(url),
          headers: headers,
          body: jsonEncode(updates),
        );
      }

      if (!mounted) return;

      if (response.statusCode >= 200 && response.statusCode < 300) {
        dynamic decoded;
        try {
          decoded = jsonDecode(response.body);
        } catch (_) {
          decoded = null;
        }

        Map<String, dynamic> payload = {};
        if (decoded is Map<String, dynamic>) {
          if (decoded['student'] is Map<String, dynamic>) {
            payload = decoded['student'] as Map<String, dynamic>;
          } else if (decoded['data'] is Map<String, dynamic>) {
            payload = decoded['data'] as Map<String, dynamic>;
          } else {
            payload = decoded;
          }
        }

        setState(() {
          _student = {...?_student, ...updates, ...payload};
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully.')),
        );
      } else {
        String message = response.body;
        try {
          final err = jsonDecode(response.body);
          if (err is Map<String, dynamic> && err['message'] != null) {
            message = err['message'].toString();
          }
        } catch (_) {}

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: $message')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Profile update failed: $e')));
    } finally {
      if (!mounted) return;
      setState(() => _isSavingProfile = false);
    }
  }

  Widget _buildRow(String label, dynamic value) {
    final display = (value ?? '').toString().trim();
    if (display.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 13, color: kGrey),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 6,
                child: Text(
                  display,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: kDark,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Divider(color: Color(0xFFF0F2F5), height: 1),
        ),
      ],
    );
  }

  Widget _buildNotesCard(String title, String? notes) {
    if (notes == null || notes.trim().isEmpty) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kBorder, width: 1.5),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: kNavy,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            notes,
            style: const TextStyle(fontSize: 13, color: kDark, height: 1.6),
          ),
        ],
      ),
    );
  }

  Widget _emptyState(String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: kBorder),
          const SizedBox(height: 12),
          Text(message, style: const TextStyle(fontSize: 14, color: kGrey)),
        ],
      ),
    );
  }

  Widget _miniInfo(IconData icon, String label, dynamic value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 11, color: kGrey),
              const SizedBox(width: 3),
              Text(label, style: const TextStyle(fontSize: 10, color: kGrey)),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            (value ?? '—').toString().isEmpty ? '—' : value.toString(),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: kDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _priceChip(String label, dynamic value, {bool highlight = false}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: highlight ? kGreenLight : kGreyBg,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: highlight ? kGreen : kGrey,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              (value ?? '—').toString().isEmpty ? '—' : '\$$value',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: highlight ? kGreen : kDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow {
  final String label;
  final dynamic value;
  const _InfoRow({required this.label, required this.value});
}

class _EditProfileSheet extends StatefulWidget {
  final Map<String, dynamic> initial;

  const _EditProfileSheet({required this.initial});

  @override
  State<_EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<_EditProfileSheet> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _firstNameCtrl;
  late final TextEditingController _lastNameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _mobileCtrl;
  late final TextEditingController _birthdayCtrl;
  late final TextEditingController _streetCtrl;
  late final TextEditingController _cityCtrl;
  late final TextEditingController _stateCtrl;
  late final TextEditingController _postalCtrl;

  @override
  void initState() {
    super.initState();
    final firstName = (widget.initial['firstName'] ?? '').toString().trim();
    final lastName = (widget.initial['lastName'] ?? '').toString().trim();
    final displayFirst = firstName.isNotEmpty
        ? firstName
        : _extractNamePart(
            (widget.initial['name'] ?? '').toString(),
            first: true,
          );
    final displayLast = lastName.isNotEmpty
        ? lastName
        : _extractNamePart(
            (widget.initial['name'] ?? '').toString(),
            first: false,
          );

    final birthday = _firstNonEmpty(widget.initial, const [
      'birthday',
      'birthDate',
      'dateOfBirth',
      'dob',
    ]);

    _firstNameCtrl = TextEditingController(text: displayFirst);
    _lastNameCtrl = TextEditingController(text: displayLast);
    _emailCtrl = TextEditingController(
      text: (widget.initial['email'] ?? '').toString(),
    );
    _mobileCtrl = TextEditingController(
      text: (widget.initial['mobilePhone'] ?? '').toString(),
    );
    _birthdayCtrl = TextEditingController(text: _normalizeDateText(birthday));
    _streetCtrl = TextEditingController(
      text: (widget.initial['streetAddress'] ?? '').toString(),
    );
    _cityCtrl = TextEditingController(
      text: (widget.initial['city'] ?? '').toString(),
    );
    _stateCtrl = TextEditingController(
      text: (widget.initial['state'] ?? '').toString(),
    );
    _postalCtrl = TextEditingController(
      text: (widget.initial['postalCode'] ?? '').toString(),
    );
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _mobileCtrl.dispose();
    _birthdayCtrl.dispose();
    _streetCtrl.dispose();
    _cityCtrl.dispose();
    _stateCtrl.dispose();
    _postalCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.fromLTRB(16, 12, 16, bottomInset + 16),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E7EB),
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Edit Profile',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: kDark,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _field(
                        _firstNameCtrl,
                        'First Name',
                        validator: (v) =>
                            (v ?? '').trim().isEmpty ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _field(
                        _lastNameCtrl,
                        'Last Name',
                        validator: (v) =>
                            (v ?? '').trim().isEmpty ? 'Required' : null,
                      ),
                    ),
                  ],
                ),
                _field(
                  _emailCtrl,
                  'Email',
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    final value = (v ?? '').trim();
                    if (value.isEmpty) return 'Email is required';
                    if (!value.contains('@')) return 'Enter a valid email';
                    return null;
                  },
                ),
                _field(
                  _mobileCtrl,
                  'Mobile Number',
                  keyboardType: TextInputType.phone,
                ),
                _dateField('Birthday', _birthdayCtrl.text),
                _field(_streetCtrl, 'Address'),
                _field(_cityCtrl, 'City'),
                _field(_stateCtrl, 'State'),
                _field(_postalCtrl, 'Postal Code'),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(46),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(46),
                          backgroundColor: kNavy,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Save Changes'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          isDense: true,
        ),
      ),
    );
  }

  Widget _dateField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: _pickBirthday,
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            hintText: 'YYYY-MM-DD',
            suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            isDense: true,
          ),
          child: Text(
            value.isEmpty ? 'YYYY-MM-DD' : value,
            style: TextStyle(
              fontSize: 16,
              color: value.isEmpty ? kGrey : kDark,
            ),
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final firstName = _firstNameCtrl.text.trim();
    final lastName = _lastNameCtrl.text.trim();
    final fullName = [
      firstName,
      lastName,
    ].where((e) => e.isNotEmpty).join(' ').trim();

    final payload = <String, dynamic>{
      'name': fullName,
      'firstName': firstName,
      'lastName': lastName,
      'email': _emailCtrl.text.trim(),
      'mobilePhone': _mobileCtrl.text.trim(),
      'birthday': _birthdayCtrl.text.trim(),
      'birthDate': _birthdayCtrl.text.trim(),
      'dateOfBirth': _birthdayCtrl.text.trim(),
      'streetAddress': _streetCtrl.text.trim(),
      'city': _cityCtrl.text.trim(),
      'state': _stateCtrl.text.trim(),
      'postalCode': _postalCtrl.text.trim(),
    };

    payload.removeWhere((_, value) => value == null);
    Navigator.pop(context, payload);
  }

  String _extractNamePart(String fullName, {required bool first}) {
    final parts = fullName
        .trim()
        .split(RegExp(r'\s+'))
        .where((e) => e.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '';
    if (first) return parts.first;
    return parts.length > 1 ? parts.sublist(1).join(' ') : '';
  }

  String _firstNonEmpty(Map<String, dynamic> source, List<String> keys) {
    for (final key in keys) {
      final value = source[key];
      if (value == null) continue;
      final raw = value.toString().trim();
      if (raw.isNotEmpty && raw.toLowerCase() != 'null') return raw;
    }
    return '';
  }

  String _normalizeDateText(String value) {
    if (value.isEmpty) return '';
    final dt = DateTime.tryParse(value);
    if (dt == null) return value;
    final y = dt.year.toString().padLeft(4, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  Future<void> _pickBirthday() async {
    FocusScope.of(context).unfocus();
    final initial =
        DateTime.tryParse(_birthdayCtrl.text.trim()) ?? DateTime(1990, 1, 1);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: 'Select Birthday',
    );

    if (picked == null) return;
    final y = picked.year.toString().padLeft(4, '0');
    final m = picked.month.toString().padLeft(2, '0');
    final d = picked.day.toString().padLeft(2, '0');
    setState(() {
      _birthdayCtrl.text = '$y-$m-$d';
    });
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  const _TabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: Colors.white, child: tabBar);
  }

  @override
  bool shouldRebuild(_TabBarDelegate old) => false;
}
