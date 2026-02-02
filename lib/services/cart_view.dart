import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:auto_shop/models/cart_item.dart';
import 'cart_viewmodel.dart';

class CartView extends StackedView<CartViewModel> {
  const CartView({Key? key}) : super(key: key);

  static const Color primaryBlue = Color(0xFF0D47A1);

  @override
  Widget builder(
    BuildContext context,
    CartViewModel viewModel,
    Widget? child,
  ) {
    final bool isMobile = MediaQuery.of(context).size.width < 900;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        title: const Text('Your Basket', style: TextStyle(color: Colors.white)),
        backgroundColor: primaryBlue,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: viewModel.isBusy
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal:
                    isMobile ? 16 : MediaQuery.of(context).size.width * 0.1,
                vertical: 30,
              ),
              child: isMobile
                  ? Column(
                      children: [
                        _buildCartList(context, viewModel),
                        const SizedBox(height: 24),
                        _buildOrderSummary(viewModel),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            flex: 2, child: _buildCartList(context, viewModel)),
                        const SizedBox(width: 30),
                        Expanded(flex: 1, child: _buildOrderSummary(viewModel)),
                      ],
                    ),
            ),
    );
  }

  Widget _buildCartList(BuildContext context, CartViewModel viewModel) {
    // Check if all items are selected
    bool allSelected = viewModel.items.isNotEmpty &&
        viewModel.items.every((item) => item.isSelected);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Shopping Cart',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              if (viewModel.items.isNotEmpty)
                Row(
                  children: [
                    const Text("Select All",
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                    Checkbox(
                      activeColor: primaryBlue,
                      value: allSelected,
                      onChanged: (val) {
                        // Assuming you might add a toggleAll in the future
                        for (var item in viewModel.items) {
                          if (item.isSelected != val) {
                            viewModel.toggleItemSelection(item.product.id);
                          }
                        }
                      },
                    ),
                  ],
                ),
            ],
          ),
          const Divider(height: 32),
          if (viewModel.items.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Center(child: Text("Your cart is empty")),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: viewModel.items.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final item = viewModel.items[index];
                return _CartItemTile(
                  item: item,
                  onToggleSelection: (val) =>
                      viewModel.toggleItemSelection(item.product.id),
                  onQuantityChanged: (newQty) =>
                      viewModel.updateItemQuantity(item, newQty),
                  onRemove: () => viewModel.removeItem(item.product.id),
                );
              },
            ),
          const SizedBox(height: 20),
          TextButton.icon(
            onPressed: viewModel.navigateToHome,
            icon: const Icon(Icons.arrow_back, size: 16, color: primaryBlue),
            label: const Text(
              'Continue Shopping',
              style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(CartViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Summary',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: primaryBlue),
          ),
          const SizedBox(height: 24),
          _summaryRow('Selected Items',
              '${viewModel.items.where((i) => i.isSelected).length}'),
          _summaryRow('Shipping', 'FREE', isGreen: true),
          const Divider(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Cost',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text(
                '₱${viewModel.totalPrice}',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: primaryBlue),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: viewModel.items.any((i) => i.isSelected)
                  ? viewModel.checkout
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                disabledBackgroundColor: Colors.grey,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text(
                'CHECKOUT NOW',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isGreen = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isGreen ? Colors.green : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  @override
  CartViewModel viewModelBuilder(BuildContext context) => CartViewModel();
}

class _CartItemTile extends StatelessWidget {
  final CartItem item;
  final Function(bool?) onToggleSelection;
  final Function(int) onQuantityChanged;
  final VoidCallback onRemove;

  const _CartItemTile({
    required this.item,
    required this.onToggleSelection,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF0D47A1);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Checkbox(
            activeColor: primaryBlue,
            value: item.isSelected,
            onChanged: onToggleSelection,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              item.product.imageUrls[0],
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.image_not_supported, size: 60),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 13),
                ),
                Text(
                  item.product.category,
                  style: const TextStyle(color: Colors.grey, fontSize: 10),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                _qtyBtn(
                    Icons.remove, () => onQuantityChanged(item.quantity - 1)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text('${item.quantity}',
                      style: const TextStyle(fontSize: 13)),
                ),
                _qtyBtn(Icons.add, () => onQuantityChanged(item.quantity + 1)),
              ],
            ),
          ),
          const SizedBox(width: 15),
          Text(
            "₱${item.product.price}",
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: primaryBlue, fontSize: 13),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline,
                color: Colors.redAccent, size: 18),
            onPressed: onRemove,
          )
        ],
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        color: Colors.grey[50],
        child: Icon(icon, size: 14, color: const Color(0xFF0D47A1)),
      ),
    );
  }
}
