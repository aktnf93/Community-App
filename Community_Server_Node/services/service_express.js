const express = require('express');
const app = express();


// ****************************************
app.use(express.json());


// ****************************************
// Morgan으로 HTTP 요청 로그를 Winston에 전달
const morgan = require('morgan');
const logger = require('../logger'); // Winston 설정 파일
app.use(morgan('combined', {
  stream: {
    write: (message) => logger.info(message.trim())
  }
}));


// ****************************************
// IP 차단
const cors = require('cors');
app.use(cors({
  origin: ['http://localhost:3000'], // 정확한 도메인
  credentials: true
}));

app.use((req, res, next) => {
  const allowedIps = ['127.0.0.1', '::1']; // 로컬 IP만 허용
  const clientIp = req.ip;

  if (!allowedIps.includes(clientIp)) {
    logger.error(`${clientIp} 차단`)

    return res.status(404).end();
  }

  next();
});

// ****************************************
// 라우터 모듈 연결
app.use('/post',                    require('../routes/url_post'));
app.use('/chat',                    require('../routes/url_chat'));
app.use('/project',                 require('../routes/url_project'));
app.use('/customer',                require('../routes/url_customer'));
app.use('/product',                 require('../routes/url_product'));
app.use('/employee',                require('../routes/url_employee'));
app.use('/organization/location',   require('../routes/organization/url_location'));
app.use('/organization/company',    require('../routes/organization/url_company'));
app.use('/organization/department', require('../routes/organization/url_department'));
app.use('/organization/team',       require('../routes/organization/url_team'));
app.use('/organization/rank',       require('../routes/organization/url_rank'));
app.use('/organization/position',   require('../routes/organization/url_position'));
app.use('/organization/role',       require('../routes/organization/url_role'));
app.use('/system',                  require('../routes/url_system'));


// ****************************************
// 에러 핸들 처리
// if (err instanceof SyntaxError && err.status === 400 && 'body' in err)
app.use((err, req, res, next) => {

  logger.error(`err.code=${err.code}, err.message=${err.message}`);

  if (err instanceof SyntaxError)
  {
    res.status(400).json({ error: '잘못된 JSON 형식입니다.' }); // // JSON 파싱 오류
  }
  else
  {
    switch (err.code) {

      case 'ER_BAD_NULL_ERROR':
        res.status(409).json({ error: '알맞는 JSON 필드가 없습니다.' });
        break;

      case 'ER_DUP_ENTRY':
        res.status(409).json({ error: '중복된 키입니다.' });
        break;

      case 'ER_BAD_FIELD_ERROR':
        res.status(409).json({ error: '존재하지 않는 컬럼입니다.' }); 
        break;

      case 'WARN_DATA_TRUNCATED':
        res.status(409).json({ error: '알맞지 않는 데이터입니다.' }); 
        break;

      case 'ER_PARSE_ERROR':
        res.status(409).json({ error: 'SQL 문법 오류입니다.' });
        break;

      case 'ECONNREFUSED':
        res.status(409).json({ error: 'DB 연결 실패 오류입니다.' }); 
        break;
    
      default:
        res.status(500).json({ error: '서버 내부 오류입니다.' });
        break;
    }
  }

  // next(err);
});


module.exports = app;
