import 'package:flutter/material.dart';

class InsuranceCEScreen extends StatefulWidget {
  const InsuranceCEScreen({super.key});

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

  static const List<InsuranceStateItem> _states = [
    InsuranceStateItem(code: 'AL', name: 'Alabama Insurance Continuing Education Courses', courses: 8),
    InsuranceStateItem(code: 'AR', name: 'Arkansas Insurance Continuing Education Courses', courses: 12),
    InsuranceStateItem(code: 'AZ', name: 'Arizona Insurance Continuing Education Courses', courses: 7),
    InsuranceStateItem(code: 'CA', name: 'CA Insurance CE', courses: 16),
    InsuranceStateItem(code: 'CO', name: 'Colorado Insurance Continuing Education Courses', courses: 12),
    InsuranceStateItem(code: 'CT', name: 'Connecticut Insurance Continuing Education Online Courses', courses: 9),
    InsuranceStateItem(code: 'DC', name: 'District of Columbia Insurance Continuing Education Courses', courses: 5),
    InsuranceStateItem(code: 'DE', name: 'Delaware Insurance Continuing Education Courses', courses: 11),
    InsuranceStateItem(code: 'FL', name: 'Florida Insurance CE', courses: 55),
    InsuranceStateItem(code: 'GA', name: 'Georgia Insurance CE online classes', courses: 8),
    InsuranceStateItem(code: 'HI', name: 'Hawaii Insurance CE Courses', courses: 20),
    InsuranceStateItem(code: 'ID', name: 'Idaho Insurance CE Courses', courses: 6),
    InsuranceStateItem(code: 'IN', name: 'Indiana Insurance CE Courses', courses: 9),
    InsuranceStateItem(code: 'KS', name: 'Kansas Insurance CE Courses', courses: 16),
    InsuranceStateItem(code: 'KY', name: 'Kentucky Insurance CE Courses', courses: 6),
    InsuranceStateItem(code: 'LA', name: 'Louisiana Insurance CE Courses', courses: 9),
    InsuranceStateItem(code: 'MD', name: 'Maryland Insurance Continuing Education Courses', courses: 13),
    InsuranceStateItem(code: 'ME', name: 'Maine Insurance Continuing Education Courses', courses: 10),
    InsuranceStateItem(code: 'MI', name: 'Michigan Insurance Continuing Education Courses', courses: 9),
    InsuranceStateItem(code: 'MO', name: 'Missouri Insurance Continuing Education Courses', courses: 9),
    InsuranceStateItem(code: 'MS', name: 'Mississippi Insurance Continuing Education Courses', courses: 7),
    InsuranceStateItem(code: 'NC', name: 'North Carolina Insurance Continuing Education Courses', courses: 11),
    InsuranceStateItem(code: 'ND', name: 'North Dakota Insurance Continuing Education Courses', courses: 4),
    InsuranceStateItem(code: 'NH', name: 'New Hampshire Insurance Continuing Education Courses', courses: 5),
    InsuranceStateItem(code: 'NM', name: 'New Mexico Insurance Continuing Education Courses', courses: 10),
    InsuranceStateItem(code: 'NV', name: 'Nevada Insurance Continuing Education Courses', courses: 2),
    InsuranceStateItem(code: 'NY', name: 'New York Insurance CE', courses: 9),
    InsuranceStateItem(code: 'OH', name: 'Ohio Insurance Continuing Education Courses', courses: 5),
    InsuranceStateItem(code: 'OK', name: 'Oklahoma Insurance Continuing Education Courses', courses: 9),
    InsuranceStateItem(code: 'OR', name: 'Oregon Insurance Continuing Education Courses', courses: 11),
    InsuranceStateItem(code: 'PA', name: 'Pennsylvania Insurance Continuing Education Courses', courses: 12),
    InsuranceStateItem(code: 'RI', name: 'Rhode Island Insurance Continuing Education Courses', courses: 4),
    InsuranceStateItem(code: 'SD', name: 'South Dakota Insurance Continuing Education Courses', courses: 9),
    InsuranceStateItem(code: 'TN', name: 'Tennessee Insurance Continuing Education Courses', courses: 18),
    InsuranceStateItem(code: 'TX', name: 'Texas Insurance CE', courses: 6),
    InsuranceStateItem(code: 'UT', name: 'Utah Insurance Continuing Education Courses', courses: 13),
    InsuranceStateItem(code: 'VA', name: 'Virginia Insurance Continuing Education Courses', courses: 4),
    InsuranceStateItem(code: 'VT', name: 'Vermont Insurance Continuing Education Courses', courses: 3),
    InsuranceStateItem(code: 'WA', name: 'Washington Insurance Continuing Education Courses', courses: 7),
    InsuranceStateItem(code: 'WV', name: 'West Virginia Insurance Continuing Education Courses', courses: 6),
    InsuranceStateItem(code: 'WY', name: 'Wyoming Insurance Continuing Education Courses', courses: 3),
  ];

  List<InsuranceStateItem> get _filteredStates {
    return _states.where((state) {
      final matchesCode = _selectedStateCode == 'All' || state.code == _selectedStateCode;
      return matchesCode;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final stateCodes = ['All', ..._states.map((item) => item.code)];

    return Scaffold(
      backgroundColor: bg,
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
            children: [
              _TopNavBar(contentWidth: contentWidth),
              Center(
                child: SizedBox(
                  width: contentWidth,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
                    child: Column(
                      children: [
                        _HeroCard(totalStates: _states.length),
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
                        const SizedBox(height: 12),
                        GridView.builder(
                          itemCount: _filteredStates.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: isDesktop ? 1.03 : 0.96,
                          ),
                          itemBuilder: (context, index) {
                            return _StateCard(item: _filteredStates[index]);
                          },
                        ),
                        const SizedBox(height: 14),
                        const _WhyChooseSection(),
                        const SizedBox(height: 14),
                      ],
                    ),
                  ),
                ),
              ),
              const _FooterBar(),
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
        borderRadius: BorderRadius.circular(10),
        gradient: const LinearGradient(
          colors: [Color(0xFF2245A8), Color(0xFF3D7EF1)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 30, 18, 30),
        child: Column(
          children: [
            const Text(
              'Insurance Continuing Education',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'State-approved CE courses for insurance license renewal. Complete your requirements online at your own pace.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFE7EEFF),
                fontSize: 20,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: accentBlue.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '$totalStates States Available',
                style: const TextStyle(
                  color: Colors.white,
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
        color: const Color(0xFFF3F6FB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: cardBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 16, 12, 18),
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
            SizedBox(
              width: 540,
              child: DropdownButtonFormField<String>(
                initialValue: selectedStateCode,
                isExpanded: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: cardBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: _InsuranceCEScreenState.accentBlue, width: 1.2),
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

  const _StateCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _InsuranceCEScreenState.cardBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              item.code,
              style: const TextStyle(
                fontSize: 47,
                fontWeight: FontWeight.w800,
                color: _InsuranceCEScreenState.primaryNavy,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              item.name,
              textAlign: TextAlign.center,
              maxLines: 2,
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
              '${item.courses} Courses',
              style: const TextStyle(
                color: _InsuranceCEScreenState.textMuted,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ],
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
        color: const Color(0xFFF3F6FB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _InsuranceCEScreenState.cardBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
        child: Column(
          children: [
            Text(
              'Why Choose RelStone for Insurance CE?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
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
                        child: _WhyItem(
                          number: '1',
                          title: 'State Approved',
                          subtitle: 'All courses meet state requirements for insurance license renewal.',
                        ),
                      ),
                      Expanded(
                        child: _WhyItem(
                          number: '2',
                          title: 'Self-Paced',
                          subtitle: 'Study on your schedule, from any device, anywhere.',
                        ),
                      ),
                      Expanded(
                        child: _WhyItem(
                          number: '3',
                          title: 'Instant Certificates',
                          subtitle: 'Download your completion certificate immediately upon passing.',
                        ),
                      ),
                      Expanded(
                        child: _WhyItem(
                          number: '4',
                          title: 'Support',
                          subtitle: 'Phone and email support available for any questions.',
                        ),
                      ),
                    ],
                  );
                }

                return const Column(
                  children: [
                    _WhyItem(
                      number: '1',
                      title: 'State Approved',
                      subtitle: 'All courses meet state requirements for insurance license renewal.',
                    ),
                    SizedBox(height: 12),
                    _WhyItem(
                      number: '2',
                      title: 'Self-Paced',
                      subtitle: 'Study on your schedule, from any device, anywhere.',
                    ),
                    SizedBox(height: 12),
                    _WhyItem(
                      number: '3',
                      title: 'Instant Certificates',
                      subtitle: 'Download your completion certificate immediately upon passing.',
                    ),
                    SizedBox(height: 12),
                    _WhyItem(
                      number: '4',
                      title: 'Support',
                      subtitle: 'Phone and email support available for any questions.',
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
                                style: TextStyle(color: Color(0xFF8E9AAF), fontSize: 13),
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
                              child: const Icon(Icons.search, color: Colors.white, size: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    const _NavText('CALIFORNIA REAL ESTATE'),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      color: const Color(0xFF1E4A85),
                      child: const Text(
                        'INSURANCE CE',
                        style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
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
                        child: Text('0', style: TextStyle(fontSize: 11, color: Color(0xFF1E4A85))),
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