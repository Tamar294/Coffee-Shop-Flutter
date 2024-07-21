import 'package:coffee_new_app/model/coffee.dart';
import 'package:flutter/material.dart';

class CoffeeShop extends ChangeNotifier {

  final List<Coffee> _shop = [

    Coffee(
      name: "Long Black",
      price: 4.10,
      imagePath: "lib/images/black.png",
    ),

     Coffee(
      name: "Latte",
      price: 4.00,
      imagePath: "lib/images/latte.png",
    ),

     Coffee(
      name: "Espresso",
      price: 4.40,
      imagePath: "lib/images/espresso.png",
    ),

     Coffee(
      name: "Iced Coffee",
      price: 5.00,
      imagePath: "lib/images/iced_coffee.png",
    ),
  ];

  List<Coffee> get coffeeShop => _shop;

  List<Coffee> _userCart = [];

  List<Coffee> get userCart => _userCart;

  void addItemToCart(Coffee coffee, int quantity) {
    coffee.quantity = quantity;
    _userCart.add(coffee);
    notifyListeners();
  }

  void removeFromCart(Coffee coffee) {
    _userCart.remove(coffee);
    notifyListeners();
  }

  void clearCart() {
  _userCart.clear();
  notifyListeners();
  }

}