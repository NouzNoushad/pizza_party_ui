import 'package:flutter/material.dart';
import 'package:flutter_pizza_party_ui/database/db.dart';
import 'package:flutter_pizza_party_ui/model/pizzas_model.dart';
import 'package:flutter_pizza_party_ui/pizza_cart.dart';

class PizzaPartyHome extends StatefulWidget {
  const PizzaPartyHome({super.key});

  @override
  State<PizzaPartyHome> createState() => _PizzaPartyHomeState();
}

class _PizzaPartyHomeState extends State<PizzaPartyHome> {
  Pizzas? pizza;
  MyDatabase myDatabase = MyDatabase();

  @override
  void initState() {
    myDatabase.open();
    pizza = pizzasCollection[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Stack(
        children: [
          ClipPath(
            clipper: CustomClipperToDesign(),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.4,
              color: Colors.red,
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.7,
            // color: Colors.yellow,
            padding: const EdgeInsets.all(18),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                  const Text(
                    'Pizza Party',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const PizzasCart()),
                      );
                    },
                    child: const Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Expanded(
                flex: 3,
                child: CircleAvatar(
                  radius: 140,
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage(
                    'assets/${pizza!.image}',
                  ),
                ),
              ),
              Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          pizza!.name,
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        IntrinsicHeight(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Large',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const VerticalDivider(
                                thickness: 1.2,
                                color: Colors.grey,
                                endIndent: 4,
                                indent: 4,
                              ),
                              Text(
                                '\$ ${pizza!.price}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          pizza!.toppings,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            var scaffoldMessenger =
                                ScaffoldMessenger.of(context);

                            await myDatabase.db!.rawInsert(
                                'INSERT INTO pizzas (image, name, toppings, price) VALUES (?, ?, ?, ?)',
                                [
                                  pizza!.image,
                                  pizza!.name,
                                  pizza!.toppings,
                                  pizza!.price
                                ]);
                            // pop up message
                            scaffoldMessenger.showSnackBar(SnackBar(
                                backgroundColor: Colors.red,
                                content: Text(
                                  '${pizza!.name} pizza added to Cart',
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                )));
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              )),
                          child: const Text(
                            'Add to Cart',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      ],
                    ),
                  )),
            ]),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipPath(
              clipper: CustomClipperBottomDesign(),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.3,
                color: Colors.red,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 60,
                    width: 120,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(80),
                          topRight: Radius.circular(80),
                        )),
                    child: const Center(
                        child: Icon(
                      Icons.navigation,
                      size: 40,
                      color: Colors.red,
                    )),
                  ),
                ),
              ),
            ),
          ),
          pizzasList(context),
        ],
      )),
    );
  }

  Widget pizzasList(context) => Padding(
        padding: const EdgeInsets.only(bottom: 60),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 200,
            // color: Colors.yellow,
            child: RotatedBox(
              quarterTurns: 3,
              child: ListWheelScrollView(
                itemExtent: 150,
                offAxisFraction: 0.8,
                onSelectedItemChanged: (index) {
                  setState(() {
                    pizza = pizzasCollection[index];
                  });
                },
                children: pizzasCollection.map((pizza) {
                  return RotatedBox(
                    quarterTurns: 1,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.2,
                      margin: const EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              width: 1.2, color: Colors.grey.shade300),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(60),
                            bottom: Radius.circular(20),
                          )),
                      child: Column(children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.transparent,
                          backgroundImage: AssetImage(
                            'assets/${pizza.image}',
                          ),
                        ),
                        Text(
                          pizza.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        )
                      ]),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      );
}

class CustomClipperBottomDesign extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double w = size.width;
    double h = size.height;

    path.moveTo(0, h / 2);
    path.lineTo(0, h);
    path.lineTo(w, h);
    path.lineTo(w, h / 2);
    path.quadraticBezierTo(w / 2, 0, 0, h / 2);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class CustomClipperToDesign extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double h = size.height;
    double w = size.width;

    path.lineTo(0, h / 2);
    path.quadraticBezierTo(w / 2, h, w, h / 2);
    path.lineTo(w, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
