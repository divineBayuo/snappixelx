import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
          Column(
            children: [
              SizedBox(height: 80), // for navbar

              const SizedBox(height: 30),
              Text(
                "Portfolio",
                style: GoogleFonts.playfair(
                  textStyle: TextStyle(fontSize: 36),
                  fontWeight: FontWeight.bold,
                ),
              ),

              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(40),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return HoverScale(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(images[index], fit: BoxFit.cover),
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
