import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class RelstoneFooter extends StatelessWidget {
  const RelstoneFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0B1A2A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Wrap(
            spacing: 10,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Icon(Icons.home_work_rounded, color: Colors.white),
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
            'Providing quality education for California Real Estate and Insurance professionals.',
            style: TextStyle(color: Colors.white70, height: 1.45, fontSize: 13),
          ),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 230;
              final iconSize = compact ? 34.0 : 40.0;
              final iconGlyphSize = compact ? 14.0 : 17.0;
              final spacing = compact ? 8.0 : 10.0;

              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: [
                  _FooterSocialIcon(
                    icon: FontAwesomeIcons.facebook,
                    color: const Color(0xFF1877F2),
                    label: 'Facebook',
                    url: 'https://www.facebook.com/RelstoneSD',
                    size: iconSize,
                    iconSize: iconGlyphSize,
                  ),
                  _FooterSocialIcon(
                    icon: FontAwesomeIcons.linkedin,
                    color: const Color(0xFF0A66C2),
                    label: 'LinkedIn',
                    url: 'https://www.linkedin.com/company/relstone/posts/?feedView=all',
                    size: iconSize,
                    iconSize: iconGlyphSize,
                  ),
                  _FooterSocialIcon(
                    icon: FontAwesomeIcons.xTwitter,
                    color: const Color(0xFFE7E7E7),
                    label: 'X / Twitter',
                    url: 'https://twitter.com/relstone',
                    size: iconSize,
                    iconSize: iconGlyphSize,
                  ),
                  _FooterSocialIcon(
                    icon: FontAwesomeIcons.tiktok,
                    color: const Color(0xFFEE1D52),
                    label: 'TikTok',
                    url: 'https://tiktok.com/@relstone',
                    size: iconSize,
                    iconSize: iconGlyphSize,
                  ),
                  _FooterSocialIcon(
                    icon: FontAwesomeIcons.instagram,
                    color: const Color(0xFFE1306C),
                    label: 'Instagram',
                    url: 'https://instagram.com/relstone',
                    size: iconSize,
                    iconSize: iconGlyphSize,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 14),
          const Divider(color: Colors.white12),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _FooterChip('Contact Us', () => Navigator.pushNamed(context, '/contact')),
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
            style: TextStyle(color: Color(0xFF6B7E92), fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _FooterSocialIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String url;
  final double size;
  final double iconSize;

  const _FooterSocialIcon({
    required this.icon,
    required this.color,
    required this.label,
    required this.url,
    this.size = 40,
    this.iconSize = 17,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      child: InkWell(
        onTap: () async {
          final uri = Uri.parse(url);
          try {
            await launchUrl(uri, mode: LaunchMode.externalNonBrowserApplication);
          } catch (_) {
            await launchUrl(uri, mode: LaunchMode.platformDefault);
          }
        },
        borderRadius: BorderRadius.circular(999),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            border: Border.all(color: color.withValues(alpha: 0.5)),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Center(child: FaIcon(icon, color: color, size: iconSize)),
        ),
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
