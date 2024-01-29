import 'package:budget_planner/app/modules/home/controllers/home_controller.dart';
import 'package:budget_planner/core/firebaseservice.dart';
import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/onboarding.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.home;

  static final routes = [
    GetPage(
      name: _Paths.home,
      page: () => Onboarding(
        controller: HomeController(
            FirebaseService()), // Provide FirebaseService instance here
        key: null,
      ),
      binding: HomeBinding(),
    ),
  ];
}
