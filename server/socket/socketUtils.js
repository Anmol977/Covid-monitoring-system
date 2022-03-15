const { Server } = require("socket.io");
const logger = require('../logger')

function createSocketServer(server){
    const socketInstance = require("socket.io")(server);
    return socketInstance;
}

function joinRoom( socket, doctorId) {
    try{
        socket.join(doctorId);
    } catch(e)
    {
        logger.error(e);
        return null;
    }
}


module.exports = {joinRoom, createSocketServer};