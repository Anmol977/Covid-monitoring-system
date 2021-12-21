const express = require('express');
const db = require('./db')
const mqtt = require('./mqtt/connectMqtt')
const logger = require('./logger')

const app = express();

app.listen(5000, (req, res) => {
  logger.info("Connected on port 5000!!")
});

(async () => {
  try {
    logger.info('Checking db migrations...');
    await db.migrate.latest().then(() => {
      logger.info('migrations complete');
    });
  } catch (e) {
    console.log(e);
  }
})();
