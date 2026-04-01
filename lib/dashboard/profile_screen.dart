import 'package:demo_flutter_project/dashboard/change_payment_method.dart';
import 'package:demo_flutter_project/dashboard/dashboard_screen_2.dart';
import 'package:demo_flutter_project/dashboard/edit_profile_screen.dart';
import 'package:demo_flutter_project/dashboard/settings_screen.dart';
import 'package:demo_flutter_project/splash/food_splash_screen.dart';
import 'package:flutter/material.dart';

// A constant for the primary theme color.
const Color _primaryColor = Color(0xFF00BFA5);

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        // Added a leading IconButton to act as a back button
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.grey[800]),
           onPressed: () {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      // Agar root hai to close app ya Home le jao
      // Example: SystemNavigator.pop();  // exit app
      // ya phir ek HomeScreen pe le jao
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen2()), 
      );
    }
  },
        ),
        title: Text(
          'My Profile',
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
            _buildProfileHeader(),
            const SizedBox(height: 24),
            _buildProfileMenuList(context),
            const SizedBox(height: 24),
            _buildLogoutButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        const CircleAvatar(
          radius: 50,
          backgroundColor: _primaryColor,
          // Placeholder for a user image
          child: Icon(Icons.person, size: 60, color: Colors.white),
        ),
        const SizedBox(height: 12),
        const Text(
          'Asmara', // Sample user name
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Text(
          'asmara@example.com', // Sample user email
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildProfileMenuList(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          )
        ],
      ),
      child: Column(
        children: [
          _buildMenuListItem(
            context,
            icon: Icons.person_outline,
            title: 'Edit Profile',
            onTap: () {
              // Navigate to edit profile screen
              Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileScreen()));
            },
          ),
          _buildMenuListItem(
            context,
            icon: Icons.settings_outlined,
            title: 'Settings',
            onTap: () {
              // Navigate to settings screen
              Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen()));
            },
          ),
          _buildMenuListItem(
            context,
            icon: Icons.payment_outlined,
            title: 'Payment Methods',
            onTap: () {
              // Navigate to payment methods screen
              Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePaymentMethodScreen(
                currentPaymentMethod: 'Mastercard •••• •••• •••• 1234',
              )));
            },
          ),
          _buildMenuListItem(
            context,
            icon: Icons.help_outline,
            title: 'Help Center',
            onTap: () {
              // Navigate to help center
            },
            hasBorder: false, // No border for the last item
          ),
        ],
      ),
    );
  }

  Widget _buildMenuListItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool hasBorder = true,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
            Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          // Logic to handle logout
          // For example, clear user session and navigate to login screen
          Navigator.push(context, MaterialPageRoute(builder: (context) => FoodSplashScreen(), ));
        },
        icon: const Icon(Icons.logout, color: Colors.red),
        label: const Text(
          'Logout',
          style: TextStyle(fontSize: 16, color: Colors.red),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.withOpacity(0.1),
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

