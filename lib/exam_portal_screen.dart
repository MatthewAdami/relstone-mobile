import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';

class ExamQuestion {
  final String id;
  final String question;
  final Map<String, String> options;
  final int questionNumber;

  ExamQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.questionNumber,
  });

  factory ExamQuestion.fromJson(Map<String, dynamic> json) {
    final opts = <String, String>{};
    final raw = json['options'] as Map<String, dynamic>? ?? {};
    raw.forEach((k, v) {
      if (v != null && v.toString().isNotEmpty) opts[k] = v.toString();
    });
    return ExamQuestion(
      id:             json['_id'].toString(),
      question:       json['question'] ?? '',
      options:        opts,
      questionNumber: json['questionNumber'] ?? 0,
    );
  }
}

String formatTime(int secs) {
  if (secs <= 0) return '00:00';
  final h = secs ~/ 3600;
  final m = (secs % 3600) ~/ 60;
  final s = secs % 60;
  final mm = m.toString().padLeft(2, '0');
  final ss = s.toString().padLeft(2, '0');
  if (h > 0) return '${h.toString().padLeft(2, '0')}:$mm:$ss';
  return '$mm:$ss';
}

class ExamPortalScreen extends StatefulWidget {
  final String bundleId;
  final String examName;

  const ExamPortalScreen({
    super.key,
    required this.bundleId,
    required this.examName,
  });

  @override
  State<ExamPortalScreen> createState() => _ExamPortalScreenState();
}

class _ExamPortalScreenState extends State<ExamPortalScreen> {
  static const Color navy    = Color(0xFF0F172A);
  static const Color blue    = Color(0xFF2563EB);
  static const Color green   = Color(0xFF16A34A);
  static const Color orange  = Color(0xFFF97316);
  static const Color red     = Color(0xFFEF4444);
  static const Color bgGray  = Color(0xFFF1F5F9);
  static const Color border  = Color(0xFFE2E8F0);

  bool    _loading    = true;
  String  _error      = '';
  String  _sessionId  = '';
  String  _version    = '';
  int     _attemptNum = 1;
  int     _timeLeft   = 0;
  bool    _resuming   = false;
  int     _leaveCount = 0;

  List<ExamQuestion>  _questions = [];
  Map<String, String> _answers   = {};
  int                 _activeQ   = 0;

  bool _submitting  = false;
  bool _showConfirm = false;

  Timer? _timer;
  Timer? _autoSave;

  final ScrollController _scrollCtrl    = ScrollController();
  final ScrollController _navScrollCtrl = ScrollController();
  final List<GlobalKey>  _qKeys         = [];

  String _studentId = '';
  String _token     = '';

  // Navigator panel toggle
  bool _navExpanded = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _autoSave?.cancel();
    _scrollCtrl.dispose();
    _navScrollCtrl.dispose();
    super.dispose();
  }

  Future<void> _init() async {
    final prefs   = await SharedPreferences.getInstance();
    final userStr = prefs.getString('user') ?? '{}';
    final user    = jsonDecode(userStr) as Map<String, dynamic>;
    _studentId    = user['studentId']?.toString() ?? '';
    _token        = prefs.getString('token') ?? '';
    await _loadSession();
  }

  Future<void> _loadSession() async {
    setState(() { _loading = true; _error = ''; });
    try {
      final uri = Uri.parse(ApiConfig.examStart).replace(
        queryParameters: {
          'studentId': _studentId,
          'bundleId':  widget.bundleId,
          'examName':  widget.examName,
        },
      );
      final res  = await http.get(uri, headers: _headers());
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      if (res.statusCode != 200) throw Exception(data['message'] ?? 'Failed to load');

      final qList = (data['questions'] as List)
          .map((q) => ExamQuestion.fromJson(q as Map<String, dynamic>))
          .toList();

      final rawAnswers = data['answers'] as Map<String, dynamic>? ?? {};
      final answers    = rawAnswers.map((k, v) => MapEntry(k, v.toString()));

      setState(() {
        _sessionId  = data['sessionId'].toString();
        _version    = data['version'] ?? '';
        _attemptNum = data['attemptNumber'] ?? 1;
        _timeLeft   = data['secondsRemaining'] ?? 0;
        _resuming   = data['resuming'] ?? false;
        _leaveCount = data['leaveCount'] ?? 0;
        _questions  = qList;
        _answers    = answers;
        _qKeys      ..clear()
                    ..addAll(List.generate(qList.length, (_) => GlobalKey()));
      });

      _startTimer();
      _startAutoSave();
    } catch (e) {
      setState(() { _error = e.toString(); });
    } finally {
      setState(() { _loading = false; });
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_timeLeft <= 1) {
        _timer?.cancel();
        _autoSave?.cancel();
        setState(() { _timeLeft = 0; });
        _submitExam(isTimeout: true);
      } else {
        setState(() { _timeLeft--; });
      }
    });
  }

  void _startAutoSave() {
    _autoSave?.cancel();
    _autoSave = Timer.periodic(const Duration(seconds: 30), (_) => _saveProgress());
  }

  Future<void> _saveProgress() async {
    if (_sessionId.isEmpty) return;
    try {
      await http.post(Uri.parse(ApiConfig.examSave),
        headers: _headers(),
        body: jsonEncode({
          'sessionId':        _sessionId,
          'answers':          _answers,
          'secondsRemaining': _timeLeft,
        }),
      );
    } catch (_) {}
  }

  Future<void> _submitExam({bool isTimeout = false}) async {
    if (_sessionId.isEmpty) return;
    setState(() { _submitting = true; });
    _timer?.cancel();
    _autoSave?.cancel();

    try {
      final res = await http.post(Uri.parse(ApiConfig.examSubmit),
        headers: _headers(),
        body: jsonEncode({
          'sessionId':        _sessionId,
          'answers':          _answers,
          'secondsRemaining': _timeLeft,
        }),
      );
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      if (res.statusCode != 200) throw Exception(data['message'] ?? 'Submit failed');

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ExamResultsScreen(
              result:    data,
              examName:  widget.examName,
              bundleId:  widget.bundleId,
              isTimeout: isTimeout,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Failed to submit: $e'), backgroundColor: red),
        );
      }
      setState(() { _submitting = false; });
    }
  }

  Map<String, String> _headers() => {
    'Content-Type':  'application/json',
    'Authorization': 'Bearer $_token',
  };

  int  get _answeredCount => _answers.length;
  int  get _totalCount    => _questions.length;
  int  get _unanswered    => _totalCount - _answeredCount;
  int  get _progressPct   => _totalCount > 0
      ? ((_answeredCount / _totalCount) * 100).round() : 0;

  bool get _timeWarning  => _timeLeft > 0 && _timeLeft <= 300;
  bool get _timeCritical => _timeLeft > 0 && _timeLeft <= 60;

  Color get _timerBg => _timeCritical ? red
      : _timeWarning ? orange
      : navy.withOpacity(0.6);

  void _scrollToQuestion(int index) {
    setState(() {
      _activeQ      = index;
      _navExpanded  = false; // close nav after selecting
    });
    final ctx = _qKeys[index].currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(ctx,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          alignment: 0.05);
    }
  }

  // ── BUILD ─────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    if (_loading) return _buildLoading();
    if (_error.isNotEmpty) return _buildError();

    return Scaffold(
      backgroundColor: bgGray,
      body: Stack(
        children: [
          Column(
            children: [
              // ── Top header ──
              _buildTopHeader(),

              // ── Navigator bar (collapsible, below header) ──
              _buildNavigatorBar(),

              // ── Full-width question list ──
              Expanded(child: _buildQuestionList()),
            ],
          ),
          if (_showConfirm) _buildConfirmModal(),
        ],
      ),
    );
  }

  // ── Loading ───────────────────────────────────────────────
  Widget _buildLoading() => Scaffold(
    backgroundColor: bgGray,
    body: const Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        CircularProgressIndicator(color: blue),
        SizedBox(height: 16),
        Text('Loading your exam...', style: TextStyle(color: Color(0xFF64748B), fontSize: 14)),
      ]),
    ),
  );

  // ── Error ─────────────────────────────────────────────────
  Widget _buildError() => Scaffold(
    backgroundColor: bgGray,
    body: Center(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('⚠️', style: TextStyle(fontSize: 40)),
          const SizedBox(height: 12),
          const Text('Failed to Load Exam', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text(_error, style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)), textAlign: TextAlign.center),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: blue),
            child: const Text('Go Back', style: TextStyle(color: Colors.white)),
          ),
        ]),
      ),
    ),
  );

  // ── Top Header ────────────────────────────────────────────
  Widget _buildTopHeader() {
    return Container(
      color: navy,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  // Back
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white60, size: 18),
                  ),
                  const SizedBox(width: 10),

                  // Title
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'RELSTONE · ${widget.bundleId}',
                          style: const TextStyle(color: Color(0xFF2EABFE), fontSize: 10,
                              fontWeight: FontWeight.w700, letterSpacing: 1.2),
                        ),
                        Text(
                          widget.examName,
                          style: const TextStyle(color: Colors.white, fontSize: 13,
                              fontWeight: FontWeight.w700),
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  // Attempt
                  Text(
                    '$_totalCount Q  •  70% Pass  •  Attempt #$_attemptNum',
                    style: const TextStyle(color: Colors.white60, fontSize: 10),
                  ),

                  const SizedBox(width: 12),

                  // Timer
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _timerBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      formatTime(_timeLeft),
                      style: const TextStyle(color: Colors.white, fontSize: 18,
                          fontWeight: FontWeight.w800, letterSpacing: 1),
                    ),
                  ),
                ],
              ),
            ),

            // Progress bar
            LinearProgressIndicator(
              value: _progressPct / 100,
              backgroundColor: Colors.white12,
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2EABFE)),
              minHeight: 3,
            ),

            // Sub info row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              child: Row(
                children: [
                  Text(
                    'Progress: $_answeredCount / $_totalCount ($_progressPct%)',
                    style: const TextStyle(color: Colors.white38, fontSize: 10),
                  ),
                  const Spacer(),
                  if (_resuming)
                    const Text('⚡ Resumed', style: TextStyle(color: Color(0xFFF97316), fontSize: 10)),
                  if (_leaveCount > 0)
                    Text('  ⚠ Left ${_leaveCount}×',
                        style: const TextStyle(color: Color(0xFFF97316), fontSize: 10)),
                  const Text('  Auto-saves every 30s',
                      style: TextStyle(color: Color(0xFF2EABFE), fontSize: 10)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Navigator Bar (below header, collapsible) ─────────────
  Widget _buildNavigatorBar() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // ── Toggle row ──
          InkWell(
            onTap: () => setState(() => _navExpanded = !_navExpanded),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
              ),
              child: Row(
                children: [
                  // Answered pill
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$_answeredCount / $_totalCount answered',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: blue),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Unanswered pill
                  if (_unanswered > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF7ED),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '$_unanswered remaining',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: orange),
                      ),
                    ),

                  const Spacer(),

                  // Submit button (always visible)
                  GestureDetector(
                    onTap: _submitting ? null : () => setState(() => _showConfirm = true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: green,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _submitting ? 'Submitting...' : '✓ Submit',
                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  // Expand chevron
                  AnimatedRotation(
                    turns: _navExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(Icons.keyboard_arrow_down_rounded,
                        color: Color(0xFF64748B), size: 20),
                  ),
                ],
              ),
            ),
          ),

          // ── Expanded grid ──
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            child: _navExpanded
                ? Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
                    color: const Color(0xFFF8FAFC),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('QUESTION NAVIGATOR',
                            style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800,
                                color: Color(0xFF94A3B8), letterSpacing: 1.4)),
                        const SizedBox(height: 10),
                        // Legend
                        Row(
                          children: [
                            _legendDot(blue, 'Answered'),
                            const SizedBox(width: 12),
                            _legendDot(const Color(0xFFE2E8F0), 'Unanswered'),
                            const SizedBox(width: 12),
                            _legendDot(Colors.black, 'Current', border: true),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // Number grid — wraps full width
                        Wrap(
                          spacing: 5,
                          runSpacing: 5,
                          children: List.generate(_questions.length, (i) {
                            final q          = _questions[i];
                            final isAnswered = _answers.containsKey(q.id);
                            final isActive   = _activeQ == i;
                            return GestureDetector(
                              onTap: () => _scrollToQuestion(i),
                              child: Container(
                                width: 36, height: 36,
                                decoration: BoxDecoration(
                                  color: isAnswered ? blue : Colors.white,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: isActive ? Colors.black : const Color(0xFFD1D5DB),
                                    width: isActive ? 2 : 1,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    '${i + 1}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: isAnswered ? Colors.white : const Color(0xFF374151),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _legendDot(Color color, String label, {bool border = false}) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 14, height: 14,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(3),
          border: border ? Border.all(color: Colors.black, width: 2) : null,
        ),
      ),
      const SizedBox(width: 4),
      Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF64748B))),
    ],
  );

  // ── Full-screen Question List ─────────────────────────────
  Widget _buildQuestionList() {
    return ListView.builder(
      controller: _scrollCtrl,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
      itemCount: _questions.length + 1,
      itemBuilder: (_, i) {
        if (i == _questions.length) return _buildBottomSubmit();
        return _buildQuestionCard(i);
      },
    );
  }

  Widget _buildQuestionCard(int i) {
    final q        = _questions[i];
    final selected = _answers[q.id];
    final isActive = _activeQ == i;

    return GestureDetector(
      onTap: () => setState(() => _activeQ = i),
      child: Container(
        key: _qKeys[i],
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color:        Colors.white,
          borderRadius: BorderRadius.circular(14),
          border:       Border.all(color: isActive ? blue : border, width: isActive ? 1.5 : 1),
          boxShadow:    isActive
              ? [BoxShadow(color: blue.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 3))]
              : [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4)],
        ),
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question header
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 34, height: 34,
                  decoration: BoxDecoration(
                    color: selected != null ? blue : isActive ? navy : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '${i + 1}',
                      style: TextStyle(
                        color: (selected != null || isActive) ? Colors.white : const Color(0xFF374151),
                        fontSize: 13, fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    q.question,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600,
                        color: Color(0xFF0F172A), height: 1.6),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Options — full width
            ...['A', 'B', 'C', 'D'].map((key) {
              final text = q.options[key];
              if (text == null || text.isEmpty) return const SizedBox.shrink();
              final isSelected = selected == key;
              return GestureDetector(
                onTap: () => setState(() {
                  _answers[q.id] = key;
                  _activeQ = i;
                }),
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                  decoration: BoxDecoration(
                    color:        isSelected ? const Color(0xFFEFF6FF) : const Color(0xFFFAFAFA),
                    borderRadius: BorderRadius.circular(10),
                    border:       Border.all(color: isSelected ? blue : border, width: 1.5),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 28, height: 28,
                        decoration: BoxDecoration(
                          color:        isSelected ? blue : const Color(0xFFE2E8F0),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Center(
                          child: Text(
                            key,
                            style: TextStyle(
                              color: isSelected ? Colors.white : const Color(0xFF374151),
                              fontSize: 12, fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          text,
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                      ),
                      if (isSelected)
                        const Icon(Icons.check_circle_rounded, color: blue, size: 18),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSubmit() {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color:        Colors.white,
        borderRadius: BorderRadius.circular(14),
        border:       Border.all(color: border),
      ),
      child: Row(
        children: [
          RichText(
            text: TextSpan(children: [
              TextSpan(
                text: '$_answeredCount / $_totalCount ',
                style: TextStyle(
                  color: _answeredCount == _totalCount ? green : orange,
                  fontWeight: FontWeight.w700, fontSize: 13,
                ),
              ),
              const TextSpan(
                text: 'questions answered',
                style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
              ),
            ]),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: _submitting ? null : () => setState(() => _showConfirm = true),
            style: ElevatedButton.styleFrom(
              backgroundColor: green,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('✓ Submit Exam',
                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  // ── Confirm Modal ─────────────────────────────────────────
  Widget _buildConfirmModal() {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color:        Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow:    [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 40)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_unanswered > 0 ? '⚠️' : '✅', style: const TextStyle(fontSize: 40)),
              const SizedBox(height: 14),
              Text(
                _unanswered > 0 ? 'Unanswered Questions' : 'Ready to Submit?',
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A)),
              ),
              const SizedBox(height: 8),
              Text(
                _unanswered > 0
                    ? 'You have $_unanswered unanswered question${_unanswered > 1 ? 's' : ''}. '
                      'Unanswered questions will be marked incorrect.'
                    : 'You\'ve answered all $_totalCount questions. '
                      'Once submitted, you cannot change your answers.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), height: 1.5),
              ),
              const SizedBox(height: 6),
              Text(
                'Time remaining: ${formatTime(_timeLeft)}',
                style: TextStyle(
                  fontSize: 12,
                  color: _timeCritical ? red : const Color(0xFF94A3B8),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => setState(() => _showConfirm = false),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Continue Exam',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submitting ? null : () {
                        setState(() => _showConfirm = false);
                        _submitExam();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: green,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text(
                        _submitting ? 'Submitting...' : 'Yes, Submit',
                        style: const TextStyle(color: Colors.white,
                            fontWeight: FontWeight.w700, fontSize: 13),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// EXAM RESULTS SCREEN (unchanged)
// ─────────────────────────────────────────────────────────────
class ExamResultsScreen extends StatefulWidget {
  final Map<String, dynamic> result;
  final String examName;
  final String bundleId;
  final bool   isTimeout;

  const ExamResultsScreen({
    super.key,
    required this.result,
    required this.examName,
    required this.bundleId,
    required this.isTimeout,
  });

  @override
  State<ExamResultsScreen> createState() => _ExamResultsScreenState();
}

class _ExamResultsScreenState extends State<ExamResultsScreen> {
  static const Color navy   = Color(0xFF0F172A);
  static const Color blue   = Color(0xFF2563EB);
  static const Color green  = Color(0xFF16A34A);
  static const Color red    = Color(0xFFDC2626);
  static const Color border = Color(0xFFE2E8F0);

  String _filter = 'all';

  @override
  Widget build(BuildContext context) {
    final r         = widget.result;
    final score     = r['score'] ?? 0;
    final passed    = r['passed'] ?? false;
    final correct   = r['correctCount'] ?? 0;
    final total     = r['totalCount'] ?? 0;
    final incorrect = total - correct;
    final version   = r['version'] ?? '';
    final attemptNum= r['attemptNumber'] ?? 1;
    final graded    = (r['gradedQuestions'] as List? ?? []).cast<Map<String, dynamic>>();

    final filtered = graded.where((q) {
      if (_filter == 'correct')   return q['isCorrect'] == true;
      if (_filter == 'incorrect') return q['isCorrect'] != true;
      return true;
    }).toList();

    final scoreColor = passed ? green : red;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                  colors: passed
                      ? [navy, const Color(0xFF064E3B)]
                      : [navy, const Color(0xFF450A0A)],
                ),
              ),
              padding: const EdgeInsets.fromLTRB(20, 48, 20, 24),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          passed ? '✓ Congratulations — Exam Complete'
                              : widget.isTimeout ? '⏰ Time Expired — Exam Submitted'
                              : '✗ Exam Complete',
                          style: TextStyle(
                            color: passed ? const Color(0xFF4ADE80) : const Color(0xFFF87171),
                            fontSize: 11, fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(passed ? 'PASSED' : 'FAILED',
                            style: const TextStyle(color: Colors.white, fontSize: 40,
                                fontWeight: FontWeight.w900, letterSpacing: -1)),
                        const SizedBox(height: 4),
                        Text(widget.examName,
                            style: const TextStyle(color: Colors.white70, fontSize: 13)),
                        const SizedBox(height: 6),
                        Text('$version  •  Attempt #$attemptNum',
                            style: const TextStyle(color: Colors.white38, fontSize: 11)),
                      ],
                    ),
                  ),
                  Container(
                    width: 90, height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: scoreColor, width: 4),
                      color: Colors.black26,
                    ),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text('$score%', style: const TextStyle(color: Colors.white,
                          fontSize: 26, fontWeight: FontWeight.w900)),
                      const Text('SCORE', style: TextStyle(color: Colors.white54, fontSize: 9, letterSpacing: 1)),
                    ]),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(children: [
                _statCard('$correct',   'Correct',   '✓', green,  const Color(0xFFF0FDF4), const Color(0xFFBBF7D0)),
                const SizedBox(width: 10),
                _statCard('$incorrect', 'Incorrect', '✗', red,    const Color(0xFFFEF2F2), const Color(0xFFFECACA)),
                const SizedBox(width: 10),
                _statCard('$total',     'Total Qs',  '?', blue,   const Color(0xFFEFF6FF), const Color(0xFFBFDBFE)),
                const SizedBox(width: 10),
                _statCard('70%',        'Passing',   '★', const Color(0xFFD97706), const Color(0xFFFFFBEB), const Color(0xFFFDE68A)),
              ]),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(children: [
                _filterTab('all',       'All ($total)'),
                const SizedBox(width: 8),
                _filterTab('incorrect', 'Incorrect ($incorrect)'),
                const SizedBox(width: 8),
                _filterTab('correct',   'Correct ($correct)'),
              ]),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 12)),

          SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, i) {
                if (i == filtered.length) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextButton(
                      onPressed: () => Navigator.pushNamedAndRemoveUntil(
                          context, '/my-courses', (_) => false),
                      child: const Text('← Back to My Courses',
                          style: TextStyle(color: blue, fontSize: 14, fontWeight: FontWeight.w700)),
                    ),
                  );
                }
                return _buildReviewCard(filtered[i], i);
              },
              childCount: filtered.length + 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(String val, String label, String icon, Color color, Color bg, Color borderC) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border(top: BorderSide(color: color, width: 3)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6)],
        ),
        child: Column(children: [
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8),
                border: Border.all(color: borderC)),
            child: Center(child: Text(icon, style: TextStyle(color: color, fontWeight: FontWeight.w900))),
          ),
          const SizedBox(height: 6),
          Text(val, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
          Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF64748B))),
        ]),
      ),
    );
  }

  Widget _filterTab(String key, String label) {
    final isActive = _filter == key;
    Color bg = isActive
        ? (key == 'incorrect' ? red : key == 'correct' ? green : navy)
        : Colors.white;
    return GestureDetector(
      onTap: () => setState(() => _filter = key),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isActive ? Colors.transparent : border),
        ),
        child: Text(label, style: TextStyle(
          color: isActive ? Colors.white : const Color(0xFF374151),
          fontSize: 12, fontWeight: FontWeight.w600,
        )),
      ),
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> q, int i) {
    final isCorrect = q['isCorrect'] == true;
    final opts      = q['options'] as Map<String, dynamic>? ?? {};

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: 28, height: 28,
            decoration: BoxDecoration(
              color: isCorrect ? const Color(0xFFF0FDF4) : const Color(0xFFFEF2F2),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: isCorrect ? const Color(0xFFBBF7D0) : const Color(0xFFFECACA)),
            ),
            child: Center(child: Text(
              '${q['questionNumber'] ?? (i + 1)}',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800,
                  color: isCorrect ? green : red),
            )),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(q['question'] ?? '',
              style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600,
                  color: Color(0xFF0F172A), height: 1.5))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isCorrect ? const Color(0xFFF0FDF4) : const Color(0xFFFEF2F2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: isCorrect ? const Color(0xFFBBF7D0) : const Color(0xFFFECACA)),
            ),
            child: Text(isCorrect ? '✓ Correct' : '✗ Incorrect',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
                    color: isCorrect ? green : red)),
          ),
        ]),
        const SizedBox(height: 12),
        ...['A', 'B', 'C', 'D'].map((key) {
          final text = opts[key]?.toString() ?? '';
          if (text.isEmpty) return const SizedBox.shrink();
          final isStudentAns = q['studentAnswer'] == key;
          final isCorrectAns = q['correctAnswer'] == key;

          Color bg = const Color(0xFFFAFAFA), bColor = border,
                tColor = const Color(0xFF374151), kBg = const Color(0xFFE2E8F0),
                kColor = const Color(0xFF374151);

          if (isCorrectAns) {
            bg = const Color(0xFFF0FDF4); bColor = const Color(0xFF86EFAC);
            tColor = const Color(0xFF15803D); kBg = green; kColor = Colors.white;
          }
          if (isStudentAns && !isCorrectAns) {
            bg = const Color(0xFFFEF2F2); bColor = const Color(0xFFFCA5A5);
            tColor = const Color(0xFFB91C1C); kBg = red; kColor = Colors.white;
          }

          return Container(
            margin: const EdgeInsets.only(bottom: 6),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8),
                border: Border.all(color: bColor, width: 1.5)),
            child: Row(children: [
              Container(width: 24, height: 24,
                decoration: BoxDecoration(color: kBg, borderRadius: BorderRadius.circular(5)),
                child: Center(child: Text(key, style: TextStyle(color: kColor, fontSize: 10, fontWeight: FontWeight.w700)))),
              const SizedBox(width: 10),
              Expanded(child: Text(text, style: TextStyle(fontSize: 12.5, color: tColor,
                  fontWeight: (isCorrectAns || isStudentAns) ? FontWeight.w600 : FontWeight.w400))),
              if (isCorrectAns)
                Text('✓ Correct', style: TextStyle(fontSize: 10, color: green, fontWeight: FontWeight.w700)),
              if (isStudentAns && !isCorrectAns)
                Text('✗ Your Answer', style: TextStyle(fontSize: 10, color: red, fontWeight: FontWeight.w700)),
            ]),
          );
        }),
        if (q['pageReference'] != null && q['pageReference'].toString().isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text('📖 Page Reference: ${q['pageReference']}',
                style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
          ),
      ]),
    );
  }
}