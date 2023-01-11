import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expense_ui/models/transaction.dart';
import 'package:flutter_expense_ui/widgets/chart.dart';
import 'package:flutter_expense_ui/widgets/new_transaction.dart';
import 'package:flutter_expense_ui/widgets/transaction_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoApp(
        title: 'Personal Expenses',
        theme: CupertinoThemeData(
            textTheme: CupertinoTextThemeData(
                textStyle: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    backgroundColor: CupertinoColors.black)),
            brightness: Brightness.light,
            primaryColor: CupertinoColors.systemPurple,
            barBackgroundColor: CupertinoColors.black,
            primaryContrastingColor: CupertinoColors.systemYellow,
            scaffoldBackgroundColor: CupertinoColors.black),
        home: MyHomePage(),
      );
    } else {
        return MaterialApp(
          title: 'Personal Expenses',
          theme: ThemeData(
              fontFamily: "Roboto",
              colorScheme: ColorScheme.fromSwatch(
                primarySwatch: Colors.purple,
              ).copyWith(secondary: Colors.amber),
              buttonColor: Colors.white),
          home: MyHomePage(),
        );
    }
  }
}

class MyHomePage extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransaction = [
    Transaction(
      id: "t1",
      title: "New Shoes",
      amount: 69.20,
      date: DateTime.now().subtract(Duration(days: 4)),
    ),
    Transaction(
        id: "t2",
        title: "Weekly Groceries",
        amount: 45.10,
        date: DateTime.now().subtract(Duration(days: 2)))
  ];

  List<Transaction> get _recentTransaction {
    return _userTransaction
        .where(
            (tx) => tx.date.isAfter(DateTime.now().subtract(Duration(days: 7))))
        .toList();
  }

  bool _ShowChart = false;

  void _addNewTransaction(String title, double amount, DateTime date) {
    final newTx = Transaction(
        id: DateTime.now().toString(),
        title: title,
        amount: amount,
        date: date);
    setState(() {
      _userTransaction.add(newTx);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransaction.removeWhere((element) => element.id == id);
    });
  }

  void _startAddNewTransaction(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return GestureDetector(
              onTap: () {},
              child: NewTransaction(addTx: _addNewTransaction),
              behavior: HitTestBehavior.opaque);
        });
  }

  @override
  Widget build(BuildContext context) {
    var mediaQueryData = MediaQuery.of(context);
    final isLandscape = mediaQueryData.orientation == Orientation.landscape;

    AppBar appBar = AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Flutter App"),
        actions: <Widget>[
          IconButton(
            onPressed: () => _startAddNewTransaction(context),
            icon: Icon(
              Icons.add,
              size: 10,
              color: Colors.amber,
            ),
          )
        ],
      );


    final txList = Container(
      height: (mediaQueryData.size.height -
              appBar.preferredSize.height -
              mediaQueryData.padding.top) *
          0.7,
      child: TransactionList(
        userTransaction: _userTransaction,
        deleteTx: _deleteTransaction,
      ),
    );

    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (isLandscape)
                Row(
                  children: [
                    Text("Show Chart"),
                    Switch.adaptive(
                        activeColor: Theme.of(context).accentColor,
                        value: _ShowChart,
                        onChanged: (val) {
                          setState(() {
                            _ShowChart = val;
                          });
                        })
                  ],
                ),
              if (!isLandscape)
                Container(
                    height: (mediaQueryData.size.height -
                            appBar.preferredSize.height -
                            mediaQueryData.padding.top) *
                        0.7,
                    child: Chart(_recentTransaction)),
              if (!isLandscape) txList,
              if (isLandscape)
                _ShowChart
                    ? Container(
                        height: (mediaQueryData.size.height -
                                appBar.preferredSize.height -
                                mediaQueryData.padding.top) *
                            0.7,
                        child: Chart(_recentTransaction))
                    : txList
            ]),
      ),
    );

    return Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    onPressed: () => _startAddNewTransaction(context),
                    child: Icon(Icons.add),
                  )
    );

  }
}
