import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/reminder.dart';
import '../providers/plant_provider.dart';

class RemindersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final plantProvider = Provider.of<PlantProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Reminders'), backgroundColor: Colors.green),
      body: ListView.builder(
        itemCount: plantProvider.reminders.length,
        itemBuilder: (context, index) {
          Reminder reminder = plantProvider.reminders[index];
          return ListTile(
            title: Text(reminder.title),
            subtitle: Text(
              '${reminder.description}\n${reminder.scheduledTime.toLocal()}',
            ),
            trailing: Switch(
              value: reminder.isActive,
              onChanged: (value) {
                plantProvider.updateReminder(
                  reminder.copyWith(isActive: value),
                );
              },
            ),
            onLongPress: () {
              plantProvider.deleteReminder(reminder.id!);
            },
          );
        },
      ),
    );
  }
}
