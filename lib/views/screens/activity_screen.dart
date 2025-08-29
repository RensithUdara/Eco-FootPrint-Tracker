import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/user_controller.dart';
import '../../models/activity_model.dart';
import '../components/add_activity_modal.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Activity'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Transportation'),
            Tab(text: 'Food'),
            Tab(text: 'Energy'),
            Tab(text: 'Shopping'),
            Tab(text: 'Other'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTransportationTab(),
          _buildFoodTab(),
          _buildEnergyTab(),
          _buildShoppingTab(),
          _buildOtherTab(),
        ],
      ),
    );
  }

  Widget _buildTransportationTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How did you travel today?',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          _buildActivityOption(
            title: 'Walk',
            subtitle: 'Carbon negative - Great for health!',
            icon: Icons.directions_walk,
            color: Colors.green,
            onTap: () => _showTransportationModal(context, 'walk'),
          ),
          _buildActivityOption(
            title: 'Bicycle',
            subtitle: 'Zero emissions transportation',
            icon: Icons.directions_bike,
            color: Colors.green,
            onTap: () => _showTransportationModal(context, 'bike'),
          ),
          _buildActivityOption(
            title: 'Public Transport',
            subtitle: 'Bus, train, or metro',
            icon: Icons.directions_bus,
            color: Colors.orange,
            onTap: () => _showTransportationModal(context, 'bus'),
          ),
          _buildActivityOption(
            title: 'Car',
            subtitle: 'Private vehicle',
            icon: Icons.directions_car,
            color: Colors.red,
            onTap: () => _showTransportationModal(context, 'car'),
          ),
          _buildActivityOption(
            title: 'Flight',
            subtitle: 'Air travel',
            icon: Icons.flight,
            color: Colors.red[700]!,
            onTap: () => _showTransportationModal(context, 'plane'),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What did you eat today?',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          _buildActivityOption(
            title: 'Plant-based Meal',
            subtitle: 'Vegetables, fruits, grains, legumes',
            icon: Icons.eco,
            color: Colors.green,
            onTap: () => _showFoodModal(context, 'plant_based'),
          ),
          _buildActivityOption(
            title: 'Chicken/Poultry',
            subtitle: 'White meat',
            icon: Icons.restaurant,
            color: Colors.orange,
            onTap: () => _showFoodModal(context, 'chicken'),
          ),
          _buildActivityOption(
            title: 'Fish/Seafood',
            subtitle: 'Fish and other seafood',
            icon: Icons.set_meal,
            color: Colors.blue,
            onTap: () => _showFoodModal(context, 'fish'),
          ),
          _buildActivityOption(
            title: 'Beef/Red Meat',
            subtitle: 'Beef, pork, lamb',
            icon: Icons.restaurant_menu,
            color: Colors.red,
            onTap: () => _showFoodModal(context, 'beef'),
          ),
          _buildActivityOption(
            title: 'Dairy Products',
            subtitle: 'Milk, cheese, yogurt',
            icon: Icons.local_drink,
            color: Colors.amber,
            onTap: () => _showFoodModal(context, 'dairy_milk'),
          ),
        ],
      ),
    );
  }

  Widget _buildEnergyTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Log your energy usage',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          _buildActivityOption(
            title: 'Electricity',
            subtitle: 'Home electricity consumption',
            icon: Icons.electrical_services,
            color: Colors.yellow[700]!,
            onTap: () => _showEnergyModal(context, 'electricity'),
          ),
          _buildActivityOption(
            title: 'Natural Gas',
            subtitle: 'Heating and cooking gas',
            icon: Icons.local_fire_department,
            color: Colors.orange,
            onTap: () => _showEnergyModal(context, 'natural_gas'),
          ),
          _buildActivityOption(
            title: 'Solar Energy',
            subtitle: 'Renewable solar power',
            icon: Icons.wb_sunny,
            color: Colors.green,
            onTap: () => _showEnergyModal(context, 'electricity', isRenewable: true),
          ),
        ],
      ),
    );
  }

  Widget _buildShoppingTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What did you buy today?',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          _buildActivityOption(
            title: 'Second-hand Items',
            subtitle: 'Used or refurbished products',
            icon: Icons.recycling,
            color: Colors.green,
            onTap: () => _showShoppingModal(context, 'second_hand'),
          ),
          _buildActivityOption(
            title: 'Local Products',
            subtitle: 'Locally made or sourced items',
            icon: Icons.store,
            color: Colors.lightGreen,
            onTap: () => _showShoppingModal(context, 'local'),
          ),
          _buildActivityOption(
            title: 'New Products',
            subtitle: 'Brand new items',
            icon: Icons.shopping_bag,
            color: Colors.orange,
            onTap: () => _showShoppingModal(context, 'new'),
          ),
        ],
      ),
    );
  }

  Widget _buildOtherTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Other activities',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          _buildActivityOption(
            title: 'Recycling',
            subtitle: 'Recycled materials today',
            icon: Icons.recycling,
            color: Colors.green,
            onTap: () => _showOtherModal(context, 'recycling'),
          ),
          _buildActivityOption(
            title: 'Composting',
            subtitle: 'Organic waste composted',
            icon: Icons.grass,
            color: Colors.brown,
            onTap: () => _showOtherModal(context, 'composting'),
          ),
          _buildActivityOption(
            title: 'Water Conservation',
            subtitle: 'Water-saving activities',
            icon: Icons.water_drop,
            color: Colors.blue,
            onTap: () => _showOtherModal(context, 'water'),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  void _showTransportationModal(BuildContext context, String transportType) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => AddActivityModal(
        activityType: ActivityType.transportation,
        transportationType: transportType,
      ),
    );
  }

  void _showFoodModal(BuildContext context, String foodType) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => AddActivityModal(
        activityType: ActivityType.food,
        foodType: foodType,
      ),
    );
  }

  void _showEnergyModal(BuildContext context, String energyType, {bool isRenewable = false}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => AddActivityModal(
        activityType: ActivityType.energy,
        energyType: energyType,
        isRenewable: isRenewable,
      ),
    );
  }

  void _showShoppingModal(BuildContext context, String shoppingType) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => AddActivityModal(
        activityType: ActivityType.shopping,
        shoppingType: shoppingType,
      ),
    );
  }

  void _showOtherModal(BuildContext context, String otherType) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => AddActivityModal(
        activityType: ActivityType.other,
        otherType: otherType,
      ),
    );
  }
}
