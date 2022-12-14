import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dotenv/dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

String fts_ip = "";
Socket? clientSock;

Future<void> main() async {
  final DotEnv env = DotEnv(includePlatformEnvironment: true)..load();
  if (!env.isDefined("fts_ip")) {
    print("IP address of FTS is not defined in environment. Exiting.");
    return;
  }
  fts_ip = env["fts_ip"]!;

  final server = await ServerSocket.bind("localhost", 4567);

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
      //orderProcess();
      break;
    default:
      print("[Server] Unknown message received: $message");
      break;
  }
}

Future<void> orderProcess() async {
  Uri startUrl = Uri.http(fts_ip, "filli/start");
  await http.post(startUrl);
  
  Uri statusUrl = Uri.http(fts_ip, "filli/status");
  String prevState = "";
  Timer.periodic(Duration(milliseconds: 500), (timer) async { 
    Response status = await http.get(statusUrl);
    String curState = status.body;
    if (prevState != curState) {
      prevState = curState;
      clientSock!.write("[status] $curState");
    }
  });
}