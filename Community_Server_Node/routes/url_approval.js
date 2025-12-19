const express = require('express');
const router = express.Router();
const db = require('../services/service_database');


const schema = {
    tb_approval_document: {
        table: 'tb_approval_document',
        get: ['type', 'employee_id', 'status'],
        post: ['type', 'title', 'employee_id', 'status'],
        put: ['type', 'title', 'employee_id', 'status'],
        delete: ['id']
    },
    tb_approval_line: {
        table: 'tb_approval_line',
        get: ['approval_id', 'employee_id'],
        post: ['approval_id', 'employee_id', 'step_order', 'status'],
        put: ['id', 'step_order', 'status'],
        delete: ['id']
    },
    tb_approval_vacation: {
        table: 'tb_approval_vacation',
        get: ['approval_id', 'type', 'start_at', 'end_at'],
        post: ['approval_id', 'type', 'start_at', 'end_at', 'description'],
        put: ['id', 'type', 'start_at', 'end_at', 'description'],
        delete: ['id']
    },
    tb_approval_expense: {
        table: 'tb_approval_expense',
        get: ['approval_id', 'amount', 'payment'],
        post: ['approval_id', 'amount', 'purpose', 'payment'],
        put: ['id', 'amount', 'purpose', 'payment'],
        delete: ['id']
    }
};

const tb_approval_document = schema.tb_approval_document;
router.post('/select', async (req, res, next) => db.get(req, res, next, tb_approval_document));
router.post('/insert', async (req, res, next) => db.post(req, res, next, tb_approval_document));
router.put('/update', async (req, res, next) => db.put(req, res, next, tb_approval_document));
router.delete('/delete', async (req, res, next) => db.delete(req, res, next, tb_approval_document));

const tb_approval_line = schema.tb_approval_line;
router.post('/line/select', async (req, res, next) => db.get(req, res, next, tb_approval_line));
router.post('/line/insert', async (req, res, next) => db.post(req, res, next, tb_approval_line));
router.put('/line/update', async (req, res, next) => db.put(req, res, next, tb_approval_line));
router.delete('/line/delete', async (req, res, next) => db.delete(req, res, next, tb_approval_line));

const tb_approval_vacation = schema.tb_approval_vacation;
router.post('/vacation/select', async (req, res, next) => db.get(req, res, next, tb_approval_vacation));
router.post('/vacation/insert', async (req, res, next) => db.post(req, res, next, tb_approval_vacation));
router.put('/vacation/update', async (req, res, next) => db.put(req, res, next, tb_approval_vacation));
router.delete('/vacation/delete', async (req, res, next) => db.delete(req, res, next, tb_approval_vacation));

const tb_approval_expense = schema.tb_approval_expense;
router.post('/expense/select', async (req, res, next) => db.get(req, res, next, tb_approval_expense));
router.post('/expense/insert', async (req, res, next) => db.post(req, res, next, tb_approval_expense));
router.put('/expense/update', async (req, res, next) => db.put(req, res, next, tb_approval_expense));
router.delete('/expense/delete', async (req, res, next) => db.delete(req, res, next, tb_approval_expense));

module.exports = router;