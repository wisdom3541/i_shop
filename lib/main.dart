import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:i_shop/model/product_details_model.dart';
import 'package:i_shop/services/products_services.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'iShop',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'iShop'),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  List<MainProductDetails> cartProductList = [];

  void addToCart(MainProductDetails product) {
    cartProductList.add(product);
    notifyListeners();
  }

  void _showDialog(
      BuildContext context, String productName, MainProductDetails product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add to Cart'),
          content: Text('Add $productName to your Cart?'),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Step 3: Implement Cancel button
                TextButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
                // Step 3: Implement Add button
                TextButton(
                  child: Text('Yes'),
                  onPressed: () {
                    // Add your functionality here
                    addToCart(product);
                    Navigator.of(context).pop();
                    createSnackBar(context,
                        "Produuct has been added to cart"); // Close the dialog
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

//typedef MyCallback = void Function(ProductDetails parameter);

//main app homePage
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<MyAppState>(context, listen: true);
    Widget currentPage = const ProductPage();
    switch (selectedIndex) {
      case 0:
        currentPage = const ProductPage(); //Product(state: updateC );
        break;

      case 1:
        //var list = getList();
        currentPage = Checkout(
          list: appState.cartProductList,
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
  final List<MainProductDetails> list;
  const Checkout({super.key, required this.list});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  //final _MyHomePageState state;

  //late List<MainProductDetails> _checkoutProductList;
  late bool isCartEmpty = false;
  late bool orderBtnVisibilty = true;

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<MyAppState>(context, listen: true);
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
                      itemCount: appState.cartProductList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {},
                          child: Container(
                              child:
                                  newListCard(appState.cartProductList[index])),
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

//Product List Page that displays list of products

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  _MyHomePageState1 createState() => _MyHomePageState1();
}

class _MyHomePageState1 extends State<ProductPage> {
  late Future<List<ProductItemDetails>> futureProductDetails;
  late Future<List<MainProductDetails>> mainProductDetails;

  @override
  void initState() {
    super.initState();
    // futureProductDetails = fetchProductDetails();
    mainProductDetails = ProductsServices().fetchMainProductDetails();
  }

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<MyAppState>(context, listen: true);
    return Scaffold(
      body: FutureBuilder<List<MainProductDetails>>(
        future: mainProductDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var productDetails = snapshot.data![index];
                var imageUrl = productDetails.imageUrl.toString();
                var productName = productDetails.productName.toString();
                var productDescription =
                    productDetails.productDescription.toString();
                var productPrice = productDetails.productPrice.toString();

                MainProductDetails currentProduct = MainProductDetails(
                    imageUrl: imageUrl,
                    productName: productName,
                    productDescription: productDescription,
                    productPrice: productPrice);

                print(productDetails.imageUrl.toString());
                return GestureDetector(
                    onTap: () {
                      appState._showDialog(
                          context, productName, currentProduct);

                      //print(appState.cartProductList.first.toString());
                    },
                    child: newListCard(MainProductDetails(
                        imageUrl: imageUrl,
                        productName: productName,
                        productDescription: productDescription,
                        productPrice: productPrice)));
              },
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}

Widget newListCard(MainProductDetails productDetails) {
  return Card(
      color: Colors.white,
      elevation: 5,
      child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(children: [
            Placeholder(
              child: SizedBox(
                height: 130,
                width: 130,
                child: Image.network(
                  productDetails.imageUrl.toString(),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          maxLines: 1,
                          productDetails.productName.toString(),
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Text(
                            maxLines: 1,
                            //split string to remove decimal
                            "₦${productDetails.productPrice.toString().split(".")[0]}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          )),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          productDetails.productDescription.toString(),
                          style: const TextStyle(
                              fontStyle: FontStyle.italic, fontSize: 15),
                          maxLines: 2,
                        )),
                    // Padding(
                    //     padding: const EdgeInsets.all(10),
                    //     child: Text(imageUrl)),
                  ],
                ))
          ])));
}
