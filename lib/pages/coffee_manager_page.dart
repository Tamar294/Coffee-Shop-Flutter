import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coffee_new_app/model/coffee.dart';
import 'package:coffee_new_app/model/coffee_shop.dart';

class CoffeeManager extends StatefulWidget {
  _CoffeeManagerState createState() => _CoffeeManagerState();
}

class _CoffeeManagerState extends State<CoffeeManager> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _imagePathController = TextEditingController(text: "lib/images/");

  void _addProduct() {
    String name = _nameController.text.trim();
    double price = double.parse(_priceController.text.trim());
    String imagePath = _imagePathController.text.trim();

    if (name.isNotEmpty && price > 0 && imagePath.isNotEmpty) {
      Coffee coffee = Coffee(
        name: name,
        price: price,
        imagePath: imagePath,
      );
      Provider.of<CoffeeShop>(context, listen: false).addProduct(coffee);

      _nameController.clear();
      _priceController.clear();
      _imagePathController.text = 'lib/images/';
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
        content: Text('Please enter valid products details'),
        backgroundColor: Colors.red, 
        ));
    }
  }

  void _deleteProduct(Coffee coffee) {
    Provider.of<CoffeeShop>(context, listen: false).deleteProducts(coffee);
  }

  Widget _buildProductItem(Coffee coffee) {
    return ListTile(
      leading: Image.asset(coffee.imagePath),
      title: Text(coffee.name),
      subtitle: Text('\$${coffee.price.toStringAsFixed(2)}'),
      trailing: IconButton(
        icon: Icon(Icons.delete, color: Colors.red),
        onPressed: () => _deleteProduct(coffee),
      ),
    );
  }

  Widget build(BuildContext context) {
    List<Coffee> coffeeShop = Provider.of<CoffeeShop>(context).coffeeShop;

    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Products"),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Product Name'),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Product Price'),
              keyboardType: TextInputType.number,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: _imagePathController,
              decoration: InputDecoration(labelText: 'Image Path'),
            ),
          ),
          ElevatedButton(
            onPressed: _addProduct,
            child: Text('Add Product'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: coffeeShop.length,
              itemBuilder: (context, index) {
                return _buildProductItem(coffeeShop[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}



