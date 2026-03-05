import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// ─── Theme Constants ──────────────────────────────────────────────────
const Color kNavy      = Color(0xFF1A3A5C);
const Color kNavyDark  = Color(0xFF0B1A2A);
const Color kRedLight  = Color(0xFFFDF0EF);
const Color kRedBorder = Color(0xFFF5C6C2);
const Color kDark      = Color(0xFF1C2B3A);
const Color kGrey      = Color(0xFF6B7E92);
const Color kGreyLight = Color(0xFFF4F6F9);
const Color kGreyBg    = Color(0xFFF7F9FC);
const Color kBorder    = Color(0xFFDDE2EA);
const Color kGreen     = Color(0xFF16A34A);
const Color kGreenLight= Color(0xFFEFFAF2);

class ProfileScreen extends StatefulWidget {
  final String studentId;
  final String token;
  final Map<String, dynamic>? user;

  const ProfileScreen({
    Key? key,
    required this.studentId,
    required this.token,
    this.user,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  Map<String, dynamic>? _student;
  List<dynamic> _orders  = [];
  List<dynamic> _courses = [];
  bool   _isLoading = true;
  String _error     = '';

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
    setState(() { _isLoading = true; _error = ''; });

    // ✅ DEBUG — check what we received
    print('>>> widget.studentId: "${widget.studentId}"');
    print('>>> widget.token: "${widget.token}"');
    print('>>> widget.user: ${widget.user}');

    // ✅ Guard — stop early if no studentId
    if (widget.studentId.isEmpty) {
      setState(() {
        _error = 'No student ID linked to this account.\nAsk admin to link your account.';
        _isLoading = false;
      });
      return;
    }

    try {
      final url = 'http://10.0.2.2:8000/api/students/${widget.studentId}';
      print('>>> Fetching: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type':  'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
      );

      print('>>> Status: ${response.statusCode}');
      print('>>> Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _student = data;
          _orders  = data['orders']  ?? [];
          _courses = data['courses'] ?? [];
        });
      } else {
        setState(() {
          _error = 'Failed to load profile (${response.statusCode}).\n${response.body}';
        });
      }
    } catch (e) {
      print('>>> ERROR: $e');
      setState(() { _error = 'Connection failed: $e'; });
    } finally {
      setState(() { _isLoading = false; });
    }
  }

  String get _name =>
      (_student?['name'] ?? widget.user?['name'] ?? 'User').toString();
  String get _email =>
      (_student?['email'] ?? widget.user?['email'] ?? '').toString();
  String get _studentId =>
      (_student?['studentId'] ?? widget.user?['studentId'] ?? '').toString();

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
                    borderRadius: BorderRadius.circular(8)),
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
                    border: Border.all(color: Colors.white.withOpacity(0.5), width: 2.5),
                  ),
                  child: Center(
                    child: Text(_initials,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(height: 12),
                Text(_name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(_email,
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.7), fontSize: 13)),
                const SizedBox(height: 8),
                if (_studentId.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.25)),
                    ),
                    child: Text('ID: $_studentId',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5)),
                  ),
                if (_isLoading) ...[
                  const SizedBox(height: 8),
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(color: Colors.white70, strokeWidth: 2),
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
          labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontSize: 13),
          tabs: [
            const Tab(
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.person_outline, size: 15),
                SizedBox(width: 5),
                Text('Info'),
              ]),
            ),
            Tab(
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.school_outlined, size: 15),
                const SizedBox(width: 5),
                Text('Courses (${_courses.length})'),
              ]),
            ),
            Tab(
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.receipt_outlined, size: 15),
                const SizedBox(width: 5),
                Text('Orders (${_orders.length})'),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTab() {
    final s = _student ?? widget.user ?? {};
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSection('Personal Information', [
            _row('Student ID',      s['studentId']),
            _row('Full Name',       s['name']),
            _row('Email',           s['email']),
            _row('Mobile Phone',    s['mobilePhone']),
            _row('Work Phone',      s['workPhone']),
            _row('Home Phone',      s['homePhone']),
          ]),
          const SizedBox(height: 14),
          _buildSection('Address', [
            _row('Street Address',  s['streetAddress']),
            _row('City',            s['city']),
            _row('State',           s['state']),
            _row('Postal Code',     s['postalCode']),
            _row('Mailing Address', s['mailingAddress']),
          ]),
          const SizedBox(height: 14),
          _buildSection('License & Identification', [
            _row('DRE Number',     s['dreNumber']),
            _row('NMLS ID',        s['nmlsId']),
            _row('License Number', s['licenseNumber']),
            _row('CFP Number',     s['cfpNumber']),
            _row('NPN Number',     s['npnNumber']),
            _row('Company',        s['companyName']),
          ]),
          const SizedBox(height: 14),
          _buildSection('Account Details', [
            _row('Access',           s['accessDenied'] == 'Y' ? 'Denied' : 'Allowed'),
            _row('Email Opt-Out',    s['emailOptOut']),
            _row('Okay to Call',     s['okayToCall']),
            _row('First Order Date', s['firstOrderDate']),
            _row('Record Type',      s['recordType']),
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
        final c      = _courses[i];
        final status = (c['status'] ?? 'Unknown').toString();
        final done   = status.toLowerCase().contains('complet');

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
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: done ? kGreenLight : kRedLight,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Text(status,
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: done ? kGreen : Colors.redAccent)),
                  ),
                  if ((c['completionDate'] ?? '').toString().isNotEmpty)
                    Text('Done: ${c['completionDate']}',
                        style: const TextStyle(fontSize: 11, color: kGrey)),
                ],
              ),
              const SizedBox(height: 10),
              Text(c['courseTitle'] ?? 'Untitled Course',
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600, color: kDark)),
              if ((c['examTitle'] ?? '').toString().isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(c['examTitle'].toString(),
                    style: const TextStyle(fontSize: 12, color: kGrey)),
              ],
              const SizedBox(height: 12),
              const Divider(color: kBorder, height: 1),
              const SizedBox(height: 12),
              Row(
                children: [
                  _miniInfo(Icons.calendar_today_outlined, 'Registered', c['registrationDate']),
                  const SizedBox(width: 16),
                  _miniInfo(Icons.event_outlined, 'Expires', c['expirationDate']),
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
                  Text('Order #${o['orderNumber'] ?? '—'}',
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: kNavy)),
                  Text(o['date'] ?? '',
                      style: const TextStyle(fontSize: 12, color: kGrey)),
                ],
              ),
              const SizedBox(height: 8),
              Text(o['description'] ?? 'No description',
                  style: const TextStyle(fontSize: 13, color: kDark)),
              const SizedBox(height: 12),
              const Divider(color: kBorder, height: 1),
              const SizedBox(height: 12),
              Row(
                children: [
                  _priceChip('Price',    o['price']),
                  const SizedBox(width: 8),
                  _priceChip('Discount', o['discount']),
                  const SizedBox(width: 8),
                  _priceChip('Total',    o['total'], highlight: true),
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
    final visible = rows.where((r) =>
        (r.value ?? '').toString().trim().isNotEmpty).toList();
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
            child: Text(title,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: kNavy,
                    letterSpacing: 0.3)),
          ),
          const Divider(color: kBorder, height: 1),
          ...visible.map((r) => _buildRow(r.label, r.value)),
        ],
      ),
    );
  }

  _InfoRow _row(String label, dynamic value) =>
      _InfoRow(label: label, value: value);

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
              SizedBox(
                width: 130,
                child: Text(label,
                    style: const TextStyle(fontSize: 13, color: kGrey)),
              ),
              Expanded(
                child: Text(display,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: kDark),
                    textAlign: TextAlign.right),
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
          Text(title,
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w700, color: kNavy)),
          const SizedBox(height: 10),
          Text(notes,
              style: const TextStyle(fontSize: 13, color: kDark, height: 1.6)),
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
          Row(children: [
            Icon(icon, size: 11, color: kGrey),
            const SizedBox(width: 3),
            Text(label, style: const TextStyle(fontSize: 10, color: kGrey)),
          ]),
          const SizedBox(height: 2),
          Text(
            (value ?? '—').toString().isEmpty ? '—' : value.toString(),
            style: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.w600, color: kDark),
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
            Text(label,
                style: TextStyle(
                    fontSize: 10,
                    color: highlight ? kGreen : kGrey,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 2),
            Text(
              (value ?? '—').toString().isEmpty ? '—' : '\$$value',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: highlight ? kGreen : kDark),
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

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  const _TabBarDelegate(this.tabBar);

  @override double get minExtent => tabBar.preferredSize.height;
  @override double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(color: Colors.white, child: tabBar);
  }

  @override
  bool shouldRebuild(_TabBarDelegate old) => false;
}