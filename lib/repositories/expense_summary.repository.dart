import 'dart:async';

import 'package:expense/common/date_format.dart';
import 'package:expense/common/storage.dart';
import 'package:expense/models/expense.dart';
import 'package:expense/models/expense_summary.dart';
import 'package:meta/meta.dart';

class ExpenseSummaryRepository {
  final CommonStorage<Expense> storage;
  ExpenseSummaryRepository({@required this.storage});
  int isoWeekNumber(DateTime date) {
    int daysToAdd = DateTime.thursday - date.weekday;
    DateTime thursdayDate = daysToAdd > 0
        ? date.add(Duration(days: daysToAdd))
        : date.subtract(Duration(days: daysToAdd.abs()));
    int dayOfYearThursday = dayOfYear(thursdayDate);
    return 1 + ((dayOfYearThursday - 1) / 7).floor();
  }

  int dayOfYear(DateTime date) {
    return date.difference(DateTime(date.year, 1, 1)).inDays;
  }

  DateTime getDateByWeek(int year, int week) {
    final startYear = DateTime(year, 1, 1);
    final int inDays = (week * 7);
    return startYear.add(Duration(days: inDays));
  }

  FutureOr<ExpenseSummary> weeklySummary({
    @required DateTime start,
    @required DateTime end,
  }) async {
    final List<Expense> data = await storage.getData();
    final startWeek = this.isoWeekNumber(start);
    final weekDiffs = this.isoWeekNumber(end) - startWeek;
    final Map<String, List<Expense>> all = <String, List<Expense>>{};
    for (int i = 1; i < weekDiffs; i += 1) {
      final current = getDateByWeek(start.year, startWeek);
      final key = '${current.year}-${startWeek + i}';
      all[key] = [];
    }
    final List<ExpenseSummaryItem> summary = <ExpenseSummaryItem>[];
    data.forEach((element) {
      final key = '${element.date.year}-${this.isoWeekNumber(element.date)}';
      if (all.containsKey(key)) {
        all[key].add(element);
      } else {
        all[key] = [element];
      }
    });
    double max = 0;
    all.forEach((key, value) {
      final double totalAmount = value.fold(
          0, (previousValue, element) => previousValue += element.amount);
      max += totalAmount;
      final splitKey = key.split('-');
      final DateTime date =
          getDateByWeek(int.parse(splitKey.first), int.parse(splitKey.last));
      summary
          .add(ExpenseSummaryItem(amount: totalAmount, label: dateMonth(date)));
    });
    return ExpenseSummary(
      max: max,
      items: summary,
    );
  }

  FutureOr<ExpenseSummary> dailySummary({
    @required DateTime start,
    @required DateTime end,
  }) async {
    final List<Expense> data = await storage.getData();
    final dayDiffs = end.difference(start).inDays;
    final Map<String, List<Expense>> all = <String, List<Expense>>{};
    for (int i = 1; i < dayDiffs; i += 1) {
      final current = start.add(Duration(days: i));
      final key = formatDate(current);
      all[key] = [];
    }
    final List<ExpenseSummaryItem> summary = <ExpenseSummaryItem>[];
    data.forEach((element) {
      final key = formatDate(element.date);
      if (all.containsKey(key)) {
        all[key].add(element);
      } else {
        all[key] = [element];
      }
    });
    double max = 0;
    all.forEach((key, value) {
      final double totalAmount = value.fold(
          0, (previousValue, element) => previousValue += element.amount);
      max += totalAmount;
      summary.add(ExpenseSummaryItem(
          amount: totalAmount, label: dayOnly(DateTime.parse(key))));
    });
    return ExpenseSummary(
      max: max,
      items: summary,
    );
  }

  FutureOr<ExpenseSummary> generateSummary(
      {@required DateTime start,
      @required DateTime end,
      String period = 'daily'}) async {
    switch (period) {
      case 'weekly':
        return this.weeklySummary(start: start, end: end);
      case 'daily':
        return this.dailySummary(start: start, end: end);
    }
    return null;
  }
}
