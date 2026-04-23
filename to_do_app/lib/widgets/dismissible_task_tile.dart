import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../utils/dialog_utils.dart';
import 'task_tile.dart';

class DismissibleTaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const DismissibleTaskTile({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        color: Colors.redAccent,
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
      ),
      confirmDismiss: (direction) async {
        return await DialogUtils.showDeleteConfirmation(context);
      },
      onDismissed: (direction) {
        onDelete();
      },
      child: TaskTile(
        task: task,
        onToggle: onToggle,
        onEdit: onEdit,
      ),
    );
  }
}
