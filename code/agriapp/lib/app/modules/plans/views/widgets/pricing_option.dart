import 'package:agri_ai/app/components/gradient_text.dart';
import 'package:agri_ai/app/modules/plans/controllers/plans_controller.dart';
import 'package:agri_ai/app/modules/plans/views/widgets/no_credit_card.dart';
import 'package:agri_ai/config/theme/app_theme.dart';
import 'package:agri_ai/config/translations/strings_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Main widget
class PricingOptionsWidget extends StatelessWidget {
  const PricingOptionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final PlansController controller = Get.find();

    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.products.isEmpty) {
          return Center(child: Text('No products available'));
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: controller.products.length,
                  itemBuilder: (context, index) {
                    final product = controller.products[index];
                    final productId = product['id'] as String;
                    final productPrices = controller.prices[productId] ?? [];
                    final List<String> features = [
                      Strings.aiAdvice.tr,
                      Strings.humanAdvice.tr,
                      Strings.chatHumanExpert.tr,
                    ];

                    return Card(
                      margin: const EdgeInsets.all(8.0),
                    
                                            color: Colors.white, 
                      elevation: 4.0, 
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0), 
                      ),

                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              title: GradientText(text: product['name']),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                             
                                  const SizedBox(height: 8.0),
                                
                                  ...productPrices.map((price) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0),
                                      child: Text(
                                        '\$${price['unit_amount'] / 100} / ${price['recurring']['interval']}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                    );
                                  }).toList(),
                                ],
                              ),
                            ),
                            // Adding FeatureItem widgets
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: features
                                  .map((feature) => FeatureItem(text: feature))
                                  .toList(),
                            ),
                        
                            SizedBox(height: 10.0.h),
                            ElevatedButton(
                             style: ElevatedButton.styleFrom(
                                      backgroundColor: AppTheme.nearlyDarkGreen,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24, vertical: 12),
                                    ),
                              onPressed: () {
                                // Handle button press
                              },
                              child: Text(
                                Strings.tryForFree.tr,
                                style: const TextStyle(
                                  fontFamily: AppTheme.fontName,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  letterSpacing: 0.5,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(height: 5.0.h),
                            const NoCreditCardWidget(),
                            SizedBox(height: 5.0.h),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

// PricingOption widget for displaying individual pricing options
class PricingOption extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String price;
  final bool isPopular;
  final bool isHighlighted;
  final String? savings;

  const PricingOption({
    super.key,
    required this.title,
    this.subtitle,
    required this.price,
    this.isPopular = false,
    this.isHighlighted = false,
    this.savings,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: 100,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: isHighlighted ? Colors.green : Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          if (subtitle != null) Text(subtitle!),
          Text(price),
          if (savings != null)
            Text(savings!, style: const TextStyle(color: Colors.green)),
        ],
      ),
    );
  }
}

class FeatureItem extends StatelessWidget {
  final String text;

  const FeatureItem({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
