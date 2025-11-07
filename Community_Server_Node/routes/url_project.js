const express = require('express');
const router = express.Router();
const db = require('../services/service_database');

const tb_project_list = db.tb.project_list;
router.post('/list/select', async (req, res, next) => db.get(req, res, next, tb_project_list));
router.post('/list/insert', async (req, res, next) => db.post(req, res, next, tb_project_list));
router.put('/list/update', async (req, res, next) => db.put(req, res, next, tb_project_list));
router.delete('/list/delete', async (req, res, next) => db.delete(req, res, next, tb_project_list));

const tb_project_member = db.tb.project_member;
router.post('/member/select', async (req, res, next) => db.get(req, res, next, tb_project_member));
router.post('/member/insert', async (req, res, next) => db.post(req, res, next, tb_project_member));
router.put('/member/update', async (req, res, next) => db.put(req, res, next, tb_project_member));
router.delete('/member/delete', async (req, res, next) => db.delete(req, res, next, tb_project_member));

const tb_project_task = db.tb.project_task;
router.post('/task/select', async (req, res, next) => db.get(req, res, next, tb_project_task));
router.post('/task/insert', async (req, res, next) => db.post(req, res, next, tb_project_task));
router.put('/task/update', async (req, res, next) => db.put(req, res, next, tb_project_task));
router.delete('/task/delete', async (req, res, next) => db.delete(req, res, next, tb_project_task));

const tb_project_task_member = db.tb.project_task_member;
router.post('/taskmember/select', async (req, res, next) => db.get(req, res, next, tb_project_task_member));
router.post('/taskmember/insert', async (req, res, next) => db.post(req, res, next, tb_project_task_member));
router.put('/taskmember/update', async (req, res, next) => db.put(req, res, next, tb_project_task_member));
router.delete('/taskmember/delete', async (req, res, next) => db.delete(req, res, next, tb_project_task_member));

module.exports = router;