import 'package:flutter/material.dart';
import '../home_viewmodel.dart';

class HomeCategories extends StatelessWidget {
  final HomeViewModel viewModel;
  const HomeCategories({Key? key, required this.viewModel}) : super(key: key);

  static const Color primaryBlue = Color(0xFF0D47A1);
  static const Color accentBlue = Color(0xFF1976D2);

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'name': 'All', 'icon': Icons.grid_view_rounded},
      {'name': 'Featured', 'icon': Icons.auto_awesome},
      {'name': 'Oil', 'icon': Icons.oil_barrel},
      {'name': 'Brakes', 'icon': Icons.settings_input_component},
      {'name': 'Tires', 'icon': Icons.tire_repair},
      {'name': 'Tools', 'icon': Icons.build},
      {'name': 'Battery', 'icon': Icons.battery_charging_full},
      {'name': 'Lights', 'icon': Icons.lightbulb},
    ];

    final screenWidth = MediaQuery.of(context).size.width;
    // On screens wider than 900px, we show all categories at once
    final bool isWideScreen = screenWidth > 900;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      width: double.infinity,
      child: isWideScreen
          ? Center(
              child: Wrap(
                spacing: 20,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: categories
                    .map((cat) => _buildCategoryItem(cat, isWideScreen))
                    .toList(),
              ),
            )
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: categories
                    .map((cat) => _buildCategoryItem(cat, false))
                    .toList(),
              ),
            ),
    );
  }

  Widget _buildCategoryItem(Map<String, dynamic> cat, bool isWideScreen) {
    final String catName = cat['name'] as String;
    final bool isSelected = viewModel.selectedCategory == catName;

    return GestureDetector(
      onTap: () => viewModel.setCategory(catName),
      child: Container(
        width: isWideScreen ? 100 : 85,
        margin:
            isWideScreen ? EdgeInsets.zero : const EdgeInsets.only(right: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.all(isWideScreen ? 16 : 12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? (catName == 'Featured' ? Colors.orange : primaryBlue)
                    : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: isSelected
                        ? primaryBlue.withOpacity(0.3)
                        : Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                cat['icon'] as IconData,
                size: isWideScreen ? 32 : 28,
                color: isSelected ? Colors.white : accentBlue,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              catName,
              textAlign: TextAlign.center,
              maxLines: 1,
              style: TextStyle(
                fontSize: isWideScreen ? 14 : 12,
                overflow: TextOverflow.ellipsis,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? primaryBlue : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
