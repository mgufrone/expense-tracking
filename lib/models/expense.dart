import 'package:meta/meta.dart';

class Expense {
  final String title;
  final double amount;
  final DateTime date;

  Expense({@required this.title, @required this.date, @required this.amount});
}
