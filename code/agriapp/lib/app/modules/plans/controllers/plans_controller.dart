import 'package:get/get.dart';
import 'stripe_service.dart';

class PlansController extends GetxController {
  var products = <Map<String, dynamic>>[].obs;
 var prices = <String, List<Map<String, dynamic>>>{}.obs; // Use RxMap with correct types
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  void fetchProducts() async {
    try {
      isLoading.value = true;
      final productList = await StripeService.getProducts();
      products.assignAll(productList);

      // Fetch prices for each product
      for (var product in products) {
        final productId = product['id'];
        final priceList = await StripeService.getPrices(productId);
        prices[productId] = priceList;
      }
    } catch (e) {
      print('Error fetching products or prices: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
