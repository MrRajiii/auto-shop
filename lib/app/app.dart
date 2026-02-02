import 'package:auto_shop/services/authentication_service.dart';
import 'package:auto_shop/services/cart_view.dart';
import 'package:auto_shop/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:auto_shop/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:auto_shop/ui/views/checkout/order_success_view.dart';
import 'package:auto_shop/ui/views/home/home_view.dart';
import 'package:auto_shop/ui/views/startup/startup_view.dart'; // 1. Import your CartView
import 'package:auto_shop/services/cart_service.dart'; // 2. Import your CartService
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:auto_shop/ui/views/register/register_view.dart';
import 'package:auto_shop/ui/views/profile/profile_view.dart';
import 'package:auto_shop/ui/views/login/login_view.dart';
import 'package:auto_shop/ui/views/checkout/checkout_view.dart';
// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(page: HomeView, initial: true),
    MaterialRoute(page: StartupView),
    MaterialRoute(page: CartView), // 3. Add the CartView route
    MaterialRoute(page: RegisterView),
    MaterialRoute(page: ProfileView),
    MaterialRoute(page: LoginView),
    MaterialRoute(page: CheckoutView),
    MaterialRoute(page: OrderSuccessView),
// @stacked-route
  ],
  dependencies: [
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: CartService),
    LazySingleton(classType: AuthenticationService),
  ],
  locatorName: 'locator',
  locatorSetupName: 'setupLocator',
  bottomsheets: [
    StackedBottomsheet(classType: NoticeSheet),
    // @stacked-bottom-sheet
  ],
  dialogs: [
    StackedDialog(classType: InfoAlertDialog),
    // @stacked-dialog
  ],
)
class App {}
