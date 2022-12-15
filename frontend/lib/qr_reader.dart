import 'dart:async';

import 'package:fill_hackathon/globals.dart';
import 'package:fill_hackathon/dino/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:simple_shadow/simple_shadow.dart';

class QrReader extends StatefulWidget {
  const QrReader({Key? key}) : super(key: key);

  @override
  _QrReader createState() => _QrReader();
}

class _QrReader extends State<QrReader> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _earlyAnimationController;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 600));
    Timer(Duration(milliseconds: 1500), () => _animationController.forward());

    _earlyAnimationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    Timer(
        Duration(milliseconds: 800), () => _earlyAnimationController.forward());

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MobileScannerController cameraController = MobileScannerController();

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(children: [
            Positioned(
              top: 150,
              child: CameraSlide(
                animationController: _earlyAnimationController,
                cameraController: cameraController,
              ),
            ),
            Positioned(
              bottom: -220,
              child: SplashBackground(
                animationController: _earlyAnimationController,
                src: 'assets/splashShort.svg',
              ),
            ),
            // Positioned(
            //   top: -225,
            //   child: SplashBackground(
            //     animationController: _animationController,
            //     src: 'assets/splashShortUpsideDown.svg',),
            // ),
            Positioned(
              top: -400,
              child: SplashBackground(
                animationController: _animationController,
                src: 'assets/splashRedUpsideDown.svg',
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.only(bottom: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: IconButton(
                      onPressed: () {
                        cameraController.switchCamera();
                      },
                      icon: Icon(Icons.camera_front, color: filliRed),
                      iconSize: 32,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: IconButton(
                      onPressed: () {
                        cameraController.toggleTorch();
                      },
                      icon: Icon(Icons.flash_on, color: filliRed),
                      iconSize: 32,
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ],
      ),
    );
  }
}

class SplashBackground extends StatelessWidget {
  final AnimationController animationController;
  final String src;

  SplashBackground({required this.animationController, required this.src});

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
        position: Tween<Offset>(
          begin: Offset(0, 1),
          end: Offset.zero,
        ).animate(animationController),
        // child: SimpleShadow(
        //     opacity: 0.6,
        //     color: Colors.black,
        //     offset: Offset(5, 5),
        //     sigma: 7,
        child: SvgPicture.asset(
          src,
          alignment: Alignment.bottomCenter,
          width: MediaQuery.of(context).size.width,
        ));
    // );
  }
}

class CameraSlide extends StatelessWidget {
  final AnimationController animationController;
  final MobileScannerController cameraController;

  CameraSlide(
      {required this.animationController, required this.cameraController});

  @override
  Widget build(BuildContext context) {
    // MobileScannerController cameraController = MobileScannerController();

    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(0, 1),
        end: Offset.zero,
      ).animate(animationController),
      child: SizedBox(
        height: 750,
        width: MediaQuery.of(context).size.width,
        child: MobileScanner(
          allowDuplicates: false,
          controller: cameraController,
          onDetect: (barcode, args) {
            if (barcode.rawValue == null) {
              debugPrint('Failed to scan Barcode');
            } else {
              final String code = barcode.rawValue!;
              if (code == "d2F0ZXJieXRlIGJlc3Rl") {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const DinoApp()));
              }
              debugPrint('Barcode found! $code');
            }
          },
        ),
      ),
    );
  }
}
