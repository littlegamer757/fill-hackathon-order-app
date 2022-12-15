import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:fill_hackathon/globals.dart';
import 'package:fill_hackathon/manual.dart';
import 'package:flutter/material.dart';

OrderState state1 = OrderState.active;
OrderState state2 = OrderState.todo;
OrderState state3 = OrderState.todo;

class OrderStepper extends StatefulWidget {
  const OrderStepper({Key? key}) : super(key: key);

  @override
  State<OrderStepper> createState() => _OrderStepperState();
}

class _OrderStepperState extends State<OrderStepper>
    with TickerProviderStateMixin {
  late AnimationController _animationControllerOut;
  late Animation<double> _animationFadeOut;

  late AnimationController _animationControllerOut2;
  late AnimationController _animationControllerIn2;
  late Animation<double> _animationFadeOut2;
  late Animation<double> _animationFadeIn2;

  late AnimationController _animationControllerIn3;
  late Animation<double> _animationFadeIn3;

  late AnimationController _endAnimationController;

  @override
  void initState() {
    _animationControllerOut = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    _animationControllerOut2 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    _animationControllerIn2 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    _animationControllerIn3 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    _animationFadeOut =
        Tween(begin: 1.0, end: 0.0).animate(_animationControllerOut);

    _animationFadeOut2 =
        Tween(begin: 1.0, end: 0.0).animate(_animationControllerOut2);

    _animationFadeIn2 =
        Tween(begin: 0.0, end: 1.0).animate(_animationControllerIn2);

    _animationFadeIn3 =
        Tween(begin: 0.0, end: 1.0).animate(_animationControllerIn3);

    _endAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));

    super.initState();
  }

  @override
  void dispose() {
    _animationControllerOut.dispose();
    _animationControllerOut2.dispose();
    _animationControllerIn2.dispose();
    _animationControllerIn3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void handleMessage(Uint8List data) {
      final message = String.fromCharCodes(data);
      print('[Client] Received a message: $message');

      if (!message.startsWith("[status]")) {
        print(
            "[Client] Received a message that is not a status update ($message).");
        return;
      }

      String statusUpdate = message.substring("[status] ".length);

      switch (statusUpdate) {
        case "confirmed":
          print("[Client] Statusupdate received: $message.");
          Timer(const Duration(milliseconds: 1500),
              () => _animationControllerOut.forward());
          Timer(
              const Duration(milliseconds: 2000),
              () => {
                    _animationControllerIn2.forward(),
                    setState(() {
                      state1 = OrderState.done;
                      state2 = OrderState.active;
                    })
                  });

          break;
        case "delivering":
          print("[Client] Statusupdate received: $message.");
          state2 = OrderState.done;
          state3 = OrderState.active;
          break;
        case "arrived":
          print("[Client] Statusupdate received: $message.");
          Timer(
              const Duration(milliseconds: 1500),
              () => {
                    _animationControllerOut2.forward(),
                    setState(() {
                      state2 = OrderState.done;
                      state3 = OrderState.active;
                    })
                  });
          Timer(
              const Duration(milliseconds: 2000),
              () => {
                    _animationControllerIn3.forward(),
                  });
          Timer(
              const Duration(milliseconds: 3000),
              () => {
                    setState(() {
                      state3 = OrderState.done;
                    })
                  });
          Timer(const Duration(milliseconds: 5000),
              () => {Navigator.of(context).push(createStepperRoute())});
          break;
      }
    }

    void sendMessage(Socket socket, String message) {
      print('[Client] Sending message: $message');
      socket.write(message);
    }

    void start() async {
      print("start gschissena");

      String serverIp = "10.7.43.4";
      // String serverIp = "10.7.43.5";
      // String serverIp = "192.168.0.22";
      int serverPort = 4567;

      final socket = await Socket.connect(serverIp, serverPort);
      print(
          '[Client] Connected to: ${socket.remoteAddress.address}:${socket.remotePort}');

      socket.listen(
        handleMessage,
        onError: (error) {
          print("[Client] Error occured: $error. Terminating.");
          socket.destroy();
        },
        onDone: () {
          print("[Client] Server disconnected. Terminating.");
          socket.destroy();
        },
      );

      sendMessage(socket, "[cmd] start");
    }

    start();

    return Scaffold(
        backgroundColor: Colors.white,
        body: SlideTransition(
            position: Tween<Offset>(
              begin: Offset.zero,
              end: const Offset(0, -1),
            ).animate(_endAnimationController),
            child: Stack(children: [
              Padding(
                padding: EdgeInsets.only(left: 25, right: 25),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(alignment: Alignment.bottomCenter, children: [
                        FadeTransition(
                          opacity: _animationFadeOut,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              'assets/received.gif',
                              width: MediaQuery.of(context).size.width / 1.2,
                              fit: BoxFit.scaleDown,
                            ),
                          )
                        ),
                        FadeTransition(
                          opacity: _animationFadeIn2,
                          child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                FadeTransition(
                                    opacity: _animationFadeOut2,
                                    child: Image.asset(
                                      'assets/forklift2.gif',
                                      width: MediaQuery.of(context).size.width,
                                    ))
                              ]),
                        ),
                        FadeTransition(
                          opacity: _animationFadeIn3,
                          child: Image.asset(
                            'assets/delivery.gif',
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.scaleDown,
                          ),
                          //     ),
                          //   ],
                          // ),
                        )
                      ]),
                      Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 40.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                OrderStep(state: state1),
                                OrderStep(state: state2),
                                OrderStep(state: state3),
                              ],
                            ),
                          ),
                          Stack(
                            children: [
                              FadeTransition(
                                  opacity: _animationFadeOut,
                                  child: Column(
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        margin: const EdgeInsets.only(
                                            bottom: 5.0, top: 30.0),
                                        child: const Text('Great!',
                                            style: normalRed),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        child: const Text(
                                            'Your order has been received.',
                                            style: normalBlack),
                                      )
                                    ],
                                  )),
                              FadeTransition(
                                  opacity: _animationFadeIn2,
                                  child: FadeTransition(
                                    opacity: _animationFadeOut2,
                                    child: Column(
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          margin: const EdgeInsets.only(
                                              bottom: 5.0, top: 30.0),
                                          child: const Text('Just a minute!',
                                              style: normalRed),
                                        ),
                                        Container(
                                          alignment: Alignment.center,
                                          child: const Text(
                                              'Your Filli is on the way.',
                                              style: normalBlack),
                                        )
                                      ],
                                    ),
                                  )),
                              FadeTransition(
                                opacity: _animationFadeIn3,
                                child: Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.only(
                                          bottom: 5.0, top: 30.0),
                                      child: const Text('Filli XMAS!',
                                          style: normalRed),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      child: const Text(
                                          'Your Filli has been delivered.',
                                          style: normalBlack),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      )
                    ]),
              ),
            ])));
  }

  Route createStepperRoute() {
    _endAnimationController.forward();
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const Manual(),
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

class OrderStep extends StatelessWidget {
  final OrderState state;

  const OrderStep({Key? key, this.state = OrderState.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case OrderState.todo:
        return Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(1000)),
            border: Border.all(color: Colors.grey, width: 3.5),
          ),
          padding: const EdgeInsets.all(2),
          child: const Icon(
            Icons.done,
            color: Colors.transparent,
            size: 18,
          ),
        );
      case OrderState.active:
        return const SizedBox(
          height: 22,
          width: 22,
          child: CircularProgressIndicator(
            color: filliRed,
          ),
        );
      case OrderState.done:
        return Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(1000)),
            border: Border.all(color: Colors.green, width: 3.5),
            color: Colors.green,
          ),
          padding: const EdgeInsets.all(2),
          child: const Icon(
            Icons.done,
            color: Colors.white,
          ),
        );
    }
  }
}

enum OrderState {
  todo,
  active,
  done,
}
