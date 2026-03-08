import 'package:flutter/material.dart';

import '../services/cart_service.dart';
import '../widgets/sidebar.dart';
import '../widgets/main_layout.dart';

class CourseCategoryPage extends StatefulWidget {
  final String pageTitle;
  final String heroCode;
  final String heroTitle;
  final String heroDescription;
  final List<String> topChips;
  final String breadcrumbText;
  final String itemType;
  final List<CategoryCourse> courses;

  const CourseCategoryPage({
    super.key,
    required this.pageTitle,
    required this.heroCode,
    required this.heroTitle,
    required this.heroDescription,
    required this.topChips,
    required this.breadcrumbText,
    required this.itemType,
    required this.courses,
  });

  @override
  State<CourseCategoryPage> createState() => _CourseCategoryPageState();
}

class _CourseCategoryPageState extends State<CourseCategoryPage> {
  static const Color _navy = Color(0xFF0F172A);
  static const Color _blue = Color(0xFF1E40AF);
  static const Color _blueLight = Color(0xFF3B82F6);
  static const Color _textMuted = Color(0xFF64748B);
  static const Color _border = Color(0xFFE2E8F0);

  static const List<String> _sortOptions = [
    'Default sorting',
    'Sort by price: low to high',
    'Sort by price: high to low',
    'Sort by title',
  ];

  String _selectedSort = _sortOptions.first;

  List<CategoryCourse> get _sortedCourses {
    final copy = List<CategoryCourse>.from(widget.courses);

    switch (_selectedSort) {
      case 'Sort by price: low to high':
        copy.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Sort by price: high to low':
        copy.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Sort by title':
        copy.sort((a, b) => a.title.compareTo(b.title));
        break;
      default:
        break;
    }

    return copy;
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      drawer: const Sidebar(),
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: _buildHeroHeader(),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                    child: _buildControls(),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  sliver: SliverLayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.crossAxisExtent;
                      final crossAxisCount = width >= 1100
                          ? 3
                          : width >= 700
                              ? 2
                              : 1;

                      return SliverGrid(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final course = _sortedCourses[index];
                            return _CourseCard(
                              course: course,
                              onAddToCart: () => _addToCart(course),
                            );
                          },
                          childCount: _sortedCourses.length,
                        ),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          childAspectRatio: crossAxisCount == 1 ? 1.28 : 1.02,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          colors: [_navy, _blue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x260F172A),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFDC2626), Color(0xFFEF4444)],
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  widget.heroCode,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.heroTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.heroDescription,
                      style: const TextStyle(
                        color: Color(0xFFDBEAFE),
                        fontSize: 13,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: _blueLight,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              '${widget.courses.length} Courses',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.topChips
                .map((chip) => _TopChip(label: chip))
                .toList(growable: false),
          ),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
      ),
      child: Wrap(
        runSpacing: 10,
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            '${widget.breadcrumbText}\nShowing all ${widget.courses.length} results',
            style: const TextStyle(
              color: _textMuted,
              fontSize: 12,
              height: 1.5,
            ),
          ),
          DropdownButtonHideUnderline(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: _border),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButton<String>(
                value: _selectedSort,
                style: const TextStyle(color: _navy, fontSize: 13),
                icon: const Icon(Icons.keyboard_arrow_down_rounded),
                items: _sortOptions
                    .map(
                      (item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => _selectedSort = value);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addToCart(CategoryCourse course) async {
    await CartService.instance.addToCart(
      CartItem(
        id: course.id,
        type: widget.itemType,
        name: course.title,
        stateSlug: 'california',
        stateName: 'California',
        price: course.price,
        creditHours: course.creditHours,
        withTextbook: false,
        textbookPrice: 0,
      ),
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${course.title} added to cart.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _TopChip extends StatelessWidget {
  final String label;

  const _TopChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.13),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white24),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _CourseCard extends StatelessWidget {
  final CategoryCourse course;
  final VoidCallback onAddToCart;

  const _CourseCard({
    required this.course,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFEDE9FE),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: const Color(0xFFD8B4FE)),
            ),
            child: Text(
              course.badge,
              style: const TextStyle(
                color: Color(0xFF6B21A8),
                fontWeight: FontWeight.w700,
                fontSize: 10,
                letterSpacing: 0.3,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            course.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF0F172A),
              fontSize: 15,
              fontWeight: FontWeight.w700,
              height: 1.35,
            ),
          ),
          if (course.rating != null) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                ...List.generate(
                  5,
                  (index) => const Icon(
                    Icons.star,
                    size: 15,
                    color: Color(0xFFF59E0B),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '${course.rating!.toStringAsFixed(0)}.0',
                  style: const TextStyle(
                    color: Color(0xFF475569),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              course.description,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF64748B),
                fontSize: 12,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            course.price == 0
                ? 'From: \$0.00 (placeholder)'
                : '\$${course.price.toStringAsFixed(2)}',
            style: TextStyle(
              color: course.price == 0
                  ? const Color(0xFF334155)
                  : const Color(0xFF16A34A),
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E40AF),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: onAddToCart,
              child: const Text(
                'Add to cart',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryCourse {
  final String id;
  final String badge;
  final String title;
  final String description;
  final double price;
  final double? rating;
  final int creditHours;

  const CategoryCourse({
    required this.id,
    required this.badge,
    required this.title,
    required this.description,
    required this.price,
    required this.rating,
    required this.creditHours,
  });
}