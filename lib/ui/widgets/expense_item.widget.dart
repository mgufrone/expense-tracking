import 'package:expense/common/date_format.dart';
import 'package:expense/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ExpenseItemWidget extends StatelessWidget {
  final Expense expense;
  final Function onPressed;
  ExpenseItemWidget({@required this.expense, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: this.onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          children: [
            Container(
              child: Text(
                "\$",
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(fontSize: 18),
              ),
              margin: EdgeInsets.only(right: 50),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      expense.title,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Text(formatDate(expense.date)),
              constraints: BoxConstraints(
                minWidth: 60,
              ),
            ),
            Container(
              constraints: BoxConstraints(
                minWidth: 30,
              ),
              child: Text(
                '\$${expense.amount.round().toString()}',
                textAlign: TextAlign.end,
              ),
              margin: EdgeInsets.only(left: 50),
            ),
          ],
        ),
      ),
    );
  }
}
