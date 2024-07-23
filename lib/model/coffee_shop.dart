import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_new_app/model/coffee.dart';
import 'package:flutter/material.dart';

class CoffeeShop extends ChangeNotifier {

List<Coffee> _shop = [];
List<Coffee> _userCart = [];

CoffeeShop() {
  _fetchProducts();
}

List<Coffee> get coffeeShop => _shop; 
List<Coffee> get userCart => _userCart; 

void addItemToCart(Coffee coffee, int quantity) {
  coffee.quantity = quantity;
  _userCart.add(coffee);
  notifyListeners();
}

void removeItemToCart(Coffee coffee) {
  _userCart.remove(coffee);
  notifyListeners();
}

void clearCart() {
  _userCart.clear();
  notifyListeners();
}

void _fetchProducts() async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('products').get();
  _shop = snapshot.docs.map((doc) {
    return Coffee(
      id: doc.id,
      name: doc['name'],
      price: doc['price'],
      imagePath: doc['imagePath'],
    );
  }).toList();
  notifyListeners();
}

Future<void> addProduct(Coffee coffee) async {
  DocumentReference docRef = await FirebaseFirestore.instance.collection('products').add({
    'name': coffee.name,
    'price': coffee.price,
    'imagePath': coffee.imagePath,
  });
  coffee.id = docRef.id;
  _shop.add(coffee);
  notifyListeners();
}

Future<void> deleteProducts(Coffee coffee) async {
  await FirebaseFirestore.instance.collection('products').doc(coffee.id).delete();
  _shop.remove(coffee);
  notifyListeners();
}


}