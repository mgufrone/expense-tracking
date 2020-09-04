import 'package:expense/common/helpers/lazyloader.dart';
import 'package:expense/models/expense.dart';
import 'package:expense/models/expense_summary.dart';
import 'package:expense/repositories/expense.repository.dart';
import 'package:expense/repositories/expense_summary.repository.dart';
import 'package:expense/ui/widgets/expense_board.widget.dart';
import 'package:expense/ui/widgets/expense_form.widget.dart';
import 'package:expense/ui/widgets/expense_item.widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExpensePage extends StatelessWidget {
  static const DAYS_DURATION = 7;
  final ExpenseRepository expenseRepository;
  final ExpenseSummaryRepository expenseSummaryRepository;
  ExpensePage()
      : expenseRepository = resolve<ExpenseRepository>(),
        expenseSummaryRepository = resolve<ExpenseSummaryRepository>();

  Widget emptyExpense() {
    return Center(
      child: Text("No expenses recorded. Try add a new one"),
    );
  }

  editExpense(BuildContext context, int index, Expense item) async {
    final result = await showModalBottomSheet<Expense>(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        child: Wrap(
          children: [
            ExpenseFormWidget(
              expense: item,
            ),
          ],
        ),
      ),
    );
    if (result != null) {
      expenseRepository.update(index, result);
    }
  }

  addExpense(BuildContext context) async {
    final result = await showModalBottomSheet<Expense>(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        child: Wrap(
          children: [
            ExpenseFormWidget(),
          ],
        ),
      ),
    );
    if (result != null) {
      expenseRepository.create(result);
    }
  }

  Widget buildBoard() {
    return FutureBuilder<ExpenseSummary>(
        initialData: null,
        future: expenseSummaryRepository.generateSummary(
            start: DateTime.now().subtract(Duration(days: DAYS_DURATION)),
            end: DateTime.now(),
            period: 'daily'),
        builder: (context, snapshot) {
          return ExpenseBoardWidget(summary: snapshot.data);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text("Expenses"),
      ),
      body: StreamBuilder<List<Expense>>(
        stream: expenseRepository.list(),
        initialData: [],
        builder: (context, snapshot) {
          if (snapshot.data == null || snapshot.data.length == 0) {
            return this.emptyExpense();
          }
          return ListView.builder(
            itemBuilder: (context, int index) {
              if (index == 0) {
                return this.buildBoard();
              }
              final item = snapshot.data[index - 1];
              return ExpenseItemWidget(
                expense: item,
                onPressed: () => this.editExpense(context, index - 1, item),
              );
            },
            itemCount: snapshot.data.length + 1,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => this.addExpense(context),
        tooltip: 'Add',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
