class ProductItemDetails {
  final String? name;
  final String? description;
  final String? id;
  final dynamic? photosDetails;
  final List<dynamic> price;

  const ProductItemDetails(
      {required this.name,
      required this.description,
      required this.id,
      required this.photosDetails,
      required this.price});

  factory ProductItemDetails.fromJson(Map<String, dynamic> json) {
    return ProductItemDetails(
        name: json["name"],
        description: json["description"],
        id: json["id"],
        photosDetails: json["photos"],
        price: json["current_price"]);
  }
}

class MainProductDetails {
  final String? imageUrl;
  final String? productName;
  final String? productDescription;
  final String? productPrice;

  const MainProductDetails(
      {required this.imageUrl,
      required this.productName,
      required this.productDescription,
      required this.productPrice});

  factory MainProductDetails.fromJson(Map<String, dynamic> json) {
    var appendUrl = json["photos"][0]['url'];
    return MainProductDetails(
        productName: json["name"],
        productDescription: json["description"],
        imageUrl: "https://api.timbu.cloud/images/$appendUrl",
        productPrice: json["current_price"][0]['NGN'][0].toString());
  }
}
