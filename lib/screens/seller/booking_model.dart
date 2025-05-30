import 'package:cloud_firestore/cloud_firestore.dart';


class Booking {
  final String id; // Firestore document ID
  final String bookingId; // Display ID like "#1234"
  final String customerName;
  final String bookingDate; // Display string
  final String status;
  // Add this if you store the date as a Timestamp in Firestore
  // final Timestamp? bookingTimestamp;

  Booking({
    required this.id,
    required this.bookingId,
    required this.customerName,
    required this.bookingDate,
    required this.status,
    // this.bookingTimestamp,
  });

  factory Booking.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw StateError("Missing data for Booking doc ${doc.id}");
    }

    // Example for handling a Timestamp field from Firestore and formatting it
    // String formattedDate = 'No Date';
    // Timestamp? timestamp = data['bookingTimestamp'] as Timestamp?;
    // if (timestamp != null) {
    //   DateTime dateTime = timestamp.toDate();
    //   formattedDate = DateFormat('MMM dd, yyyy\nhh:mm a').format(dateTime); // Customize format
    // }

    return Booking(
      id: doc.id,
      bookingId: data['bookingId'] as String? ?? '#N/A',
      customerName: data['customerName'] as String? ?? 'Unknown',
      bookingDate: data['bookingDate'] as String? ?? 'No Date', // Use this if date is stored as String
      // bookingDate: formattedDate, // Use this if date is stored as Timestamp and formatted
      status: data['status'] as String? ?? 'Unknown',
      // bookingTimestamp: timestamp,
    );
  }

  // Optional: Add a method to convert back to Map for saving to Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'bookingId': bookingId,
      'customerName': customerName,
      'bookingDate': bookingDate, // Or bookingTimestamp if using Timestamp
      'status': status,
      // 'bookingTimestamp': bookingTimestamp, // if you are using a Timestamp
    };
  }
}
