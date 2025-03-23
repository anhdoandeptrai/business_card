import 'package:card_app/app/view/login_signin/wellcome_screen.dart';
import 'package:get/get.dart';
import '../view/card/home_view.dart';
import '../view/card/create_card_view.dart';
import '../view/contact/contact_list_view.dart';
import '../view/contact/enter_card_code_view.dart';
import '../view/contact/scan_qr_code_view.dart';
import '../view/login_signin/forgot_password_screen.dart';
import '../view/login_signin/login_screen.dart';
import '../view/login_signin/register_screen.dart';
import '../view/login_signin/opt_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(name: AppRoutes.home, page: () => HomeView()),
    GetPage(name: AppRoutes.createCard, page: () => CreateCardView()),
    GetPage(name: AppRoutes.welcome, page: () => WelcomeScreen()),
    GetPage(name: AppRoutes.login, page: () => LoginScreen()),
    GetPage(name: AppRoutes.register, page: () => RegisterScreen()),
    GetPage(name: AppRoutes.otp, page: () => OtpScreen()),
    GetPage(name: AppRoutes.forgotPassword, page: () => ForgotPasswordScreen()),
    GetPage(name: AppRoutes.contactList, page: () => ContactListView()),
    GetPage(name: AppRoutes.enterCardCode, page: () => EnterCardCodeView()),
    GetPage(name: AppRoutes.scanQRCode, page: () => ScanQRCodeView()),
  ];
}
