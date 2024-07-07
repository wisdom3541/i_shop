import 'dart:convert';

import 'package:i_shop/model/product_details_model.dart';
import 'package:http/http.dart' as http;

class ProductsServices {
  Future<List<MainProductDetails>> fetchMainProductDetails() async {
    final response = await http.get(Uri.parse(
        "https://api.timbu.cloud/products?organization_id=948bfff2d9814413b87042ea4492956e&reverse_sort=false&page=1&size=10&Appid=NHNNOHE1SCV6BNR&Apikey=3183ab50907e416893b594661287573120240704202043445117"));
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var productsJson = jsonResponse['items'] as List;
      return productsJson
          .map((productJson) => MainProductDetails.fromJson(productJson))
          .toList();
    } else {
      print('Failed to load data: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load products');
    }
  }
}
