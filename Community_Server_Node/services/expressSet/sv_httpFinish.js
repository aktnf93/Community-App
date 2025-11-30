const logger = require('../../utils/logger');

const { performance } = require('perf_hooks');

const finishSet = (req, res, next) => {
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
};

module.exports = finishSet;