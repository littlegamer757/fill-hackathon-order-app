import 'dart:io';
import 'dart:typed_data';

import 'package:dotenv/dotenv.dart';

void main() async {
  final DotEnv env = DotEnv(includePlatformEnvironment: true)..load();
  if (!env.isDefined("server_ip")) {
    print("IP address of Socket Server is not defined in environment. Exiting.");
    return;
  }
  String serverIp = env["server_ip"]!;

  if (!env.isDefined("server_port")) {
    print("Port of Socket Server is not defined in environment. Exiting.");
    return;
  }
  int serverPort = int.parse(env["server_port"]!);
  
  final socket = await Socket.connect(serverIp, serverPort);
  print('[Client] Connected to: ${socket.remoteAddress.address}:${socket.remotePort}');

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
    print("[Client] Received a message that is not a status update ($message).");
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
