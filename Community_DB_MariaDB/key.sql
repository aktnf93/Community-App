/* CREATE INDEX NAME ON TABLE (FIELD, FIELD, ...); */
/* CREATE UNIQUE INDEX NAME ON TABLE (FIELD, FIELD, ...); */
/* CREATE INDEX `tb_posts_index_0` ON `tb_posts` (`employee_id`); */

PRIMARY KEY(`id`), 
INDEX `log_code` (`log_code`)
NOT NULL DEFAULT current_timestamp(),


CREATE INDEX `tb_posts_index_0` ON `tb_posts` (`employee_id`);
CREATE UNIQUE INDEX `tb_employee_permissions_index_0` ON `tb_employee_permissions` (`employee_id`, `permissions_id`);

ALTER TABLE `tb_organization_companies` 	ADD FOREIGN KEY(`location_id`) 		REFERENCES `tb_organization_locations`(`id`)	ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE `tb_organization_departments` 	ADD FOREIGN KEY(`company_id`) 		REFERENCES `tb_organization_companies`(`id`)	ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `tb_employees` 					ADD FOREIGN KEY(`department_id`) 	REFERENCES `tb_organization_departments`(`id`)	ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE `tb_employees` 					ADD FOREIGN KEY(`team_id`) 			REFERENCES `tb_organization_teams`(`id`)		ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE `tb_employees` 					ADD FOREIGN KEY(`rank_id`) 			REFERENCES `tb_organization_ranks`(`id`)		ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE `tb_employees` 					ADD FOREIGN KEY(`position_id`) 		REFERENCES `tb_organization_positions`(`id`)	ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE `tb_employees` 					ADD FOREIGN KEY(`role_id`) 			REFERENCES `tb_organization_roles`(`id`)		ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE `tb_employee_reviews` 			ADD FOREIGN KEY(`employee_id`) 		REFERENCES `tb_employees`(`id`)					ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE `tb_employee_reviews` 			ADD FOREIGN KEY(`reviewer_id`) 		REFERENCES `tb_employees`(`id`)					ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE `tb_employee_leaves` 			ADD FOREIGN KEY(`employee_id`) 		REFERENCES `tb_employees`(`id`)					ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE `tb_employee_leaves` 			ADD FOREIGN KEY(`approver_id`) 		REFERENCES `tb_employees`(`id`)					ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE `tb_employee_account` 			ADD FOREIGN KEY(`employee_id`) 		REFERENCES `tb_employees`(`id`)					ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE `tb_employee_privileges` 		ADD FOREIGN KEY(`employee_id`) 		REFERENCES `tb_employees`(`id`)					ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE `tb_employee_privileges` 		ADD FOREIGN KEY(`privileges_id`) 	REFERENCES `tb_system_privileges`(`id`)			ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `tb_customers`					ADD FOREIGN KEY(`location_id`)		REFERENCES `tb_organization_locations`(`id`)	ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE `tb_customer_products`			ADD FOREIGN KEY(`customer_id`)		REFERENCES `tb_customers`(`id`)					ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE `tb_customer_products`			ADD FOREIGN KEY(`product_id`)		REFERENCES `tb_products`(`id`)					ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `tb_product_inventory`			ADD FOREIGN KEY(`product_id`)		REFERENCES `tb_products`(`id`)					ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE `tb_product_inventory`			ADD FOREIGN KEY(`from_employee_id`) REFERENCES `tb_employees`(`id`)					ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE `tb_product_inventory`			ADD FOREIGN KEY(`to_employee_id`)	REFERENCES `tb_employees`(`id`)					ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `tb_projects`					ADD FOREIGN KEY(`customer_id`)		REFERENCES `tb_customers`(`id`)					ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE `tb_project_members`			ADD FOREIGN KEY(`project_id`)		REFERENCES `tb_projects`(`id`)					ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE `tb_project_members`			ADD FOREIGN KEY(`employee_id`)		REFERENCES `tb_employees`(`id`)					ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE `tb_project_tasks`				ADD FOREIGN KEY(`project_id`)		REFERENCES `tb_projects`(`id`)					ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE `tb_project_task_members`		ADD FOREIGN KEY(`project_task_id`)	REFERENCES `tb_project_tasks`(`id`)				ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE `tb_project_task_members`		ADD FOREIGN KEY(`employee_id`)		REFERENCES `tb_employees`(`id`)					ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `tb_posts`						ADD FOREIGN KEY(`employee_id`) 		REFERENCES `tb_employees`(`id`)					ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE `tb_post_comments`				ADD FOREIGN KEY(`post_id`)			REFERENCES `tb_posts`(`id`)						ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE `tb_post_comments`				ADD FOREIGN KEY(`employee_id`)		REFERENCES `tb_employees`(`id`)					ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `tb_chat_members`				ADD FOREIGN KEY(`chat_room_id`)		REFERENCES `tb_chat_rooms`(`id`)				ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE `tb_chat_members`				ADD FOREIGN KEY(`employee_id`)		REFERENCES `tb_employees`(`id`)					ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE `tb_chat_messages`				ADD FOREIGN KEY(`chat_room_id`)		REFERENCES `tb_chat_rooms`(`id`)				ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE `tb_chat_messages`				ADD FOREIGN KEY(`employee_id`)		REFERENCES `tb_employees`(`id`)					ON DELETE NO ACTION ON UPDATE NO ACTION;
