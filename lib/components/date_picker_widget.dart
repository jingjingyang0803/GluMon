import 'package:flutter/material.dart';
import 'package:glu_mon/utils/color_utils.dart';
import 'package:intl/intl.dart';

class DatePickerWidget extends StatefulWidget {
  final Function(DateTime) onDateSelected;

  const DatePickerWidget({super.key, required this.onDateSelected});

  @override
  DatePickerWidgetState createState() => DatePickerWidgetState();
}

class DatePickerWidgetState extends State<DatePickerWidget> {
  late ScrollController _scrollController;
  DateTime _selectedDate = DateTime.now();

  final List<DateTime> _dates = List.generate(
    31,
    (index) => DateTime.now().subtract(Duration(days: 30 - index)),
  );

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelected();
    });
  }

  void _onDateTap(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
    widget.onDateSelected(date);
    _scrollToSelected();
  }

  void _scrollToSelected() {
    int selectedIndex = _dates.indexWhere((date) =>
        date.year == _selectedDate.year &&
        date.month == _selectedDate.month &&
        date.day == _selectedDate.day);

    if (selectedIndex != -1) {
      double itemWidth = 60 + 12;
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

          final bool isSelected = _selectedDate.year == date.year &&
              _selectedDate.month == date.month &&
              _selectedDate.day == date.day;

          return GestureDetector(
            onTap: () => _onDateTap(date),
            child: Container(
              width: 60,
              margin: EdgeInsets.symmetric(horizontal: 6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('E').format(date)[0], // First letter of the day
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Nexa Text-Trial',
                      fontWeight: FontWeight.w400,
                      color: isSelected ? primaryBlue : primaryGrey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    DateFormat('dd').format(date),
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Nexa Text-Trial',
                      fontWeight: FontWeight.w400,
                      color: isSelected ? primaryBlue : Colors.black,
                    ),
                  ),
                  Text(
                    DateFormat('MMM').format(date),
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Nexa Text-Trial',
                      fontWeight: FontWeight.w400,
                      color: isSelected ? primaryBlue : primaryBlack,
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
