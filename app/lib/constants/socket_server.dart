import 'package:socket_io/socket_io.dart';

class SocketIO {
  static void initServer() {
    // Dart server
    var io = Server();
    var nsp = io.of('/test');
    nsp.on('connection', (client) {
      print('connection /test');
      client.on('msg', (data) {
        print('data from /test => $data');
        client.emit('fromServer', "ok 2");
      });
    });
    io.on('connection', (client) {
      print('connection default namespace');
      client.on('msg', (data) {
        print('data from default => $data');
        client.emit('fromServer', "ok");
      });
    });
    io.listen(3000);
  }
}
