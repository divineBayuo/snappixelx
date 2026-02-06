import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snappixelx/core/responsive_helper.dart';
import 'package:snappixelx/widgets/hover_scale.dart';
import 'package:snappixelx/widgets/navbar.dart';

class Refpage extends StatefulWidget {
  const Refpage({super.key});

  @override
  State<Refpage> createState() => _RefpageState();
}

class _RefpageState extends State<Refpage> {
  int selectedIndex = 2;

  final List<String> images = const [
    "assets/birthday.jpg",
    "assets/graduation.jpg",
    "assets/portrait.jpg",
    "assets/wedding.jpg",
    "assets/event.jpg",
  ];

  String? selectedImage;

  void _showImageDialog(String imagePath) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(imagePath, fit: BoxFit.contain),
              ),
            ),
            Positioned(
              top: 20,
              right: 20,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close, color: Colors.white, size: 30),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black.withOpacity(0.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);

    // Determine grid columns
    int crossAxisCount;
    if (isMobile) {
      crossAxisCount = 1;
    } else if (isTablet) {
      crossAxisCount = 2;
    } else {
      crossAxisCount = 3;
    }

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
          Column(
            children: [
              SizedBox(height: isMobile ? 60 : 80),
              SizedBox(height: isMobile ? 20 : 30), // for navbar

              Text(
                "Portfolio",
                style: GoogleFonts.playfair(
                  textStyle: TextStyle(fontSize: isMobile ? 28 : 36),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 10),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: isMobile ? 30 : 100),
                child: Text(
                  "Explore our collection of memorable moments captured through our lens",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.playfair(
                    fontSize: isMobile ? 12 : 14,
                    color: Colors.white70,
                  ),
                ),
              ),

              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.all(isMobile ? 20 : 40),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: isMobile ? 15 : 20,
                    mainAxisSpacing: isMobile ? 15 : 20,
                    childAspectRatio: 1,
                  ),
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return HoverScale(
                      child: GestureDetector(
                        onTap: () => _showImageDialog(images[index]),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.asset(images[index], fit: BoxFit.cover),

                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withOpacity(0.3),
                                      ],
                                    ),
                                  ),
                                ),

                                // icon
                                Positioned(
                                  bottom: 10,
                                  right: 10,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.9),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.zoom_in,
                                      color: Colors.black,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          // Sticky Navbar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: NavBar(
              selectedIndex: selectedIndex,
              onTabSelected: (index) {
                setState(() => selectedIndex = index);
              },
            ),
          ),
        ],
      ),
    );
  }
}
