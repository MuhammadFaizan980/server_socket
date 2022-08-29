library system_socket;

import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part './app_constants.dart';

class SystemSocket {
  static late ServerSocket _serverSocket;

  static Future<void> createSocket() async {
    try {
      _serverSocket = await ServerSocket.bind('192.168.0.11', 3000);
      _serverSocket.listen(_handleClient);
    } catch (e) {
      print('===ERROR STARTING SYSTEM SOCKET===');
      print(e);
    }
  }

  static void _handleClient(Socket clientSocket) {
    clientSocket.listen(
      (onData) async {
        String? token = await const FlutterSecureStorage().read(key: userToken);
        if (token != null) {
          print(String.fromCharCodes(onData).trim());
          clientSocket.write('VM Logged In');
        } else {
          clientSocket.write('Vending machine not logged in');
        }
      },
      onError: (e) {},
      onDone: () {},
    );
  }
}
