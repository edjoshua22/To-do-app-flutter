import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class WeekDaySelector extends StatefulWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const WeekDaySelector({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  State<WeekDaySelector> createState() => _WeekDaySelectorState();
}

class _WeekDaySelectorState extends State<WeekDaySelector> {
  late PageController _pageController;
  late DateTime _referenceMonday;
  static const int _initialPage = 10000;

  static const List<String> _shortWeekdays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _initialPage);
    _referenceMonday = _getMonday(widget.selectedDate);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  DateTime _getMonday(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  @override
  void didUpdateWidget(WeekDaySelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Check if the external selectedDate changed to a different week
    final currentMonday = _getMonday(oldWidget.selectedDate);
    final newMonday = _getMonday(widget.selectedDate);
    
    if (currentMonday != newMonday) {
      final int weeksDiff = newMonday.difference(_referenceMonday).inDays ~/ 7;
      final targetPage = _initialPage + weeksDiff;
      
      if (_pageController.hasClients && _pageController.page?.round() != targetPage) {
        _pageController.animateToPage(
          targetPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  List<DateTime> _getWeekForPage(int pageIndex) {
    final int weekOffset = pageIndex - _initialPage;
    final DateTime targetMonday = _referenceMonday.add(Duration(days: weekOffset * 7));
    return List.generate(7, (index) => targetMonday.add(Duration(days: index)));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          // Optional: we can automatically select a day when swiping to a new week
          // But usually swiping just changes the view. 
        },
        itemBuilder: (context, pageIndex) {
          final weekDates = _getWeekForPage(pageIndex);
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: weekDates.map((date) {
              final isSelected = date.year == widget.selectedDate.year &&
                  date.month == widget.selectedDate.month &&
                  date.day == widget.selectedDate.day;
              return GestureDetector(
                onTap: () => widget.onDateSelected(date),
                behavior: HitTestBehavior.opaque,
                child: _DayItem(
                  label: _shortWeekdays[date.weekday - 1],
                  date: date.day,
                  isSelected: isSelected,
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class _DayItem extends StatelessWidget {
  final String label;
  final int date;
  final bool isSelected;

  const _DayItem({
    required this.label,
    required this.date,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            color: isSelected ? AppColors.primary : AppColors.secondary,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$date',
          style: GoogleFonts.inter(
            fontSize: 13,
            color: isSelected ? AppColors.primary : AppColors.secondary,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
        const SizedBox(height: 5),
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          height: 2.5,
          width: isSelected ? 16 : 0,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }
}
