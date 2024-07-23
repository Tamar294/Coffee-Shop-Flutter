import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_new_app/const.dart';
import 'package:coffee_new_app/pages/home_page.dart';
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
  int _selectedIndex = 0;

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
        MaterialPageRoute(builder: (context) => HomePage()),
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

    void signInWithPhoneNumber() async {
    // String phoneNumber = _phoneController.text.trim();
    String code = _codeController.text.trim();

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationCode!, smsCode: code);

    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Verification code is incorrect.')),
      );
    }
  }

  Future<void> _sendPhoneVerificationCode() async {
    String phoneNumber = _phoneController.text.trim();

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Phone number verification failed.')),
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationCode = verificationId;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verification code sent to $phoneNumber.')),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          _verificationCode = verificationId;
        });
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor, 
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(25),
              child: Image.asset("lib/images/latte.png", height: 140),
            ),
            SizedBox(height: 10),
            Text(
              "Hi, Welcome!",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.brown[800],
                fontSize: 26,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Enter your phone number or email to log in",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 10),
            ToggleButtons(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Text("phone"),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Text("email"),
                ),
              ],
              isSelected: [
                _selectedIndex == 0,
                _selectedIndex == 1,
              ],
              onPressed: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
            SizedBox(height: 10),
            if (_selectedIndex == 1)
              Column(
                children: [
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.brown)
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.brown)
                        ),
                      labelText: 'email',
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _sendVerificationCode,
                    child: Text("sent me a verification code to my email"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown[800],
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.all(10),
                    ),
                  ),
                ],
              )
            else
              Column(
                children: [
                  TextField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.brown)
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.brown)
                        ),
                        labelText: 'phone',
                        prefixText: '+972 '),
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _sendVerificationCode,
                    child: Text("sent me a verification code to my phone"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown[800],
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              TextField(
                controller: _codeController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.brown)
                  ),
                  hintText: 'verification code',
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _selectedIndex == 1
                    ? signInWithEmailCode
                    : signInWithPhoneNumber,
                child: Text('submit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown[800], 
                  foregroundColor: Colors.white, 
                ),
              ),
            ],
          ),
        ),
      );
    }
}





