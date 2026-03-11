import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';
import 'exam_portal_screen.dart';

const Color _navy   = Color(0xFF1A3A5C);
const Color _blue   = Color(0xFF2563EB);
const Color _green  = Color(0xFF16A34A);
const Color _orange = Color(0xFFF97316);
const Color _red    = Color(0xFFDC2626);
const Color _purple = Color(0xFF7C3AED);
const Color _muted  = Color(0xFF6B7280);
const Color _bg     = Color(0xFFF4F6F9);
const Color _white  = Colors.white;
const Color _border = Color(0xFFE5E7EB);

class _StatusCfg {
  final String label;
  final Color dot, badgeBg, badgeText, badgeBorder, barColor;
  const _StatusCfg({required this.label, required this.dot, required this.badgeBg,
      required this.badgeText, required this.badgeBorder, required this.barColor});
}

const Map<String, _StatusCfg> _statusMap = {
  'In Progress': _StatusCfg(label: 'In Progress', dot: _orange,
      badgeBg: Color(0xFFFFF7ED), badgeText: Color(0xFFEA580C),
      badgeBorder: Color(0xFFFED7AA), barColor: _orange),
  'Complete': _StatusCfg(label: 'Complete', dot: _green,
      badgeBg: Color(0xFFF0FDF4), badgeText: Color(0xFF15803D),
      badgeBorder: Color(0xFFBBF7D0), barColor: _green),
  'Failed': _StatusCfg(label: 'Failed', dot: _red,
      badgeBg: Color(0xFFFEF2F2), badgeText: Color(0xFFB91C1C),
      badgeBorder: Color(0xFFFECACA), barColor: _green),
};

_StatusCfg _getStatus(String? s) => _statusMap[s] ?? _statusMap['In Progress']!;

String _getStatusKey(String? s) {
  if (s == 'Complete') return 'complete';
  if (s == 'Failed')   return 'failed';
  return 'in-progress';
}

class MyCoursesScreen extends StatefulWidget {
  const MyCoursesScreen({super.key});
  @override
  State<MyCoursesScreen> createState() => _MyCoursesScreenState();
}

class _MyCoursesScreenState extends State<MyCoursesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> _courses = [];
  bool _loading = true;
  String _error = '', _token = '', _studentId = '';

  static const _tabs = [
    ('all', 'All'), ('in-progress', 'In Progress'),
    ('complete', 'Completed'), ('failed', 'Needs Retake'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _fetchCourses();
  }

  @override
  void dispose() { _tabController.dispose(); super.dispose(); }

  Future<void> _fetchCourses() async {
    setState(() { _loading = true; _error = ''; });
    try {
      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString('token') ?? '';
      if (_token.isEmpty) {
        setState(() { _error = 'You are not logged in. Please log in again.'; _loading = false; });
        return;
      }

      final userStr = prefs.getString('user') ?? '{}';
      Map<String, dynamic> user = {};
      try { user = jsonDecode(userStr) as Map<String, dynamic>; } catch (_) {}
      _studentId = user['studentId']?.toString() ?? '';

      if (_studentId.isEmpty) {
        try {
          final meRes = await http.get(
            Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/auth/me'),
            headers: {'Authorization': 'Bearer $_token'},
          );
          if (meRes.statusCode == 200) {
            final meData = jsonDecode(meRes.body) as Map<String, dynamic>;
            _studentId = meData['studentId']?.toString() ?? '';
            user['studentId'] = _studentId;
            await prefs.setString('user', jsonEncode(user));
          }
        } catch (_) {}
      }

      final res = await http.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/auth/my-courses'),
        headers: { 'Content-Type': 'application/json', 'Authorization': 'Bearer $_token' },
      );

      final data = jsonDecode(res.body) as Map<String, dynamic>;
      if (res.statusCode != 200) {
        setState(() { _error = data['message']?.toString() ?? 'Failed to load courses.'; _loading = false; });
        return;
      }

      final rawCourses = data['courses'] as List? ?? [];
      if (_studentId.isEmpty) {
        _studentId = (data['student'] as Map<String, dynamic>?)?['studentId']?.toString() ?? '';
      }

      setState(() {
        _courses = rawCourses.map((e) => Map<String, dynamic>.from(e as Map)).toList();
        _loading = false;
      });
    } catch (e, stack) {
      debugPrint('❌ _fetchCourses error: $e\n$stack');
      setState(() { _error = 'Network error: ${e.toString()}'; _loading = false; });
    }
  }

  List<Map<String, dynamic>> _filtered(String k) =>
      k == 'all' ? _courses : _courses.where((c) => _getStatusKey(c['status']) == k).toList();

  int _count(String k) => _filtered(k).length;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _bg,
    appBar: AppBar(
      backgroundColor: _white, elevation: 0.5, titleSpacing: 16,
      title: Image.asset('assets/relstone_logo.png', height: 28, fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => const Text('RELSTONE',
              style: TextStyle(color: _navy, fontWeight: FontWeight.w800, letterSpacing: 1.2))),
      actions: [
        IconButton(icon: const Icon(Icons.refresh_rounded, color: _navy), onPressed: _fetchCourses),
        const SizedBox(width: 8),
      ],
    ),
    body: _loading ? const Center(child: CircularProgressIndicator(color: _blue))
        : _error.isNotEmpty ? _buildError()
        : _buildBody(),
  );

  Widget _buildError() => Center(child: Padding(padding: const EdgeInsets.all(24),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      const Icon(Icons.error_outline, color: _red, size: 48),
      const SizedBox(height: 12),
      Text(_error, textAlign: TextAlign.center, style: const TextStyle(color: _muted, fontSize: 13)),
      const SizedBox(height: 16),
      ElevatedButton(onPressed: _fetchCourses,
          style: ElevatedButton.styleFrom(backgroundColor: _navy, foregroundColor: _white),
          child: const Text('Try Again')),
    ]),
  ));

  Widget _buildBody() => Column(children: [
    Container(width: double.infinity, color: _navy,
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
      child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('My Courses', style: TextStyle(color: _white, fontSize: 22, fontWeight: FontWeight.w800)),
        SizedBox(height: 4),
        Text('Track progress, continue studying, and download certificates.',
            style: TextStyle(color: Colors.white70, fontSize: 13)),
      ]),
    ),
    Container(color: _navy, padding: const EdgeInsets.fromLTRB(12, 0, 12, 14),
      child: Row(children: [
        _statCard('${_courses.length}',      'Enrolled',    Icons.menu_book_rounded,        _blue,   const Color(0xFFEFF6FF)),
        const SizedBox(width: 8),
        _statCard('${_count('complete')}',   'Completed',   Icons.check_circle_outline,      _green,  const Color(0xFFF0FDF4)),
        const SizedBox(width: 8),
        _statCard('${_count('in-progress')}','In Progress', Icons.access_time_rounded,       _orange, const Color(0xFFFFF7ED)),
        const SizedBox(width: 8),
        _statCard('${_courses.where((c) => _getStatusKey(c['status']) == 'complete').length}',
            'Certs', Icons.workspace_premium_rounded, _purple, const Color(0xFFF5F3FF)),
      ]),
    ),
    Container(color: _white,
      child: TabBar(
        controller: _tabController, isScrollable: true, tabAlignment: TabAlignment.start,
        labelColor: _blue, unselectedLabelColor: _muted, indicatorColor: _blue, indicatorWeight: 2.5,
        labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
        unselectedLabelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        tabs: _tabs.map((t) => Tab(child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(t.$2), const SizedBox(width: 6),
          Container(padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(color: _bg, borderRadius: BorderRadius.circular(20)),
            child: Text('${_count(t.$1)}',
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _muted))),
        ]))).toList(),
      ),
    ),
    Expanded(child: TabBarView(controller: _tabController,
      children: _tabs.map((t) {
        final list = _filtered(t.$1);
        if (list.isEmpty) return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.menu_book_outlined, size: 48, color: _border),
          const SizedBox(height: 12),
          Text(t.$1 == 'all' ? 'No courses enrolled yet.' : 'No courses in this category.',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: _muted)),
        ]));
        return RefreshIndicator(
          onRefresh: _fetchCourses,
          color: _blue,
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: list.length,
            itemBuilder: (_, i) => _CourseCard(
              course: list[i],
              token: _token,
              studentId: _studentId,
            ),
          ),
        );
      }).toList(),
    )),
  ]);

  Widget _statCard(String v, String label, IconData icon, Color color, Color bg) =>
    Expanded(child: Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: _white, borderRadius: BorderRadius.circular(10),
          border: Border(top: BorderSide(color: color, width: 3))),
      child: Column(children: [
        Container(width: 32, height: 32,
            decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: color, size: 16)),
        const SizedBox(height: 6),
        Text(v, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
        Text(label, style: const TextStyle(fontSize: 10, color: _muted), textAlign: TextAlign.center),
      ]),
    ));
}

// ── CourseCard ────────────────────────────────────────────────────────────────
class _CourseCard extends StatefulWidget {
  final Map<String, dynamic> course;
  final String token, studentId;
  const _CourseCard({required this.course, required this.token, required this.studentId});
  @override State<_CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<_CourseCard> {
  bool _expanded    = false;
  bool _downloading = false;

  String? _hrs(String? id) {
    final m = RegExp(r'(\d+)HR', caseSensitive: false).firstMatch(id ?? '');
    return m?.group(1);
  }

  String _cat(String? t) {
    if (t == 'CE')         return 'California C.E.';
    if (t == 'RE')         return 'Real Estate';
    if (t == 'PreLicense') return 'Pre-License';
    return t ?? 'Course';
  }

  String _scoreLabel(dynamic score, String suffix) {
    if (score == null) return 'Passed';
    final n = num.tryParse(score.toString());
    if (n == null) return suffix;
    return '${n.toInt()}% $suffix';
  }

  Future<void> _downloadCertificate(BuildContext context, String courseId, String courseTitle) async {
    if (_downloading || courseId.isEmpty) return;
    setState(() => _downloading = true);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(children: [
          SizedBox(width: 18, height: 18,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)),
          SizedBox(width: 12),
          Text('Downloading certificate...'),
        ]),
        duration: Duration(seconds: 60),
        backgroundColor: _navy,
      ),
    );

    try {
      final url = '${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/certificate/download/$courseId';
      final res = await http.get(Uri.parse(url), headers: {'Authorization': 'Bearer ${widget.token}'});
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (res.statusCode != 200) {
        String msg = 'Failed to download certificate.';
        try { msg = (jsonDecode(res.body) as Map)['message']?.toString() ?? msg; } catch (_) {}
        throw Exception(msg);
      }

      final safeName = courseTitle.replaceAll(RegExp(r'[^\w\s]'), '').replaceAll(' ', '_');
      final String savePath = Platform.isAndroid
          ? '/storage/emulated/0/Download/Certificate_$safeName.pdf'
          : '/tmp/Certificate_$safeName.pdf';
      final file = File(savePath);
      if (!await file.parent.exists()) await file.parent.create(recursive: true);
      await file.writeAsBytes(res.bodyBytes);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('✅ Saved to Downloads:\n${file.path.split('/').last}'),
          backgroundColor: _green, duration: const Duration(seconds: 5),
        ));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('❌ ${e.toString()}'), backgroundColor: _red,
        ));
      }
    } finally {
      if (mounted) setState(() => _downloading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c           = widget.course;
    final s           = _getStatus(c['status']?.toString());
    final sKey        = _getStatusKey(c['status']?.toString());
    final bundleId    = c['bundleId']?.toString() ?? '';
    final courseId    = c['_id']?.toString() ?? '';
    final courseTitle = c['courseTitle']?.toString() ?? bundleId;
    final examNames   = (c['examNames'] as List? ?? []).map((e) => e.toString()).toList();
    final versions    = (c['versions']  as List? ?? []).map((e) => e.toString()).toList();
    final progress    = (c['progress']  as num? ?? 0).toInt();
    final title       = examNames.isNotEmpty ? examNames.first : courseTitle;
    final examScore   = c['examScore'];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: _white, borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _border),
          boxShadow: [BoxShadow(color: _navy.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))]),
      child: Column(children: [
        Padding(padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          Row(children: [
            Expanded(child: Wrap(spacing: 4, children: versions.isNotEmpty
                ? versions.map((v) => _pill(v.replaceAll('Version ', 'Ver '))).toList()
                : [_pill(bundleId)])),
            Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: s.badgeBg, borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: s.badgeBorder)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Container(width: 6, height: 6, decoration: BoxDecoration(color: s.dot, shape: BoxShape.circle)),
                const SizedBox(width: 5),
                Text(s.label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: s.badgeText)),
              ])),
          ]),
          const SizedBox(height: 12),

          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(width: 48, height: 48,
                decoration: BoxDecoration(color: s.badgeBg, borderRadius: BorderRadius.circular(12)),
                child: Icon(Icons.menu_book_rounded, color: s.dot, size: 24)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(_cat(c['courseType']?.toString()),
                  style: const TextStyle(fontSize: 10, color: _muted, fontWeight: FontWeight.w600, letterSpacing: 0.6)),
              const SizedBox(height: 3),
              Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700,
                  color: Color(0xFF111827), height: 1.4)),
              const SizedBox(height: 4),
              Row(children: [
                if (_hrs(bundleId) != null) ...[
                  const Icon(Icons.access_time_rounded, size: 12, color: _muted), const SizedBox(width: 3),
                  Text('${_hrs(bundleId)} Credit Hrs', style: const TextStyle(fontSize: 11, color: _muted)),
                  const SizedBox(width: 10),
                ],
                if ((c['registrationDate'] ?? '').toString().isNotEmpty) ...[
                  const Icon(Icons.calendar_today_rounded, size: 12, color: _muted), const SizedBox(width: 3),
                  Text(c['registrationDate'].toString(), style: const TextStyle(fontSize: 11, color: _muted)),
                ],
              ]),
            ])),
          ]),

          const SizedBox(height: 12), const Divider(height: 1), const SizedBox(height: 10),

          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Progress', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF374151))),
            Text('$progress%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
                color: sKey == 'in-progress' ? _orange : sKey == 'complete' ? _green : _red)),
          ]),
          const SizedBox(height: 6),
          ClipRRect(borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(value: progress / 100,
                backgroundColor: const Color(0xFFF3F4F6),
                valueColor: AlwaysStoppedAnimation<Color>(s.barColor), minHeight: 6)),
          if ((c['totalQuestions'] as num? ?? 0) > 0) ...[
            const SizedBox(height: 5),
            Text('${c['totalQuestions']} exam questions', style: const TextStyle(fontSize: 11, color: _muted)),
          ],
          const SizedBox(height: 10),

          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            if (sKey == 'complete')
              Text(_scoreLabel(examScore, 'Passed'),
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: _green))
            else if (sKey == 'failed')
              Text(_scoreLabel(examScore, 'Failed'),
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: _red))
            else
              Text('Registered: ${c['registrationDate'] ?? '—'}',
                  style: const TextStyle(fontSize: 12, color: _muted)),

            if (sKey == 'in-progress' && examNames.isNotEmpty)
              _actionBtn('Continue', Icons.play_arrow_rounded, _blue, false)
            else if (sKey == 'complete')
              _certBtn(context, courseId, courseTitle)
            else if (sKey == 'failed' && examNames.isNotEmpty)
              _actionBtn('Retake', Icons.refresh_rounded, _purple, true),
          ]),
        ])),

        if (_expanded && examNames.isNotEmpty) ...[
          const Divider(height: 1),
          Container(color: _bg, padding: const EdgeInsets.all(12),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('SELECT AN EXAM', style: TextStyle(fontSize: 10, color: _muted,
                  fontWeight: FontWeight.w800, letterSpacing: 1.4)),
              const SizedBox(height: 8),
              ...examNames.map((en) => _ExamTile(
                examName: en, bundleId: bundleId,
                studentId: widget.studentId, token: widget.token,
              )),
            ])),
        ],
      ]),
    );
  }

  Widget _certBtn(BuildContext context, String courseId, String courseTitle) =>
    GestureDetector(
      onTap: () => _downloadCertificate(context, courseId, courseTitle),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: _downloading ? const Color(0xFFDCFCE7) : _white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: _green),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          if (_downloading)
            const SizedBox(width: 12, height: 12,
                child: CircularProgressIndicator(strokeWidth: 2, color: _green))
          else
            const Icon(Icons.download_rounded, color: _green, size: 14),
          const SizedBox(width: 5),
          Text(_downloading ? 'Downloading...' : 'Certificate',
              style: const TextStyle(color: _green, fontSize: 12, fontWeight: FontWeight.w700)),
        ]),
      ),
    );

  Widget _pill(String l) => Container(
    margin: const EdgeInsets.only(bottom: 2),
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(20), border: Border.all(color: _border)),
    child: Text(l, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: _muted)),
  );

  Widget _actionBtn(String label, IconData icon, Color color, bool outlined) =>
    GestureDetector(onTap: () => setState(() => _expanded = !_expanded),
      child: Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(color: outlined ? _white : color,
            borderRadius: BorderRadius.circular(8), border: Border.all(color: color)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, color: outlined ? color : _white, size: 14), const SizedBox(width: 5),
          Text(label, style: TextStyle(color: outlined ? color : _white,
              fontSize: 12, fontWeight: FontWeight.w700)),
          const SizedBox(width: 4),
          Icon(_expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: outlined ? color : _white, size: 14),
        ])));
}

// ── ExamTile ──────────────────────────────────────────────────────────────────
class _ExamTile extends StatefulWidget {
  final String examName, bundleId, studentId, token;
  const _ExamTile({required this.examName, required this.bundleId,
      required this.studentId, required this.token});
  @override State<_ExamTile> createState() => _ExamTileState();
}

class _ExamTileState extends State<_ExamTile> {
  Map<String, dynamic>? _result;
  bool _loading = false;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    if (widget.studentId.isEmpty || widget.bundleId.isEmpty) return;
    setState(() => _loading = true);
    try {
      final res = await http.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/exam-session/bundle/${widget.studentId}/${widget.bundleId}'),
        headers: {'Authorization': 'Bearer ${widget.token}'},
      );
      if (res.statusCode == 200) {
        final data    = jsonDecode(res.body) as Map<String, dynamic>;
        final summary = data['examSummary'] as Map<String, dynamic>? ?? {};
        if (mounted) setState(() => _result = summary[widget.examName] as Map<String, dynamic>?);
      }
    } catch (e) {
      debugPrint('❌ ExamTile load error: $e');
    }
    if (mounted) setState(() => _loading = false);
  }

  // ── KEY FIX: smart navigation based on exam status ────────────────────────
  void _handleTap(BuildContext context) {
    final passed     = _result?['passed'] == true;
    final inProgress = _result?['status'] == 'in-progress';

    if (passed) {
      // ✅ Already passed — show results screen, cannot restart
      Navigator.push(context, MaterialPageRoute(
        builder: (_) => ExamResultsScreen(
          result: {
            'passed':          true,
            'score':           _result?['latestScore'] ?? 0,
            'correctCount':    _result?['correctCount'] ?? 0,
            'totalCount':      _result?['totalCount'] ?? 0,
            'version':         _result?['version'] ?? '',
            'attemptNumber':   _result?['attempts'] ?? 1,
            'gradedQuestions': _result?['gradedQuestions'] ?? [],
          },
          examName:  widget.examName,
          bundleId:  widget.bundleId,
          isTimeout: false,
        ),
      ));
      return;
    }

    // ❌ Failed or not started → open exam (retake or fresh)
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => ExamPortalScreen(
        bundleId: widget.bundleId,
        examName: widget.examName,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final passed     = _result?['passed'] == true;
    final failed     = _result != null && _result!['passed'] == false && _result!['status'] != 'in-progress';
    final inProgress = _result?['status'] == 'in-progress';
    final score      = _result?['latestScore'];
    final attempts   = _result?['attempts'];

    Color borderC = _border, bgC = _white, statusC = _muted;
    String statusT   = 'Not Started';
    IconData statusI = Icons.quiz_rounded;

    if (passed)     { borderC = _green;  bgC = const Color(0xFFF0FDF4); statusT = 'Passed';      statusC = _green;  statusI = Icons.check_circle_rounded; }
    if (failed)     { borderC = _red;    bgC = const Color(0xFFFEF2F2); statusT = 'Failed';      statusC = _red;    statusI = Icons.cancel_rounded; }
    if (inProgress) { borderC = _orange; bgC = const Color(0xFFFFF7ED); statusT = 'In Progress'; statusC = _orange; statusI = Icons.pending_rounded; }

    return GestureDetector(
      onTap: () => _handleTap(context), // ← FIX: was widget.onTap (always opened ExamPortalScreen)
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(color: bgC, borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderC)),
        child: Row(children: [
          Container(width: 36, height: 36,
            decoration: BoxDecoration(
                color: passed ? const Color(0xFFDCFCE7) : failed ? const Color(0xFFFEE2E2) : _bg,
                borderRadius: BorderRadius.circular(8)),
            child: Icon(statusI, color: passed ? _green : failed ? _red : _muted, size: 20)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(widget.examName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _navy)),
            const SizedBox(height: 2),
            Row(children: [
              Text(statusT, style: TextStyle(fontSize: 11, color: statusC, fontWeight: FontWeight.w600)),
              if (score != null) ...[const Text(' · ', style: TextStyle(color: _muted, fontSize: 11)),
                Text('$score%', style: const TextStyle(fontSize: 11, color: _muted))],
              if (attempts != null) ...[const Text(' · ', style: TextStyle(color: _muted, fontSize: 11)),
                Text('Attempt #$attempts', style: const TextStyle(fontSize: 11, color: _muted))],
            ]),
          ])),
          if (_loading)
            const SizedBox(width: 16, height: 16,
                child: CircularProgressIndicator(strokeWidth: 2, color: _muted))
          else
            // Lock icon for passed, arrow for everything else
            Icon(
              passed ? Icons.lock_rounded : Icons.chevron_right_rounded,
              color: passed ? _green : _muted,
              size: 20,
            ),
        ]),
      ),
    );
  }
}