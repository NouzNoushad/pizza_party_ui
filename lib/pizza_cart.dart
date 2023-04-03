import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_pizza_party_ui/database/db.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class PizzasCart extends StatefulWidget {
  const PizzasCart({super.key});

  @override
  State<PizzasCart> createState() => _PizzasCartState();
}

class _PizzasCartState extends State<PizzasCart> {
  MyDatabase myDatabase = MyDatabase();
  List<Map> myPizzas = [];

  @override
  void initState() {
    myDatabase.open();
    getMyPizzas();
    super.initState();
  }

  getMyPizzas() {
    Future.delayed(const Duration(seconds: 1), () async {
      myPizzas = await myDatabase.db!.rawQuery('SELECT * FROM pizzas');
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    num total = myPizzas.fold(0, (prev, value) => prev + value['price']);
    return Scaffold(
      backgroundColor: Colors.red,
      body: SafeArea(
          child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.84,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                )),
            padding: const EdgeInsets.all(18),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Text(
                    'Cart',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 6,
                  ),
                  itemCount: myPizzas.length,
                  itemBuilder: (context, index) {
                    final myPizza = myPizzas[index];

                    return Slidable(
                      endActionPane: ActionPane(
                        extentRatio: 0.2,
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (value) async {
                              var scaffoldMessenger =
                                  ScaffoldMessenger.of(context);
                              await myDatabase.db!.rawDelete(
                                  'DELETE FROM pizzas WHERE id = ?', [
                                myPizza['id'],
                              ]);
                              // pop up message
                              scaffoldMessenger.showSnackBar(SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text(
                                    '${myPizza['name']} pizza removed from the Cart',
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  )));
                              getMyPizzas();
                            },
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            icon: Icons.delete,
                          )
                        ],
                      ),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.2,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Row(children: [
                            Image.asset(
                              'assets/${myPizza['image']}',
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      myPizza['name'],
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      'Large',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    Text(
                                      myPizza['toppings'],
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    Text(
                                      '\$ ${myPizza['price']}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ]),
                            ),
                          ]),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ]),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total Bill',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '\$ $total',
                          style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.06,
                      child: ElevatedButton(
                        onPressed: () async {},
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            )),
                        child: Row(
                          children: const [
                            Text(
                              'Place Order',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 20,
                              color: Colors.black,
                            )
                          ],
                        ),
                      ),
                    )
                  ]),
            ),
          ),
        ],
      )),
    );
  }
}
