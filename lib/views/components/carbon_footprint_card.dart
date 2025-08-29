import 'package:flutter/material.dart';
import '../../services/carbon_calculation_service.dart';
import '../../utils/app_theme.dart';

class CarbonFootprintCard extends StatelessWidget {
  final String title;
  final double carbonAmount;
  final String subtitle;
  final IconData icon;

  const CarbonFootprintCard({
    super.key,
    required this.title,
    required this.carbonAmount,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final CarbonCalculationService carbonService = CarbonCalculationService();
    final color = AppTheme.getCarbonFootprintColor(carbonAmount);
    final category = carbonService.getCarbonFootprintCategory(carbonAmount);

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '${(carbonAmount / 1000).toStringAsFixed(2)} kg CO₂',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              category,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
