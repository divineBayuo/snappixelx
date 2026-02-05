import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snappixelx/widgets/hover_scale.dart';
import 'package:snappixelx/widgets/navbar.dart';

class Pricingpage extends StatefulWidget {
  const Pricingpage({super.key});

  @override
  State<Pricingpage> createState() => _PricingpageState();
}

class _PricingpageState extends State<Pricingpage> {
  int selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
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
                  SizedBox(height: 80), // for navbar

                  const SizedBox(height: 40),

                  Text(
                    'Packages',
                    style: GoogleFonts.playfair(
                      textStyle: TextStyle(fontSize: 36),
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Expanded(
                    child: Center(
                      child: Wrap(
                        spacing: 30,
                        runSpacing: 30,
                        children: [
                          packageCard("Basic", "₵500", [
                            "2 Hours",
                            "10 Photos",
                          ]),
                          packageCard("Standard", "₵1200", [
                            "5 Hours",
                            "30 Photos",
                          ]),
                          packageCard("Premium", "₵2500", [
                            "Full Day",
                            "Unlimited Photos",
                          ]),
                        ],
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

  Widget packageCard(String title, String price, List<String> features) {
    return HoverScale(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 200,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: GoogleFonts.playfair(textStyle: TextStyle(fontSize: 22)),
            ),
            const SizedBox(height: 10),
            Text(
              price,
              style: GoogleFonts.playfair(textStyle: TextStyle(fontSize: 30)),
            ),
            const SizedBox(height: 20),
            ...features.map((f) => Text("• $f", style: GoogleFonts.playfair())),
            const SizedBox(height: 20),
            HoverScale(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                ),
                onPressed: () {},
                child: Text("Select", style: GoogleFonts.playfair()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
