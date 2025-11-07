const express = require('express');
const router = express.Router();
const db = require('../services/service_database');

const tb_employee_list = db.tb.employee_list;
router.post('/list/select', async (req, res, next) => db.get(req, res, next, tb_employee_list));
router.post('/list/insert', async (req, res, next) => db.post(req, res, next, tb_employee_list));
router.put('/list/update', async (req, res, next) => db.put(req, res, next, tb_employee_list));
router.delete('/list/delete', async (req, res, next) => db.delete(req, res, next, tb_employee_list));

const tb_employee_leave = db.tb.employee_leave;
router.post('/leave/select', async (req, res, next) => db.get(req, res, next, tb_employee_leave));
router.post('/leave/insert', async (req, res, next) => db.post(req, res, next, tb_employee_leave));
router.put('/leave/update', async (req, res, next) => db.put(req, res, next, tb_employee_leave));
router.delete('/leave/delete', async (req, res, next) => db.delete(req, res, next, tb_employee_leave));

const tb_employee_review = db.tb.employee_review;
router.post('/review/select', async (req, res, next) => db.get(req, res, next, tb_employee_review));
router.post('/review/insert', async (req, res, next) => db.post(req, res, next, tb_employee_review));
router.put('/review/update', async (req, res, next) => db.put(req, res, next, tb_employee_review));
router.delete('/review/delete', async (req, res, next) => db.delete(req, res, next, tb_employee_review));

module.exports = router;