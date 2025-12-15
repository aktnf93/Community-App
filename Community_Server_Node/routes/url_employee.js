const express = require('express');
const router = express.Router();
const db = require('../services/service_database');
const pick = require('../utils/pick');

const schema = {

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


router.post('/list/login', async (req, res, next) => {
    try {
        const data = pick(req.body, [ 'login_id', 'login_pw' ]);
        const result = await db.query(req, 'SELECT * FROM v_employees WHERE login_id = ? AND login_pw = ?;', [data.login_id, data.login_pw]);
        res.locals.dbResult = result;

        next();
    } 
    catch (err) {
        next(err);
    }
});

router.post('/list/select', async (req, res, next) => {
    try {
        const data = pick(req.body, [
            'login_id', 'login_pw', 
            'company_id', 'department_id', 'team_id', 
            'id', 'employee_code', 'name'
        ]);

        db.setCondition(data, 'login_id', '=');
        db.setCondition(data, 'login_pw', '=');
        db.setCondition(data, 'company_id', '=');
        db.setCondition(data, 'department_id', '=');
        db.setCondition(data, 'team_id', '=');
        db.setCondition(data, 'id', '=');
        db.setCondition(data, 'employee_code', 'LIKE');
        db.setCondition(data, 'name', 'LIKE');

        const result = await db.select_query_operator(req, 'v_employees', data);
        res.locals.dbResult = result;

        next();
    } 
    catch (err) {
        next(err);
    }
});
router.post('/list/insert', async (req, res, next) => {
    try {
        const data = pick(req.body, [
            'name', 'description', 'employee_code', 'employee_type', 
            'gender', 'birth_date', 'email', 'phone', 'address', 'image_path', 
            'status', 'joined_at', 'resigned_at', 'resigned_desc', 
            'team_id', 'rank_id', 'position_id', 'role_id', 'privilege_id',
            'login_id', 'login_pw', 'is_active', 'deleted_at'
        ]);

        if (data.birth_date)
            data.birth_date = new Date(data.birth_date);

        const result = await db.insert_query(req, 'tb_employees', data);
        res.locals.dbResult = result;
        next();
    } 
    catch (err) {
        next(err);
    }
});
router.put('/list/update', async (req, res, next) => {
    try {
        const data = pick(req.body, [
            'id', 'name', 'description', 'employee_code', 'employee_type', 
            'gender', 'birth_date', 'email', 'phone', 'address', 'image_path', 
            'status', 'joined_at', 'resigned_at', 'resigned_desc', 
            'team_id', 'rank_id', 'position_id', 'role_id', 'privilege_id',
            'login_id', 'login_pw', 'is_active', 'deleted_at'
        ]);

        if (data.birth_date)
            data.birth_date = new Date(data.birth_date);

        const result = await db.update_query(req, 'tb_employees', data);
        res.locals.dbResult = result;
        next();
    } 
    catch (err) {
        next(err);
    }
});
router.delete('/list/delete', async (req, res, next) => {
    try {
        const data = pick(req.body, ['id']);
        const result = await db.delete_query(req, 'tb_employees', data);
        res.locals.dbResult = result;
        next();
    } 
    catch (err) {
        next(err);
    }
});

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
            'select_type', 'date', 'employee_id'
        ]);

        if(!('employee_id' in data)) data.employee_id = null;

        switch (data.select_type) {

            case 'day_time': // 일간 근무시간 조회
                {
                    const [rows, fields] = await db.query(req, `CALL p_employee_daytime(?, ?);`, [data.date, data.employee_id]);
                    res.locals.dbResult = rows;
                }
                break;

            case 'week_time': // 주간 근무시간 조회
                {
                    const [rows, fields] = await db.query(req, `CALL p_employee_weektime(?, ?, ?);`, [2400, data.date, data.employee_id]);
                    res.locals.dbResult = rows;
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