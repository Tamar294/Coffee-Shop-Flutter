import 'dart:async';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_new_app/const.dart';
import 'package:coffee_new_app/pages/intro_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/email_service.dart';

class LoginPage extends StatefulWidget {
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();

  final EmailService _emailService = new EmailService();

  String? _verificationCode;

  void signInWithEmailCode() async {
    String email = _emailController.text.trim();
    String code = _codeController.text.trim();

    if (code == _verificationCode) {
      User? user = await _checkUserExists(email);

      if (user == null) {
        await _registerUser(email);
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => IntroScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Verification code is incorrect.')),
      );
    }
  }

  Future<void> _sendVerificationCode() async {
    String email = _emailController.text.trim();
    _verificationCode = _emailService.generateVerificationCode();

    print('Send Verification Code button clicked');
    print('Verification code: $_verificationCode');

    await _emailService.sendVerificationEmail(email, _verificationCode!);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Verification code sent to $email.')),
    );
  }

  Future<User?> _checkUserExists(String email) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: 'temporaryPassword',
      );
      return userCredential.user;
    } catch (e) {
      return null;
    }
  }

  Future<void> _registerUser(String email) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: 'temporaryPassword',
      );
      await FirebaseFirestore.instance
          .collection('user')
          .doc(userCredential.user?.uid)
          .set({
        'email': email,
      });
    } catch (e) {
      print('Error registering user: $e');
    }
  }

  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: backgroundColor,
  //     body: Center(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Padding(
  //             padding: EdgeInsets.all(25),
  //             child: Image.asset("lib/images/latte.png", height: 140),
  //           ),
  //           SizedBox(height: 10),
  //           Text(
  //             "היי, ברוכים הבאים",
  //             style: TextStyle(
  //               fontWeight: FontWeight.bold,
  //               color: Colors.brown[800],
  //               fontSize: 26,
  //             ),
  //           ),
  //           SizedBox(height: 10),
  //           Text(
  //             "הזינו את מספר הטלפון או המייל על מנת להיכנס",
  //             style: TextStyle(
  //               color: Colors.black,
  //               fontSize: 18,
  //             ),
  //           ),
  //           SizedBox(height: 10),
  //           ToggleButtons(
  //             children: <Widget>[
  //               Padding(
  //                 padding: EdgeInsets.all(5),
  //                 Text("טלפון"),
  //               ),
  //               Padding(
  //                 padding: EdgeInsets.all(5),
  //                 Text("מייל"),
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

   Widget build(BuildContext context) {
         return Scaffold(
       appBar: AppBar(title: Text('Login')),
       body: Padding(
         padding: const EdgeInsets.all(16.0),
         child: Column(
           children: [
             TextField(
               controller: _emailController,
               decoration: InputDecoration(labelText: 'Email'),
             ),
             ElevatedButton(
               onPressed: _sendVerificationCode,
               child: Text('Send Verification Code'),
             ),
             TextField(
               controller: _codeController,
               decoration: InputDecoration(labelText: 'Verification Code'),
             ),
             ElevatedButton(
               onPressed: signInWithEmailCode,
               child: Text('Verify and Sign In'),
             ),
           ],
         ),
       ),
     );
   }
}
