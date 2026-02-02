import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:auto_shop/models/cart_item.dart';
import 'cart_viewmodel.dart';

class CartView extends StackedView<CartViewModel> {
  const CartView({Key? key}) : super(key: key);

  static const Color legacyBlue = Color(0xFF0D47A1);
  static const Color brandingCream = Color(0xFFFFF3E0);

  @override
  Widget builder(BuildContext context, CartViewModel viewModel, Widget? child) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 900;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Your Basket'),
        backgroundColor: legacyBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: viewModel.navigateToHome,
        ),
      ),
      body: viewModel.items.isEmpty
          ? _buildEmptyCart(viewModel)
          : SingleChildScrollView(
              child: Center(
                child: Container(
                  width: isMobile ? screenWidth : 1200,
                  margin: EdgeInsets.all(isMobile ? 12 : 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      )
                    ],
                  ),
                  // FIXED: Removed IntrinsicHeight and used a standard layout
                  child: isMobile
                      ? _buildMobileLayout(viewModel)
                      : _buildDesktopLayout(viewModel),
                ),
              ),
            ),
    );
  }

  // DESKTOP: Side-by-side Row
  Widget _buildDesktopLayout(CartViewModel viewModel) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start, // Align to top
      children: [
        Expanded(
          flex: 2,
          child: _buildItemList(viewModel),
        ),
        // FIXED: Wrap summary in a Container with a height constraint or let it flow
        Expanded(
          flex: 1,
          child: _buildSummarySection(viewModel, isDesktop: true),
        ),
      ],
    );
  }

  // MOBILE: Vertical Column
  Widget _buildMobileLayout(CartViewModel viewModel) {
    return Column(
      children: [
        _buildItemList(viewModel, isMobile: true),
        const Divider(height: 1),
        _buildSummarySection(viewModel, isDesktop: false),
      ],
    );
  }

  Widget _buildItemList(CartViewModel viewModel, {bool isMobile = false}) {
    return Padding(
      padding: EdgeInsets.all(isMobile ? 20.0 : 30.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Shopping Cart",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          const Divider(),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: viewModel.items.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final item = viewModel.items[index];
              return _CartItemTile(
                item: item,
                onRemove: () => viewModel.removeItem(item.product.id),
              );
            },
          ),
          const SizedBox(height: 20),
          TextButton.icon(
            onPressed: viewModel.navigateToHome,
            icon: const Icon(Icons.arrow_back, size: 16),
            label: const Text("Continue Shopping"),
            style: TextButton.styleFrom(foregroundColor: legacyBlue),
          )
        ],
      ),
    );
  }

  Widget _buildSummarySection(CartViewModel viewModel,
      {required bool isDesktop}) {
    return Container(
      // FIXED: Added a minimum height for desktop so the sidebar looks filled
      constraints: isDesktop ? const BoxConstraints(minHeight: 500) : null,
      decoration: BoxDecoration(
        color: brandingCream,
        borderRadius: isDesktop
            ? const BorderRadius.only(
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
              )
            : const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
      ),
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Order Summary",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: legacyBlue)),
          const SizedBox(height: 20),
          _summaryRow("Items", "${viewModel.items.length}"),
          _summaryRow("Shipping", "FREE"),
          const SizedBox(height: 40),
          const Divider(color: Colors.blueGrey),
          _summaryRow("Total Cost", "₱${viewModel.totalPrice}", isTotal: true),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: viewModel.checkout,
              style: ElevatedButton.styleFrom(
                backgroundColor: legacyBlue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text("CHECKOUT NOW",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: isTotal ? 16 : 14,
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
          Text(value,
              style: TextStyle(
                  fontSize: isTotal ? 20 : 14,
                  fontWeight: FontWeight.bold,
                  color: isTotal ? legacyBlue : Colors.black)),
        ],
      ),
    );
  }

  Widget _buildEmptyCart(CartViewModel viewModel) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_basket_outlined,
              size: 100, color: Colors.grey[300]),
          const SizedBox(height: 20),
          const Text("Your basket is empty",
              style: TextStyle(fontSize: 18, color: Colors.grey)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: viewModel.navigateToHome,
            style: ElevatedButton.styleFrom(backgroundColor: legacyBlue),
            child: const Text("GO SHOPPING",
                style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  @override
  CartViewModel viewModelBuilder(BuildContext context) => CartViewModel();
}

class _CartItemTile extends StatelessWidget {
  final CartItem item;
  final VoidCallback onRemove;
  const _CartItemTile({required this.item, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    bool isSmall = MediaQuery.of(context).size.width < 500;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              item.product.imageUrls[0],
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              // FIXED: This prevents the app from throwing exceptions if the link is dead
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 70,
                  height: 70,
                  color: Colors.grey[200],
                  child:
                      const Icon(Icons.image_not_supported, color: Colors.grey),
                );
              },
              // Optional: Adds a nice fade-in effect
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: 70,
                  height: 70,
                  color: Colors.grey[100],
                  child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2)),
                );
              },
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 13)),
                Text(item.product.category,
                    style: const TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            ),
          ),
          const SizedBox(width: 10),
          if (!isSmall) ...[
            Text("x${item.quantity}",
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 15),
          ],
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("₱${item.product.price}",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              if (isSmall)
                Text("Qty: ${item.quantity}",
                    style: const TextStyle(fontSize: 12)),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline,
                color: Colors.redAccent, size: 20),
            onPressed: onRemove,
          )
        ],
      ),
    );
  }
}
