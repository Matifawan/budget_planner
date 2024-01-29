import 'package:logging/logging.dart';

class Validator {
  static final Logger _logger = Logger('Validator');

  static String? validateEmail({required String email}) {
    RegExp emailRegex = RegExp(
      r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
    );

    if (email.isEmpty) {
      _logger.warning('Email cannot be empty');
      return 'Email cannot be empty';
    } else if (!emailRegex.hasMatch(email)) {
      _logger.warning('Enter a valid email address');
      return 'Enter a valid email address';
    }

    _logger.info('Email is valid');
    return null; // Return null if there's no error
  }

  static String? validatePassword({required String password}) {
    if (password.isEmpty) {
      _logger.warning('Password cannot be empty');
      return 'Password cannot be empty';
    } else if (password.length < 8) {
      _logger.warning('Password must be at least 8 characters long');
      return 'Password must be at least 8 characters long';
    }

    _logger.info('Password is valid');
    return null; // Return null if there's no error
  }

  static String? validateName({required String name}) {
    if (name.isEmpty) {
      _logger.warning('Name cannot be empty');
      return 'Name cannot be empty';
    }

    _logger.info('Name is valid');
    return null; // Return null if there's no error
  }
}
