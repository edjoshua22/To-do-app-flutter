import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class PickerUtils {
  static void showPriorityPicker(BuildContext context, String currentPriority, ValueChanged<String> onChanged) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['Low', 'Medium', 'High'].map((p) {
            return ListTile(
              title: Text(
                p,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: currentPriority == p ? FontWeight.w700 : FontWeight.w400,
                  color: currentPriority == p ? AppColors.primary : AppColors.secondary,
                ),
              ),
              trailing: currentPriority == p
                  ? const Icon(Icons.check, color: AppColors.accent)
                  : null,
              onTap: () {
                onChanged(p);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  static Future<void> showAlarmPicker(BuildContext context, String currentAlarm, ValueChanged<String> onChanged) async {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(
                'None',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: currentAlarm == 'None' ? FontWeight.w700 : FontWeight.w400,
                  color: currentAlarm == 'None' ? AppColors.primary : AppColors.secondary,
                ),
              ),
              trailing: currentAlarm == 'None'
                  ? const Icon(Icons.check, color: AppColors.accent)
                  : null,
              onTap: () {
                onChanged('None');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                'Pick a Time...',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: currentAlarm != 'None' ? FontWeight.w700 : FontWeight.w400,
                  color: currentAlarm != 'None' ? AppColors.primary : AppColors.secondary,
                ),
              ),
              trailing: currentAlarm != 'None'
                  ? const Icon(Icons.check, color: AppColors.accent)
                  : null,
              onTap: () async {
                Navigator.pop(context);
                final TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.light(
                          primary: AppColors.primary,
                          onPrimary: Colors.white,
                          onSurface: AppColors.primary,
                        ),
                        textButtonTheme: TextButtonThemeData(
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.primary,
                          ),
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (picked != null) {
                  if (!context.mounted) return;
                  onChanged(picked.format(context));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  static void showReminderPicker(BuildContext context, String currentReminder, ValueChanged<String> onChanged) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['None', '5 min before', '30 min before', '1 hour before'].map((r) {
            return ListTile(
              title: Text(
                r,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: currentReminder == r ? FontWeight.w700 : FontWeight.w400,
                  color: currentReminder == r ? AppColors.primary : AppColors.secondary,
                ),
              ),
              trailing: currentReminder == r
                  ? const Icon(Icons.check, color: AppColors.accent)
                  : null,
              onTap: () {
                onChanged(r);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
