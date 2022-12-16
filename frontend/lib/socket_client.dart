import 'dart:io';
import 'dart:typed_data';

class SocketClient {
  SocketClient() {
    start();
  }
}

void start() async {
  // String serverIp = "10.7.43.5";
  String serverIp = "192.168.178.33";
  //192.168.178.33
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

void sendMessage(Socket socket, String message) {
  print('[Client] Sending message: $message');
  socket.write(message);
}

void handleMessage(Uint8List data) {
  final message = String.fromCharCodes(data);
  print('[Client] Received a message: $message');

  if (!message.startsWith("[status]")) {
    print(
        "[Client] Received a message that is not a status update ($message).");
    return;
  }

  String statusUpdate = message.substring("[status] ".length - 1);

  switch (statusUpdate) {
    case "confirmed":
      print("[Client] Statusupdate received: $message.");
      break;
    case "delivering":
      print("[Client] Statusupdate received: $message.");
      break;
    case "arrived":
      print("[Client] Statusupdate received: $message.");
      break;
  }
}
