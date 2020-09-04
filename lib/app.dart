import 'package:expense/common/helpers/lazyloader.dart';
import 'package:expense/common/storage.dart';
import 'package:expense/models/expense.dart';
import 'package:expense/repositories/expense.repository.dart';
import 'package:expense/repositories/expense_summary.repository.dart';
import 'package:expense/storage/no.op.storage.dart';
import 'package:expense/ui/page/expense.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  // This widget is the root of your application.
  App.bootstrap() {
    final CommonStorage<Expense> storage = NoOpStorage<Expense>();
    register<CommonStorage<Expense>>(() => storage..initialize());
    register<ExpenseRepository>(() => ExpenseRepository(storage: storage)
      ..create(
          Expense(title: 'Expense Title', amount: 10, date: DateTime.now()))
      ..create(
          Expense(title: 'Expense Title', amount: 10, date: DateTime.now()))
      ..create(
          Expense(title: 'Expense Title', amount: 10, date: DateTime.now()))
      ..create(
          Expense(title: 'Expense Title', amount: 10, date: DateTime.now()))
      ..create(Expense(
          title: 'Expense Title',
          amount: 5,
          date: DateTime.now().subtract(Duration(days: 1)))));
    register<ExpenseSummaryRepository>(
        () => ExpenseSummaryRepository(storage: storage));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ExpensePage(),
    );
  }
}
