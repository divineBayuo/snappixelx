import 'package:flutter/material.dart';
import 'package:snappixelx/screens/booking_page.dart';
import 'package:snappixelx/screens/home_page.dart';
import 'package:snappixelx/screens/price_page.dart';
import 'package:snappixelx/screens/ref_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photography Portfolio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      routes: {
        '/': (context) => const Homepage(),
        '/pricing': (context) => const Pricingpage(),
        '/portfolio': (context) => const Refpage(),
        '/booking': (context) => const Bookingpage(),
      },
    );
  }
}