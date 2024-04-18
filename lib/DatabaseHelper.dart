import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'expense_model.dart';

class DatabaseHelper {
  static late Database _database;

  static Future<void> initDatabase() async {
    final Directory documentsDirectory =
        await getApplicationDocumentsDirectory();
    final String path = join(documentsDirectory.path, 'expenses.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE expenses(id INTEGER PRIMARY KEY, item TEXT, amount INTEGER, isIncome INTEGER, date TEXT)',
        );
      },
    );
  }

  static Future<void> insertExpense(ExpenseModel expense) async {
    await _database.insert(
      'expenses',
      expense.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<ExpenseModel>> getExpenses() async {
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

  static Future<void> deleteExpense(int id) async {
    await _database.delete(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

