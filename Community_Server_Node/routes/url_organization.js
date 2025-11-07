const express = require('express');
const router = express.Router();
const db = require('../services/service_database');

const tb_location = db.tb.organization_location;
router.post('/location/select', async (req, res, next) => db.get(req, res, next, tb_location));
router.post('/location/insert', async (req, res, next) => db.post(req, res, next, tb_location));
router.put('/location/update', async (req, res, next) => db.put(req, res, next, tb_location));
router.delete('/location/delete', async (req, res, next) => db.delete(req, res, next, tb_location));

const tb_company = db.tb.organization_company;
router.post('/company/select', async (req, res, next) => db.get(req, res, next, tb_company));
router.post('/company/insert', async (req, res, next) => db.post(req, res, next, tb_company));
router.put('/company/update', async (req, res, next) => db.put(req, res, next, tb_company));
router.delete('/company/delete', async (req, res, next) => db.delete(req, res, next, tb_company));

const tb_department = db.tb.organization_department;
router.post('/department/select', async (req, res, next) => db.get(req, res, next, tb_department));
router.post('/department/insert', async (req, res, next) => db.post(req, res, next, tb_department));
router.put('/department/update', async (req, res, next) => db.put(req, res, next, tb_department));
router.delete('/department/delete', async (req, res, next) => db.delete(req, res, next, tb_department));

const tb_team = db.tb.organization_team;
router.post('/team/select', async (req, res, next) => db.get(req, res, next, tb_team));
router.post('/team/insert', async (req, res, next) => db.post(req, res, next, tb_team));
router.put('/team/update', async (req, res, next) => db.put(req, res, next, tb_team));
router.delete('/team/delete', async (req, res, next) => db.delete(req, res, next, tb_team));

const tb_rank = db.tb.organization_rank;
router.post('/rank/select', async (req, res, next) => db.get(req, res, next, tb_rank));
router.post('/rank/insert', async (req, res, next) => db.post(req, res, next, tb_rank));
router.put('/rank/update', async (req, res, next) => db.put(req, res, next, tb_rank));
router.delete('/rank/delete', async (req, res, next) => db.delete(req, res, next, tb_rank));

const tb_position = db.tb.organization_position;
router.post('/position/select', async (req, res, next) => db.get(req, res, next, tb_position));
router.post('/position/insert', async (req, res, next) => db.post(req, res, next, tb_position));
router.put('/position/update', async (req, res, next) => db.put(req, res, next, tb_position));
router.delete('/position/delete', async (req, res, next) => db.delete(req, res, next, tb_position));

const tb_role = db.tb.organization_role;
router.post('/role/select', async (req, res, next) => db.get(req, res, next, tb_role));
router.post('/role/insert', async (req, res, next) => db.post(req, res, next, tb_role));
router.put('/role/update', async (req, res, next) => db.put(req, res, next, tb_role));
router.delete('/role/delete', async (req, res, next) => db.delete(req, res, next, tb_role));

const tb_organization_privilege = db.tb.organization_privilege;
router.post('/privileg/select', async (req, res, next) => db.get(req, res, next, tb_organization_privilege));
router.post('/privileg/insert', async (req, res, next) => db.post(req, res, next, tb_organization_privilege));
router.put('/privileg/update', async (req, res, next) => db.put(req, res, next, tb_organization_privilege));
router.delete('/privileg/delete', async (req, res, next) => db.delete(req, res, next, tb_organization_privilege));

module.exports = router;