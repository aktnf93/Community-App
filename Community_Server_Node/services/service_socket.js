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
        const req = { ip: socket.id };

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
                // 채팅방 멤버 추가
                const result = await db.query(req, 'INSERT IGNORE INTO tb_chat_members (chat_room_id, employee_id) VALUES (?, ?);', [ join.roomId, join.userId ]);

                // 채팅방 멤버 조회
                const members = await db.query(req, 'SELECT * FROM tb_chat_members m WHERE m.chat_room_id = ?;', [ join.roomId ]);

                // 채팅방 메시지 조회
                const messages = await db.query(req, 'SELECT * FROM v_chat_messages m WHERE m.chat_room_id = ?;', [ join.roomId ]);

                socket.join(join.roomId); // 채팅방 연결.

                io.to(join.roomId).emit('welcome', { 
                    Id: 0,
                    Name: '',
                    Description: '',
                    Message_At: null,
                    Created_At: new Date(),
                    Updated_At: new Date(),
                    Deleted_At: null,
                    SendMessage: '',
                    Members: members, 
                    Messages: messages 
                });
            }
            catch (err) {
                console.log(err);
                socket.disconnect(true);
            }
        });

        socket.on('sendMessage', async (msg) => {
            console.log(`sendMessage > ${JSON.stringify(msg)}`);

            // DB 저장
            const result = await db.query(req, 'INSERT INTO tb_chat_messages (chat_room_id, employee_id, message) VALUES (?, ?, ?);', [ msg.Chat_Room_Id, msg.Employee_Id, msg.Message ]);
            const db_msg = await db.query(req, 'SELECT * FROM v_chat_messages m WHERE m.id = ?;', [result.insertId]);

            if (result) {
                // 같은 방 사용자에게 브로드캐스트
                io.to(msg.Chat_Room_Id).emit('receiveMessage', db_msg[0]);
            }
        });

        socket.on('disconnect', () => {
            console.log('사용자 연결 끊김:', socket.id);
        });
    });
};

module.exports = initSocket;