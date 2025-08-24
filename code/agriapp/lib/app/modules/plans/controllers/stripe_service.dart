import 'dart:convert';
import 'package:http/http.dart' as http;

class StripeService {
  static const String _baseUrl = 'https://api.stripe.com/v1';
  static const String _apiKey = 'sk_test_xxxx';  // Replace with your Stripe secret key

    static Future<List<Map<String, dynamic>>> getProducts() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/products'),
      headers: {
        'Authorization': 'Bearer $_apiKey',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final products = List<Map<String, dynamic>>.from(data['data']);
      return products;
    } else {
      throw Exception('Failed to load products');
    }
  }

  static Future<List<Map<String, dynamic>>> getPrices(String productId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/prices?product=$productId'),
      headers: {
        'Authorization': 'Bearer $_apiKey',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final prices = List<Map<String, dynamic>>.from(data['data']);
      return prices;
    } else {
      throw Exception('Failed to load prices');
    }
  }
}
