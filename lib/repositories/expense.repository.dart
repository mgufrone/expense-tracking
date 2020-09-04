import 'dart:async';

import 'package:expense/common/storage.dart';
import 'package:expense/models/expense.dart';
import 'package:meta/meta.dart';

class ExpenseRepository {
  final CommonStorage<Expense> storage;
  ExpenseRepository({@required this.storage});

  create(Expense expense) async {
    final List<Expense> data = storage.getData() ?? [];
    storage.save(data..add(expense));
  }

  update(int index, Expense expense) {
    final List<Expense> data = storage.getData();
    data[index] = expense;
    storage.save(data);
  }

  Stream<List<Expense>> list() {
    return storage.getStream();
  }
}
