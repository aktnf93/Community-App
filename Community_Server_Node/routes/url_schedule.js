const express = require('express');
const router = express.Router();
const db = require('../services/service_database');

const schema = {
    schedule: {
        table: 'tb_schedule',
        get: ['id', 'employee_id', 'start_at', 'end_at', 'color_code'],
        post: ['employee_id', 'title', 'description', 'start_at', 'end_at', 'color_code'],
        put: ['id', 'title', 'description', 'start_at', 'end_at', 'color_code'],
        delete: ['id']
    }
};

const tb_schedule = schema.schedule;
router.post('/select', async (req, res, next) => db.get(req, res, next, tb_schedule));
router.post('/insert', async (req, res, next) => db.post(req, res, next, tb_schedule));
router.put('/update', async (req, res, next) => db.put(req, res, next, tb_schedule));
router.delete('/delete', async (req, res, next) => db.delete(req, res, next, tb_schedule));