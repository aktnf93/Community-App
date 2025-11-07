const express = require('express');
const router = express.Router();
const db = require('../services/service_database');

const tb_chat_room = db.tb.chat_room;
router.post('/room/select', async (req, res, next) => db.get(req, res, next, tb_chat_room));
router.post('/room/insert', async (req, res, next) => db.post(req, res, next, tb_chat_room));
router.put('/room/update', async (req, res, next) => db.put(req, res, next, tb_chat_room));
router.delete('/room/delete', async (req, res, next) => db.delete(req, res, next, tb_chat_room));

const tb_chat_member = db.tb.chat_member;
router.post('/member/select', async (req, res, next) => db.get(req, res, next, tb_chat_member));
router.post('/member/insert', async (req, res, next) => db.post(req, res, next, tb_chat_member));
router.put('/member/update', async (req, res, next) => db.put(req, res, next, tb_chat_member));
router.delete('/member/delete', async (req, res, next) => db.delete(req, res, next, tb_chat_member));

const tb_chat_message = db.tb.chat_message;
router.post('/message/select', async (req, res, next) => db.get(req, res, next, tb_chat_message));
router.post('/message/insert', async (req, res, next) => db.post(req, res, next, tb_chat_message));
router.put('/message/update', async (req, res, next) => db.put(req, res, next, tb_chat_message));
router.delete('/message/delete', async (req, res, next) => db.delete(req, res, next, tb_chat_message));

module.exports = router;