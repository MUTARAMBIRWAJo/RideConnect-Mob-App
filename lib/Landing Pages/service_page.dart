// lib/pages/service_page.dart
import 'package:flutter/material.dart';
import 'package:rideconnect/Landing%20Pages/myfooter.dart';
import 'package:rideconnect/Landing%20Pages/myheader.dart';

class ServicePage extends StatelessWidget {
  const ServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCECEC),
      body: Column(
        children: [
          AppHeader(currentRoute: '/services'), // Highlight About
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [_buildServiceContent(), const SizedBox(height: 40)],
              ),
            ),
          ),
          const Myfooter(),
        ],
      ),
    );
  }

  /// Service Content Section
  Widget _buildServiceContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Center(
            child: Text(
              'What We Serve',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 30),

          // Subheader
          const Center(
            child: Text(
              'Top Values For You',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.blue,
              ),
            ),
          ),
          const SizedBox(height: 15),

          // Description
          const Center(
            child: Text(
              'Try a variety of benefits when using our services.',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ),
          const SizedBox(height: 40),
          const Divider(thickness: 1, height: 20),

          // Service Features
          _buildServiceFeature(
            title: 'Real-Time Rider Matching',
            description:
                'Find available nearby drivers in real-time, ensuring quick and efficient ride matching.',
          ),
          const SizedBox(height: 30),
          _buildServiceFeature(
            title: 'Secure and Reliable Transportation',
            description:
                'All drivers undergo thorough verification to provide passengers with safe and reliable rides.',
          ),
          const SizedBox(height: 30),
          _buildServiceFeature(
            title: 'Easy Ride Booking',
            description:
                'Book a ride with just a few taps on the website. Select your pickup and drop-off locations seamlessly.',
          ),
        ],
      ),
    );
  }

  /// Service Feature Widget
  Widget _buildServiceFeature({
    required String title,
    required String description,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              description,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}
