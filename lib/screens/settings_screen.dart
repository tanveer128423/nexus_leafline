import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications') ?? true;
    });
  }

  Future<void> _saveSetting(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Settings'), backgroundColor: Colors.green),
      body: ListView(
        children: [
          ListTile(
            title: Text('Dark Mode'),
            subtitle: Text('Toggle dark theme'),
            trailing: Switch(
              value: themeProvider.isDarkMode,
              onChanged: (value) {
                themeProvider.toggleTheme();
              },
            ),
          ),
          ListTile(
            title: Text('Notifications'),
            subtitle: Text('Enable plant care reminders'),
            trailing: Switch(
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                });
                _saveSetting('notifications', value);
              },
            ),
          ),
          Divider(),
          ListTile(
            title: Text('About'),
            subtitle: Text('App version and information'),
            onTap: () => _showAboutDialog(context),
          ),
          ListTile(
            title: Text('Help & Support'),
            subtitle: Text('Get help with the app'),
            onTap: () => _showHelpDialog(context),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('About Nexus Leafline'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Version: 1.0.0'),
            SizedBox(height: 8),
            Text(
              'A comprehensive plant care guidance app for nurseries and plant enthusiasts.',
            ),
            SizedBox(height: 8),
            Text('Features:'),
            Text('• Plant care instructions'),
            Text('• Care reminders'),
            Text('• Plant search and favorites'),
            Text('• Category browsing'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Help & Support'),
        content: Text(
          '• Browse plants by category or search\n'
          '• Tap on plants for detailed care instructions\n'
          '• Set reminders for watering and care\n'
          '• Add plants to favorites for quick access\n'
          '• Enable notifications for timely reminders\n\n'
          'For more help, contact support@nexusleafline.com',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}
