import 'package:auto_shop/ui/views/widgets/product_card.dart';
import 'package:auto_shop/ui/views/widgets/product_quick_view.dart';
import 'package:flutter/material.dart';
import '../home_viewmodel.dart';

class HomeProductGrid extends StatelessWidget {
  final HomeViewModel viewModel;
  const HomeProductGrid({Key? key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final displayProducts = viewModel.filteredProducts;

    if (displayProducts.isEmpty) {
      return _buildEmptyState();
    }

    double screenWidth = MediaQuery.of(context).size.width;

    // Determine column count based on width
    int crossAxisCount = screenWidth > 1400
        ? 6
        : screenWidth > 1100
            ? 5
            : screenWidth > 800
                ? 3
                : 2;

    // Adjust ratio for mobile vs desktop to prevent squashed text
    // 2 columns need more height (smaller ratio) than 6 columns
    double aspectRatio = screenWidth > 600 ? 0.75 : 0.68;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: displayProducts.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: aspectRatio,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
        ),
        itemBuilder: (context, index) {
          final product = displayProducts[index];
          return ProductCard(
            product: product,
            onOrderPressed: () {
              showDialog(
                context: context,
                builder: (context) => ProductQuickView(
                  product: product,
                  onAddToCart: (p, quantity) {
                    viewModel.addToCart(p, quantity);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.search_off_rounded,
                  size: 64, color: Colors.grey[400]),
            ),
            const SizedBox(height: 24),
            const Text(
              "No results found",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "We couldn't find any parts matching \"${viewModel.searchQuery}\" in ${viewModel.selectedCategory}.",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.blueGrey, fontSize: 14),
              ),
            ),
            const SizedBox(height: 24),
            TextButton.icon(
              onPressed: () {
                // You could add a clear filters method in your viewmodel
              },
              icon: const Icon(Icons.refresh),
              label: const Text("Clear all filters"),
            )
          ],
        ),
      ),
    );
  }
}
