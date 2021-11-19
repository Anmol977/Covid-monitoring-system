const express = require('express');
const mqtt = require('mqtt');

let client = mqtt.connect('mqtt://127.0.0.1:1883', { clientId: "mqttjs01", username: 'Anmol' });

client.on('connect', () => {
    console.log('connected to the MQTT broker!');
})
