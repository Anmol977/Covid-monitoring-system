const { Server } = require("socket.io");
const logger = require('../logger')

function createSocketServer(httpServer){
    const ioSocket = new Server(httpServer);
	ioSocket.of('/9407351e-1e38-4f6d-90e5-f9d763c252c5').emit("fromServer", "testing");
	ioSocket.on('test', (test)=>{console.log(test);})
	ioSocket.listen(3000);
    return ioSocket;
}

function initSocket( ioSocketServer, doctorId) {
    try{
        var nsp = ioSocketServer.of(`/${doctorId}`);
        logger.info(`socket created with id : ${nsp.name}`);
        nsp.on('connection', (client) => {
            client.on('test', (data) => {
                console.log(`data from /some => ${data}`);
                client.emit('fromServer', "ok 2");
            });
        });
        return nsp;
    } catch(e)
    {
        logger.error(e);
        return null;
    }


}

module.exports = {initSocket, createSocketServer};
