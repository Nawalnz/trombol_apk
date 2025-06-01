import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trombol_apk/screens/navbar_button/booking/ticket.dart';

class MyBookingsPage extends StatelessWidget {
  const MyBookingsPage({super.key});

  static String _formatDate(Map<String, dynamic> data) {
    final selectedDate = data['selectedDate'];
    final createdAt = data['createdAt'];

    if (selectedDate != null) {
      return selectedDate.toString().substring(0, 10);
    } else if (createdAt != null && createdAt is Timestamp) {
      return (createdAt).toDate().toString().substring(0, 10);
    } else {
      return 'N/A';
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('My Bookings'),
          backgroundColor: const Color(0xFF085374),
          foregroundColor: Colors.white,
        ),
        body: Center(child: Text('You must be logged in to view bookings.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        backgroundColor: const Color(0xFF085374),
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('bookings')
            .where('userId', isEqualTo: currentUser.uid)
            //.orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No bookings found.'));
          }


          final bookings = snapshot.data!.docs;

          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index].data() as Map<String, dynamic>;

              return ListTile(
                title: Text(booking['tourTitle'] ?? 'No Title'),
                subtitle: Text('Date: ${_formatDate(booking)}'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BookingConfirmedPage(data: booking, bookingData: {},)

                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}