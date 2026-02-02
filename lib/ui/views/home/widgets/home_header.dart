import 'package:flutter/material.dart';
import '../home_viewmodel.dart';

class HomeHeader extends StatelessWidget {
  final HomeViewModel viewModel;
  final TextEditingController controller;

  const HomeHeader({
    Key? key,
    required this.viewModel,
    required this.controller,
  }) : super(key: key);

  static const Color primaryBlue = Color(0xFF0D47A1);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 700;

    return Container(
      color: primaryBlue,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: SafeArea(
        bottom: false,
        child: isMobile
            ? Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildLogo(),
                      Row(
                        children: [
                          _buildCartIcon(),
                          const SizedBox(width: 15),
                          _buildAuthSection(isMobile: true),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildSearchField(),
                ],
              )
            : Row(
                children: [
                  _buildLogo(),
                  const SizedBox(width: 30),
                  Expanded(
                    child: _buildSearchField(),
                  ),
                  const SizedBox(width: 20),
                  _buildCartIcon(),
                  const SizedBox(width: 20),
                  _buildAuthSection(isMobile: false),
                ],
              ),
      ),
    );
  }

  // Helper to toggle between Login button and Profile Greeting
  Widget _buildAuthSection({required bool isMobile}) {
    if (viewModel.isLoggedIn && viewModel.currentUser != null) {
      return _buildUserProfile(viewModel.currentUser!.fullName,
          isMobile: isMobile);
    }
    return _buildLoginButton(isMobile: isMobile);
  }

  Widget _buildLogo() {
    return const Text(
      'LEGACY AUTO',
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 20,
        letterSpacing: 1.1,
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        onChanged: viewModel.updateSearchQuery,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: "Search parts...",
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 20),
          suffixIcon: viewModel.searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey, size: 18),
                  onPressed: () {
                    controller.clear();
                    viewModel.clearSearch();
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }

  Widget _buildUserProfile(String fullName, {required bool isMobile}) {
    // Splits "Justin Mason" to "Justin"
    final String firstName = fullName.split(' ').first;

    return InkWell(
      onTap: viewModel.navigateToProfile,
      child: Row(
        children: [
          if (!isMobile) ...[
            Text(
              "Hi, $firstName",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 10),
          ],
          CircleAvatar(
            radius: 15,
            backgroundColor: Colors.white24,
            child: Text(
              firstName[0].toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton({required bool isMobile}) {
    return TextButton(
      onPressed: viewModel.navigateToLogin,
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        padding: isMobile
            ? EdgeInsets.zero
            : const EdgeInsets.symmetric(horizontal: 10),
      ),
      child: Text(
        isMobile ? "Login" : "Login / Register",
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildCartIcon() {
    return GestureDetector(
      onTap: viewModel.viewCart,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const Icon(
            Icons.shopping_cart_outlined,
            color: Colors.white,
            size: 26,
          ),
          if (viewModel.cartItemCount > 0)
            Positioned(
              right: -6,
              top: -6,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(
                  minWidth: 16,
                  minHeight: 16,
                ),
                child: Text(
                  '${viewModel.cartItemCount}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            )
        ],
      ),
    );
  }
}
