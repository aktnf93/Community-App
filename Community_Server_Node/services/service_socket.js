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
                // signup
                let qry = "INSERT IGNORE INTO tb_chat_members (chat_room_id, employee_id) VALUES (?, ?);";
                const result = await db.query(req, qry, [ join.roomId, join.userId ]);
                console.log(`joinRoom: 채팅방 멤버를 추가합니다. ${JSON.stringify(result)}`);

                // get members
                qry = "SELECT * FROM tb_chat_members m WHERE m.chat_room_id = ?;";
                const members = await db.query(req, qry, [ join.roomId ]);
                console.log(`joinRoom: 채팅방 멤버를 불러옵니다. ${members}`);

                // get messages
                qry = `
SELECT 
	m.id AS 'Id',
	m.chat_room_id AS 'Chat_Room_Id', 
	m.employee_id AS 'Employee_Id',
	e.name AS 'Employee_Name',
	m.message AS 'Message',
	DATE_FORMAT(m.created_at, '%Y-%m-%dT%H:%i:%s') AS 'Created_At',
	DATE_FORMAT(m.deleted_at, '%Y-%m-%dT%H:%i:%s') AS 'Deleted_At'
FROM tb_chat_messages m 
	INNER JOIN tb_employees e ON m.employee_id = e.id
WHERE m.chat_room_id = ?;
                `;
                const messages = await db.query(req, qry, [ join.roomId ]);
                console.log(`joinRoom: 채팅방 메시지를 불러옵니다. ${messages}`);

                socket.join(join.roomId);
                console.log(`joinRoom: 채팅방에 연결합니다. ${join.roomId}`);

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
                console.log(`joinRoom: 채팅방 멤버와 메시지를 응답합니다.`);
            }
            catch (err) {
                console.log(err);
                socket.disconnect(true);
            }
        });

        socket.on('sendMessage', async (msg) => {
            console.log('sendMessage');
            console.log(msg);

            // DB 저장
            const qry = "INSERT INTO tb_chat_messages (chat_room_id, employee_id, message) VALUES (?, ?, ?);";
            const result = await db.query(req, qry, [ msg.Chat_Room_Id, msg.Employee_Id, msg.Message ]);
            console.log(result);
            const db_msg = await db.query(req, 
`
SELECT 
	m.id AS 'Id',
	m.chat_room_id AS 'Chat_Room_Id',
	m.employee_id AS 'Employee_Id',
	m.message AS 'Message',
	DATE_FORMAT(m.created_at, '%Y-%m-%dT%H:%i:%s') AS 'Created_At',
	DATE_FORMAT(m.deleted_at, '%Y-%m-%dT%H:%i:%s') AS 'Deleted_At', 
	e.name AS 'Employee_Name' 
FROM tb_chat_messages m 
INNER JOIN tb_employees e ON m.employee_id = e.id 
WHERE m.id = ?;
`, 
                [ result.insertId ]);

            // msg.Created_At = db_msg.created_at;
            // msg.Employee_Name = db_msg.Employee_Name;

            if (result) {
                // 같은 방 사용자에게 브로드캐스트
                console.log(db_msg[0]);
                io.to(msg.Chat_Room_Id).emit('receiveMessage', db_msg[0]);
            }
        });

        socket.on('disconnect', () => {
            console.log('사용자 연결 끊김:', socket.id);
        });
    });
};

module.exports = initSocket;