import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:expense_tracker/expense_model.dart';

class Item extends StatefulWidget {
  final ExpenseModel expense;
  final VoidCallback onDelete;

  // Add a new parameter to control whether to show random color or not
  final bool showRandomColor;
  // Color myColor = Color.fromARGB(255, 178, 108, 0);

  Item({
    Key? key,
    required this.expense,
    required this.onDelete,
    this.showRandomColor = true, // Default to true
  }) : super(key: key);

  @override
  _ItemState createState() => _ItemState();
}

class _ItemState extends State<Item> {
  late Color containerColor;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    // Set a fixed color or random color based on showRandomColor
    containerColor = widget.showRandomColor ? getRandomColor() : Colors.white;
    if (widget.showRandomColor) {
      timer = Timer.periodic(Duration(seconds: 5), (Timer t) {
        setState(() {
          containerColor =
              getRandomColor(); // Generate a new random color every 5 seconds
        });
      });
    }
  }

  @override
  void dispose() {
    if (widget.showRandomColor) {
      timer.cancel(); // Cancel the timer when the widget is disposed
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 9,
        bottom: 7,
        left: 12,
        right: 11,
      ),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.0),
          // color: containerColor,
          color: Colors.amber[200],
        ),
        child: Row(
          children: [
            SizedBox(
              height: 35,
              width: 35,
              child: widget.expense.isIncome
                  ? Image.asset("images/income.png")
                  : Image.asset("images/expense.png"),
            ),
            const SizedBox(width: 17),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.expense.item,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  DateFormat.yMMMMd().format(widget.expense.date),
                  style: const TextStyle(
                    fontSize: 14.7,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              "₹${widget.expense.amount}",
              style: TextStyle(
                fontSize: 20.5,
                color: widget.expense.isIncome ? Colors.green : Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Color getRandomColor() {
  Random random = Random();
  return Color.fromARGB(
    255,
    random.nextInt(256), // Generates a random value for red (0-255)
    random.nextInt(256), // Generates a random value for green (0-255)
    random.nextInt(256), // Generates a random value for blue (0-255)
  );
}
