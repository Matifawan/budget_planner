import 'package:flutter/material.dart';

class ProfileSummary extends StatelessWidget {
  final double totalBudget;
  final double totalExpenses;

  const ProfileSummary(
      {super.key, required this.totalBudget, required this.totalExpenses});

  @override
  Widget build(BuildContext context) {
    double totalSaving = totalBudget - totalExpenses;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Total Budget: \$${totalBudget.toString()}'),
          Text('Total Expenses: \$${totalExpenses.toString()}'),
          Text('Total Saving: \$${totalSaving.toString()}'),
        ],
      ),
    );
  }
}
