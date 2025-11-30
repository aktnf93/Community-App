const db = require('../services/service_database');



const createProject = async (req) => {
    let conn;

    try {
        conn = await db.pool.getConnection();
        await conn.beginTransaction();

        const { project, members, tasks } = req.body;

        //#region Project 생성
        const [result_p] = await conn.query(`
            INSERT INTO tb_projects 
            (customer_id, name, description, progress, start_date, end_date, status) 
            VALUES (?, ?, ?, ?, ?, ?, ?);`, [
                project.customer_id,
                project.name,
                project.description,
                project.progress,
                project.start_date,
                project.end_date,
                project.status
            ]
        );
        //#endregion

        //#region Member 추가
        const projectId = result_p.insertId;

        for (const m of members) {
            
            const [result_m] = await conn.query(`
                INSERT INTO tb_project_members 
                (project_id, employee_id) 
                VALUES (?, ?);`, [
                    projectId, 
                    m.employee_id
                ]
            );
        }
        //#endregion

        //#region task & member 추가
        for (const t of tasks) {

            console.log(t);
            
            const [result_t] = await conn.query(`
                INSERT INTO tb_project_tasks 
                (project_id, task_no, name, description, progress, start_date, end_date, status) 
                VALUES (?, ?, ?, ?, ?, ?, ?, ?);`, [
                    projectId,
                    t.task_no,
                    t.name,
                    t.description,
                    t.progress,
                    t.start_date,
                    t.end_date,
                    t.status
                ]
            );

            //#region task member 추가
            const taskId = result_t.insertId;

            if (t.member !== null) {

                const [result_tm] = await conn.query(`
                    INSERT INTO tb_project_task_members 
                    (project_task_id, employee_id) 
                    VALUES (?, ?);`, [
                        taskId,
                        t.member
                    ]
                );
            }
            //#endregion
        }
        //#endregion

        await conn.commit();
        return projectId;
    } catch (err) {
        await conn.rollback();
        throw err;
    } finally {
        if (conn) conn.release();
    }
};

const deleteProject = async (req) => {
    let conn;

    try {
        conn = await db.pool.getConnection();
        await conn.beginTransaction();

        const { id } = req.body;

        const [result] = await conn.query(`
            DELETE tm, t, m, p
            FROM tb_projects p
                LEFT OUTER JOIN tb_project_members m 		ON m.project_id = p.id
                LEFT OUTER JOIN tb_project_tasks t 			ON t.project_id = p.id
                LEFT OUTER JOIN tb_project_task_members tm 	ON tm.project_task_id = t.id
            WHERE p.id = ?;
            `, [id]
        );

        await conn.commit();
        return result;
    } catch (err) {
        await conn.rollback();
        throw err;
    } finally {
        if (conn) conn.release();
    }
};

module.exports = {
    createProject,
    deleteProject
};