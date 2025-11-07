const express = require('express');
const router = express.Router();
const db = require('../services/service_database');

const tb_customer_list = db.tb.customer_list;
router.post('/list/select', async (req, res, next) => db.get(req, res, next, tb_customer_list));
router.post('/list/insert', async (req, res, next) => db.post(req, res, next, tb_customer_list));
router.put('/list/update', async (req, res, next) => db.put(req, res, next, tb_customer_list));
router.delete('/list/delete', async (req, res, next) => db.delete(req, res, next, tb_customer_list));

const tb_customer_product = db.tb.customer_product;
router.post('/product/select', async (req, res, next) => db.get(req, res, next, tb_customer_product));
router.post('/product/insert', async (req, res, next) => db.post(req, res, next, tb_customer_product));
router.put('/product/update', async (req, res, next) => db.put(req, res, next, tb_customer_product));
router.delete('/product/delete', async (req, res, next) => db.delete(req, res, next, tb_customer_product));

module.exports = router;