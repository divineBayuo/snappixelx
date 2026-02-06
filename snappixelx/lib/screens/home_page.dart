import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snappixelx/core/constants.dart';
import 'package:snappixelx/core/responsive_helper.dart';
import 'package:snappixelx/widgets/footer.dart';
import 'package:snappixelx/widgets/hover_scale.dart';
import 'package:snappixelx/widgets/navbar.dart';
import 'package:url_launcher/url_launcher.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with TickerProviderStateMixin {
  int selectedIndex = 0;
  late AnimationController _heroController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Social media links
  final String instagramUrl = 'https://instagram.com/snappixelx';
  final String snapchatUrl = 'https://snapchat.com/add/snappixelx';
  final String whatsappNumber = '+233123456789';
  final String emailAddress = 'info@snappixelx.com';

  @override
  void initState() {
    super.initState();

    _heroController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _heroController,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(_fadeAnimation);

    _heroController.forward();
  }

  @override
  void dispose() {
    _heroController.dispose();
    super.dispose();
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Could not open link')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF06050c),
                  Color(0xFF24108d),
                  Color(0xFF924e87),
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: isMobile ? 60 : 80), // for navbar
                _buildHeroSection(isMobile),

                // services section
                SizedBox(height: isMobile ? 40 : 75),
                _buildServicesSection(isMobile, isTablet),

                // about section
                SizedBox(height: isMobile ? 40 : 75),
                _buildAboutSection(isMobile),

                // socials section
                SizedBox(height: isMobile ? 40 : 75),
                _buildSocialsSection(isMobile),

                SizedBox(height: isMobile ? 60 : 120),
                const Footer(),
                SizedBox(height: isMobile ? 30 : 60),
              ],
            ),
          ),

          // Sticky Navbar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: NavBar(
                selectedIndex: selectedIndex,
                onTabSelected: (index) {
                  setState(() => selectedIndex = index);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection(bool isMobile) {
    return Container(
      height: isMobile ? 400 : 600,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/hero.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: TweenAnimationBuilder(
        tween: Tween(begin: 1.0, end: 1.05),
        duration: const Duration(seconds: 2),
        builder: (context, scale, child) {
          return Transform.scale(scale: scale, child: child);
        },
        child: Container(
          color: Colors.black.withOpacity(0.5),
          child: Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Capturing Timeless Moments...',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.playfair(
                          textStyle: TextStyle(
                            fontSize: isMobile ? 28 : 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      HoverScale(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: isMobile ? 20 : 28,
                              vertical: isMobile ? 12 : 16,
                            ),
                            elevation: 10,
                          ),
                          onPressed: () =>
                              Navigator.pushNamed(context, '/booking'),
                          child: Text(
                            'Book Session',
                            style: GoogleFonts.playfair(
                              color: Colors.black,
                              fontSize: isMobile ? 14 : 16,
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
      ),
    );
  }

  Widget _buildServicesSection(bool isMobile, bool isTablet) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 40),
      child: Column(
        children: [
          Text(
            'Services',
            style: GoogleFonts.playfair(
              textStyle: TextStyle(
                fontSize: isMobile ? 24 : 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 30),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: [
              serviceCard("Wedding", 'assets/wedding.jpg', isMobile),
              serviceCard("Portrait", 'assets/portrait.jpg', isMobile),
              serviceCard("Commercial", 'assets/graduation.jpg', isMobile),
              serviceCard("Events", 'assets/event.jpg', isMobile),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(bool isMobile) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 40),
      child: Column(
        children: [
          Text(
            'About Us',
            style: GoogleFonts.playfair(
              textStyle: TextStyle(fontSize: isMobile ? 24 : 30),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(
                  spreadRadius: 1,
                  blurRadius: 6,
                  offset: Offset(0.2, 0.4),
                ),
              ],
            ),
            padding: EdgeInsets.all(isMobile ? 15 : 20),
            constraints: BoxConstraints(
              maxWidth: isMobile ? double.infinity : 700,
            ),
            child: isMobile
                ? Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'assets/photographer.jpg',
                          fit: BoxFit.cover,
                          height: 200,
                          width: double.infinity,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        aboutText,
                        style: GoogleFonts.playfair(
                          textStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        softWrap: true,
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  )
                : SizedBox(
                    height: 400,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            'assets/photographer.jpg',
                            fit: BoxFit.cover,
                            width: 300,
                          ),
                        ),
                        const SizedBox(width: 30),
                        Expanded(
                          child: Text(
                            aboutText,
                            style: GoogleFonts.playfair(
                              textStyle: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            softWrap: true,
                            overflow: TextOverflow.fade,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialsSection(bool isMobile) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.white),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 40,
        vertical: isMobile ? 20 : 30,
      ),
      child: Column(
        children: [
          Text(
            'Socials',
            style: GoogleFonts.playfair(
              textStyle: TextStyle(
                fontSize: isMobile ? 24 : 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(height: isMobile ? 15 : 20),
          isMobile
              ? Column(
                  children: [
                    _socialButton(
                      icon: FontAwesomeIcons.instagram,
                      label: 'Instagram',
                      color: Colors.purple,
                      onTap: () => _launchUrl(instagramUrl),
                    ),
                    const SizedBox(height: 10),
                    _socialButton(
                      icon: FontAwesomeIcons.snapchat,
                      label: 'Snapchat',
                      color: Colors.amber.shade500,
                      onTap: () => _launchUrl(snapchatUrl),
                    ),
                    const SizedBox(height: 10),
                    _socialButton(
                      icon: FontAwesomeIcons.whatsapp,
                      label: 'WhatsApp',
                      color: Colors.green,
                      onTap: () => _launchUrl('https://wa.me/$whatsappNumber'),
                    ),
                    const SizedBox(height: 10),
                    _socialButton(
                      icon: Icons.mail_outlined,
                      label: 'Email',
                      color: Colors.black,
                      onTap: () => _launchUrl('mailto:$emailAddress'),
                    ),
                  ],
                )
              : Wrap(
                  spacing: 20,
                  runSpacing: 10,
                  alignment: WrapAlignment.center,
                  children: [
                    _socialButton(
                      icon: FontAwesomeIcons.instagram,
                      label: 'Instagram',
                      color: Colors.purple,
                      onTap: () => _launchUrl(instagramUrl),
                    ),
                    _socialButton(
                      icon: FontAwesomeIcons.snapchat,
                      label: 'Snapchat',
                      color: Colors.amber.shade500,
                      onTap: () => _launchUrl(snapchatUrl),
                    ),
                    _socialButton(
                      icon: FontAwesomeIcons.whatsapp,
                      label: 'WhatsApp',
                      color: Colors.green,
                      onTap: () => _launchUrl('https://wa.me/$whatsappNumber'),
                    ),
                    _socialButton(
                      icon: Icons.mail_outlined,
                      label: 'Email',
                      color: Colors.black,
                      onTap: () => _launchUrl('mailto:$emailAddress'),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _socialButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return HoverScale(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 8),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.playfair(
                  textStyle: TextStyle(color: color, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget serviceCard(String title, String image, bool isMobile) {
    return HoverScale(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: isMobile ? 150 : 250,
        height: isMobile ? 120 :200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Stack(
            children: [
              // zoom efx
              Positioned.fill(child: Image.asset(image, fit: BoxFit.cover)),

              // dark overlay
              Positioned.fill(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  color: Colors.black.withOpacity(0.45),
                ),
              ),

              /// Title
              Center(
                child: Text(
                  title,
                  style: GoogleFonts.playfair(
                    fontSize: isMobile ? 16 : 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
