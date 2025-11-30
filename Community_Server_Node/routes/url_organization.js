const express = require('express');
const router = express.Router();
const db = require('../services/service_database');

const schema = {

    organization_location: {
        table: 'tb_organization_locations',
        get: ['id'],
        post: ['name', 'description'],
        put: ['id', 'name', 'description'],
        delete: ['id']
    },

    organization_company: {
        table: 'tb_organization_companies',
        get: ['id'],
        post: ['name', 'description'],
        put: ['id', 'name', 'description'],
        delete: ['id']
    },

    organization_department: {
        table: 'tb_organization_departments',
        get: ['id', 'company_id'],
        post: ['company_id', 'name', 'description'],
        put: ['id', 'name', 'description'],
        delete: ['id']
    },

    organization_team: {
        table: 'tb_organization_teams',
        get: ['id', 'department_id'],
        post: ['department_id', 'name', 'description'],
        put: ['id', 'name', 'description'],
        delete: ['id']
    },

    organization_rank: {
        table: 'tb_organization_ranks',
        get: ['id'],
        post: ['name', 'description'],
        put: ['id', 'name', 'description'],
        delete: ['id']
    },

    organization_position: {
        table: 'tb_organization_positions',
        get: ['id'],
        post: ['name', 'description'],
        put: ['id', 'name', 'description'],
        delete: ['id']
    },

    organization_role: {
        table: 'tb_organization_roles',
        get: ['id'],
        post: ['name', 'description'],
        put: ['id', 'name', 'description'],
        delete: ['id']
    },

    organization_privilege: {
        table: 'tb_organization_privileges',
        get: ['id'],
        post: ['name'],
        put: [
            'id', 'name', 'description',
            'auth_post', 'auth_chat', 
            'auth_project', 'auth_customer', 'auth_product', 'auth_employee',
            'auth_system'
        ],
        delete: ['id']
    }
};


router.post('/team/tree', async (req, res, next) => {
    try {
        const result = await db.query(req, 'SELECT * FROM v_teams WHERE 1 = 1 LIMIT 1000;', []);
        res.locals.dbResult = result;
        
        next();
    } 
    catch (err) {
        next(err);
    }
});

const tb_location = schema.organization_location;
router.post('/location/select', async (req, res, next) => db.get(req, res, next, tb_location));
router.post('/location/insert', async (req, res, next) => db.post(req, res, next, tb_location));
router.put('/location/update', async (req, res, next) => db.put(req, res, next, tb_location));
router.delete('/location/delete', async (req, res, next) => db.delete(req, res, next, tb_location));

const tb_company = schema.organization_company;
router.post('/company/select', async (req, res, next) => db.get(req, res, next, tb_company));
router.post('/company/insert', async (req, res, next) => db.post(req, res, next, tb_company));
router.put('/company/update', async (req, res, next) => db.put(req, res, next, tb_company));
router.delete('/company/delete', async (req, res, next) => db.delete(req, res, next, tb_company));

const tb_department = schema.organization_department;
router.post('/department/select', async (req, res, next) => db.get(req, res, next, tb_department));
router.post('/department/insert', async (req, res, next) => db.post(req, res, next, tb_department));
router.put('/department/update', async (req, res, next) => db.put(req, res, next, tb_department));
router.delete('/department/delete', async (req, res, next) => db.delete(req, res, next, tb_department));

const tb_team = schema.organization_team;
router.post('/team/select', async (req, res, next) => db.get(req, res, next, tb_team));
router.post('/team/insert', async (req, res, next) => db.post(req, res, next, tb_team));
router.put('/team/update', async (req, res, next) => db.put(req, res, next, tb_team));
router.delete('/team/delete', async (req, res, next) => db.delete(req, res, next, tb_team));

const tb_rank = schema.organization_rank;
router.post('/rank/select', async (req, res, next) => db.get(req, res, next, tb_rank));
router.post('/rank/insert', async (req, res, next) => db.post(req, res, next, tb_rank));
router.put('/rank/update', async (req, res, next) => db.put(req, res, next, tb_rank));
router.delete('/rank/delete', async (req, res, next) => db.delete(req, res, next, tb_rank));

const tb_position = schema.organization_position;
router.post('/position/select', async (req, res, next) => db.get(req, res, next, tb_position));
router.post('/position/insert', async (req, res, next) => db.post(req, res, next, tb_position));
router.put('/position/update', async (req, res, next) => db.put(req, res, next, tb_position));
router.delete('/position/delete', async (req, res, next) => db.delete(req, res, next, tb_position));

const tb_role = schema.organization_role;
router.post('/role/select', async (req, res, next) => db.get(req, res, next, tb_role));
router.post('/role/insert', async (req, res, next) => db.post(req, res, next, tb_role));
router.put('/role/update', async (req, res, next) => db.put(req, res, next, tb_role));
router.delete('/role/delete', async (req, res, next) => db.delete(req, res, next, tb_role));

const tb_organization_privilege = schema.organization_privilege;
router.post('/privileg/select', async (req, res, next) => db.get(req, res, next, tb_organization_privilege));
router.post('/privileg/insert', async (req, res, next) => db.post(req, res, next, tb_organization_privilege));
router.put('/privileg/update', async (req, res, next) => db.put(req, res, next, tb_organization_privilege));
router.delete('/privileg/delete', async (req, res, next) => db.delete(req, res, next, tb_organization_privilege));

module.exports = router;