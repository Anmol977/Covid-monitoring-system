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
      socket.on('9407351e-1e38-4f6d-90e5-f9d763c252c5', (data) {
        debugPrint(data.toString());
      });
    });
  }

  static void addEventListenerTo(String topic) {
    socket.on(topic, (data) {
      debugPrint(data.toString());
    });
  }

  static void sendData(String topic, String message) {
    socket.emit(topic, message);
  }
}
