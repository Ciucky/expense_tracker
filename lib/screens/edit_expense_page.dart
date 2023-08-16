import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/expense.dart';
import '../providers/expenses.dart';

class EditExpensePage extends StatefulWidget {
  final String expenseId;

  EditExpensePage({required this.expenseId});

  @override
  _EditExpensePageState createState() => _EditExpensePageState();
}

class _EditExpensePageState extends State<EditExpensePage> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  String dropdownValue = 'Food';

  @override
  void initState() {
    super.initState();
    final existingExpense = Provider.of<Expenses>(context, listen: false).findById(widget.expenseId);
    _titleController.text = existingExpense.title;
    _amountController.text = existingExpense.amount.toString();
    _selectedDate = existingExpense.date;
    dropdownValue = existingExpense.category;
  }

  // ... (Reuse the date and time pickers from AddExpensePage)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Expense'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            DropdownButton<String>(
              value: dropdownValue,
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                });
              },
              items: <String>['Food', 'Transport', 'Entertainment', 'Others']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            // Add date and time pickers here
            ElevatedButton(
              child: Text('Update Expense'),
              onPressed: () {
                // Update the expense in the provider and database here
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      ),
    );
  }
}
