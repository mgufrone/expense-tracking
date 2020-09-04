import 'package:expense/models/expense.dart';
import 'package:expense/models/expense_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

class ExpenseBoardWidget extends StatelessWidget {
  static const double BAR_HEIGHT = 140;
  final ExpenseSummary summary;
  ExpenseBoardWidget({@required this.summary});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.withOpacity(0.1),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      height: BAR_HEIGHT + 60,
      child: Container(
        child: Row(
          children: List.generate((summary?.items ?? []).length, (index) {
            final item = summary.items[index];
            return Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      '${item.amount.round()}\$',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(fontSize: 12),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      child: Stack(
                        children: [
                          Container(
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.2),
                            height: BAR_HEIGHT,
                          ),
                          Positioned(
                            top: BAR_HEIGHT -
                                (BAR_HEIGHT * (item.amount / summary.max)),
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Container(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${item.label}',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(fontSize: 11),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
