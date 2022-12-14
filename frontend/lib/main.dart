import 'package:fill_hackathon/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:simple_shadow/simple_shadow.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        fontFamily: 'ProductSans',
        scaffoldBackgroundColor: Color.fromARGB(255, 203, 69, 95)
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      // appBar: AppBar(
      //   // Here we take the value from the MyHomePage object that was created by
      //   // the App.build method, and use it to set our appbar title.
      //   title: Text(widget.title),
      // ),
      body: Stack(
        children: <Widget>[
          Positioned(
            bottom: -200,
            child: SimpleShadow(
              opacity: 0.6,
              color: Colors.black,
              offset: Offset(5,5),
              sigma: 7,
              child: SvgPicture.asset(
                'assets/splash.svg',
                alignment: Alignment.bottomCenter,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,),
            )),
          Column(
            // Column is also a layout widget. It takes a list of children and
            // arranges them vertically. By default, it sizes itself to fit its
            // children horizontally, and tries to be as tall as its parent.
            //
            // Invoke "debug painting" (press "p" in the console, choose the
            // "Toggle Debug Paint" action from the Flutter Inspector in Android
            // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
            // to see the wireframe for each widget.
            //
            // Column has various properties to control how it sizes itself and
            // how it positions its children. Here we use mainAxisAlignment to
            // center the children vertically; the main axis here is the vertical
            // axis because Columns are vertical (the cross axis would be
            // horizontal).
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 100, left: 35),
                alignment: Alignment.centerLeft,
                child: Column (
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Get the newest ', style: TextStyle(
                        fontSize: 28,
                      color: Color.fromARGB(255, 255, 208, 217)
                    )),
                    Text('Filli Future ', style: TextStyle(
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
                      fit: BoxFit.scaleDown,),
                  )
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 50.0, top: 25.0),
                child: ElevatedButton.icon(
                  label: const Text('Order', style: TextStyle(
                      fontSize: 20
                  ),),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28.0)
                        )
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(filliRed),
                  ).merge(ElevatedButton.styleFrom(
                      minimumSize: const Size(150, 56)
                  )),
                  onPressed: () {},
                  icon: const Icon( // <-- Icon
                    Icons.shopping_cart_outlined,
                    size: 26.0,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //     label: Text('Order'), // <-- Text
      //     backgroundColor: Color.fromRGBO(203, 69, 95, 80),
      //     icon: Icon( // <-- Icon
      //       Icons.shopping_cart_outlined,
      //       size: 24.0,
      //     ),
      //     onPressed: () {},
      //   ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
