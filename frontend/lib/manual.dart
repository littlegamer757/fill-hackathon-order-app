import 'dart:async';

import 'package:fill_hackathon/qr_reader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_svg/svg.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

import 'globals.dart';

class Manual extends StatefulWidget {
  const Manual({Key? key}) : super(key: key);

  @override
  _ManualState createState() => _ManualState();
}

var backgroundColor = Colors.white;

class _ManualState extends State<Manual> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _earlyAnimationController;
  late AnimationController _endAnimationController;
  late Animation<double> _animationFadeIn;
  late AnimationController _animationControllerOut;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    Timer(Duration(milliseconds: 2000), () => _animationController.forward());

    _earlyAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    Timer(Duration(milliseconds: 1800), () => _earlyAnimationController.forward());

    _endAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));

    _animationControllerOut = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    Timer(Duration(milliseconds: 3000), () => _animationControllerOut.forward());
    _animationFadeIn =
        Tween(begin: 0.0, end: 1.0).animate(_animationControllerOut);

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
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Positioned(
            bottom: -450,
            child: SplashBackground(
                animationController: _earlyAnimationController),
          ),
          Column(
            children: [
              Stack(
                children: [
                  TextHeaderSlider(animationController: _animationController),
                  TextFilliSlider(animationController: _earlyAnimationController),
                ],
              ),
              Expanded(
                child: FilliFader(animation: _animationFadeIn),
              ),
              CarouselSlider(animationController: _animationController),
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
            child: const Text('Hi I\'m ', style: bigRegularBlack)));
  }
}

class CarouselSlider extends StatelessWidget {
  final AnimationController animationController;

  CarouselSlider({
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
        alignment: Alignment.centerLeft,
        child: FlutterCarousel(
          items: [
            "Swipe here to get to know me.",
            "First, try to shake my hand.",
            "Look, I can also move my feet so we can dance!",
            "Even my antennas can be adjusted for improved internet speed.",
            "Now it's your turn to discover my secrets!"
          ].asMap().entries.map((entry) {
            int idx = entry.key;
            String val = entry.value;

            List<Widget> colItems = [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Text(
                  val,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ];

            if (idx == 4) {
              colItems.add(Padding(
                padding: const EdgeInsets.only(top: 8),
                child: ElevatedButton.icon(
                  label: const Text(
                    'Hint',
                    style: TextStyle(
                      color: filliRed,
                      fontSize: 18,
                    ),
                  ),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28.0))),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                  ).merge(
                      ElevatedButton.styleFrom(minimumSize: const Size(100, 44))),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => QrReader()));
                  },
                  icon: const Icon(
                    // <-- Icon
                    Icons.lightbulb_outlined,
                    size: 22.0,
                    color: filliRed,
                  ),
                ),
              ));
            }

            return Builder(builder: (BuildContext context) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: colItems,
              );
            });
          }).toList(),
          options: CarouselOptions(
            showIndicator: true,
            height: 165,
            slideIndicator: const CircularSlideIndicator(
              indicatorBackgroundColor: filliLightRed,
              currentIndicatorColor: Colors.white,
            ),
          ),
        ),
      ),
    );
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
              'Filli Future!',
              style: bigBoldRed,
            )));
  }
}

class FilliFader extends StatelessWidget {
  final Animation<double> animation;

  FilliFader({
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
        child: Container(
          alignment: Alignment.topCenter,
          child: ModelViewer(
            src: 'assets/BG-Filli.glb',
            autoRotate: true,
            cameraControls: true,
            backgroundColor: Colors.transparent,
          ),
          // child: Image.asset(
          //   'assets/giphy.gif',
          //   width: MediaQuery.of(context).size.width / 1.7,
          //   fit: BoxFit.scaleDown,
          // ),
        ));
  }
}

class ButtonSlider extends StatelessWidget {
  final AnimationController animationController;
  final AnimationController endAnimationController;
  final Function callback;

  ButtonSlider(
      {required this.animationController,
      required this.endAnimationController,
      required this.callback});

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
              'Hint',
              style: normalRed,
            ),
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28.0))),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
            ).merge(ElevatedButton.styleFrom(minimumSize: const Size(150, 56))),
            onPressed: () {
              Navigator.of(context).push(createStepperRoute());
            },
            icon: const Icon(
              // <-- Icon
              Icons.lightbulb_outlined,
              size: 26.0,
              color: filliRed,
            ),
          ),
        ));
  }

  Route createStepperRoute() {
    endAnimationController.forward();
    // Future.delayed(const Duration(milliseconds: 100),
    //         () => {callback()});
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const QrReader(),
      transitionDuration: const Duration(milliseconds: 2500),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
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
            'assets/splashRed.svg',
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          )),
    );
  }
}
