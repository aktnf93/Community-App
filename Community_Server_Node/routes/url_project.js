const express = require('express');
const router = express.Router();
const query = require('../services/service_database');

router.route('/')
    .get(async (req, res) => {
        try {
            const sql = `SELECT * FROM tb_customers WHERE 1 = 1 LIMIT 1000;`;
            const [rows] = await query(sql);

            res.status(200).json(rows);
        } 
        catch (err) {
            res.status(500).json({ message: err.message });
        }
    })
    .post(async (req, res) => {
        try {
            const { location_id, name, description, image_path } = req.body;

            const sql = `INSERT INTO tb_customers (location_id, name, description, image_path) VALUES (?, ?, ?, ?);`;
            const [result] = await query(sql, [location_id, name, description, image_path]);

            res.status(200).json(result.insertId);
        } 
        catch (err) {
            res.status(500).json({ message: err.message });
        }
    })
    .put(async (req, res) => {
        try {
            const { location_id, name, description, image_path, id } = req.body;

            const sql = `UPDATE tb_customers SET location_id = ?, name = ?, description = ?, image_path = ? WHERE id = ?;`;
            const [result] = await query(sql, [location_id, name, description, image_path, id]);

            res.status(200).json(result.changedRows);
        } 
        catch (err) {
            res.status(500).json({ message: err.message });
        }
    })
    .delete(async (req, res) => {
        try {
            const { id } = req.body;

            const sql = `DELETE FROM tb_customers WHERE id = ?;`;
            const [result] = await query(sql, [id]);

            res.status(200).json(result.affectedRows);
        } 
        catch (err) {
            res.status(500).json({ message: err.message });
        }
    });

module.exports = router;