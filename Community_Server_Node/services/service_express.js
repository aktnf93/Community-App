const express = require('express');
const app = express();

const logger = require('../logger'); // Winston 설정 파일



// ****************************************
// 보안 헤더 설정
const helmet = require('helmet');
app.use(helmet({
  // contentSecurityPolicy: 외부 CDN, 이미지, 폰트 등 로딩에 영향을 줄 수 있으니 주의
  contentSecurityPolicy: true, // 외부 리소스 로딩 제한 (스크립트, 이미지 등) → XSS 방지

  crossOriginEmbedderPolicy: true,      // 교차 출처 리소스 임베딩 제한 → 보안 격리 강화
  crossOriginOpenerPolicy: true,        // 새 창/탭과의 공유 제한 → Spectre 공격 방지
  crossOriginResourcePolicy: true,      // 외부 리소스 공유 제한 → 민감 리소스 보호
  dnsPrefetchControl: true,             // DNS 프리페치 제어 → 정보 노출 방지
  expectCt: true,                       // Certificate Transparency 정책 설정 → SSL 인증서 위조 방지
  frameguard: true,                     // iframe 삽입 차단 → 클릭재킹 방지
  hidePoweredBy: true,                  // X-Powered-By 헤더 제거 → Express 노출 방지

  hsts: false,                          // HTTPS 강제 → 중간자 공격 방지

  ieNoOpen: true,                       // IE에서 다운로드된 파일 자동 실행 방지
  noSniff: true,                        // MIME 타입 추측 방지 → 악성 콘텐츠 실행 차단
  originAgentCluster: true,             // 브라우저의 Origin 격리 활성화
  permittedCrossDomainPolicies: true,   // Adobe 플러그인 정책 제한
  referrerPolicy: true,                 // 리퍼러 정보 제한 → 개인정보 보호
  xssFilter: true                       // XSS 필터 활성화 (구형 브라우저용) → 최신 브라우저에선 무의미
}));


// ****************************************
// HTTP finish 로그 생성
const { performance } = require('perf_hooks');
app.use((req, res, next) => {
  const start = performance.now();

  const log = {
    ip: req.ip,
    method: req.method,
    url: req.originalUrl,
    httpVersion: req.httpVersion,
    referrer: req.get('Referer') || '-',
    userAgent: req.get('User-Agent') || '-',
  };

  res.on('finish', () => {
    const end = performance.now();
    const duration = (end - start).toFixed(2); // ms 단위

    log.id = req.requestId || 'no-id',
    log.status = res.statusCode;
    log.length = res.getHeader('Content-Length') || '-';
    // console.log(log);

    try {
      log.body = JSON.stringify(req.body);
    } catch {
      log.body = 'unreadable';
    }

    const logText = 
      `[ip=${log.ip}][uuid=${log.id}] ` +
      `${log.method} ${log.url} HTTP/${log.httpVersion} | ` +
      `status=${log.status} length=${log.length} ${duration}ms | ` +
      `referrer=(${log.referrer}) userAgent=${log.userAgent} body=${log.body}`;

    logger.http(logText.trim())
  });

  next();
});


// ****************************************
// Morgan으로 HTTP 요청 로그를 Winston에 전달
/*
const morgan = require('morgan'); // Morgan으로 HTTP 요청 로그를 Winston에 전달
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
app.use(morgan(format, {
  stream: {
    write: (message) => logger.http(message.trim())
  }
}));
*/


// ****************************************
// 이벤트 루프 지연 모니터링
/*
const toobusy = require('toobusy-js'); // 이벤트 루프 지연 모니터링
toobusy.maxLag(50); // 50ms 이상 지연되면 busy로 판단 (최소 10ms)

app.use((req, res, next) => {

    res.setTimeout(3000); // ms 타임아웃 설정 (선택)

    res.on('timeout', () => {
      console.warn(`⏱️ Timeout on ${req.method} ${req.originalUrl}`);
      // 선택적으로 응답 시도 (주의: 이미 응답했을 수도 있음)
      if (!res.headersSent) {
        res.status(503).send('Request timed out');
      }
    });


    // 이벤트 루프 지연 모니터링.
    if (toobusy()) {
        // log if you see necessary
        res.status(503).send("Server Too Busy");
    } else {
      next();
    }
});

setInterval(() => {
  console.log(`Event loop lag: ${toobusy.lag()} ms`);
}, 1000);
*/


// ****************************************
// cors 설정
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

app.use(cors({
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
}));

// IP 체크, API Key 체크, Header Size 체크, uuid 부여
const { v4: uuidv4 } = require('uuid'); // uuid 부여.
app.use((req, res, next) => {

  // * * * * * * * * * * * * * * * * * * * * * * * * * * *
  // IP 체크 (화이트 리스트)
  const allowedIps = ['127.0.0.1', '::1']; // 로컬 IP만 허용
  const clientIp = req.ip;

  if (!allowedIps.includes(clientIp)) {
    logger.error(`[ip=${clientIp}] IP Blocked`)
    return res.status(404).end();
  }

  // * * * * * * * * * * * * * * * * * * * * * * * * * * *
  // API Key 체크
  const t_autho_key = req.headers['authorization'];
  if (!t_autho_key || t_autho_key !== 'a620') {
    logger.error(`[ip=${clientIp}] Unauthorized: ${t_autho_key}`)
    return res.status(401).end(); // Unauthorized
  }

  // * * * * * * * * * * * * * * * * * * * * * * * * * * *
  // Header Size 체크
  const headerSize = JSON.stringify(req.headers).length;
  const headerMaxSize = 8192;
  if (headerSize > headerMaxSize) {
    // 431 Request Header Fields Too Large
    logger.error(`[ip=${clientIp}] Header Size Exceeded: ${headerSize}/${headerMaxSize} bytes`);
    return res.status(431).end();
  }

  req.requestId = uuidv4(); // uuid 부여
  logger.info(`[ip=${clientIp}][uuid=${req.requestId}] Passed`);

  next();
});

// 본문 크기 제한
app.use(express.json({
  limit: '1kb' // 본문 크기 제한
}));
// app.use(express.text()); // text/plain 요청을 처리


// ****************************************
// 라우터 모듈 연결
app.use('/chat',         require('../routes/url_chat'));
app.use('/customer',     require('../routes/url_customer'));
app.use('/employee',     require('../routes/url_employee'));
app.use('/organization', require('../routes/url_organization'));
app.use('/post',         require('../routes/url_post'));
app.use('/product',      require('../routes/url_product'));
app.use('/project',      require('../routes/url_project'));
app.use('/system',       require('../routes/url_system'));

app.get('/favicon.ico', (req, res) => res.status(204).end()); // 브라우저 아이콘 무시


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
    
      default:
        res.status(500).json({ error: '서버 내부 오류입니다.' });
        break;
    }
  }

  // next(err);
});





module.exports = app;
