const express = require('express');
const router = express.Router();
const query = require('../../services/service_database');

router.route('/')
    .get(async (req, res, next) => {
        try {
            const sql = `SELECT * FROM tb_organization_companies WHERE 1 = 1 LIMIT 1000;`;
            const [rows] = await query(sql);
            res.status(200).json(rows);
        } 
        catch (err) {
            next(err);
        }
    })
    .post(async (req, res, next) => {
        try {
            const { name, description } = req.body;
            const sql = `INSERT INTO tb_organization_companies (name, description) VALUES (?, ?);`;
            const [result] = await query(sql, [name, description]);
            res.status(200).json(result);
        } 
        catch (err) {
            next(err);
        }
    })
    .put(async (req, res, next) => {
        try {
            const { id, name, description } = req.body;
            const sql = `UPDATE tb_organization_companies SET name = ?, description = ? WHERE id = ?;`;
            const [result] = await query(sql, [name, description, id]);
            res.status(200).json(result);
        } 
        catch (err) {
            next(err);
        }
    })
    .delete(async (req, res, next) => {
        try {
            const { id } = req.body;
            const sql = `DELETE FROM tb_organization_companies WHERE id = ?;`;
            const [result] = await query(sql, [id]);
            res.status(200).json(result);
        } 
        catch (err) {
            next(err);
        }
    });

module.exports = router;