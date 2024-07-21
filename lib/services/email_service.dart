import 'dart:math';

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class EmailService {
  final String username = 'ohadleib@gmail.com';
  final String password = 'bcep gayq pxzx oxkf';

  String generateVerificationCode() {
    final random = Random();
    return List<int>.generate(6, (index) => random.nextInt(10)).join();
  }

  Future<void> sendVerificationEmail(String email, String code) async {
    final smtpServer = gmail(username, password);
    final message = Message()
      ..from = Address(username, 'Coffee Shop')
      ..recipients.add(email)
      ..subject = 'Verification Code'
      ..text = 'Your verification code is: $code';

    try {
      await send(message, smtpServer);
      print('Verification email sent');
    } catch (e) {
      print('Error sending email: $e');
    }
  }
}
