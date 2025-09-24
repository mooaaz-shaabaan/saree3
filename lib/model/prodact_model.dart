class MenuItem {
  final int id;
  final String name;
  final String description;
  final double price;
  final String imageProdact;
  final String imageResturant;

  MenuItem({
    required this.imageResturant,
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageProdact,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      imageProdact: json['imageProdact'],
      imageResturant: json['imageResturant'],
    );
  }
}
