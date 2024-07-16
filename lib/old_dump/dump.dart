import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:i_shop/model/product_details_model.dart';
import 'package:i_shop/services/products_services.dart';

/// ignore this file...old implementations
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

//main app homePage
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
          automaticallyImplyLeading: false,
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

//BottomNav Items
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

//List Widget for Product page
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
                      products[index].image,
                      products[index].name,
                      products[index].description,
                      products[index].rating,
                      products[index].price,
                      false),
                ));
          }),
    ],
  );
}

//Card display for listWidget
Widget listCard(String image, productName, String description, double rating,
    double price, bool visible) {
  return Card(
    color: Colors.blueGrey,
    elevation: 3,
    child: Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(children: [
        Placeholder(
          child: SizedBox(
            height: 150,
            width: 150,
            child: Image.asset(
              image,
              fit: BoxFit.cover,
            ),
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
                maxLines: 2,
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
              onPressed: () {},
              icon: const Icon(Icons.cancel),
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
    // var api = fetchAlbum();
    //print(api.toString());
    // fetchData();

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
                                Placeholder(
                                  child: SizedBox(
                                    height: 155,
                                    width: 150,
                                    child: Image.asset(
                                        fit: BoxFit.cover,
                                        _checkoutProductList[index].image),
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
                                        maxLines: 2,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      Text(
                                        "Rating: $rating",
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
                                      },
                                      icon: const Icon(Icons.cancel),
                                      //iconSize: 100,
                                    ))
                              ]),
                            ),
                          )),
                        );
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
                          child: const Text("Place your Order",
                              style: TextStyle(
                                color: Colors.white,
                              )),
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

//snackBar
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
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 400,
                width: 400,
                child: Image.asset(
                  "images/orderSucessful.jpg",
                ),
              ),
              const SizedBox(
                height: 60,
                width: double.infinity,
              ),
              const Text(
                "Order Sucessful",
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(10),
                child: MaterialButton(
                  minWidth: double.infinity,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const MyHomePage(title: "iShop")));
                  },
                  color: Colors.cyan,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: const Text("Back to Home",
                      style: TextStyle(
                        color: Colors.white,
                      )),
                ),
              ),
            ]),
      ),
    );
  }
}

//-------------------------------------data nd dummy----------------------------

//data class for the products
class ProductDetails {
  const ProductDetails(
      {required this.image,
      required this.name,
      required this.description,
      required this.rating,
      required this.price});
  final String image;
  final String name;
  final String description;
  final double rating;
  final double price;
}

//dummy list of products
List<ProductDetails> products = [
  const ProductDetails(
      image: "images/gtav.jpeg",
      name: "GTA VI",
      description: "A free world action-adventure game",
      rating: 4.8,
      price: 20),
  const ProductDetails(
      image: "images/reddead.jpeg",
      name: "Red Dead Redemption",
      description: "A western action-adventure game ",
      rating: 4,
      price: 15),
  const ProductDetails(
      image: "images/apexlegends.jpeg",
      name: "Apex Legends",
      description: "A battle royale-hero shooter multiplayer game",
      rating: 4.5,
      price: 10),
  const ProductDetails(
      image: "images/spiderman.jpeg",
      name: "SpiderMan 2 Remastered",
      description: "A super hero action-adventure game",
      rating: 4,
      price: 9.99),
  const ProductDetails(
      image: "images/lastofus.jpeg",
      name: "Last Of Us",
      description: "A post Apocaliptic survival action game ",
      rating: 4,
      price: 15),
  const ProductDetails(
      image: "images/alanwake.jpeg",
      name: "Alan Wake",
      description: "A horror action-adventure game",
      rating: 3.5,
      price: 9.99),
  const ProductDetails(
      image: "images/frozahorizon.jpeg",
      name: "Froza Horizon",
      description: "A 2021 racing video game",
      rating: 3.5,
      price: 5),
  const ProductDetails(
      image: "images/farcry.jpeg",
      name: "FarCry 6",
      description: "A first-person shooter suvival action game",
      rating: 4.5,
      price: 15),
  const ProductDetails(
      image: "images/residentevil.jpeg",
      name: "Resident Evil 4",
      description: "A Japanese survival horror game series",
      rating: 4,
      price: 9.99),
  const ProductDetails(
      image: "images/cyberpunk.jpeg",
      name: "Cyperpunk",
      description: "A action role-playing video game",
      rating: 3.9,
      price: 10),
];
