const express = require('express');
const router = express.Router();
const db = require('../services/service_database');

const tb_post_list = db.tb.post_list;
router.post('/list/select', async (req, res, next) => db.get(req, res, next, tb_post_list));
router.post('/list/insert', async (req, res, next) => db.post(req, res, next, tb_post_list));
router.put('/list/update', async (req, res, next) => db.put(req, res, next, tb_post_list));
router.delete('/list/delete', async (req, res, next) => db.delete(req, res, next, tb_post_list));

const tb_post_comment = db.tb.post_comment;
router.post('/comment/select', async (req, res, next) => db.get(req, res, next, tb_post_comment));
router.post('/comment/insert', async (req, res, next) => db.post(req, res, next, tb_post_comment));
router.put('/comment/update', async (req, res, next) => db.put(req, res, next, tb_post_comment));
router.delete('/comment/delete', async (req, res, next) => db.delete(req, res, next, tb_post_comment));

module.exports = router;