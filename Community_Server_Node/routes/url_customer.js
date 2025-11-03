const express = require('express');
const router = express.Router();
const query = require('../services/service_database');

router.route('/')
    .get(async (req, res, next) => {
        try {
            const sql = `SELECT * FROM tb_customers WHERE 1 = 1 LIMIT 1000;`;
            const [rows] = await query(sql);
            res.status(200).json(rows);
        } 
        catch (err) {
            next(err);
        }
    })
    .post(async (req, res, next) => {
        try {
            const { location_id, name, description, image_path } = req.body;
            const sql = `INSERT INTO tb_customers (location_id, name, description, image_path) VALUES (?, ?, ?, ?);`;
            const [result] = await query(sql, [location_id, name, description, image_path]);
            res.status(200).json(result);
        } 
        catch (err) {
            next(err);
        }
    })
    .put(async (req, res, next) => {
        try {
            const { location_id, name, description, image_path, id } = req.body;
            const sql = `UPDATE tb_customers SET location_id = ?, name = ?, description = ?, image_path = ? WHERE id = ?;`;
            const [result] = await query(sql, [location_id, name, description, image_path, id]);
            res.status(200).json(result);
        } 
        catch (err) {
            next(err);
        }
    })
    .delete(async (req, res, next) => {
        try {
            const { id } = req.body;
            const sql = `DELETE FROM tb_customers WHERE id = ?;`;
            const [result] = await query(sql, [id]);
            res.status(200).json(result);
        } 
        catch (err) {
            next(err);
        }
    });

router.route('/product')
    .get(async (req, res, next) => {
        try {
            const { customer_id } = req.body;
            const sql = `SELECT * FROM tb_customer_products WHERE customer_id = ? LIMIT 1000;`;
            const [rows] = await query(sql, [customer_id]);
            res.status(200).json(rows);
        } 
        catch (err) {
            next(err);
        }
    })
    .post(async (req, res, next) => {
        try {
            const { customer_id, product_id } = req.body;
            const sql = `INSERT INTO tb_customer_products (customer_id, product_id) VALUES (?, ?);`;
            const [result] = await query(sql, [customer_id, product_id]);
            res.status(200).json(result);
        } 
        catch (err) {
            next(err);
        }
    })
    .delete(async (req, res, next) => {
        try {
            const { id } = req.body;
            const sql = `DELETE FROM tb_customer_products WHERE id = ?;`;
            const [result] = await query(sql, [id]);
            res.status(200).json(result);
        } 
        catch (err) {
            next(err);
        }
    });

module.exports = router;