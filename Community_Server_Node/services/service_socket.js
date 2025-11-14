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

        // 예: 10초 후 강제 연결 해제
        /*
        setTimeout(() => {
            console.log(`사용자 연결 해제: ${socket.id}`);
            socket.disconnect(true); // true는 강제 해제
        }, 10000);
        */

        socket.on('joinRoom', async (join) => {
            console.log(`joinRoom > ${JSON.stringify(join)}`);

            try {
                const req = { ip: socket.id };

                // signup
                let qry = "INSERT IGNORE INTO tb_chat_members (chat_room_id, employee_id) VALUES (?, ?);";
                const result = await db.query(req, qry, [ join.roomId, join.userId ]);
                console.log(`joinRoom > signup > ${JSON.stringify(result)}`);

                // get members
                qry = "SELECT * FROM tb_chat_members m WHERE m.chat_room_id = ?;";
                const members = await db.query(req, qry, [ join.roomId ]);
                console.log(`joinRoom > signup > get members > ${members.length} rows`);

                // get messages
                qry = "SELECT * FROM tb_chat_messages m WHERE m.chat_room_id = ?;";
                const messages = await db.query(req, qry, [ join.roomId, join.userId ]);
                console.log(`joinRoom > signup > get members > get messages > ${messages.length} rows`);

                socket.join(join.roomId);
                console.log(`joinRoom > signup > get members > get messages > join commit > ${join.roomId}`);

                io.to(join.roomId).emit('welcome', { Members: members, Messages: messages });
                console.log(`joinRoom > signup > get members > get messages > join commit > welcome emit`);
            }
            catch (err) {
                console.log(err);
                socket.disconnect(true);
            }
        });

        socket.on('sendMessage', async (obj) => {
            console.log('sendMessage');
            console.log(obj);

            // DB 저장
            // await db.saveMessage(roomId, sender, message);

            // 같은 방 사용자에게 브로드캐스트
            io.to(3).emit('receiveMessage', obj);
        });

        socket.on('disconnect', () => {
            console.log('사용자 연결 끊김:', socket.id);
        });
    });
};

module.exports = initSocket;