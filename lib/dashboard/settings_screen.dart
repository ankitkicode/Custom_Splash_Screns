import 'package:flutter/material.dart';

// A constant for the primary theme color.
const Color _primaryColor = Color(0xFF00BFA5);

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // State variables for the settings toggles
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.grey[800]),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Settings',
          style: TextStyle(
            color: Colors.grey[800],
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSettingsGroup(
              title: 'Preferences',
              children: [
                _buildNotificationToggle(),
                _buildDarkModeToggle(),
              ],
            ),
            const SizedBox(height: 24),
            _buildSettingsGroup(
              title: 'Account',
              children: [
                _buildMenuListItem(
                  icon: Icons.lock_outline_rounded,
                  title: 'Change Password',
                  onTap: () {},
                ),
                _buildMenuListItem(
                  icon: Icons.language_rounded,
                  title: 'Language',
                  trailing:
                      const Text('English', style: TextStyle(color: Colors.grey)),
                  onTap: () {},
                  hasBorder: false,
                ),
              ],
            ),
             const SizedBox(height: 24),
            _buildSettingsGroup(
              title: 'Support',
              children: [
                 _buildMenuListItem(
                  icon: Icons.info_outline_rounded,
                  title: 'About Us',
                  onTap: () {},
                ),
                _buildMenuListItem(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                  onTap: () {},
                  hasBorder: false,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // A reusable widget to group settings under a title
  Widget _buildSettingsGroup(
      {required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: TextStyle(
            color: Colors.grey[600],
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  // Widget for the notification toggle
  Widget _buildNotificationToggle() {
    return SwitchListTile(
      title: const Text('Enable Notifications'),
      secondary: const Icon(Icons.notifications_outlined, color: _primaryColor),
      value: _notificationsEnabled,
      onChanged: (bool value) {
        setState(() {
          _notificationsEnabled = value;
        });
      },
      activeColor: _primaryColor,
    );
  }
  
  // Widget for the dark mode toggle
  Widget _buildDarkModeToggle() {
    return SwitchListTile(
      title: const Text('Dark Mode'),
      secondary: const Icon(Icons.dark_mode_outlined, color: _primaryColor),
      value: _darkModeEnabled,
      onChanged: (bool value) {
        setState(() {
          _darkModeEnabled = value;
        });
      },
      activeColor: _primaryColor,
    );
  }

  // A reusable list item for other settings
  Widget _buildMenuListItem({
    required IconData icon,
    required String title,
    Widget? trailing,
    required VoidCallback onTap,
    bool hasBorder = true,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: hasBorder
              ? Border(bottom: BorderSide(color: Colors.grey.shade200))
              : null,
        ),
        child: Row(
          children: [
            Icon(icon, color: _primaryColor),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            if (trailing != null) trailing,
            const SizedBox(width: 8),
            Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
          ],
        ),
      ),
    );
  }
}
