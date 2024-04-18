import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'NavBar.dart';
import 'expense_model.dart';
import 'fund_condition_widget.dart';
import 'item.dart';
import 'policies/AllTranscations.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> options = ["expense", "income"];
  List<ExpenseModel> expenses = [];
  TextEditingController itemController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  int totalMoney = 0;
  int spentMoney = 0;
  int income = 0;
  DateTime? pickedDate;
  String currentOption = "expense";

  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _refreshScreen();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 255, 158, 55),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(" Add Transactions "),
                content: SizedBox(
                  height: 340,
                  width: 400,
                  child: Column(
                    children: [
                      TextField(
                        controller: itemController,
                        decoration: InputDecoration(
                          hintText: "Enter the Item",
                        ),
                      ),
                      SizedBox(height: 8),
                      TextField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "Enter the Amount",
                        ),
                      ),
                      SizedBox(height: 18),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextField(
                          onTap: () async {
                            pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            String date =
                                DateFormat.yMMMMd().format(pickedDate!);
                            dateController.text = date;
                            setState(() {});
                          },
                          controller: dateController,
                          decoration: InputDecoration(
                            labelText: "DATE",
                          ),
                          readOnly: true,
                        ),
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          Radio(
                            value: options[0],
                            groupValue: currentOption,
                            onChanged: (value) {
                              setState(() {
                                currentOption = value.toString();
                                _refreshScreen();
                              });
                            },
                          ),
                          Text("BUDGET"),
                          SizedBox(width: 20),
                          Radio(
                            value: options[1],
                            groupValue: currentOption,
                            onChanged: (value) {
                              setState(() {
                                currentOption = value.toString();
                                _refreshScreen();
                              });
                            },
                            activeColor: Colors.green,
                          ),
                          Text("INCOME"),
                        ],
                      ),
                    ],
                  ),
                ),
          



               
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("CANCEL"),
                  ),
                  TextButton(
                    onPressed: () {
                      try {
                        int amount = int.parse(amountController.text);
                        final expense = ExpenseModel(
                          item: itemController.text,
                          amount: amount,
                          isIncome: currentOption == "income" ? true : false,
                          date: pickedDate!,
                        );
                        expenses.add(expense);
                        if (expense.isIncome) {
                          income += expense.amount;
                          totalMoney += expense.amount;
                        } else {
                          spentMoney += expense.amount;
                          totalMoney -= expense.amount;
                        }
                        _addExpenseToDB(expense); // Save to database
                        itemController.clear();
                        amountController.clear();
                        dateController.clear();
                        Navigator.pop(context);
                        _refreshScreen();
                      } catch (e) {
                        print('Error parsing amount: $e');
                        // Handle the error, such as displaying a message to the user
                        // You can also choose to do nothing or provide a default value
                      }
                    },
                    child: Text("ADD"),
                  ),
                ],
              );
            },
          );
        },
        child: CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(Icons.add, size: 29, color: Color.fromARGB(255, 255, 146, 58)),
        ),
      ),
      appBar: AppBar(
        title: Text("Budget Tracker"),
        backgroundColor: Color.fromARGB(255, 255, 139, 6),
        toolbarHeight: 90,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
      ),
      drawer: NavBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 30),
            Center(
              child: Row(
                children: [
                  Text(
                    "Calculations",
                    style: TextStyle(color: Colors.black, fontSize: 20,)
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.all(8),
                    width: 170,
                    height: 100,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24.0),
                      color: Colors.amberAccent,
                    ),
                    child: FundCondition(
                      type: "INCOME",
                      amount: "$income",
                      icon: "grey",
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(8),
                    width: 170,
                    height: 100,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24.0),
                      color: Colors.amberAccent,
                    ),
                    child: FundCondition(
                      type: "BUDGET",
                      amount: "$spentMoney",
                      icon: "orange",
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(8),
                    width: 170,
                    height: 100,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24.0),
                      color: Colors.amberAccent,
                    ),
                    child: FundCondition(
                      type: "DEPOSIT",
                      amount: "$totalMoney",
                      icon: "blue",
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ItemScreen(
                      expenses: expenses,
                      onDelete: () {
                        setState(() {
                          expenses.removeAt(0);
                        });
                      },
                    ),
                  ),
                );
              },
              child: Row(
                children: [
                  Text(
                    " View Transactions",
                    style: TextStyle(color: Colors.black.withRed(400), fontSize: 20),
                  )
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: expenses.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Confirm to Delete the Item ?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("CANCEL"),
                              ),
                              TextButton(
                                onPressed: () {
                                  final myExpense = expenses[index];
                                  if (myExpense.isIncome) {
                                    income -= myExpense.amount;
                                    totalMoney -= myExpense.amount;
                                  } else {
                                    spentMoney -= myExpense.amount;
                                    totalMoney += myExpense.amount;
                                  }
                                  _deleteExpenseFromDB(myExpense.id);
                                  expenses.remove(myExpense);
                                  Navigator.pop(context);
                                  _refreshScreen();
                                },
                                child: Text("DELETE"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Item(
                      expense: expenses[index],
                      onDelete: () {},
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _refreshScreen() async {
    await _loadExpensesFromDB();
  }

  Future<void> _addExpenseToDB(ExpenseModel expense) async {
    final Database _database = await _getDatabase();
    final int id = await _database.insert(
      'expenses',
      expense.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    expense = expense.copyWith(id: id);
    await _loadExpensesFromDB();
  }

  Future<List<ExpenseModel>> _getExpensesFromDB() async {
    final Database _database = await _getDatabase();
    final List<Map<String, dynamic>> maps = await _database.query('expenses');
    return List.generate(maps.length, (i) {
      return ExpenseModel(
        id: maps[i]['id'],
        item: maps[i]['item'],
        amount: maps[i]['amount'],
        isIncome: maps[i]['isIncome'] == 1,
        date: DateTime.parse(maps[i]['date']),
      );
    });
  }

  Future<void> _deleteExpenseFromDB(int? id) async {
    if (id != null) {
      final Database _database = await _getDatabase();
      await _database.delete(
        'expenses',
        where: 'id = ?',
        whereArgs: [id],
      );
      await _loadExpensesFromDB();
    }
  }

  Future<void> _loadExpensesFromDB() async {
    final List<ExpenseModel> loadedExpenses = await _getExpensesFromDB();
    setState(() {
      expenses = loadedExpenses;
      _updateMoneyValues();
    });
  }

  Future<Database> _getDatabase() async {
    final Directory documentsDirectory =
        await getApplicationDocumentsDirectory();
    final String pathStr = path.join(documentsDirectory.path, 'expenses.db');
    return openDatabase(pathStr, version: 1, onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE expenses(id INTEGER PRIMARY KEY, item TEXT, amount INTEGER, isIncome INTEGER, date TEXT)',
      );
    });
  }

  void _updateMoneyValues() {
    totalMoney = 0;
    spentMoney = 0;
    income = 0;
    for (final expense in expenses) {
      if (expense.isIncome) {
        income += expense.amount;
        totalMoney += expense.amount;
      } else {
        spentMoney += expense.amount;
        totalMoney -= expense.amount;
      }
    }
  }
}
