import 'package:flutter/material.dart';
import 'package:trombol_apk/screens/bookplace/booking_successful.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PaymentInputScreen(),
    ),
  );
}

class PaymentInputScreen extends StatelessWidget {
  const PaymentInputScreen({super.key});

  Future<void> saveBooking() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final bookingRef = FirebaseFirestore.instance.collection('bookings').doc();

    await bookingRef.set({
      'bookingId': bookingRef.id,
      'userId': user.uid,
      'tourTitle': 'Damai Lagoon Resort',
      'productId': 'JMSlXcwBBeBRzV7Urz33',
      'selectedDate': DateTime.now().toIso8601String(), // or pass real selectedDate
      'guestCount': 2,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // this will navigate back
          },
        ),
        title: const Text('Payment', style: TextStyle(color: Colors.black)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),

            const Icon(Icons.qr_code_2, size: 100, color: Color(0xFF085374)),
            const SizedBox(height: 20),
            const Text(
              'Confirm that you have scanned the QR and completed the payment.',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),

            const Spacer(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: const TextSpan(
                    text: 'RM1200',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF085374),
                    ),
                    children: [
                      TextSpan(
                        text: '/2Person',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF085374),
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF085374),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 18,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    await saveBooking(); // 🔥 Save booking to Firestore

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const BookingSuccessScreen()),
                    );
                  },

                  child: const Text(
                    'Confirm',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
