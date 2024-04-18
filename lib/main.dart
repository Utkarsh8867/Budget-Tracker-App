import 'package:expense_tracker/DatabaseHelper.dart';
import 'package:expense_tracker/home_page.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.initDatabase();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      theme: ThemeData(fontFamily: "Tilt Neon"),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
