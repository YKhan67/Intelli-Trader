import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() async {
  final url = 'ws://127.0.0.1:8007/live/EURUSD';
  print('Connecting to $url...');
  
  try {
    final channel = WebSocketChannel.connect(Uri.parse(url));
    print('Connected. Waiting for signal...');
    
    channel.stream.listen((data) {
      print('Received: $data');
    }, onDone: () {
      print('Connection closed.');
    }, onError: (e) {
      print('Error: $e');
    });
    
    await Future.delayed(Duration(seconds: 10));
    await channel.sink.close();
  } catch (e) {
    print('Failed to connect: $e');
  }
}
