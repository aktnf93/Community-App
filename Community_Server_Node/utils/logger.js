const winston = require('winston');
const { combine, colorize, timestamp, printf } = winston.format;
require('winston-daily-rotate-file');


// 커스텀 레벨 및 색상.
const customLevels = {
  levels: {
    error:   0, // 치명적인 오류
    warn:    1, // 경고
    info:    2, // 일반 정보 로그
    http:    3, // HTTP 요청 관련 로그
    verbose: 4, // 상세 정보 로그
    debug:   5, // 디버깅용 로그
    sql:     6,
    silly:   7, // 아주 상세한 로그
  },
  colors: {
    error:   'red', 
    warn:    'yellow', 
    info:    'green', 
    http:    'magenta', 
    verbose: 'cyan', 
    debug:   'blue',
    sql:     'green',
    silly:   'rainbow', 
  }
};
// white

winston.addColors(customLevels.colors);

const consoleFormat = combine(
  colorize({ all: true }),
  timestamp({ format: 'YYYY-MM-DD HH:mm:ss.SSS' }),
  printf(({ level, message, timestamp }) => {
    return `${timestamp} [${level}]: ${message}`;
  })
);


const fileFormat = combine(
  timestamp({ format: 'YYYY-MM-DD HH:mm:ss.SSS' }),
  printf(({ level, message, timestamp }) => {
    return `${timestamp} [${level}]: ${message}`;
  })
);

const fileJsonFormat = combine(
  timestamp(),
  winston.format.json()
);


const logger = winston.createLogger({
  levels: customLevels.levels,
  level: 'silly', // 현재 레벨을 최저로.
  transports: [
      new winston.transports.Console({ format: consoleFormat }), 
      new winston.transports.DailyRotateFile({
        format: fileFormat,
        filename: 'logs/app-%DATE%.log',
        datePattern: 'YYYY-MM-DD',
        zippedArchive: true, // 압축 여부
        maxSize: '20m',       // 파일당 최대 크기
        maxFiles: '14d'       // 최대 보관 기간
      })
  ]
});

module.exports = logger;