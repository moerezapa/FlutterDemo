// hold textfield
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './adaptive_flat_button.dart';

class NewTransaction extends StatefulWidget {

  /// NewTransaction is stateful to keep input from user in each form

  final Function addTx;

  NewTransaction(this.addTx);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate;

  void _submitData() {
    if (_amountController.text.isEmpty) {
      return;
    }
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);

    // print(titleController.text);
    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
      /**
       * return will stop function execution
       * then addTx function will not be executed
       */
    }
    widget.addTx(
      enteredTitle,
      enteredAmount,
      _selectedDate
    );

    // close bottom sheet
    Navigator.of(context).pop();
  }

  void _showDatePicker() {
    showDatePicker(
      context: context, // refers to the class property context
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime.now()
      /**
       * Future<>
       * Future is a class built into dart that 
       * allow us to create objects which will give us a value in the future
       */
    ) // then() is a function that is executed once the future resolves to a value
      .then((pickedDate) {
        if (pickedDate == null) {
          return;
        }
        setState(() {
          _selectedDate = pickedDate;
        });
        
      });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
          child: Card(
            elevation: 5,
            child: Container(
              padding: EdgeInsets.only(
                top: 10,
                left: 10,
                right: 10,
                // MediaQuery.of(context).viewInsets give info about that lapping into our layout
                bottom: MediaQuery.of(context).viewInsets.bottom + 10
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[

                  TextField(
                    decoration: InputDecoration(labelText: 'Title'),
                    controller: _titleController,
                    onSubmitted: (_) => _submitData(),
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Amount'),
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    onSubmitted: (_) => _submitData(), // _ indicate not to use it (?)
                  ),
                  Container(
                    height: 70,
                    child: Row(
                      children: <Widget>[
                        // expanded will take as much free space as it can get
                        Expanded(
                          child: Text(
                            _selectedDate == null ? 'No Date Chosen!' : 
                            'Picked Date: ${DateFormat.yMd().format(_selectedDate)}'
                          ),
                        ),
                        AdaptiveFlatButton('Choose Date', _showDatePicker)
                      ],
                    ),
                  ),
                  RaisedButton(
                    child: Text('Add Transaction'),
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).textTheme.button.color,
                    onPressed: _submitData,
                  )
                ],
              ),
            )
          ),
    );
  }
}