import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import 'api.dart';

class SocketIO {
  static String serverIp = 'http://${Api.ip}:5000/';
  static late io.Socket socket;

  static void connectToServer() {
    socket = io.io(
        serverIp,
        io.OptionBuilder().setTransports(
          ['websocket'],
        ).build());

    socket.onConnect((_) {
      debugPrint('connected to socket server');
    });
  }

  static void sendData(String id, String topic, String message) {}
}
