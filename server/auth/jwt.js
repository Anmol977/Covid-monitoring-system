const jwt = require('jsonwebtoken');
const logger = require('../logger')

function generateUserToken(userDetails) {
     try {
          let token = jwt.sign(
               userDetails
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