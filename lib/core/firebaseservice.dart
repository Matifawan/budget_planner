import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  // ignore: deprecated_member_use
  final DatabaseReference _database = FirebaseDatabase.instance.reference();

  Future<void> addBudget(String userId, double budgetAmount) async {
    await _database.child('users/$userId/budgets').push().set({
      'amount': budgetAmount,
      'timestamp': ServerValue.timestamp,
    });
  }

  Future<void> addExpense(String userId, double expenseAmount) async {
    await _database.child('users/$userId/expenses').push().set({
      'amount': expenseAmount,
      'timestamp': ServerValue.timestamp,
    });
  }

  Future<void> addSaving(String userId, double savingAmount) async {
    await _database.child('users/$userId/savings').push().set({
      'amount': savingAmount,
      'timestamp': ServerValue.timestamp,
    });
  }

  Future<void> deleteBudget(String userId, String budgetId) async {
    await _database.child('users/$userId/budgets/$budgetId').remove();
    // Add any additional logic needed for deletion
  }

  Stream<DatabaseEvent> listenBudgetChanges(String userId) {
    return _database.child('users/$userId/budgets').onValue;
  }

  Stream<DatabaseEvent> listenExpenseChanges(String userId) {
    return _database.child('users/$userId/expenses').onValue;
  }

  Stream<DatabaseEvent> listenSavingChanges(String userId) {
    return _database.child('users/$userId/savings').onValue;
  }
}
