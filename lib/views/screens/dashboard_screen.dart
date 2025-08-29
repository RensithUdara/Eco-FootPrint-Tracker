import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../controllers/user_controller.dart';
import '../../models/activity_model.dart';
import '../../services/carbon_calculation_service.dart';
import '../../utils/app_theme.dart';
import '../components/carbon_footprint_card.dart';
import '../components/quick_activity_card.dart';
import '../components/achievement_banner.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final CarbonCalculationService _carbonService = CarbonCalculationService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final userController = Provider.of<UserController>(context, listen: false);
    await userController.loadUserActivities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EcoFootprint Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
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

          return RefreshIndicator(
            onRefresh: _loadData,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWelcomeSection(user.name),
                  const SizedBox(height: 24),
                  _buildCarbonOverview(userController),
                  const SizedBox(height: 24),
                  _buildQuickStats(userController),
                  const SizedBox(height: 24),
                  _buildWeeklyChart(userController),
                  const SizedBox(height: 24),
                  _buildQuickActions(userController),
                  const SizedBox(height: 24),
                  _buildRecentActivities(userController),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWelcomeSection(String userName) {
    final hour = DateTime.now().hour;
    String greeting;
    IconData icon;
    
    if (hour < 12) {
      greeting = 'Good Morning';
      icon = Icons.wb_sunny;
    } else if (hour < 18) {
      greeting = 'Good Afternoon';
      icon = Icons.wb_sunny_outlined;
    } else {
      greeting = 'Good Evening';
      icon = Icons.nightlight_round;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 32,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$greeting, $userName!',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Let's make today more sustainable",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarbonOverview(UserController userController) {
    final dailyCarbonFootprint = userController.getDailyCarbonFootprint();
    final weeklyCarbonFootprint = userController.getWeeklyCarbonFootprint();
    final dailyBudget = _carbonService.getDailyCarbonBudget();

    return Row(
      children: [
        Expanded(
          child: CarbonFootprintCard(
            title: 'Today',
            carbonAmount: dailyCarbonFootprint,
            subtitle: '${((dailyCarbonFootprint / dailyBudget) * 100).toStringAsFixed(0)}% of daily budget',
            icon: Icons.today,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: CarbonFootprintCard(
            title: 'This Week',
            carbonAmount: weeklyCarbonFootprint,
            subtitle: '${(weeklyCarbonFootprint / 1000).toStringAsFixed(1)} kg CO₂',
            icon: Icons.date_range,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStats(UserController userController) {
    final user = userController.currentUser!;
    
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Green Points',
            user.stats.greenPoints.toString(),
            Icons.eco,
            AppTheme.primaryGreen,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Level',
            user.stats.level.toString(),
            Icons.trending_up,
            AppTheme.accentOrange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Streak',
            '${user.stats.streakDays} days',
            Icons.local_fire_department,
            AppTheme.carbonHigh,
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
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyChart(UserController userController) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weekly Carbon Footprint',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: _buildLineChart(userController),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLineChart(UserController userController) {
    final activities = userController.userActivities;
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    
    final dailyTotals = List.generate(7, (index) {
      final day = weekStart.add(Duration(days: index));
      final dayStart = DateTime(day.year, day.month, day.day);
      final dayEnd = dayStart.add(const Duration(days: 1));
      
      return activities
          .where((activity) => 
              activity.timestamp.isAfter(dayStart) && 
              activity.timestamp.isBefore(dayEnd))
          .fold(0.0, (sum, activity) => sum + activity.carbonFootprint) / 1000; // Convert to kg
    });

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                if (value.toInt() >= 0 && value.toInt() < days.length) {
                  return Text(
                    days[value.toInt()],
                    style: const TextStyle(fontSize: 12),
                  );
                }
                return const Text('');
              },
              interval: 1,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(
                  '${value.toStringAsFixed(1)}kg',
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: dailyTotals.asMap().entries.map((entry) {
              return FlSpot(entry.key.toDouble(), entry.value);
            }).toList(),
            isCurved: true,
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withOpacity(0.5),
              ],
            ),
            barWidth: 3,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor.withOpacity(0.3),
                  Theme.of(context).primaryColor.withOpacity(0.1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(UserController userController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: QuickActivityCard(
                title: 'Transportation',
                subtitle: 'Log your commute',
                icon: Icons.directions_car,
                color: Colors.blue,
                onTap: () => _showActivityModal(context, ActivityType.transportation),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: QuickActivityCard(
                title: 'Food',
                subtitle: 'Track your meals',
                icon: Icons.restaurant,
                color: Colors.orange,
                onTap: () => _showActivityModal(context, ActivityType.food),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentActivities(UserController userController) {
    final recentActivities = userController.userActivities.take(5).toList();
    
    if (recentActivities.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(
                Icons.eco_outlined,
                size: 48,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'No activities yet',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Start logging your daily activities to track your carbon footprint',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activities',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...recentActivities.map((activity) => _buildActivityTile(activity)),
      ],
    );
  }

  Widget _buildActivityTile(ActivityModel activity) {
    final color = AppTheme.getCarbonFootprintColor(activity.carbonFootprint);
    final category = _carbonService.getCarbonFootprintCategory(activity.carbonFootprint);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            _getActivityIcon(activity.type),
            color: color,
            size: 20,
          ),
        ),
        title: Text(activity.title),
        subtitle: Text(activity.description),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${(activity.carbonFootprint / 1000).toStringAsFixed(2)} kg',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              category,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getActivityIcon(ActivityType type) {
    switch (type) {
      case ActivityType.transportation:
        return Icons.directions_car;
      case ActivityType.food:
        return Icons.restaurant;
      case ActivityType.energy:
        return Icons.flash_on;
      case ActivityType.shopping:
        return Icons.shopping_bag;
      case ActivityType.other:
        return Icons.more_horiz;
    }
  }

  void _showActivityModal(BuildContext context, ActivityType type) {
    // This would open a modal to add a new activity
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Add ${type.name} activity modal would open here'),
      ),
    );
  }
}
