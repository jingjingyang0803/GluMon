import 'package:flutter/material.dart';
import 'package:glu_mon/utils/color_utils.dart';
import 'package:intl/intl.dart';

class DatePickerWidget extends StatefulWidget {
  final Function(DateTime) onDateSelected; // Callback function

  const DatePickerWidget({super.key, required this.onDateSelected});

  @override
  DatePickerWidgetState createState() => DatePickerWidgetState();
}

class DatePickerWidgetState extends State<DatePickerWidget> {
  DateTime _selectedDate = DateTime.now(); // ✅ Set today as default

  // ✅ Generate dates: 4 days before today + today
  final List<DateTime> _dates = List.generate(
    5,
    (index) => DateTime.now()
        .subtract(Duration(days: 4 - index)), // Includes past and future dates
  );

  void _onDateTap(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
    widget.onDateSelected(date); // Notify parent widget
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _dates.length,
        itemBuilder: (context, index) {
          final date = _dates[index];

          // ✅ Ensure today is selected by default
          final isSelected = _selectedDate.year == date.year &&
              _selectedDate.month == date.month &&
              _selectedDate.day == date.day;

          return GestureDetector(
            onTap: () => _onDateTap(date),
            child: Container(
              width: 60,
              margin: EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: isSelected ? primaryBlue : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border:
                    Border.all(color: isSelected ? primaryBlue : Colors.grey),
              ),
              padding: EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('EEE').format(date), // Mon, Tue...
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    DateFormat('dd').format(date), // 01, 02...
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
