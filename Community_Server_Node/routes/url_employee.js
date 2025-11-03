const express = require('express');
const router = express.Router();
const query = require('../services/service_database');



router.route('/')
    .get(async (req, res, next) => {
        try {
            const { id } = req.body;

            const sql = `SELECT * FROM tb_employees WHERE id = ? LIMIT 1000;`;

            const [rows] = await query(sql, [id]);
            res.status(200).json(rows);
        } 
        catch (err) {
            next(err);
        }
    })
    .post(async (req, res, next) => {
        try {
            const data = { 
                name, description, employee_code, 
                gender, birth_date, email, phone, address, image_path, 
                status, joined_at, resigned_at, team_id, rank_id, position_id, role_id, login_id, login_pw, is_active 
            } = req.body;

            // ******************************************
            const columns = Object.keys(data);
            const sql_columns = columns.join(', ');                     // ['id', 'name', 'remark']
            const sql_placeholders = columns.map(() => '?').join(', '); // ['?', '?', '?']
            const sql_values = columns.map(col => data[col]);           // [1, 'Alice', 'hello']

            const sql = `INSERT INTO tb_employees (${sql_columns}) VALUES (${sql_placeholders})`;
            // ******************************************

            const [result] = await query(sql, sql_values);
            res.status(200).json(result);
        } 
        catch (err) {
            next(err);
        }
    })
    .put(async (req, res, next) => {
        try {
            const data = { 
                employee_code, name, description, 
                gender, birth_date, email, phone, address, image_path, 
                status, joined_at, resigned_at, team_id, rank_id, position_id, role_id, login_id, login_pw, is_active, 
                id 
            } = req.body;

            // ******************************************
            const columns = Object.keys(data); // ['name', 'remark']
            const sql_set = columns.map(col => `${col} = ?`).join(', '); // 'name = ?, remark = ?'
            const sql_values = columns.map(col => data[col]); // ['Alice', 'hello']

            const sql = `UPDATE tb_employees SET ${sql_set} WHERE id = ?`;
            sql_values.push(data.id); // 마지막에 WHERE 조건 값 추가
            // ******************************************

            const [result] = await query(sql, sql_values);
            res.status(200).json(result);
        } 
        catch (err) {
            next(err);
        }
    })
    .delete(async (req, res, next) => {
        try {
            const { id } = req.body;

            const sql = `DELETE FROM tb_employees WHERE id = ?;`;
            const [result] = await query(sql, [id]);

            res.status(200).json(result);
        } 
        catch (err) {
            next(err);
        }
    });

// _______________________________________________________________________________

router.route('/review')
    .get(async (req, res, next) => {
        try {
            const { employee_id } = req.body;

            const sql = `SELECT * FROM tb_employee_reviews WHERE employee_id = ? LIMIT 1000;`;

            const [rows] = await query(sql, [employee_id]);
            res.status(200).json(rows);
        } 
        catch (err) {
            next(err);
        }
    })
    .post(async (req, res, next) => {
        try {
            const { employee_id, reviewer_id, review_date, review_type, score, description, review_result } = req.body;

            const sql = `
            INSERT INTO tb_employee_reviews 
            (employee_id, reviewer_id, review_date, review_type, score, description, review_result) 
            VALUES (?, ?, ?, ?, ?, ?, ?);`;
            const [result] = await query(sql, 
                [employee_id, reviewer_id, review_date, review_type, score, description, review_result]);

            res.status(200).json(result);
        } 
        catch (err) {
            next(err);
        }
    })
    .put(async (req, res, next) => {
        try {
            const { employee_id, reviewer_id, review_date, review_type, score, description, review_result, id } = req.body;

            const sql = `
                UPDATE tb_employee_reviews 
                SET employee_id = ?, reviewer_id = ?, review_date = ?, review_type = ?, score = ?, description = ?, review_result = ?
                WHERE id = ?;`;
            const [result] = await query(sql, 
                [employee_id, reviewer_id, review_date, review_type, score, description, review_result, id]);

            res.status(200).json(result);
        } 
        catch (err) {
            next(err);
        }
    })
    .delete(async (req, res, next) => {
        try {
            const { id } = req.body;

            const sql = `DELETE FROM tb_employee_reviews WHERE id = ?;`;
            const [result] = await query(sql, [id]);

            res.status(200).json(result);
        } 
        catch (err) {
            next(err);
        }
    });

// _______________________________________________________________________________

router.route('/leave')
    .get(async (req, res, next) => {
        try {
            const { employee_id } = req.body;

            const sql = `SELECT * FROM tb_employee_leaves WHERE employee_id = ? LIMIT 1000;`;

            const [rows] = await query(sql, [employee_id]);
            res.status(200).json(rows);
        } 
        catch (err) {
            next(err);
        }
    })
    .post(async (req, res, next) => {
        try {
            const { employee_id, approver_id, leave_type, start_dt, end_dt, description, leave_result } = req.body;

            const sql = `
                INSERT INTO tb_employee_leaves 
                (employee_id, approver_id, leave_type, start_dt, end_dt, description, leave_result) 
                VALUES (?, ?, ?, ?, ?, ?, ?);`;
            const [result] = await query(sql, 
                [employee_id, approver_id, leave_type, start_dt, end_dt, description, leave_result]);

            res.status(200).json(result);
        } 
        catch (err) {
            next(err);
        }
    })
    .put(async (req, res, next) => {
        try {
            const { id, employee_id, approver_id, leave_type, start_dt, end_dt, description, leave_result } = req.body;

            const sql = `
                UPDATE tb_employee_leaves 
                SET employee_id = ?, approver_id = ?, leave_type = ?, start_dt = ?, end_dt = ?, description = ?, leave_result = ?
                WHERE id = ?;`;
            const [result] = await query(sql, 
                [employee_id, approver_id, leave_type, start_dt, end_dt, description, leave_result, id]);

            res.status(200).json(result);
        } 
        catch (err) {
            next(err);
        }
    })
    .delete(async (req, res, next) => {
        try {
            const { id } = req.body;

            const sql = `DELETE FROM tb_employee_leaves WHERE id = ?;`;
            const [result] = await query(sql, [id]);

            res.status(200).json(result);
        } 
        catch (err) {
            next(err);
        }
    });

// _______________________________________________________________________________

router.route('/privilege')
    .get(async (req, res, next) => {
        try {
            const { employee_id } = req.body;

            const sql = `SELECT * FROM tb_employee_privileges WHERE employee_id = ? LIMIT 1000;`;
            const [rows] = await query(sql, [employee_id]);

            res.status(200).json(rows);
        } 
        catch (err) {
            next(err);
        }
    })
    .post(async (req, res, next) => {
        try {
            const { employee_id, privileges_id } = req.body;

            const sql = `INSERT INTO tb_employee_privileges (employee_id, privileges_id) VALUES (?, ?);`;
            const [result] = await query(sql, [employee_id, privileges_id]);

            res.status(200).json(result);
        } 
        catch (err) {
            next(err);
        }
    })
    .put(async (req, res, next) => {
        try {
            const { id, is_allowed, is_deleted } = req.body;

            const sql = `UPDATE tb_employee_privileges SET is_allowed = ?, is_deleted = ? WHERE id = ?;`;
            const [result] = await query(sql, [is_allowed, is_deleted, id]);

            res.status(200).json(result);
        } 
        catch (err) {
            next(err);
        }
    })
    .delete(async (req, res, next) => {
        try {
            const { id } = req.body;

            const sql = `DELETE FROM tb_employee_privileges WHERE id = ?;`;
            const [result] = await query(sql, [id]);

            res.status(200).json(result);
        } 
        catch (err) {
            next(err);
        }
    });

module.exports = router;