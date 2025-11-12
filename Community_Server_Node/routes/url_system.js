const express = require('express');
const router = express.Router();
const db = require('../services/service_database');


const tb_system_config = db.tb.system_config;
router.post('/config/select', async (req, res, next) => {
    try {
        const data = []; // db.pick(req.body, tb.get);
        const result = await db.query(req, 'select * from tb_system_config where 1 = 1;', data);
        res.locals.dbResult = result;
        next();
    } 
    catch (err) {
        next(err);
    }
});


// router.post('/config/insert', async (req, res, next) => db.post(req, res, next, tb_system_config));
router.put('/config/update', async (req, res, next) => db.put(req, res, next, tb_system_config));
// router.delete('/config/delete', async (req, res, next) => db.delete(req, res, next, tb_system_config));

const tb_system_log = db.tb.system_log;
router.post('/log/select', async (req, res, next) => db.get(req, res, next, tb_system_log));
router.post('/log/insert', async (req, res, next) => db.post(req, res, next, tb_system_log));
// router.put('/log/update', async (req, res, next) => db.put(req, res, next, tb_system_log));
// router.delete('/log/delete', async (req, res, next) => db.delete(req, res, next, tb_system_log));

module.exports = router;