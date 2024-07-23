class Coffee {
  String? id;
  final String name;
  final double price;
  final String imagePath;
  int quantity;

  Coffee({
    this.id,
    required this.name,
    required this.price,
    required this.imagePath,
    this.quantity = 1,
  });
}