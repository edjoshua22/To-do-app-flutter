import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/task_model.dart';
import '../theme/app_theme.dart';

class AddTaskScreen extends StatefulWidget {
  final Task? taskToEdit;
  final DateTime selectedDate;
  const AddTaskScreen({super.key, this.taskToEdit, required this.selectedDate});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _titleController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  String _alarm = 'None';
  String _reminder = 'None';
  String _priority = 'Low';

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    if (widget.taskToEdit != null) {
      final t = widget.taskToEdit!;
      _titleController.text = t.title;
      _reminder = t.subtitle.isNotEmpty ? t.subtitle : 'None';
      _alarm = t.hasAlarm ? '10:00 am' : 'None';
      _priority = t.hasPriority ? 'High' : 'Low';
    }
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
      id: widget.taskToEdit?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      subtitle: _reminder != 'None' ? _reminder : '',
      date: widget.taskToEdit?.date ?? widget.selectedDate,
      isCompleted: widget.taskToEdit?.isCompleted ?? false,
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

  Widget _buildDivider() => const Divider(
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

  Future<void> _showAlarmPicker() async {
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
                  fontWeight: _alarm == 'None' ? FontWeight.w700 : FontWeight.w400,
                  color: _alarm == 'None' ? AppColors.primary : AppColors.secondary,
                ),
              ),
              trailing: _alarm == 'None'
                  ? const Icon(Icons.check, color: AppColors.accent)
                  : null,
              onTap: () {
                setState(() => _alarm = 'None');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                'Pick a Time...',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: _alarm != 'None' ? FontWeight.w700 : FontWeight.w400,
                  color: _alarm != 'None' ? AppColors.primary : AppColors.secondary,
                ),
              ),
              trailing: _alarm != 'None'
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
                  setState(() {
                    _alarm = picked.format(context);
                  });
                }
              },
            ),
          ],
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
          children: ['None', '5 min before', '30 min before', '1 hour before'].map((r) {
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

  Widget _buildTopBar() {
    return Padding(
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
              widget.taskToEdit == null ? 'Add task' : 'Save task',
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

  Widget _buildTitleInput() {
    return Padding(
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
    );
  }

  Widget _buildOptionsCard() {
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
                _buildTopBar(),
                const Divider(height: 1, color: AppColors.divider),
                Expanded(
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTitleInput(),
                        const SizedBox(height: 32),
                        const Divider(height: 1, color: AppColors.divider),
                        _buildOptionsCard(),
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
