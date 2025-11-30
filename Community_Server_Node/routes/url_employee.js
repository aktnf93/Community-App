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

module.exports = router;