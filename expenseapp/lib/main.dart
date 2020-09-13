// import this library to 
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './widget/chart.dart';
import './widget/transaction_new.dart';
import './model/transaction.dart';
import './widget/transaction_list.dart';

void main() {
  // prevent to landscape mode
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown
  // ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
                title: 'Personal Expenses',
                theme: ThemeData(
                  primarySwatch: Colors.purple,
                  accentColor: Colors.amber,
                  errorColor: Colors.red,
                  fontFamily: 'Quicksand',
                  // font for rest of the apps
                  textTheme: ThemeData.light().textTheme.copyWith(
                    title: TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
                    button: TextStyle( color: Colors.white ),
                  ),
                  // font for appbar
                  appBarTheme: AppBarTheme(
                    textTheme: ThemeData.light().textTheme.copyWith(
                      title: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                      ),
                    )
                  ),
                  // font for button
                  buttonTheme: ButtonThemeData(
                    
                  )
                ),
                home: MyHomePage(),
            );
  }
}

class MyHomePage extends StatefulWidget {
  
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final List<Transaction> _userTransactionList = [
    // Transaction(
    //   id: 't1',
    //   title: 'New Shoes',
    //   amount: 79.9,
    //   date: DateTime.now()
    // ),
    // Transaction(
    //   id: 't2',
    //   title: 'New Shirt',
    //   amount: 83.12,
    //   date: DateTime.now()
    // )
  ];

  bool _showCart = false;

  List<Transaction> get _recentTransactions {

    /**
     * where() allows to run a function on every item in a list
     * if that function return true, the item is kept in a newly returned list
     * in here, we create a function to get every element
     */
    return _userTransactionList.where((tx) {
      // substract 7 day from today
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7)
        )
      );
    }).toList(); // where() need list as argument
  }

  // add transactions
  void _addNewTransaction(String txTitle, double txAmount, DateTime pickedDate) {
    final newTx = Transaction(
      title: txTitle, 
      amount: txAmount,
      // date: DateTime.now(),
      date: pickedDate,
      id: DateTime.now().toString()
    );

    setState(() {
      _userTransactionList.add(newTx);
    });
  }
  void _addNewTransactionForm(BuildContext buildContext) {
    showModalBottomSheet(
      context: buildContext,
      builder: (_) {
        // return widget that want to be shown inside modal sheet
        //return NewTransaction(_addNewTransaction);

        return GestureDetector(
          onTap: () {},
          child: NewTransaction(_addNewTransaction),
          behavior: HitTestBehavior.opaque, // avoid sheet closed when tapped (?)
        );
      });
  }

  // delete transactions
  void _deleteTransaction(String id) {
    setState(() {
      _userTransactionList.removeWhere((tx) => tx.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    
    
    // add PreferredSizeWidget to get preferredSize property 
    final PreferredSizeWidget appBar = Platform.isAndroid 
                    ? AppBar(
                        title: Text(
                          'Personal Expenses',
                          style: TextStyle( fontFamily: 'OpenSans'),
                        ),
                        actions: <Widget>[
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () => _addNewTransactionForm(context),
                          )
                        ],
                      )
                      : CupertinoNavigationBar(
                        middle: Text(
                          'Personal Expenses',
                          style: TextStyle( fontFamily: 'OpenSans' )
                        ),
                        trailing: Row(
                          /**
                           * by default, row takes all width that can take
                           */
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            // IconButton cuman buat material on Android
                            GestureDetector(
                              child: Icon( CupertinoIcons.add ),
                              onTap: () => _addNewTransactionForm(context),
                            )
                          ],
                        ),
                      ) ;

    final txListWidget = Container(
                  height: (mediaQuery.size.height - 
                            appBar.preferredSize.height - 
                            mediaQuery.padding.top) * 0.7,
                  child: TransactionList(_userTransactionList, _deleteTransaction)
                );

    /**
     * use SafeArea to make sure pageBody not overlapping status bar and navigation bar button (?)
     * and make sure that everything is positioned within the boundaries or
     * moved down a bit, moved up a bit
     */
    final pageBody = SafeArea(
                  child: SingleChildScrollView(
                      // SingleChildScrollView only working on body element
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[  
                          if (isLandscape) Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Show Chart', 
                                style: Theme.of(context).textTheme.title,
                              ),
                              Switch.adaptive(
                                activeColor: Theme.of(context).accentColor,
                                value: _showCart, 
                                onChanged: (val) {
                                  setState(() {
                                    _showCart = val;
                                  });
                                }
                              )
                            ],
                          ),
                          // display chart
                          if (!isLandscape) Container(
                            /**
                             * mediaQuery.size gives you access
                             * where you have a height and width that give you
                             * the device height and width 
                             * akan dikali sama 0 atau 1
                             * 1 : jika ingin full height
                             * 0 : jika ingin ngambil 0 height
                             */

                            /**
                             * appBar.preferredSize.height give appbar height
                             * deduct the height of appbar
                             * mediaQuery.size.height - 
                                      appBar.preferredSize.height berarti:
                                      tinggi app dikurangi tinggi appbar
                            */

                            /**
                             * mediaQuery.padding gives information about
                             * status bar keknya (?)
                             */
                            height: (mediaQuery.size.height - 
                                      appBar.preferredSize.height - 
                                      mediaQuery.padding.top) * 0.3,
                            child: Chart(_recentTransactions)
                          ),
                          
                          if (!isLandscape) txListWidget,
                          
                          if (isLandscape) _showCart ?  Container(
                            height: (mediaQuery.size.height - 
                                      appBar.preferredSize.height - 
                                      mediaQuery.padding.top) * 0.3,
                            child: Chart(_recentTransactions)
                          )
                            : txListWidget
                            
                        ],
                      ),
                  )
                );
    

    return Platform.isAndroid ? 
      Scaffold(

        appBar: appBar,

        body: pageBody,

        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

        floatingActionButton: Platform.isIOS ? 
          Container()
          : FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () => _addNewTransactionForm(context)
          ),
      )
      : CupertinoPageScaffold(
        child: pageBody,
        navigationBar: appBar,
      );
  }
}
