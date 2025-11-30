const logger = require('../../utils/logger');

const cors = require('cors');
/*
app.use(cors({
  origin: ['http://localhost:3000'], // 정확한 도메인
  credentials: true
}));
*/

const allowedOrigins = [
  'http://localhost:3000'
];

const corsSet = cors({
  origin: (origin, callback) => {
    // Postman, Thunder Client 등 Origin 없는 요청 허용 (선택)
    if (!origin) return callback(null, true);

    // 화이트리스트 체크
    if (allowedOrigins.includes(origin)) {
      return callback(null, true);
    }

    return callback(new Error('Not allowed by CORS'));
  },

  credentials: true,  // 쿠키/인증 허용

  methods: ['GET', 'POST', 'PUT', 'DELETE'],

  allowedHeaders: ['Content-Type', 'Authorization'],
  exposedHeaders: ['Content-Length', 'Authorization'],

  maxAge: 600, // preflight 캐싱 10분
});

module.exports = corsSet;