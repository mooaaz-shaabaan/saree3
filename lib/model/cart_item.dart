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

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'] is int
          ? map['id'] as int
          : int.tryParse(map['id']?.toString() ?? '') ?? 0,
      name: map['name']?.toString() ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      quantity: map['quantity'] is int
          ? map['quantity'] as int
          : int.tryParse(map['quantity']?.toString() ?? '') ?? 1,
      description: map['description']?.toString() ?? '',
      imageProdact: map['imageProdact']?.toString() ?? '',
      imageResturant: map['imageResturant']?.toString() ?? '',
      restaurantName: map['restaurantName']?.toString() ?? '',
      restaurantNameDefault: map['restaurantNameDefault']?.toString() ?? '',
    );
  }

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
