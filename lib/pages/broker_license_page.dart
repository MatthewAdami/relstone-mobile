import 'package:flutter/material.dart';

import 'course_category_page.dart';

class BrokerLicensePage extends StatelessWidget {
  const BrokerLicensePage({super.key});

  static const List<CategoryCourse> _brokerCourses = [
    CategoryCourse(
      id: 'broker-package-30355',
      badge: 'Broker License',
      title: 'California Real Estate Broker Course Package',
      description:
          '360-hour California real estate package. Includes 8 courses: Principles, Practice, Business Law, Legal Aspects, Property Management, Appraisal, Economics, and Finance.',
      price: 0,
      rating: null,
      creditHours: 360,
    ),
    CategoryCourse(
      id: 'broker-principles-30349',
      badge: 'Broker License',
      title: 'California Real Estate Principles',
      description:
          'DRE-approved 45-hour course covering ownership, title transfer, encumbrances, contracts, agency, financing, appraisal, fair housing, and escrow.',
      price: 98,
      rating: null,
      creditHours: 45,
    ),
    CategoryCourse(
      id: 'broker-practice-30350',
      badge: 'Broker License',
      title: 'California Real Estate Practice',
      description:
          'DRE-approved 45-hour course focused on career development, ethics, trust funds, disclosures, advertising, and client representation.',
      price: 98,
      rating: null,
      creditHours: 45,
    ),
    CategoryCourse(
      id: 'broker-business-law-30343',
      badge: 'Broker License',
      title: 'California Real Estate Business Law',
      description:
          'DRE-approved 45-hour course covering legal systems, contracts, agency law, business organizations, employment law, and tort law.',
      price: 98,
      rating: 5,
      creditHours: 45,
    ),
    CategoryCourse(
      id: 'broker-legal-aspects-30351',
      badge: 'Broker License',
      title: 'Legal Aspects of California Real Estate',
      description:
          'DRE-approved 45-hour course covering sources of law, property rights, agency law, contract law, listing agreements, and disclosure requirements.',
      price: 98,
      rating: null,
      creditHours: 45,
    ),
    CategoryCourse(
      id: 'broker-property-management-30347',
      badge: 'Broker License',
      title: 'Property Management Real Estate California',
      description:
          'DRE-approved 45-hour course covering management agreements, tenant selection, leases, rent collection, maintenance, and tenant relations.',
      price: 98,
      rating: null,
      creditHours: 45,
    ),
    CategoryCourse(
      id: 'broker-appraisal-30344',
      badge: 'Broker License',
      title: 'Real Estate Appraisal Course',
      description:
          'DRE-approved 45-hour course on appraisal principles, site analysis, construction methods, cost approach, income approach, and market analysis.',
      price: 98,
      rating: null,
      creditHours: 45,
    ),
    CategoryCourse(
      id: 'broker-economics-30346',
      badge: 'Broker License',
      title: 'Real Estate Economics Course',
      description:
          'DRE-approved 45-hour course covering market cycles, urban land economics, investment analysis, and taxation effects in real estate.',
      price: 98,
      rating: 5,
      creditHours: 45,
    ),
    CategoryCourse(
      id: 'broker-finance-30345',
      badge: 'Broker License',
      title: 'Real Estate Finance Course',
      description:
          'DRE-approved 45-hour course covering loan types, trust deeds, borrower qualification, underwriting, and financing fundamentals.',
      price: 98,
      rating: null,
      creditHours: 45,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return const CourseCategoryPage(
      pageTitle: 'Broker License',
      heroCode: 'BL',
      heroTitle: 'Broker License Pre-Licensing',
      heroDescription:
          '360-hour advanced package: Office Management, Legal Aspects, Appraisal, Escrow, Property Management & more.',
      topChips: [
        'CA Insurance CE (16)',
        'CA Real Estate CE (4)',
        'Sales License (12)',
      ],
      breadcrumbText: 'Home / California Courses / Broker License',
      itemType: 'broker_license',
      courses: _brokerCourses,
    );
  }
}
