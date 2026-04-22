import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class WeekDaySelector extends StatelessWidget {
  final DateTime selectedDate;
  final List<DateTime> currentWeek;
  final ValueChanged<DateTime> onDateSelected;

  const WeekDaySelector({
    super.key,
    required this.selectedDate,
    required this.currentWeek,
    required this.onDateSelected,
  });

  static const List<String> _shortWeekdays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: currentWeek.map((date) {
        final isSelected = date.year == selectedDate.year &&
            date.month == selectedDate.month &&
            date.day == selectedDate.day;
        return GestureDetector(
          onTap: () => onDateSelected(date),
          behavior: HitTestBehavior.opaque,
          child: _DayItem(
            label: _shortWeekdays[date.weekday - 1],
            date: date.day,
            isSelected: isSelected,
          ),
        );
      }).toList(),
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
