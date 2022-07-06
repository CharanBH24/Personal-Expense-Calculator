import 'package:flutter/material.dart';
import 'package:personal_expense_calculator/models/transaction.dart';
import 'package:intl/intl.dart';
import 'package:personal_expense_calculator/widgets/chart.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final List<Transaction> transactions = [];
  DateTime? _selectDate;

  List<Transaction> get _recentTransction {
    return transactions.where((tx) {
      return tx.dateTime!
          .isAfter(DateTime.now().subtract(const Duration(days: 7)));
    }).toList();
  }

  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2022),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Align(
          alignment: Alignment.bottomCenter,
          child: FloatingActionButton(
            backgroundColor: Colors.amber,
            child: const Icon(
              Icons.add,
              color: Colors.black,
            ),
            onPressed: () {
              modal(context);
            },
          ),
        ),
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text(
            "Personal Expense",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                modal(context);
              },
              color: Colors.white,
            )
          ],
        ),
        body: transactions.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                    SizedBox(
                      child: Image.asset("./assets/img/waiting.png"),
                      height: MediaQuery.of(context).size.height * 0.5,
                    )
                  ])
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Chart(
                    recentTransaction: _recentTransction,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        return Card(
                            elevation: 5,
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 5),
                            child: ListTile(
                              leading: Card(
                                  elevation: 3,
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color:
                                                Theme.of(context).primaryColor,
                                            width: 1.0)),
                                    child: Text(
                                      "Rs ${transactions[index].price?.toStringAsFixed(2)}",
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                              title: Text(
                                transactions[index].title!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(DateFormat.yMMMMd('en_US')
                                  .format(transactions[index].dateTime!)),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  setState(() {
                                    transactions.removeAt(index);
                                  });
                                },
                              ),
                            ));
                      },
                    ),
                  )
                ],
              ));
  }

  Future<dynamic> modal(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            margin: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _titleController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: "Title"),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _amountController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: "Amount"),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                Container(
                  height: 70,
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(_selectDate == null
                              ? 'No Date Choosen'
                              : 'Picked Date:' +
                                  DateFormat.yMMMMd().format(_selectDate!))),
                      TextButton(
                          onPressed: _presentDatePicker,
                          child: const Text(
                            "Choose Date",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ))
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        style: TextButton.styleFrom(primary: Colors.white),
                        onPressed: () {
                          setState(() {
                            transactions.add(Transaction(
                              title: _titleController.text,
                              price: double.parse(_amountController.text),
                              dateTime: _selectDate,
                            ));
                          });
                          Navigator.pop(context);
                        },
                        child: const Text("Add Transaction"))
                  ],
                )
              ],
            ),
          );
        });
  }
}
