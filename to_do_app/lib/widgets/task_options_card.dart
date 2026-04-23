import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class TaskOptionsCard extends StatelessWidget {
  final String alarm;
  final String reminder;
  final String priority;
  final VoidCallback onAlarmTap;
  final VoidCallback onReminderTap;
  final VoidCallback onPriorityTap;

  const TaskOptionsCard({
    super.key,
    required this.alarm,
    required this.reminder,
    required this.priority,
    required this.onAlarmTap,
    required this.onReminderTap,
    required this.onPriorityTap,
  });

  Widget _buildOptionRow({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        child: Row(
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            const Spacer(),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.secondary,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: AppColors.secondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() => const Divider(
        height: 1,
        thickness: 1,
        indent: 24,
        endIndent: 24,
        color: AppColors.divider,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildOptionRow(
            label: 'Alarm',
            value: alarm,
            onTap: onAlarmTap,
          ),
          _buildDivider(),
          _buildOptionRow(
            label: 'Reminder',
            value: reminder,
            onTap: onReminderTap,
          ),
          _buildDivider(),
          _buildOptionRow(
            label: 'Priority',
            value: priority,
            onTap: onPriorityTap,
          ),
        ],
      ),
    );
  }
}
