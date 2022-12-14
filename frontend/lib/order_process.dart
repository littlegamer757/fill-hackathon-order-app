import 'dart:async';
import 'dart:collection';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:simple_shadow/simple_shadow.dart';

import 'globals.dart';

class OrderProcessRoute extends StatefulWidget {
  @override
  _HomeLoadedPage createState() => _HomeLoadedPage();
}

class _HomeLoadedPage extends State<OrderProcessRoute>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _earlyAnimationController;
  late AnimationController _lateAnimationController;
  late AnimationController _headerAnimationController;
  late AnimationController _filliHeaderAnimationController;

  @override
  void initState() {
    _earlyAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 700));
    Timer(Duration(milliseconds: 1650),
        () => _earlyAnimationController.forward());

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    Timer(Duration(milliseconds: 2000), () => _animationController.forward());

    _lateAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    Timer(
        Duration(milliseconds: 1800), () => _lateAnimationController.forward());

    _headerAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    Timer(Duration(milliseconds: 3200),
        () => _headerAnimationController.forward());

    _filliHeaderAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    Timer(Duration(milliseconds: 3000),
            () => _filliHeaderAnimationController.forward());

    super.initState();
  }

  @override
  void dispose() {
    _earlyAnimationController.dispose();
    _animationController.dispose();
    _lateAnimationController.dispose();
    _headerAnimationController.dispose();
    _filliHeaderAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned(
            bottom: -200,
            child: SplashBackground(
                animationController: _earlyAnimationController),
          ),
          Column(
            children: [
              Stack(
                children: [
                  TextHeaderSlider(animationController: _headerAnimationController),
                  TextFilliSlider(animationController: _filliHeaderAnimationController),
                ],
              ),
              Expanded(
                child: FilliSlider(animationController: _animationController),
              ),
              ButtonSlider(animationController: _lateAnimationController)
            ],
          )
        ],
      ),
    );
  }
}

class TextHeaderSlider extends StatelessWidget {
  final AnimationController animationController;

  TextHeaderSlider({
    required this.animationController,
  });

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
        position: Tween<Offset>(
          begin: Offset(0, -1),
          end: Offset.zero,
        ).animate(animationController),
        child: Container(
            margin: const EdgeInsets.only(left: 35, top: 100),
            alignment: Alignment.centerLeft,
            child: const Text('Get the newest ',
                style: TextStyle(
                    fontSize: 28, color: Color.fromARGB(255, 255, 208, 217)))));
  }
}

class TextFilliSlider extends StatelessWidget {
  final AnimationController animationController;

  TextFilliSlider({
    required this.animationController,
  });

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
        position: Tween<Offset>(
          begin: Offset(0, -1),
          end: Offset.zero,
        ).animate(animationController),
        child: Container(
            margin: const EdgeInsets.only(left: 35, top: 132),
            alignment: Alignment.centerLeft,
            child: const Text(
              'Filli Future ',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 40,
              ),
            )));
  }
}

class FilliSlider extends StatelessWidget {
  final AnimationController animationController;

  FilliSlider({
    required this.animationController,
  });

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
        position: Tween<Offset>(
          begin: Offset(0, 1.5),
          end: Offset.zero,
        ).animate(animationController),
        child: Container(
          alignment: Alignment.bottomCenter,
          child: SvgPicture.asset(
            'assets/BG-Filli.svg',
            width: MediaQuery.of(context).size.width / 1.7,
            fit: BoxFit.scaleDown,
          ),
        ));
  }
}

class ButtonSlider extends StatelessWidget {
  final AnimationController animationController;

  ButtonSlider({
    required this.animationController,
  });

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
        position: Tween<Offset>(
          begin: Offset(0, 1),
          end: Offset.zero,
        ).animate(animationController),
        child: Container(
          margin: const EdgeInsets.only(bottom: 50.0, top: 25.0),
          child: ElevatedButton.icon(
            label: const Text(
              'Order',
              style: TextStyle(fontSize: 20),
            ),
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28.0))),
              backgroundColor: MaterialStateProperty.all<Color>(filliRed),
            ).merge(ElevatedButton.styleFrom(minimumSize: const Size(150, 56))),
            onPressed: () {},
            icon: const Icon(
              // <-- Icon
              Icons.shopping_cart_outlined,
              size: 26.0,
            ),
          ),
        ));
  }
}

class SplashBackground extends StatelessWidget {
  final AnimationController animationController;

  SplashBackground({
    required this.animationController,
  });

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(0, 1),
        end: Offset.zero,
      ).animate(animationController),
      child: SimpleShadow(
          opacity: 0.6,
          color: Colors.black,
          offset: Offset(5, 5),
          sigma: 7,
          child: SvgPicture.asset(
            'assets/splash2.svg',
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          )),
    );
  }
}
