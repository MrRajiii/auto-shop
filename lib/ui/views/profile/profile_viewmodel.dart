import 'package:auto_shop/app/app.locator.dart';
import 'package:auto_shop/app/app.router.dart';
import 'package:auto_shop/services/authentication_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../models/user_model.dart';

class ProfileViewModel extends ReactiveViewModel {
  final _authService = locator<AuthenticationService>();
  final _navigationService = locator<NavigationService>();

  // 1. Register the service so the ViewModel rebuilds when the user data changes
  @override
  List<ListenableServiceMixin> get listenableServices => [_authService];

  AppUser? get currentUser => _authService.currentUser;

  bool _isEditing = false;
  bool get isEditing => _isEditing;

  String _newAddress = '';
  String get newAddress => _newAddress;

  void toggleEdit() {
    _isEditing = !_isEditing;
    if (_isEditing) {
      _newAddress = currentUser?.address ?? '';
    }
    notifyListeners();
  }

  void setNewAddress(String value) {
    _newAddress = value;
  }

  Future<void> saveAddress() async {
    // Basic validation to prevent saving empty strings
    if (_newAddress.trim().isEmpty) {
      _isEditing = false;
      notifyListeners();
      return;
    }

    setBusy(true);

    // This updates the ReactiveValue in the service
    await _authService.updateUserAddress(_newAddress);

    _isEditing = false;
    setBusy(false);
    // setBusy automatically calls notifyListeners()
  }

  // UPDATED: Navigates to HomeView and wipes the navigation history
  void logout() {
    // We don't need to 'await' here anymore because the service
    // clears state instantly and Firebase works in the background.
    _authService.logout();

    // Navigate immediately
    _navigationService.clearStackAndShow(Routes.homeView);
  }
}
