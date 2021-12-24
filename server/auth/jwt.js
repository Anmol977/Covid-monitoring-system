const jwt = require('jsonwebtoken');
const logger = require('../logger')

function generateUserToken(id, email) {
     try {
          let token = jwt.sign(
               {
                    id, email
               }
               , process.env.ACCESS_TOKEN_SECRET,
               {
                    expiresIn: process.env.ACCESS_TOKEN_LIFE
               });
          return token;
     } catch (e) {
          logger.error(e);
     }
}

module.exports = generateUserToken;