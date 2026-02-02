import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../models/product_model.dart';
import '../../../services/cart_service.dart';
import '../../../services/authentication_service.dart';
import '../../../models/user_model.dart';

class HomeViewModel extends ReactiveViewModel {
  final _navigationService = locator<NavigationService>();
  final _cartService = locator<CartService>();
  final _authService = locator<AuthenticationService>();

  String _searchQuery = '';
  String _selectedCategory = 'All';

  // Getters for the View to access private state
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;

  // Auth Getters
  bool get isLoggedIn => _authService.hasUser;
  AppUser? get currentUser => _authService.currentUser;

  @override
  List<ListenableServiceMixin> get listenableServices =>
      [_cartService, _authService];

  // Logic to filter products based on search query AND category
  List<Product> get filteredProducts {
    return products.where((product) {
      final matchesSearch =
          product.name.toLowerCase().contains(searchQuery.toLowerCase());

      final matchesCategory =
          _selectedCategory == 'All' || product.category == _selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  void setCategory(String category) {
    if (_selectedCategory == category) {
      _selectedCategory = 'All';
    } else {
      _selectedCategory = category;
    }
    notifyListeners();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  // --- MOCK DATA ---
  List<Product> products = [
    Product(
      id: '1',
      name:
          'Hydraulic Floor Jack 2Ton Crocodile Jack Low Lifting Quick Pump Lifting Car',
      price: '1,999',
      category: 'Tools',
      isFeatured: true,
      description:
          '2T horizontal jack, for home use, or for auto repair shops.\nHydraulics use the liquid power that is taken from the applied force to move certain things using the same force. In terms of the floor jack, the liquid pressure is added when we push the handle downwards while the jack lifts the vehicle upwards. When a person lifts the jacks handle, the pump piston moves upwards.',
      specifications: {
        'Stock': 'IN STOCK',
        'Brand': 'Seametal',
        'Condition': 'Brand New',
      },
      imageUrls: [
        'https://down-ph.img.susercontent.com/file/ph-11134207-7rasc-m2m0vb5lcv7jfa.webp',
        'https://down-ph.img.susercontent.com/file/ph-11134207-7rasg-m2m0vb5vcglb77.webp',
        'https://down-ph.img.susercontent.com/file/ph-11134207-7ras9-m2m0vb5le9yq18.webp',
      ],
    ),
    Product(
      id: '2',
      name: 'AUTOMATIC TRANSMISSION FLUID ATF DW-1 / ATF DW1 1L HONDA GENUINE',
      price: '499',
      category: 'Oil',
      isFeatured: false,
      description:
          'AUTOMATIC TRANSMISSION FLUID ATF DW-1 / ATF DW1 1L HONDA GENUINE PART NO: 08268-P99-1BS1/100% ORIGINAL',
      specifications: {'Brand': 'Honda', 'Stock': 'IN STOCK'},
      imageUrls: [
        'https://down-ph.img.susercontent.com/file/ph-11134207-7r98q-lw2w0sfnwkck00.webp',
        'https://down-ph.img.susercontent.com/file/ph-11134207-7r98u-lw2w0sfo26mc6a.webp',
        'https://down-ph.img.susercontent.com/file/ph-11134207-7r98s-lw2w0sfo0s1w53.webp',
      ],
    ),
    Product(
      id: '3',
      name:
          'Toyota AT FLUID T-IV 4L ATF Automatic Transmission Oil For Toyota Innova Fortuner Hilux Car 4Liters',
      price: '1,499',
      category: 'Oil',
      isFeatured: true,
      description:
          'This fluid is designed to keep your vehicle running at its best. Enjoy long-lasting protection against wear and corrosion, thanks to advanced additives that help maintain the health of your transmission system.',
      specifications: {
        'Brand': 'Toyota',
        'Stock': 'IN STOCK',
        'Capacity': '4L',
      },
      imageUrls: [
        'https://down-ph.img.susercontent.com/file/ph-11134207-7r991-lp3mefdle34f85.webp',
        'https://down-ph.img.susercontent.com/file/ph-11134207-7ras9-ma8a76agaf3i1d.webp',
        'https://down-ph.img.susercontent.com/file/sg-11134253-81zu9-mim62wolz01sd3.webp',
      ],
    ),
  ];

  // --- NAVIGATION ---
  void viewCart() {
    _navigationService.navigateToCartView();
  }

  void navigateToLogin() {
    _navigationService.navigateToLoginView();
  }

  void navigateToProfile() => _navigationService.navigateToProfileView();

  // --- CART LOGIC ---
  int get cartItemCount => _cartService.items.length;

  // FIXED: Added {String? userId} as a named parameter to fix the compilation error
  // and passed it to the CartService to enable Firestore synchronization.
  void addToCart(Product product, int quantity, {String? userId}) {
    _cartService.addToCart(product, quantity, userId: userId);
    notifyListeners();
  }
}
