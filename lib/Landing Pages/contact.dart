import 'package:flutter/material.dart';
import 'package:rideconnect/Landing%20Pages/myfooter.dart';
import 'package:rideconnect/Landing%20Pages/myheader.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCECEC), // Match your theme color
      body: SingleChildScrollView(
        child: Column(
          children: [
            const AppHeader(
              currentRoute: '/contacts',
            ), // Highlight About// Header Section
            // Contact Form Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  const Text(
                    'Prepare Yourself & Let\'s Explore The Beauty Of The Country',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Subtitle
                  const Text(
                    'We have many special offers recommended for you.',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 40),

                  // Contact Form
                  _buildContactForm(),
                  const SizedBox(height: 30),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle form submission
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'SUBMIT',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Myfooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildContactForm() {
    return Column(
      children: [
        // Full Name Field
        const Text(
          'FULL NAMES',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          decoration: const InputDecoration(
            hintText: 'enter your names',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          ),
        ),
        const SizedBox(height: 20),

        // Email Field
        const Text(
          'EMAIL',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          decoration: const InputDecoration(
            hintText: 'your email',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 20),

        // Message Field
        const Text(
          'MESSAGE',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          decoration: const InputDecoration(
            hintText: 'type your message here....',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          ),
          maxLines: 5,
        ),
      ],
    );
  }
}
