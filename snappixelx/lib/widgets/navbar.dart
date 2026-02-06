import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snappixelx/core/responsive_helper.dart';

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
  bool _isMenuOpen = false;

  final List<Map<String, String>> tabs = [
    {"title": "Home", "route": "/"},
    {"title": "Pricing", "route": "/pricing"},
    {"title": "Portfolio", "route": "/portfolio"},
    {"title": "Booking", "route": "/booking"},
  ];

  void _navigateTo(String route, int index) {
    widget.onTabSelected(index);
    Navigator.pushNamed(context, route);

    if (_isMenuOpen) {
      setState(() => _isMenuOpen = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: isMobile ? 60 : 80,
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 40),
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.6)),
          child: isMobile ? _buildMobileNav() : _buildDesktopNav(),
        ),
      ),
    );
  }

  Widget _buildDesktopNav() {
    return Row(
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
                alignment: Alignment(-1 + (widget.selectedIndex * 0.66), 0),
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
    );
  }

  Widget _buildMobileNav() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Snappixelx',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),

        /// Hamburger Menu
        IconButton(
          onPressed: () {
            setState(() => _isMenuOpen = !_isMenuOpen);
          },
          icon: AnimatedIcon(
            icon: AnimatedIcons.menu_close,
            progress: _isMenuOpen
                ? const AlwaysStoppedAnimation(1.0)
                : const AlwaysStoppedAnimation(0.0),
            color: Colors.white,
          ),
        ),
      ],
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
      onPressed: () => _navigateTo(route, index),
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

  // Mobile menu overlay
  Widget buildMobileMenu() {
    if (!_isMenuOpen) return const SizedBox.shrink();

    return Positioned(
      top: 60,
      left: 0,
      right: 0,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.9),
              border: Border(
                bottom: BorderSide(color: Colors.white.withOpacity(0.1)),
              ),
            ),
            child: Column(
              children: List.generate(tabs.length, (index) {
                final tab = tabs[index];
                final isActive = widget.selectedIndex == index;

                return InkWell(
                  onTap: () => _navigateTo(tab["route"]!, index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: isActive
                          ? Colors.white.withOpacity(0.1)
                          : Colors.transparent,
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        if (isActive)
                          Container(
                            width: 4,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        if (isActive) const SizedBox(width: 12),
                        Text(
                          tab["title"]!,
                          style: GoogleFonts.playfair(
                            fontSize: 16,
                            color: isActive ? Colors.white : Colors.white70,
                            fontWeight: isActive
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

// wrapper widget to handle mobile menu overlay
class NavBarWithMenu extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;

  const NavBarWithMenu({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    if (!isMobile) {
      return NavBar(selectedIndex: selectedIndex, onTabSelected: onTabSelected);
    }

    // for mobile use state mgt
    return _MobileNavWrapper(
      selectedIndex: selectedIndex,
      onTabSelected: onTabSelected,
    );
  }
}

class _MobileNavWrapper extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;

  const _MobileNavWrapper({
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  State<_MobileNavWrapper> createState() => _MobileNavWrapperState();
}

class _MobileNavWrapperState extends State<_MobileNavWrapper> {
  bool _isMenuOpen = false;

  final List<Map<String, String>> tabs = [
    {"title": "Home", "route": "/"},
    {"title": "Pricing", "route": "/pricing"},
    {"title": "Portfolio", "route": "/portfolio"},
    {"title": "Booking", "route": "/booking"},
  ];

  void _navigateTo(String route, int index) {
    widget.onTabSelected(index);
    Navigator.pushNamed(context, route);
    setState(() => _isMenuOpen = false);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Navbar
        ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.6)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Snappixelx',
                    style: GoogleFonts.playfair(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() => _isMenuOpen = !_isMenuOpen);
                    },
                    icon: Icon(
                      _isMenuOpen ? Icons.close : Icons.menu,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Mobile menu
        if (_isMenuOpen)
          Positioned(
            top: 60,
            left: 0,
            right: 0,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.9),
                  ),
                  child: Column(
                    children: List.generate(tabs.length, (index) {
                      final tab = tabs[index];
                      final isActive = widget.selectedIndex == index;

                      return InkWell(
                        onTap: () => _navigateTo(tab["route"]!, index),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: isActive
                                ? Colors.white.withOpacity(0.1)
                                : Colors.transparent,
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.white.withOpacity(0.1),
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              if (isActive)
                                Container(
                                  width: 4,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              if (isActive) const SizedBox(width: 12),
                              Text(
                                tab["title"]!,
                                style: GoogleFonts.playfair(
                                  fontSize: 16,
                                  color: isActive
                                      ? Colors.white
                                      : Colors.white70,
                                  fontWeight: isActive
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
