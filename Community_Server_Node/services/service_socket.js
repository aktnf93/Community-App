const { Server } = require('socket.io');
const db = require('../services/service_database');

const initSocket = (server) => {
    
    console.log(`initSocket`);

    const io = new Server(server, { 
        cors: { origin: "*" },
        transports: ['polling', 'websocket'],
        pingTimeout: 30000, // 기본 20000ms
        pingInterval: 25000 // 기본 25000ms
    });

    io.on('connection', socket => {
        console.log('사용자 연결:', socket.id);

        socket.on('joinRoom', roomId => {

            console.log(`joinRoom ${roomId}`);

            socket.join(roomId);
        });

        socket.on('sendMessage', async ({ roomId, sender, message }) => {
            // DB 저장
            // await db.saveMessage(roomId, sender, message);

            console.log(`sendMessage ${roomId} ${sender} ${message}`);

            // 같은 방 사용자에게 브로드캐스트
            io.to(roomId).emit('receiveMessage', { sender, message, time: new Date() });
        });

        socket.on('disconnect', () => console.log('사용자 연결 끊김:', socket.id));
    });
};

module.exports = initSocket;