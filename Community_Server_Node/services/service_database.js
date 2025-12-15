const mysql = require('mysql2/promise');
const logger = require('../utils/logger');
const pick = require('../utils/pick');

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

// * * * * * * * * * * * * * * * * * * * * * * * * * * *

const query = async (req, sql, params = []) => {
    let conn;

    try {
        const compactSql = sql.replace(/\s+/g, ' ').trim();
        logger.info(`[ip=${req.ip}][uuid=${req.requestId}] SQL: "${compactSql}", params: ${JSON.stringify(params)}`);

        conn = await pool.getConnection();
        const [rows, fields] = await conn.query(sql, params);
        
        return rows;
    } catch (err) {
        // logger.info(`[ip=${req.ip}][uuid=${requestId}] SQL-Error: ${err.message}`);
        throw err;
    } finally {
        if (conn) conn.release();
    }
};





// * * * * * * * * * * * * * * * * * * * * * * * * * * *
const setCondition = (data, field, operator = '=') => {

    if (field in data) {
        const value = data[field];
        const op = operator.toUpperCase();

        if (value === null) {
            // null 검색 → IS NULL
            // data[field] = { operator: 'IS NULL', value: null, isRaw: true };

            delete data[field];
        } 
        else if (value.toString().trim() === '') {
            // 빈 문자열 검색 → = ''
            // data[field] = { operator: '=', value: '' };

            delete data[field];
        } 
        else {
            switch (op) {
                case 'LIKE':
                    data[field] = { operator: op, value: `%${value}%` };
                    break;
                default:
                    data[field] = { operator: op, value };
                    break;
            }
        }
    }
};

const select_query_operator = async (req, table, conditions = {}, columns = ['*']) => {
    
    const selectColumns = columns.join(', ');

    const whereKeys = Object.keys(conditions);

    const whereClause = (whereKeys.length > 0) ? 'WHERE ' + whereKeys.map(key => {
        const cond = conditions[key];
        if (cond.isRaw) {
            return `${key} ${cond.operator}`; // ex) "employee_code IS NULL"
        }
        return `${key} ${cond.operator} ?`;
    }).join(' AND ') : '';

    const sqlValues = whereKeys
        .filter(key => !conditions[key].isRaw)
        .map(key => conditions[key].value);

    const sql = `SELECT ${selectColumns} FROM ${table} ${whereClause} LIMIT 1000;`;
    const result = await query(req, sql, sqlValues);
    return result;
};


/**
 * SELECT 쿼리를 동적으로 생성하는 함수 ( SELECT * FROM Table WHERE id = 1 AND name = 'A' LIMIT 1000; )
 * @param {string} table - 조회할 테이블 이름
 * @param {Object} conditions - WHERE 조건 객체 (예: { id: 1, name: 'Alice' })
 * @param {string[]} columns - 조회할 컬럼 목록 (기본값: ['*'])
 */
const select_query = async (req, table, conditions = {}, columns = ['*']) => {

    const selectColumns = columns.join(', ');
    const whereKeys = Object.keys(conditions);
    const whereClause = (whereKeys.length > 0) ? 'WHERE ' + whereKeys.map(key => `${key} = ?`).join(' AND ') : '';
    const sqlValues = whereKeys.map(key => conditions[key]);

    const sql = `SELECT ${selectColumns} FROM ${table} ${whereClause} LIMIT 1000;`;

    const result = await query(req, sql, sqlValues);
    return result;
};

/**
 * INSERT 쿼리를 동적으로 생성하고 실행하는 함수
 * @param {string} tableName - 데이터를 삽입할 테이블 이름
 * @param {Object} data - 삽입할 데이터 객체 (예: { id: 1, name: 'Alice' })
 *                         키는 컬럼명, 값은 삽입할 값
 * @returns {Promise<Object>} - 삽입 결과를 포함한 Promise 객체
 */
const insert_query = async (req, tableName, data) => {
    // ******************************************
    const columns = Object.keys(data);

    // id, created_at, updated_at는 insert 할 수 없다.
    const filteredColumns = columns.filter(col => (col !== 'id') || (col !== 'created_at') || (col !== 'updated_at'));

    const sqlColumns = filteredColumns.join(', ');                     // ['name', 'remark']
    const sqlPlaceholders = filteredColumns.map(() => '?').join(', '); // ['?', '?']
    const sqlValues = filteredColumns.map(col => data[col]);           // ['Alice', 'hello']

    const sql = `INSERT INTO ${tableName} (${sqlColumns}) VALUES (${sqlPlaceholders});`;
    // ******************************************

    const result = await query(req, sql, sqlValues);
    return result;
};

/**
 * UPDATE 쿼리를 동적으로 생성하고 실행하는 함수
 * @param {string} tableName - 데이터를 삽입할 테이블 이름
 * @param {Object} data - 업데이트할 데이터 객체 (예: { id: 1, name: 'Alice' })
 *                         키는 컬럼명, 값은 삽입할 값
 * @returns {Promise<Object>} - 삽입 결과를 포함한 Promise 객체
 */
const update_query = async (req, tableName, data) => {
    // ******************************************
    const columns = Object.keys(data); // ['name', 'remark']

    // id, created_at, updated_at는 update 할 수 없다.
    const filteredColumns = columns.filter(col => (col !== 'id') || (col !== 'created_at') || (col !== 'updated_at'));

    const sqlSet = filteredColumns.map(col => `${col} = ?`).join(', '); // 'name = ?, remark = ?'
    const sqlValues = filteredColumns.map(col => data[col]); // ['Alice', 'hello']

    const sql = `UPDATE ${tableName} SET ${sqlSet} WHERE id = ?`;
    sqlValues.push(data.id); // 마지막에 WHERE 조건 값 추가
    // ******************************************

    const result = await query(req, sql, sqlValues);
    return result;
};

/**
 * DELETE 쿼리를 동적으로 생성하고 실행하는 함수
 * @param {string} tableName - 삭제할 테이블 이름
 * @param {Object} data - WHERE 조건 객체 (예: { id: 1, name: 'John' })
 * @returns {Promise<Object>} - 삭제 결과를 포함한 Promise 객체
 */
const delete_query = async (req, tableName, data) => {
    // ******************************************
    const keys = Object.keys(data);
    if (keys.length === 0) throw new Error('삭제 조건이 없습니다');

    const whereClause = keys.map(key => `${key} = ?`).join(' AND ');
    const values = keys.map(key => data[key]);

    const sql = `DELETE FROM ${tableName} WHERE ${whereClause}`;
    // ******************************************
    
    const result = await query(req, sql, values);
    return result;
};

// * * * * * * * * * * * * * * * * * * * * * * * * * * *

const route_get = async (req, res, next, tb) => {
    try {
        const data = pick(req.body, tb.get);
        const result = await select_query(req, tb.table, data);
        res.locals.dbResult = result;
        next();
    } 
    catch (err) {
        next(err);
    }
};

const route_post = async (req, res, next, tb) => {
    try {
        const data = pick(req.body, tb.post);
        const result = await insert_query(req, tb.table, data);
        res.locals.dbResult = result;
        next();
    } 
    catch (err) {
        next(err);
    }
};

const route_put = async (req, res, next, tb) => {
    try {
        const data = pick(req.body, tb.put);
        const result = await update_query(req, tb.table, data);
        res.locals.dbResult = result;
        next();
    } 
    catch (err) {
        next(err);
    }
};

const route_delete = async (req, res, next, tb) => {
    try {
        const data = pick(req.body, tb.delete);
        const result = await delete_query(req, tb.table, data);
        res.locals.dbResult = result;
        next();
    } 
    catch (err) {
        next(err);
    }
};


module.exports = {
    pool,
    pick,
    query,
    get: route_get,
    post: route_post, 
    put: route_put,
    delete: route_delete, 

    setCondition, 
    select_query_operator, 
    select_query, 
    insert_query, 
    update_query, 
    delete_query
};