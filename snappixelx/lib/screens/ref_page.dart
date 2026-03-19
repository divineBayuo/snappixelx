import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snappixelx/core/responsive_helper.dart';
import 'package:snappixelx/widgets/hover_scale.dart';
import 'package:snappixelx/widgets/navbar.dart';

class PortfolioItem {
  final String category;
  final String path;
  const PortfolioItem({required this.category, required this.path});

  factory PortfolioItem.fromJson(Map<String, dynamic> json) => PortfolioItem(
    category: json['category'] as String,
    path: json['path'] as String,
  );
}

class Refpage extends StatefulWidget {
  const Refpage({super.key});

  @override
  State<Refpage> createState() => _RefpageState();
}

class _RefpageState extends State<Refpage> {
  int selectedIndex = 2;
  List<PortfolioItem> _allItems = [];
  String _selectedFilter = 'All';
  bool _loaded = false;
  bool _initialCategoryApplied = false;

  @override
  void initState() {
    super.initState();
    _loadPortfolioData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // only apply the route argument once so user can freely change filter after
    if (!_initialCategoryApplied) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is String) {
        _selectedFilter = args;
      }
      _initialCategoryApplied = true;
    }
  }

  Future<void> _loadPortfolioData() async {
    try {
      final jsonStr = await rootBundle.loadString('assets/portfolio.json');
      final List<dynamic> data = json.decode(jsonStr);
      setState(() {
        _allItems = data
            .map((e) => PortfolioItem.fromJson(e as Map<String, dynamic>))
            .toList();
        _loaded = true;
      });
    } catch (e) {
      debugPrint('Error loading images from db: $e');
      setState(() {
        _loaded = true;
      });
    }
  }

  // Derive unique ordered categories from the JSON
  /* List<String> get _categories {
    final seen = <String>{};
    final unique = <String>[];
    for (final item in _allItems) {
      if (seen.add(item.category)) unique.add(item.category);
    }
    return ['All', ...unique];
  } */

  List<String> get _categories => const [
    'All',
    'Portraits',
    'Corporate Events',
    'Professional Headshots',
    'Real Estates & Architectural',
    'Others',
  ];

  List<PortfolioItem> get _filteredItems => _selectedFilter == 'All'
      ? _allItems
      : _allItems.where((e) => e.category == _selectedFilter).toList();

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
    final crossAxisCount = isMobile
        ? 1
        : isTablet
        ? 2
        : 3;

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

              const SizedBox(height: 20),

              // Filter chips - show once data is loaded
              if (_loaded)
                SizedBox(
                  height: 44,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 20 : 40,
                    ),
                    itemCount: _categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final cat = _categories[index];
                      final isSelected = _selectedFilter == cat;
                      return Center(
                        child: FilterChip(
                          label: Text(
                            cat,
                            style: GoogleFonts.playfair(
                              fontSize: 12,
                              color: isSelected ? Colors.black : Colors.white,
                            ),
                          ),
                          selected: isSelected,
                          onSelected: (_) =>
                              setState(() => _selectedFilter = cat),
                          backgroundColor: Colors.white.withOpacity(0.12),
                          selectedColor: Colors.white,
                          checkmarkColor: Colors.black,
                          showCheckmark: false,
                          side: BorderSide(
                            color: isSelected
                                ? Colors.white
                                : Colors.white.withOpacity(0.35),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                        ),
                      );
                    },
                  ),
                ),

              const SizedBox(height: 16),

              // Grid
              Expanded(
                child: !_loaded
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : _filteredItems.isEmpty
                    ? Center(
                        child: Text(
                          'No images in this category.',
                          style: GoogleFonts.playfair(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      )
                    : GridView.builder(
                        padding: EdgeInsets.fromLTRB(
                          isMobile ? 20 : 40,
                          0,
                          isMobile ? 20 : 40,
                          isMobile ? 20 : 40,
                        ),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: isMobile ? 15 : 20,
                          mainAxisSpacing: isMobile ? 15 : 20,
                          childAspectRatio: 1,
                        ),
                        itemCount: _filteredItems.length,
                        itemBuilder: (context, index) {
                          final item = _filteredItems[index];
                          return HoverScale(
                            child: GestureDetector(
                              onTap: () => _showImageDialog(item.path),
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
                                      Image.asset(item.path, fit: BoxFit.cover),

                                      Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.transparent,
                                              Colors.black.withOpacity(0.45),
                                            ],
                                          ),
                                        ),
                                      ),

                                      // icon
                                      Positioned(
                                        bottom: 10,
                                        left: 10,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(
                                              0.55,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                          child: Text(
                                            item.category,
                                            style: GoogleFonts.playfair(
                                              fontSize: 11,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),

                                      // Zoom icon
                                      Positioned(
                                        bottom: 10,
                                        right: 10,
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(
                                              0.9,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: const Icon(
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
