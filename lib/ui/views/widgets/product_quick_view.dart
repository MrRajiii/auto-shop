import 'package:flutter/material.dart';
import 'package:auto_shop/models/product_model.dart';
import 'package:auto_shop/app/app.locator.dart';
import 'package:auto_shop/services/authentication_service.dart';
import 'package:auto_shop/app/app.router.dart'; // Ensure this is imported for navigation
import 'package:stacked_services/stacked_services.dart';

class ProductQuickView extends StatefulWidget {
  final Product product;
  final Function(Product, int, String? userId) onAddToCart;

  const ProductQuickView({
    Key? key,
    required this.product,
    required this.onAddToCart,
  }) : super(key: key);

  @override
  State<ProductQuickView> createState() => _ProductQuickViewState();
}

class _ProductQuickViewState extends State<ProductQuickView> {
  final PageController _pageController = PageController();
  final _authService = locator<AuthenticationService>();
  final _navigationService =
      locator<NavigationService>(); // Added for direct navigation

  int _currentPage = 0;
  int _quantity = 1;

  static const Color primaryBlue = Color(0xFF0D47A1);
  static const Color discountGold = Color(0xFFFFC107);

  void _increment() => setState(() => _quantity++);
  void _decrement() {
    if (_quantity > 1) setState(() => _quantity--);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final bool isMobile = screenSize.width < 850;

    return DefaultTabController(
      length: 2,
      child: Dialog(
        insetPadding: EdgeInsets.all(isMobile ? 12 : 40),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: isMobile ? screenSize.width : 1100,
          height: isMobile ? screenSize.height * 0.9 : 700,
          padding: const EdgeInsets.all(24),
          child: isMobile
              ? Column(
                  children: [
                    _buildCloseButton(),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildImageCarousel(height: 350, isMobile: true),
                            const SizedBox(height: 20),
                            _buildProductInfo(),
                            _buildTabSection(),
                            const SizedBox(height: 20),
                            const Text("QUANTITY",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                    letterSpacing: 1.2)),
                            const SizedBox(height: 12),
                            _buildQuantityCounter(),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: _buildActionButtons(context),
                    ),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: _buildImageCarousel(isMobile: false),
                    ),
                    const SizedBox(width: 30),
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildProductInfo(showClose: true),
                                  _buildTabSection(),
                                  const SizedBox(height: 20),
                                  const Text("QUANTITY",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                          letterSpacing: 1.2)),
                                  const SizedBox(height: 12),
                                  _buildQuantityCounter(),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ),
                          const Divider(height: 40),
                          _buildActionButtons(context),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildProductInfo({bool showClose = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildBadge("OFFICIAL STORE", primaryBlue),
            if (showClose)
              IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close)),
          ],
        ),
        const SizedBox(height: 10),
        Text(widget.product.name,
            style: const TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, height: 1.2)),
        const SizedBox(height: 10),
        _buildRatingRow(),
        const SizedBox(height: 20),
        Text('₱${widget.product.price}',
            style: const TextStyle(
                color: primaryBlue, fontSize: 32, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildTabSection() {
    return Column(
      children: [
        const TabBar(
          labelColor: primaryBlue,
          unselectedLabelColor: Colors.grey,
          indicatorColor: primaryBlue,
          tabs: [
            Tab(text: "DESCRIPTION"),
            Tab(text: "SPECIFICATIONS"),
          ],
        ),
        SizedBox(
          height: 180,
          child: TabBarView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: SingleChildScrollView(
                  child: Text(
                    widget.product.description ??
                        "No description available for this product.",
                    style: TextStyle(color: Colors.grey[700], height: 1.5),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: _buildSpecifications(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => _handleAddToCart(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: primaryBlue,
              side: const BorderSide(color: primaryBlue, width: 2),
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('ADD TO CART',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () => _handleBuyNow(context), // Updated handler
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryBlue,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('BUY NOW',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  // --- HANDLERS ---

  void _handleAddToCart(BuildContext context) {
    widget.onAddToCart(widget.product, _quantity, _authService.currentUser?.id);

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added $_quantity ${widget.product.name} to cart'),
        backgroundColor: primaryBlue,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleBuyNow(BuildContext context) async {
    // 1. Add item to cart session
    widget.onAddToCart(widget.product, _quantity, _authService.currentUser?.id);

    // 2. Close the quick view dialog
    Navigator.pop(context);

    // 3. Navigate directly to the Cart/Checkout page
    // Using Stacked NavigationService to ensure clean routing
    _navigationService.navigateTo(Routes.cartView);
  }

  // --- UI COMPONENTS ---

  Widget _buildImageCarousel({double? height, required bool isMobile}) {
    return Container(
      height: height ?? double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemCount: widget.product.imageUrls.length,
            itemBuilder: (context, index) => ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                widget.product.imageUrls[index],
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Center(
                    child:
                        Icon(Icons.broken_image, size: 50, color: Colors.grey)),
              ),
            ),
          ),
          _buildCarouselDots(),
        ],
      ),
    );
  }

  Widget _buildCloseButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.close),
      ),
    );
  }

  Widget _buildSpecifications() {
    final productSpecs = widget.product.specifications ?? {};
    final specs = productSpecs.isNotEmpty
        ? productSpecs
        : {
            "Category": widget.product.category,
            "Brand": "Genuine Parts",
            "Warranty": "12 Months",
            "Compatibility": "Universal",
          };

    return ListView(
      shrinkWrap: true,
      children: specs.entries
          .map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Text("${e.key}: ",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13)),
                    Text(e.value,
                        style: const TextStyle(
                            fontSize: 13, color: Colors.blueGrey)),
                  ],
                ),
              ))
          .toList(),
    );
  }

  Widget _buildQuantityCounter() {
    return Row(
      children: [
        _qtyBtn(Icons.remove, _decrement),
        Container(
          width: 70,
          height: 45,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              border: Border.symmetric(
                  horizontal: BorderSide(color: Colors.grey[300]!))),
          child: Text('$_quantity',
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        _qtyBtn(Icons.add, _increment),
      ],
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          color: Colors.grey[100],
        ),
        child: Icon(icon, size: 20, color: primaryBlue),
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(4)),
      child: Text(text,
          style: TextStyle(
              color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildRatingRow() {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        ...List.generate(
            5, (i) => const Icon(Icons.star, color: discountGold, size: 18)),
        const SizedBox(width: 8),
        const Text('5.0', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(width: 12),
        const Text('|', style: TextStyle(color: Colors.grey)),
        const SizedBox(width: 12),
        const Text('1.8k Sold', style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildCarouselDots() {
    return Positioned(
      bottom: 20,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          widget.product.imageUrls.length,
          (index) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: _currentPage == index ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: _currentPage == index
                  ? primaryBlue
                  : Colors.white.withOpacity(0.5),
            ),
          ),
        ),
      ),
    );
  }
}
