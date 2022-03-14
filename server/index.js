require('dotenv').config()
const express = require('express');
const db = require('./db');
const logger = require('./logger');
const bodyParser = require('body-parser');
const mqtt = require('./mqtt/connectMqtt');
const userRoutes = require('./routes/patientRoutes');
const doctorRoutes = require('./routes/doctorRoutes');
const { initSocket, createSocketServer } = require('./socket/socketUtils');
const { createServer } = require("http");
// const { Server } = require("socket.io");
const { getDoctorsList } = require('./stores/doctorStore');
const io = require("socket.io-client");
const { closeSync } = require('fs');

const app = express();
const httpServer = createServer();

app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

//check for database migrations
(async () => {
  try {
    await db.migrate.latest().then(() => {
      logger.info('database migrations complete...');
    });
  } catch (e) {
    logger.error(e);
  }
})();

const server = app.listen(5000, async (req, res) => {
  logger.info("server running on port : 5000");

  // const doctorIdList = await getDoctorsList();
  // logger.info('creating sockets for users...');
  // let socketRooms = {};
  // for await (let idObject of doctorIdList) {
  //   socketRooms[idObject.id] = initSocket(socketInstance, idObject.id);
  // }
});

const socketInstance = require("socket.io")(server);

  socketInstance.on("connection",(socket)=>{
    // console.log(socket);
    console.log('socket connected');
  })

// const socket = io('http://localhost:5000');
// socket.on('connect',()=>{
//   console.log('connected');
// })

app.use(userRoutes, doctorRoutes);
