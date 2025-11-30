const express = require('express');
const router = express.Router();
const db = require('../services/service_database');

const schema = {

    chat_room: {
        table: 'tb_chat_rooms',
        get: ['id'],
        post: ['name', 'description'],
        put: ['id', 'name', 'description', 'is_deleted'],
        delete: ['id']
    },

    chat_member: {
        table: 'tb_chat_members',
        get: ['id', 'chat_room_id', 'employee_id'],
        post: ['chat_room_id', 'employee_id'],
        put: ['id', 'is_deleted'],
        delete: ['id']
    },

    chat_message: {
        table: 'tb_chat_messages',
        get: ['id', 'chat_member_id'],
        post: ['chat_member_id', 'message'],
        put: ['id', 'is_deleted'],
        delete: ['id']
    }
};

const tb_chat_room = schema.chat_room;
router.post('/room/select', async (req, res, next) => db.get(req, res, next, tb_chat_room));
router.post('/room/insert', async (req, res, next) => db.post(req, res, next, tb_chat_room));
router.put('/room/update', async (req, res, next) => db.put(req, res, next, tb_chat_room));
router.delete('/room/delete', async (req, res, next) => db.delete(req, res, next, tb_chat_room));

/*
const tb_chat_member = schema.chat_member;
router.post('/member/select', async (req, res, next) => db.get(req, res, next, tb_chat_member));
router.post('/member/insert', async (req, res, next) => db.post(req, res, next, tb_chat_member));
router.put('/member/update', async (req, res, next) => db.put(req, res, next, tb_chat_member));
router.delete('/member/delete', async (req, res, next) => db.delete(req, res, next, tb_chat_member));

const tb_chat_message = schema.chat_message;
router.post('/message/select', async (req, res, next) => db.get(req, res, next, tb_chat_message));
router.post('/message/insert', async (req, res, next) => db.post(req, res, next, tb_chat_message));
router.put('/message/update', async (req, res, next) => db.put(req, res, next, tb_chat_message));
router.delete('/message/delete', async (req, res, next) => db.delete(req, res, next, tb_chat_message));
*/

module.exports = router;