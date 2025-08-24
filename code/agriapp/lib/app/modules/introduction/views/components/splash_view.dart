import 'package:agri_ai/config/translations/strings_enum.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agri_ai/app/components/gradient_text.dart';
import 'package:agri_ai/config/translations/localization_service.dart';

class SplashView extends StatefulWidget {
  final AnimationController animationController;

  const SplashView({super.key, required this.animationController});

  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  Locale? _selectedLocale;

  @override
  void initState() {
    super.initState();
    _selectedLocale = LocalizationService.getCurrentLocal();
  }

  @override
  Widget build(BuildContext context) {
    final List<Locale> supportedLocales =
        LocalizationService.supportedLanguages.values.toList();
    final theme = Theme.of(context);

    final introductionanimation =
        Tween<Offset>(begin: const Offset(0, 0), end: const Offset(0.0, -1.0))
            .animate(CurvedAnimation(
      parent: widget.animationController,
      curve: const Interval(
        0.0,
        0.2,
        curve: Curves.fastOutSlowIn,
      ),
    ));
    return SlideTransition(
      position: introductionanimation,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 100,
              ),
              Container(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                  top: 16,
                  bottom: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GradientText(text: Strings.select.tr),
                    GradientText(text: Strings.language.tr),
                  ],
                ),
              ),
              const SizedBox(
                height: 150,
              ),
              Center(
                child: Column(
                  children: supportedLocales.map((Locale locale) {
                    return RadioListTile<Locale>(
                      title: Text(
                        locale.languageCode == 'en'
                            ? Strings.english.tr
                            : Strings.arabic.tr,
                        style: theme.textTheme.bodyLarge,
                      ),
                      value: locale,
                      groupValue: _selectedLocale,
                      onChanged: (Locale? newLocale) {
                        setState(() {
                          _selectedLocale = newLocale;
                        });
                        if (newLocale != null) {
                          LocalizationService.updateLanguage(
                              newLocale.languageCode);
                        }
                      },
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(
                height: 150,
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom + 16),
                child: InkWell(
                  onTap: () {
                    widget.animationController.animateTo(0.2);
                  },
                  child: Container(
                    height: 58,
                    padding: const EdgeInsets.only(
                      left: 56.0,
                      right: 56.0,
                      top: 16,
                      bottom: 16,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(38.0),
                      color: const Color(0xff132137),
                    ),
                    child: Text(
                      Strings.letsBegin.tr,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
