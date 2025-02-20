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
  late ScrollController _scrollController;
  DateTime _selectedDate = DateTime.now(); // ✅ Default to today

  // ✅ Generate dates: 30 days before today + today
  final List<DateTime> _dates = List.generate(
    31,
    (index) => DateTime.now().subtract(Duration(days: 30 - index)),
  );

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    // Move selected date to center after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelected();
    });
  }

  void _onDateTap(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
    widget.onDateSelected(date);
    _scrollToSelected(); // Scroll when a new date is selected
  }

  void _scrollToSelected() {
    int selectedIndex = _dates.indexWhere((date) =>
        date.year == _selectedDate.year &&
        date.month == _selectedDate.month &&
        date.day == _selectedDate.day);

    if (selectedIndex != -1) {
      double itemWidth = 60 + 12; // Width + margin (horizontal padding)
      double screenWidth = MediaQuery.of(context).size.width;
      double targetScrollOffset =
          (selectedIndex * itemWidth) - (screenWidth / 2) + (itemWidth / 2);

      _scrollController.animateTo(
        targetScrollOffset.clamp(
          0.0,
          _scrollController.position.maxScrollExtent,
        ),
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: _dates.length,
        itemBuilder: (context, index) {
          final date = _dates[index];

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
                    DateFormat('E').format(date)[0], // M, T, W ...
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : primaryGrey,
                    ),
                  ),
                  Text(
                    DateFormat('dd').format(date), // 01, 02...
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                  Text(
                    DateFormat('MMM').format(date), // Jan, Feb...
                    style: TextStyle(
                      fontSize: 12,
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
