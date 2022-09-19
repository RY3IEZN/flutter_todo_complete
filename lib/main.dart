import 'package:flutter/material.dart';
import 'package:flutter_todo_backend_test/screens/home_page.dart';
import 'package:flutter_todo_backend_test/screens/the_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: TheListPage(),
    );
  }
}
