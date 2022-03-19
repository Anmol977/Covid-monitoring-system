import 'dart:convert';

import 'package:covmon/models/patient.dart';
import 'package:covmon/provider/patient.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  static void addEventListenerTo(BuildContext context, String topic) {
    socket.on(topic, (data) {
      Map<String, dynamic> patientData = json.decode(data);
      Patient patient = Patient.fromMap(patientData);
      /* print(patient.id); */
      /* print(Provider.of<Patients>(context, listen: false) */
      /*     .patientAdded(patient.id)); */
      /* Provider.of<Patients>(context, listen: false).addPatientVitals(patient); */
      if (Provider.of<Patients>(context, listen: false)
          .patientAdded(patient.id)) {
        Provider.of<Patients>(context, listen: false).addPatientVitals(patient);
      }
    });
  }

  static void sendData(String topic, String message) {
    socket.emit(topic, message);
  }
}
