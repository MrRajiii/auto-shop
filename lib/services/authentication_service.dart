import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:stacked/stacked.dart';
import '../models/user_model.dart';

class AuthenticationService with ListenableServiceMixin {
  final fb.FirebaseAuth _firebaseAuth = fb.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final _currentUser = ReactiveValue<AppUser?>(null);
  AppUser? get currentUser => _currentUser.value;
  bool get hasUser => _currentUser.value != null;

  AuthenticationService() {
    listenToReactiveValues([_currentUser]);

    _firebaseAuth.authStateChanges().listen((fb.User? user) async {
      if (user != null) {
        final doc = await _firestore.collection('users').doc(user.uid).get();
        final data = doc.data();

        _currentUser.value = AppUser(
          id: user.uid,
          email: user.email ?? '',
          fullName: data?['fullName'] ?? user.displayName ?? "User",
          address: data?['address'] ?? '',
        );
      } else {
        _currentUser.value = null;
      }
      // CRITICAL: Ensure listeners are notified after the async fetch
      notifyListeners();
    });
  }

  Future<bool> login({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      // AuthStateChanges listener above will trigger the UI update
      return true;
    } catch (e) {
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
    await _firebaseAuth.signOut();
    _currentUser.value = null;
    notifyListeners();
  }
}
