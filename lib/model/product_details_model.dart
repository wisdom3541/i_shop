class MainProductDetails {
  final String? imageUrl;
  final String? productName;
  final String? productDescription;
  final String? productPrice;
  final double? productQuantity;

  const MainProductDetails(
      {required this.imageUrl,
      required this.productName,
      required this.productDescription,
      required this.productPrice,
      required this.productQuantity});

  factory MainProductDetails.fromJson(Map<String, dynamic> json) {
    var appendUrl = json["photos"][0]['url'];
    return MainProductDetails(
        productName: json["name"],
        productDescription: json["description"],
        imageUrl: "https://api.timbu.cloud/images/$appendUrl",
        productPrice: json["current_price"][0]['NGN'][0].toString(),
        productQuantity: json["available_quantity"]);
  }
}
