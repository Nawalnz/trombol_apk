import 'package:flutter/material.dart';

class BookingListPage extends StatelessWidget {
  const BookingListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> bookings = [
      {
        'id': '#1234',
        'name': 'John Doe',
        'date': 'April 15,2025\n10:00AM',
        'status': 'Pending',
      },
      {
        'id': '#1234',
        'name': 'Bella Cullen',
        'date': 'April 15,2025\n10:00AM',
        'status': 'Cancelled',
      },
      {
        'id': '#1234',
        'name': 'Jane Smith',
        'date': 'April 15,2025\n10:00AM',
        'status': 'Confirmed',
      },
      {
        'id': '#1234',
        'name': 'Chris Brown',
        'date': 'April 21,2025\n10:00AM',
        'status': 'Pending',
      },
    ];

    Color getStatusColor(String status) {
      switch (status) {
        case 'Confirmed':
          return Colors.green.shade200;
        case 'Pending':
          return Colors.amber.shade200;
        case 'Cancelled':
          return Colors.red.shade200;
        default:
          return Colors.grey.shade300;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking List'),
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search Bookings',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),

          // Header Row
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
            child: Row(
              // ignore: unnecessary_const
              children: const [
                Expanded(child: Text('ID', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(child: Text('Customer', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(child: Text('Date', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(child: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
              ],
            ),
          ),

          const Divider(),

          // List
          Expanded(
            child: ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: Text(booking['id']!)),
                      Expanded(child: Text(booking['name']!)),
                      Expanded(child: Text(booking['date']!)),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: getStatusColor(booking['status']!),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            booking['status']!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
