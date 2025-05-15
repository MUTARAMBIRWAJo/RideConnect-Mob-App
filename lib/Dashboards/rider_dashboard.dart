import 'package:flutter/material.dart';

class RiderDashboard extends StatelessWidget {
  const RiderDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rider Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {},
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // RideConnect Services Section
              const Text(
                'RideConnect',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: const [
                  ServiceChip('Red Connect'),
                  ServiceChip('Blue Circle'),
                  ServiceChip('Echoes'),
                  ServiceChip('Non-Crossing'),
                  ServiceChip('AirChip'),
                  ServiceChip('Dropout'),
                  ServiceChip('Peripheral, 0x10k'),
                  ServiceChip('Time to start'),
                  ServiceChip('Ride support'),
                  ServiceChip('Expected'),
                ],
              ),
              const Divider(height: 40),

              // Ride Information Section
              const Text(
                'Ride Information',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const InfoCard(
                items: [
                  'NE 22AH TYG Driver Modifications yves',
                  '4-hour Total r/sec Status',
                  'Kubernetes Yves ID: 2334562525',
                  '60 Available',
                ],
              ),
              const Divider(height: 40),

              // Last Reinstallment Section
              const Text(
                'Last reinstallment',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const InfoCard(
                items: [
                  '11 says, 2024',
                  'Number of plans',
                  'NE 23AH',
                ],
              ),
              const Divider(height: 40),

              // Trip History Section
              const Text(
                'TRIP HISTORY',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TripHistoryTable(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppFooter(),
    );
  }
}

// Left Sidebar/Drawer
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'RideConnect',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Trip History'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Payments'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Help & Support'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

// Service Chip Widget
class ServiceChip extends StatelessWidget {
  final String label;
  const ServiceChip(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      backgroundColor: Colors.blue[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

// Information Card Widget
class InfoCard extends StatelessWidget {
  final List<String> items;
  const InfoCard({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: items.map((item) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(item),
          )).toList(),
        ),
      ),
    );
  }
}

// Trip History Table Widget
class TripHistoryTable extends StatelessWidget {
  final List<Map<String, String>> trips = [
    {
      'no': '01',
      'details': '*2343562534 memen -gpushe, hoseo',
      'status': 'completed'
    },
    {
      'no': '02',
      'details': '*0734674624 mobil -mynbogoro, yven',
      'status': 'cancelled'
    },
    {
      'no': '03',
      'details': '*2343562534 khotelagua -katnevko, edc',
      'status': 'completed'
    },
  ];

  TripHistoryTable({super.key});

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: const [
        DataColumn(label: Text('NO')),
        DataColumn(label: Text('Trip details')),
        DataColumn(label: Text('Status')),
      ],
      rows: trips.map((trip) => DataRow(cells: [
        DataCell(Text(trip['no']!)),
        DataCell(Text(trip['details']!)),
        DataCell(
          Chip(
            label: Text(
              trip['status']!,
              style: TextStyle(
                color: trip['status'] == 'completed' 
                  ? Colors.green 
                  : Colors.red,
              ),
            ),
            backgroundColor: trip['status'] == 'completed' 
              ? Colors.green[50] 
              : Colors.red[50],
          ),
        ),
      ])).toList(),
    );
  }
}

// Footer Widget
class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[200],
      child: const Center(
        child: Text(
          '© 2025 RideConnect. All rights reserved.',
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}