import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../providers/hydration_provider.dart';
import '../constants/theme.dart';
import '../services/notification_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(context, 'Daily Water Goal', [
            Consumer<HydrationProvider>(
              builder: (context, hydration, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Target: ${hydration.formattedTargetIntake}ml',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Slider(
                      value: hydration.targetIntake,
                      min: 1000,
                      max: 5000,
                      divisions: 40,
                      label: '${hydration.targetIntake.toStringAsFixed(0)}ml',
                      onChanged: (value) => hydration.setTargetIntake(value),
                    ),
                  ],
                );
              },
            ),
          ]),
          const SizedBox(height: 24),
          _buildSection(context, 'Reminder Settings', [
            Consumer<SettingsProvider>(
              builder: (context, settings, child) {
                return Column(
                  children: [
                    SwitchListTile(
                      title: const Text('Enable Reminders'),
                      value: settings.notificationsEnabled,
                      onChanged: settings.setNotificationsEnabled,
                    ),
                    if (settings.notificationsEnabled) ...[
                      const SizedBox(height: 16),
                      ListTile(
                        title: const Text('Reminder Frequency'),
                        subtitle: Text(
                          'Every ${settings.frequencyMinutes} minutes',
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => _showFrequencyPicker(context, settings),
                      ),
                      ListTile(
                        title: const Text('Start Time'),
                        subtitle: Text(settings.startTime),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => _showTimePicker(
                          context,
                          settings.startTime,
                          (time) => settings.setStartTime(time),
                        ),
                      ),
                      ListTile(
                        title: const Text('End Time'),
                        subtitle: Text(settings.endTime),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => _showTimePicker(
                          context,
                          settings.endTime,
                          (time) => settings.setEndTime(time),
                        ),
                      ),
                      ListTile(
                        title: const Text('Sound'),
                        trailing: Switch(
                          value: settings.soundEnabled,
                          onChanged: (value) => settings.setSoundEnabled(value),
                        ),
                      ),
                      ListTile(
                        title: const Text('Vibration'),
                        trailing: Switch(
                          value: settings.vibrationEnabled,
                          onChanged: (value) =>
                              settings.setVibrationEnabled(value),
                        ),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.notifications_active),
                        title: const Text('Test Notification'),
                        subtitle: const Text(
                            'Send a test notification with snooze options'),
                        onTap: () {
                          final notificationService = NotificationService();
                          notificationService.showTestNotification();
                        },
                      ),
                    ],
                  ],
                );
              },
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.primaryBlue,
              ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showFrequencyPicker(
    BuildContext context,
    SettingsProvider settings,
  ) async {
    final frequencies = [30, 45, 60, 90, 120];
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reminder Frequency'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: frequencies
              .map(
                (minutes) => ListTile(
                  title: Text('Every $minutes minutes'),
                  onTap: () {
                    settings.setFrequencyMinutes(minutes);
                    Navigator.pop(context);
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Future<void> _showTimePicker(
    BuildContext context,
    String currentTime,
    Function(String) onTimeSelected,
  ) async {
    final parts = currentTime.split(':');
    final initialTime = TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );

    final time = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (time != null) {
      final formattedTime =
          '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
      onTimeSelected(formattedTime);
    }
  }
}
