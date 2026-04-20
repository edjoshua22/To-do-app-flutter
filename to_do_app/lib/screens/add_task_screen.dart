import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/task_model.dart';
import '../theme/app_theme.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _titleController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  String _alarm = 'None';
  String _reminder = '10:00 am';
  String _priority = 'Low';

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _focusNode.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _onAdd() {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      _focusNode.requestFocus();
      return;
    }

    final newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      subtitle: _reminder != 'None' ? _reminder : '',
      isCompleted: false,
      hasAlarm: _alarm != 'None',
      hasPriority: _priority != 'Low',
    );

    Navigator.pop(context, newTask);
  }

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

  Widget _buildDivider() => Divider(
        height: 1,
        thickness: 1,
        indent: 24,
        endIndent: 24,
        color: AppColors.divider,
      );

  void _showPriorityPicker() {
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
                  fontWeight:
                      _priority == p ? FontWeight.w700 : FontWeight.w400,
                  color: _priority == p ? AppColors.primary : AppColors.secondary,
                ),
              ),
              trailing: _priority == p
                  ? const Icon(Icons.check, color: AppColors.accent)
                  : null,
              onTap: () {
                setState(() => _priority = p);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showAlarmPicker() {
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
          children: ['None', '8:00 am', '9:00 am', '10:00 am', '12:00 pm', '3:00 pm'].map((a) {
            return ListTile(
              title: Text(
                a,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: _alarm == a ? FontWeight.w700 : FontWeight.w400,
                  color: _alarm == a ? AppColors.primary : AppColors.secondary,
                ),
              ),
              trailing: _alarm == a
                  ? const Icon(Icons.check, color: AppColors.accent)
                  : null,
              onTap: () {
                setState(() => _alarm = a);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showReminderPicker() {
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
          children: ['None', '5 min before', '10:00 am', '30 min before', '1 hour before'].map((r) {
            return ListTile(
              title: Text(
                r,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: _reminder == r ? FontWeight.w700 : FontWeight.w400,
                  color: _reminder == r ? AppColors.primary : AppColors.secondary,
                ),
              ),
              trailing: _reminder == r
                  ? const Icon(Icons.check, color: AppColors.accent)
                  : null,
              onTap: () {
                setState(() => _reminder = r);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppColors.background,
        resizeToAvoidBottomInset: true,
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Top Bar ──────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
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
                        onTap: _onAdd,
                        child: Text(
                          'Add task',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Divider ───────────────────────────────────────────────
                Divider(height: 1, color: AppColors.divider),

                // ── Body ──────────────────────────────────────────────────
                Expanded(
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Task title input
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                          child: TextField(
                            controller: _titleController,
                            focusNode: _focusNode,
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
                        ),

                        const SizedBox(height: 32),
                        Divider(height: 1, color: AppColors.divider),

                        // ── Options ──────────────────────────────────────
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
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
                                value: _alarm,
                                onTap: _showAlarmPicker,
                              ),
                              _buildDivider(),
                              _buildOptionRow(
                                label: 'Reminder',
                                value: _reminder,
                                onTap: _showReminderPicker,
                              ),
                              _buildDivider(),
                              _buildOptionRow(
                                label: 'Priority',
                                value: _priority,
                                onTap: _showPriorityPicker,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
