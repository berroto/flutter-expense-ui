import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;

  const NewTransaction({required this.addTx});

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  void _submitDate() {
    if (_amountController.text.isEmpty) return;
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);

    if (enteredAmount <= 0 || enteredTitle.isEmpty || _selectedDate == null) {
      return;
    }

    widget.addTx(_titleController.text, double.parse(_amountController.text),
        _selectedDate);

    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020, 1, 1),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return null;
      }

      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;

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
              controller: _titleController,
              onSubmitted: (_) => _submitDate()),
          TextField(
            decoration: InputDecoration(labelText: 'Amount'),
            //onChanged: (String value) => {amountInput = value},
            controller: _amountController,
            keyboardType: TextInputType.number,
            onSubmitted: (_) => _submitDate(),
          ),
          Container(
            height: 70,
            child: Row(
              children: [
                Expanded(
                  child: _selectedDate == null
                      ? Text('no Date choosen')
                      : Text(
                          'Picked Date: ${DateFormat.yMd().format(_selectedDate!)}'),
                ),
                TextButton(
                  onPressed: _presentDatePicker,
                  style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.primary),
                  child: Text("choose data"),
                )
              ],
            ),
          ),
          ElevatedButton(
            //backgroundColor: Theme.of(context).backgroundColor,
            //foregroundColor: Theme.of(context).primaryColor,
            child: Text("Add Transactions"),
            onPressed: _submitDate,
          )
        ]),
      ),
    );
  }
}
