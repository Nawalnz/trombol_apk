import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trombol_apk/screens/bookplace/detail_booking.dart';

// Updated BookingCalendar class
class BookingCalendar extends StatefulWidget {
  final String productId;
  final String productType;
  final String productName;
  final String productImage;
  final double price;

  const BookingCalendar({
    super.key,
    required this.productId,
    required this.productType,
    required this.productName,
    required this.productImage,
    required this.price,
  });

  @override
  State<BookingCalendar> createState() => _BookingCalendarState();
}

class _BookingCalendarState extends State<BookingCalendar> {
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  List<DateTime> unavailableDates = [];
  bool isLoading = true;

  bool get isAccommodation => widget.productType == 'accommodation';

  @override
  void initState() {
    super.initState();
    _loadUnavailableDates();
  }

  Future<void> _loadUnavailableDates() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.productId)
          .get();

      final List<dynamic> dateStrings = doc.data()?['unavailableDates'] ?? [];

      setState(() {
        unavailableDates = dateStrings.map((d) {
          if (d is Timestamp) return d.toDate();
          if (d is String) return DateTime.tryParse(d);
          return null;
        }).whereType<DateTime>().toList();
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading unavailable dates: $e');
      setState(() => isLoading = false);
    }
  }

  bool isDateUnavailable(DateTime date) {
    return unavailableDates.any((d) =>
    d.year == date.year &&
        d.month == date.month &&
        d.day == date.day);
  }

  void handleDateTap(DateTime date) {
    if (isDateUnavailable(date)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("This date is unavailable")),
      );
      return;
    }

    setState(() {
      if (isAccommodation) {
        if (selectedStartDate == null || selectedEndDate != null) {
          selectedStartDate = date;
          selectedEndDate = null;
        } else if (date.isBefore(selectedStartDate!)) {
          selectedStartDate = date;
        } else {
          selectedEndDate = date;
        }
      } else {
        selectedStartDate = date;
        selectedEndDate = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final canProceed = selectedStartDate != null &&
        (!isAccommodation || selectedEndDate != null);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Available date", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Choose your booking", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            ...List.generate(12, (index) {
              final now = DateTime.now();
              final year = now.year + ((now.month + index - 1) ~/ 12);
              final month = (now.month + index - 1) % 12 + 1;
              final startDay = DateTime(year, month, 1);
              final monthLabel = "${_getMonthName(month)} $year";

              return Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: CalendarMonth(
                  month: monthLabel,
                  startDay: startDay,
                  selectedStartDate: selectedStartDate,
                  selectedEndDate: selectedEndDate,
                  onDateTap: handleDateTap,
                  isUnavailable: isDateUnavailable,
                  isRangeSelection: isAccommodation,
                ),
              );
            }),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Back"),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: canProceed
                    ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BookingPage(
                        productId: widget.productId,
                        productName: widget.productName,
                        productType: widget.productType,
                        productImage: widget.productImage,
                        price: widget.price,
                        selectedStartDate: selectedStartDate!,
                        selectedEndDate: selectedEndDate,
                        userEmail: FirebaseAuth.instance.currentUser?.email ?? '',
                      ),
                    ),
                  );


                }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF085374),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Next"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _getMonthName(int month) {
  const months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];
  return months[month - 1];
}

class CalendarMonth extends StatelessWidget {
  final String month;
  final DateTime startDay;
  final DateTime? selectedStartDate;
  final DateTime? selectedEndDate;
  final Function(DateTime) onDateTap;
  final bool Function(DateTime) isUnavailable;
  final bool isRangeSelection;

  const CalendarMonth({
    super.key,
    required this.month,
    required this.startDay,
    required this.selectedStartDate,
    required this.selectedEndDate,
    required this.onDateTap,
    required this.isUnavailable,
    required this.isRangeSelection,
  });

  bool _isInRange(DateTime date) {
    if (!isRangeSelection || selectedStartDate == null || selectedEndDate == null) return false;
    return date.isAfter(selectedStartDate!) && date.isBefore(selectedEndDate!);
  }

  bool _isSelected(DateTime date) {
    return date == selectedStartDate || date == selectedEndDate;
  }

  @override
  Widget build(BuildContext context) {
    final firstDayOfMonth = DateTime(startDay.year, startDay.month, 1);
    final daysInMonth = DateUtils.getDaysInMonth(startDay.year, startDay.month);
    final weekdayOffset = firstDayOfMonth.weekday % 7;
    final totalItems = daysInMonth + weekdayOffset;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(month, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
              .map((e) => Expanded(
            child: Center(child: Text(e, style: const TextStyle(fontSize: 12, color: Colors.grey))),
          ))
              .toList(),
        ),
        const SizedBox(height: 4),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: totalItems,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            if (index < weekdayOffset) return const SizedBox();
            final day = index - weekdayOffset + 1;
            final currentDate = DateTime(startDay.year, startDay.month, day);

            final unavailable = isUnavailable(currentDate);
            final isSelected = _isSelected(currentDate);
            final isInRange = _isInRange(currentDate);

            Color backgroundColor;
            Color textColor;

            if (isSelected) {
              backgroundColor = const Color(0xFF085374);
              textColor = Colors.white;
            } else if (isInRange) {
              backgroundColor = const Color(0xFFB3E5FC);
              textColor = Colors.black;
            } else if (unavailable) {
              backgroundColor = Colors.grey.shade300;
              textColor = Colors.grey;
            } else {
              backgroundColor = Colors.transparent;
              textColor = Colors.black;
            }

            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: unavailable ? null : () => onDateTap(currentDate),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text("$day", style: TextStyle(color: textColor, fontSize: 12)),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}




