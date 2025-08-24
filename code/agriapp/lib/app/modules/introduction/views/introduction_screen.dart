import 'package:agri_ai/config/theme/app_theme.dart';

import 'components/Two_view.dart';
import 'components/center_next_button.dart';
import 'components/Three_vew.dart';
import 'components/one_view.dart';
import 'components/splash_view.dart';
import 'components/top_back_skip_view.dart';
import 'components/welcome_view.dart';
// import 'package:chat_ai_plants/screens/home.dart';
import 'package:flutter/material.dart';

// import 'components/select_language_view.dart';

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({super.key});

  @override
  _IntroductionScreenState createState() =>
      _IntroductionScreenState();
}

class _IntroductionScreenState
    extends State<IntroductionScreen> with TickerProviderStateMixin {
  AnimationController? _animationController;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 8));
    _animationController?.animateTo(0.0);
    super.initState();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  void _navigateToHome(BuildContext context) {
    // Navigator.of(context).pushReplacement(
    //   MaterialPageRoute(builder: (context) => Home()),
    // );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return  LanguageSelectionPage(    animationController: _animationController!,
  //             onNextClick: _onNextClick);
  // }

  @override
  Widget build(BuildContext context) {
    print(_animationController?.value);
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: ClipRect(
        child: Stack(
          children: [
       
            SplashView(
              animationController: _animationController!,
            ),
            OneView(
              animationController: _animationController!,
            ),
            TowView(
              animationController: _animationController!,
            ),
            ThreeView(
              animationController: _animationController!,
            ),
            WelcomeView(
              animationController: _animationController!,
            ),
            TopBackSkipView(
              onBackClick: _onBackClick,
              onSkipClick: _onSkipClick,
              animationController: _animationController!,
            ),
            CenterNextButton(
              animationController: _animationController!,
              onNextClick: _onNextClick,
            ),
          ],
        ),
      ),
    );
  }

  void _onSkipClick() {
    _animationController?.animateTo(0.8,
        duration: const Duration(milliseconds: 1200));
  }

  void _onBackClick() {
    if (_animationController!.value >= 0 &&
        _animationController!.value <= 0.2) {
      _animationController?.animateTo(0.0);
    } else if (_animationController!.value > 0.2 &&
        _animationController!.value <= 0.4) {
      _animationController?.animateTo(0.2);
    } else if (_animationController!.value > 0.4 &&
        _animationController!.value <= 0.6) {
      _animationController?.animateTo(0.4);
    } else if (_animationController!.value > 0.6 &&
        _animationController!.value <= 0.8) {
      _animationController?.animateTo(0.6);
    } else if (_animationController!.value > 0.8 &&
        _animationController!.value <= 1.0) {
      _animationController?.animateTo(0.8);
    }
  }

  void _onNextClick() {
    if (_animationController!.value >= 0 &&
        _animationController!.value <= 0.2) {
      _animationController?.animateTo(0.4);
    } else if (_animationController!.value > 0.2 &&
        _animationController!.value <= 0.4) {
      _animationController?.animateTo(0.6);
    } else if (_animationController!.value > 0.4 &&
        _animationController!.value <= 0.6) {
      _animationController?.animateTo(0.8);
    } else if (_animationController!.value > 0.6 &&
        _animationController!.value <= 0.8) {
      _signUpClick(context);
    }
  }

  void _signUpClick(BuildContext context) {
    _navigateToHome(context);
  }
}
