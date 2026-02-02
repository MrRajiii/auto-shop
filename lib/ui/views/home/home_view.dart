import 'package:auto_shop/ui/views/home/widgets/home_hero.dart';
import 'package:auto_shop/ui/views/home/widgets/home_product_grid.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'home_viewmodel.dart';
import 'widgets/home_header.dart';
import 'widgets/home_categories.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget builder(BuildContext context, HomeViewModel viewModel, Widget? child) {
    final screenSize = MediaQuery.of(context).size;
    final bool isMobile = screenSize.width < 700;

    final TextEditingController searchController =
        TextEditingController(text: viewModel.searchQuery);

    searchController.selection = TextSelection.fromPosition(
      TextPosition(offset: searchController.text.length),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      body: Column(
        children: [
          // Header stays pinned at the top
          HomeHeader(viewModel: viewModel, controller: searchController),
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Container(
                  // Constrain maximum width for ultra-wide monitors
                  constraints: const BoxConstraints(maxWidth: 1400),
                  child: Column(
                    children: [
                      const HomeHero(),
                      HomeTrustBar(isMobile: isMobile),
                      HomeCategories(viewModel: viewModel),
                      const SizedBox(height: 20),
                      const HomeSectionTitle(title: "FEATURED AUTO SUPPLIES"),
                      // The Grid usually handles its own crossAxisCount internally
                      HomeProductGrid(viewModel: viewModel),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  HomeViewModel viewModelBuilder(BuildContext context) => HomeViewModel();
}

class HomeTrustBar extends StatelessWidget {
  final bool isMobile;
  const HomeTrustBar({Key? key, required this.isMobile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Item 1: Expert Verified
          Expanded(
            child: _TrustItem(
              icon: Icons.verified_user_rounded,
              label: "Expert Verified",
              isMobile: isMobile,
            ),
          ),
          // Vertical Divider line between the two items
          Container(
            height: 20,
            width: 1,
            color: Colors.grey[200],
          ),
          // Item 2: Nationwide Delivery
          Expanded(
            child: _TrustItem(
              icon: Icons.local_shipping_rounded,
              label: "Nationwide Delivery",
              isMobile: isMobile,
            ),
          ),
        ],
      ),
    );
  }
}

class _TrustItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isMobile;

  const _TrustItem({
    required this.icon,
    required this.label,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: const Color(0xFF1976D2),
          size: isMobile ? 18 : 22,
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            label,
            style: TextStyle(
              fontSize: isMobile ? 11 : 13,
              fontWeight: FontWeight.w600,
              color: Colors.blueGrey[800],
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class HomeSectionTitle extends StatelessWidget {
  final String title;
  const HomeSectionTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 24,
            decoration: BoxDecoration(
              color: const Color(0xFF1976D2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
