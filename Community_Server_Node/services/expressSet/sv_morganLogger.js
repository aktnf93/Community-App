const logger = require('../../utils/logger');
const morgan = require('morgan'); // Morgan으로 HTTP 요청 로그를 Winston에 전달


// Morgan으로 HTTP 요청 로그를 Winston에 전달
morgan.token('ip', (req) => req.ip); // IP 주소
morgan.token('id', (req) => req.requestId || 'no-id'); // uuid
morgan.token('body', (req) => {
  try {
    return JSON.stringify(req.body);
  } catch {
    return 'unreadable';
  }
}); // 요청 본문 일부

const format = '[ip=:ip][uuid=:id] ":method :url HTTP/:http-version" status=:status length=:res[content-length] (:response-time ms) [referrer=:referrer][user-agent=:user-agent][body=:body]';

// app.use(morgan('combined', {
const morganLogger = morgan(format, {
  stream: {
    write: (message) => logger.http(message.trim())
  }
});

module.exports = morganLogger;