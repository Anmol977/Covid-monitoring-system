import 'dart:async';

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import 'api.dart';

class SocketIO {
  static String serverIp = 'http://${Api.ip}:5000/';
  static late io.Socket socket;
  static StreamSocket streamSocket = StreamSocket();

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

  static void sendData(String topic, String message) {
    socket.emit(topic, message);
  }

  static void listenTo(String event) {
    socket.on(event, (data) => streamSocket.addResponse);
  }
}

class StreamSocket {
  final _socketResponse = StreamController<String>();

  void Function(String) get addResponse => _socketResponse.sink.add;

  Stream<String> get getResponse => _socketResponse.stream;

  void dispose() {
    _socketResponse.close();
  }
}
