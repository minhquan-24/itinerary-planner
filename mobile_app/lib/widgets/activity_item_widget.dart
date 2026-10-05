import 'package:flutter/material.dart';
import '../models/trip_model.dart';

class ActivityItemWidget extends StatelessWidget {
  final Activity activity;
  final ValueChanged<bool?> onToggle;

  const ActivityItemWidget({
    super.key,
    required this.activity,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: activity.isCompleted
          ? Colors.teal.shade50
          : Colors.grey.shade100,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: activity.isCompleted
              ? Colors.teal.shade200
              : Colors.grey.shade300,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: Checkbox(
          value: activity.isCompleted,
          activeColor: Colors.teal,
          onChanged: onToggle,
        ),
        title: Text(
          activity.title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            decoration: activity.isCompleted
                ? TextDecoration.lineThrough
                : TextDecoration.none,
            color: activity.isCompleted ? Colors.grey.shade600 : Colors.black87,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.access_time_rounded,
                  size: 14,
                  color: Colors.teal.shade700,
                ),
                const SizedBox(width: 4),
                Text(
                  activity.time,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal.shade800,
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  Icons.place_outlined,
                  size: 14,
                  color: Colors.grey.shade700,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    activity.location,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
