import 'package:budget_planner/core/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordPage extends StatelessWidget {
  final auth = FirebaseAuth.instanceFor;
  final AuthController authController = Get.find<AuthController>();

  ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Enter your email to reset your password',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              controller: authController.emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(), // Add border
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                // Ensure the email is not empty
                if (authController.emailController.text.isNotEmpty) {
                  try {
                    authController.sendPasswordResetEmail();
                    Get.snackbar(
                      'Password Reset',
                      'A password reset email has been sent to ${authController.emailController.text}',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  } catch (e) {
                    if (kDebugMode) {
                      print('Failed to send password reset email: $e');
                    }
                    // Handle specific Firebase errors here
                    Get.snackbar(
                        'Error', 'Failed to send password reset email');
                  }
                } else {
                  // Show an error message if the email is empty
                  Get.snackbar('Error', 'Please enter your email');
                }
              },
              child: const Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}
