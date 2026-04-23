import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class AddTaskTitleInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;

  const AddTaskTitleInput({
    super.key,
    required this.controller,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        maxLines: null,
        style: GoogleFonts.inter(
          fontSize: 26,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
        decoration: InputDecoration(
          hintText: 'Write your task',
          hintStyle: GoogleFonts.inter(
            fontSize: 26,
            fontWeight: FontWeight.w400,
            color: AppColors.secondary.withValues(alpha: 0.45),
          ),
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
        cursorColor: AppColors.accent,
        cursorWidth: 2.5,
      ),
    );
  }
}
