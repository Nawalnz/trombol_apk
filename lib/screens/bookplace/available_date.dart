import 'package:flutter/material.dart';
import 'package:trombol_apk/screens/bookplace/detail_booking.dart';
import 'package:trombol_apk/screens/bookplace/payment.dart';

class BookingCalendar extends StatefulWidget {
  const BookingCalendar({super.key});

  @override
  State<BookingCalendar> createState() => _BookingCalendarState();
}

class _BookingCalendarState extends State<BookingCalendar> {
  DateTime? selectedDate;

  final List<DateTime> unavailableDates = [
    DateTime(2025, 4, 11),
    DateTime(2025, 4, 12),
  ];

  bool isDateUnavailable(DateTime date) {
    return unavailableDates.any((d) =>
    d.year == date.year &&
        d.month == date.month &&
        d.day == date.day);
  }

  void handleDateTap(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (date.isBefore(today)) {
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
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
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
            ...List.generate(36, (index) {
              final now = DateTime.now();
              final year = now.year + ((now.month + index - 1) ~/ 12);
              final month = (now.month + index - 1) % 12 + 1;
              final startDay = DateTime(year, month, 1);
              final monthLabel = "${_getMonthName(month)} $year";

              return Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: CalendarMonth(
                  month: monthLabel,
                  startDay: startDay,
                  selectedDate: selectedDate,
                  onDateTap: handleDateTap,
                  isUnavailable: isDateUnavailable,
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Back", style: TextStyle(fontFamily: 'Poppins')),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: selectedDate == null
                    ? null
                    : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PaymentPage(selectedDate: selectedDate!),
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
                child: const Text("Next", style: TextStyle(fontFamily: 'Poppins')),
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

    final totalItems = daysInMonth + weekdayOffset;

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
        const SizedBox(height: 4),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: totalItems,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
            childAspectRatio: 1, // 👈 This makes cells square
          ),
          itemBuilder: (context, index) {
            if (index < weekdayOffset) return const SizedBox();
            final day = index - weekdayOffset + 1;
            final currentDate =
            DateTime(startDay.year, startDay.month, day);

            final isSelected = selectedDate?.year == currentDate.year &&
                selectedDate?.month == currentDate.month &&
                selectedDate?.day == currentDate.day;

            final unavailable = isUnavailable(currentDate);

            final isDark = Theme.of(context).brightness == Brightness.dark;

            Color backgroundColor;
            Color textColor;

            if (isSelected) {
              backgroundColor = const Color(0xFF085374); // your selected color
              textColor = Colors.white;
            } else if (unavailable) {
              backgroundColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;
              textColor = Colors.grey;
            } else {
              backgroundColor = Colors.transparent;
              textColor = isDark ? Colors.white : Colors.black;
            }

            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => onDateTap(currentDate),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      "$day",
                      style: TextStyle(
                        color: textColor,
                        fontFamily: 'Poppins',
                        fontSize: 12,
                      ),
                    ),
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
