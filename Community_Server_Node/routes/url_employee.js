const express = require('express');
const router = express.Router();
const db = require('../services/service_database');

const schema = {

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
    }
};

const tb_employee_list = schema.employee_list;
router.post('/list/select', async (req, res, next) => db.get(req, res, next, tb_employee_list));
router.post('/list/insert', async (req, res, next) => db.post(req, res, next, tb_employee_list));
router.put('/list/update', async (req, res, next) => db.put(req, res, next, tb_employee_list));
router.delete('/list/delete', async (req, res, next) => db.delete(req, res, next, tb_employee_list));

const tb_employee_leave = schema.employee_leave;
router.post('/leave/select', async (req, res, next) => db.get(req, res, next, tb_employee_leave));
router.post('/leave/insert', async (req, res, next) => db.post(req, res, next, tb_employee_leave));
router.put('/leave/update', async (req, res, next) => db.put(req, res, next, tb_employee_leave));
router.delete('/leave/delete', async (req, res, next) => db.delete(req, res, next, tb_employee_leave));

const tb_employee_review = schema.employee_review;
router.post('/review/select', async (req, res, next) => db.get(req, res, next, tb_employee_review));
router.post('/review/insert', async (req, res, next) => db.post(req, res, next, tb_employee_review));
router.put('/review/update', async (req, res, next) => db.put(req, res, next, tb_employee_review));
router.delete('/review/delete', async (req, res, next) => db.delete(req, res, next, tb_employee_review));


router.post('/attendance/select', async (req, res, next) => {
    try {
        const data = db.pick(req.body, [ 
            'select_type', 'select_total', 'date',

            'employee_id',          // 당일 조회, 그 외
            'created_at',           // 특정 날짜 조회
            'start_at', 'end_at',   // 날짜 범위 조회
            'base_at', 'count'      // 기준일부터 N일 이내 조회
        ]);

        switch (data.select_type) {

            case 'today': // 오늘 날짜 조회
                {
                    const sql = 'SELECT * FROM v_employee_attendance a WHERE DATE(a.created_at) = CURDATE() LIMIT 1000;';
                    const result = await db.query(req, sql, [data.employee_id]);
                    res.locals.dbResult = result;
                }
                break;

            case 'single': // 개별 조회
                {
                    const sql = 'SELECT * FROM v_employee_attendance a WHERE DATE(a.created_at) = CURDATE() AND a.employee_id = ? LIMIT 1;';
                    const result = await db.query(req, sql, [data.employee_id]);
                    res.locals.dbResult = result;
                }
                break;

            case 'date':
                {
                        // 특정 날짜 집계 조회
                        const sql = `
                            SELECT 
                                e.id AS 'employee_id', e.employee_code, e.name,
                                e.company_name, e.department_name, e.team_name,
                                e.rank_name, e.position_name, e.role_name, e.privilege_name,
                                a.id,
                                a.start_work_at, a.end_work_at,
                                SEC_TO_TIME(a.total_work_minutes * 60) AS 'total_work_minutes',
                                a.description, a.created_at, a.updated_at
                            FROM v_employees e
                                LEFT OUTER JOIN tb_employee_attendance a ON 
                                a.employee_id = e.id AND DATE(a.start_work_at) = DATE(?);
                        `;
                        const result = await db.query(req, sql, [data.date]);
                        res.locals.dbResult = result;
                }
                break;

            case 'range':
                {
                    // 날짜 범위 조회
                    // SELECT * FROM v_employee_attendance a WHERE a.created_at BETWEEN ? AND ?;
                }
                break;

            case 'days':
                {
            // 기준일부터 N일 이내 조회
            // SELECT * FROM v_employee_attendance a WHERE DATEDIFF(a.created_at, ?) BETWEEN 0 AND ?;
                }
                break;
        }
        
        next();
    } 
    catch (err) {
        next(err);
    }
});

router.post('/attendance/insert', async (req, res, next) => {
    try {
        const data = db.pick(req.body, ['employee_id']);

        if (data.employee_id) {
            /* 출근 이력 생성 */
            const sql = 'INSERT INTO tb_employee_attendance (employee_id, start_work_at) SELECT ?, NOW() WHERE NOT EXISTS (SELECT 1 FROM tb_employee_attendance WHERE employee_id = ? AND DATE(start_work_at) = CURDATE());';
            const result = await db.query(req, sql, [data.employee_id, data.employee_id]);
            res.locals.dbResult = result;
        }
        
        next();
    } 
    catch (err) {
        next(err);
    }
});

router.put('/attendance/update', async (req, res, next) => {
    try {
        const data = db.pick(req.body, ['employee_id', 'description']);

        if (data.employee_id && data.description) {
            /* 근태 설명 업데이트 */
            const sql = 'UPDATE tb_employee_attendance SET description = ? WHERE employee_id = ?;';
            const result = await db.query(req, sql, [data.description, data.employee_id]);
            res.locals.dbResult = result;

        } else if (data.employee_id) {
            /* 퇴근 이력 업데이트 */
            const sql = 'UPDATE tb_employee_attendance SET end_work_at = NOW() WHERE employee_id = ? AND DATE(start_work_at) = CURDATE() AND end_work_at IS NULL;';
            const result = await db.query(req, sql, [data.employee_id]);
            res.locals.dbResult = result;
        }
        
        next();
    } 
    catch (err) {
        next(err);
    }
});

/* 근태 이력 삭제 */
router.delete('/attendance', async (req, res, next) => {
    try {
        const data = db.pick(req.body, [ 'id' ]);
        const sql = 'DELETE FROM tb_employee_attendance WHERE id = ?';
        const result = await db.query(req, sql, data);
        res.locals.dbResult = result;
        
        next();
    } 
    catch (err) {
        next(err);
    }
});


module.exports = router;