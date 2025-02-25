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
      height: 100, // Ensures enough space for the layout
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
            child: SizedBox(
              width: 56, // Ensures equal width for all dates
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // **Weekday Letter (Always Visible)**
                  Container(
                    width: 22,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: ShapeDecoration(
                      color: isSelected ? primaryOrange : Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: Text(
                      DateFormat('E')
                          .format(date)[0], // First letter of the day
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        color: isSelected ? Colors.white : primaryGrey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // **Date Display (Always Visible, Changes Style Based on `isSelected`)**
                  Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      // **Blue Oval Glow (Only Visible When Selected)**
                      Container(
                        width: 30,
                        height: 45,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Color(0xFFDEECFE)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),

                      // **White Floating Circle for Selected Date / Normal Date for Others**
                      Positioned(
                        top: isSelected
                            ? 3
                            : 0, // ✅ Move selected date down slightly for effect
                        child: Container(
                          width: 25,
                          height: 28,
                          decoration: BoxDecoration(
                            color:
                                isSelected ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(
                                16), // ✅ Oval shape instead of a perfect circle
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: Color(0x19000000),
                                      blurRadius: 13,
                                      offset: Offset(0, 4),
                                    ),
                                  ]
                                : [],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            DateFormat('dd').format(date),
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              color: isSelected ? primaryBlack : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
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
