import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/cart_tile.dart';
import '../components/my_button.dart';
import '../model/coffee.dart';
import '../model/coffee_shop.dart';
import 'credit_card_page.dart';

class CartPage extends StatefulWidget {
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  void removeItemFromCart(Coffee coffee) {
    Provider.of<CoffeeShop>(context, listen: false).removeFromCart(coffee);
  }

  void payNow() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreditCardPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CoffeeShop>(
      builder: (context, value, child) {
        double totalPrice = value.userCart.fold(0, (sum, item) => sum + item.price * item.quantity);
        int totalQuantity = value.userCart.fold(0, (sum, item) => sum + item.quantity);

        return Column(
          children: [
            Row(
              children: const [
                Padding(
                  padding: EdgeInsets.only(left: 25.0, top: 25, bottom: 25),
                  child: Text('Your Cart', style: TextStyle(fontSize: 20)),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: value.userCart.length,
                itemBuilder: (context, index) {
                  Coffee coffee = value.userCart[index];
                  return CartTile(
                    coffee: coffee,
                    onPressed: () => removeItemFromCart(coffee),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Quantity:', style: TextStyle(fontSize: 16)),
                      Text('$totalQuantity', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Price:', style: TextStyle(fontSize: 16)),
                      Text('\$${totalPrice.toStringAsFixed(2)}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            MyButton(text: "Pay now", onTap: payNow),
          ],
        );
      },
    );
  }
}