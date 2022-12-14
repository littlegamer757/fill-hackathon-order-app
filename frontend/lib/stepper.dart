import 'dart:io';
import 'dart:typed_data';

import 'package:fill_hackathon/globals.dart';
import 'package:flutter/material.dart';

OrderState state1 = OrderState.todo;
OrderState state2 = OrderState.todo;
OrderState state3 = OrderState.todo;

class OrderStepper extends StatefulWidget {
  const OrderStepper({Key? key}) : super(key: key);

  @override
  State<OrderStepper> createState() => _OrderStepperState();
}

class _OrderStepperState extends State<OrderStepper> {
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
          setState(() {
            state1 = OrderState.done;
            state2 = OrderState.active;
          });
          break;
        case "delivering":
          print("[Client] Statusupdate received: $message.");
          state2 = OrderState.done;
          state3 = OrderState.active;
          break;
        case "arrived":
          print("[Client] Statusupdate received: $message.");
          setState(() {
            state2 = OrderState.done;
            state3 = OrderState.done;
          });
          break;
      }
    }

    void sendMessage(Socket socket, String message) {
      print('[Client] Sending message: $message');
      socket.write(message);
    }

    void start() async {
      print("start gschissena");
      // String serverIp = "10.7.43.5";
      String serverIp = "192.168.0.22";
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          OrderStep(state: state1),
          OrderStep(state: state2),
          OrderStep(state: state3),
        ],
      ),
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
            color: Colors.white,
          ),
        );
      case OrderState.active:
        return const SizedBox(
          height: 30,
          width: 30,
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
