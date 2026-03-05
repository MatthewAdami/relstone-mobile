import 'package:flutter/material.dart';
import 'package:relstone_mobile/services/insurance_service.dart';

class InsuranceCEScreen extends StatefulWidget {
  final bool startInDetailMode;
  final String? initialStateSlug;
  final String? initialStateName;

  const InsuranceCEScreen({
    super.key,
    this.startInDetailMode = false,
    this.initialStateSlug,
    this.initialStateName,
  });

  @override
  State<InsuranceCEScreen> createState() => _InsuranceCEScreenState();
}

class _InsuranceCEScreenState extends State<InsuranceCEScreen> {
  static const Color primaryNavy = Color(0xFF1A3A5C);
  static const Color accentBlue = Color(0xFF2E7EBE);
  static const Color successGreen = Color(0xFF0A7A5B);
  static const Color bg = Color(0xFFF4F6F9);
  static const Color cardBorder = Color(0xFFD8E0EB);
  static const Color textMuted = Color(0xFF6B7E92);

  String _selectedStateCode = 'All';
  bool _argsInitialized = false;
  bool _isStateDetailMode = false;
  bool _isDetailLoading = false;
  String? _detailError;
  String _detailStateSlug = '';
  String _detailStateName = '';
  String _detailStateCode = '';
  Map<String, dynamic> _detailStateData = {};
  List<Map<String, dynamic>> _detailCourses = [];
  Map<String, int> _liveCourseCountsBySlug = {};

  static const Map<String, String> _stateCodeToSlug = {
    'AL': 'alabama',
    'AR': 'arkansas',
    'AZ': 'arizona',
    'CA': 'california',
    'CO': 'colorado',
    'CT': 'connecticut',
    'DC': 'district-of-columbia',
    'DE': 'delaware',
    'FL': 'florida',
    'GA': 'georgia',
    'HI': 'hawaii',
    'ID': 'idaho',
    'IN': 'indiana',
    'KS': 'kansas',
    'KY': 'kentucky',
    'LA': 'louisiana',
    'MD': 'maryland',
    'ME': 'maine',
    'MI': 'michigan',
    'MO': 'missouri',
    'MS': 'mississippi',
    'NC': 'north-carolina',
    'ND': 'north-dakota',
    'NH': 'new-hampshire',
    'NM': 'new-mexico',
    'NV': 'nevada',
    'NY': 'new-york',
    'OH': 'ohio',
    'OK': 'oklahoma',
    'OR': 'oregon',
    'PA': 'pennsylvania',
    'RI': 'rhode-island',
    'SD': 'south-dakota',
    'TN': 'tennessee',
    'TX': 'texas',
    'UT': 'utah',
    'VA': 'virginia',
    'VT': 'vermont',
    'WA': 'washington',
    'WV': 'west-virginia',
    'WY': 'wyoming',
  };

  static const List<InsuranceStateItem> _states = [
    InsuranceStateItem(
      code: 'AL',
      name: 'Alabama Insurance Continuing Education Courses',
      courses: 8,
    ),
    InsuranceStateItem(
      code: 'AR',
      name: 'Arkansas Insurance Continuing Education Courses',
      courses: 12,
    ),
    InsuranceStateItem(
      code: 'AZ',
      name: 'Arizona Insurance Continuing Education Courses',
      courses: 7,
    ),
    InsuranceStateItem(code: 'CA', name: 'CA Insurance CE', courses: 16),
    InsuranceStateItem(
      code: 'CO',
      name: 'Colorado Insurance Continuing Education Courses',
      courses: 12,
    ),
    InsuranceStateItem(
      code: 'CT',
      name: 'Connecticut Insurance Continuing Education Online Courses',
      courses: 9,
    ),
    InsuranceStateItem(
      code: 'DC',
      name: 'District of Columbia Insurance Continuing Education Courses',
      courses: 5,
    ),
    InsuranceStateItem(
      code: 'DE',
      name: 'Delaware Insurance Continuing Education Courses',
      courses: 11,
    ),
    InsuranceStateItem(code: 'FL', name: 'Florida Insurance CE', courses: 55),
    InsuranceStateItem(
      code: 'GA',
      name: 'Georgia Insurance CE online classes',
      courses: 8,
    ),
    InsuranceStateItem(
      code: 'HI',
      name: 'Hawaii Insurance CE Courses',
      courses: 20,
    ),
    InsuranceStateItem(
      code: 'ID',
      name: 'Idaho Insurance CE Courses',
      courses: 6,
    ),
    InsuranceStateItem(
      code: 'IN',
      name: 'Indiana Insurance CE Courses',
      courses: 9,
    ),
    InsuranceStateItem(
      code: 'KS',
      name: 'Kansas Insurance CE Courses',
      courses: 16,
    ),
    InsuranceStateItem(
      code: 'KY',
      name: 'Kentucky Insurance CE Courses',
      courses: 6,
    ),
    InsuranceStateItem(
      code: 'LA',
      name: 'Louisiana Insurance CE Courses',
      courses: 9,
    ),
    InsuranceStateItem(
      code: 'MD',
      name: 'Maryland Insurance Continuing Education Courses',
      courses: 13,
    ),
    InsuranceStateItem(
      code: 'ME',
      name: 'Maine Insurance Continuing Education Courses',
      courses: 10,
    ),
    InsuranceStateItem(
      code: 'MI',
      name: 'Michigan Insurance Continuing Education Courses',
      courses: 9,
    ),
    InsuranceStateItem(
      code: 'MO',
      name: 'Missouri Insurance Continuing Education Courses',
      courses: 9,
    ),
    InsuranceStateItem(
      code: 'MS',
      name: 'Mississippi Insurance Continuing Education Courses',
      courses: 7,
    ),
    InsuranceStateItem(
      code: 'NC',
      name: 'North Carolina Insurance Continuing Education Courses',
      courses: 11,
    ),
    InsuranceStateItem(
      code: 'ND',
      name: 'North Dakota Insurance Continuing Education Courses',
      courses: 4,
    ),
    InsuranceStateItem(
      code: 'NH',
      name: 'New Hampshire Insurance Continuing Education Courses',
      courses: 5,
    ),
    InsuranceStateItem(
      code: 'NM',
      name: 'New Mexico Insurance Continuing Education Courses',
      courses: 10,
    ),
    InsuranceStateItem(
      code: 'NV',
      name: 'Nevada Insurance Continuing Education Courses',
      courses: 2,
    ),
    InsuranceStateItem(code: 'NY', name: 'New York Insurance CE', courses: 9),
    InsuranceStateItem(
      code: 'OH',
      name: 'Ohio Insurance Continuing Education Courses',
      courses: 5,
    ),
    InsuranceStateItem(
      code: 'OK',
      name: 'Oklahoma Insurance Continuing Education Courses',
      courses: 9,
    ),
    InsuranceStateItem(
      code: 'OR',
      name: 'Oregon Insurance Continuing Education Courses',
      courses: 11,
    ),
    InsuranceStateItem(
      code: 'PA',
      name: 'Pennsylvania Insurance Continuing Education Courses',
      courses: 12,
    ),
    InsuranceStateItem(
      code: 'RI',
      name: 'Rhode Island Insurance Continuing Education Courses',
      courses: 4,
    ),
    InsuranceStateItem(
      code: 'SD',
      name: 'South Dakota Insurance Continuing Education Courses',
      courses: 9,
    ),
    InsuranceStateItem(
      code: 'TN',
      name: 'Tennessee Insurance Continuing Education Courses',
      courses: 18,
    ),
    InsuranceStateItem(code: 'TX', name: 'Texas Insurance CE', courses: 6),
    InsuranceStateItem(
      code: 'UT',
      name: 'Utah Insurance Continuing Education Courses',
      courses: 13,
    ),
    InsuranceStateItem(
      code: 'VA',
      name: 'Virginia Insurance Continuing Education Courses',
      courses: 4,
    ),
    InsuranceStateItem(
      code: 'VT',
      name: 'Vermont Insurance Continuing Education Courses',
      courses: 3,
    ),
    InsuranceStateItem(
      code: 'WA',
      name: 'Washington Insurance Continuing Education Courses',
      courses: 7,
    ),
    InsuranceStateItem(
      code: 'WV',
      name: 'West Virginia Insurance Continuing Education Courses',
      courses: 6,
    ),
    InsuranceStateItem(
      code: 'WY',
      name: 'Wyoming Insurance Continuing Education Courses',
      courses: 3,
    ),
  ];

  List<InsuranceStateItem> get _filteredStates {
    return _states.where((state) {
      final matchesCode =
          _selectedStateCode == 'All' || state.code == _selectedStateCode;
      return matchesCode;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _loadLiveStateCourseCounts();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_argsInitialized) return;
    _argsInitialized = true;

    String stateSlug = (widget.initialStateSlug ?? '').trim();
    String stateName = (widget.initialStateName ?? '').trim();
    bool shouldOpenDetail = widget.startInDetailMode;

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map<String, dynamic>) {
      final argCode = (args['stateCode'] ?? '').toString().trim();
      final argSlug = (args['stateSlug'] ?? '').toString().trim();
      final argName = (args['stateName'] ?? '').toString().trim();
      if (argCode.isNotEmpty) _detailStateCode = argCode;
      if (argSlug.isNotEmpty) stateSlug = argSlug;
      if (argName.isNotEmpty) stateName = argName;
      shouldOpenDetail = shouldOpenDetail || argSlug.isNotEmpty || argName.isNotEmpty;
    }

    if (!shouldOpenDetail && stateSlug.isEmpty && stateName.isEmpty) return;

    _isStateDetailMode = true;
    _detailStateName = stateName;
    _detailStateSlug = stateSlug.isNotEmpty ? stateSlug : _slugify(stateName);
    if (_detailStateCode.isEmpty) {
      _detailStateCode = _stateCodeFromSlug(_detailStateSlug);
    }

    if (_detailStateSlug.isEmpty) {
      _detailError = 'Missing state information.';
      _isDetailLoading = false;
      return;
    }

    _loadStateDetailData();
  }

  String _slugify(String value) {
    return value
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-|-$'), '');
  }

  List<String> _stringList(dynamic value) {
    if (value is List) {
      return value
          .map((item) => item.toString())
          .where((text) => text.isNotEmpty)
          .toList();
    }
    if (value is String && value.trim().isNotEmpty) {
      return [value.trim()];
    }
    return [];
  }

  String _stateCodeFromSlug(String slug) {
    final cleanSlug = slug.trim().toLowerCase();
    if (cleanSlug.isEmpty) return '';
    for (final entry in _stateCodeToSlug.entries) {
      if (entry.value == cleanSlug) {
        return entry.key;
      }
    }
    return '';
  }

  String _stateCodeFromName(String name) {
    final cleanName = name.trim().toLowerCase();
    if (cleanName.isEmpty) return '';
    for (final item in _states) {
      if (item.name.toLowerCase().startsWith(cleanName)) {
        return item.code;
      }
    }
    return '';
  }

  Future<void> _loadStateDetailData() async {
    if (!mounted) return;
    setState(() {
      _isDetailLoading = true;
      _detailError = null;
    });

    final result = await InsuranceService.fetchStateWithCourses(_detailStateSlug);
    if (!mounted) return;

    if (result['success'] == true) {
      final state = (result['state'] as Map?)?.cast<String, dynamic>() ?? {};
      final coursesRaw = (result['courses'] as List?) ?? [];
      final courses = coursesRaw
          .whereType<Map>()
          .map((item) => item.cast<String, dynamic>())
          .toList();

      setState(() {
        _detailStateData = state;
        _detailCourses = courses;
        _detailStateName = (state['name'] ?? _detailStateName).toString();
        if (_detailStateCode.isEmpty) {
          _detailStateCode = _stateCodeFromSlug(_detailStateSlug);
        }
        if (_detailStateCode.isEmpty) {
          _detailStateCode = _stateCodeFromName(_detailStateName);
        }
        _isDetailLoading = false;
      });
      return;
    }

    setState(() {
      _detailError = (result['message'] ?? 'Unable to load data').toString();
      _isDetailLoading = false;
    });
  }

  Future<void> _loadLiveStateCourseCounts() async {
    if (!mounted) return;

    final entries = _stateCodeToSlug.entries.toList();
    final futures = entries.map((entry) async {
      final result = await InsuranceService.fetchCoursesByStateSlug(entry.value);
      final rawCourses = (result['courses'] as List?) ?? <dynamic>[];
      final activeCourses = rawCourses.where((course) {
        if (course is! Map) return false;
        final value = course['isActive'];
        if (value is bool) return value;
        if (value is String) return value.toLowerCase() == 'true';
        return true;
      }).length;
      return MapEntry(entry.value, activeCourses);
    }).toList();

    final loadedEntries = await Future.wait(futures);
    if (!mounted) return;

    final loadedMap = <String, int>{};
    for (final item in loadedEntries) {
      loadedMap[item.key] = item.value;
    }

    setState(() {
      _liveCourseCountsBySlug = loadedMap;
    });
  }

  Widget _buildStateDetailScaffold(BuildContext context) {
    final stateDisplayName = _detailStateName.isEmpty
        ? 'Insurance Continuing Education Courses'
        : _detailStateName;
    final heroTitle = (_detailStateData['heroTitle'] ?? '').toString().trim();
    final heroSubtitle = (_detailStateData['metaDescription'] ?? '').toString().trim();
    final pageTitle = heroTitle.isNotEmpty
        ? heroTitle
        : '$stateDisplayName Insurance Continuing Education Courses';
    final subtitle = heroSubtitle.isNotEmpty
        ? heroSubtitle
        : 'Browse our selection of ${stateDisplayName.toLowerCase()} insurance continuing education courses.';

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text(
          _detailStateName.isEmpty ? 'Insurance CE' : '$_detailStateName Insurance CE',
          style: const TextStyle(
            color: primaryNavy,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        iconTheme: const IconThemeData(color: primaryNavy),
      ),
      body: _isDetailLoading
          ? const Center(child: CircularProgressIndicator())
          : _detailError != null
          ? _InsuranceStateErrorView(
              message: _detailError!,
              onRetry: _loadStateDetailData,
            )
          : RefreshIndicator(
              onRefresh: _loadStateDetailData,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;
                  final isDesktop = width >= 1040;
                  final isTablet = width >= 700;
                  final crossAxisCount = isDesktop ? 2 : 1;
                  final contentWidth = isDesktop
                      ? 1280.0
                      : (isTablet ? 980.0 : width);

                  return ListView(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
                    children: [
                      Center(
                        child: SizedBox(
                          width: contentWidth,
                          child: _InsuranceStateHero(
                            stateCode: _detailStateCode,
                            title: pageTitle,
                            subtitle: subtitle,
                            courseCount: _detailCourses.length,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (_detailCourses.isEmpty)
                        Center(
                          child: SizedBox(
                            width: contentWidth,
                            child: const _InsuranceStateEmptyCourses(),
                          ),
                        )
                      else
                        Center(
                          child: SizedBox(
                            width: contentWidth,
                            child: GridView.builder(
                              itemCount: _detailCourses.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                childAspectRatio: isDesktop ? 1.6 : 1.42,
                              ),
                              itemBuilder: (context, index) {
                                final course = _detailCourses[index];
                                return _InsuranceStateCourseCard(
                                  course: course,
                                  stateLabel: pageTitle,
                                  stateData: _detailStateData,
                                  allCourses: _detailCourses,
                                );
                              },
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isStateDetailMode) {
      return _buildStateDetailScaffold(context);
    }

    final stateCodes = ['All', ..._states.map((item) => item.code)];

    return Scaffold(
      backgroundColor: bg,
      drawer: const _InsuranceAppSidebar(),
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
            tooltip: 'Cart',
            onPressed: () => Navigator.pushNamed(context, '/cart'),
            icon: const Icon(Icons.shopping_cart_outlined, color: primaryNavy),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final isDesktop = width >= 1200;
          final isTablet = width >= 760;

          final int crossAxisCount;
          if (isDesktop) {
            crossAxisCount = 5;
          } else if (isTablet) {
            crossAxisCount = 3;
          } else {
            crossAxisCount = 2;
          }

          final double contentWidth = isDesktop
              ? 1240
              : (isTablet ? 980 : width);

          return ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                width: double.infinity,
                color: const Color(0xFF1E3A5F),
                padding: const EdgeInsets.symmetric(
                  vertical: 54,
                  horizontal: 20,
                ),
                child: const Column(
                  children: [
                    Text(
                      'Insurance Continuing Education',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'State-approved CE courses for insurance license renewal',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFDCE7F7),
                        fontSize: 15,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: SizedBox(
                  width: contentWidth,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 26),
                    child: Column(
                      children: [
                        _HeroCard(totalStates: _states.length),
                        const SizedBox(height: 14),
                        const _InsuranceSectionTitle(
                          eyebrow: 'OUR SERVICES',
                          title: 'Select your Insurance CE state',
                          subtitle:
                              'To get started, choose a state below and continue with the same Relstone learning experience.',
                        ),
                        const SizedBox(height: 12),
                        _FilterCard(
                          selectedStateCode: _selectedStateCode,
                          stateCodes: stateCodes,
                          onStateChanged: (value) {
                            if (value == null) return;
                            setState(() {
                              _selectedStateCode = value;
                            });
                          },
                        ),
                        const SizedBox(height: 14),
                        GridView.builder(
                          itemCount: _filteredStates.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                childAspectRatio: isDesktop ? 1.03 : 0.96,
                              ),
                          itemBuilder: (context, index) {
                            final state = _filteredStates[index];
                            final stateSlug =
                                _stateCodeToSlug[state.code] ??
                                state.name
                                    .split(' ')
                                    .first
                                    .toLowerCase();
                            final dynamicCount = _liveCourseCountsBySlug[stateSlug];
                            final effectiveCount = dynamicCount ?? state.courses;

                            return _StateCard(
                              item: state,
                              courseCount: effectiveCount,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => InsuranceCEScreen(
                                      startInDetailMode: true,
                                      initialStateSlug: stateSlug,
                                      initialStateName: state.name,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        const _WhyChooseSection(),
                        const SizedBox(height: 18),
                        const _FooterSection(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class InsuranceStateItem {
  final String code;
  final String name;
  final int courses;

  const InsuranceStateItem({
    required this.code,
    required this.name,
    required this.courses,
  });
}

class _HeroCard extends StatelessWidget {
  final int totalStates;

  const _HeroCard({required this.totalStates});

  static const Color accentBlue = _InsuranceCEScreenState.accentBlue;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _InsuranceCEScreenState.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 24, 18, 24),
        child: Column(
          children: [
            const Text(
              'Choose Your State',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _InsuranceCEScreenState.primaryNavy,
                fontSize: 30,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Browse available insurance CE courses by state and start your renewal requirements online at your own pace.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _InsuranceCEScreenState.textMuted,
                fontSize: 15,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: accentBlue.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '$totalStates States Available',
                style: const TextStyle(
                  color: _InsuranceCEScreenState.primaryNavy,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterCard extends StatelessWidget {
  final String selectedStateCode;
  final List<String> stateCodes;
  final ValueChanged<String?> onStateChanged;

  const _FilterCard({
    required this.selectedStateCode,
    required this.stateCodes,
    required this.onStateChanged,
  });

  static const Color cardBorder = _InsuranceCEScreenState.cardBorder;
  static const Color textMuted = _InsuranceCEScreenState.textMuted;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 16, 14, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Select Your State:',
              style: TextStyle(
                color: textMuted,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 540),
              child: DropdownButtonFormField<String>(
                initialValue: selectedStateCode,
                isExpanded: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: cardBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: _InsuranceCEScreenState.accentBlue,
                      width: 1.2,
                    ),
                  ),
                ),
                items: stateCodes
                    .map(
                      (code) => DropdownMenuItem<String>(
                        value: code,
                        child: Text(
                          code == 'All' ? '-- Choose a State --' : code,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: onStateChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StateCard extends StatelessWidget {
  final InsuranceStateItem item;
  final int courseCount;
  final VoidCallback onTap;

  const _StateCard({
    required this.item,
    required this.courseCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: _InsuranceCEScreenState.primaryNavy.withOpacity(0.06),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.code,
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: _InsuranceCEScreenState.primaryNavy,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.fade,
                  style: const TextStyle(
                    color: _InsuranceCEScreenState.primaryNavy,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '$courseCount Courses',
                  style: const TextStyle(
                    color: _InsuranceCEScreenState.textMuted,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
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

class _WhyChooseSection extends StatelessWidget {
  const _WhyChooseSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _InsuranceCEScreenState.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
        child: Column(
          children: [
            Text(
              'Why Choose RelStone for Insurance CE?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: _InsuranceCEScreenState.primaryNavy,
              ),
            ),
            const SizedBox(height: 18),
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 900;

                if (isWide) {
                  return const Row(
                    children: [
                      Expanded(
                        child: _WhyChooseCard(
                          title: 'State Approved',
                          subtitle:
                              'All courses meet state requirements for insurance license renewal.',
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _WhyChooseCard(
                          title: 'Self-Paced',
                          subtitle:
                              'Study on your schedule, from any device, anywhere.',
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _WhyChooseCard(
                          title: 'Instant Certificates',
                          subtitle:
                              'Download your completion certificate immediately upon passing.',
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _WhyChooseCard(
                          title: 'Support',
                          subtitle:
                              'Phone and email support available for any questions.',
                        ),
                      ),
                    ],
                  );
                }

                return const Column(
                  children: [
                    _WhyChooseCard(
                      title: 'State Approved',
                      subtitle:
                          'All courses meet state requirements for insurance license renewal.',
                    ),
                    SizedBox(height: 12),
                    _WhyChooseCard(
                      title: 'Self-Paced',
                      subtitle:
                          'Study on your schedule, from any device, anywhere.',
                    ),
                    SizedBox(height: 12),
                    _WhyChooseCard(
                      title: 'Instant Certificates',
                      subtitle:
                          'Download your completion certificate immediately upon passing.',
                    ),
                    SizedBox(height: 12),
                    _WhyChooseCard(
                      title: 'Support',
                      subtitle:
                          'Phone and email support available for any questions.',
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _WhyItem extends StatelessWidget {
  final String number;
  final String title;
  final String subtitle;

  const _WhyItem({
    required this.number,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            color: _InsuranceCEScreenState.accentBlue,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            number,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: _InsuranceCEScreenState.primaryNavy,
            fontWeight: FontWeight.w700,
            fontSize: 22,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: _InsuranceCEScreenState.textMuted,
            fontSize: 12,
            height: 1.25,
          ),
        ),
      ],
    );
  }
}

class _InsuranceSectionTitle extends StatelessWidget {
  final String? eyebrow;
  final String title;
  final String subtitle;

  const _InsuranceSectionTitle({
    this.eyebrow,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (eyebrow != null && eyebrow!.trim().isNotEmpty) ...[
          Text(
            eyebrow!,
            style: const TextStyle(
              fontSize: 11,
              letterSpacing: 1.8,
              fontWeight: FontWeight.w700,
              color: _InsuranceCEScreenState.textMuted,
            ),
          ),
          const SizedBox(height: 10),
        ],
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: _InsuranceCEScreenState.primaryNavy,
            height: 1.15,
          ),
        ),
        if (subtitle.trim().isNotEmpty) ...[
          const SizedBox(height: 10),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13.5,
              color: _InsuranceCEScreenState.textMuted,
              height: 1.45,
            ),
          ),
        ],
      ],
    );
  }
}

class _WhyChooseCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const _WhyChooseCard({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _InsuranceCEScreenState.primaryNavy.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: const Color(0xFF16A34A),
                borderRadius: BorderRadius.circular(17),
              ),
              child: const Icon(Icons.check_rounded, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: _InsuranceCEScreenState.primaryNavy,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: _InsuranceCEScreenState.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FooterSection extends StatelessWidget {
  const _FooterSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0B1A2A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.home_work_rounded, color: Colors.white),
              SizedBox(width: 10),
              Text(
                'RELSTONE',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Providing quality education for\nCalifornia Real Estate and Insurance professionals.',
            style: TextStyle(color: Colors.white70, height: 1.45, fontSize: 13),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _FooterChip('Contact Us', () {
                Navigator.pushNamed(context, '/contact');
              }),
              _FooterChip('Privacy Policy', () {}),
              _FooterChip('Refund Policy', () {}),
              _FooterChip('Terms of Use', () {}),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(color: Colors.white12),
          const SizedBox(height: 10),
          const Text(
            '© 2026 Relstone. All rights reserved.',
            style: TextStyle(
              color: _InsuranceCEScreenState.textMuted,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _FooterChip(this.label, this.onTap);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white24),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _TopNavBar extends StatelessWidget {
  final double contentWidth;

  const _TopNavBar({required this.contentWidth});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: SizedBox(
          width: contentWidth,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 1020),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/relstone_logo.png',
                      height: 32,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Text(
                        'R',
                        style: TextStyle(
                          color: _InsuranceCEScreenState.accentBlue,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 18),
                    SizedBox(
                      width: 380,
                      child: Container(
                        height: 38,
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFE1E6EF)),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Text(
                                'Search...',
                                style: TextStyle(
                                  color: Color(0xFF8E9AAF),
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            Container(
                              width: 40,
                              height: 38,
                              decoration: const BoxDecoration(
                                color: _InsuranceCEScreenState.successGreen,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(3),
                                  bottomRight: Radius.circular(3),
                                ),
                              ),
                              child: const Icon(
                                Icons.search,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    const _NavText('CALIFORNIA REAL ESTATE'),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      color: const Color(0xFF1E4A85),
                      child: const Text(
                        'INSURANCE CE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const _NavText('CFP CE'),
                    const SizedBox(width: 10),
                    const _NavText('TESTIMONIALS'),
                    const SizedBox(width: 12),
                    const _NavText('CART / \$0.00'),
                    const SizedBox(width: 10),
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFF1E4A85)),
                      ),
                      child: const Center(
                        child: Text(
                          '0',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF1E4A85),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavText extends StatelessWidget {
  final String text;

  const _NavText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 10.5,
        color: Color(0xFF475266),
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _FooterBar extends StatelessWidget {
  const _FooterBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF061A36),
      padding: const EdgeInsets.fromLTRB(18, 24, 18, 14),
      child: Column(
        children: const [
          Text(
            'FOLLOW US',
            style: TextStyle(
              color: Color(0xFFC2CFE6),
              fontSize: 11,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _SocialCircle(icon: Icons.facebook),
              SizedBox(width: 10),
              _SocialCircle(icon: Icons.work),
              SizedBox(width: 10),
              _SocialCircle(icon: Icons.music_note),
              SizedBox(width: 10),
              _SocialCircle(icon: Icons.camera_alt),
            ],
          ),
          SizedBox(height: 14),
          Text(
            'HOME   SHOP   MY ACCOUNT   CART   PRIVACY POLICY   REFUND POLICY',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFFE8C24E),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Copyright 2026 © Relstone',
            style: TextStyle(color: Colors.white70, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _SocialCircle extends StatelessWidget {
  final IconData icon;

  const _SocialCircle({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: const BoxDecoration(
        color: Color(0xFF243C66),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 15),
    );
  }
}

class _InsuranceAppSidebar extends StatelessWidget {
  const _InsuranceAppSidebar();

  static const Color navBg = Color(0xFF0B1A2A);

  void _go(BuildContext context, String route) {
    Navigator.pop(context);
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
                      'RELSTONE',
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

            _InsuranceNavExpansion(
              title: 'States',
              children: [
                _InsuranceNavItem(
                  title: 'Select a State',
                  onTap: () => _go(context, '/states'),
                ),
              ],
            ),

            _InsuranceNavExpansion(
              title: 'California Real Estate',
              children: [
                _InsuranceNavItem(
                  title: 'Sales License',
                  onTap: () => _go(context, '/sales'),
                ),
                _InsuranceNavItem(
                  title: 'Broker License',
                  onTap: () => _go(context, '/broker'),
                ),
                _InsuranceNavItem(
                  title: '45 Hour DRE Renewal CE',
                  onTap: () => _go(context, '/dre-ce'),
                ),
              ],
            ),

            _InsuranceNavItem(
              title: 'Exam Prep',
              onTap: () => _go(context, '/exam-prep'),
            ),

            _InsuranceNavExpansion(
              title: 'Insurance CE',
              children: [
                _InsuranceNavItem(
                  title: 'Select a State',
                  onTap: () => _go(context, '/insurance-states'),
                ),
                _InsuranceNavItem(
                  title: 'Courses',
                  onTap: () => _go(context, '/insurance-courses'),
                ),
              ],
            ),

            _InsuranceNavItem(
              title: 'CFP Renewal',
              onTap: () => _go(context, '/cfp-renewal'),
            ),
            _InsuranceNavItem(
              title: 'About Us',
              onTap: () => _go(context, '/about'),
            ),
            _InsuranceNavItem(
              title: 'Contact Us',
              onTap: () => _go(context, '/contact'),
            ),

            const SizedBox(height: 10),
            const Divider(color: Colors.white12, height: 1),

            _InsuranceNavItem(
              title: 'Log out',
              color: Colors.redAccent,
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
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

class _InsuranceNavItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final Color? color;

  const _InsuranceNavItem({
    required this.title,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      onTap: onTap,
      title: Text(
        title,
        style: TextStyle(
          color: color ?? Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _InsuranceNavExpansion extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _InsuranceNavExpansion({required this.title, required this.children});

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
        collapsedIconColor: Colors.white70,
        iconColor: Colors.white70,
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        children: children,
      ),
    );
  }
}

class _InsuranceStateHero extends StatelessWidget {
  final String stateCode;
  final String title;
  final String subtitle;
  final int courseCount;

  const _InsuranceStateHero({
    required this.stateCode,
    required this.title,
    required this.subtitle,
    required this.courseCount,
  });

  @override
  Widget build(BuildContext context) {
    final normalizedCode = stateCode.trim().isEmpty
        ? title
              .split(' ')
              .where((word) => word.isNotEmpty)
              .take(2)
              .map((word) => word[0])
              .join()
              .toUpperCase()
        : stateCode.trim().toUpperCase();

    return Container(
      decoration: BoxDecoration(
        color: _InsuranceCEScreenState.primaryNavy,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF275086)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: _InsuranceCEScreenState.accentBlue,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(
              normalizedCode,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFFDCE7F7),
                    fontSize: 12,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF315BDD),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              '$courseCount Courses',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InsuranceStateCourseCard extends StatelessWidget {
  final Map<String, dynamic> course;
  final String stateLabel;
  final Map<String, dynamic> stateData;
  final List<Map<String, dynamic>> allCourses;

  const _InsuranceStateCourseCard({
    required this.course,
    required this.stateLabel,
    required this.stateData,
    required this.allCourses,
  });

  int _extractIncludedCount(String text) {
    final match = RegExp(r'includes?\s+(\d+)\s+approved\s+courses?', caseSensitive: false)
        .firstMatch(text);
    if (match == null) return 0;
    return int.tryParse(match.group(1) ?? '') ?? 0;
  }

  List<String> _stateBenefits() {
    final source = stateData['ceBullets'] ?? stateData['introBullets'];
    if (source is List) {
      return source
          .map((item) => item.toString().trim())
          .where((item) => item.isNotEmpty)
          .take(6)
          .toList();
    }
    return <String>[];
  }

  List<String> _howToCompleteSteps() {
    final examInstructions = stateData['examInstructions'];
    if (examInstructions is Map && examInstructions['online'] is List) {
      return (examInstructions['online'] as List)
          .map((item) => item.toString().trim())
          .where((item) => item.isNotEmpty)
          .take(4)
          .toList();
    }
    return const <String>[
      'Enroll — Get immediate access to your course.',
      'Study — Work through the lessons at your own pace.',
      'Pass Exams — Complete required final assessments.',
      'Get Certified — Download your completion certificate.',
    ];
  }

  @override
  Widget build(BuildContext context) {
    final name = (course['name'] ?? 'Untitled Course').toString();
    final description = (course['description'] ?? '').toString();
    final price = course['price'];
    final creditHours = (course['creditHours'] ?? '').toString();
    final courseType = (course['courseType'] ?? '').toString();
    final textbookPrice = course['printedTextbookPrice'];
    final hasPrintedTextbook = course['hasPrintedTextbook'] == true;
    final shortName = (course['shortName'] ?? '').toString();
    final effectiveDescription =
        description.trim().isNotEmpty ? description : 'Online, self-paced.';
    final headlineLabel = stateLabel.toUpperCase();
    final includedCount = _extractIncludedCount(effectiveDescription);
    final relatedCourses = allCourses
        .where((item) => item['_id'] != course['_id'])
        .toList()
      ..sort((a, b) {
        final aOrder = (a['sortOrder'] is num) ? (a['sortOrder'] as num).toInt() : 9999;
        final bOrder = (b['sortOrder'] is num) ? (b['sortOrder'] as num).toInt() : 9999;
        return aOrder.compareTo(bOrder);
      });

    final includedCourses = includedCount > 0
        ? relatedCourses.take(includedCount).toList()
        : relatedCourses.take(2).toList();
    final benefits = _stateBenefits();
    final steps = _howToCompleteSteps();

    void showCourseDetails() {
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
        ),
        builder: (ctx) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shortName.trim().isNotEmpty ? shortName : name,
                      style: const TextStyle(
                        color: _InsuranceCEScreenState.primaryNavy,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        if (courseType.trim().isNotEmpty)
                          _InsuranceStateDetailChip(label: courseType),
                        if (creditHours.trim().isNotEmpty)
                          _InsuranceStateDetailChip(label: '$creditHours Hours'),
                        if (price != null)
                          _InsuranceStateDetailChip(label: '\$${price.toString()}'),
                        if (hasPrintedTextbook)
                          _InsuranceStateDetailChip(
                            label: textbookPrice == null
                                ? 'Printed Textbook Available'
                                : 'Textbook +\$${textbookPrice.toString()}',
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      effectiveDescription,
                      style: const TextStyle(
                        color: _InsuranceCEScreenState.textMuted,
                        fontSize: 14,
                        height: 1.45,
                      ),
                    ),
                    if (includedCourses.isNotEmpty) ...[
                      const SizedBox(height: 18),
                      const Text(
                        'Courses Included',
                        style: TextStyle(
                          color: _InsuranceCEScreenState.primaryNavy,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...includedCourses.map((item) {
                        final itemName = (item['shortName'] ?? item['name'] ?? 'Course').toString();
                        final itemDescription = (item['description'] ?? '').toString();
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('• ', style: TextStyle(fontSize: 16)),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      itemName,
                                      style: const TextStyle(
                                        color: _InsuranceCEScreenState.primaryNavy,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    if (itemDescription.trim().isNotEmpty)
                                      Text(
                                        itemDescription,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: _InsuranceCEScreenState.textMuted,
                                          fontSize: 12,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                    if (benefits.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      const Text(
                        'Package Benefits',
                        style: TextStyle(
                          color: _InsuranceCEScreenState.primaryNavy,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...benefits.map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('✓ ', style: TextStyle(color: Color(0xFF0A7A5B), fontWeight: FontWeight.w700)),
                              Expanded(
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    color: _InsuranceCEScreenState.textMuted,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    if (steps.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      const Text(
                        'How to Complete',
                        style: TextStyle(
                          color: _InsuranceCEScreenState.primaryNavy,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...steps.asMap().entries.map(
                        (entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 10,
                                backgroundColor: const Color(0xFF0A7A5B),
                                child: Text(
                                  '${entry.key + 1}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  entry.value,
                                  style: const TextStyle(
                                    color: _InsuranceCEScreenState.textMuted,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    if (relatedCourses.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      const Text(
                        'Related Products',
                        style: TextStyle(
                          color: _InsuranceCEScreenState.primaryNavy,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...relatedCourses.take(2).map((item) {
                        final relatedName =
                            (item['shortName'] ?? item['name'] ?? 'Course').toString();
                        final relatedPrice = item['price'];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFD3DCE8)),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  relatedName,
                                  style: const TextStyle(
                                    color: _InsuranceCEScreenState.primaryNavy,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              if (relatedPrice != null)
                                Text(
                                  '\$${relatedPrice.toString()}',
                                  style: const TextStyle(
                                    color: Color(0xFF16A34A),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFD3DCE8)),
      ),
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Color(0xFF16A34A), width: 2),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F0FF),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: const Color(0xFF9FC0FF)),
              ),
              child: const Text(
                'INSURANCE CE',
                style: TextStyle(
                  color: Color(0xFF2855C5),
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFD3DCE8)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    headlineLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    shortName.trim().isNotEmpty ? shortName : name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF0F172A),
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Text(
                effectiveDescription,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _InsuranceCEScreenState.textMuted,
                  fontSize: 12,
                  height: 1.35,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                FilledButton(
                  onPressed: showCourseDetails,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF1F49B6),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 9,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'VIEW DETAILS',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Spacer(),
                if (price != null)
                  Text(
                    '\$${price.toString()}',
                    style: const TextStyle(
                      color: Color(0xFF16A34A),
                      fontWeight: FontWeight.w700,
                      fontSize: 22,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InsuranceStateDetailChip extends StatelessWidget {
  final String label;

  const _InsuranceStateDetailChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: _InsuranceCEScreenState.accentBlue.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: _InsuranceCEScreenState.primaryNavy,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _InsuranceStateEmptyCourses extends StatelessWidget {
  const _InsuranceStateEmptyCourses();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE4E9F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'No active courses are available for this state right now.',
            style: TextStyle(
              color: _InsuranceCEScreenState.textMuted,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _InsuranceStateErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _InsuranceStateErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.redAccent, size: 34),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: _InsuranceCEScreenState.textMuted),
            ),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
