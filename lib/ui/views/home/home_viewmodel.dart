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
      name: 'Full Synthetic Oil 5W-40 Premium Protection',
      price: '1,250',
      category: 'Oil',
      isFeatured: true,
      description:
          'Engineered for high-performance engines to provide extreme temperature protection.',
      specifications: {
        'Viscosity': '5W-40',
        'Volume': '4 Liters',
        'Engine Type': 'Gasoline & Diesel',
        'Certification': 'API SN/CF',
        'Performance': 'Extreme Temp Guard'
      },
      imageUrls: [
        'https://images.pexels.com/photos/2051034/pexels-photo-2051034.jpeg'
      ],
    ),
    Product(
      id: '2',
      name: 'High Performance Ceramic Brake Pads',
      price: '850',
      category: 'Brakes',
      isFeatured: false,
      description: 'Upgrade your stopping power with low-dust ceramic formula.',
      specifications: {
        'Material': 'Premium Ceramic',
        'Compatibility': 'Universal Fit V.1'
      },
      imageUrls: [
        'https://images.pexels.com/photos/5634621/pexels-photo-5634621.jpeg'
      ],
    ),
    Product(
      id: '3',
      name: 'Heavy Duty Tool Set',
      price: '2,450',
      category: 'Tools',
      isFeatured: true,
      description:
          'A comprehensive 82-piece tool kit made from Chrome Vanadium Steel.',
      specifications: {
        'Pieces': '82 Items',
        'Material': 'Chrome Vanadium Steel'
      },
      imageUrls: [
        'https://images.pexels.com/photos/162460/wrench-nuts-screws-chisel-162460.jpeg'
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
