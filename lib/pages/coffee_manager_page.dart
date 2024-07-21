import 'package:flutter/material.dart';

class CoffeeManager extends StatefulWidget {
  State<CoffeeManager> createState() => _CoffeeManagerState();
}

class _CoffeeManagerState extends State<CoffeeManager> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add a new product"),
      ),
    );
  }
}
