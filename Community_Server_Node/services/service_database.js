const mysql = require('mysql2/promise');
const logger = require('../logger');
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

/**
 * SELECT 쿼리를 동적으로 생성하는 함수 ( SELECT * FROM Table WHERE id = 1 AND name = 'A' LIMIT 1000; )
 * @param {string} table - 조회할 테이블 이름
 * @param {Object} conditions - WHERE 조건 객체 (예: { id: 1, name: 'Alice' })
 * @param {string[]} columns - 조회할 컬럼 목록 (기본값: ['*'])
 */
const select_query = async (req, table, conditions = {}, columns = ['*']) => {
    // ******************************************
    const selectColumns = columns.join(', ');
    const whereKeys = Object.keys(conditions);
    const whereClause = whereKeys.length > 0
        ? 'WHERE ' + whereKeys.map(key => `${key} = ?`).join(' AND ')
        : '';
    const sqlValues = whereKeys.map(key => conditions[key]);

    const sql = `SELECT ${selectColumns} FROM ${table} ${whereClause} LIMIT 1000;`;
    // ******************************************

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
 * @param {Object} data - WHERE 조건 id (예: { id: 1 })
 * @returns {Promise<Object>} - 삭제 결과를 포함한 Promise 객체
 */
const delete_id_query = async (req, tableName, data) => {
    // ******************************************
    const sql = `DELETE FROM ${tableName} WHERE id = ?`;
    // ******************************************

    const result = await query(req, sql, [data.id]);
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


const tables = {

    // __________________________________________/post
    post_category: {
        table: 'tb_post_category',
        view: 'tb_post_category',
        get: ['id'],
        post: ['parent_id', 'name', 'description'],
        put: ['id', 'parent_id', 'name', 'description'],
        delete: ['id']
    },

    post_list: {
        table: 'tb_posts',
        view: 'v_posts',
        get: ['id', 'post_category_id', 'employee_id'],
        post: ['post_category_id', 'employee_id', 'title', 'content'],
        put: ['id', 'post_category_id', 'title', 'content', 'view_count', 'deleted_at'],
        delete: ['id']
    },

    post_comment: {
        table: 'tb_post_comments',
        get: ['id', 'post_id', 'employee_id'],
        post: ['post_id', 'employee_id', 'content'],
        put: ['id', 'content', 'deleted_at'],
        delete: ['id']
    },

    // __________________________________________/chat
    chat_room: {
        table: 'tb_chat_rooms',
        get: ['id'],
        post: ['name', 'description'],
        put: ['id', 'name', 'description', 'is_deleted'],
        delete: ['id']
    },

    chat_member: {
        table: 'tb_chat_members',
        get: ['id', 'chat_room_id', 'employee_id'],
        post: ['chat_room_id', 'employee_id'],
        put: ['id', 'is_deleted'],
        delete: ['id']
    },

    chat_message: {
        table: 'tb_chat_messages',
        get: ['id', 'chat_member_id'],
        post: ['chat_member_id', 'message'],
        put: ['id', 'is_deleted'],
        delete: ['id']
    },


    // __________________________________________/project
    project_list: {
        table: 'tb_projects',
        get: ['id', 'status'],
        post: ['customer_id', 'name', 'description', 'progress', 'start_date', 'end_date', 'status'],
        put: ['id', 'customer_id', 'name', 'description', 'progress', 'start_date', 'end_date', 'status', 'is_deleted'],
        delete: ['id']
    },

    project_member: {
        table: 'tb_project_members',
        get: ['id', 'project_id', 'employee_id'],
        post: ['project_id', 'employee_id'],
        // put: [],
        delete: ['id']
    },

    project_task: {
        table: 'tb_project_tasks',
        get: ['id', 'project_id', 'status'],
        post: ['project_id', 'name', 'description', 'progress', 'start_date', 'end_date', 'status'],
        put: ['id', 'name', 'description', 'progress', 'start_date', 'end_date', 'status'],
        delete: ['id']
    },

    project_task_member: {
        table: 'tb_project_task_members',
        get: ['id', 'project_task_id'],
        post: ['project_task_id', 'project_member_id'],
        // put: [],
        delete: ['id']
    },

    // __________________________________________/customer
    customer_list: {
        table: 'tb_customers',
        get: ['id'],
        post: ['location_id', 'name', 'description', 'image_path'],
        put: ['id', 'location_id', 'name', 'description', 'image_path', 'is_deleted'],
        delete: ['id']
    },

    customer_product: {
        table: 'tb_customer_products',
        get: ['id', 'customer_id', 'product_id'],
        post: ['customer_id', 'product_id'],
        // put: [],
        delete: ['id']
    },

    // __________________________________________/product
    product_list: {
        table: 'tb_products',
        get: ['id'],
        post: ['name', 'content', 'description', 'image_path', 'total_count'],
        put: ['id', 'name', 'content', 'description', 'image_path', 'total_count', 'is_deleted'],
        delete: ['id']
    },

    product_inventory: {
        table: 'tb_product_inventory',
        get: ['id', 'product_id', 'from_employee_id', 'to_employee_id'],
        post: ['product_id', 'from_employee_id', 'to_employee_id', 'movement_type', 'movement_count', 'content'],
        put: ['id', 'product_id', 'from_employee_id', 'to_employee_id', 'movement_type', 'movement_count', 'content'],
        delete: ['id']
    },

    // __________________________________________/employee
    employee_list: {
        table: 'v_employees',
        get: ['id', 'login_id', 'login_pw'],
        post: [
            'name', 'description', 'employee_code', 
            'gender', 'birth_date', 'email', 'phone', 'address', 'image_path', 
            'status', 'joined_at', 'resigned_at', 
            'team_id', 'rank_id', 'position_id', 'role_id', 'privilege_id',
            'login_id', 'login_pw', 'is_active', 'deleted_at'
        ],
        put: [
            'id', 'name', 'description', 'employee_code', 
            'gender', 'birth_date', 'email', 'phone', 'address', 'image_path', 
            'status', 'joined_at', 'resigned_at', 
            'team_id', 'rank_id', 'position_id', 'role_id', 'privilege_id',
            'login_id', 'login_pw', 'is_active', 'deleted_at'
        ],
        delete: ['id']
    },

    employee_leave: {
        table: 'tb_employee_leaves',
        get: ['id', 'employee_id', 'approver_id', 'leave_type', 'leave_result'],
        post: ['employee_id', 'approver_id', 'leave_type', 'start_dt', 'end_dt', 'description', 'leave_result'],
        put: ['id', 'leave_type', 'start_dt', 'end_dt', 'description', 'leave_result'],
        delete: ['id']
    },

    employee_review: {
        table: 'tb_employee_reviews',
        get: ['id', 'employee_id', 'reviewer_id', 'review_type', 'review_result'],
        post: ['employee_id', 'reviewer_id', 'review_date', 'review_type', 'score', 'description', 'review_result'],
        put: ['id', 'review_date', 'review_type', 'score', 'description', 'review_result'],
        delete: ['id']
    },

    // __________________________________________/organization
    organization_location: {
        table: 'tb_organization_locations',
        get: ['id'],
        post: ['name', 'description'],
        put: ['id', 'name', 'description'],
        delete: ['id']
    },

    organization_company: {
        table: 'tb_organization_companies',
        get: ['id'],
        post: ['name', 'description'],
        put: ['id', 'name', 'description'],
        delete: ['id']
    },

    organization_department: {
        table: 'tb_organization_departments',
        get: ['id', 'company_id'],
        post: ['company_id', 'name', 'description'],
        put: ['id', 'name', 'description'],
        delete: ['id']
    },

    organization_team: {
        table: 'tb_organization_teams',
        get: ['id', 'department_id'],
        post: ['department_id', 'name', 'description'],
        put: ['id', 'name', 'description'],
        delete: ['id']
    },

    organization_rank: {
        table: 'tb_organization_ranks',
        get: ['id'],
        post: ['name', 'description'],
        put: ['id', 'name', 'description'],
        delete: ['id']
    },

    organization_position: {
        table: 'tb_organization_positions',
        get: ['id'],
        post: ['name', 'description'],
        put: ['id', 'name', 'description'],
        delete: ['id']
    },

    organization_role: {
        table: 'tb_organization_roles',
        get: ['id'],
        post: ['name', 'description'],
        put: ['id', 'name', 'description'],
        delete: ['id']
    },

    organization_privilege: {
        table: 'tb_organization_privileges',
        get: ['id'],
        post: ['name'],
        put: [
            'id', 'name', 'description',
            'auth_post', 'auth_chat', 
            'auth_project', 'auth_customer', 'auth_product', 'auth_employee',
            'auth_system'
        ],
        delete: ['id']
    },

    // __________________________________________/system
    system_config: {
        table: 'tb_system_config',
        get: ['id'],
        // post: [],
        put: ['id', 'value_number', 'value_text'],
        // delete: []
    },

    system_log: {
        table: 'tb_system_logs',
        get: ['id'],
        post: ['category', 'message'],
        // put: [],
        // delete: []
    },
};

module.exports = {
    pick,
    query,
    tb: tables,
    get: route_get,
    post: route_post, 
    put: route_put,
    delete: route_delete
};