const mysql = require('mysql2/promise');
const logger = require('../logger');

require('dotenv').config();
const env = process.env;
const pool = mysql.createPool({
    host:     env.DB_HOST,
    port:     Number(env.DB_PORT),
    user:     env.DB_USER,
    password: env.DB_PASSWORD,
    database: env.DB_NAME,

    waitForConnections: true,               // 커넥션이 없을 때 대기 여부
    connectionLimit: 10,                    // 최대 커넥션 수
    queueLimit: 0,                          // 대기열 최대 길이 (0=무제한)
    enableKeepAlive: true,                  // TCP Keep-Alive 활성화
    keepAliveInitialDelay: 10000,           // Keep-Alive 시작 지연 시간 (ms)
    connectTimeout: 10000,                  // 연결 타임아웃 (ms)
    // acquireTimeout: 10000,               // 커넥션 획득 타임아웃 (ms)
    multipleStatements: false,              // 여러 SQL 문장 허용 여부
    charset: 'utf8mb4',                     // 문자셋 설정
    timezone: '+09:00',                     // 시간대 설정
    // ssl: {rejectUnauthorized: true},     // SSL 연결 설정

    typeCast: function (field, next) {
        if (field.type === 'DATETIME' || field.type === 'TIMESTAMP') {
        return field.string(); // 그대로 문자열로 반환
        }
        return next();
    }
});

const query = async (sql, params) => {
    let conn;
    try {
        const compactSql = sql.replace(/\s+/g, ' ').trim();
        logger.info(`db query: sql=\"${compactSql}\", params=\"${params}\"`);

        conn = await pool.getConnection();
        const result = await conn.query(sql, params);

        return result;
    } catch (err) {
        // logger.info(`db error: ${err.message}`);
        throw err;
    } finally {
        if (conn) conn.release();
    }
};

module.exports = query;