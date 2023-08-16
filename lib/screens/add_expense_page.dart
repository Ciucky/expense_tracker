// screens/add_expense_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/expenses.dart';
import '../models/expense.dart';

class AddExpensePage extends StatefulWidget {
  @override
  _AddExpensePageState createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  String dropdownValue = 'Food';
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null && _selectedDate != null) {
      setState(() {
        _selectedDate = DateTime(
          _selectedDate!.year,
          _selectedDate!.month,
          _selectedDate!.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Expense'),
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
            ElevatedButton(
              child: Text(_selectedDate == null ? 'Choose Date' : DateFormat.yMMMd().format(_selectedDate!)),
              onPressed: () => _selectDate(context),
            ),
            ElevatedButton(
              child: Text(_selectedDate == null ? 'Choose Time' : DateFormat.jm().format(_selectedDate!)),
              onPressed: () => _selectTime(context),
            ),
            ElevatedButton(
              child: Text('Add Expense'),
              onPressed: () {
                Provider.of<Expenses>(context, listen: false).addExpense(
                  Expense(
                    id: DateTime.now().toString(),
                    title: _titleController.text,
                    amount: double.parse(_amountController.text),
                    category: dropdownValue,
                    date: _selectedDate ?? DateTime.now(),
                  ),
                );
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      ),
    );
  }
}
