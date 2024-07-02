import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iShop',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'iShop'),
    );
  }
}

typedef MyCallback = void Function(ProductDetails parameter);

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  List<ProductDetails> productList = products;
  List<ProductDetails> updatedCart = [];

  void updateC(ProductDetails product) {
    setState(() {
      if (updatedCart.contains(product)) {
        // show added to card snackBar
        const snack = SnackBar(
          content: Text("Product is alreeady in cart"),
          duration: Duration(seconds: 1),
          // behavior: SnackBarBehavior.floating ,
        );
        ScaffoldMessenger.of(context).showSnackBar(snack);
      } else {
        updatedCart.add(product);
        createSnackBar(context, "Product as been added to cart");
        print(updatedCart.length);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget currentPage = Product(state: updateC);
    switch (selectedIndex) {
      case 0:
        currentPage = Product(state: updateC);
        break;

      case 1:
        //var list = getList();
        currentPage = Checkout(
          list: updatedCart,
        );
        break;

      default:
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        bottomNavigationBar: NavigationBar(
          backgroundColor: Colors.cyan,
          destinations: bottomNav,
          selectedIndex: selectedIndex,
          onDestinationSelected: (value) {
            setState(() {
              selectedIndex = value;
            });
          },
        ),
        body: Container(
          child: currentPage,
        ));
  }
}

var bottomNav = const [
  NavigationDestination(icon: Icon(Icons.shop), label: "Products"),
  NavigationDestination(icon: Icon(Icons.shop), label: "Checkout")
];

//product page
class Product extends StatelessWidget {
  const Product({super.key, required this.state});

  final MyCallback state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const Center(
            child: Text(
              "Product List",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30.0, color: Colors.black),
            ),
          ),
          Padding(padding: const EdgeInsets.all(5), child: productList(state))
        ],
      ),
    );
  }
}

Widget productList(MyCallback onTap) {
  return Column(
    children: [
      ListView.builder(
          shrinkWrap: true,
          itemCount: products.length,
          itemBuilder: (context, index) {
            return GestureDetector(
                onTap: () {
                  onTap(products[index]);
                },
                child: Container(
                  child: listCard(
                      products[index].name,
                      products[index].description,
                      products[index].rating,
                      products[index].price,
                      false),
                ) //() {
                //   //add clicked item to cart
                //   state._addToCart(products[index]);
                //   //show added to card snackBar
                //   const snack = SnackBar(
                //     content: Text("Product as been added to cart"),
                //     duration: Duration(seconds: 1),
                //     // behavior: SnackBarBehavior.floating ,
                //   );
                //   ScaffoldMessenger.of(context).showSnackBar(snack);
                // },
                );
          }),
    ],
  );
}

Widget listCard(String productName, String description, double rating,
    double price, bool visible) {
  return Card(
    color: Colors.blueGrey,
    elevation: 3,
    child: Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(children: [
        const Placeholder(
          child: SizedBox(
            height: 125,
            width: 150,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                productName,
                style: const TextStyle(fontSize: 25, color: Colors.white),
              ),
              const SizedBox(
                height: 5.0,
              ),
              Text(
                description,
                style: const TextStyle(color: Colors.white),
              ),
              Text(
                "rating: $rating",
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(5),
          child: Text(
            "\$$price",
            style: const TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Visibility(
            visible: visible,
            child: IconButton(
              onPressed: () {
                //removes product from cart
                //state.removeFromCart(products[index]);
              },
              icon: const Icon(Icons.cancel),
              //iconSize: 100,
            ))
      ]),
    ),
  );
}

//checkout page
class Checkout extends StatefulWidget {
  final List<ProductDetails> list;
  const Checkout({super.key, required this.list});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  //final _MyHomePageState state;

  late List<ProductDetails> _checkoutProductList;
  late bool isCartEmpty;
  late bool orderBtnVisibilty;

  @override
  void initState() {
    super.initState();
    _checkoutProductList = widget.list;
    if (_checkoutProductList.isEmpty) {
      isCartEmpty = true;
      orderBtnVisibilty = false;
    } else {
      isCartEmpty = false;
      orderBtnVisibilty = true;
    }
  }

  void removeFromCart(ProductDetails product) {
    setState(() {
      _checkoutProductList.remove(product);
      print(_checkoutProductList.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isCartEmpty) {
      return const Scaffold(
        body: Center(
          child: Text("No Item has been added to cart"),
        ),
      );
    } else {
      return Scaffold(
        body: ListView(
          children: [
            const Center(
              child: Text("Checkout",
                  style: TextStyle(fontSize: 30.0, color: Colors.black)),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                children: [
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: _checkoutProductList.length,
                      itemBuilder: (context, index) {
                        var rating = _checkoutProductList[index].rating;
                        var price = _checkoutProductList[index].price;

                        return GestureDetector(
                          onTap: () {},
                          child: Container(
                              child: Card(
                            color: Colors.blueGrey,
                            elevation: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(children: [
                                const Placeholder(
                                  child: SizedBox(
                                    height: 125,
                                    width: 150,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _checkoutProductList[index].name,
                                        style: const TextStyle(
                                            fontSize: 25, color: Colors.white),
                                      ),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        _checkoutProductList[index].description,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      Text(
                                        "$rating",
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(
                                    "\$$price",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Visibility(
                                    visible: true,
                                    child: IconButton(
                                      onPressed: () {
                                        removeFromCart(
                                            _checkoutProductList[index]);
                                        //removes product from cart
                                        //state.removeFromCart(products[index]);
                                      },
                                      icon: const Icon(Icons.cancel),
                                      //iconSize: 100,
                                    ))
                              ]),
                            ),
                          )

                              // listCard(
                              //     ,
                              //     _checkoutProductList[index].description,
                              //     _checkoutProductList[index].rating,
                              //     _checkoutProductList[index].price,
                              //     true),
                              ),
                        );
                        // IconButton(
                        //   onPressed: () {
                        //     //removes product from cart
                        //     state.removeFromCart(products[index]);
                        //   },
                        //   icon: const Icon(Icons.cancel),
                        //   iconSize: 100,
                        // )
                      }),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Visibility(
                        visible: orderBtnVisibilty,
                        child: MaterialButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const OrderPage()));
                          },
                          color: Colors.cyan,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: const Text("Place your Order"),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      );
    }
  }
}

void createSnackBar(BuildContext context, String message) {
  //show  snackBar
  var snack = SnackBar(
    content: Text(message),
    duration: const Duration(seconds: 1),
    // behavior: SnackBarBehavior.floating ,
  );
  ScaffoldMessenger.of(context).showSnackBar(snack);
}

//order page
class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          "images/orderSucessful.jpg",
        ),
      ),
    );
  }
}

//-------------------------------------data nd dummy----------------------------

//data class for the products
class ProductDetails {
  const ProductDetails(
      {required this.name,
      required this.description,
      required this.rating,
      required this.price});

  final String name;
  final String description;
  final double rating;
  final double price;
}

//dummy list of products
List<ProductDetails> products = [
  const ProductDetails(
      name: "GTA VI",
      description: "A free world action-adventure game",
      rating: 4.8,
      price: 20),
  const ProductDetails(
      name: "Red Dead Redemption",
      description: "A western action-adventure game ",
      rating: 4,
      price: 15),
  const ProductDetails(
      name: "Apex Legends",
      description: "A battle royale-hero shooter multiplayer game",
      rating: 4.5,
      price: 10),
  const ProductDetails(
      name: "SpiderMan 2 Remastered",
      description: "A super hero action-adventure game",
      rating: 4,
      price: 9.99),
  const ProductDetails(
      name: "Last Of Us", description: "description", rating: 4, price: 15),
  const ProductDetails(
      name: "Alan Wake", description: "description", rating: 3.5, price: 9.99),
  const ProductDetails(
      name: "Froza Horizon", description: "description", rating: 3.5, price: 5),
  const ProductDetails(
      name: "FarCry 6", description: "description", rating: 4.5, price: 15),
  const ProductDetails(
      name: "Resident Evil 4",
      description: "description",
      rating: 4,
      price: 9.99),
  const ProductDetails(
      name: "Cyperpunk", description: "description", rating: 3.9, price: 10),
];
