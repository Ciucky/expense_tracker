// main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_page.dart';
import 'screens/add_expense_page.dart';
import 'providers/expenses.dart';
import 'screens/edit_expense_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => Expenses(),
      child: MaterialApp(
        title: 'Expense Tracker',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomePage(),
        routes: {
          '/add-expense': (ctx) => AddExpensePage(),
          '/edit-expense': (ctx) => EditExpensePage(expenseId: ModalRoute.of(ctx)!.settings.arguments as String),
        },
      ),
    );
  }
}
