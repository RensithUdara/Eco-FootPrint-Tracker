import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/user_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to settings
            },
          ),
        ],
      ),
      body: Consumer<UserController>(
        builder: (context, userController, child) {
          final user = userController.currentUser;
          
          if (user == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildProfileHeader(user.name, user.email),
                const SizedBox(height: 24),
                _buildStatsGrid(user.stats.greenPoints, user.stats.level, user.stats.totalCarbonSaved),
                const SizedBox(height: 24),
                _buildMenuItems(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(String name, String email) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.green.shade100,
          child: Text(
            name.isNotEmpty ? name[0].toUpperCase() : 'U',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          name,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          email,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid(int greenPoints, int level, double carbonSaved) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Green Points',
            greenPoints.toString(),
            Icons.eco,
            Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Level',
            level.toString(),
            Icons.trending_up,
            Colors.orange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'CO₂ Saved',
            '${carbonSaved.toStringAsFixed(1)} kg',
            Icons.cloud,
            Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItems(BuildContext context) {
    return Column(
      children: [
        _buildMenuItem(
          icon: Icons.history,
          title: 'Activity History',
          subtitle: 'View your logged activities',
          onTap: () {},
        ),
        _buildMenuItem(
          icon: Icons.analytics,
          title: 'Carbon Analytics',
          subtitle: 'Detailed footprint analysis',
          onTap: () {},
        ),
        _buildMenuItem(
          icon: Icons.emoji_events,
          title: 'Achievements',
          subtitle: 'View unlocked achievements',
          onTap: () {},
        ),
        _buildMenuItem(
          icon: Icons.settings,
          title: 'Settings',
          subtitle: 'App preferences and account',
          onTap: () {},
        ),
        _buildMenuItem(
          icon: Icons.help,
          title: 'Help & Support',
          subtitle: 'Get help and contact support',
          onTap: () {},
        ),
        _buildMenuItem(
          icon: Icons.info,
          title: 'About',
          subtitle: 'App version and information',
          onTap: () {},
        ),
        const SizedBox(height: 24),
        _buildMenuItem(
          icon: Icons.logout,
          title: 'Sign Out',
          subtitle: 'Sign out of your account',
          onTap: () {
            _showSignOutDialog(context);
          },
          isDestructive: true,
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isDestructive 
                ? Colors.red.withOpacity(0.1)
                : Colors.grey.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: isDestructive ? Colors.red : Colors.grey[700],
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: isDestructive ? Colors.red : null,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Handle sign out
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Sign out functionality would be implemented here'),
                  ),
                );
              },
              child: const Text(
                'Sign Out',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
