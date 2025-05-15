// lib/pages/landing_page.dart
import 'package:flutter/material.dart';
import 'package:rideconnect/Landing%20Pages/myfooter.dart';
import 'package:rideconnect/Landing%20Pages/myheader.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCECEC), // Light pink background
      body: Column(
        children: [
          const AppHeader(currentRoute: '/'), // Highlight Home
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 50),
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    if (constraints.maxWidth > 768) {
                      // Wide screen layout
                      return _buildWideHeroSection();
                    } else {
                      // Narrow screen layout
                      return _buildNarrowHeroSection();
                    }
                  },
                ),
              ),
            ),
          ),
          const Myfooter(),
        ],
      ),
    );
  }

  /// 🔹 **Hero Section for Wide Screens**
  Widget _buildWideHeroSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: [
          // Left Side: Text Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTagline(),
                const SizedBox(height: 80),
                const Text(
                  "It's a Big Country Out Here, Go and Explore",
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 60),
                const Text(
                  "We always make our customers happy by connecting Motorcyclist and passengers",
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                ),
                const SizedBox(height: 80),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                      child: const Text("Book Motorcyclist >"),
                    ),
                    const SizedBox(width: 20),
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.play_circle_fill,
                        color: Colors.black,
                        size: 24,
                      ),
                      label: const Text(
                        "Watch our Story",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 40),

          // Right Side: Images
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/motorcycle.png", width: 200),
                const SizedBox(height: 60),
                Image.asset("assets/taxi.png", width: 220),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 **Hero Section for Narrow Screens**
  Widget _buildNarrowHeroSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildTagline(isNarrow: true),
          const SizedBox(height: 40),
          const Text(
            "It's a Big Country Out Here, Go and Explore",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 40),
          const Text(
            "We always make our customers happy by connecting Motorcyclist and passengers",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          const SizedBox(height: 60),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              textStyle: const TextStyle(fontSize: 16),
            ),
            child: const Text("Book Motorcyclist >"),
          ),
          const SizedBox(height: 15),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(
              Icons.play_circle_fill,
              color: Colors.black,
              size: 20,
            ),
            label: const Text(
              "Watch our Story",
              style: TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 60),
          Image.asset("assets/motorcycle.png", width: 180),
          const SizedBox(height: 30),
          Image.asset("assets/taxi.png", width: 200),
        ],
      ),
    );
  }

  /// 🏷️ **Tagline Widget**
  Widget _buildTagline({bool isNarrow = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.redAccent.shade100,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Go where you want to ',
            style: TextStyle(
              fontSize: isNarrow ? 12 : 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 4),
          Icon(Icons.public, color: Colors.blue, size: isNarrow ? 16 : 20),
        ],
      ),
    );
  }
}