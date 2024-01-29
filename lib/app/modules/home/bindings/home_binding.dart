import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import 'package:budget_planner/core/firebaseservice.dart'; // Import FirebaseService

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(
          FirebaseService()), // Provide FirebaseService instance here
    );
  }
}
