import 'dart:io';

import 'package:covmon/provider/patient.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:provider/provider.dart';

import 'api.dart';

enum Info {
  temperature,
  spo2level,
  pulserate,
}

class MQTTBroker {
  static String host = Api.ip;
  static const String clientIdentifier = 'app';

  static final MqttServerClient client =
      MqttServerClient(host, clientIdentifier);
  static int pongCount = 0;

  static void onSubscribed(String topic) {
    debugPrint('EXAMPLE::Subscription confirmed for topic $topic');
  }

  static void onDisconnected() {
    debugPrint(
        'EXAMPLE::OnDisconnected client callback - Client disconnection');
    if (client.connectionStatus!.disconnectionOrigin ==
        MqttDisconnectionOrigin.solicited) {
      debugPrint(
          'EXAMPLE::OnDisconnected callback is solicited, this is correct');
    } else {
      debugPrint(
          'EXAMPLE::OnDisconnected callback is unsolicited or none, this is incorrect - exiting');
    }
    if (pongCount == 3) {
      debugPrint('EXAMPLE:: Pong count is correct');
    } else {
      debugPrint(
          'EXAMPLE:: Pong count is incorrect, expected 3. actual $pongCount');
    }
  }

  /// The successful connect callback
  static void onConnected() {
    debugPrint(
        'EXAMPLE::OnConnected client callback - Client connection was successful');
  }

  /// Pong callback
  static void pong() {
    debugPrint('EXAMPLE::Ping response client callback invoked');
    pongCount++;
  }

  static Future<void> configureMQTT({
    required BuildContext context,
    required List<String> topics,
  }) async {
    client.logging(on: false);

    client.setProtocolV311();

    client.keepAlivePeriod = 20;

    client.onDisconnected = onDisconnected;

    client.onConnected = onConnected;

    client.onSubscribed = onSubscribed;

    client.pongCallback = pong;

    final connMess = MqttConnectMessage()
        .withClientIdentifier('alouette')
        .withWillTopic('willtopic')
        .withWillMessage('My Will message')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    debugPrint('EXAMPLE::Mosquitto client connecting....');
    client.connectionMessage = connMess;

    try {
      await client.connect();
    } on NoConnectionException catch (e) {
      debugPrint('EXAMPLE::client exception - $e');
      client.disconnect();
    } on SocketException catch (e) {
      debugPrint('EXAMPLE::socket exception - $e');
      client.disconnect();
    }

    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      debugPrint('EXAMPLE::Mosquitto client connected');
    } else {
      /// Use status here rather than state if you also want the broker return code.
      debugPrint(
          'EXAMPLE::ERROR Mosquitto client connection failed - disconnecting, status is ${client.connectionStatus}');
      client.disconnect();
    }

    for (String topic in topics) {
      debugPrint('EXAMPLE::Subscribing to the test/lol topic');
      client.subscribe(topic, MqttQos.atMostOnce);
    }

    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;
      final pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      debugPrint(
          'EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
      debugPrint('');
      Provider.of<Patients>(context, listen: false).update(c[0].topic, pt);
    });
    client.published!.listen((MqttPublishMessage message) {
      debugPrint(
          'EXAMPLE::Published notification:: topic is ${message.variableHeader!.topicName}, with Qos ${message.header!.qos}');
    });

    /* const pubTopic = 'Dart/Mqtt_client/testtopic'; */
    /* final builder = MqttClientPayloadBuilder(); */
    /* builder.addString('Hello from mqtt_client'); */

    /* debugPrint('EXAMPLE::Subscribing to the Dart/Mqtt_client/testtopic topic'); */
    /* client.subscribe(pubTopic, MqttQos.exactlyOnce); */

    /* debugPrint('EXAMPLE::Publishing our topic'); */
    /* client.publishMessage(pubTopic, MqttQos.exactlyOnce, builder.payload!); */

    /* /// Ok, we will now sleep a while, in this gap you will see ping request/response */
    /* /// messages being exchanged by the keep alive mechanism. */
    /* debugPrint('EXAMPLE::Sleeping....'); */
    /* await MqttUtilities.asyncSleep(60); */

    /* debugPrint('EXAMPLE::Unsubscribing'); */
    /* /1* client.unsubscribe(topic); *1/ */
    /* await MqttUtilities.asyncSleep(2); */
    /* debugPrint('EXAMPLE::Disconnecting'); */
    /* client.disconnect(); */
    /* debugPrint('EXAMPLE::Exiting normally'); */
  }
}
