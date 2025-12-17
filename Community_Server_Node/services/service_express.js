const express = require('express');
const app = express();

const logger = require('../utils/logger'); // Winston 설정 파일



// # 보안 헤더 설정
const securitySet = require('./expressSet/sv_securityHeader');
app.use(securitySet);

// # HTTP finish 로그 생성
const finishSet = require('./expressSet/sv_httpFinish');
app.use(finishSet);

// # Morgan으로 HTTP 요청 로그를 Winston에 전달
// const morganLogger = require('./expressSet/sv_morganLogger');
// app.use(morganLogger);

// # 이벤트 루프 지연 모니터링
// ...

// # cors 설정
const corsSet = require('./expressSet/sv_corsSet');
app.use(corsSet);

// # IP 체크, API Key 체크, Header Size 체크, uuid 부여
const checkerSet = require('./expressSet/sv_checkerSet');
app.use(checkerSet);


// 본문 크기 제한
app.use(express.json({
  limit: '10kb' // 본문 크기 제한
}));
// app.use(express.text()); // text/plain 요청을 처리


// ****************************************
// 라우터 모듈 연결
/*
// const path = require('path');
app.get('/', (req, res) => {
  res.sendFile('C:\\Users\\A\\Downloads\\Community-App-main\\Community_Server_Node\\home.html'); 
});
*/
app.get('/favicon.ico', (req, res) => res.status(204).end()); // 브라우저 아이콘 무시
app.use('/chat',         require('../routes/url_chat'));
app.use('/customer',     require('../routes/url_customer'));
app.use('/employee',     require('../routes/url_employee'));
app.use('/organization', require('../routes/url_organization'));
app.use('/post',         require('../routes/url_post'));
app.use('/product',      require('../routes/url_product'));
app.use('/project',      require('../routes/url_project'));
app.use('/system',       require('../routes/url_system'));
app.use('/schedule',       require('../routes/url_schedule'));
app.use('/approval',       require('../routes/url_approval'));

// ****************************************
const multer = require('multer');
const path = require('path');
const fs = require('fs');

// 1) 업로드 디렉토리 없으면 생성
const uploadDir = path.join(__dirname, 'uploads');
if (!fs.existsSync(uploadDir)) {
    fs.mkdirSync(uploadDir);
}

// 2) multer 설정
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, uploadDir);
    },
    filename: (req, file, cb) => {
        const uniqueName = Date.now() + '-' + file.originalname;
        cb(null, uniqueName);
    }
});
const upload = multer({ storage });

// 3) 업로드 API
app.post('/upload', upload.single('image'), async (req, res) => {
    try {
        const filePath = '/uploads/' + req.file.filename;

        console.log(`app.post > ${filePath}`);

        // DB 저장 예시
        // await db.query("INSERT INTO images (path) VALUES (?)", [filePath]);

        res.json({
            success: true,
            path: filePath
        });
    } catch (err) {
        console.error(err);
        res.status(500).json({ success: false });
    }
});

// 4) 정적 파일 제공
app.use('/uploads', express.static(uploadDir));

// ****************************************
// 정상 핸들 처리
app.use((req, res, next) => {

  const result = res.locals.dbResult;
  logger.info(`[ip=${req.ip}][uuid=${req.requestId}] Normal Processing Success`);
  res.status(200).json(result);

  /*
  if (result) {
    logger.info(`[ip=${req.ip}][uuid=${req.requestId}] Normal Processing Success`);
    res.status(200).json(result);
  }
  else {
    logger.error(`[ip=${req.ip}][uuid=${req.requestId}] Normal Processing Error=None URL`);
    res.status(404).end();
  }
  */
});


// ****************************************
// 에러 핸들 처리
app.use((err, req, res, next) => {

  const contentType = req.headers?.['content-type'] || 'unknown';
  
  logger.error(`[ip=${req.ip}][uuid=${req.requestId}] [content-type=${contentType}] [type=${err.type}] [code=${err.code}] [status=${err.status}] [message=${err.message}] [body=${err.body}]`);

  if (err instanceof SyntaxError) {
    res.status(400).json({ error: '잘못된 JSON 형식입니다.' });
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

      case 'ER_NO_DEFAULT_FOR_FIELD':
        res.status(409).json({ error: '필수 필드가 누락됐습니다.' });
        break;

      case 'ECONNREFUSED':
        res.status(409).json({ error: 'DB 연결 실패 오류입니다.' }); 
        break;

      case 'ER_TRUNCATED_WRONG_VALUE':
        res.status(500).json({ error: '서버 내부 오류입니다.' });
        break;
    
      default:
        res.status(500).json({ error: '서버 내부 오류입니다.' });
        break;
    }
  }

  // next(err);
});





module.exports = app;
