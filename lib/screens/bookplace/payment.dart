// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trombol_apk/screens/homepage/explore.dart';
import 'package:trombol_apk/screens/bookplace/confirm_payment.dart';
import 'package:trombol_apk/screens/homepage/explore.dart';

class PaymentPage extends StatefulWidget {
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
  final String productId;

  const PaymentPage({
    super.key,
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
    required this.productId, required DateTime selectedDate,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  File? proofFile;
  bool isUploading = false;

  Future<void> pickProofFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['jpg', 'png', 'pdf']);
    if (result != null) {
      setState(() {
        proofFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> saveBookingAndExit() async {
    final user = FirebaseAuth.instance.currentUser;
    final docRef = FirebaseFirestore.instance.collection('bookings').doc();
    await docRef.set({
      'userId': user?.uid,
      'productId': widget.productId,
      'guestName': widget.guestName,
      'totalGuest': widget.totalGuest,
      'phone': widget.phone,
      'email': widget.email,
      'idNumber': widget.idNumber,
      'startDate': widget.startDate,
      'endDate': widget.endDate,
      'totalPrice': widget.totalPrice,
      'createdAt': DateTime.now(),
      'expiresAt': DateTime.now().add(const Duration(hours: 48)),
      'status': 'pending',
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Booking saved for 48 hours")),
    );
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const ExploreToday()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Confirm and Payment', style: TextStyle(color: Colors.black)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    widget.productImage,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.productName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 4),
                      Text("Guest: ${widget.guestName} (${widget.totalGuest})"),
                      Text("Phone: ${widget.phone}"),
                      Text("Email: ${widget.email}"),
                      Text("ID: ${widget.idNumber}"),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Total Price", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("RM${widget.totalPrice.toStringAsFixed(2)}"),
              ],
            ),
            const SizedBox(height: 30),
            Center(
              child: Column(
                children: [
                  const Text("Scan QR to Pay", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Image.asset('assets/images/your_qr_image.png', width: 200, height: 200),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: pickProofFile,
              child: Text(proofFile == null ? "Upload Proof of Payment" : "Proof Selected: ${proofFile!.path.split("/").last}"),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: saveBookingAndExit,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                    child: const Text("Save Booking (48h)", style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: proofFile == null
                        ? null
                        : () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => PaymentInputScreen(
                        productId: widget.productId,
                        productName: widget.productName,
                        productImage: widget.productImage,
                        totalPrice: widget.totalPrice,
                        guestName: widget.guestName,
                        totalGuest: widget.totalGuest,
                        phone: widget.phone,
                        email: widget.email,
                        idNumber: widget.idNumber,
                        startDate: widget.startDate,
                        endDate: widget.endDate,
                      )),
                    ),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF085374)),
                    child: const Text("Process Payment"),
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
