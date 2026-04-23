import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/task_model.dart';
import '../theme/app_theme.dart';
import '../utils/picker_utils.dart';
import '../widgets/task_options_card.dart';
import '../widgets/add_task_top_bar.dart';
import '../widgets/add_task_title_input.dart';

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
                AddTaskTopBar(
                  onCancel: () => Navigator.pop(context),
                  onSave: _onAdd,
                  isEditing: widget.taskToEdit != null,
                ),
                const Divider(height: 1, color: AppColors.divider),
                Expanded(
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AddTaskTitleInput(
                          controller: _titleController,
                          focusNode: _focusNode,
                        ),
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
