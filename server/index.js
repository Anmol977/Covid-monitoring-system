require('dotenv').config()
const express = require('express');
const db = require('./db');
const fs = require('fs');
const logger = require('./logger');
const bodyParser = require('body-parser');
const mqtt = require('./mqtt/connectMqtt');
const userRoutes = require('./routes/patientRoutes');
const doctorRoutes = require('./routes/doctorRoutes');
const { createSocketServer } = require('./socket/socketUtils');



const app = express();

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
});

socketIo = createSocketServer(server);
socketIo.on("connection", (socket) => {
  logger.info(`socket connected with id ${socket.id}`);
  socket.on('patientDoctorId', (data) => {
    logger.info(`created room with id ${data}`);
    socket.join(data);
  });
  socket.on('sendVitalsToDoctor', (data) => {
    socket.to(data.DoctorId).emit(data);
    fs.writeFile('/scriptData', data, function (err) {
      if (err) {
        logger.error(err);
      }
    })
  })
});

app.use(userRoutes, doctorRoutes);
