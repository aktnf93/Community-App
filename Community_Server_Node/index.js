const http = require('http');
const app = require('./services/service_express');
const initSocket = require('./services/service_socket');
const logger = require('./logger');

const server = http.createServer(app);

// WebSocket 초기화
initSocket(server); // TCP Socket 채팅방

const PORT = 3000;
server.listen(PORT, () => {
    logger.info(`Server running on http://localhost:${PORT}`);
});