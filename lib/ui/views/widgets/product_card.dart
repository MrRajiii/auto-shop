import 'package:auto_shop/models/product_model.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onOrderPressed;

  const ProductCard({
    Key? key,
    required this.product,
    required this.onOrderPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF0D47A1);
    const Color discountGold = Color(0xFFFFC107);

    // Using LayoutBuilder to make internal elements responsive to the card's size
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;

        // Adjust font sizes based on card width
        double titleFontSize = width > 160 ? 13 : 11;
        double priceFontSize = width > 160 ? 15 : 13;
        double badgeFontSize = width > 160 ? 10 : 8;

        return InkWell(
          onTap: onOrderPressed,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. IMAGE SECTION
                Expanded(
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(8)),
                        child: Image.network(
                          product.imageUrls.isNotEmpty
                              ? product.imageUrls[0]
                              : 'https://via.placeholder.com/150',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            color: Colors.grey[200],
                            child: const Center(
                              child: Icon(Icons.image_not_supported,
                                  color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                      // "OFF" Badge
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 4),
                          decoration: const BoxDecoration(
                            color: discountGold,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(8),
                              bottomLeft: Radius.circular(8),
                            ),
                          ),
                          child: Text(
                            '20% OFF',
                            style: TextStyle(
                              fontSize: badgeFontSize,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                      // "TOP DEAL" Tag - Hidden on very small cards to prevent clutter
                      if (width > 140)
                        Positioned(
                          bottom: 8,
                          left: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: const BoxDecoration(
                              color: primaryBlue,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(4),
                                bottomRight: Radius.circular(4),
                              ),
                            ),
                            child: Text(
                              'TOP DEAL',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: badgeFontSize - 1,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // 2. CONTENT SECTION
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Responsive Height for Name
                      SizedBox(
                        height: width > 160 ? 35 : 30,
                        child: Text(
                          product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: titleFontSize,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),

                      // PRICE ROW
                      Wrap(
                        // Wrap handles overflow better than Row on small screens
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            '₱${product.price}',
                            style: TextStyle(
                              color: primaryBlue,
                              fontSize: priceFontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '₱${(double.parse(product.price.replaceAll(',', '')) * 1.2).toStringAsFixed(0)}',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 9,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      // RATING & SOLD ROW
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: List.generate(5, (index) {
                              return const Icon(
                                Icons.star,
                                size: 10,
                                color: discountGold,
                              );
                            }),
                          ),
                          if (width >
                              150) // Only show "sold" count if there's room
                            Text(
                              '1.2k sold',
                              style: TextStyle(
                                  fontSize: badgeFontSize, color: Colors.grey),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
