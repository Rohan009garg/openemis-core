import 'package:flutter/material.dart';
import 'login_page.dart';

void main() {
  runApp(MyApp());
}
//1522271965
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Info App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginPage(),
    );
  }
}
