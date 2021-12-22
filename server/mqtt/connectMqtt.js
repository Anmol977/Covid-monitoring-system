const mqtt = require('mqtt');
const logger = require('../logger')

let mqttclient = mqtt.connect('mqtt://127.0.0.1:1883', { clientId: "mqttjs01", username: 'Anmol' });

mqttclient.on('connect', () => {
     logger.info('Connected to mosquitto MQTT broker on port : 1883')
     // mqttclient.subscribe("Temperature", (topic) => {
     //      logger.info(`Subscribed to topic ${topic}`);
     // })
})

// mqttclient.on('message', (topic, payload) => {
//      logger.info('Received Message:', topic, payload.toString())
// })

module.exports = mqttclient;