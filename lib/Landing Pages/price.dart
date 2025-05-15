import 'package:flutter/material.dart';
import 'package:rideconnect/Landing%20Pages/myheader.dart';

class PricingPage extends StatelessWidget {
  const PricingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCECEC), // Matching your theme
      body: Column(
        children: [
          AppHeader(
            currentRoute: '/pricing',
          ), // Highlight About// Header Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Best Places In Rwanda',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Explore Top Destination',
                  style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                ),
              ],
            ),
          ),

          // Pricing Cards
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: const [
                DestinationCard(price: 49),
                DestinationCard(price: 54),
                DestinationCard(price: 30),
                DestinationCard(price: 25),
                DestinationCard(price: 46),
              ],
            ),
          ),

          // View All Button
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: () {
                // Add navigation to all destinations
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'view all destination',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DestinationCard extends StatelessWidget {
  final int price;
  final String? imagePath;
  final String? title;

  const DestinationCard({
    super.key,
    required this.price,
    magePath = 'assets/kigali1.png',
    this.title,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            // Destination Image
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[200], // Placeholder color
                borderRadius: BorderRadius.circular(8),
                image:
                    imagePath != null
                        ? DecorationImage(
                          image: AssetImage(imagePath!),
                          fit: BoxFit.cover,
                        )
                        : null,
              ),
              child:
                  imagePath == null
                      ? const Icon(Icons.image, size: 40, color: Colors.grey)
                      : null,
            ),
            const SizedBox(width: 15),

            // Destination Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title ?? 'Rwanda Destination',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Beautiful location with amazing views',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),

            // Price
            Text(
              '\$$price',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
