import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snappixelx/core/responsive_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  static const _gradient = LinearGradient(
    colors: [Color(0xFF06050c), Color(0xFF24108d), Color(0xFF924e87)],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(decoration: BoxDecoration(gradient: _gradient)),
          SingleChildScrollView(
            child: Column(
              children: [
                _buildHero(isMobile),
                _buildAbout(isMobile),
                _buildVentures(context, isMobile),
                _buildSkills(isMobile),
                _buildContact(isMobile),
                _buildFooter(isMobile),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- HERO -----------------
  Widget _buildHero(bool isMobile) {
    return SizedBox(
      height: isMobile ? 500 : 650,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Subtle radial glow
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                colors: [Color(0x40924e87), Colors.transparent],
                radius: 0.9,
                center: Alignment(0, -0.2),
              ),
            ),
          ),

          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 28 : 80),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo / monogram
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white38, width: 2),
                      color: Colors.white.withOpacity(0.08),
                    ),
                    child: const Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.white70,
                      size: 48,
                    ),
                  ),

                  const SizedBox(height: 24),

                  Text(
                    'Ebenezer Oppong',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.playfair(
                      fontSize: isMobile ? 34 : 56,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    'Photographer · Creative Entrepreneur · Visual Storyteller',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.playfair(
                      fontSize: isMobile ? 13 : 17,
                      color: Colors.white60,
                      fontStyle: FontStyle.italic,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    'Accra, Ghana',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.playfair(
                      fontSize: isMobile ? 12 : 14,
                      color: Colors.white38,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Scroll indicator
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  'scroll to explore',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.playfair(
                    fontSize: 11,
                    color: Colors.white30,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 6),

                const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white30,
                  size: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAbout(bool isMobile) {
    return Container(
      width: double.infinity,
      color: Colors.white.withOpacity(0.04),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 28 : 120,
        vertical: isMobile ? 48 : 72,
      ),
      child: Column(
        children: [
          _SectionLabel(text: 'About', isMobile: isMobile),
          const SizedBox(height: 24),
          Text(
            'Ebenezer Oppong is a Ghanaian photographer with a passion for '
            'capturing authentic moments and transforming them into timeless '
            'visual stories. Operating under the SnappixelX brand, he brings '
            'a refined aesthetic sensibility to every shoot — whether it\'s an '
            'intimate portrait session, a high-stakes corporate event, or the '
            'sweeping lines of an architectural landmark.\n\n'
            'With years of experience serving clients across Ghana, Ebenezer '
            'combines technical precision with a calm, collaborative style '
            'that puts every subject at ease. His images don\'t just document '
            '— they resonate.',
            textAlign: TextAlign.center,
            style: GoogleFonts.playfair(
              fontSize: isMobile ? 14 : 16,
              color: Colors.white70,
              height: 1.85,
            ),
          ),
        ],
      ),
    );
  }

  // --- VENTURES -------------------
  Widget _buildVentures(BuildContext context, bool isMobile) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 28 : 80,
        vertical: isMobile ? 52 : 80,
      ),
      child: Column(
        children: [
          _SectionLabel(text: 'My Ventures', isMobile: isMobile),
          const SizedBox(height: 12),
          Text(
            'A growing portfolio of businesses and creative projects.',
            textAlign: TextAlign.center,
            style: GoogleFonts.playfair(
              fontSize: isMobile ? 13 : 15,
              color: Colors.white38,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 40),

          // Snappixelx card - the main venture
          _VentureCard(
            icon: Icons.camera_alt_outlined,
            name: 'Snappixelx',
            tagline: 'Photography Studio',
            description:
                'A professional photography studio offering portraits, '
                'corporate event coverage, professional headshots, and real '
                'estate photography. SnappixelX delivers timeless imagery '
                'for clients across Ghana.',
            accentColor: const Color(0xFF924e87),
            ctaLabel: 'Visit Studio →',
            onTap: () => Navigator.of(context).pushNamed('/home'),
            isMobile: isMobile,
          ),

          const SizedBox(height: 20),

          // Placeholder venture card
          _VentureCard(
            icon: Icons.storefront_outlined,
            name: 'Coming Soon',
            tagline: 'New Venture',
            description:
                'Ebenezer is always building. More exciting projects are '
                'on the way. Watch this space.',
            accentColor: const Color(0xFF24108d),
            ctaLabel: 'Stay Tuned',
            onTap: null,
            isMobile: isMobile,
          ),
        ],
      ),
    );
  }

  // --- SKILLS -------------------
  Widget _buildSkills(bool isMobile) {
    const skills = [
      _Skill(icon: Icons.camera_alt_outlined, label: 'Photography'),
      _Skill(icon: Icons.edit_outlined, label: 'Photo Editing'),
      _Skill(icon: Icons.lightbulb_outlined, label: 'Creative Direction'),
      _Skill(icon: Icons.business_center_outlined, label: 'Brand Strategy'),
      _Skill(icon: Icons.groups_outlined, label: 'Client Relations'),
      _Skill(icon: Icons.apartment_outlined, label: 'Architectural Eye'),
    ];

    return Container(
      width: double.infinity,
      color: Colors.white.withOpacity(0.04),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 28 : 80,
        vertical: isMobile ? 52 : 80,
      ),
      child: Column(
        children: [
          _SectionLabel(text: 'Skills', isMobile: isMobile),
          const SizedBox(height: 40),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: skills.map((s) => _SkillChip(skill: s)).toList(),
          ),
        ],
      ),
    );
  }

  // --- CONTACT ---------------------
  Widget _buildContact(bool isMobile) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 28 : 140,
        vertical: isMobile ? 52 : 80,
      ),
      child: Column(
        children: [
          _SectionLabel(text: 'Get In Touch', isMobile: isMobile),
          const SizedBox(height: 12),
          Text(
            'Have a project or opportunity in mind? Let\'s talk.',
            textAlign: TextAlign.center,
            style: GoogleFonts.playfair(
              fontSize: isMobile ? 13 : 15,
              color: Colors.white38,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 36),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: [
              _ContactButton(
                icon: Icons.mail_outline,
                label: 'info@snappixelx.com',
                onTap: () => _launchUrl('mailto:info@snappixelx.com'),
              ),
              _ContactButton(
                icon: Icons.phone_outlined,
                label: '+233 55 720 2839',
                onTap: () => _launchUrl('tel:+233557202839'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- FOOTER ----------------
  Widget _buildFooter(bool isMobile) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 24 : 36,
        horizontal: 20,
      ),
      child: Text(
        '© ${DateTime.now().year} · Ebenezer Oppong · All rights reserved',
        textAlign: TextAlign.center,
        style: GoogleFonts.playfair(fontSize: 12, color: Colors.white30),
      ),
    );
  }
}

// --- HELPERS ----------------------
class _SectionLabel extends StatelessWidget {
  final String text;
  final bool isMobile;
  const _SectionLabel({required this.text, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          text,
          style: GoogleFonts.playfair(
            fontSize: isMobile ? 24 : 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: 44,
          height: 2,
          decoration: BoxDecoration(
            color: const Color(0xFF924e87),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }
}

class _Skill {
  final IconData icon;
  final String label;
  const _Skill({required this.icon, required this.label});
}

class _SkillChip extends StatelessWidget {
  final _Skill skill;
  const _SkillChip({required this.skill});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.07),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(skill.icon, color: const Color(0xFF924e87), size: 16),
          const SizedBox(width: 8),
          Text(
            skill.label,
            style: GoogleFonts.playfair(fontSize: 13, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _ContactButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ContactButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.07),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withOpacity(0.15)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white60, size: 18),
            const SizedBox(width: 10),
            Text(
              label,
              style: GoogleFonts.playfair(fontSize: 13, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}

class _VentureCard extends StatelessWidget {
  final IconData icon;
  final String name;
  final String tagline;
  final String description;
  final Color accentColor;
  final String ctaLabel;
  final VoidCallback? onTap;
  final bool isMobile;

  const _VentureCard({
    required this.icon,
    required this.name,
    required this.tagline,
    required this.description,
    required this.accentColor,
    required this.ctaLabel,
    required this.onTap,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 680),
      padding: EdgeInsets.all(isMobile ? 20 : 28),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(18),

        border: Border.all(color: accentColor.withOpacity(0.35), width: 1.5),
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(),
                const SizedBox(height: 14),
                _desc(),
                const SizedBox(height: 20),
                if (onTap != null) _cta(),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _iconBox(),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [_nameRow(), const SizedBox(height: 8), _desc()],
                  ),
                ),
                const SizedBox(width: 24),
                if (onTap != null) _cta(),
              ],
            ),
    );
  }

  Widget _iconBox() => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: accentColor.withOpacity(0.18),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Icon(icon, color: Colors.white70, size: 28),
  );

  Widget _header() =>
      Row(children: [_iconBox(), const SizedBox(width: 14), _nameRow()]);

  Widget _nameRow() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        name,
        style: GoogleFonts.playfair(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      Text(
        tagline,
        style: GoogleFonts.playfair(
          fontSize: 12,
          color: accentColor.withOpacity(0.85),
          fontStyle: FontStyle.italic,
        ),
      ),
    ],
  );

  Widget _desc() => Text(
    description,
    style: GoogleFonts.playfair(
      fontSize: 13,
      color: Colors.white60,
      height: 1.75,
    ),
  );

  Widget _cta() => ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: accentColor,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 4,
    ),
    onPressed: onTap,
    child: Text(
      ctaLabel,
      style: GoogleFonts.playfair(fontWeight: FontWeight.bold, fontSize: 13),
    ),
  );
}
