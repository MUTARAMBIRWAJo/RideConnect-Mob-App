// lib/pages/about_page.dart
import 'package:flutter/material.dart';
import 'package:rideconnect/Landing%20Pages/myfooter.dart';
import 'package:rideconnect/Landing%20Pages/myheader.dart';
// ignore: depend_on_referenced_packages

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCECEC), // Light pink background
      body: Column(
        children: [
          AppHeader(currentRoute: '/about'), // Highlight About
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeroSection(),
                  _buildStatsSection(),
                  // IMAGE PLACEHOLDER - Replace with your image widget
                  // Example:
                  // Image.asset('assets/about_us_image.jpg'),
                  // or
                  // Image.network('https://example.com/about-image.jpg'),
                ],
              ),
            ),
          ),
          const Myfooter(),
        ],
      ),
    );
  }

  /// Hero Section
  Widget _buildHeroSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 60, 40, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quality And Comfort',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            'With Our Experience We Will Serve You',
            style: TextStyle(fontSize: 20, color: Colors.black54),
          ),
          const SizedBox(height: 25),
          const Text(
            'Since we first opened we have always prioritized the convenience of our users by providing low prices and with easy process.',
            style: TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
          ),
          const SizedBox(height: 40),

          // IMAGE PLACEHOLDER - Replace with your image widget
          Container(
            height: 300,
            color: Colors.grey[200],
            alignment: Alignment.center,
            child: const Text(
              'INSERT COMPANY IMAGE HERE',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  /// Stats Section
  Widget _buildStatsSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildStatItem('20', 'Years Experience'),
            _buildStatItem('460+', 'Destination Collaboration'),
            _buildStatItem('50k+', 'Happy Customer'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 42,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
      ],
    );
  }
}
