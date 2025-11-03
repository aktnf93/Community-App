INSERT INTO tb_system_settings 
(id, name, value_number, value_text, description) VALUES 
(@id, @name, @value_number, @value_text, @description);

INSERT INTO tb_system_monitor 
(id, name, value_number, value_text, description, check_interval, checked_at) VALUES 
(@id, @name, @value_number, @value_text, @description, @check_interval, @checked_at);

INSERT INTO tb_system_log_list (id, category, description) VALUES 
(1, 'normal', '테스트 기본 로그'),
(2, 'error', '테스트 에러 로그')
;

INSERT INTO tb_system_logs (log_id) VALUES 
(1)
;

INSERT INTO tb_system_privileges (id, name, description) VALUES 
(1, '게시글', ''), 
(2, '채팅방', ''), 
(3, '프로젝트관리', ''), 
(4, '고객관리', ''), 
(5, '제품관리', ''), 
(6, '직원관리', ''), 
(7, '시스템', '')
;

/* -------------------------------------- */

INSERT INTO tb_posts 
(employee_id, title, content, comments, comment_at) VALUES 
(@employee_id, @title, @content, NULL, NULL);

INSERT INTO tb_post_comments 
(post_id, employee_id, content) VALUES 
(@post_id, @employee_id, @content);

/* -------------------------------------- */

INSERT INTO tb_chat_rooms (name, description, message_at) VALUES (@name, @description, NULL);
INSERT INTO tb_chat_members (chat_room_id, employee_id) VALUES (@chat_room_id, @employee_id);
INSERT INTO tb_chat_messages (chat_member_id, message) VALUES (@chat_member_id, @message);

/* -------------------------------------- */

INSERT INTO tb_projects 
(customer_id, name, description, progress, start_date, end_date, status) VALUES 
(@customer_id, @name, @description, @progress, @start_date, @end_date, @status);
/* status: '대기','진행','완료','취소','보류' */

INSERT INTO tb_project_members 
(project_id, employee_id) VALUES 
(@project_id, @employee_id);

INSERT INTO tb_project_tasks 
(project_id, name, description, progress, start_date, end_date, status) VALUES 
(@project_id, @name, @description, @progress, @start_date, @end_date, @status);
/* status: '대기','진행','완료','취소','보류' */

INSERT INTO tb_project_task_members 
(project_task_id, project_member_id) VALUES 
(@project_task_id, @project_member_id);

/* -------------------------------------- */

INSERT INTO tb_customers 
(location_id, name, description, image_path) VALUES 
(@location_id, @name, @description, @image_path);

INSERT INTO tb_customer_products 
(customer_id, product_id) VALUES 
(@customer_id, @product_id);

/* -------------------------------------- */

INSERT INTO tb_products 
(name, content, description, image_path, total_count) VALUES 
(@name, @content, @description, @image_path, @total_count);

INSERT INTO tb_product_inventory 
(product_id, from_employee_id, to_employee_id, movement_type, movement_count, content) VALUES 
(@product_id, @from_employee_id, @to_employee_id, @movement_type, @movement_count, @content);
/* movement_type: '입고','출고' */

/* -------------------------------------- */

INSERT INTO tb_employees 
(employee_code, name, description, gender, birth_date, email, phone, address, image_path, 
status, joined_at, resigned_at, team_id, rank_id, position_id, role_id) VALUES 
(@employee_code, @name, @description, @gender, @birth_date, @email, @phone, @address, @image_path, 
@status, @joined_at, @resigned_at, @team_id, @rank_id, @position_id, @role_id);
/* gender: '기타','남','여' */
/* status: '재직','휴가','정직','퇴직','대기','계약해지' */

INSERT INTO tb_employee_reviews 
(employee_id, reviewer_id, review_date, review_type, score, description, review_result) VALUES 
(@employee_id, @reviewer_id, @review_date, @review_type, @score, @description, @review_result);
/* review_type: '1차평가','2차평가','최종평가','자기평가','동료평가' */
/* review_result: '매우우수(S)','우수(A)','양호(B)','보통(C)','미흡(D)','부족(E)','미달(F)' */

INSERT INTO tb_employee_leaves 
(employee_id, approver_id, leave_type, start_dt, end_dt, description, leave_result) VALUES 
(@employee_id, @approver_id, @leave_type, @start_dt, @end_dt, @description, @leave_result);
/* leave_type: '연차','병가','무급','출산','육아','특별','대체' */
/* leave_result: '대기','승인','반려','취소','완료' */

INSERT INTO tb_employee_account 
(employee_id, login_id, login_pw, name, description) VALUES 
(@employee_id, @login_id, @login_pw, @name, @description);

INSERT INTO tb_employee_privileges 
(employee_id, privileges_id) VALUES 
(@employee_id, @privileges_id);

/* -------------------------------------- */

INSERT INTO tb_organization_locations (name, description) VALUES (@name, @description);
INSERT INTO tb_organization_companies (location_id, name, description) VALUES (@location_id, @name, @description);
INSERT INTO tb_organization_departments (company_id, name, description) VALUES (@company_id, @name, @description);
INSERT INTO tb_organization_teams (department_id, name, description) VALUES (@department_id, @name, @description);
INSERT INTO tb_organization_ranks (name, description) VALUES (@name, @description);

/* 직책 */
INSERT INTO tb_organization_positions (name, description) VALUES (@name, @description);

/* 역할 */
SELECT r.id, r.name, r.description, r.created_at, r.updated_at, r.is_deleted FROM tb_organization_roles r WHERE 1 = 1;
INSERT INTO tb_organization_roles (name, description) VALUES (@name, @description);
UPDATE tb_organization_roles SET name = @name, description = @description WHERE id = @id;
UPDATE tb_organization_roles SET is_deleted = @is_deleted WHERE id = @id;
DELETE FROM tb_organization_roles WHERE id = @id;












