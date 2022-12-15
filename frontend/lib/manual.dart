import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:simple_shadow/simple_shadow.dart';

import 'globals.dart';

class Manual extends StatefulWidget {
  const Manual({Key? key}) : super(key: key);

  @override
  _ManualState createState() => _ManualState();
}

class _ManualState extends State<Manual>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    Timer(Duration(milliseconds: 2000), () => _animationController.forward());

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
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
                animationController: _animationController),
          ),
          Column(
            children: [
              Stack(
                children: [
                  TextHeaderSlider(animationController: _animationController),
                  TextFilliSlider(animationController: _animationController),
                ],
              ),
              Expanded(
                child: FilliSlider(animationController: _animationController),
              ),
              ButtonSlider(animationController: _animationController)
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
                style: bigRegularRed
            )));
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
              style: bigBoldWhite,
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
          child: Image.asset(
            'assets/giphy.gif',
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
