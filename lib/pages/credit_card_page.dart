// import 'package:flutter/material.dart';
// import 'package:flutter_credit_card/flutter_credit_card.dart';
// import 'package:provider/provider.dart';
// import '../model/coffee_shop.dart';

// class CreditCardPage extends StatefulWidget {
//   @override
//   _CreditCardPageState createState() => _CreditCardPageState();
// }

// class _CreditCardPageState extends State<CreditCardPage> {
//   String cardNumber = '';
//   String expiryDate = '';
//   String cardHolderName = '';
//   String cvvCode = '';
//   bool isCvvFocused = false;
//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();

//   void onCreditCardModelChange(CreditCardModel model) {
//     setState(() {
//       cardNumber = model.cardNumber;
//       expiryDate = model.expiryDate;
//       cardHolderName = model.cardHolderName;
//       cvvCode = model.cvvCode;
//       isCvvFocused = model.isCvvFocused;
//     });
//   }

//   void processPayment() {
//     if (formKey.currentState!.validate()) {
//       // ניקוי העגלה
//       Provider.of<CoffeeShop>(context, listen: false).clearCart();

//       // הצגת אלרט של רכישה מוצלחת
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text('Success'),
//             content: Text('Payment Successful!'),
//             actions: <Widget>[
//               TextButton(
//                 child: Text('OK'),
//                 onPressed: () {
//                   Navigator.pop(context); // סגירת האלרט
//                   Navigator.pop(context); // חזרה לעמוד הקודם
//                 },
//               ),
//             ],
//           );
//         },
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Credit Card Payment'),
//       ),
//       body: SafeArea(
//         child: Column(
//           children: <Widget>[
//             CreditCardWidget(
//               cardNumber: cardNumber,
//               expiryDate: expiryDate,
//               cardBgColor: Colors.black,
//               cardHolderName: cardHolderName,
//               cvvCode: cvvCode,
//               showBackView: isCvvFocused,
//               onCreditCardWidgetChange: (CreditCardBrand) {},
//             ),
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: <Widget>[
//                     CreditCardForm(
//                       formKey: formKey,
//                       obscureCvv: true,
//                       obscureNumber: true,
//                       cardNumber: cardNumber,
//                       cvvCode: cvvCode,
//                       cardHolderName: cardHolderName,
//                       expiryDate: expiryDate,
//                       onCreditCardModelChange: onCreditCardModelChange,
//                     ),
//                     SizedBox(height: 20),
//                     ElevatedButton(
//                       onPressed: processPayment,
//                       child: Container(
//                         margin: EdgeInsets.all(8),
//                         child: Text(
//                           'Pay Now',
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 18,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';  // נוסיף את הייבוא הזה
import '../model/coffee.dart';
import '../model/coffee_shop.dart';
import '../services/email_service.dart';

class CreditCardPage extends StatefulWidget {
  @override
  _CreditCardPageState createState() => _CreditCardPageState();
}

class _CreditCardPageState extends State<CreditCardPage> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void onCreditCardModelChange(CreditCardModel model) {
    setState(() {
      cardNumber = model.cardNumber;
      expiryDate = model.expiryDate;
      cardHolderName = model.cardHolderName;
      cvvCode = model.cvvCode;
      isCvvFocused = model.isCvvFocused;
    });
  }

  void processPayment() async {
    if (formKey.currentState!.validate()) {
      final coffeeShop = Provider.of<CoffeeShop>(context, listen: false);
      final order = List<Coffee>.from(coffeeShop.userCart);
      final total = coffeeShop.userCart.fold(0.0, (sum, item) => sum + item.price * item.quantity);

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null && user.email != null) {
        String userEmail = user.email!;

        final emailService = EmailService();
        await emailService.sendOrderDetails(userEmail, order, total);

        coffeeShop.clearCart();

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Payment Successful!'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context); 
                  },
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to retrieve user email. Please try again.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Credit Card Payment'),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            CreditCardWidget(
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardBgColor: Colors.black,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              showBackView: isCvvFocused,
              onCreditCardWidgetChange: (CreditCardBrand) {},
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    CreditCardForm(
                      formKey: formKey,
                      obscureCvv: true,
                      obscureNumber: true,
                      cardNumber: cardNumber,
                      cvvCode: cvvCode,
                      cardHolderName: cardHolderName,
                      expiryDate: expiryDate,
                      onCreditCardModelChange: onCreditCardModelChange,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: processPayment,
                      child: Container(
                        margin: EdgeInsets.all(8),
                        child: Text(
                          'Pay Now',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
