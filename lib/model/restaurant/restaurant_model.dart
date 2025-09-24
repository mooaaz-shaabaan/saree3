class Restaurant {
  final String id;
  final String name;
  final String cuisine;
  final String rating;
  final String deliveryInfo;
  final String deliveryTime;
  final String imageUrl, resturantName;

  Restaurant({
    required this.resturantName,
    required this.id,
    required this.name,
    required this.cuisine,
    required this.rating,
    required this.deliveryInfo,
    required this.deliveryTime,
    required this.imageUrl,
  });

  static final List<Restaurant> restaurantsByCategory = [
    Restaurant(
      id: '1',
      name: 'Blbn',
      cuisine: 'Sweets',
      rating: '4.7',
      deliveryInfo: 'Free',
      deliveryTime: '20 min',
      imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/saree3-6a6dc.firebasestorage.app/o/Restaurants%20Logo%2Fblbn_logo.jpg?alt=media&token=26f1d65d-5e44-49f7-aa59-869c438e1aac',
      resturantName: 'blbn.json',
    ),
    Restaurant(
      id: '2',
      name: 'Karm El-Sham',
      cuisine: 'Burger - Chicken - Riche - Wings',
      rating: '4.5',
      deliveryInfo: 'Free',
      deliveryTime: '25 min',
      imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/saree3-6a6dc.firebasestorage.app/o/Restaurants%20Logo%2FkarmElSham_logo.png?alt=media&token=11fc9ab6-985e-411e-8dc4-9e3d414c0568',
      resturantName: 'karm-elsham.json',
    ),
    Restaurant(
      id: '3',
      name: 'Abo Tarek',
      cuisine: 'Koshari - Tagen - Hawawshi',
      rating: '4.8',
      deliveryInfo: '15 EGP',
      deliveryTime: '30 min',
      imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/saree3-6a6dc.firebasestorage.app/o/Restaurants%20Logo%2FaboTarek_logo.jpg?alt=media&token=a5aca5cb-80a1-4456-a34d-1f1ca524174a',
      resturantName: 'aboTarek.json',
    ),
  ];
}
