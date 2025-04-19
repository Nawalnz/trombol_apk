import 'package:flutter/material.dart';
import 'package:mobcom/screens/detail_booking.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BookingCalendar(),
    ),
  );
}

class BookingCalendar extends StatelessWidget {
  const BookingCalendar({super.key});

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
            // First Month
            CalendarMonth(
              month: 'April 2025',
              startDay: DateTime(2025, 4, 1),
              selectedDays: const [11, 12, 13, 14, 15],
            ),
            const SizedBox(height: 24),
            // Second Month (Changed from June to May!)
            CalendarMonth(
              month: 'May 2025',
              startDay: DateTime(2025, 5, 1),
              selectedDays: const [],
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BookingPage()),
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
  final List<int> selectedDays;

  const CalendarMonth({
    super.key,
    required this.month,
    required this.startDay,
    this.selectedDays = const [],
  });

  @override
  Widget build(BuildContext context) {
    final firstDayOfMonth = DateTime(startDay.year, startDay.month, 1);
    final daysInMonth = DateUtils.getDaysInMonth(startDay.year, startDay.month);
    final weekdayOffset = firstDayOfMonth.weekday % 7; // Sunday = 0

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
          children:
          ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
              .map<Widget>(
                (e) => Expanded(
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
            ),
          )
              .toList(),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 200, // Provide a fixed height for the GridView
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
                return const SizedBox(); // Empty space before 1st day
              }
              final day = index - weekdayOffset + 1;
              final isSelected = selectedDays.contains(day);

              return Container(
                decoration: BoxDecoration(
                  color:
                  isSelected ? const Color(0xFF085374) : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    "$day",
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontFamily: 'Poppins',
                      fontSize: 12,
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
