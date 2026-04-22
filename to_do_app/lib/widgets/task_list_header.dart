import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../utils/date_formatter.dart';
import 'week_day_selector.dart';

class TaskListHeader extends StatelessWidget {
  final DateTime selectedDate;
  final int completedCount;
  final int totalCount;
  final VoidCallback onCalendarTap;
  final ValueChanged<DateTime> onDateSelected;

  const TaskListHeader({
    super.key,
    required this.selectedDate,
    required this.completedCount,
    required this.totalCount,
    required this.onCalendarTap,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormatter.formatHeaderDate(selectedDate),
                    style: GoogleFonts.inter(
                      fontSize: 10.5,
                      letterSpacing: 1.2,
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'To-Do List',
                    style: GoogleFonts.inter(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: GestureDetector(
                  onTap: onCalendarTap,
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.calendar_today_outlined,
                      size: 18,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),
          Text(
            '$completedCount of $totalCount tasks completed',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.secondary,
              fontWeight: FontWeight.w400,
            ),
          ),

          const SizedBox(height: 20),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: totalCount == 0 ? 0 : completedCount / totalCount,
              backgroundColor: AppColors.divider,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
              minHeight: 4,
            ),
          ),

          const SizedBox(height: 22),

          // Week Day Selector
          WeekDaySelector(
            selectedDate: selectedDate,
            onDateSelected: onDateSelected,
          ),
        ],
      ),
    );
  }
}
