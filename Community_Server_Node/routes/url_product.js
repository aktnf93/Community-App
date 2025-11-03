const express = require('express');
const router = express.Router();
const query = require('../services/service_database');

router.route('/')
    .get(async (req, res) => {
        try {
            const sql = `SELECT * FROM tb_products WHERE 1 = 1 LIMIT 1000;`;
            const [rows] = await query(sql);

            res.status(200).json(rows);
        } 
        catch (err) {
            res.status(500).json({ message: err.message });
        }
    })
    .post(async (req, res) => {
        try {
            const { name, content, description, image_path, total_count } = req.body;

            const sql = `INSERT INTO tb_products (name, content, description, image_path, total_count) VALUES (?, ?, ?, ?, ?);`;
            const [result] = await query(sql, [name, content, description, image_path, total_count]);

            res.status(200).json(result.insertId);
        } 
        catch (err) {
            res.status(500).json({ message: err.message });
        }
    })
    .put(async (req, res) => {
        try {
            const { name, content, description, image_path, total_count, id } = req.body;

            const sql = `UPDATE tb_products SET name = ?, content = ?, description = ?, image_path = ?, total_count = ? WHERE id = ?;`;
            const [result] = await query(sql, [name, content, description, image_path, total_count, id]);

            res.status(200).json(result.changedRows);
        } 
        catch (err) {
            res.status(500).json({ message: err.message });
        }
    })
    .delete(async (req, res) => {
        try {
            const { id } = req.body;

            const sql = `DELETE FROM tb_products WHERE id = ?;`;
            const [result] = await query(sql, [id]);

            res.status(200).json(result.affectedRows);
        } 
        catch (err) {
            res.status(500).json({ message: err.message });
        }
    });

router.route('/inventory')
    .get(async (req, res) => {
        try {
            const { id } = req.body;

            const sql = `SELECT * FROM tb_product_inventory WHERE id = ? LIMIT 1000;`;
            const [rows] = await query(sql, [id]);

            res.status(200).json(rows);
        } 
        catch (err) {
            res.status(500).json({ message: err.message });
        }
    })
    .post(async (req, res) => {
        try {
            const { product_id, from_employee_id, to_employee_id, movement_type, movement_count, content } = req.body;

            const sql = `INSERT INTO tb_product_inventory (product_id, from_employee_id, to_employee_id, movement_type, movement_count, content) VALUES (?, ?, ?, ?, ?, ?);`;
            const [result] = await query(sql, [product_id, from_employee_id, to_employee_id, movement_type, movement_count, content]);

            res.status(200).json(result.insertId);
        } 
        catch (err) {
            res.status(500).json({ message: err.message });
        }
    })
    .put(async (req, res) => {
        try {
            const { product_id, from_employee_id, to_employee_id, movement_type, movement_count, content, id } = req.body;

            const sql = `UPDATE tb_product_inventory SET product_id = ?, from_employee_id = ?, to_employee_id = ?, movement_type = ?, movement_count = ?, content = ? WHERE id = ?;`;
            const [result] = await query(sql, [product_id, from_employee_id, to_employee_id, movement_type, movement_count, content, id]);

            res.status(200).json(result.changedRows);
        } 
        catch (err) {
            res.status(500).json({ message: err.message });
        }
    })
    .delete(async (req, res) => {
        try {
            const { id } = req.body;

            const sql = `DELETE FROM tb_product_inventory WHERE id = ?;`;
            const [result] = await query(sql, [id]);

            res.status(200).json(result.affectedRows);
        } 
        catch (err) {
            res.status(500).json({ message: err.message });
        }
    });

module.exports = router;