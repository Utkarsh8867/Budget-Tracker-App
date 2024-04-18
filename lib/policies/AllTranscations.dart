


// import 'package:expense_tracker/graph.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:expense_tracker/expense_model.dart';
// import 'graph_screen.dart'; // Import the GraphScreen

class ItemScreen extends StatelessWidget {
  final List<ExpenseModel> expenses;
  final VoidCallback onDelete;

  ItemScreen({
    required this.expenses,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate total amount spent
    double totalAmount = 0;
    expenses.forEach((expense) {
      totalAmount += expense.amount.toDouble(); // Convert int to double
    });

    // Calculate the percentage of each expense
    Map<String, double> percentageMap = {};
    expenses.forEach((expense) {
      final percentage = (expense.amount.toDouble() / totalAmount) * 100; // Convert int to double
      percentageMap[expense.item] = percentage;
    });

    return Scaffold(
      appBar: AppBar(
        title: Text("Transaction History"),
        backgroundColor: Color.fromARGB(255, 255, 135, 49), // Custom app bar color
      ),
      body: Column(
        children: [
          // List of expenses
          Expanded(
            child: ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                final expense = expenses[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: GestureDetector(
                    onTap: () {
                      // Add onTap functionality if needed
                    },
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: Colors.white, // Custom card background color
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        title: Text(
                          "Item: ${expense.item}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple, // Custom title text color
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 4),
                            Text(
                              "Amount: ₹${expense.amount}",
                              style: TextStyle(
                                color: Colors.green, // Custom amount text color
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Date: ${DateFormat.yMMMMd().format(expense.date)}",
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
         
        ],
      ),
    );
  }
}
