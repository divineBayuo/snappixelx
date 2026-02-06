import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snappixelx/core/responsive_helper.dart';
import 'package:snappixelx/screens/booking_page.dart';
import 'package:snappixelx/widgets/hover_scale.dart';
import 'package:snappixelx/widgets/navbar.dart';

class Pricingpage extends StatefulWidget {
  const Pricingpage({super.key});

  @override
  State<Pricingpage> createState() => _PricingpageState();
}

class _PricingpageState extends State<Pricingpage> {
  int selectedIndex = 1;

  void _navigateToBooking(String packageName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Bookingpage(prefilledPackage: packageName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    // final isTablet = Responsive.isTablet(context);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/priceback.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              color: Colors.black.withOpacity(0.5),
              child: Column(
                children: [
                  SizedBox(height: isMobile ? 60 : 80), // for navbar
                  SizedBox(height: isMobile ? 20 : 40),

                  Text(
                    'Packages',
                    style: GoogleFonts.playfair(
                      textStyle: TextStyle(fontSize: isMobile ? 28 : 36),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 20 : 40,
                          vertical: 30,
                        ),
                        child: isMobile
                            ? Column(
                                children: [
                                  packageCard("Basic", "₵500", [
                                    "2 Hours Coverage",
                                    "10 Edited Photos",
                                    "Online Gallery",
                                  ], isMobile),
                                  const SizedBox(height: 20),
                                  packageCard(
                                    "Standard",
                                    "₵1200",
                                    [
                                      "5 Hours Coverage",
                                      "30 Edited Photos",
                                      "Online Gallery",
                                      "Print Rights",
                                    ],
                                    isMobile,
                                    isPopular: true,
                                  ),
                                  const SizedBox(height: 20),
                                  packageCard("Basic", "₵2500", [
                                    "Full Day Coverage",
                                    "Unlimited Photos",
                                    "Online Gallery",
                                    "Print Rights",
                                    "Photo Album",
                                  ], isMobile),
                                ],
                              )
                            : Wrap(
                                spacing: 30,
                                runSpacing: 30,
                                alignment: WrapAlignment.center,
                                children: [
                                  packageCard("Basic", "₵500", [
                                    "2 Hours Coverage",
                                    "10 Edited Photos",
                                    "Online Gallery",
                                  ], isMobile),
                                  packageCard(
                                    "Standard",
                                    "₵1200",
                                    [
                                      "5 Hours Coverage",
                                      "30 Edited Photos",
                                      "Online Gallery",
                                      "Print Rights",
                                    ],
                                    isMobile,
                                    isPopular: true,
                                  ),
                                  packageCard("Premium", "₵2500", [
                                    "Full Day Coverage",
                                    "Unlimited Photos",
                                    "Online Gallery",
                                    "Print Rights",
                                    "Photo Album",
                                  ], isMobile),
                                ],
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
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

  Widget packageCard(
    String title,
    String price,
    List<String> features,
    bool isMobile, {
    bool isPopular = false,
  }) {
    return HoverScale(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: isMobile ? double.infinity : 280,
        padding: EdgeInsets.all(isMobile ? 20 : 25),
        decoration: BoxDecoration(
          color: isPopular
              ? Colors.red.withOpacity(0.15)
              : Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(20),
          border: isPopular ? Border.all(color: Colors.red, width: 2) : null,
          boxShadow: isPopular
              ? [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (isPopular)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'MOST POPULAR',
                  style: GoogleFonts.playfair(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            if (isPopular) const SizedBox(height: 10),

            Text(
              title,
              style: GoogleFonts.playfair(
                textStyle: TextStyle(
                  fontSize: isMobile ? 24 : 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '₵',
                  style: GoogleFonts.playfair(
                    textStyle: TextStyle(fontSize: 20, color: Colors.white70),
                  ),
                ),
                Text(
                  price.replaceAll('₵', ''),
                  style: GoogleFonts.playfair(
                    textStyle: TextStyle(
                      fontSize: isMobile ? 36 : 42,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            ...features.map(
              (f) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: isPopular ? Colors.red : Colors.green,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        f,
                        style: GoogleFonts.playfair(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            HoverScale(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: isPopular ? Colors.white : Colors.black,
                    backgroundColor: isPopular ? Colors.red : Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                  ),
                  onPressed: () => _navigateToBooking(title),
                  child: Text(
                    "Select Package",
                    style: GoogleFonts.playfair(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
