import 'package:budget_planner/app/modules/home/views/onboarding.dart';
import 'package:budget_planner/core/firebaseservice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final FirebaseService _firebaseService;

  final TextEditingController _budgetController = TextEditingController();
  final TextEditingController _expenseController = TextEditingController();
  final TextEditingController _savingController = TextEditingController();

  RxList<Budget> budgets = <Budget>[].obs;
  RxList<Expense> expenses = <Expense>[].obs;
  RxList<Saving> savings = <Saving>[].obs;

  HomeController(this._firebaseService);

  @override
  void onInit() {
    super.onInit();
    listenBudgetChanges('user1'); // Change 'user_id' to 'user1'
    listenExpenseChanges('user1'); // Change 'user_id' to 'user1'
    listenSavingChanges('user1'); // Change 'user_id' to 'user1'
  }

  double getBudgetAmount() {
    return double.tryParse(_budgetController.text) ?? 0.0;
  }

  double getExpenseAmount() {
    return double.tryParse(_expenseController.text) ?? 0.0;
  }

  double getSavingAmount() {
    return double.tryParse(_savingController.text) ?? 0.0;
  }

  Future<void> addBudget(String userId, double budgetAmount) async {
    if (budgetAmount > 0) {
      try {
        await _firebaseService.addBudget(userId, budgetAmount);
        _budgetController.clear();
      } catch (e) {
        // Handle error (e.g., show a snackbar)
        if (kDebugMode) {
          print('Error adding budget: $e');
        }
      }
    }
  }

  Future<void> addExpense(String userId, double expenseAmount) async {
    if (expenseAmount > 0) {
      try {
        await _firebaseService.addExpense(userId, expenseAmount);
        _expenseController.clear();
      } catch (e) {
        // Handle error (e.g., show a snackbar)
        if (kDebugMode) {
          print('Error adding expense: $e');
        }
      }
    }
  }

  Future<void> addSaving(String userId, double savingAmount) async {
    if (savingAmount > 0) {
      try {
        await _firebaseService.addSaving(userId, savingAmount);
        _savingController.clear();
      } catch (e) {
        // Handle error (e.g., show a snackbar)
        if (kDebugMode) {
          print('Error adding saving: $e');
        }
      }
    }
  }

  // Add similar methods for delete and edit operations...

  void listenBudgetChanges(String userId) {
    _firebaseService.listenBudgetChanges(userId).listen((event) {
      // Handle budget changes
      DataSnapshot snapshot = event.snapshot;
      Map<dynamic, dynamic>? values = snapshot.value as Map<dynamic, dynamic>?;

      if (values != null) {
        List<Budget> updatedBudgets = [];
        values.forEach((key, value) {
          updatedBudgets.add(Budget(id: key, amount: value['amount']));
        });

        budgets.assignAll(updatedBudgets);
      }
    });
  }

  void listenExpenseChanges(String userId) {
    _firebaseService.listenExpenseChanges(userId).listen((event) {
      // Handle expense changes
      DataSnapshot snapshot = event.snapshot;
      Map<dynamic, dynamic>? values = snapshot.value as Map<dynamic, dynamic>?;

      if (values != null) {
        List<Expense> updatedExpenses = [];
        values.forEach((key, value) {
          updatedExpenses.add(Expense(id: key, amount: value['amount']));
        });

        expenses.assignAll(updatedExpenses);
      }
    });
  }

  void listenSavingChanges(String userId) {
    _firebaseService.listenSavingChanges(userId).listen((event) {
      // Handle saving changes
      DataSnapshot snapshot = event.snapshot;
      Map<dynamic, dynamic>? values = snapshot.value as Map<dynamic, dynamic>?;

      if (values != null) {
        List<Saving> updatedSavings = [];
        values.forEach((key, value) {
          updatedSavings.add(Saving(id: key, amount: value['amount']));
        });

        savings.assignAll(updatedSavings);
      }
    });
  }

// Assuming HomeController is accessible in the scope where logout is called
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    // Instantiate HomeController before navigating and pass it to Onboarding
    var homeController = HomeController(
        FirebaseService()); // Adjust this based on your actual implementation
    Get.offAll(() => Onboarding(controller: homeController));
  }
}

class Budget {
  final String id;
  final double amount;

  Budget({required this.id, required this.amount});
}

class Expense {
  final String id;
  final double amount;

  Expense({required this.id, required this.amount});
}

class Saving {
  final String id;
  final double amount;

  Saving({required this.id, required this.amount});
}
