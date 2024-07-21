import 'package:coffee_new_app/model/coffee.dart';
import 'package:flutter/material.dart';

class CartTile extends StatelessWidget {
  final Coffee coffee;
  final void Function()? onPressed;

  const CartTile({required this.coffee, required this.onPressed});

  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.only(left: 25, right: 25, bottom: 10),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: ListTile(
        leading: Image.asset(coffee.imagePath),
        title: Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: Text(
            coffee.name,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        subtitle: Text(
          "Quantity: ${coffee.quantity} \nTotal: \$${coffee.price * coffee.quantity}"
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.brown[300]),
          onPressed: onPressed,
        ),
      ),
    );
  }
}