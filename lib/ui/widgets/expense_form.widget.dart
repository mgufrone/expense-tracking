import 'package:expense/common/date_format.dart';
import 'package:expense/common/validators.dart';
import 'package:expense/models/expense.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExpenseFormWidget extends StatefulWidget {
  final Expense expense;
  ExpenseFormWidget({this.expense});
  @override
  _ExpenseFormState createState() {
    return _ExpenseFormState();
  }
}

class _ExpenseFormState extends State<ExpenseFormWidget> {
  TextEditingController title = TextEditingController();
  TextEditingController amount = TextEditingController();
  DateTime date;
  bool isSubmitting = false;
  final _formKey = GlobalKey<FormState>();
  @override
  initState() {
    super.initState();
    if (widget.expense != null) {
      title.text = widget.expense.title;
      amount.text = widget.expense.amount.toString();
      date = widget.expense.date;
    }
  }

  submit() {
    setState(() {
      isSubmitting = true;
    });
    if (_formKey.currentState.validate() && date != null) {
      Navigator.pop(
        context,
        Expense(
          title: title.text,
          amount: double.parse(amount.text),
          date: date,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Select Date: "),
                        FlatButton(
                          child: Text(
                            date == null ? "Select Date" : formatDate(date),
                            style:
                                Theme.of(context).textTheme.bodyText1.copyWith(
                                      fontSize: 14,
                                      color: Theme.of(context).primaryColor,
                                    ),
                          ),
                          onPressed: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now()
                                  .subtract(const Duration(days: 30)),
                              lastDate: DateTime.now(),
                            );
                            if (date != null) {
                              setState(() {
                                this.date = date;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    date == null && isSubmitting
                        ? Container(
                            child: Text(
                              "Please select date",
                              style: TextStyle(color: Colors.red),
                            ),
                          )
                        : Container(),
                  ]),
                ),
                Container(
                  child: TextFormField(
                    controller: title,
                    validator: (value) {
                      final message = isEmpty(value) ?? textLimit(value, 150);
                      if (message != null) {
                        return 'Title $message';
                      }
                      return message;
                    },
                    decoration: InputDecoration(
                        hintText: "Enter the title here", labelText: "Title"),
                  ),
                ),
                Container(
                  child: TextFormField(
                    controller: amount,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                        hintText: "Enter the amount here", labelText: "Amount"),
                    validator: (value) {
                      final message = isEmpty(value) ?? isNumber(value);
                      if (message != null) {
                        return 'Amount $message';
                      }
                      return message;
                    },
                  ),
                ),
                Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      child: FlatButton(
                        onPressed: this.submit,
                        color: Theme.of(context).primaryColor,
                        textColor:
                            Theme.of(context).primaryTextTheme.button.color,
                        child: Text(
                            "${widget.expense != null ? 'Update' : 'Add'} Expense"),
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
