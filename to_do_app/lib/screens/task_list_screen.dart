import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/task_model.dart';
import '../services/task_service.dart';
import '../theme/app_theme.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/task_list_header.dart';
import '../widgets/dismissible_task_tile.dart';
import 'add_task_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TaskService _taskService = TaskService();
  List<Task> _tasks = [];
  bool _isLoading = true;
  String? _errorMessage;

  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final fetchedTasks = await _taskService.getTasks();
      if (mounted) {
        setState(() {
          _tasks = fetchedTasks;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load tasks: $e';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.primary,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _toggleTask(Task task) async {
    final originalState = task.isCompleted;
    setState(() {
      task.isCompleted = !task.isCompleted;
    });

    try {
      await _taskService.updateTask(task);
    } catch (e) {
      if (mounted) {
        setState(() {
          task.isCompleted = originalState;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to update task')));
      }
    }
  }

  Future<void> _handleDelete(Task task) async {
    final index = _tasks.indexOf(task);
    if (index == -1) return;

    setState(() {
      _tasks.removeAt(index);
    });

    try {
      await _taskService.deleteTask(task.id);
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Task deleted'),
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () async {
                setState(() {
                  if (index > _tasks.length) {
                    _tasks.add(task);
                  } else {
                    _tasks.insert(index, task);
                  }
                });
                await _taskService.addTask(task);
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _tasks.insert(index, task);
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to delete task')));
      }
    }
  }

  Future<void> _openAddTask({Task? taskToEdit}) async {
    final result = await Navigator.push<Task>(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            AddTaskScreen(taskToEdit: taskToEdit, selectedDate: _selectedDate),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final slide =
              Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              );
          return SlideTransition(position: slide, child: child);
        },
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );

    if (result != null) {
      try {
        if (taskToEdit != null) {
          final updated = await _taskService.updateTask(result);
          if (mounted) {
            final idx = _tasks.indexWhere((t) => t.id == taskToEdit.id);
            if (idx != -1) setState(() => _tasks[idx] = updated);
          }
        } else {
          final created = await _taskService.addTask(result);
          if (mounted) setState(() => _tasks.insert(0, created));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Failed to save task')));
        }
      }
    }
  }

  List<Task> get _filteredTasks {
    return _tasks.where((t) {
      return t.date.year == _selectedDate.year &&
          t.date.month == _selectedDate.month &&
          t.date.day == _selectedDate.day;
    }).toList();
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.accent),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _errorMessage!,
              style: GoogleFonts.inter(color: Colors.redAccent),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _loadTasks, child: const Text('Retry')),
          ],
        ),
      );
    }

    final currentTasks = _filteredTasks;

    if (currentTasks.isEmpty) {
      return const EmptyStateWidget();
    }

    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: currentTasks.length,
      separatorBuilder: (context, index) => const Divider(
        height: 1,
        thickness: 1,
        indent: 20,
        endIndent: 20,
        color: AppColors.divider,
      ),
      itemBuilder: (context, i) {
        final task = currentTasks[i];
        return DismissibleTaskTile(
          task: task,
          onToggle: () => _toggleTask(task),
          onEdit: () => _openAddTask(taskToEdit: task),
          onDelete: () => _handleDelete(task),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentTasks = _filteredTasks;
    final completedCount = currentTasks.where((t) => t.isCompleted).length;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TaskListHeader(
                selectedDate: _selectedDate,
                completedCount: completedCount,
                totalCount: currentTasks.length,
                onCalendarTap: () => _selectDate(context),
                onDateSelected: (date) {
                  setState(() {
                    _selectedDate = date;
                  });
                },
              ),
              const SizedBox(height: 18),
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
                    child: _buildBody(),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
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
