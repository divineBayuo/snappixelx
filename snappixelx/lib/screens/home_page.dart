import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snappixelx/core/constants.dart';
import 'package:snappixelx/widgets/footer.dart';
import 'package:snappixelx/widgets/hover_scale.dart';
import 'package:snappixelx/widgets/navbar.dart';

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

  @override
  Widget build(BuildContext context) {
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
                SizedBox(height: 80), // for navbar
                // hero section
                Container(
                  height: 600,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/hero.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: TweenAnimationBuilder<double>(
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
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Capturing Timeless Moments...',
                                  style: GoogleFonts.playfair(
                                    textStyle: TextStyle(
                                      fontSize: 48,
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
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 28,
                                        vertical: 16,
                                      ),
                                      elevation: 10,
                                    ),
                                    onPressed: () => Navigator.pushNamed(
                                      context,
                                      "/booking",
                                    ),
                                    child: Text(
                                      'Book Session',
                                      style: GoogleFonts.playfair(
                                        color: Colors.black,
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

                // services section
                const SizedBox(height: 75),
                Text(
                  'Services',
                  style: GoogleFonts.playfair(
                    textStyle: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children: [
                    serviceCard("Wedding", 'assets/wedding.jpg'),
                    serviceCard("Portrait", 'assets/portrait.jpg'),
                    serviceCard("Commercial", 'assets/graduation.jpg'),
                    serviceCard("Events", 'assets/event.jpg'),
                  ],
                ),

                // about section
                const SizedBox(height: 75),
                Text(
                  'About Us',
                  style: GoogleFonts.playfair(
                    textStyle: const TextStyle(fontSize: 30),
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
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    width: 700,
                    height: 400,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadiusGeometry.circular(12),
                          child: Image.asset(
                            'assets/photographer.jpg',
                            fit: BoxFit.cover,
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
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // socials section
                const SizedBox(height: 75),
                Container(
                  decoration: BoxDecoration(color: Colors.white),
                  child: Column(
                    children: [
                      Text(
                        'Socials',
                        style: GoogleFonts.playfair(
                          textStyle: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(width: 80),
                          Row(
                            children: [
                              Icon(
                                FontAwesomeIcons.instagram,
                                color: Colors.purple,
                              ),
                              TextButton(
                                onPressed: () {},
                                child: Text(
                                  'Instagram',
                                  style: GoogleFonts.playfair(
                                    textStyle: TextStyle(
                                      color: Colors.purple,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 5),
                          Row(
                            children: [
                              Icon(
                                FontAwesomeIcons.snapchat,
                                color: Colors.amber.shade500,
                              ),
                              TextButton(
                                onPressed: () {},
                                child: Text(
                                  'Snapchat',
                                  style: GoogleFonts.playfair(
                                    textStyle: TextStyle(
                                      color: Colors.amber.shade500,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 5),
                          Row(
                            children: [
                              Icon(
                                FontAwesomeIcons.whatsapp,
                                color: Colors.green,
                              ),
                              TextButton(
                                onPressed: () {},
                                child: Text(
                                  'WhatsApp/Phone',
                                  style: GoogleFonts.playfair(
                                    textStyle: TextStyle(
                                      fontSize: 14,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 5),
                          Row(
                            children: [
                              Icon(Icons.mail_outlined, color: Colors.black),
                              TextButton(
                                onPressed: () {},
                                child: Text(
                                  'Email',
                                  style: GoogleFonts.playfair(
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 80),
                        ],
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),

                const SizedBox(height: 120),
                const Footer(),
                const SizedBox(height: 60),
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

  Widget serviceCard(String title, String image) {
    return HoverScale(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 250,
        height: 200,
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
                    fontSize: 22,
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
