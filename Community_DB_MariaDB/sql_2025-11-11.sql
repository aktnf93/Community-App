/* 
SET AUTOCOMMIT=1;
START TRANSACTION;
COMMIT;
SET AUTOCOMMIT=0;

SELECT version();
SELECT @@autocommit
SHOW PLUGINS;

SET FOREIGN_KEY_CHECKS = 1;
CALL p_comment_board(1);
CALL p_board_range(1, 3);
CALL p_user_select('Admin987', 'Admin987');

SELECT * FROM tb_board b LEFT OUTER JOIN tb_user u    ON b.user_id = u.id
WHERE 1 = 1
ORDER BY b.create_dt DESC 
LIMIT 10 OFFSET 10;

SHOW VARIABLES LIKE 'character_set%';
SHOW TABLE STATUS LIKE 'tb_organization_roles';
SHOW FULL COLUMNS FROM tb_organization_roles;

SHOW COLUMNS FROM tb_chat_rooms;

SELECT 
	TABLE_NAME AS 'table', 
	COLUMN_NAME AS 'column'
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'community';

*/