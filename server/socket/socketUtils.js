const logger = require('../logger')

function createSocketServer(server){
    const socketInstance = require("socket.io")(server);
    return socketInstance;
}

module.exports = { createSocketServer};