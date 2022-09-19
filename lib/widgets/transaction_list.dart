import 'package:flutter/material.dart';
import 'package:flutter_expense_ui/models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> userTransaction;
  final Function deleteTx;
  TransactionList({required this.userTransaction, required this.deleteTx});

  @override
  Widget build(BuildContext context) {
    return Column(
        children: userTransaction.isEmpty
            ? <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      'No transactions added yet',
                      style: Theme.of(context).textTheme.titleMedium,
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 200,
                  child: Image.asset(
                    "assets/images/waiting.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ]
            : userTransaction
                .map((tx) => Card(
                      elevation: 5,
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          child: FittedBox(child: Text('€ ${tx.amount}')),
                        ),
                        title: Text(
                          tx.title,
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        subtitle: Text(DateFormat.yMMMd().format(tx.date)),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          color: Theme.of(context).errorColor,
                          onPressed: () => deleteTx(tx.id),
                        ),
                      ),
                    ))
                .toList());
  }
}
