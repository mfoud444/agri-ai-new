import 'package:agri_ai/app/controllers/auth_controller.dart';
import 'package:agri_ai/app/data/providers/app_setting_provider.dart';
import 'package:agri_ai/config/translations/strings_enum.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:agri_ai/config/translations/localization_service.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsView extends GetView<SettingsController> {
  final AppSettingProvider appSettingProvider = Get.find();

   SettingsView({super.key});

@override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final supportedLocales = LocalizationService.supportedLanguages.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.settings.tr),
      ),
      body: Obx(() {
        final appSetting = appSettingProvider.appSetting.value;

        if (appSetting == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return SettingsList(
          sections: [
            SettingsSection(
              title: Text(Strings.common.tr),
              tiles: <SettingsTile>[
                SettingsTile.navigation(
                  leading: const Icon(Icons.language),
                  title: Text(Strings.language.tr),
                  value: Obx(() => Text(controller.selectedLanguage.value.languageCode == 'en' ? 'English' : 'Arabic')),
                  onPressed: (context) => _showLanguageDialog(context, supportedLocales, theme),
                )
              ],
            ),
            SettingsSection(
              title: Text(Strings.account.tr),
              tiles: <SettingsTile>[
                SettingsTile.navigation(
                  leading: const Icon(Icons.exit_to_app),
                  title: Text(Strings.signOut.tr),
                  onPressed: (context) async {
                   await Get.find<AuthController>().logout();
                  },
                ),
              ],
            ),
            SettingsSection(
              title: Text(Strings.legal.tr),
              tiles: <SettingsTile>[
                SettingsTile.navigation(
                  leading: const Icon(Icons.description),
                  title: Text(Strings.termsOfUse.tr),
                  onPressed: (context) {
                    if (appSetting.termsOfUseUrl != null) {
                      _launchURL(appSetting.termsOfUseUrl ?? '');
                    }
                  },
                ),
                SettingsTile.navigation(
                  leading: const Icon(Icons.privacy_tip),
                  title: Text(Strings.privacyPolicy.tr),
                  onPressed: (context) {
                    if (appSetting.privacyPolicyUrl != null) {
                      _launchURL(appSetting.privacyPolicyUrl ?? '');
                    }
                  },
                ),
              ],
            ),
          ],
        );
      }),
    );
  }


 void _showLanguageDialog(BuildContext context, List<Locale> supportedLocales, ThemeData theme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(Strings.chooseLanguage.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: supportedLocales.map((locale) {
            return ListTile(
              title: Text(locale.languageCode == 'en' ? 'English' : 'Arabic'),
              onTap: () {
                controller.updateLanguage(locale);
                Get.back();
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
