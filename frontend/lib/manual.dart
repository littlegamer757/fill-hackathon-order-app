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
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Positioned(
            bottom: -450,
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
        begin: Offset(0, -1),
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
          alignment: Alignment.topCenter,
          child:
            ModelViewer(
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
              'Hint',
              style: normalRed,
            ),
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28.0))),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
            ).merge(ElevatedButton.styleFrom(minimumSize: const Size(150, 56))),
            onPressed: () {},
            icon: const Icon(
              // <-- Icon
              Icons.lightbulb_outlined,
              size: 26.0,
              color: filliRed,
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
            'assets/splashRed.svg',
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          )),
    );
  }
}
