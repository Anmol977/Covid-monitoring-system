import 'package:socket_io/socket_io.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketIO {
  static void initServer() {
    var io = Server();
    var nsp = io.of('/some');
    nsp.on('connection', (client) {
      print('connection /some');
      client.on('msg', (data) {
        print('data from /some => $data');
        client.emit('fromServer', "ok 2");
      });
    });
    io.on('connection', (client) {
      print('connection default namespace');
      print('client id: ${client.id}');
      client.on('msg', (data) {
        print('data from default => $data');
        client.emit('fromServer', "ok");
      });
    });
    io.listen(3000);

    IO.Socket socket = IO.io(
      'http://localhost:3000/some',
      IO.OptionBuilder().setTransports(['websocket']).build(),
    );
    socket.onConnect((_) {
      print('connect');
      print('id: ${socket.id}');
      socket.emit('msg', 'test');
    });
    socket.on('event', (data) => print(data));
    socket.onDisconnect((_) => print('disconnect'));
    socket.on('fromServer', (_) => print(_));
  }
}
