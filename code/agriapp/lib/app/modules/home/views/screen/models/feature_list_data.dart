import 'package:agri_ai/config/translations/strings_enum.dart';
import 'package:get/get.dart';

class FeatureListData {
  FeatureListData({
    this.imagePath = '',
    this.titleTxt = '',
    this.startColor = '',
    this.endColor = '',
    this.description,
  });

  String imagePath;
  String titleTxt;
  String startColor;
  String endColor;
  String? description;

    static List<FeatureListData> tabIconsList = <FeatureListData>[
      FeatureListData(
        imagePath: 'assets/images/chat_ai.png',
        titleTxt: Strings.chatAIExpert.tr,
        description: Strings.aiAdvice.tr,
        startColor: '#FA7D82',
        endColor: '#FFB295',
      ),
      FeatureListData(
        imagePath: 'assets/images/chat_human.png',
        titleTxt: Strings.chatHumanExpert.tr,
        description: Strings.humanAdvice.tr,
        startColor: '#738AE6',
        endColor: '#5C5EDD',
      ),
    ];

}