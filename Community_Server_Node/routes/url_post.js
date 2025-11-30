const express = require('express');
const router = express.Router();
const db = require('../services/service_database');

const schema = {

    post_category: {
        table: 'tb_post_category',
        view: 'tb_post_category',
        get: ['id'],
        post: ['parent_id', 'name', 'description'],
        put: ['id', 'parent_id', 'name', 'description'],
        delete: ['id']
    },

    post_list: {
        table: 'tb_posts',
        view: 'v_posts',
        get: ['id', 'post_category_id', 'employee_id'],
        post: ['post_category_id', 'employee_id', 'title', 'content'],
        put: ['id', 'post_category_id', 'title', 'content', 'view_count', 'deleted_at'],
        delete: ['id']
    },

    post_comment: {
        table: 'tb_post_comments',
        get: ['id', 'post_id', 'employee_id'],
        post: ['post_id', 'employee_id', 'content'],
        put: ['id', 'content', 'deleted_at'],
        delete: ['id']
    }
};

const tb_post_category = schema.post_category;
router.post('/category/select', async (req, res, next) => {
    try {
        const data = db.pick(req.body, [ 'name' ]);

        if(data.name) {
            data.name = `%${data.name}%`;
            const result = await db.query(req, `
                SELECT * 
                FROM tb_post_category 
                WHERE id IN (
                    SELECT id FROM tb_post_category WHERE name like ?
                    UNION
                    SELECT parent_id FROM tb_post_category WHERE name like ?
                );`, [data.name, data.name]);
            res.locals.dbResult = result;
        }
        else {
            const result = await db.query(req, 'select * from tb_post_category where 1 = 1;', data);
            res.locals.dbResult = result;
        }
        
        next();
    } 
    catch (err) {
        next(err);
    }
});
router.post('/category/insert', async (req, res, next) => db.post(req, res, next, tb_post_category));
router.put('/category/update', async (req, res, next) => db.put(req, res, next, tb_post_category));
router.delete('/category/delete', async (req, res, next) => db.delete(req, res, next, tb_post_category));

const tb_post_list = schema.post_list;
router.post('/list/select', async (req, res, next) => {
    try {
        const data = db.pick(req.body, ['id', 'post_category_id', 'employee_id', 'title', 'content']);

        if (data.title) {
            const result = await db.query(req, `
                SELECT * 
                FROM v_posts p 
                WHERE (p.post_category_id = ? OR p.parent_id = ?) AND p.title like ? 
                ORDER BY p.created_at desc;`, [data.post_category_id, data.post_category_id, `%${data.title}%`]);
            res.locals.dbResult = result;
        }
        else if (data.content) {
            const result = await db.query(req, `
                SELECT * 
                FROM v_posts p 
                WHERE (p.post_category_id = ? OR p.parent_id = ?) AND p.content like ? 
                ORDER BY p.created_at desc;`, [data.post_category_id, data.post_category_id, `%${data.content}%`]);
            res.locals.dbResult = result;
        }
        else {
            const result = await db.query(req, `
                SELECT * 
                FROM v_posts p 
                WHERE p.post_category_id = ? OR p.parent_id = ? 
                ORDER BY p.created_at desc;`, 
                [data.post_category_id, data.post_category_id]);
            res.locals.dbResult = result;
        }
        
        next();
    } 
    catch (err) {
        next(err);
    }
});
router.post('/list/insert', async (req, res, next) => db.post(req, res, next, tb_post_list));
router.put('/list/update', async (req, res, next) => db.put(req, res, next, tb_post_list));
router.delete('/list/delete', async (req, res, next) => db.delete(req, res, next, tb_post_list));

const tb_post_comment = schema.post_comment;
router.post('/comment/select', async (req, res, next) => {
    try {
        const data = db.pick(req.body, ['post_id']);

        if (data.post_id) {
            const result = await db.query(req, `SELECT * FROM v_comments WHERE post_id = ? LIMIT 1000;`, [data.post_id]);
            res.locals.dbResult = result;   
        }

        next();
    } 
    catch (err) {
        next(err);
    }
});
router.post('/comment/insert', async (req, res, next) => db.post(req, res, next, tb_post_comment));
router.put('/comment/update', async (req, res, next) => db.put(req, res, next, tb_post_comment));
router.delete('/comment/delete', async (req, res, next) => db.delete(req, res, next, tb_post_comment));

module.exports = router;