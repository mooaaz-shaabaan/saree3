class CartItem {
  final int id;
  final String name;
  final String description;
  final double price;
  final String imageProdact;
  final String imageResturant;
  int quantity;

  CartItem({
    required this.description,
    required this.imageProdact,
    required this.imageResturant,
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'quantity': quantity,
      'imageProdact': imageProdact,
      'imageResturant': imageResturant,
    };
  }
}
