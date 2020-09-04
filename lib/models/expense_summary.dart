import 'package:meta/meta.dart';

class ExpenseSummary {
  final double max;
  final List<ExpenseSummaryItem> items;
  ExpenseSummary({@required this.max, @required this.items});
}

class ExpenseSummaryItem {
  final double amount;
  final String label;
  ExpenseSummaryItem({@required this.label, @required this.amount});
}
