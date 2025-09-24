class CartItem {
  final int id;
  final String name;
  final String description;
  final double price;
  final String imageProdact;
  final String imageResturant;
  final String restaurantName;
  final String restaurantNameDefault;
  int quantity;

  CartItem({
    required this.description,
    required this.imageProdact,
    required this.imageResturant,
    required this.id,
    required this.name,
    required this.price,
    required this.restaurantName,
    required this.restaurantNameDefault,
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
