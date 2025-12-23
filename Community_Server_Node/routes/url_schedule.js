const express = require('express');
const router = express.Router();
const db = require('../services/service_database');

const schema = {
    schedule: {
        table: 'tb_schedule',
        get: ['id', 'employee_id', 
            'start_at', 'start_year', 'start_month', 
            'end_at', 'end_year', 'end_month',
            'color_code'],
        post: ['employee_id', 'title', 'start_at', 'end_at', 'color_code'],
        put: ['id', 'title', 'start_at', 'end_at', 'color_code'],
        delete: ['id']
    }
};

const tb_schedule = schema.schedule;
router.post('/select', async (req, res, next) => {
    try {
        const data = db.pick(req.body, ['start_year', 'start_month', 'end_year', 'end_month', 'employee_id']);
        const sqlValues = [];
        let sql = `SELECT * FROM v_schedule WHERE 1=1 `;

        if ('start_year' in data) {
            sqlValues.push(data.start_year);
            sqlValues.push(data.start_month);
            sqlValues.push(data.end_year);
            sqlValues.push(data.end_month);
            sql += ` AND ((start_year = ? AND start_month = ?) OR (end_year = ? AND end_month = ?)) `;
        }

        if ('employee_id' in data) {
            sqlValues.push(data.employee_id);
            sql += ` AND employee_id = ? `;
        }

        const result = await db.query(req, sql, sqlValues);
        res.locals.dbResult = result;
        next();
    } 
    catch (err) {
        next(err);
    }
});
router.post('/insert', async (req, res, next) => db.post(req, res, next, tb_schedule));
router.put('/update', async (req, res, next) => db.put(req, res, next, tb_schedule));
router.delete('/delete', async (req, res, next) => db.delete(req, res, next, tb_schedule));

module.exports = router;