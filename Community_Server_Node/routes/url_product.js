const express = require('express');
const router = express.Router();
const db = require('../services/service_database');

const schema = {

    product_list: {
        table: 'tb_products',
        get: ['id'],
        post: ['name', 'content', 'description', 'image_path', 'total_count'],
        put: ['id', 'name', 'content', 'description', 'image_path', 'total_count', 'is_deleted'],
        delete: ['id']
    },

    product_inventory: {
        table: 'tb_product_inventory',
        get: ['id', 'product_id', 'from_employee_id', 'to_employee_id'],
        post: ['product_id', 'from_employee_id', 'to_employee_id', 'movement_type', 'movement_count', 'content'],
        put: ['id', 'product_id', 'from_employee_id', 'to_employee_id', 'movement_type', 'movement_count', 'content'],
        delete: ['id']
    }
};

const tb_product_list = schema.product_list;
router.post('/list/select', async (req, res, next) => db.get(req, res, next, tb_product_list));
router.post('/list/insert', async (req, res, next) => db.post(req, res, next, tb_product_list));
router.put('/list/update', async (req, res, next) => db.put(req, res, next, tb_product_list));
router.delete('/list/delete', async (req, res, next) => db.delete(req, res, next, tb_product_list));

const tb_product_inventory = schema.product_inventory;
router.post('/inventory/select', async (req, res, next) => db.get(req, res, next, tb_product_inventory));
router.post('/inventory/insert', async (req, res, next) => db.post(req, res, next, tb_product_inventory));
router.put('/inventory/update', async (req, res, next) => db.put(req, res, next, tb_product_inventory));
router.delete('/inventory/delete', async (req, res, next) => db.delete(req, res, next, tb_product_inventory));

module.exports = router;