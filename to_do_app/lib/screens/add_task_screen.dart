import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/task_model.dart';
import '../theme/app_theme.dart';
import '../utils/picker_utils.dart';
import '../widgets/task_options_card.dart';

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
                        TaskOptionsCard(
                          alarm: _alarm,
                          reminder: _reminder,
                          priority: _priority,
                          onAlarmTap: () => PickerUtils.showAlarmPicker(
                            context,
                            _alarm,
                            (val) => setState(() => _alarm = val),
                          ),
                          onReminderTap: () => PickerUtils.showReminderPicker(
                            context,
                            _reminder,
                            (val) => setState(() => _reminder = val),
                          ),
                          onPriorityTap: () => PickerUtils.showPriorityPicker(
                            context,
                            _priority,
                            (val) => setState(() => _priority = val),
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
