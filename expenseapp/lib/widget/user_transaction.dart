import 'package:flutter/material.dart';

import '../model/transaction.dart';
import './transaction_new.dart';

class UserTransaction extends StatefulWidget {
  UserTransaction({Key key}) : super(key: key);

  @override
  _UserTransactionState createState() => _UserTransactionState();
}

class _UserTransactionState extends State<UserTransaction> {
  final List<Transaction> _userTransactionList = [
    Transaction(
      id: 't1',
      title: 'New Shoes',
      amount: 79.9,
      date: DateTime.now()
    ),
    Transaction(
      id: 't2',
      title: 'New Shirt',
      amount: 83.12,
      date: DateTime.now()
    )
  ];

  void _addNewTransaction(String txTitle, double txAmount) {
    final newTx = Transaction(
      title: txTitle, 
      amount: txAmount,
      date: DateTime.now(),
      id: DateTime.now().toString()
    );

    setState(() {
      _userTransactionList.add(newTx);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
       children: <Widget>[
         NewTransaction(_addNewTransaction), // handle new transaction
        //  TransactionList(_userTransactionList) // display list of transaction
       ],
    );
  }
}