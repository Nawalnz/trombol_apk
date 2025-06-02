import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trombol_apk/screens/navbar_button/booking/ticket.dart';

class BookingsPage extends StatelessWidget {
  const BookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Bookings')),
      body: user == null
          ? const Center(child: Text("Not signed in"))
          : StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('bookings')
            .where('userId', isEqualTo: user.uid)
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No bookings found."));
          }

          final bookings = snapshot.data!.docs;
          print("Fetched ${bookings.length} booking(s)");

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final data = bookings[index].data() as Map<String, dynamic>;

              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BookingConfirmedPage(
                        bookingId: data['bookingId'] ?? bookings[index].id,
                      ),
                    ),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            data['productImage'] ?? '',
                            width: 100,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Image.asset(
                              'assets/images/default.jpg',
                              width: 100,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data['productName'] ?? 'Unknown Product',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text("Status: ${data['status'] ?? 'N/A'}"),
                              Text("Date: ${_formatDate(data['startDate'])}"),
                              Text("RM${data['totalPrice']}"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  static String _formatDate(dynamic timestamp) {
    if (timestamp == null) return 'Unknown';
    try {
      final date = (timestamp is Timestamp)
          ? timestamp.toDate()
          : DateTime.tryParse(timestamp.toString());
      if (date == null) return 'Invalid';
      return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    } catch (e) {
      return 'Error';
    }
  }
}
