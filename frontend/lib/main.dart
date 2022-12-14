import 'package:fill_hackathon/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:simple_shadow/simple_shadow.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'ProductSans',
        scaffoldBackgroundColor: Color.fromARGB(255, 203, 69, 95),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned(
            bottom: -200,
            child: SimpleShadow(
              opacity: 0.6,
              color: Colors.black,
              offset: Offset(5, 5),
              sigma: 7,
              child: SvgPicture.asset(
                'assets/splash.svg',
                alignment: Alignment.bottomCenter,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 100, left: 35),
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Get the newest ',
                        style: TextStyle(
                            fontSize: 28,
                            color: Color.fromARGB(255, 255, 208, 217))),
                    Text('Filli Future ',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 40,
                        )),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.bottomCenter,
                  child: SvgPicture.asset(
                    'assets/BG-Filli.svg',
                    width: MediaQuery.of(context).size.width / 1.7,
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ),
              Container(
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
                  ).merge(ElevatedButton.styleFrom(
                      minimumSize: const Size(150, 56))),
                  onPressed: () {},
                  icon: const Icon(
                    // <-- Icon
                    Icons.shopping_cart_outlined,
                    size: 26.0,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
