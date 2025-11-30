const express = require('express');
const router = express.Router();
const db = require('../services/service_database');

const schema = {

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
    }
};

const tb_system_config = schema.system_config;
router.post('/config/select', async (req, res, next) => db.post(req, res, next, tb_system_config));
// router.post('/config/insert', async (req, res, next) => db.post(req, res, next, tb_system_config));
router.put('/config/update', async (req, res, next) => db.put(req, res, next, tb_system_config));
// router.delete('/config/delete', async (req, res, next) => db.delete(req, res, next, tb_system_config));

const tb_system_log = schema.system_log;
router.post('/log/select', async (req, res, next) => db.get(req, res, next, tb_system_log));
router.post('/log/insert', async (req, res, next) => db.post(req, res, next, tb_system_log));
// router.put('/log/update', async (req, res, next) => db.put(req, res, next, tb_system_log));
// router.delete('/log/delete', async (req, res, next) => db.delete(req, res, next, tb_system_log));

module.exports = router;