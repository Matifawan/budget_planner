import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:get/get.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.initial, // Corrected line
      getPages: AppPages.routes,
      theme: ThemeData(
        // Add your desired theme configuration here
        primarySwatch: Colors.deepPurple,
        // Other theme properties...
      ),
      debugShowCheckedModeBanner: false, // Set banner to false
    ),
  );
}
