import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dotenv/dotenv.dart';
import 'package:http/http.dart' as http;

String ftsIp = "";
late Socket clientSock;
late bool mockProcess;

/// Acts as a middleman between the mobile app and the FTS.
///
/// Reads the environment file and starts a Websocket-Server for communication
/// with the client.
Future<void> main() async {
  final DotEnv env = DotEnv(includePlatformEnvironment: true)..load();

  if (env.isDefined("mock_process")) {
    mockProcess = env["mock_process"]!.toLowerCase() == "true";
  } else {
    mockProcess = false;
  }

  if (!env.isDefined("fts_ip") && !mockProcess) {
    print("IP address of FTS is not defined in .env. Exiting.");
    return;
  }
  ftsIp = env["fts_ip"] ?? "";

  if (!env.isDefined("server_ip")) {
    print("IP address for WebSocket Server is not defined in .env. Exiting.");
    return;
  }
  String serverIp = env["server_ip"]!;
  int serverPort = int.parse(env["server_port"] ?? '4567');
  
  print("[Server] Listening for connections on $serverIp:$serverPort");
  final server = await ServerSocket.bind(serverIp, serverPort);
  server.listen((client) => handleConnection(client));
}

void handleConnection(Socket client) {
  print(
      "[Server] Connection from ${client.remoteAddress.address}:${client.remotePort}");
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
      orderProcess(mockProcess);
      break;
    default:
      print("[Server] Unknown message received: $message");
      break;
  }
}

/// Starts the order process and sends status updates to the client.
///
/// Tells the FTS to start driving via a HTTP POST request. Before that, the
/// client is sent confirmation that the server received the order command. Once
///  the FTS finishes driving, the server receives a response to the initial
/// request and it tells the client that the order is completed.
///
/// Mock mode
/// - useful for testing just the client
/// - activated by setting the `mock` parameter to `true`
/// - status updates are sent manually via stdin
///   - step 1 is called `confirmed`
///   - step 2 is called `arrived`
///   - `exit` ends the process and lets the next client connect
Future<void> orderProcess(bool mock) async {
  if (!mock) {
    print("[Server] Sending start command to FTS...");
    Uri startUrl = Uri.http(ftsIp, "filli/start");
    clientSock.write("[status] confirmed");
    await http.post(startUrl);
    clientSock.write("[status] arrived");
  } else {
    String input;
    do {
      print(
          "Enter order status update to send to client (confirmed/arrived/exit): ");
      input = stdin.readLineSync()!;
      clientSock.write("[status] $input");
    } while (input != "exit");
  }
}
