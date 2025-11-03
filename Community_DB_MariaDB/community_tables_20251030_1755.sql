CREATE TABLE `tb_system_settings` (
	`id` INT(10) UNSIGNED NOT NULL COMMENT '설정 ID',
	`name` VARCHAR(255) NOT NULL COMMENT '설정 이름',
	`value_number` INT(10) UNSIGNED COMMENT '숫자형태 설정값',
	`value_text` VARCHAR(255) COMMENT '문자형태 설정값',
	`description` VARCHAR(255) COMMENT '설정 설명',
	`created_at` TIMESTAMP NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
	`updated_at` TIMESTAMP NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
	PRIMARY KEY(`id`)
) COMMENT='시스템 세팅 리스트';

CREATE TABLE `tb_system_monitor` (
	`id` INT(10) UNSIGNED NOT NULL COMMENT '모니터링 ID',
	`name` VARCHAR(255) NOT NULL COMMENT '모니터링 이름',
	`value_number` INT(10) UNSIGNED COMMENT '숫자형태 상태값',
	`value_text` VARCHAR(255) COMMENT '문자형태 상태값',
	`description` VARCHAR(255) COMMENT '모니터링 설명',
	`check_interval` INT(10) UNSIGNED COMMENT '모니터링 체크 주기 (필요 시)',
	`checked_at` TIMESTAMP COMMENT '모니터링 체크 시각 (필요 시)',
	`created_at` TIMESTAMP NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
	`updated_at` TIMESTAMP NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
	PRIMARY KEY(`id`)
) COMMENT='시스템 모니터링 리스트';

CREATE TABLE `tb_system_log_list` (
	`id` INT(10) UNSIGNED NOT NULL COMMENT '로그 ID',
	`category` ENUM('normal','error') NOT NULL DEFAULT 'normal' COMMENT '로그 구분',
	`description` VARCHAR(255) COMMENT '로그 내용',
	`created_at` TIMESTAMP NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
	`updated_at` TIMESTAMP NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
	PRIMARY KEY(`id`)
) COMMENT='시스템 로그 리스트';

CREATE TABLE `tb_system_logs` (
	`id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
	`log_id` INT(10) UNSIGNED NOT NULL COMMENT '로그 ID',
	`created_at` TIMESTAMP NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
	PRIMARY KEY(`id`)
) COMMENT='시스템 로그 이력';

CREATE TABLE `tb_system_privileges` (
	`id` INT(10) UNSIGNED NOT NULL COMMENT '권한 ID',
	`name` VARCHAR(255) NOT NULL COMMENT '권한 이름',
	`description` VARCHAR(255) COMMENT '권한 설명',
	`created_at` TIMESTAMP NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
	`updated_at` TIMESTAMP NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
	`is_deleted` ENUM('Y','N') NOT NULL DEFAULT 'N' COMMENT '레코드 삭제 여부',
	PRIMARY KEY(`id`)
) COMMENT='시스템 권한';

/* -------------------------------------- */

CREATE TABLE `tb_posts` (
	`id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
	`employee_id` INT(10) UNSIGNED NOT NULL COMMENT '작성자 직원 ID',
	`title` VARCHAR(255) NOT NULL COMMENT '게시글 제목',
	`content` TEXT NOT NULL COMMENT '게시글 내용',
	`comments` INT(10) UNSIGNED NOT NULL COMMENT '댓글 수',
	`comment_at` TIMESTAMP COMMENT '마지막 댓글 생성시각',
	`created_at` TIMESTAMP NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
	`updated_at` TIMESTAMP NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
	`is_deleted` ENUM('Y','N') NOT NULL DEFAULT 'N' COMMENT '레코드 삭제 여부',
	PRIMARY KEY(`id`)
) COMMENT='게시글 리스트';

CREATE TABLE `tb_post_comments` (
	`id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
	`post_id` INT(10) UNSIGNED NOT NULL COMMENT '게시글 ID',
	`employee_id` INT(10) UNSIGNED NOT NULL COMMENT '작성자 직원 ID',
	`content` VARCHAR(255) NOT NULL COMMENT '댓글 내용',
	`created_at` TIMESTAMP NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
	`updated_at` TIMESTAMP NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
	`is_deleted` ENUM('Y','N') NOT NULL DEFAULT 'N' COMMENT '레코드 삭제 여부',
	PRIMARY KEY(`id`)
) COMMENT='게시글 별 댓글';

/* -------------------------------------- */

CREATE TABLE `tb_chat_rooms` (
	`id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
	`name` VARCHAR(255) NOT NULL COMMENT '채팅방 이름',
	`description` VARCHAR(255) COMMENT '채팅방 설명',
	`message_at` TIMESTAMP COMMENT '마지막 메시지 생성시각',
	`created_at` TIMESTAMP NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
	`updated_at` TIMESTAMP NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
	`is_deleted` ENUM('Y','N') NOT NULL DEFAULT 'N' COMMENT '레코드 삭제 여부',
	PRIMARY KEY(`id`)
) COMMENT='채팅방 리스트';

CREATE TABLE `tb_chat_members` (
	`id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
	`chat_room_id` INT(10) UNSIGNED NOT NULL COMMENT '채팅방 ID',
	`employee_id` INT(10) UNSIGNED NOT NULL COMMENT '작성자 직원 ID',
	`created_at` TIMESTAMP NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
	`is_deleted` ENUM('Y','N') NOT NULL DEFAULT 'N' COMMENT '레코드 삭제 여부',
	PRIMARY KEY(`id`)
) COMMENT='채팅방 별 멤버';

CREATE TABLE `tb_chat_messages` (
	`id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
	`chat_member_id` INT(10) UNSIGNED NOT NULL COMMENT '채팅방 멤버 ID',
	`message` VARCHAR(255) NOT NULL COMMENT '메시지 내용',
	`created_at` TIMESTAMP NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
	`is_deleted` ENUM('Y','N') NOT NULL DEFAULT 'N' COMMENT '레코드 삭제 여부',
	PRIMARY KEY(`id`)
) COMMENT='채팅방 별 메시지';

/* -------------------------------------- */

CREATE TABLE `tb_projects` (
	`id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
	`customer_id` INT(10) UNSIGNED COMMENT '고객사 ID (필요 시)',
	`name` VARCHAR(255) NOT NULL COMMENT '프로젝트 이름',
	`description` VARCHAR(255) COMMENT '프로젝트 설명',
	`progress` INT(10) UNSIGNED NOT NULL COMMENT '프로젝트 진행도',
	`start_date` TIMESTAMP COMMENT '프로젝트 시작일',
	`end_date` TIMESTAMP COMMENT '프로젝트 종료일',
	`status` ENUM('대기','진행','완료','취소','보류') NOT NULL DEFAULT '대기' COMMENT '프로젝트 상태',
	`created_at` TIMESTAMP NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
	`updated_at` TIMESTAMP NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
	`is_deleted` ENUM('Y','N') NOT NULL DEFAULT 'N' COMMENT '레코드 삭제 여부',
	PRIMARY KEY(`id`)
) COMMENT='프로젝트 리스트';

CREATE TABLE `tb_project_members` (
	`id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
	`project_id` INT(10) UNSIGNED NOT NULL COMMENT '프로젝트 ID',
	`employee_id` INT(10) UNSIGNED NOT NULL COMMENT '프로젝트 직원 ID',
	`created_at` TIMESTAMP NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
	PRIMARY KEY(`id`)
) COMMENT='프로젝트 별 멤버';

CREATE TABLE `tb_project_tasks` (
	`id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
	`project_id` INT(10) UNSIGNED NOT NULL COMMENT '프로젝트 ID',
	`name` VARCHAR(255) NOT NULL COMMENT '프로젝트 이름',
	`description` VARCHAR(255) COMMENT '프로젝트 설명',
	`progress` INT(10) UNSIGNED NOT NULL COMMENT '프로젝트 작업 진행도',
	`start_date` TIMESTAMP COMMENT '프로젝트 작업 시작일',
	`end_date` TIMESTAMP COMMENT '프로젝트 작업 종료일',
	`status` ENUM('대기','진행','완료','취소','보류') NOT NULL DEFAULT '대기' COMMENT '프로젝트 작업 상태',
	`created_at` TIMESTAMP NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
	`updated_at` TIMESTAMP NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
	PRIMARY KEY(`id`)
) COMMENT='프로젝트 별 작업';

CREATE TABLE `tb_project_task_members` (
	`id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
	`project_task_id` INT(10) UNSIGNED NOT NULL COMMENT '프로젝트 작업 ID',
	`project_member_id` INT(10) UNSIGNED NOT NULL COMMENT '프로젝트 작업 직원 ID',
	`created_at` TIMESTAMP NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
	PRIMARY KEY(`id`)
) COMMENT='프로젝트 별 작업 멤버';

/* -------------------------------------- */

CREATE TABLE `tb_customers` (
	`id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
	`location_id` INT(10) UNSIGNED COMMENT '지역 ID',
	`name` VARCHAR(255) NOT NULL COMMENT '고객 이름',
	`description` VARCHAR(255) COMMENT '고객 설명',
	`image_path` VARCHAR(255) COMMENT '고객 사진 경로 또는 URL',
	`created_at` TIMESTAMP NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
	`updated_at` TIMESTAMP NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
	`is_deleted` ENUM('Y','N') NOT NULL DEFAULT 'N' COMMENT '레코드 삭제 여부',
	PRIMARY KEY(`id`)
) COMMENT='고객 리스트';

CREATE TABLE `tb_customer_products` (
	`id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
	`customer_id` INT(10) UNSIGNED NOT NULL COMMENT '고객 ID',
	`product_id` INT(10) UNSIGNED NOT NULL COMMENT '제품 ID',
	`created_at` TIMESTAMP NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
	PRIMARY KEY(`id`)
) COMMENT='고객 별 제품';

/* -------------------------------------- */

CREATE TABLE `tb_products` (
	`id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
	`name` VARCHAR(255) NOT NULL COMMENT '제품 이름',
	`content` TEXT COMMENT '제품 상세 설명',
	`description` VARCHAR(255) COMMENT '제품 간단 설명',
	`image_path` VARCHAR(255) COMMENT '제품 사진 경로 또는 URL',
	`total_count` INT(10) UNSIGNED COMMENT '제품 재고 수량',
	`created_at` TIMESTAMP NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
	`updated_at` TIMESTAMP NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
	`is_deleted` ENUM('Y','N') NOT NULL DEFAULT 'N' COMMENT '레코드 삭제 여부',
	PRIMARY KEY(`id`)
) COMMENT='제품 리스트';

CREATE TABLE `tb_product_inventory` (
	`id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
	`product_id` INT(10) UNSIGNED NOT NULL COMMENT '제품 ID',
	`from_employee_id` INT(10) UNSIGNED COMMENT '입출고 직원 ID',
	`to_employee_id` INT(10) UNSIGNED COMMENT '요청 직원 ID',
	`movement_type` ENUM('입고','출고') NOT NULL DEFAULT '입고' COMMENT '입출고 구분',
	`movement_count` INT(10) NOT NULL COMMENT '입출고 수량',
	`content` VARCHAR(255) COMMENT '입출고 내용',
	`created_at` TIMESTAMP NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
	`updated_at` TIMESTAMP NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
	`is_deleted` ENUM('Y','N') NOT NULL DEFAULT 'N' COMMENT '레코드 삭제 여부',
	PRIMARY KEY(`id`)
) COMMENT='제품 별 입출고 이력';

/* -------------------------------------- */

CREATE TABLE `tb_employees` (
	`id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
	`name` VARCHAR(255) NOT NULL COMMENT '직원 이름',
	`description` VARCHAR(255) COMMENT '직원 설명',
	`employee_code` VARCHAR(255) COMMENT '직원 코드 (필요 시)',
	`gender` ENUM('남','여','기타') COMMENT '직원 성별',
	`birth_date` DATE COMMENT '직원 생년월일',
	`email` VARCHAR(255) COMMENT '직원 이메일',
	`phone` VARCHAR(255) COMMENT '직원 전화번호',
	`address` VARCHAR(255) COMMENT '직원 자택주소',
	`image_path` VARCHAR(255) COMMENT '직원 사진 경로 또는 URL',
	`status` ENUM('재직','휴가','정직','퇴직','대기','계약해지') COMMENT '직원 상태',
	`joined_at` TIMESTAMP COMMENT '직원 입사일',
	`resigned_at` TIMESTAMP COMMENT '직원 퇴사일',
	`team_id` INT(10) UNSIGNED COMMENT '팀 ID',
	`rank_id` INT(10) UNSIGNED COMMENT '직급 ID',
	`position_id` INT(10) UNSIGNED COMMENT '직책 ID',
	`role_id` INT(10) UNSIGNED COMMENT '역할 ID',
	`login_id` VARCHAR(255) COMMENT '로그인 ID',
	`login_pw` VARCHAR(255) COMMENT '로그인 PW',
	`is_active` ENUM('Y','N') COMMENT '로그인 계정 상태',
	`created_at` TIMESTAMP NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
	`updated_at` TIMESTAMP NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
	`is_deleted` ENUM('Y','N') NOT NULL DEFAULT 'N' COMMENT '레코드 삭제 여부',
	PRIMARY KEY(`id`),
	UNIQUE INDEX `login_id` (`login_id`)
) COMMENT='직원 리스트';

CREATE TABLE `tb_employee_reviews` (
	`id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
	`employee_id` INT(10) UNSIGNED NOT NULL COMMENT '평가대상 직원 ID',
	`reviewer_id` INT(10) UNSIGNED NOT NULL COMMENT '평가자 직원 ID',
	`review_date` TIMESTAMP COMMENT '평가일',
	`review_type` ENUM('1차평가','2차평가','최종평가','자기평가','동료평가') NOT NULL DEFAULT '1차평가' COMMENT '평가 구분',
	`score` INT(10) COMMENT '평가 점수',
	`description` VARCHAR(255) COMMENT '평가 내용',
	`review_result` ENUM('매우우수(S)','우수(A)','양호(B)','보통(C)','미흡(D)','부족(E)','미달(F)') NOT NULL DEFAULT '매우우수(S)' COMMENT '평가 결과',
	`created_at` TIMESTAMP NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
	`updated_at` TIMESTAMP NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
	PRIMARY KEY(`id`)
) COMMENT='직원 별 평가 이력';

CREATE TABLE `tb_employee_leaves` (
	`id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
	`employee_id` INT(10) UNSIGNED NOT NULL COMMENT '휴가 직원 ID',
	`approver_id` INT(10) UNSIGNED NOT NULL COMMENT '승인 직원 ID',
	`leave_type` ENUM('연차','병가','무급','출산','육아','특별','대체') NOT NULL DEFAULT '연차' COMMENT '휴가 구분',
	`start_dt` TIMESTAMP NOT NULL COMMENT '휴가 시작일',
	`end_dt` TIMESTAMP NOT NULL COMMENT '휴가 종료일',
	`description` VARCHAR(255) COMMENT '휴가 내용',
	`leave_result` ENUM('대기','승인','반려','취소','완료') NOT NULL DEFAULT '대기' COMMENT '승인 결과',
	`created_at` TIMESTAMP NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
	`updated_at` TIMESTAMP NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
	PRIMARY KEY(`id`)
) COMMENT='직원 별 휴가 이력';

CREATE TABLE `tb_employee_privileges` (
	`id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
	`employee_id` INT(10) UNSIGNED NOT NULL COMMENT '직원 ID',
	`privileges_id` INT(10) UNSIGNED NOT NULL COMMENT '권한 ID',
	`is_allowed` ENUM('Y','N') NOT NULL DEFAULT 'Y' COMMENT '권한 허용 여부',
	`created_at` TIMESTAMP NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
	`updated_at` TIMESTAMP NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
	PRIMARY KEY(`id`)
) COMMENT='직원 별 권한 내역';

/* -------------------------------------- */

CREATE TABLE `tb_organization_locations` (
	`id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
	`name` VARCHAR(255) NOT NULL COMMENT '지역 이름',
	`description` VARCHAR(255) COMMENT '지역 설명',
	`created_at` TIMESTAMP NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
	`updated_at` TIMESTAMP NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
	PRIMARY KEY(`id`)
) COMMENT='지역 리스트';

CREATE TABLE `tb_organization_companies` (
	`id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
	`name` VARCHAR(255) NOT NULL COMMENT '회사 이름',
	`description` VARCHAR(255) COMMENT '회사 설명',
	`created_at` TIMESTAMP NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
	`updated_at` TIMESTAMP NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
	PRIMARY KEY(`id`)
) COMMENT='회사 리스트';

CREATE TABLE `tb_organization_departments` (
	`id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
	`company_id` INT(10) UNSIGNED NOT NULL COMMENT '회사 ID',
	`name` VARCHAR(255) NOT NULL COMMENT '부서 이름',
	`description` VARCHAR(255) COMMENT '부서 설명',
	`created_at` TIMESTAMP NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
	`updated_at` TIMESTAMP NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
	PRIMARY KEY(`id`)
) COMMENT='부서 리스트';

CREATE TABLE `tb_organization_teams` (
	`id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
	`department_id` INT(10) UNSIGNED NOT NULL COMMENT '부서 ID',
	`name` VARCHAR(255) NOT NULL COMMENT '팀 이름',
	`description` VARCHAR(255) COMMENT '팀 설명',
	`created_at` TIMESTAMP NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
	`updated_at` TIMESTAMP NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
	PRIMARY KEY(`id`)
) COMMENT='팀 리스트';

CREATE TABLE `tb_organization_ranks` (
	`id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
	`name` VARCHAR(255) NOT NULL COMMENT '직급 이름',
	`description` VARCHAR(255) COMMENT '직급 설명',
	`created_at` TIMESTAMP NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
	`updated_at` TIMESTAMP NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
	PRIMARY KEY(`id`)
) COMMENT='직급 리스트';

CREATE TABLE `tb_organization_positions` (
	`id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
	`name` VARCHAR(255) NOT NULL COMMENT '직책 이름',
	`description` VARCHAR(255) COMMENT '직책 설명',
	`created_at` TIMESTAMP NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
	`updated_at` TIMESTAMP NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
	PRIMARY KEY(`id`)
) COMMENT='직책 리스트';

CREATE TABLE `tb_organization_roles` (
	`id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
	`name` VARCHAR(255) NOT NULL COMMENT '역할 이름',
	`description` VARCHAR(255) COMMENT '역할 설명',
	`created_at` TIMESTAMP NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
	`updated_at` TIMESTAMP NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
	PRIMARY KEY(`id`)
) COMMENT='역할 리스트';

