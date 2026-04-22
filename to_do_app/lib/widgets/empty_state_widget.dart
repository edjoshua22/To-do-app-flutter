import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.task_rounded,
            size: 48,
            color: AppColors.secondary.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            textAlign: TextAlign.center,
            'Clear day ahead!\nTap + to add a task.',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.secondary,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
