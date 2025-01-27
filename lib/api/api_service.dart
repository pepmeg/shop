import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../models/category.dart';

class ApiService {
  final String productApiUrl =
      'http://onlinestore.whitetigersoft.ru/api/common/product/details?appKey=EyZ6DhtHN24DjRJofNZ7BijpNsAZ-TT1is4WbJb9DB7m83rNQCZ7US0LyUg5FCP4eoyUZXmM1z45hY5fIC-JTCgmqHgnfcevkQQpmxi8biwwlSn0zZedvlNh0QkP1-Um';

  final String categoryApiUrl =
      'https://onlinestore.whitetigersoft.ru/api/common/category/list?appKey=EyZ6DhtHN24DjRJofNZ7BijpNsAZ-TT1is4WbJb9DB7m83rNQCZ7US0LyUg5FCP4eoyUZXmM1z45hY5fIC-JTCgmqHgnfcevkQQpmxi8biwwlSn0zZedvlNh0QkP1-Um';

  Future<List<Product>> fetchProductDetails() async {
    final response = await http.get(Uri.parse(productApiUrl));
    final jsonData = json.decode(response.body);
    return (jsonData['data'] as List)
        .map((item) => Product.fromJson(item))
        .toList();
  }

  Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse(categoryApiUrl));
    final jsonData = json.decode(response.body);
    return (jsonData['data']['categories'] as List)
        .map((item) => Category.fromJson(item))
        .toList();
  }
}