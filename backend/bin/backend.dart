import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dotenv/dotenv.dart';
import 'package:http/http.dart' as http;

String fts_ip = "";
Socket? clientSock;

Future<void> main() async {
  final DotEnv env = DotEnv(includePlatformEnvironment: true)..load();
  if (!env.isDefined("fts_ip")) {
    print("IP address of FTS is not defined in environment. Exiting.");
    return;
  }
  fts_ip = env["fts_ip"]!;

  final server = await ServerSocket.bind("192.168.0.22", 4567);

  server.listen((client) => handleConnection(client));
}

void handleConnection(Socket client) {
  print("[Server] Connection from ${client.remoteAddress.address}:${client.remotePort}");
  clientSock = client;

  client.listen(
    handleMessage,
    
    onError: (error) {
      print("[Server] Error occured: $error");
      client.close();
    },
    
    onDone: () {
      print("[Server] Client left");
      client.close();
    },
  );
}

void handleMessage(Uint8List data) {
  final message = String.fromCharCodes(data);
  print("[Server] Received message $message");
  switch (message) {
    case "[cmd] start":
      print("[Server] Sending start command to FTS...");
      orderProcess();
      break;
    default:
      print("[Server] Unknown message received: $message");
      break;
  }
}

Future<void> orderProcess() async {
  // Uri startUrl = Uri.http(fts_ip, "filli/start");
  // clientSock!.write("[status] confirmed");
  // await http.post(startUrl);
  // clientSock!.write("[status] arrived");
  
  while (true) {
    String input = stdin.readLineSync()!;
    clientSock!.write(input);
  }
}