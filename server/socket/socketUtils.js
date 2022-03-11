const { Server } = require("socket.io");
const logger = require('../logger')

function createSocketServer(httpServer){
    const ioSocket = new Server(httpServer);
    return ioSocket;
}

function initSocket( ioSocketServer, doctorId) {
    try{
        var nsp = ioSocketServer.of(`/${doctorId}`);
        logger.info(`socket created with id : ${nsp.name}`);
        // nsp.on('connection', (client) => {
        //     client.on('msg', (data) => {
        //         console.log(`data from /some => ${data}`);
        //         client.emit('fromServer', "ok 2");
        //     });
        // });
        return nsp;
    } catch(e)
    {
        logger.error(e);
        return null;
    }


}

module.exports = {initSocket, createSocketServer};