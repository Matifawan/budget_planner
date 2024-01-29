import 'package:budget_planner/app/modules/home/controllers/home_controller.dart';
import 'package:budget_planner/app/modules/home/views/forgot_password.dart';
import 'package:budget_planner/app/modules/home/views/home_page.dart';
import 'package:budget_planner/app/modules/home/views/signup_screen.dart';
import 'package:budget_planner/core/exception_file.dart';
import 'package:budget_planner/core/firebase_auth.dart';
import 'package:budget_planner/core/validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required HomeController controller});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late bool _isPasswordHidden = true;

  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  bool _isProcessing = false;

  Future<void> _initializeFirebase() async {
    try {
      await Firebase.initializeApp();

      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // ignore: use_build_context_synchronously
        _navigateToHomeScreen(context, user);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Firebase initialization failed: $e');
      }
    }
  }

  void _navigateToHomeScreen(BuildContext context, User user) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => HomePage(user: user),
      ),
    );
  }

  void _showError(String errorMessage,
      {bool showForgotPassword = false, bool emailNotFound = false}) {
    String finalErrorMessage = errorMessage;

    if (emailNotFound) {
      finalErrorMessage = "Email not found. Register your account to login.";
    }

    Get.snackbar(
      'Error',
      finalErrorMessage,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.deepPurple,
      colorText: Colors.white,
      onTap: (snack) {
        if (showForgotPassword) {
          Get.to(
            () => ForgotPasswordPage(),
            binding: BindingsBuilder(() {
              Get.put(AuthController());
            }),
          );
        }
      },
    );
  }

  void _showSuccess(String successMessage) {
    Get.snackbar(
      'Success',
      successMessage,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  InputDecoration _buildInputDecoration(String labelText) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
      labelText: labelText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(
          color: Colors.grey,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6.0),
        borderSide: const BorderSide(
          color: Colors.blueGrey,
        ),
      ),
    );
  }

  InputDecoration _buildPasswordInputDecoration() {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
      labelText: 'Password',
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(
          color: Colors.grey,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6.0),
        borderSide: const BorderSide(
          color: Colors.grey,
        ),
      ),
      suffixIcon: IconButton(
        icon: Icon(
          _isPasswordHidden ? Icons.visibility : Icons.visibility_off,
          color: Colors.grey,
        ),
        onPressed: () {
          setState(() {
            _isPasswordHidden = !_isPasswordHidden;
          });
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
  }

  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();
    _focusEmail.dispose();
    _focusPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusEmail.unfocus();
        _focusPassword.unfocus();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 48),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  child: Image.asset(
                    "assets/images/e4.png",
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.person,
                          color: Colors.green,
                          size: 40,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "Welcome back! User",
                          style: GoogleFonts.lato(
                            textStyle: Theme.of(context).textTheme.displayLarge,
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _emailTextController,
                        focusNode: _focusEmail,
                        validator: (value) =>
                            Validator.validateEmail(email: value ?? ''),
                        decoration: _buildInputDecoration("Email"),
                      ),
                      const SizedBox(height: 9),
                      TextFormField(
                        controller: _passwordTextController,
                        focusNode: _focusPassword,
                        obscureText: _isPasswordHidden,
                        validator: (value) =>
                            Validator.validatePassword(password: value ?? ''),
                        decoration: _buildPasswordInputDecoration(),
                      ),
                      const SizedBox(height: 24.0),
                      _isProcessing
                          ? const CircularProgressIndicator()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      _focusEmail.unfocus();
                                      _focusPassword.unfocus();

                                      if (_formKey.currentState!.validate()) {
                                        setState(() {
                                          _isProcessing = true;
                                        });

                                        try {
                                          User? user = await FirebaseAuthHelper
                                              .signInUsingEmailPassword(
                                            email: _emailTextController.text,
                                            password:
                                                _passwordTextController.text,
                                          );

                                          setState(() {
                                            _isProcessing = false;
                                          });

                                          if (user != null) {
                                            // User successfully signed in
                                            // ignore: use_build_context_synchronously
                                            _navigateToHomeScreen(
                                                context, user);
                                            _showSuccess(
                                                "Login successful. Welcome!");
                                          } else {
                                            // Check if email is registered
                                            bool emailExists =
                                                await FirebaseAuthHelper
                                                    .isEmailRegistered(
                                              _emailTextController.text,
                                            );

                                            if (emailExists) {
                                              // Email is registered, but password is incorrect
                                              throw WrongPasswordException();
                                            } else {
                                              // Email not found, ask the user to register
                                              _showError(
                                                  "Email not found. Register your account to login.",
                                                  emailNotFound: true);
                                            }
                                          }
                                        } on WrongPasswordException {
                                          // Handle wrong password separately
                                          _showError(
                                            "Incorrect password. Click 'Forgot Password?' to recover.",
                                            showForgotPassword: true,
                                          );
                                        } catch (e) {
                                          // Handle other exceptions
                                          _showError(
                                              "An error occurred. Please try again later.");
                                        }
                                      }
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.deepPurple),
                                    ),
                                    child: const Text(
                                      'Login',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 24.0),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const SignUpScreen(),
                                        ),
                                      );
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.deepPurple),
                                    ),
                                    child: const Text(
                                      'Register',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.topRight,
                        child: TextButton(
                          onPressed: () {
                            Get.to(
                              () => ForgotPasswordPage(),
                              binding: BindingsBuilder(() {
                                Get.put(AuthController());
                              }),
                            );
                          },
                          child: const Text('Forgot Password?'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
