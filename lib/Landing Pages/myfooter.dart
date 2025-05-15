import 'package:flutter/material.dart';

class Myfooter extends StatelessWidget {
  const Myfooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      color: Colors.black,
      child: Column(
        children: [
          // Footer Links
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _footerColumn(
                title: 'Company',
                items: ['About Us', 'Careers', 'Blog', 'Press'],
              ),
              _footerColumn(
                title: 'Products',
                items: [
                  'RideConnect',
                  'RideConnect Business',
                  'RideConnect Bike',
                ],
              ),
              _footerColumn(
                title: 'Support',
                items: ['Help Center', 'Safety', 'Community Guidelines'],
              ),
              _footerColumn(
                title: 'Legal',
                items: ['Terms of Service', 'Privacy Policy', 'Cookie Policy'],
              ),
            ],
          ),
          const SizedBox(height: 4),

          // Social Media and App Stores
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.facebook, color: Colors.white),
                onPressed: () {},
              ),
              const SizedBox(width: 40),
              IconButton(
                icon: const Icon(Icons.call, color: Colors.white),
                onPressed: () {},
              ),
              const SizedBox(width: 40),
              IconButton(
                icon: const Icon(
                  Icons.location_city_rounded,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 3),

          // Copyright
          const Text(
            "© 2025 RideConnect Technologies Inc. All rights reserved.",
            style: TextStyle(color: Colors.white54, fontSize: 7),
          ),
        ],
      ),
    );
  }

  /// 🔹 **Footer Column Widget** (Same as before)
  Widget _footerColumn({required String title, required List<String> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 6,
          ),
        ),
        const SizedBox(height: 2),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              item,
              style: const TextStyle(color: Colors.white54, fontSize: 7),
            ),
          ),
        ),
        // .toList(),
      ],
    );
  }
}
