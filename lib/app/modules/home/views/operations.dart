import 'package:firebase_database/firebase_database.dart';

class Operations {
  // List to store operation log
  List<String> operationLog = [];

  // Method to update user data and log the operation
  void updateUserData({
    required String userId,
    required int budget,
    required int expenses,
    required int savings,
  }) {
    // Update data in Firebase
    updateUserDataInFirebase(userId, budget, expenses, savings);

    // Add entry to operation log
    String logEntry =
        'Updated Data: Budget=$budget, Expenses=$expenses, Savings=$savings';
    operationLog.add(logEntry);
  }

  // Method to get user data
  Future<Map<String, dynamic>> fetchUserData(String userId) async {
    DatabaseReference userRef =
        // ignore: deprecated_member_use
        FirebaseDatabase.instance.reference().child('users').child(userId);
    DataSnapshot snapshot = (await userRef.once()) as DataSnapshot;

    // Explicitly cast the value to Map<dynamic, dynamic>
    Map<dynamic, dynamic>? dataMap = snapshot.value as Map<dynamic, dynamic>?;

    // Convert Map<dynamic, dynamic> to Map<String, dynamic>
    Map<String, dynamic> userData = Map<String, dynamic>.from(dataMap ?? {});

    return userData;
  }

  // Method to update user data in Firebase
  void updateUserDataInFirebase(
      String userId, int budget, int expenses, int savings) {
    DatabaseReference userRef =
        // ignore: deprecated_member_use
        FirebaseDatabase.instance.reference().child('users').child(userId);
    userRef.update({
      'budget': budget,
      'expenses': expenses,
      'savings': savings,
    });
  }
}
