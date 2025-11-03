const express = require('express');
const router = express.Router();
const db = require('../services/service_database');

router.get('/', async (req, res) => {
    try
    {
        res.status(200).json({ message: `None` });;
    } 
    catch (err) 
    {
        res.status(500).json({ message: err.message });
    }
});

module.exports = router;