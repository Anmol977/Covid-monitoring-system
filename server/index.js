const express = require('express');
const db = require('./db')
const mqtt = require('./mqtt/connectMqtt')
const logger = require('./logger')
const userRoutes = require('./routes/user')

const app = express();
app.use(express.json());

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
  logger.info("Connected on port 5000")
});

app.use(userRoutes);