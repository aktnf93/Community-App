const logger = require('../../utils/logger');

// IP 체크, API Key 체크, Header Size 체크, uuid 부여
const { v4: uuidv4 } = require('uuid'); // uuid 부여.

const checkerSet = (req, res, next) => {

  // * * * * * * * * * * * * * * * * * * * * * * * * * * *
  // IP 체크 (화이트 리스트)
  const allowedIps = ['127.0.0.1', '::1', '::ffff:127.0.0.1']; // 로컬 IP만 허용
  const clientIp = req.ip;

  if (!allowedIps.includes(clientIp)) {
    logger.error(`[ip=${clientIp}] IP Blocked`)
    return res.status(404).end();
  }

  // * * * * * * * * * * * * * * * * * * * * * * * * * * *
  // API Key 체크
  
  const t_autho_key = req.headers['authorization'];
  if (!t_autho_key || t_autho_key !== 'a620') {
    // logger.error(`[ip=${clientIp}] Unauthorized: ${t_autho_key}`)
    // return res.status(401).end(); // Unauthorized
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
};

module.exports = checkerSet;