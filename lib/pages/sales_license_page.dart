import 'package:flutter/material.dart';

import 'course_category_page.dart';

class SalesLicensePage extends StatelessWidget {
  const SalesLicensePage({super.key});

  static const List<CategoryCourse> _salesCourses = [
    CategoryCourse(
      id: 'sales-package-30798',
      badge: 'Sales License',
      title: 'California Real Estate Salesperson Package',
      description:
          'Complete package for California Salesperson licensing with required Principles, Practice, and one elective course. Placeholder data for now.',
      price: 0,
      rating: null,
      creditHours: 135,
    ),
    CategoryCourse(
      id: 'sales-principles-30349',
      badge: 'Sales License',
      title: 'California Real Estate Principles',
      description:
          'Required 45-hour DRE course introducing ownership, title, contracts, agency, financing, fair housing, and escrow basics.',
      price: 98,
      rating: 5,
      creditHours: 45,
    ),
    CategoryCourse(
      id: 'sales-practice-30350',
      badge: 'Sales License',
      title: 'California Real Estate Practice',
      description:
          'Required 45-hour DRE course focused on transactions, disclosures, ethics, trust funds, and practical sales workflows.',
      price: 98,
      rating: null,
      creditHours: 45,
    ),
    CategoryCourse(
      id: 'sales-business-law-30343',
      badge: 'Sales License',
      title: 'California Real Estate Business Law (Elective)',
      description:
          'Elective course covering legal system basics, contracts, agency law, business entities, and compliance for agents.',
      price: 98,
      rating: null,
      creditHours: 45,
    ),
    CategoryCourse(
      id: 'sales-finance-30345',
      badge: 'Sales License',
      title: 'Real Estate Finance (Elective)',
      description:
          'Elective course on loan products, underwriting, borrower qualification, trust deeds, and financing structures.',
      price: 98,
      rating: null,
      creditHours: 45,
    ),
    CategoryCourse(
      id: 'sales-economics-30346',
      badge: 'Sales License',
      title: 'Real Estate Economics (Elective)',
      description:
          'Elective course on market cycles, regional economics, taxation impacts, and investment-related decision making.',
      price: 98,
      rating: 5,
      creditHours: 45,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return const CourseCategoryPage(
      pageTitle: 'Sales License',
      heroCode: 'SL',
      heroTitle: 'Sales License Pre-Licensing',
      heroDescription:
          'Start your California real estate career with required pre-licensing courses and elective options.',
      topChips: [
        'Broker License (9)',
        'CA Real Estate CE (4)',
        'Exam Prep (placeholder)',
      ],
      breadcrumbText: 'Home / California Courses / Sales License',
      itemType: 'sales_license',
      courses: _salesCourses,
    );
  }
}
