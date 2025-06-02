import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:trombol_apk/screens/bookplace/payment.dart'; // Make sure this import is correct

class BookingConfirmedPage extends StatelessWidget {
  final String bookingId;

  const BookingConfirmedPage({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF085374),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Booking Ticket",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('bookings').doc(bookingId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("Booking not found", style: TextStyle(color: Colors.white)));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final startDate = _formatDate(data['startDate']);
          final endDate = data['endDate'] != null ? _formatDate(data['endDate']) : null;
          final dateRange = endDate != null ? '$startDate - $endDate' : startDate;
          final status = data['status'] ?? 'pending';
          final expiresAt = data['expiresAt'] != null
              ? _formatDate(data['expiresAt'])
              : null;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // 🧾 SUMMARY CARD
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            data['productImage'] ?? '',
                            width: 90,
                            height: 90,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Image.asset('assets/images/default.jpg', width: 90, height: 90),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(data['productName'] ?? 'Product',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                              const SizedBox(height: 6),
                              Text("Date: $dateRange"),
                              const SizedBox(height: 8),
                              _statusBadge(status),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                if (status == 'confirmed')
                  Text("PAID", style: TextStyle(color: Colors.green[700], fontSize: 26, fontWeight: FontWeight.bold)),

                if (status == 'pending') ...[
                  Text("PENDING PAYMENT", style: TextStyle(color: Colors.grey[800], fontSize: 26, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  if (expiresAt != null)
                    Text("Expires on: $expiresAt", style: const TextStyle(color: Colors.redAccent)),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PaymentPage(
                            productId: data['productId'],
                            productName: data['productName'],
                            productImage: data['productImage'],
                            totalPrice: data['totalPrice'],
                            guestName: data['guestName'],
                            totalGuest: data['totalGuest'],
                            phone: data['phone'],
                            email: data['email'],
                            idNumber: data['idNumber'],
                            startDate: (data['startDate'] as Timestamp).toDate(),
                            endDate: data['endDate'] != null
                                ? (data['endDate'] as Timestamp).toDate()
                                : null,
                            selectedDate: (data['startDate'] as Timestamp).toDate(),
                          ),
                        ),
                      );
                    },
                    child: const Text("Complete Payment"),
                  ),
                ],

                const SizedBox(height: 24),

                // 🧾 BOOKING DETAILS
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Booking Details", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),

                      _info("Booking ID", bookingId),
                      _info("Customer Name", data['guestName']),
                      _info("Phone", data['phone']),
                      _info("Email", data['email']),
                      _info("IC / Passport", data['idNumber']),
                      _info("Guest / Quantity", data['totalGuest'].toString()),
                      _info("Date", dateRange),
                      _info("Total Price", "RM${(data['totalPrice'] ?? 0).toStringAsFixed(2)}"),
                      _info("Status", status),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _info(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120, child: Text("$label:", style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  String _formatDate(dynamic date) {
    if (date == null) return 'Unknown';
    final dt = (date is Timestamp) ? date.toDate() : DateTime.tryParse(date.toString());
    if (dt == null) return 'Invalid';
    return DateFormat('dd/MM/yyyy').format(dt);
  }

  Widget _statusBadge(String status) {
    Color bgColor;
    switch (status) {
      case 'confirmed':
        bgColor = Colors.green;
        break;
      case 'pending':
        bgColor = Colors.grey;
        break;
      case 'unpaid':
        bgColor = Colors.amber;
        break;
      case 'rejected':
        bgColor = Colors.red;
        break;
      default:
        bgColor = Colors.grey.shade700;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
