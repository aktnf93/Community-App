const express = require('express');
const router = express.Router();
const db = require('../services/service_database');

const tb_product_list = db.tb.product_list;
router.post('/list/select', async (req, res, next) => db.get(req, res, next, tb_product_list));
router.post('/list/insert', async (req, res, next) => db.post(req, res, next, tb_product_list));
router.put('/list/update', async (req, res, next) => db.put(req, res, next, tb_product_list));
router.delete('/list/delete', async (req, res, next) => db.delete(req, res, next, tb_product_list));

const tb_product_inventory = db.tb.product_inventory;
router.post('/inventory/select', async (req, res, next) => db.get(req, res, next, tb_product_inventory));
router.post('/inventory/insert', async (req, res, next) => db.post(req, res, next, tb_product_inventory));
router.put('/inventory/update', async (req, res, next) => db.put(req, res, next, tb_product_inventory));
router.delete('/inventory/delete', async (req, res, next) => db.delete(req, res, next, tb_product_inventory));

module.exports = router;