import 'package:flutter/material.dart';
import 'package:auto_shop/models/product_model.dart';

class ProductQuickView extends StatefulWidget {
  final Product product;
  final Function(Product, int) onAddToCart;

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

    return Dialog(
      insetPadding: EdgeInsets.all(isMobile ? 12 : 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: isMobile ? screenSize.width : 1000,
        height: isMobile ? screenSize.height * 0.9 : 600,
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
                          _buildProductDetails(isMobile: true),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: _buildImageCarousel(isMobile: false),
                  ),
                  const SizedBox(width: 30),
                  Expanded(
                    flex: 4,
                    child: _buildProductDetails(isMobile: false),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildImageCarousel({double? height, required bool isMobile}) {
    return Container(
      height: height ?? double.infinity,
      decoration: BoxDecoration(
        color: const Color(
            0xFFF0F0F0), // Light grey background for uncropped images
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
                // KEY CHANGE: BoxFit.contain ensures the full image is shown
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                    const Center(child: Icon(Icons.broken_image, size: 50)),
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

  Widget _buildProductDetails({required bool isMobile}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isMobile)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBadge("OFFICIAL STORE", primaryBlue),
              IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close)),
            ],
          ),
        if (isMobile) _buildBadge("OFFICIAL STORE", primaryBlue),
        const SizedBox(height: 10),
        Text(widget.product.name,
            style: const TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, height: 1.2)),
        const SizedBox(height: 10),
        _buildRatingRow(),
        const SizedBox(height: 25),
        Text('₱${widget.product.price}',
            style: const TextStyle(
                color: primaryBlue, fontSize: 32, fontWeight: FontWeight.bold)),
        const SizedBox(height: 25),
        const Text("QUANTITY",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                letterSpacing: 1.2)),
        const SizedBox(height: 12),
        _buildQuantityCounter(),
        const SizedBox(height: 30),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => _handleAddToCart(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: primaryBlue,
                  side: const BorderSide(color: primaryBlue, width: 2),
                  padding: const EdgeInsets.symmetric(vertical: 20),
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
                onPressed: () {
                  widget.onAddToCart(widget.product, _quantity);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('BUY NOW',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        )
      ],
    );
  }

  void _handleAddToCart(BuildContext context) {
    widget.onAddToCart(widget.product, _quantity);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added $_quantity to cart'),
        backgroundColor: primaryBlue,
        duration: const Duration(seconds: 2),
      ),
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
