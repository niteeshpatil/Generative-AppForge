import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dynamicwidget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dynamic Widgets',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CombinedWidgetsScreen(),
    );
  }
}
