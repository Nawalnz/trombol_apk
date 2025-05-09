import 'package:flutter/material.dart';
import 'package:trombol_apk/screens/bookplace/detail_booking.dart'; // your next page

class BookingCalendar extends StatefulWidget {
  const BookingCalendar({super.key});

  @override
  State<BookingCalendar> createState() => _BookingCalendarState();
}

class _BookingCalendarState extends State<BookingCalendar> {
  DateTime? selectedDate; // <-- To temporarily store selected date

  // Simulate unavailable dates (normally fetched from database)
  final List<DateTime> unavailableDates = [
    DateTime(2025, 4, 11),
    DateTime(2025, 4, 12),
    // Future: Fetch from Firestore or other DB
    // Example pseudo-code:
    // unavailableDates = await FirebaseFirestore.instance.collection('bookings').get()
  ];

  bool isDateUnavailable(DateTime date) {
    return unavailableDates.any((d) =>
    d.year == date.year && d.month == date.month && d.day == date.day
    );
  }

  void handleDateTap(DateTime date) {
    if (date.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You cannot select a past date")),
      );
      return;
    }
    if (isDateUnavailable(date)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Booking full on selected date")),
      );
      return;
    }
    setState(() {
      selectedDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Available date",
          style: TextStyle(color: Colors.black, fontFamily: 'Poppins'),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Choose your booking",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 16),
            CalendarMonth(
              month: 'April 2025',
              startDay: DateTime(2025, 4, 1),
              selectedDate: selectedDate,
              onDateTap: handleDateTap,
              isUnavailable: isDateUnavailable,
            ),
            const SizedBox(height: 24),
            CalendarMonth(
              month: 'May 2025',
              startDay: DateTime(2025, 5, 1),
              selectedDate: selectedDate,
              onDateTap: handleDateTap,
              isUnavailable: isDateUnavailable,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Back",
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: selectedDate == null
                    ? null
                    : () {
                  // Proceed and pass the selected date
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingPage(selectedDate: selectedDate!),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF085374),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Next",
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CalendarMonth extends StatelessWidget {
  final String month;
  final DateTime startDay;
  final DateTime? selectedDate;
  final Function(DateTime) onDateTap;
  final bool Function(DateTime) isUnavailable;

  const CalendarMonth({
    super.key,
    required this.month,
    required this.startDay,
    required this.selectedDate,
    required this.onDateTap,
    required this.isUnavailable,
  });

  @override
  Widget build(BuildContext context) {
    final firstDayOfMonth = DateTime(startDay.year, startDay.month, 1);
    final daysInMonth = DateUtils.getDaysInMonth(startDay.year, startDay.month);
    final weekdayOffset = firstDayOfMonth.weekday % 7;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          month,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
              .map((e) => Expanded(
            child: Center(
              child: Text(
                e,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ))
              .toList(),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 220,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemCount: daysInMonth + weekdayOffset,
            itemBuilder: (context, index) {
              if (index < weekdayOffset) {
                return const SizedBox();
              }
              final day = index - weekdayOffset + 1;
              final currentDate = DateTime(startDay.year, startDay.month, day);

              bool isSelected = selectedDate?.year == currentDate.year &&
                  selectedDate?.month == currentDate.month &&
                  selectedDate?.day == currentDate.day;

              bool unavailable = isUnavailable(currentDate);

              return GestureDetector(
                onTap: () => onDateTap(currentDate),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF085374)
                        : unavailable
                        ? Colors.grey[300]
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      "$day",
                      style: TextStyle(
                        color: unavailable
                            ? Colors.grey
                            : isSelected
                            ? Colors.white
                            : Colors.black,
                        fontFamily: 'Poppins',
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
