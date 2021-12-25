require('dotenv').config()
const express = require('express');
const db = require('./db');
const mqtt = require('./mqtt/connectMqtt');
const logger = require('./logger');
const userRoutes = require('./routes/patientRoutes');
const doctorRoutes = require('./routes/doctorRoutes');
const bodyParser = require('body-parser');

const app = express();

app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

(async () => {
  try {
    await db.migrate.latest().then(() => {
      logger.info('database migrations complete...');
    });
  } catch (e) {
    console.log(e);
  }
})();

app.listen(5000, (req, res) => {
  logger.info("server running on port : 5000")
});

app.use(userRoutes, doctorRoutes);
