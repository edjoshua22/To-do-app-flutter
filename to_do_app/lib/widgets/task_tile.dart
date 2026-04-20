import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class TaskTile extends StatefulWidget {
  final Task task;
  final VoidCallback onToggle;

  const TaskTile({super.key, required this.task, required this.onToggle});

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      lowerBound: 0.0,
      upperBound: 0.1,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) => _controller.forward();
  void _onTapUp(TapUpDetails _) => _controller.reverse();
  void _onTapCancel() => _controller.reverse();

  @override
  Widget build(BuildContext context) {
    final task = widget.task;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onToggle,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Circular Checkbox
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: task.isCompleted ? AppColors.accent : Colors.transparent,
                  border: task.isCompleted
                      ? null
                      : Border.all(color: AppColors.border, width: 1.8),
                ),
                child: task.isCompleted
                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 16),

              // Title + Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 250),
                      style: GoogleFonts.inter(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                        color: task.isCompleted
                            ? AppColors.secondary
                            : AppColors.primary,
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        decorationColor: AppColors.secondary,
                      ),
                      child: Text(task.title),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      task.subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

              // Right Icons / Edit
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (task.hasAlarm)
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: Icon(
                        Icons.notifications_none_rounded,
                        size: 15,
                        color: AppColors.secondary.withValues(alpha: 0.6),
                      ),
                    ),
                  if (task.hasPriority)
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: Icon(
                        Icons.bar_chart_rounded,
                        size: 15,
                        color: AppColors.accent,
                      ),
                    ),
                  if (!task.isCompleted)
                    Text(
                      'Edit',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
