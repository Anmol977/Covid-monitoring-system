import 'package:flutter/material.dart';
import 'package:socket_io/socket_io.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketIO {
  static const String serverIp = 'http://localhost:5000/';

  static void sendData(String id, String topic, String message) {
    /* var notio = Server(); */
    /* var nsp = notio.of('/9407351e-1e38-4f6d-90e5-f9d763c252c5'); */
    /* nsp.on('connection', (client) { */
    /*   print('connection /9407351e-1e38-4f6d-90e5-f9d763c252c5'); */
    /*   client.on('test', (data) { */
    /*     print('data from /9407351e-1e38-4f6d-90e5-f9d763c252c5 => $data'); */
    /*     client.emit('fromServer', "ok 2"); */
    /*   }); */
    /* }); */
    /* notio.on('connection', (client) { */
    /*   print('connection default namespace'); */
    /*   print('client id: ${client.id}'); */
    /*   client.on('msg', (data) { */
    /*     print('data from default => $data'); */
    /*     client.emit('fromServer', "ok"); */
    /*   }); */
    /* }); */
    /* notio.listen(3000); */

    /* socket.emit('/test', 'testData'); */
    /* socket.onConnect((_) { */
    /*   debugPrint('connect'); */
    /*   debugPrint('id: ${socket.id}'); */
    /*   socket.emit(topic, message); */
    /* }); */
    /* socket.on('event', (data) => debugPrint(data)); */
    /* socket.onDisconnect((_) => debugPrint('disconnect')); */
    /* socket.on('fromServer', (data) => debugPrint(data)); */
  }
}
