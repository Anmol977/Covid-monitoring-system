const express = require('express');
const app = express();
const cors = require("cors");
const mqtt = require('mqtt');
// const pool = require("./db");
const { Client,Pool } = require("pg");
const connectionString = 'postgres://postgres:shivam@localhost:5432/covmon';
const sqlClient = new Client({
    connectionString: connectionString
});
sqlClient.connect();


//middleware
app.use(express.json());   
app.use(cors());

//routes//

//create


//get





let client = mqtt.connect('mqtt://127.0.0.1:1883', { clientId: "mqttjs01", username: 'Anmol' });

client.on('connect', () => {
    console.log('Connected')
    client.subscribe("Temperature", (topic) => {
      console.log(`Subscribe to topic ${topic}`);
    })
})

client.on('message', (topic, payload) => {
    console.log('Received Message:', topic, payload.toString())
  })


  app.listen(5000,(req,res) => {
    console.log("Connected on port 5000!!")
  })



