import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import 'api.dart';

class SocketIO {
  static String serverIp = 'http://${Api.ip}:5000/';
  static late io.Socket socket;
  static bool isConnected = false;

  static void connectToServer(String topic, String doctorId) {
    socket = io.io(
        serverIp,
        io.OptionBuilder().setTransports(
          ['websocket'],
        ).build());

    socket.onConnect((_) {
      isConnected = true;
      debugPrint('connected to socket server');
      sendData(topic, doctorId);
    });

  }

  static void sendData(String topic, String message) {
    if (!isConnected) {
      return;
    }
    socket.emit(topic, message);
  }
}
