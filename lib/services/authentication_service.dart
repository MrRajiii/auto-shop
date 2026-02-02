import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:stacked/stacked.dart';
import '../app/app.locator.dart';
import '../models/user_model.dart';
import '../models/cart_item.dart';
import '../models/product_model.dart';
import '../services/cart_service.dart';

class AuthenticationService with ListenableServiceMixin {
  final fb.FirebaseAuth _firebaseAuth = fb.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Access the CartService to clear it on logout or load it on login
  final _cartService = locator<CartService>();

  final _currentUser = ReactiveValue<AppUser?>(null);
  AppUser? get currentUser => _currentUser.value;
  bool get hasUser => _currentUser.value != null;

  AuthenticationService() {
    listenToReactiveValues([_currentUser]);

    _firebaseAuth.authStateChanges().listen((fb.User? user) async {
      if (user != null) {
        print("DEBUG: Auth detected user ${user.uid}. Fetching profile...");

        try {
          final doc = await _firestore.collection('users').doc(user.uid).get();
          final data = doc.data();

          _currentUser.value = AppUser(
            id: user.uid,
            email: user.email ?? '',
            fullName: data?['fullName'] ?? user.displayName ?? "User",
            address: data?['address'] ?? '',
          );

          // 2. FETCH SAVED CART FROM FIRESTORE
          await _fetchAndLoadUserCart(user.uid);
        } catch (e) {
          print("DEBUG: Profile fetch error: $e");
        }
      } else {
        print("DEBUG: No user detected. Clearing local cart.");
        _currentUser.value = null;
        _cartService.clearCart();
      }
      notifyListeners();
    });
  }

  // Helper method to sync the cart from the cloud to the local CartService
  Future<void> _fetchAndLoadUserCart(String uid) async {
    try {
      print("DEBUG: Attempting to fetch cart from 'carts/$uid'");
      final cartDoc = await _firestore.collection('carts').doc(uid).get();

      if (cartDoc.exists && cartDoc.data() != null) {
        final List<dynamic> itemsData = cartDoc.data()!['items'] ?? [];

        List<CartItem> savedItems = itemsData.map((item) {
          final Map<String, dynamic> specsRaw = item['specifications'] ?? {};
          final Map<String, String> specs = specsRaw.map(
            (key, value) => MapEntry(key, value.toString()),
          );

          return CartItem(
            quantity: item['quantity'] ?? 1,
            product: Product(
              id: item['productId'] ?? '',
              name: item['name'] ?? 'Unknown',
              price: item['price']?.toString() ?? '0',
              imageUrls: [item['imageUrl'] ?? ''],
              category: item['category'] ?? '',
              description: item['description'] ?? '',
              specifications: specs,
            ),
          )..isSelected = item['isSelected'] ?? true;
        }).toList();

        _cartService.loadCart(savedItems);
        print(
            "DEBUG: Cart loaded successfully with ${savedItems.length} items.");
      } else {
        print("DEBUG: No existing cart document found for this user.");
      }
    } catch (e) {
      // If this prints 'permission-denied', double-check your 'Rules' tab in Firebase
      print("Error fetching user cart: $e");
    }
  }

  Future<bool> login({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return true;
    } catch (e) {
      print("DEBUG: Login failure: $e");
      return false;
    }
  }

  Future<bool> registerWithEmail({
    required String email,
    required String password,
    required String fullName,
    String? address,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      final uid = credential.user!.uid;
      await credential.user?.updateDisplayName(fullName);

      await _firestore.collection('users').doc(uid).set({
        'fullName': fullName,
        'email': email,
        'address': address ?? '',
        'createdAt': FieldValue.serverTimestamp(),
      });

      _currentUser.value = AppUser(
        id: uid,
        fullName: fullName,
        email: email,
        address: address ?? '',
      );

      notifyListeners();
      return true;
    } catch (e) {
      print("DEBUG: Registration failure: $e");
      return false;
    }
  }

  Future<void> updateUserAddress(String newAddress) async {
    if (_currentUser.value != null) {
      final uid = _currentUser.value!.id;
      await _firestore.collection('users').doc(uid).update({
        'address': newAddress,
      });

      _currentUser.value = AppUser(
        id: _currentUser.value!.id,
        fullName: _currentUser.value!.fullName,
        email: _currentUser.value!.email,
        address: newAddress,
      );
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _currentUser.value = null;
    _cartService.clearCart();
    notifyListeners();
    _firebaseAuth.signOut().catchError((e) => print("Logout error: $e"));
  }
}
