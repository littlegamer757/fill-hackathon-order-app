import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrReader extends StatelessWidget {
  const QrReader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MobileScannerController cameraController = MobileScannerController();

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 350,
            width: 350,
            child: MobileScanner(
              allowDuplicates: false,
              controller: cameraController,
              onDetect: (barcode, args) {
                if (barcode.rawValue == null) {
                  debugPrint('Failed to scan Barcode');
                } else {
                  final String code = barcode.rawValue!;
                  if (code == "d2F0ZXJieXRlIGJlc3Rl") {
                    // TODO: Navigate to secret activity
                  }
                  debugPrint('Barcode found! $code');
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: IconButton(
                    onPressed: () {
                      cameraController.switchCamera();
                    },
                    icon: Icon(Icons.camera_front, color: Colors.white),
                    iconSize: 32,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: IconButton(
                    onPressed: () {
                      cameraController.toggleTorch();
                    },
                    icon: Icon(Icons.flash_on, color: Colors.white),
                    iconSize: 32,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}