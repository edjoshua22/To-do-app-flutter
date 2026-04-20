import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/task_model.dart';
import '../theme/app_theme.dart';
import '../widgets/task_tile.dart';
import '../widgets/week_day_selector.dart';
import 'add_task_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> tasks = List.from(sampleTasks);

  final List<Map<String, dynamic>> weekDays = [
    {'label': 'S', 'date': 7},
    {'label': 'M', 'date': 8},
    {'label': 'T', 'date': 9},
    {'label': 'W', 'date': 10},
    {'label': 'T', 'date': 11},
    {'label': 'F', 'date': 12},
    {'label': 'S', 'date': 13},
  ];

  void _toggleTask(String id) {
    setState(() {
      final idx = tasks.indexWhere((t) => t.id == id);
      if (idx != -1) tasks[idx].isCompleted = !tasks[idx].isCompleted;
    });
  }

  Future<void> _openAddTask() async {
    final result = await Navigator.push<Task>(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const AddTaskScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final slide = Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
          return SlideTransition(position: slide, child: child);
        },
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );

    if (result != null) {
      setState(() => tasks.insert(0, result));
    }
  }

  @override
  Widget build(BuildContext context) {
    final completedCount = tasks.where((t) => t.isCompleted).length;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'FRIDAY, OCT 12',
                              style: GoogleFonts.inter(
                                fontSize: 10.5,
                                letterSpacing: 1.2,
                                color: AppColors.secondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'To-Do List',
                              style: GoogleFonts.inter(
                                fontSize: 30,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                                height: 1.1,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: AppColors.card,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.06),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.calendar_today_outlined,
                              size: 18,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),
                    Text(
                      '$completedCount of ${tasks.length} tasks completed',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Progress bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: tasks.isEmpty ? 0 : completedCount / tasks.length,
                        backgroundColor: AppColors.divider,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
                        minHeight: 4,
                      ),
                    ),

                    const SizedBox(height: 22),

                    // Week Day Selector
                    WeekDaySelector(selectedDay: 12, days: weekDays),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // ── Task List ────────────────────────────────────────────────
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: tasks.isEmpty
                        ? Center(
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
                          )
                        : ListView.separated(
                            padding: EdgeInsets.zero,
                            itemCount: tasks.length,
                            separatorBuilder: (context, index) => const Divider(
                              height: 1,
                              thickness: 1,
                              indent: 20,
                              endIndent: 20,
                              color: AppColors.divider,
                            ),
                            itemBuilder: (context, i) => TaskTile(
                              task: tasks[i],
                              onToggle: () => _toggleTask(tasks[i].id),
                            ),
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),

        // ── FAB ──────────────────────────────────────────────────────────
        floatingActionButton: GestureDetector(
          onTap: _openAddTask,
          child: Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(Icons.add, color: Colors.white, size: 26),
          ),
        ),
      ),
    );
  }
}
