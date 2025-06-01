import 'package:flutter/material.dart';

class BookingListPage extends StatefulWidget {
  const BookingListPage({super.key});

  @override
  State<BookingListPage> createState() => _BookingListPageState();
}

class _BookingListPageState extends State<BookingListPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> bookings = [];
  List<Map<String, String>> filteredBookings = [];

  @override
  void initState() {
    super.initState();
    bookings = [
      {
        'id': '#1234',
        'name': 'John Doe',
        'date': 'April 15,2025\n10:00AM',
        'status': 'Pending',
      },
      {
        'id': '#1235',
        'name': 'Bella Cullen',
        'date': 'April 15,2025\n10:00AM',
        'status': 'Cancelled',
      },
      {
        'id': '#1236',
        'name': 'Jane Smith',
        'date': 'April 15,2025\n10:00AM',
        'status': 'Confirmed',
      },
      {
        'id': '#1237',
        'name': 'Chris Brown',
        'date': 'April 21,2025\n10:00AM',
        'status': 'Pending',
      },
    ];
    filteredBookings = List.from(bookings);
    _searchController.addListener(_filterBookings);
  }

  void _filterBookings() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredBookings = bookings.where((booking) {
        return booking.values.any((value) => value.toLowerCase().contains(query));
      }).toList();
    });
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking List'),
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search Bookings',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
            child: Row(
              children: [
                Expanded(child: Text('ID', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(child: Text('Customer', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(child: Text('Date', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(child: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: filteredBookings.length,
              itemBuilder: (context, index) {
                final booking = filteredBookings[index];
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
