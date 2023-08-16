// providers/expenses.dart

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';
import '../helpers/db_helper.dart';

class Expenses with ChangeNotifier {
  List<Expense> _items = [];

  List<Expense> get items {
    return [..._items];
  }

  Map<String, double> get dailyTotal {
    Map<String, double> totals = {};

    _items.forEach((expense) {
      String key = DateFormat.yMMMd().format(expense.date);
      if (totals.containsKey(key)) {
        totals[key] = (totals[key] ?? 0) + expense.amount;
      } else {
        totals[key] = expense.amount;
      }
    });

    return totals;
  }


  void addExpense(Expense expense) {
    _items.add(expense);
    notifyListeners();

    DBHelper.insert('expenses', {
      'id': expense.id,
      'title': expense.title,
      'amount': expense.amount,
      'date': expense.date.toIso8601String(),
      'category': expense.category,
    });
  }

  void loadExpenses() async {
    final dataList = await DBHelper.getData('expenses');
    _items = dataList
        .map(
          (item) => Expense(
        id: item['id'],
        title: item['title'],
        amount: item['amount'],
        date: DateTime.parse(item['date']),
        category: item['category'],
      ),
    )
        .toList();
    notifyListeners();
  }

  void deleteExpense(String id) {
    _items.removeWhere((expense) => expense.id == id);
    notifyListeners();
    DBHelper.delete('expenses', id);
  }

  void updateExpense(String id, Expense newExpense) {
    final expenseIndex = _items.indexWhere((expense) => expense.id == id);
    if (expenseIndex >= 0) {
      _items[expenseIndex] = newExpense;
      notifyListeners();

      // Update the database
      DBHelper.update('expenses', {
        'id': newExpense.id,
        'title': newExpense.title,
        'amount': newExpense.amount,
        'date': newExpense.date.toIso8601String(),
        'category': newExpense.category,
      });
    }
  }

  Expense findById(String id) {
    return _items.firstWhere((expense) => expense.id == id);
  }

}
