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
const { getDoctorsList } = require('./stores/doctorStore');

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
  // const socketInstance = createSocketServer(httpServer);
  // socketInstance.of('/9407351e-1e38-4f6d-90e5-f9d763c252c5').emit("fromServer", "testing");
  // socketInstance.on('/test', (test)=>{console.log(test);})
  // socketInstance.listen(3000);
  // logger.info('creating sockets for users...');
  // let socketRooms = {};
  // for await (let idObject of doctorIdList) {
  //   socketRooms[idObject.id] = initSocket(socketInstance, idObject.id);
  // }
});

const io = require('socket.io')(server);

io.on('connection', (socket) => {
	console.log('Connected Succesfully to', socket.id);
});

app.use(userRoutes, doctorRoutes);
