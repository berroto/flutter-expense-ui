import 'package:flutter/material.dart';
import 'package:flutter_expense_ui/models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> userTransaction;
  final Function deleteTx;

  TransactionList({required this.userTransaction, required this.deleteTx});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: userTransaction.isEmpty
            ? LayoutBuilder(builder: (ctx, constraints) {
                print(ctx);
                print(constraints);
                return Column(children: <Widget>[
                  Container(
                    height: 20,
                    child: Text('No transactions added yet',
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: constraints.maxHeight * 0.6,
                    child: Image.asset(
                      "assets/images/waiting.png",
                      fit: BoxFit.cover,
                    ),
                  )
                ]);
              })
            : Container(
                child: Column(
                    children: userTransaction
                        .map((tx) => Card(
                              elevation: 5,
                              margin: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 5),
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 30,
                                  child:
                                      FittedBox(child: Text('€ ${tx.amount}')),
                                ),
                                title: Text(
                                  tx.title,
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                ),
                                subtitle:
                                    Text(DateFormat.yMMMd().format(tx.date)),
                                trailing: MediaQuery.of(context).size.width >
                                        400
                                    ? TextButton(
                                        onPressed: () => deleteTx(tx.id),
                                        style: TextButton.styleFrom(
                                            foregroundColor: Theme.of(context)
                                                .colorScheme
                                                .error),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: const [
                                            Text('Delete'), // <-- Text
                                            Icon(// <-- Icon
                                                Icons.delete),
                                          ],
                                        ),
                                      )
                                    : IconButton(
                                        icon: const Icon(Icons.delete),
                                        color: Theme.of(context).errorColor,
                                        onPressed: () => deleteTx(tx.id),
                                      ),
                              ),
                            ))
                        .toList())));
  }
}
