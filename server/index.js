require('dotenv').config()
const express = require('express');
const db = require('./db');
const logger = require('./logger');
const bodyParser = require('body-parser');
const mqtt = require('./mqtt/connectMqtt');
const userRoutes = require('./routes/patientRoutes');
const doctorRoutes = require('./routes/doctorRoutes');
const {initSocket, createSocketServer } = require('./socket/socketUtils');
const { createServer } = require("http");
const { getDoctorsList } = require('./stores/doctorStore');

const app = express();
const httpServer = createServer();

app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

(async () => {
  try {
    await db.migrate.latest().then(() => {
      logger.info('database migrations complete...');
    });
  } catch (e) {
    logger.error(e);
  }
})();

app.listen(5000, async (req, res) => {
  logger.info("server running on port : 5000");

  const doctorIdList = await getDoctorsList();
  const socketInstance =  createSocketServer(httpServer);
  for await ( let idObject of doctorIdList ){
    initSocket(socketInstance, idObject.id);
  }
});



app.use(userRoutes, doctorRoutes);
