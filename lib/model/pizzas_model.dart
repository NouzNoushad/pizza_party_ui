class Pizzas {
  final String image;
  final String name;
  final double price;
  final String toppings;

  Pizzas({
    required this.image,
    required this.name,
    required this.price,
    required this.toppings,
  });
}

List<Pizzas> pizzasCollection = [
  Pizzas(
    image: 'farmhouse.png',
    name: 'Farmhouse',
    price: 89,
    toppings: 'Tomato, Mozzarello, Green basil, Olives, Bell pepper',
  ),
  Pizzas(
    image: 'mexican_green_wave.png',
    name: 'Mexican Green',
    price: 80,
    toppings: 'American cheese, Taco seasoning, Grilled chicken, Fresh onion',
  ),
  Pizzas(
    image: 'deluxe_veggie.png',
    name: 'Deluxe Veggie',
    price: 75,
    toppings: 'Mushrooms, Red onions, Green peppers, Black olives',
  ),
  Pizzas(
    image: 'corn_cheese.png',
    name: 'Corn Cheese',
    price: 86,
    toppings: 'Canned corn, Mayannaise, Mild shredded cheese',
  ),
  Pizzas(
    image: 'veggie_paradise.png',
    name: 'Veggie Paradise',
    price: 82,
    toppings: 'Crunchy capsicum, Red paprika, Black olives, Golden corn',
  ),
];
