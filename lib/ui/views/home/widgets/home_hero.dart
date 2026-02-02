import 'package:flutter/material.dart';

class HomeHero extends StatelessWidget {
  const HomeHero({Key? key}) : super(key: key);

  static const Color primaryBlue = Color(0xFF0D47A1);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 800;
    final bool isVerySmall = screenWidth < 500;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: isMobile
          ? Column(
              children: [
                // Main Banner takes full width on mobile
                SizedBox(
                  height: 240,
                  width: double.infinity,
                  child: _buildMainBanner(isMobile: true),
                ),
                if (!isVerySmall) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _sideBanner(
                        'Mechanical Tools',
                        'https://images.pexels.com/photos/162460/wrench-nuts-screws-chisel-162460.jpeg?auto=compress&cs=tinysrgb&w=400',
                        height: 120,
                      ),
                      const SizedBox(width: 12),
                      _sideBanner(
                        'Lubricant Deals',
                        'https://images.pexels.com/photos/4489749/pexels-photo-4489749.jpeg?auto=compress&cs=tinysrgb&w=400',
                        height: 120,
                      ),
                    ],
                  ),
                ],
              ],
            )
          : SizedBox(
              height: 320,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildMainBanner(isMobile: false),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      children: [
                        _sideBanner(
                          'Mechanical Tools',
                          'https://images.pexels.com/photos/162460/wrench-nuts-screws-chisel-162460.jpeg?auto=compress&cs=tinysrgb&w=400',
                        ),
                        const SizedBox(height: 12),
                        _sideBanner(
                          'Lubricant Deals',
                          'https://images.pexels.com/photos/4489749/pexels-photo-4489749.jpeg?auto=compress&cs=tinysrgb&w=400',
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }

  Widget _buildMainBanner({required bool isMobile}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: const DecorationImage(
          image: NetworkImage(
              'https://images.pexels.com/photos/190574/pexels-photo-190574.jpeg?auto=compress&cs=tinysrgb&w=800'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(isMobile ? 20 : 30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
              colors: [primaryBlue.withOpacity(0.9), Colors.transparent],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('PROFESSIONAL GRADE',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: isMobile ? 10 : 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2)),
            const SizedBox(height: 8),
            Text('RELIABLE PARTS\nFOR EVERY DRIVE',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: isMobile ? 22 : 32,
                    fontWeight: FontWeight.bold,
                    height: 1.1)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: primaryBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
              child: const Text('EXPLORE CATALOG',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }

  Widget _sideBanner(String title, String url, {double? height}) {
    Widget content = Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
      ),
      child: Container(
        alignment: Alignment.bottomLeft,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
              colors: [primaryBlue.withOpacity(0.8), Colors.transparent],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter),
        ),
        child: Text(title,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    // If height is not provided, we assume it's inside an Expanded/Column (desktop)
    return height == null ? Expanded(child: content) : Expanded(child: content);
  }
}
