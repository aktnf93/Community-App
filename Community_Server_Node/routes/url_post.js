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
        const data = db.pick(req.body, [ 'select_type', 'parent_id' ]);

        console.log(req.body);

        switch (data.select_type)
        {
            default: // 전체 조회
                {
                    const sql = 'select * from v_category WHERE 1 = 1;';
                    const result = await db.query(req, sql, []);
                    res.locals.dbResult = result;
                }
                break;

            case 'parent': // 부모 요소만 조회
                {
                    const sql = 'select * from tb_post_category c WHERE c.parent_id IS NULL';
                    const result = await db.query(req, sql, []);
                    res.locals.dbResult = result;
                }
                break;

            case 'child': // 부모 id에 맞는 자식 요소만 조회
                {
                    const sql = 'select * from tb_post_category c WHERE c.parent_id = ?;';
                    const result = await db.query(req, sql, [data.parent_id]);
                    res.locals.dbResult = result;
                }
                break;
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
        const data = db.pick(req.body, [
            // 게시판 메뉴
            'post_category_id', 'title', 'content', 'limit', 'page', 
            
            // 홈 대시보드
            'post_level', 'post_level_operator'
        ]);

        let sql = `SELECT * FROM v_posts p WHERE 1 = 1 `;
        let params = [];
        
        if (data.post_category_id) {
            sql += ` AND (p.post_category_id = ? OR p.parent_id = ?) `;
            params.push(data.post_category_id, data.post_category_id);
        }
        
        if (data.title) {
            sql += ` AND p.title LIKE ? `;
            params.push(`%${data.title}%`);
        }
        
        if (data.content) {
            sql += ` AND p.content LIKE ? `;
            params.push(`%${data.content}%`);
        }

        if ('post_level' in data && 'post_level_operator' in data) {
            if (data.post_level_operator) {
                sql += ` AND p.post_level = ? `;
            }
            else {
                sql += ` AND p.post_level != ? OR p.post_level IS NULL `;
            }

            
            params.push(data.post_level);
        }
        
        sql += ` ORDER BY p.created_at DESC `;
        
        if (data.limit) {
            sql += ` LIMIT ? `;
            params.push(Number(data.limit));
            
            if (data.page) {
                sql += ` OFFSET ? `;
                params.push(Number(data.page) * Number(data.limit));
            }
        }

        const result = await db.query(req, sql, params);
        res.locals.dbResult = result;

        next();
    } catch (err) {
        next(err);
    }
});
router.post('/list/insert', async (req, res, next) => {
    try {
        const data = db.pick(req.body, ['post_category_id', 'employee_id', 'title', 'content', 'post_level']);
        const result = await db.insert_query(req, 'tb_posts', data);
        res.locals.dbResult = result;
        next();
    } 
    catch (err) {
        next(err);
    }
});
router.put('/list/update', async (req, res, next) => {
    try {

        const data = db.pick(req.body, ['id', 'post_category_id', 'title', 'content', 'view_count', 'post_level', 'deleted_at']);
        console.log(req.body);
        let sql = `UPDATE tb_posts SET `;
        let params = [];
        let params_count = 0;

        if (data.post_category_id) {
            sql += (params_count > 0) ? `,` : ``;
            sql += ` post_category_id = ? `;
            params_count++;
            params.push(data.post_category_id);
        }

        if (data.title) {
            sql += (params_count > 0) ? `,` : ``;
            sql += ` title = ? `;
            params_count++;
            params.push(data.title);
        }

        if (data.content) {
            sql += (params_count > 0) ? `,` : ``;
            sql += ` content = ? `;
            params_count++;
            params.push(data.content);
        }

        if (data.view_count) {
            sql += (params_count > 0) ? `,` : ``;
            sql += ` view_count = view_count + ? `;
            params_count++;
            params.push(data.view_count);
        }

        if ('post_level' in data) {
            sql += (params_count > 0) ? `,` : ``;
            sql += ` post_level = ? `;
            params_count++;
            params.push(data.post_level);
        }

        if (data.deleted_at) {
            sql += (params_count > 0) ? `,` : ``;
            sql += ` deleted_at = ? `;
            params_count++;
            params.push(data.deleted_at);
        }

        sql += ` WHERE `;

        if (data.id) {
            sql += ` id = ? `;
            params.push(data.id);
        }


        sql += `;`;
        const result = await db.query(req, sql, params);
        res.locals.dbResult = result;

        next();
    } catch (err) {
        next(err);
    }
});
router.delete('/list/delete', async (req, res, next) => {
    try {
        const data = pick(req.body, ['id']);
        const result = await delete_query(req, 'tb_posts', data);
        res.locals.dbResult = result;
        next();
    } 
    catch (err) {
        next(err);
    }
});

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