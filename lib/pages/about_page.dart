import 'package:coffee_new_app/const.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("About", style: TextStyle(color:  Colors.grey.shade900)),
        centerTitle: true,
      ),

      body: Center(child: Text("We have a Great Coffee")),
    );
  }
}