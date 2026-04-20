import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class WeekDaySelector extends StatelessWidget {
  final int selectedDay;
  final List<Map<String, dynamic>> days;

  const WeekDaySelector({
    super.key,
    required this.selectedDay,
    required this.days,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: days.map((d) {
        final isSelected = d['date'] == selectedDay;
        return _DayItem(
          label: d['label'] as String,
          date: d['date'] as int,
          isSelected: isSelected,
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
