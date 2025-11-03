const express = require('express');
const router = express.Router();
const query = require('../services/service_database');

router.get('/leave', async (req, res) => {
    try {
        const { employee_id } = req.body;

        const sql = `SELECT * FROM tb_employee_leaves WHERE employee_id = ? LIMIT 1000;`;
        const [rows] = await query(sql, [employee_id]);

        res.status(200).json(rows);
    } 
    catch (err) {
        res.status(500).json({ message: err.message });
    }
});

module.exports = router;