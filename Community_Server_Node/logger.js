const winston = require('winston');
const { combine, timestamp, printf } = winston.format;
require('winston-daily-rotate-file');

const logger = winston.createLogger({
    format: combine(
        timestamp({ format: 'YYYY-MM-DD HH:mm:ss.SSS' }),
        printf(({ level, message, label, timestamp }) => {
          return `${timestamp} [${level}]: ${message}`;
        })
    ),
    transports: [
        new winston.transports.Console(), 
        new winston.transports.DailyRotateFile({
          filename: 'logs/app-%DATE%.log',
          datePattern: 'YYYY-MM-DD',
          zippedArchive: true, // 압축 여부
          maxSize: '20m',       // 파일당 최대 크기
          maxFiles: '14d'       // 최대 보관 기간
        })
    ]
});

module.exports = logger;