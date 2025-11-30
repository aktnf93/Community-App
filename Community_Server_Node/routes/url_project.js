const express = require('express');
const router = express.Router();
const db = require('../services/service_database');

const pro = require('../repositories/repo_project');

const schema = {

    project_list: {
        table: 'tb_projects',
        get: ['id', 'status'],
        post: ['customer_id', 'name', 'description', 'progress', 'start_date', 'end_date', 'status'],
        put: ['id', 'customer_id', 'name', 'description', 'progress', 'start_date', 'end_date', 'status', 'is_deleted'],
        delete: ['id']
    },

    project_member: {
        table: 'tb_project_members',
        get: ['id', 'project_id', 'employee_id'],
        post: ['project_id', 'employee_id'],
        // put: [],
        delete: ['id']
    },

    project_task: {
        table: 'tb_project_tasks',
        get: ['id', 'project_id', 'status'],
        post: ['task_no', 'project_id', 'name', 'description', 'progress', 'start_date', 'end_date', 'status'],
        put: ['id', 'task_no', 'name', 'description', 'progress', 'start_date', 'end_date', 'status'],
        delete: ['id']
    },

    project_task_member: {
        table: 'tb_project_task_members',
        get: ['id', 'project_task_id'],
        post: ['project_task_id', 'project_member_id'],
        // put: [],
        delete: ['id']
    }
};

const tb_project_list = schema.project_list;
router.post('/list/select', async (req, res, next) => db.get(req, res, next, tb_project_list));

router.post('/list/insert', async (req, res, next) => {
    try {
        const result = await pro.createProject(req)
        res.locals.dbResult = result;
        next();
    } 
    catch (err) {
        next(err);
    }
});

router.put('/list/update', async (req, res, next) => db.put(req, res, next, tb_project_list));

router.delete('/list/delete', async (req, res, next) => {
    try {
        const result = await pro.deleteProject(req)
        res.locals.dbResult = result;
        next();
    } 
    catch (err) {
        next(err);
    }
});


const tb_project_member = schema.project_member;
router.post('/member/select', async (req, res, next) => db.get(req, res, next, tb_project_member));
router.post('/member/insert', async (req, res, next) => db.post(req, res, next, tb_project_member));
router.put('/member/update', async (req, res, next) => db.put(req, res, next, tb_project_member));
router.delete('/member/delete', async (req, res, next) => db.delete(req, res, next, tb_project_member));

const tb_project_task = schema.project_task;
router.post('/task/select', async (req, res, next) => db.get(req, res, next, tb_project_task));
router.post('/task/insert', async (req, res, next) => db.post(req, res, next, tb_project_task));
router.put('/task/update', async (req, res, next) => db.put(req, res, next, tb_project_task));
router.delete('/task/delete', async (req, res, next) => db.delete(req, res, next, tb_project_task));

/*
const tb_project_task_member = schema.project_task_member;
router.post('/taskmember/select', async (req, res, next) => db.get(req, res, next, tb_project_task_member));
router.post('/taskmember/insert', async (req, res, next) => db.post(req, res, next, tb_project_task_member));
router.put('/taskmember/update', async (req, res, next) => db.put(req, res, next, tb_project_task_member));
router.delete('/taskmember/delete', async (req, res, next) => db.delete(req, res, next, tb_project_task_member));
*/
module.exports = router;