import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class AddTaskTopBar extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onSave;
  final bool isEditing;

  const AddTaskTopBar({
    super.key,
    required this.onCancel,
    required this.onSave,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: onCancel,
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(
                fontSize: 15,
                color: AppColors.secondary,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          GestureDetector(
            onTap: onSave,
            child: Text(
              isEditing ? 'Save task' : 'Add task',
              style: GoogleFonts.inter(
                fontSize: 15,
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
