// screens/home_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expenses.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  Future<bool> _confirmDelete(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Confirm Deletion'),
        content: Text('Do you really want to delete this expense?'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(ctx).pop(false);
            },
          ),
          TextButton(
            child: Text('Delete'),
            onPressed: () {
              Navigator.of(ctx).pop(true);
            },
          ),
        ],
      ),
    ) ?? false;  // Return false if user taps outside the dialog
  }

  @override
  Widget build(BuildContext context) {
    final expensesData = Provider.of<Expenses>(context);
    final expenses = expensesData.items;
    final dailyTotals = expensesData.dailyTotal;

    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Tracker'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed('/add-expense');
            },
          ),
        ],
      ),
      body:
      ListView.builder(
        itemCount: expenses.length,
        itemBuilder: (ctx, i) {
          final expense = expenses[i];
          return ListTile(
            title: Text(expense.title),
            subtitle: Text('${expense.category} - ${DateFormat.yMMMd().add_jm().format(expense.date)}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('£${expense.amount.toStringAsFixed(2)}'),
                SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      '/edit-expense',
                      arguments: expense.id,
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    bool shouldDelete = await _confirmDelete(context);
                    if (shouldDelete) {
                      Provider.of<Expenses>(context, listen: false).deleteExpense(expense.id);
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
