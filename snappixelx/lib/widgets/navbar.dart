import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NavBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;

  const NavBar({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  final List<Map<String, String>> tabs = [
    {"title": "Home", "route": "/"},
    {"title": "Pricing", "route": "/pricing"},
    {"title": "Portfolio", "route": "/portfolio"},
    {"title": "Booking", "route": "/booking"},
  ];

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.6)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Snappixelx',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              /// Tab Section
              SizedBox(
                width: 400,
                height: 50,
                child: Stack(
                  children: [
                    // Animated background tile
                    AnimatedAlign(
                      alignment: Alignment(
                        -1 + (widget.selectedIndex * 0.66),
                        0,
                      ),
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: Container(
                        width: 100,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),

                    /// Tab buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(tabs.length, (index) {
                        final tab = tabs[index];

                        return _navButton(
                          context,
                          tab["title"]!,
                          tab["route"]!,
                          index,
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navButton(
    BuildContext context,
    String title,
    String route,
    int index,
  ) {
    final bool isActive = widget.selectedIndex == index;

    return TextButton(
      onPressed: () {
        widget.onTabSelected(index);
        Navigator.pushNamed(context, route);
      },
      child: Text(
        title,
        style: GoogleFonts.playfair(
          fontSize: 14,
          color: isActive ? Colors.white : Colors.white70,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
