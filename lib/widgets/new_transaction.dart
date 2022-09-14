import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;

  NewTransaction(this.addTx);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  void Function(String title, double amount) addNewTransaction;

  NewTransaction({required this.addNewTransaction, super.key});
  void submitDate() {
    final enteredTitle = titleController.text;
    final enteredAmount = double.parse(amountController.text);

    if (enteredAmount <= 0 || enteredTitle.isEmpty) return;

    addNewTransaction(
      titleController.text,
      double.parse(amountController.text),
    );
  }

  final titleController = TextEditingController();
  final amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          TextField(
              decoration: InputDecoration(labelText: 'Title'),
              //onChanged: (String value) => {titleInput = value},
              controller: titleController,
              onSubmitted: (_) => submitDate()),
          TextField(
            decoration: InputDecoration(labelText: 'Amount'),
            //onChanged: (String value) => {amountInput = value},
            controller: amountController,
            keyboardType: TextInputType.number,
            onSubmitted: (_) => submitDate(),
          ),
          TextButton(
            child: Text("Add Transactions"),
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.purple),
            ),
            onPressed: submitDate,
          )
        ]),
      ),
    );
  }
}
