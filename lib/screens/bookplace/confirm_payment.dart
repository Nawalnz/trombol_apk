import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trombol_apk/screens/homepage/explore.dart';

class PaymentInputScreen extends StatefulWidget {
  final String productId;
  final String productName;
  final String productImage;
  final double totalPrice;
  final String guestName;
  final int totalGuest;
  final String phone;
  final String email;
  final String idNumber;
  final DateTime startDate;
  final DateTime? endDate;

  const PaymentInputScreen({
    super.key,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.totalPrice,
    required this.guestName,
    required this.totalGuest,
    required this.phone,
    required this.email,
    required this.idNumber,
    required this.startDate,
    required this.endDate,
  });

  @override
  State<PaymentInputScreen> createState() => _PaymentInputScreenState();
}

class _PaymentInputScreenState extends State<PaymentInputScreen> {
  bool isSaving = true;

  @override
  void initState() {
    super.initState();
    _saveBookingAndRedirect();
  }

  Future<void> _saveBookingAndRedirect() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // handle error if needed
      return;
    }

    final bookingRef = FirebaseFirestore.instance.collection('bookings').doc();

    await bookingRef.set({
      'bookingId': bookingRef.id,
      'userId': user.uid,
      'productId': widget.productId,
      'productName': widget.productName,
      'productImage': widget.productImage,
      'guestName': widget.guestName,
      'totalGuest': widget.totalGuest,
      'phone': widget.phone,
      'email': widget.email,
      'idNumber': widget.idNumber,
      'startDate': widget.startDate,
      'endDate': widget.endDate,
      'totalPrice': widget.totalPrice,
      'status': 'pending',
      'createdAt': DateTime.now(),
      'expiresAt': DateTime.now().add(const Duration(hours: 48)),
      'notifiedAdmin': true, // 👈 optional flag if admin filters this
    });

    setState(() => isSaving = false);

    // Wait 5 seconds before redirect
    await Future.delayed(const Duration(seconds: 5));

    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const ExploreToday()),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: isSaving
            ? const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text("Processing your booking...", style: TextStyle(fontSize: 16)),
          ],
        )
            : const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 80),
            SizedBox(height: 16),
            Text("Booking Submitted!", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                "Your booking has been submitted and will be reviewed by the seller. You will be notified when it's confirmed or declined.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
