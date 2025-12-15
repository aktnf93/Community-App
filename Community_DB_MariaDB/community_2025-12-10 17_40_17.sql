-- --------------------------------------------------------
-- 호스트:                          127.0.0.1
-- 서버 버전:                        11.8.5-MariaDB - MariaDB Server
-- 서버 OS:                        Win64
-- HeidiSQL 버전:                  12.11.0.7065
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- community 데이터베이스 구조 내보내기
DROP DATABASE IF EXISTS `community`;
CREATE DATABASE IF NOT EXISTS `community` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;
USE `community`;

-- 프로시저 community.p_employee_daytime 구조 내보내기
DELIMITER //
CREATE PROCEDURE `p_employee_daytime`(
	IN `base_date` DATE,
	IN `base_employee_id` INT
)
BEGIN
   SELECT 
       e.id AS `employee_id`, 
		 e.employee_code, 
		 e.name,
       e.company_name, 
		 e.department_name, 
		 e.team_name,
       e.rank_name, 
		 e.position_name, 
		 e.role_name, 
		 e.privilege_name,
       a.id,
       a.start_work_at, a.end_work_at,
       SEC_TO_TIME(a.total_work_minutes * 60) AS 'total_work_minutes',
       a.description, a.created_at, a.updated_at
   FROM v_employees e
       LEFT OUTER JOIN tb_employee_attendance a ON 
       a.employee_id = e.id AND DATE(a.start_work_at) = DATE(base_date)
	WHERE IF(base_employee_id IS NULL, 1 = 1, e.id = base_employee_id)
	;
END//
DELIMITER ;

-- 프로시저 community.p_employee_weektime 구조 내보내기
DELIMITER //
CREATE PROCEDURE `p_employee_weektime`(
	IN `base_minutes` INT,
	IN `base_date` DATE,
	IN `base_employee_id` INT
)
BEGIN
   SELECT 
		e.id AS employee_id,
      COALESCE(SUM(a.total_work_minutes), 0) AS total_minutes,
      
      (COALESCE(SUM(a.total_work_minutes), 0) - 
      GREATEST(ROUND(COALESCE(SUM(a.total_work_minutes), 0) - base_minutes), 0)) AS base_minutes,
      
      
      GREATEST(ROUND(COALESCE(SUM(a.total_work_minutes), 0) - base_minutes), 0) AS overtime_minutes,
      GREATEST(ROUND((base_minutes - COALESCE(SUM(a.total_work_minutes), 0)), 0), 0) AS remaining_minutes,
      DATE_SUB(base_date, INTERVAL WEEKDAY(base_date) DAY) AS week_start,
      base_date AS week_day,
      DATE_ADD(DATE_SUB(base_date, INTERVAL WEEKDAY(base_date) DAY), INTERVAL 6 DAY) AS week_end
   FROM tb_employees e
       LEFT JOIN tb_employee_attendance a ON e.id = a.employee_id AND YEARWEEK(a.start_work_at, 1) = YEARWEEK(base_date, 1)
   WHERE IF(base_employee_id IS NULL, 1 = 1, e.id = base_employee_id)
   GROUP BY e.id
	;
END//
DELIMITER ;

-- 테이블 community.tb_chat_members 구조 내보내기
CREATE TABLE IF NOT EXISTS `tb_chat_members` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
  `chat_room_id` int(10) unsigned NOT NULL COMMENT '채팅방 ID',
  `employee_id` int(10) unsigned NOT NULL COMMENT '직원 ID',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
  `deleted_at` timestamp NULL DEFAULT NULL COMMENT '레코드 삭제시각',
  PRIMARY KEY (`id`),
  UNIQUE KEY `chat_room_id` (`chat_room_id`,`employee_id`),
  KEY `FK_tb_chat_members_tb_chat_rooms` (`chat_room_id`),
  KEY `FK_tb_chat_members_tb_employees` (`employee_id`),
  CONSTRAINT `FK_tb_chat_members_tb_chat_rooms` FOREIGN KEY (`chat_room_id`) REFERENCES `tb_chat_rooms` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_tb_chat_members_tb_employees` FOREIGN KEY (`employee_id`) REFERENCES `tb_employees` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='채팅방 별 멤버';

-- 테이블 데이터 community.tb_chat_members:~2 rows (대략적) 내보내기
INSERT INTO `tb_chat_members` (`id`, `chat_room_id`, `employee_id`, `created_at`, `deleted_at`) VALUES
	(2, 3, 13, '2025-11-14 10:11:41', NULL),
	(8, 4, 13, '2025-11-14 10:53:28', NULL);

-- 테이블 community.tb_chat_messages 구조 내보내기
CREATE TABLE IF NOT EXISTS `tb_chat_messages` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
  `chat_room_id` int(10) unsigned NOT NULL COMMENT '채팅방 ID',
  `employee_id` int(10) unsigned NOT NULL COMMENT '직원 ID',
  `message` varchar(255) NOT NULL COMMENT '메시지 내용',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
  `deleted_at` timestamp NULL DEFAULT NULL COMMENT '레코드 삭제 여부',
  PRIMARY KEY (`id`),
  KEY `FK_tb_chat_messages_tb_chat_rooms` (`chat_room_id`),
  KEY `FK_tb_chat_messages_tb_employees` (`employee_id`),
  CONSTRAINT `FK_tb_chat_messages_tb_chat_rooms` FOREIGN KEY (`chat_room_id`) REFERENCES `tb_chat_rooms` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_tb_chat_messages_tb_employees` FOREIGN KEY (`employee_id`) REFERENCES `tb_employees` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='채팅방 별 메시지';

-- 테이블 데이터 community.tb_chat_messages:~5 rows (대략적) 내보내기
INSERT INTO `tb_chat_messages` (`id`, `chat_room_id`, `employee_id`, `message`, `created_at`, `deleted_at`) VALUES
	(1, 4, 13, '안녕하세요?', '2025-11-19 11:49:28', NULL),
	(2, 4, 13, '232', '2025-11-27 08:01:22', NULL),
	(3, 4, 13, '안녕하세요', '2025-11-27 08:01:27', NULL),
	(4, 4, 13, '안녕하세요', '2025-11-27 08:05:28', NULL),
	(5, 4, 13, '안녕하세요', '2025-11-27 08:16:08', NULL),
	(6, 4, 13, 'dasda', '2025-11-27 15:50:18', NULL);

-- 테이블 community.tb_chat_rooms 구조 내보내기
CREATE TABLE IF NOT EXISTS `tb_chat_rooms` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
  `name` varchar(255) NOT NULL COMMENT '채팅방 이름',
  `description` varchar(255) DEFAULT NULL COMMENT '채팅방 설명',
  `message_at` timestamp NULL DEFAULT NULL COMMENT '마지막 메시지 생성시각',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
  `deleted_at` timestamp NULL DEFAULT NULL COMMENT '레코드 삭제시각',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='채팅방 리스트';

-- 테이블 데이터 community.tb_chat_rooms:~2 rows (대략적) 내보내기
INSERT INTO `tb_chat_rooms` (`id`, `name`, `description`, `message_at`, `created_at`, `updated_at`, `deleted_at`) VALUES
	(3, '자유 채팅방', NULL, NULL, '2025-11-14 06:59:37', '2025-11-14 06:59:37', NULL),
	(4, '총무부', '비번: 총무부 번호', NULL, '2025-11-14 06:59:47', '2025-11-14 07:04:20', NULL);

-- 테이블 community.tb_customers 구조 내보내기
CREATE TABLE IF NOT EXISTS `tb_customers` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
  `location_id` int(10) unsigned DEFAULT NULL COMMENT '지역 ID',
  `name` varchar(255) NOT NULL COMMENT '고객 이름',
  `description` varchar(255) DEFAULT NULL COMMENT '고객 설명',
  `image_path` varchar(255) DEFAULT NULL COMMENT '고객 사진 경로 또는 URL',
  `contract_type` enum('None','short_contract','long_contract') DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
  `deleted_at` timestamp NULL DEFAULT NULL COMMENT '레코드 삭제시각',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `FK_tb_customers_tb_organization_locations` (`location_id`),
  CONSTRAINT `FK_tb_customers_tb_organization_locations` FOREIGN KEY (`location_id`) REFERENCES `tb_organization_locations` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='고객 리스트';

-- 테이블 데이터 community.tb_customers:~2 rows (대략적) 내보내기
INSERT INTO `tb_customers` (`id`, `location_id`, `name`, `description`, `image_path`, `contract_type`, `created_at`, `updated_at`, `deleted_at`) VALUES
	(1, NULL, '00마케팅', '광고회사', NULL, NULL, '2025-11-26 04:03:43', '2025-11-26 04:03:43', NULL),
	(2, NULL, '00전자', '연구개발', NULL, NULL, '2025-11-26 05:04:15', '2025-11-26 05:04:15', NULL);

-- 테이블 community.tb_customer_products 구조 내보내기
CREATE TABLE IF NOT EXISTS `tb_customer_products` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
  `customer_id` int(10) unsigned NOT NULL COMMENT '고객 ID',
  `product_id` int(10) unsigned NOT NULL COMMENT '제품 ID',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
  PRIMARY KEY (`id`),
  KEY `FK_tb_customer_products_tb_customers` (`customer_id`),
  KEY `FK_tb_customer_products_tb_products` (`product_id`),
  CONSTRAINT `FK_tb_customer_products_tb_customers` FOREIGN KEY (`customer_id`) REFERENCES `tb_customers` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_tb_customer_products_tb_products` FOREIGN KEY (`product_id`) REFERENCES `tb_products` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='고객 별 제품';

-- 테이블 데이터 community.tb_customer_products:~0 rows (대략적) 내보내기

-- 테이블 community.tb_customer_services 구조 내보내기
CREATE TABLE IF NOT EXISTS `tb_customer_services` (
  `id` int(10) unsigned NOT NULL,
  `customer_id` int(10) unsigned NOT NULL,
  `type` varchar(255) NOT NULL DEFAULT '',
  `description` varchar(255) NOT NULL DEFAULT '',
  `price` int(10) DEFAULT NULL,
  `employee_id` int(10) unsigned DEFAULT NULL,
  `created_at` timestamp NOT NULL,
  `updated_at` timestamp NOT NULL,
  KEY `FK_tb_customer_services_tb_customers` (`customer_id`),
  KEY `FK_tb_customer_services_tb_employees` (`employee_id`),
  CONSTRAINT `FK_tb_customer_services_tb_customers` FOREIGN KEY (`customer_id`) REFERENCES `tb_customers` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_tb_customer_services_tb_employees` FOREIGN KEY (`employee_id`) REFERENCES `tb_employees` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 테이블 데이터 community.tb_customer_services:~0 rows (대략적) 내보내기

-- 테이블 community.tb_employees 구조 내보내기
CREATE TABLE IF NOT EXISTS `tb_employees` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
  `name` varchar(255) NOT NULL COMMENT '직원 이름',
  `description` varchar(255) DEFAULT NULL COMMENT '직원 설명',
  `employee_code` varchar(255) DEFAULT NULL COMMENT '직원 코드 (필요 시)',
  `employee_type` enum('정규직','계약직','인턴','무기계약직','파트타임','파견직','아르바이트','프리랜서','외주') DEFAULT NULL COMMENT '직원 고용유형',
  `gender` enum('남','여','기타') DEFAULT NULL COMMENT '직원 성별',
  `birth_date` date DEFAULT NULL COMMENT '직원 생년월일',
  `email` varchar(255) DEFAULT NULL COMMENT '직원 이메일',
  `phone` varchar(255) DEFAULT NULL COMMENT '직원 전화번호',
  `address` varchar(255) DEFAULT NULL COMMENT '직원 자택주소',
  `image_path` varchar(255) DEFAULT NULL COMMENT '직원 사진 경로 또는 URL',
  `status` enum('재직','휴가','정직','퇴직','대기','계약해지') DEFAULT NULL COMMENT '직원 상태',
  `joined_at` timestamp NULL DEFAULT NULL COMMENT '직원 입사일',
  `resigned_at` timestamp NULL DEFAULT NULL COMMENT '직원 퇴사일',
  `resigned_desc` varchar(255) DEFAULT NULL COMMENT '직원 퇴사사유',
  `team_id` int(10) unsigned DEFAULT NULL COMMENT '팀 ID',
  `rank_id` int(10) unsigned DEFAULT NULL COMMENT '직급 ID',
  `position_id` int(10) unsigned DEFAULT NULL COMMENT '직책 ID',
  `role_id` int(10) unsigned DEFAULT NULL COMMENT '역할 ID',
  `privilege_id` int(10) unsigned DEFAULT NULL COMMENT '권한 ID',
  `login_id` varchar(255) DEFAULT NULL COMMENT '로그인 ID',
  `login_pw` varchar(255) DEFAULT NULL COMMENT '로그인 PW',
  `is_active` enum('Y','N') DEFAULT NULL COMMENT '로그인 계정 상태',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
  `deleted_at` timestamp NULL DEFAULT NULL COMMENT '레코드 삭제시각',
  PRIMARY KEY (`id`),
  UNIQUE KEY `login_id` (`login_id`),
  UNIQUE KEY `employee_code` (`employee_code`),
  KEY `FK_tb_employees_tb_organization_teams` (`team_id`),
  KEY `FK_tb_employees_tb_organization_ranks` (`rank_id`),
  KEY `FK_tb_employees_tb_organization_positions` (`position_id`),
  KEY `FK_tb_employees_tb_organization_roles` (`role_id`),
  KEY `FK_tb_employees_tb_organization_privileges` (`privilege_id`),
  CONSTRAINT `FK_tb_employees_tb_organization_positions` FOREIGN KEY (`position_id`) REFERENCES `tb_organization_positions` (`id`) ON DELETE SET NULL ON UPDATE NO ACTION,
  CONSTRAINT `FK_tb_employees_tb_organization_privileges` FOREIGN KEY (`privilege_id`) REFERENCES `tb_organization_privileges` (`id`) ON DELETE SET NULL ON UPDATE NO ACTION,
  CONSTRAINT `FK_tb_employees_tb_organization_ranks` FOREIGN KEY (`rank_id`) REFERENCES `tb_organization_ranks` (`id`) ON DELETE SET NULL ON UPDATE NO ACTION,
  CONSTRAINT `FK_tb_employees_tb_organization_roles` FOREIGN KEY (`role_id`) REFERENCES `tb_organization_roles` (`id`) ON DELETE SET NULL ON UPDATE NO ACTION,
  CONSTRAINT `FK_tb_employees_tb_organization_teams` FOREIGN KEY (`team_id`) REFERENCES `tb_organization_teams` (`id`) ON DELETE SET NULL ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='직원 리스트';

-- 테이블 데이터 community.tb_employees:~8 rows (대략적) 내보내기
INSERT INTO `tb_employees` (`id`, `name`, `description`, `employee_code`, `employee_type`, `gender`, `birth_date`, `email`, `phone`, `address`, `image_path`, `status`, `joined_at`, `resigned_at`, `resigned_desc`, `team_id`, `rank_id`, `position_id`, `role_id`, `privilege_id`, `login_id`, `login_pw`, `is_active`, `created_at`, `updated_at`, `deleted_at`) VALUES
	(13, '제임슨(test)', '초창기 직원', 'A0001', '정규직', '남', '2025-11-19', 'jameson@123.com', '000-1234-5678', '서울특별시 강남구 서초길 럭셔리브랜드아파트 1232-567, 1999호', '/uploads\\A0002.png', '재직', '2025-11-19 08:30:50', '2025-12-08 13:29:28', '자진퇴사', 31, 14, 10, 12, 2, '123', '123', 'Y', '2025-11-11 05:15:04', '2025-12-09 08:20:56', NULL),
	(15, '김민수', '', 'A0002', '정규직', '남', '2025-11-19', 'jameson@123.com', '110-12**-56**', '00시 00구 00군 0000-123', '/uploads\\A0003.png', '재직', '2025-11-19 08:30:50', NULL, NULL, 31, 13, 7, 13, 2, '김민수', '123', 'Y', '2025-11-11 05:15:04', '2025-12-09 01:15:34', NULL),
	(16, '김영호', '', 'A0003', '정규직', '남', '2025-11-19', 'jameson@123.com', '000-1234-5678', '00시 00구 00군 0000-123', '/uploads\\A0004.png', '휴가', '2025-11-19 08:30:50', NULL, NULL, 31, 13, 7, 15, 2, '김영호', '123', 'Y', '2025-11-11 05:15:04', '2025-12-09 01:16:06', NULL),
	(17, '배선호', '', 'A0004', '인턴', '남', '2025-11-19', '배선호@email.com', '000-1234-5678', '', '/uploads\\A0005.png', '재직', '2025-11-19 08:30:50', NULL, NULL, 31, 11, 7, 13, 2, NULL, NULL, 'N', '2025-11-11 05:15:04', '2025-12-09 01:19:41', NULL),
	(18, '장현석', '직원설명4', 'A0005', NULL, '남', '2025-11-19', 'jameson@123.com', '000-1234-5678', '00시 00구 00군 0000-123', '/uploads\\A0006.png', '퇴직', '2025-11-19 08:30:50', NULL, NULL, NULL, 13, 7, 20, NULL, NULL, NULL, 'N', '2025-11-11 05:15:04', '2025-12-01 14:44:12', NULL),
	(19, '한민우', '직원설명5', 'A0006', NULL, '여', '2025-11-19', 'jameson@123.com', '000-1234-5678', '00시 00구 00군 0000-123', '/uploads\\A0006.png', '재직', '2025-11-19 08:30:50', NULL, NULL, NULL, 13, 7, 20, NULL, NULL, NULL, 'N', '2025-11-11 05:15:04', '2025-12-01 13:43:53', NULL),
	(20, '고선재', '직원설명6', 'A0007', NULL, '여', '2025-11-19', 'jameson@123.com', '055-**12-0099', '서울시 00구 00구 123-567', '/uploads\\A0006.png', '재직', '2025-11-19 08:30:50', NULL, NULL, NULL, 11, 7, 20, NULL, NULL, NULL, 'N', '2025-11-11 05:15:04', '2025-12-01 13:43:54', NULL),
	(21, '박진철', '직원설명7', 'A0008', NULL, '여', '2025-11-19', 'jameson@123.com', '000-1234-5678', '00시 서울구 00-1234', '/uploads\\A0006.png', '퇴직', '2025-11-19 08:30:50', NULL, NULL, 7, 13, 7, 20, NULL, NULL, NULL, 'N', '2025-11-11 05:15:04', '2025-12-01 13:43:54', NULL);

-- 테이블 community.tb_employee_attendance 구조 내보내기
CREATE TABLE IF NOT EXISTS `tb_employee_attendance` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
  `employee_id` int(10) unsigned NOT NULL COMMENT '직원 ID',
  `start_work_at` timestamp NULL DEFAULT NULL COMMENT '출근 시각',
  `end_work_at` timestamp NULL DEFAULT NULL COMMENT '퇴근 시각',
  `total_work_minutes` int(10) GENERATED ALWAYS AS (timestampdiff(MINUTE,`start_work_at`,`end_work_at`)) STORED,
  `description` varchar(255) DEFAULT NULL COMMENT '비고',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수성시각',
  PRIMARY KEY (`id`),
  KEY `FK_tb_employee_attendance_tb_employees` (`employee_id`,`created_at`) USING BTREE,
  KEY `created_at` (`created_at`),
  CONSTRAINT `FK_tb_employee_attendance_tb_employees` FOREIGN KEY (`employee_id`) REFERENCES `tb_employees` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='직원 별 근태이력';

-- 테이블 데이터 community.tb_employee_attendance:~16 rows (대략적) 내보내기
INSERT INTO `tb_employee_attendance` (`id`, `employee_id`, `start_work_at`, `end_work_at`, `description`, `created_at`, `updated_at`) VALUES
	(2, 13, '2025-12-01 00:00:00', '2025-12-01 09:00:00', NULL, '2025-12-01 06:39:17', '2025-12-02 06:45:20'),
	(5, 13, '2025-12-02 13:26:39', '2025-12-02 13:26:46', NULL, '2025-12-02 13:26:39', '2025-12-02 13:26:46'),
	(7, 20, '2025-12-01 22:50:00', '2025-12-02 10:38:03', NULL, '2025-12-02 15:38:09', '2025-12-02 15:38:09'),
	(8, 16, '2025-11-30 15:00:00', '2025-12-01 14:59:59', NULL, '2025-12-02 15:38:28', '2025-12-10 07:49:50'),
	(9, 21, '2025-12-02 00:00:00', '2025-12-02 10:25:00', NULL, '2025-12-02 15:38:56', '2025-12-02 15:38:56'),
	(10, 17, '2025-12-01 23:26:58', '2025-12-02 09:23:07', NULL, '2025-12-02 15:39:12', '2025-12-02 15:39:12'),
	(14, 13, '2025-12-03 11:44:51', '2025-12-03 11:44:59', NULL, '2025-12-03 11:44:51', '2025-12-03 11:44:59'),
	(15, 13, '2025-12-04 01:43:19', '2025-12-04 14:00:52', NULL, '2025-12-04 01:43:19', '2025-12-04 14:00:52'),
	(16, 13, '2025-12-05 02:53:17', NULL, NULL, '2025-12-05 02:53:17', '2025-12-05 02:53:17'),
	(18, 13, '2025-12-07 07:32:50', NULL, NULL, '2025-12-07 07:32:50', '2025-12-07 07:32:50'),
	(19, 13, '2025-12-08 12:42:53', NULL, NULL, '2025-12-08 12:42:53', '2025-12-08 12:42:53'),
	(20, 13, '2025-12-09 07:22:57', '2025-12-09 12:10:52', NULL, '2025-12-09 07:22:57', '2025-12-09 12:10:52'),
	(22, 13, '2025-12-10 04:57:03', NULL, NULL, '2025-12-10 04:57:03', '2025-12-10 04:57:03'),
	(23, 16, '2025-12-07 15:00:00', '2025-12-08 14:59:59', NULL, '2025-12-02 15:38:28', '2025-12-10 08:06:16'),
	(24, 16, '2025-12-08 15:00:00', '2025-12-09 14:59:59', NULL, '2025-12-02 15:38:28', '2025-12-10 08:06:20'),
	(25, 16, '2025-12-09 15:00:00', '2025-12-10 14:59:59', NULL, '2025-12-02 15:38:28', '2025-12-10 08:06:24');

-- 테이블 community.tb_employee_leaves 구조 내보내기
CREATE TABLE IF NOT EXISTS `tb_employee_leaves` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
  `employee_id` int(10) unsigned NOT NULL COMMENT '휴가 직원 ID',
  `approver_id` int(10) unsigned NOT NULL COMMENT '승인 직원 ID',
  `leave_type` enum('연차','병가','무급','출산','육아','특별','대체') NOT NULL DEFAULT '연차' COMMENT '휴가 구분',
  `start_date` timestamp NOT NULL COMMENT '휴가 시작일',
  `end_date` timestamp NOT NULL COMMENT '휴가 종료일',
  `description` varchar(255) DEFAULT NULL COMMENT '휴가 내용',
  `leave_result` enum('대기','승인','반려','취소','완료') NOT NULL DEFAULT '대기' COMMENT '승인 결과',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
  PRIMARY KEY (`id`),
  KEY `FK_tb_employee_leaves_tb_employees` (`employee_id`),
  KEY `FK_tb_employee_leaves_tb_employees_2` (`approver_id`),
  CONSTRAINT `FK_tb_employee_leaves_tb_employees` FOREIGN KEY (`employee_id`) REFERENCES `tb_employees` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_tb_employee_leaves_tb_employees_2` FOREIGN KEY (`approver_id`) REFERENCES `tb_employees` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='직원 별 휴가 이력';

-- 테이블 데이터 community.tb_employee_leaves:~0 rows (대략적) 내보내기

-- 테이블 community.tb_employee_reviews 구조 내보내기
CREATE TABLE IF NOT EXISTS `tb_employee_reviews` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
  `employee_id` int(10) unsigned NOT NULL COMMENT '평가대상 직원 ID',
  `reviewer_id` int(10) unsigned NOT NULL COMMENT '평가자 직원 ID',
  `review_date` timestamp NOT NULL COMMENT '평가일',
  `review_type` enum('1차평가','2차평가','최종평가','자기평가','동료평가') NOT NULL DEFAULT '1차평가' COMMENT '평가 구분',
  `score` int(10) NOT NULL COMMENT '평가 점수',
  `description` varchar(255) DEFAULT NULL COMMENT '평가 내용',
  `review_result` enum('매우우수(S)','우수(A)','양호(B)','보통(C)','미흡(D)','부족(E)','미달(F)') NOT NULL DEFAULT '매우우수(S)' COMMENT '평가 결과',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
  PRIMARY KEY (`id`),
  KEY `FK_tb_employee_reviews_tb_employees` (`employee_id`),
  KEY `FK_tb_employee_reviews_tb_employees_2` (`reviewer_id`),
  CONSTRAINT `FK_tb_employee_reviews_tb_employees` FOREIGN KEY (`employee_id`) REFERENCES `tb_employees` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_tb_employee_reviews_tb_employees_2` FOREIGN KEY (`reviewer_id`) REFERENCES `tb_employees` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='직원 별 평가 이력';

-- 테이블 데이터 community.tb_employee_reviews:~0 rows (대략적) 내보내기

-- 테이블 community.tb_organization_companies 구조 내보내기
CREATE TABLE IF NOT EXISTS `tb_organization_companies` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
  `name` varchar(255) NOT NULL COMMENT '회사 이름',
  `description` varchar(255) DEFAULT NULL COMMENT '회사 설명',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='회사 리스트';

-- 테이블 데이터 community.tb_organization_companies:~1 rows (대략적) 내보내기
INSERT INTO `tb_organization_companies` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES
	(8, 'SH ELECTRONIC', NULL, '2025-11-13 02:23:57', '2025-12-03 00:05:25');

-- 테이블 community.tb_organization_departments 구조 내보내기
CREATE TABLE IF NOT EXISTS `tb_organization_departments` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
  `company_id` int(10) unsigned NOT NULL COMMENT '회사 ID',
  `name` varchar(255) NOT NULL COMMENT '부서 이름',
  `description` varchar(255) DEFAULT NULL COMMENT '부서 설명',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
  PRIMARY KEY (`id`),
  UNIQUE KEY `company_id` (`company_id`,`name`),
  KEY `FK_tb_organization_departments_tb_organization_companies` (`company_id`),
  CONSTRAINT `FK_tb_organization_departments_tb_organization_companies` FOREIGN KEY (`company_id`) REFERENCES `tb_organization_companies` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='부서 리스트';

-- 테이블 데이터 community.tb_organization_departments:~6 rows (대략적) 내보내기
INSERT INTO `tb_organization_departments` (`id`, `company_id`, `name`, `description`, `created_at`, `updated_at`) VALUES
	(4, 8, '경영지원본부', NULL, '2025-11-13 02:24:06', '2025-12-03 00:06:24'),
	(5, 8, '영업본부', NULL, '2025-11-13 14:02:52', '2025-12-03 00:06:51'),
	(18, 8, '마케팅본부', NULL, '2025-12-03 00:07:32', '2025-12-03 00:07:32'),
	(19, 8, '연구개발(R&D)본부', NULL, '2025-12-03 00:08:05', '2025-12-03 00:08:05'),
	(20, 8, '생산본부', NULL, '2025-12-03 00:08:25', '2025-12-03 00:08:25'),
	(21, 8, 'IT본부', NULL, '2025-12-03 00:08:44', '2025-12-03 00:08:44');

-- 테이블 community.tb_organization_locations 구조 내보내기
CREATE TABLE IF NOT EXISTS `tb_organization_locations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
  `name` varchar(255) NOT NULL COMMENT '지역 이름',
  `description` varchar(255) DEFAULT NULL COMMENT '지역 설명',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='지역 리스트';

-- 테이블 데이터 community.tb_organization_locations:~0 rows (대략적) 내보내기

-- 테이블 community.tb_organization_positions 구조 내보내기
CREATE TABLE IF NOT EXISTS `tb_organization_positions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
  `name` varchar(255) NOT NULL COMMENT '직책 이름',
  `description` varchar(255) DEFAULT NULL COMMENT '직책 설명',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='직책 리스트';

-- 테이블 데이터 community.tb_organization_positions:~12 rows (대략적) 내보내기
INSERT INTO `tb_organization_positions` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES
	(7, '팀원', NULL, '2025-11-14 00:38:59', '2025-12-03 00:09:17'),
	(8, '담당자', NULL, '2025-11-14 01:00:56', '2025-12-03 00:09:22'),
	(9, '실무 리더', NULL, '2025-11-14 01:01:00', '2025-12-03 00:09:28'),
	(10, '프로젝트 매니저', NULL, '2025-12-03 00:09:34', '2025-12-03 00:09:34'),
	(11, '팀장', NULL, '2025-12-03 00:09:38', '2025-12-03 00:09:38'),
	(12, '본부장', NULL, '2025-12-03 00:09:42', '2025-12-03 00:09:42'),
	(13, 'CEO', '최고 경영자', '2025-12-03 00:09:45', '2025-12-03 00:11:17'),
	(14, 'CTO', '최고 기술경영자', '2025-12-03 00:09:49', '2025-12-03 00:11:19'),
	(15, 'CFO', '최고 재무관리자', '2025-12-03 00:11:14', '2025-12-03 00:11:23'),
	(16, 'COO', '최고 운영책임자', '2025-12-03 00:11:38', '2025-12-03 00:11:38'),
	(17, 'CIO', '최고 정보관리책임자', '2025-12-03 00:11:49', '2025-12-03 00:11:49'),
	(18, '파트장', NULL, '2025-12-03 00:11:54', '2025-12-03 00:11:54');

-- 테이블 community.tb_organization_privileges 구조 내보내기
CREATE TABLE IF NOT EXISTS `tb_organization_privileges` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '권한 ID',
  `name` varchar(255) NOT NULL COMMENT '권한 이름',
  `description` varchar(255) DEFAULT NULL COMMENT '권한 설명',
  `auth_level` int(10) unsigned NOT NULL DEFAULT 0,
  `auth_post` enum('no','user','staff','admin') DEFAULT 'user',
  `auth_chat` enum('no','user','staff','admin') DEFAULT 'no',
  `auth_project` enum('no','user','staff','admin') DEFAULT 'no',
  `auth_customer` enum('no','user','staff','admin') DEFAULT 'no',
  `auth_product` enum('no','user','staff','admin') DEFAULT 'no',
  `auth_employee` enum('no','user','staff','admin') DEFAULT 'no',
  `auth_system` enum('no','user','staff','admin') DEFAULT 'no',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='권한';

-- 테이블 데이터 community.tb_organization_privileges:~1 rows (대략적) 내보내기
INSERT INTO `tb_organization_privileges` (`id`, `name`, `description`, `auth_level`, `auth_post`, `auth_chat`, `auth_project`, `auth_customer`, `auth_product`, `auth_employee`, `auth_system`, `created_at`, `updated_at`) VALUES
	(2, 'admin', NULL, 9, 'admin', 'admin', 'admin', 'admin', 'admin', 'admin', 'admin', '2025-12-08 12:25:14', '2025-12-08 12:25:14');

-- 테이블 community.tb_organization_ranks 구조 내보내기
CREATE TABLE IF NOT EXISTS `tb_organization_ranks` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
  `name` varchar(255) NOT NULL COMMENT '직급 이름',
  `description` varchar(255) DEFAULT NULL COMMENT '직급 설명',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='직급 리스트';

-- 테이블 데이터 community.tb_organization_ranks:~12 rows (대략적) 내보내기
INSERT INTO `tb_organization_ranks` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES
	(11, '사원', NULL, '2025-11-13 14:03:48', '2025-11-13 14:03:48'),
	(12, '주임', NULL, '2025-11-14 00:36:42', '2025-11-14 00:36:42'),
	(13, '대리', NULL, '2025-11-14 00:39:11', '2025-11-14 00:39:11'),
	(14, '과장', NULL, '2025-11-14 00:39:16', '2025-11-14 00:39:16'),
	(15, '차장', NULL, '2025-11-14 00:39:19', '2025-11-14 00:39:26'),
	(16, '부장', '', '2025-11-14 00:41:44', '2025-11-14 00:52:38'),
	(18, '이사', '', '2025-11-14 01:00:27', '2025-12-03 00:14:57'),
	(19, '상무', '', '2025-12-03 00:12:48', '2025-12-03 00:12:58'),
	(20, '전무', NULL, '2025-12-03 00:13:02', '2025-12-03 00:13:02'),
	(21, '대표이사', NULL, '2025-12-03 00:13:07', '2025-12-03 00:13:07'),
	(22, '사장', NULL, '2025-12-03 00:13:13', '2025-12-03 00:13:13'),
	(23, '회장', NULL, '2025-12-03 00:13:32', '2025-12-03 00:13:32');

-- 테이블 community.tb_organization_roles 구조 내보내기
CREATE TABLE IF NOT EXISTS `tb_organization_roles` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
  `name` varchar(255) NOT NULL COMMENT '역할 이름',
  `description` varchar(255) DEFAULT NULL COMMENT '역할 설명',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='역할 리스트';

-- 테이블 데이터 community.tb_organization_roles:~15 rows (대략적) 내보내기
INSERT INTO `tb_organization_roles` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES
	(12, 'CS 개발', NULL, '2025-11-14 00:39:04', '2025-11-14 00:39:04'),
	(13, '백엔드 개발', NULL, '2025-11-14 01:01:21', '2025-11-14 01:01:21'),
	(14, '프론트 개발', NULL, '2025-11-14 01:01:27', '2025-11-14 01:01:27'),
	(15, '갤럭시 개발', NULL, '2025-11-14 01:01:39', '2025-11-14 01:01:39'),
	(16, '아이폰 개발', NULL, '2025-11-14 01:01:43', '2025-11-14 01:01:43'),
	(17, '펌웨어 개발', NULL, '2025-11-14 01:01:56', '2025-11-14 01:01:56'),
	(18, '퍼플리셔', NULL, '2025-11-14 01:02:09', '2025-11-14 01:02:09'),
	(19, '디자이너', NULL, '2025-11-14 01:02:14', '2025-11-14 01:02:14'),
	(20, '기획', NULL, '2025-11-14 01:02:18', '2025-11-14 01:02:18'),
	(21, '재무', NULL, '2025-12-03 00:14:11', '2025-12-03 00:14:11'),
	(22, '회계', NULL, '2025-12-03 00:14:16', '2025-12-03 00:14:16'),
	(23, '생산', NULL, '2025-12-03 00:14:19', '2025-12-03 00:14:19'),
	(24, '영업', NULL, '2025-12-03 00:15:34', '2025-12-03 00:15:34'),
	(25, '개발', NULL, '2025-12-03 00:15:42', '2025-12-03 00:15:42'),
	(26, '고문', NULL, '2025-12-03 00:16:00', '2025-12-03 00:16:00');

-- 테이블 community.tb_organization_teams 구조 내보내기
CREATE TABLE IF NOT EXISTS `tb_organization_teams` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
  `department_id` int(10) unsigned NOT NULL COMMENT '부서 ID',
  `name` varchar(255) NOT NULL COMMENT '팀 이름',
  `description` varchar(255) DEFAULT NULL COMMENT '팀 설명',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
  PRIMARY KEY (`id`),
  UNIQUE KEY `department_id` (`department_id`,`name`),
  KEY `FK_tb_organization_teams_tb_organization_departments` (`department_id`),
  CONSTRAINT `FK_tb_organization_teams_tb_organization_departments` FOREIGN KEY (`department_id`) REFERENCES `tb_organization_departments` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='팀 리스트';

-- 테이블 데이터 community.tb_organization_teams:~18 rows (대략적) 내보내기
INSERT INTO `tb_organization_teams` (`id`, `department_id`, `name`, `description`, `created_at`, `updated_at`) VALUES
	(7, 4, '인사팀', NULL, '2025-11-13 02:24:15', '2025-12-03 00:06:30'),
	(16, 4, '총무팀', NULL, '2025-12-03 00:06:36', '2025-12-03 00:06:36'),
	(17, 4, '재무회계팀', NULL, '2025-12-03 00:06:41', '2025-12-03 00:06:41'),
	(18, 5, '국내영업팀', NULL, '2025-12-03 00:07:03', '2025-12-03 00:07:03'),
	(19, 5, '해외영업팀', NULL, '2025-12-03 00:07:09', '2025-12-03 00:07:09'),
	(20, 5, '영업기획팀', NULL, '2025-12-03 00:07:16', '2025-12-03 00:07:16'),
	(21, 18, '브랜드팀', NULL, '2025-12-03 00:07:38', '2025-12-03 00:07:38'),
	(22, 18, '디지털마케팅팀', NULL, '2025-12-03 00:07:42', '2025-12-03 00:07:42'),
	(23, 18, '고객관리(CRM)팀', NULL, '2025-12-03 00:07:52', '2025-12-03 00:07:52'),
	(24, 19, '제품개발팀', NULL, '2025-12-03 00:08:11', '2025-12-03 00:08:11'),
	(25, 19, '품질관리팀', NULL, '2025-12-03 00:08:16', '2025-12-03 00:08:16'),
	(26, 19, '기술지원팀', NULL, '2025-12-03 00:08:19', '2025-12-03 00:08:19'),
	(27, 20, '생산관리팀', NULL, '2025-12-03 00:08:31', '2025-12-03 00:08:31'),
	(28, 20, '구매/자재팀', NULL, '2025-12-03 00:08:35', '2025-12-03 00:08:35'),
	(29, 20, '물류팀', NULL, '2025-12-03 00:08:38', '2025-12-03 00:08:38'),
	(30, 21, '시스템운영팀', NULL, '2025-12-03 00:08:49', '2025-12-03 00:08:49'),
	(31, 21, '개발팀', NULL, '2025-12-03 00:08:54', '2025-12-03 00:08:54'),
	(32, 21, '보안팀', NULL, '2025-12-03 00:08:58', '2025-12-03 00:08:58');

-- 테이블 community.tb_posts 구조 내보내기
CREATE TABLE IF NOT EXISTS `tb_posts` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
  `post_category_id` int(10) unsigned NOT NULL,
  `employee_id` int(10) unsigned NOT NULL COMMENT '작성자 직원 ID',
  `title` varchar(255) NOT NULL COMMENT '게시글 제목',
  `content` text NOT NULL COMMENT '게시글 내용',
  `view_count` int(10) unsigned NOT NULL DEFAULT 0 COMMENT '조회 수',
  `comments` int(10) unsigned NOT NULL DEFAULT 0 COMMENT '댓글 수',
  `comment_at` timestamp NULL DEFAULT NULL COMMENT '마지막 댓글 생성시각',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
  `deleted_at` timestamp NULL DEFAULT NULL COMMENT '레코드 삭제시각',
  PRIMARY KEY (`id`),
  KEY `FK_tb_posts_tb_employees` (`employee_id`),
  KEY `FK_tb_posts_tb_post_category` (`post_category_id`),
  CONSTRAINT `FK_tb_posts_tb_employees` FOREIGN KEY (`employee_id`) REFERENCES `tb_employees` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_tb_posts_tb_post_category` FOREIGN KEY (`post_category_id`) REFERENCES `tb_post_category` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=68 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='게시글 리스트';

-- 테이블 데이터 community.tb_posts:~36 rows (대략적) 내보내기
INSERT INTO `tb_posts` (`id`, `post_category_id`, `employee_id`, `title`, `content`, `view_count`, `comments`, `comment_at`, `created_at`, `updated_at`, `deleted_at`) VALUES
	(32, 7, 13, '새 글', '본문', 0, 0, NULL, '2025-11-11 11:17:34', '2025-11-11 11:17:34', NULL),
	(33, 7, 13, '새 글', '본문', 0, 0, NULL, '2025-11-11 11:17:34', '2025-11-11 11:17:34', NULL),
	(34, 7, 13, '새 글', '본문', 0, 0, NULL, '2025-11-11 11:17:34', '2025-11-11 11:17:34', NULL),
	(35, 7, 13, '새 글', '본문', 0, 0, NULL, '2025-11-11 11:17:34', '2025-11-11 11:17:34', NULL),
	(36, 7, 13, '새 글', '본문', 0, 0, NULL, '2025-11-11 11:17:34', '2025-11-11 11:17:34', NULL),
	(37, 7, 13, '새 글', '본문', 0, 0, NULL, '2025-11-11 11:17:35', '2025-11-11 11:17:35', NULL),
	(38, 7, 13, '새 글', '본문', 0, 0, NULL, '2025-11-11 11:17:35', '2025-11-11 11:17:35', NULL),
	(39, 7, 13, '새 글', '본문', 0, 0, NULL, '2025-11-11 11:17:35', '2025-11-11 11:17:35', NULL),
	(40, 7, 13, '새 글', '본문', 0, 0, NULL, '2025-11-11 11:17:35', '2025-11-11 11:17:35', NULL),
	(41, 7, 13, '새 글', '본문', 0, 0, NULL, '2025-11-11 11:17:35', '2025-11-11 11:17:35', NULL),
	(42, 7, 13, '새 글', '본문', 0, 0, NULL, '2025-11-11 11:17:35', '2025-11-11 11:17:35', NULL),
	(43, 7, 13, '새 글', '본문', 0, 0, NULL, '2025-11-11 11:17:36', '2025-11-11 11:17:36', NULL),
	(44, 7, 13, '새 글', '본문', 0, 0, NULL, '2025-11-11 11:17:36', '2025-11-11 11:17:36', NULL),
	(45, 7, 13, '새 글', '본문', 0, 0, NULL, '2025-11-11 11:17:36', '2025-11-11 11:17:36', NULL),
	(46, 7, 13, '새 글', '본문', 0, 0, NULL, '2025-11-11 11:17:36', '2025-11-11 11:17:36', NULL),
	(47, 7, 13, '새 글', '본문', 0, 0, NULL, '2025-11-11 11:17:36', '2025-11-11 11:17:36', NULL),
	(48, 7, 13, '새 글', '본문', 0, 0, NULL, '2025-11-11 11:17:36', '2025-11-11 11:17:36', NULL),
	(49, 7, 13, '새 글', '본문', 0, 0, NULL, '2025-11-11 11:17:36', '2025-11-11 11:17:36', NULL),
	(50, 7, 13, '새 글', '본문', 0, 0, NULL, '2025-11-11 11:17:37', '2025-11-11 11:17:37', NULL),
	(51, 7, 13, '새 글', '본문', 0, 0, NULL, '2025-11-11 11:17:37', '2025-11-11 11:17:37', NULL),
	(52, 7, 13, '새 글', '본문', 0, 0, NULL, '2025-11-11 11:17:37', '2025-11-11 11:17:37', NULL),
	(53, 7, 13, '새 글', '본문', 0, 0, NULL, '2025-11-11 11:17:37', '2025-11-11 11:17:37', NULL),
	(54, 7, 13, '새 글', '본문', 0, 0, NULL, '2025-11-11 11:17:37', '2025-11-11 11:17:37', NULL),
	(55, 7, 13, '새 글', '본문', 0, 0, NULL, '2025-11-11 11:17:37', '2025-11-11 11:17:37', NULL),
	(56, 7, 13, '새 글', '본문', 0, 0, NULL, '2025-11-11 11:17:38', '2025-11-11 11:17:38', NULL),
	(57, 7, 13, '새 글', '본문', 0, 0, NULL, '2025-11-11 11:17:38', '2025-11-11 11:17:38', NULL),
	(58, 7, 13, '새 글', '본문', 0, 0, NULL, '2025-11-11 11:17:38', '2025-11-11 11:17:38', NULL),
	(59, 8, 13, '자유게시판1 첫 글입니다.', '안녕하세요', 0, 0, NULL, '2025-11-13 06:48:11', '2025-11-13 06:48:11', NULL),
	(60, 8, 13, '자유게시판1 첫 글입니다.', '안녕하세요', 0, 0, NULL, '2025-11-13 06:48:57', '2025-11-13 06:48:57', NULL),
	(61, 8, 13, '자유게시판1 첫 글입니다.', '안녕하세요', 0, 0, NULL, '2025-11-13 06:50:32', '2025-11-13 06:50:32', NULL),
	(62, 9, 13, '댓글이 없는 자유게시판2', '자유게시판2', 0, 0, NULL, '2025-11-13 06:51:54', '2025-11-13 09:24:35', NULL),
	(63, 10, 13, '댓글이 없는 자유게시판', '내용', 0, 0, NULL, '2025-11-13 06:53:58', '2025-11-13 09:24:07', NULL),
	(64, 7, 13, '댓글이 많은 자유게시판', '본문입니다', 0, 0, NULL, '2025-11-13 06:55:35', '2025-11-13 09:23:37', NULL),
	(65, 15, 13, '풍속계 개발의뢰', '2030년 2월까지 요청합니다.', 0, 0, NULL, '2025-11-13 07:03:59', '2025-11-13 07:03:59', NULL),
	(66, 7, 13, '새로운 게시글', '내용은 ...', 0, 0, NULL, '2025-11-19 06:14:46', '2025-11-19 06:14:46', NULL),
	(67, 7, 13, '새 게시글2', '내용 없음', 0, 0, NULL, '2025-11-19 06:16:12', '2025-11-19 06:16:12', NULL);

-- 테이블 community.tb_post_category 구조 내보내기
CREATE TABLE IF NOT EXISTS `tb_post_category` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `parent_id` int(10) unsigned DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `FK_tb_post_category_tb_post_category` (`parent_id`),
  CONSTRAINT `FK_tb_post_category_tb_post_category` FOREIGN KEY (`parent_id`) REFERENCES `tb_post_category` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 테이블 데이터 community.tb_post_category:~18 rows (대략적) 내보내기
INSERT INTO `tb_post_category` (`id`, `parent_id`, `name`, `description`, `created_at`, `updated_at`) VALUES
	(1, NULL, '공지사항', NULL, '2025-11-11 10:16:30', '2025-12-05 05:24:38'),
	(7, NULL, '자유 게시판', NULL, '2025-11-11 10:12:29', '2025-11-11 11:20:18'),
	(8, 7, '자유게시판1', NULL, '2025-11-11 10:12:41', '2025-11-11 10:12:41'),
	(9, 7, '자유게시판2', NULL, '2025-11-11 10:12:49', '2025-11-11 10:12:49'),
	(10, 7, '자유게시판3', NULL, '2025-11-11 10:12:56', '2025-11-11 10:12:56'),
	(11, NULL, '부서 게시판', NULL, '2025-11-11 10:13:11', '2025-11-11 11:20:21'),
	(12, 11, '마케팅', NULL, '2025-11-11 10:13:28', '2025-11-11 10:13:28'),
	(13, 11, '기획', NULL, '2025-11-11 10:13:38', '2025-11-11 10:13:38'),
	(14, 11, '생산', NULL, '2025-11-11 10:13:49', '2025-11-11 10:13:49'),
	(15, 11, '개발', NULL, '2025-11-11 10:15:20', '2025-11-11 10:15:20'),
	(16, 11, '영업', NULL, '2025-11-11 10:15:29', '2025-11-11 10:15:29'),
	(17, 11, '총무', NULL, '2025-11-11 10:15:58', '2025-11-11 10:15:58'),
	(18, NULL, '고객의 소리', NULL, '2025-11-11 10:16:24', '2025-11-11 10:16:24'),
	(20, 18, '세모전자', NULL, '2025-11-11 10:16:49', '2025-11-11 10:16:49'),
	(21, 18, '동그라미 마트', NULL, '2025-11-11 10:17:31', '2025-11-11 10:17:31'),
	(22, 18, '네모 호텔&리조트', NULL, '2025-11-11 10:17:48', '2025-11-11 10:17:54'),
	(23, NULL, '신규 게시판', NULL, '2025-11-13 06:05:49', '2025-11-13 06:05:49'),
	(24, NULL, '마감 게시판', NULL, '2025-11-13 06:06:43', '2025-11-13 06:06:43');

-- 테이블 community.tb_post_comments 구조 내보내기
CREATE TABLE IF NOT EXISTS `tb_post_comments` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
  `post_id` int(10) unsigned NOT NULL COMMENT '게시글 ID',
  `employee_id` int(10) unsigned NOT NULL COMMENT '작성자 직원 ID',
  `content` varchar(255) NOT NULL COMMENT '댓글 내용',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
  `deleted_at` timestamp NULL DEFAULT NULL COMMENT '레코드 삭제시각',
  PRIMARY KEY (`id`),
  KEY `FK_tb_post_comments_tb_posts` (`post_id`),
  KEY `FK_tb_post_comments_tb_employees` (`employee_id`),
  CONSTRAINT `FK_tb_post_comments_tb_employees` FOREIGN KEY (`employee_id`) REFERENCES `tb_employees` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_tb_post_comments_tb_posts` FOREIGN KEY (`post_id`) REFERENCES `tb_posts` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='게시글 별 댓글';

-- 테이블 데이터 community.tb_post_comments:~15 rows (대략적) 내보내기
INSERT INTO `tb_post_comments` (`id`, `post_id`, `employee_id`, `content`, `created_at`, `updated_at`, `deleted_at`) VALUES
	(1, 64, 13, '123', '2025-11-13 08:47:18', '2025-11-13 08:47:18', NULL),
	(2, 64, 13, '123', '2025-11-13 08:50:52', '2025-11-13 08:50:52', NULL),
	(3, 64, 13, '123', '2025-11-13 08:51:13', '2025-11-13 08:51:13', NULL),
	(4, 64, 13, '123', '2025-11-13 08:51:46', '2025-11-13 08:51:46', NULL),
	(5, 64, 13, '123', '2025-11-13 08:52:14', '2025-11-13 08:52:14', NULL),
	(6, 64, 13, '123', '2025-11-13 08:54:14', '2025-11-13 08:54:14', NULL),
	(7, 64, 13, '123', '2025-11-13 08:55:00', '2025-11-13 08:55:00', NULL),
	(8, 64, 13, '123', '2025-11-13 08:56:35', '2025-11-13 08:56:35', NULL),
	(9, 64, 13, '123', '2025-11-13 08:59:03', '2025-11-13 08:59:03', NULL),
	(10, 64, 13, '123', '2025-11-13 09:05:35', '2025-11-13 09:05:35', NULL),
	(11, 64, 13, '123', '2025-11-13 09:06:01', '2025-11-13 09:06:01', NULL),
	(12, 64, 13, '123', '2025-11-13 09:06:34', '2025-11-13 09:06:34', NULL),
	(13, 64, 13, '3214dfgd sgf ', '2025-11-13 09:06:58', '2025-11-13 09:06:58', NULL),
	(14, 64, 13, 'fv 23v f3f', '2025-11-13 09:07:00', '2025-11-13 09:07:00', NULL),
	(15, 64, 13, '1. 자유게시판 어쩌구\r\n2. 제임슨 어쩌구\r\n3. 이 댓글은 어쩌구 저쩌구\r\n4. 그래서 이렇게 해주세요!', '2025-11-13 09:12:02', '2025-11-13 09:12:02', NULL);

-- 테이블 community.tb_products 구조 내보내기
CREATE TABLE IF NOT EXISTS `tb_products` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
  `name` varchar(255) NOT NULL COMMENT '제품 이름',
  `content` text DEFAULT NULL COMMENT '제품 상세 설명',
  `description` varchar(255) DEFAULT NULL COMMENT '제품 간단 설명',
  `image_path` varchar(255) DEFAULT NULL COMMENT '제품 사진 경로 또는 URL',
  `total_count` int(10) unsigned NOT NULL DEFAULT 0 COMMENT '제품 재고 수량',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
  `deleted_at` timestamp NULL DEFAULT NULL COMMENT '레코드 삭제시각',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='제품 리스트';

-- 테이블 데이터 community.tb_products:~0 rows (대략적) 내보내기

-- 테이블 community.tb_product_inventory 구조 내보내기
CREATE TABLE IF NOT EXISTS `tb_product_inventory` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
  `product_id` int(10) unsigned NOT NULL COMMENT '제품 ID',
  `from_employee_id` int(10) unsigned DEFAULT NULL COMMENT '입출고 직원 ID',
  `to_employee_id` int(10) unsigned DEFAULT NULL COMMENT '요청 직원 ID',
  `movement_type` enum('입고','출고') NOT NULL DEFAULT '입고' COMMENT '입출고 구분',
  `movement_count` int(10) NOT NULL COMMENT '입출고 수량',
  `content` varchar(255) DEFAULT NULL COMMENT '입출고 내용',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
  `is_deleted` enum('Y','N') NOT NULL DEFAULT 'N' COMMENT '레코드 삭제 여부',
  PRIMARY KEY (`id`),
  KEY `FK_tb_product_inventory_tb_products` (`product_id`),
  KEY `FK_tb_product_inventory_tb_employees` (`from_employee_id`),
  KEY `FK_tb_product_inventory_tb_employees_2` (`to_employee_id`),
  CONSTRAINT `FK_tb_product_inventory_tb_employees` FOREIGN KEY (`from_employee_id`) REFERENCES `tb_employees` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_tb_product_inventory_tb_employees_2` FOREIGN KEY (`to_employee_id`) REFERENCES `tb_employees` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_tb_product_inventory_tb_products` FOREIGN KEY (`product_id`) REFERENCES `tb_products` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='제품 별 입출고 이력';

-- 테이블 데이터 community.tb_product_inventory:~0 rows (대략적) 내보내기

-- 테이블 community.tb_projects 구조 내보내기
CREATE TABLE IF NOT EXISTS `tb_projects` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
  `customer_id` int(10) unsigned DEFAULT NULL COMMENT '고객사 ID (필요 시)',
  `name` varchar(255) NOT NULL COMMENT '프로젝트 이름',
  `description` varchar(255) DEFAULT NULL COMMENT '프로젝트 설명',
  `progress` int(10) unsigned NOT NULL DEFAULT 0 COMMENT '프로젝트 진행도',
  `start_date` timestamp NULL DEFAULT NULL COMMENT '프로젝트 시작일',
  `end_date` timestamp NULL DEFAULT NULL COMMENT '프로젝트 종료일',
  `status` enum('대기','진행','완료','취소','보류') NOT NULL DEFAULT '대기' COMMENT '프로젝트 상태',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
  `deleted_at` timestamp NULL DEFAULT NULL COMMENT '레코드 삭제시각',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `FK_tb_projects_tb_customers` (`customer_id`),
  CONSTRAINT `FK_tb_projects_tb_customers` FOREIGN KEY (`customer_id`) REFERENCES `tb_customers` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='프로젝트 리스트';

-- 테이블 데이터 community.tb_projects:~6 rows (대략적) 내보내기
INSERT INTO `tb_projects` (`id`, `customer_id`, `name`, `description`, `progress`, `start_date`, `end_date`, `status`, `created_at`, `updated_at`, `deleted_at`) VALUES
	(37, NULL, '태양광 제어 시스템 개발', '데스크탑 프로그램', 0, '2025-11-18 03:37:35', '2025-11-30 03:37:51', '대기', '2025-11-18 03:35:15', '2025-11-18 03:37:57', NULL),
	(38, NULL, '제습기 모바일 제어', '갤럭시/iOS 앱', 12, '2025-03-18 03:37:39', '2025-12-01 03:37:47', '진행', '2025-11-18 03:37:31', '2025-11-18 05:08:31', NULL),
	(39, NULL, '한전 연계 전기 검진기계 수정', NULL, 50, '2025-11-20 03:39:44', '2026-04-05 03:39:51', '대기', '2025-11-18 03:39:16', '2025-11-18 03:40:01', NULL),
	(41, NULL, '수도검침 모듈 개선', '기기,앱 연계', 100, '2025-01-05 05:08:51', '2025-05-13 05:09:00', '완료', '2025-11-18 05:09:47', '2025-11-18 05:09:47', NULL),
	(56, 1, '아이스크림 만들기 프로젝트', NULL, 30, '2025-02-11 15:00:00', '2025-11-26 15:00:00', '보류', '2025-12-03 11:41:45', '2025-12-03 11:41:45', NULL),
	(57, 1, '신규 립스틱 판촉 광고', NULL, 55, '2025-07-09 15:00:00', '2025-10-22 15:00:00', '취소', '2025-12-03 11:42:19', '2025-12-03 11:42:19', NULL);

-- 테이블 community.tb_project_members 구조 내보내기
CREATE TABLE IF NOT EXISTS `tb_project_members` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
  `project_id` int(10) unsigned NOT NULL COMMENT '프로젝트 ID',
  `employee_id` int(10) unsigned NOT NULL COMMENT '프로젝트 직원 ID',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
  PRIMARY KEY (`id`),
  KEY `FK_tb_project_members_tb_projects` (`project_id`),
  KEY `FK_tb_project_members_tb_employees` (`employee_id`),
  CONSTRAINT `FK_tb_project_members_tb_employees` FOREIGN KEY (`employee_id`) REFERENCES `tb_employees` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `FK_tb_project_members_tb_projects` FOREIGN KEY (`project_id`) REFERENCES `tb_projects` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='프로젝트 별 멤버';

-- 테이블 데이터 community.tb_project_members:~0 rows (대략적) 내보내기

-- 테이블 community.tb_project_tasks 구조 내보내기
CREATE TABLE IF NOT EXISTS `tb_project_tasks` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
  `project_id` int(10) unsigned NOT NULL COMMENT '프로젝트 ID',
  `task_no` int(10) NOT NULL DEFAULT 0,
  `name` varchar(255) NOT NULL COMMENT '프로젝트 이름',
  `description` varchar(255) DEFAULT NULL COMMENT '프로젝트 설명',
  `progress` int(10) unsigned NOT NULL DEFAULT 0 COMMENT '프로젝트 작업 진행도',
  `start_date` timestamp NULL DEFAULT NULL COMMENT '프로젝트 작업 시작일',
  `end_date` timestamp NULL DEFAULT NULL COMMENT '프로젝트 작업 종료일',
  `status` enum('대기','진행','완료','취소','보류') NOT NULL DEFAULT '대기' COMMENT '프로젝트 작업 상태',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
  PRIMARY KEY (`id`),
  KEY `FK_tb_project_tasks_tb_projects` (`project_id`),
  CONSTRAINT `FK_tb_project_tasks_tb_projects` FOREIGN KEY (`project_id`) REFERENCES `tb_projects` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='프로젝트 별 작업';

-- 테이블 데이터 community.tb_project_tasks:~1 rows (대략적) 내보내기
INSERT INTO `tb_project_tasks` (`id`, `project_id`, `task_no`, `name`, `description`, `progress`, `start_date`, `end_date`, `status`, `created_at`, `updated_at`) VALUES
	(1, 38, 0, '모바일앱', '갤럭시', 12, '2025-05-18 08:02:18', '2025-08-18 08:02:19', '진행', '2025-11-18 08:02:25', '2025-11-18 08:03:07');

-- 테이블 community.tb_project_task_members 구조 내보내기
CREATE TABLE IF NOT EXISTS `tb_project_task_members` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
  `project_task_id` int(10) unsigned NOT NULL COMMENT '프로젝트 작업 ID',
  `employee_id` int(10) unsigned NOT NULL COMMENT '프로젝트 작업 직원 ID',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
  PRIMARY KEY (`id`),
  KEY `FK_tb_project_task_members_tb_project_members` (`employee_id`) USING BTREE,
  KEY `FK_tb_project_task_members_tb_project_tasks` (`project_task_id`) USING BTREE,
  CONSTRAINT `FK_tb_project_task_members_tb_employees` FOREIGN KEY (`employee_id`) REFERENCES `tb_employees` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `FK_tb_project_task_members_tb_project_tasks` FOREIGN KEY (`project_task_id`) REFERENCES `tb_project_tasks` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='프로젝트 별 작업 멤버';

-- 테이블 데이터 community.tb_project_task_members:~0 rows (대략적) 내보내기

-- 테이블 community.tb_system_config 구조 내보내기
CREATE TABLE IF NOT EXISTS `tb_system_config` (
  `id` int(10) unsigned NOT NULL COMMENT '레코드 ID',
  `name` varchar(255) NOT NULL COMMENT '레코드 이름',
  `value_number` int(10) unsigned DEFAULT NULL COMMENT '숫자형태 상태값',
  `value_text` varchar(255) DEFAULT NULL COMMENT '문자형태 상태값',
  `description` varchar(255) DEFAULT NULL COMMENT '레코드 설명',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='시스템 정보';

-- 테이블 데이터 community.tb_system_config:~15 rows (대략적) 내보내기
INSERT INTO `tb_system_config` (`id`, `name`, `value_number`, `value_text`, `description`, `created_at`, `updated_at`) VALUES
	(1, '총 게시글 수', 30023, NULL, NULL, '2025-11-12 14:35:40', '2025-11-12 14:35:40'),
	(2, '총 댓글 수', 12333, NULL, NULL, '2025-11-12 14:35:40', '2025-11-12 14:35:40'),
	(3, '활성 사용자 수 (최근 24시간)', 132, NULL, NULL, '2025-11-12 14:35:40', '2025-11-12 14:35:40'),
	(4, '총 프로젝트 수', 12323, NULL, NULL, '2025-11-12 14:35:40', '2025-11-12 14:35:40'),
	(5, '총 고객사 수', 123, NULL, NULL, '2025-11-12 14:35:40', '2025-11-12 14:35:40'),
	(6, '총 제품 수', 5525, NULL, NULL, '2025-11-12 14:35:40', '2025-11-12 14:35:40'),
	(7, '총 직원 수', 465, NULL, NULL, '2025-11-12 14:35:40', '2025-11-12 14:35:40'),
	(8, '시스템 접속 로그 수', 232, NULL, NULL, '2025-11-12 14:35:40', '2025-11-12 14:35:40'),
	(9, '프로그램 테마', NULL, '기본', NULL, '2025-11-12 14:35:40', '2025-11-12 14:35:40'),
	(400, '서버 CPU', 30, NULL, NULL, '2025-11-12 14:35:40', '2025-11-12 14:35:40'),
	(401, '서버 GPU', 7, NULL, NULL, '2025-11-12 14:35:40', '2025-11-12 14:35:40'),
	(402, '서버 RAM', 56, NULL, NULL, '2025-11-12 14:35:40', '2025-11-12 14:35:40'),
	(403, '최근 백업 일시', NULL, '2025-11-12', NULL, '2025-11-12 14:35:40', '2025-11-12 14:35:40'),
	(404, '에러 로그 수', 12, NULL, NULL, '2025-11-12 14:35:40', '2025-11-12 14:35:40'),
	(405, '업타임', 7239, NULL, NULL, '2025-11-12 14:35:40', '2025-11-12 14:35:40');

-- 테이블 community.tb_system_logs 구조 내보내기
CREATE TABLE IF NOT EXISTS `tb_system_logs` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
  `category` varchar(50) DEFAULT NULL COMMENT '로그 구분',
  `message` varchar(255) NOT NULL COMMENT '로그 내용',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='시스템 로그';

-- 테이블 데이터 community.tb_system_logs:~33 rows (대략적) 내보내기
INSERT INTO `tb_system_logs` (`id`, `category`, `message`, `created_at`) VALUES
	(1, 'normal', 'add post 0, 새로운 게시글', '2025-11-19 06:14:46'),
	(2, 'normal', 'add post 0, 새 게시글2', '2025-11-19 06:16:12'),
	(3, 'normal', 'add customer 0, 00마케팅', '2025-11-26 04:03:43'),
	(4, 'normal', 'add customer 0, 00전자', '2025-11-26 05:04:15'),
	(9, 'project', '새 프로젝트: 00프로젝트', '2025-11-27 04:30:08'),
	(10, 'project', '새 프로젝트: 00 핸드폰 신규 개발', '2025-11-27 05:18:38'),
	(11, 'project', '새 프로젝트: 00 핸드폰 신규 개발', '2025-11-27 05:19:17'),
	(12, 'project', '새 프로젝트: 00 핸드폰 신규 개발', '2025-11-27 05:19:43'),
	(13, 'project', '새 프로젝트: 00 핸드폰 신규 개발', '2025-11-27 05:20:01'),
	(14, 'project', '새 프로젝트: 00 핸드폰 신규 개발', '2025-11-27 05:51:03'),
	(15, 'project', '새 프로젝트: 00 핸드폰 신규 개발', '2025-11-27 05:53:03'),
	(17, 'project', '새 프로젝트: 123', '2025-11-27 11:59:47'),
	(19, 'employee', '새 직원: 직원명', '2025-11-11 05:15:04'),
	(20, 'employee', '새 직원: 직원명', '2025-11-11 05:15:04'),
	(21, 'employee', '새 직원: 직원명', '2025-11-11 05:15:04'),
	(22, 'employee', '새 직원: 직원명', '2025-11-11 05:15:04'),
	(23, 'employee', '새 직원: 직원명', '2025-11-11 05:15:04'),
	(24, 'employee', '새 직원: 직원명', '2025-11-11 05:15:04'),
	(25, 'employee', '새 직원: 직원명', '2025-11-11 05:15:04'),
	(26, 'employee', '새 직원: 직원명', '2025-11-11 05:15:04'),
	(27, 'employee', '새 직원: 직원명', '2025-11-11 05:15:04'),
	(28, 'employee', '새 직원: 직원명', '2025-11-11 05:15:04'),
	(29, 'employee', '새 직원: 직원명', '2025-11-11 05:15:04'),
	(30, 'employee', '새 직원: 직원명', '2025-11-11 05:15:04'),
	(31, 'employee', '새 직원: 직원명', '2025-11-11 05:15:04'),
	(32, 'employee', '새 직원: 직원명', '2025-11-11 05:15:04'),
	(33, 'project', '새 프로젝트: 아이스크림 만들기 프로젝트', '2025-12-03 11:41:45'),
	(34, 'project', '새 프로젝트: 신규 립스틱 판촉 광고', '2025-12-03 11:42:19'),
	(35, 'employee', '새 직원: 234', '2025-12-05 05:42:19'),
	(36, 'employee', '새 직원: 홍길동', '2025-12-05 05:43:21'),
	(43, 'employee', '새 직원: 강남진', '2025-12-09 02:35:33'),
	(44, 'employee', '새 직원: 테스트직원', '2025-12-09 08:14:06'),
	(45, 'employee', '새 직원: 새 직원', '2025-12-09 08:21:51');

-- 뷰 community.v_comments 구조 내보내기
-- VIEW 종속성 오류를 극복하기 위해 임시 테이블을 생성합니다.
CREATE TABLE `v_comments` (
	`id` INT(10) UNSIGNED NOT NULL COMMENT '레코드 ID',
	`post_id` INT(10) UNSIGNED NOT NULL COMMENT '게시글 ID',
	`employee_id` INT(10) UNSIGNED NOT NULL COMMENT '작성자 직원 ID',
	`employee_name` VARCHAR(1) NULL COMMENT '직원 이름' COLLATE 'utf8mb4_general_ci',
	`content` VARCHAR(1) NOT NULL COMMENT '댓글 내용' COLLATE 'utf8mb4_general_ci',
	`created_at` TIMESTAMP NOT NULL COMMENT '레코드 생성시각',
	`updated_at` TIMESTAMP NOT NULL COMMENT '레코드 수정시각',
	`deleted_at` TIMESTAMP NULL COMMENT '레코드 삭제시각'
);

-- 뷰 community.v_employees 구조 내보내기
-- VIEW 종속성 오류를 극복하기 위해 임시 테이블을 생성합니다.
CREATE TABLE `v_employees` (
	`id` INT(10) UNSIGNED NOT NULL COMMENT '레코드 ID',
	`name` VARCHAR(1) NOT NULL COMMENT '직원 이름' COLLATE 'utf8mb4_general_ci',
	`description` VARCHAR(1) NULL COMMENT '직원 설명' COLLATE 'utf8mb4_general_ci',
	`employee_code` VARCHAR(1) NULL COMMENT '직원 코드 (필요 시)' COLLATE 'utf8mb4_general_ci',
	`employee_type` ENUM('정규직','계약직','인턴','무기계약직','파트타임','파견직','아르바이트','프리랜서','외주') NULL COMMENT '직원 고용유형' COLLATE 'utf8mb4_general_ci',
	`gender` ENUM('남','여','기타') NULL COMMENT '직원 성별' COLLATE 'utf8mb4_general_ci',
	`birth_date` DATE NULL COMMENT '직원 생년월일',
	`email` VARCHAR(1) NULL COMMENT '직원 이메일' COLLATE 'utf8mb4_general_ci',
	`phone` VARCHAR(1) NULL COMMENT '직원 전화번호' COLLATE 'utf8mb4_general_ci',
	`address` VARCHAR(1) NULL COMMENT '직원 자택주소' COLLATE 'utf8mb4_general_ci',
	`image_path` VARCHAR(1) NULL COMMENT '직원 사진 경로 또는 URL' COLLATE 'utf8mb4_general_ci',
	`status` ENUM('재직','휴가','정직','퇴직','대기','계약해지') NULL COMMENT '직원 상태' COLLATE 'utf8mb4_general_ci',
	`joined_at` TIMESTAMP NULL COMMENT '직원 입사일',
	`resigned_at` TIMESTAMP NULL COMMENT '직원 퇴사일',
	`resigned_desc` VARCHAR(1) NULL COMMENT '직원 퇴사사유' COLLATE 'utf8mb4_general_ci',
	`company_id` INT(10) UNSIGNED NULL COMMENT '레코드 ID',
	`company_name` VARCHAR(1) NULL COMMENT '회사 이름' COLLATE 'utf8mb4_general_ci',
	`department_id` INT(10) UNSIGNED NULL COMMENT '레코드 ID',
	`department_name` VARCHAR(1) NULL COMMENT '부서 이름' COLLATE 'utf8mb4_general_ci',
	`team_id` INT(10) UNSIGNED NULL COMMENT '레코드 ID',
	`team_name` VARCHAR(1) NULL COMMENT '팀 이름' COLLATE 'utf8mb4_general_ci',
	`rank_id` INT(10) UNSIGNED NULL COMMENT '레코드 ID',
	`rank_name` VARCHAR(1) NULL COMMENT '직급 이름' COLLATE 'utf8mb4_general_ci',
	`position_id` INT(10) UNSIGNED NULL COMMENT '레코드 ID',
	`position_name` VARCHAR(1) NULL COMMENT '직책 이름' COLLATE 'utf8mb4_general_ci',
	`role_id` INT(10) UNSIGNED NULL COMMENT '레코드 ID',
	`role_name` VARCHAR(1) NULL COMMENT '역할 이름' COLLATE 'utf8mb4_general_ci',
	`privilege_id` INT(10) UNSIGNED NULL COMMENT '권한 ID',
	`privilege_name` VARCHAR(1) NULL COMMENT '권한 이름' COLLATE 'utf8mb4_general_ci',
	`login_id` VARCHAR(1) NULL COMMENT '로그인 ID' COLLATE 'utf8mb4_general_ci',
	`login_pw` VARCHAR(1) NULL COMMENT '로그인 PW' COLLATE 'utf8mb4_general_ci',
	`is_active` ENUM('Y','N') NULL COMMENT '로그인 계정 상태' COLLATE 'utf8mb4_general_ci',
	`created_at` TIMESTAMP NOT NULL COMMENT '레코드 생성시각',
	`updated_at` TIMESTAMP NOT NULL COMMENT '레코드 수정시각',
	`deleted_at` TIMESTAMP NULL COMMENT '레코드 삭제시각'
);

-- 뷰 community.v_employee_attendance 구조 내보내기
-- VIEW 종속성 오류를 극복하기 위해 임시 테이블을 생성합니다.
CREATE TABLE `v_employee_attendance` (
	`id` INT(10) UNSIGNED NULL COMMENT '레코드 ID',
	`employee_id` INT(10) UNSIGNED NOT NULL COMMENT '레코드 ID',
	`name` VARCHAR(1) NOT NULL COMMENT '직원 이름' COLLATE 'utf8mb4_general_ci',
	`employee_code` VARCHAR(1) NULL COMMENT '직원 코드 (필요 시)' COLLATE 'utf8mb4_general_ci',
	`company_id` INT(10) UNSIGNED NULL COMMENT '레코드 ID',
	`company_name` VARCHAR(1) NULL COMMENT '회사 이름' COLLATE 'utf8mb4_general_ci',
	`department_id` INT(10) UNSIGNED NULL COMMENT '레코드 ID',
	`department_name` VARCHAR(1) NULL COMMENT '부서 이름' COLLATE 'utf8mb4_general_ci',
	`team_id` INT(10) UNSIGNED NULL COMMENT '레코드 ID',
	`team_name` VARCHAR(1) NULL COMMENT '팀 이름' COLLATE 'utf8mb4_general_ci',
	`rank_id` INT(10) UNSIGNED NULL COMMENT '레코드 ID',
	`rank_name` VARCHAR(1) NULL COMMENT '직급 이름' COLLATE 'utf8mb4_general_ci',
	`position_id` INT(10) UNSIGNED NULL COMMENT '레코드 ID',
	`position_name` VARCHAR(1) NULL COMMENT '직책 이름' COLLATE 'utf8mb4_general_ci',
	`role_id` INT(10) UNSIGNED NULL COMMENT '레코드 ID',
	`role_name` VARCHAR(1) NULL COMMENT '역할 이름' COLLATE 'utf8mb4_general_ci',
	`privilege_id` INT(10) UNSIGNED NULL COMMENT '권한 ID',
	`privilege_name` VARCHAR(1) NULL COMMENT '권한 이름' COLLATE 'utf8mb4_general_ci',
	`start_work_at` TIMESTAMP NULL COMMENT '출근 시각',
	`end_work_at` TIMESTAMP NULL COMMENT '퇴근 시각',
	`total_work_minutes` TIME NULL,
	`description` VARCHAR(1) NULL COMMENT '비고' COLLATE 'utf8mb4_general_ci',
	`created_at` TIMESTAMP NULL COMMENT '레코드 생성시각',
	`updated_at` TIMESTAMP NULL COMMENT '레코드 수성시각'
);

-- 뷰 community.v_posts 구조 내보내기
-- VIEW 종속성 오류를 극복하기 위해 임시 테이블을 생성합니다.
CREATE TABLE `v_posts` (
	`id` INT(10) UNSIGNED NOT NULL COMMENT '레코드 ID',
	`post_category_id` INT(10) UNSIGNED NOT NULL,
	`post_category_name` VARCHAR(1) NULL COLLATE 'utf8mb4_general_ci',
	`parent_id` INT(10) UNSIGNED NULL,
	`employee_id` INT(10) UNSIGNED NOT NULL COMMENT '작성자 직원 ID',
	`employee_name` VARCHAR(1) NULL COMMENT '직원 이름' COLLATE 'utf8mb4_general_ci',
	`title` VARCHAR(1) NOT NULL COMMENT '게시글 제목' COLLATE 'utf8mb4_general_ci',
	`content` TEXT NOT NULL COMMENT '게시글 내용' COLLATE 'utf8mb4_general_ci',
	`view_count` INT(10) UNSIGNED NOT NULL COMMENT '조회 수',
	`comments` INT(10) UNSIGNED NOT NULL COMMENT '댓글 수',
	`comment_at` TIMESTAMP NULL COMMENT '마지막 댓글 생성시각',
	`created_at` TIMESTAMP NOT NULL COMMENT '레코드 생성시각',
	`updated_at` TIMESTAMP NOT NULL COMMENT '레코드 수정시각',
	`deleted_at` TIMESTAMP NULL COMMENT '레코드 삭제시각'
);

-- 뷰 community.v_projects 구조 내보내기
-- VIEW 종속성 오류를 극복하기 위해 임시 테이블을 생성합니다.
CREATE TABLE `v_projects` (
	`id` INT(10) UNSIGNED NOT NULL COMMENT '레코드 ID',
	`customer_id` INT(10) UNSIGNED NULL COMMENT '고객사 ID (필요 시)',
	`name` VARCHAR(1) NOT NULL COMMENT '프로젝트 이름' COLLATE 'utf8mb4_general_ci',
	`description` VARCHAR(1) NULL COMMENT '프로젝트 설명' COLLATE 'utf8mb4_general_ci',
	`progress` INT(10) UNSIGNED NOT NULL COMMENT '프로젝트 진행도',
	`start_date` TIMESTAMP NULL COMMENT '프로젝트 시작일',
	`end_date` TIMESTAMP NULL COMMENT '프로젝트 종료일',
	`status` ENUM('대기','진행','완료','취소','보류') NOT NULL COMMENT '프로젝트 상태' COLLATE 'utf8mb4_general_ci',
	`created_at` TIMESTAMP NOT NULL COMMENT '레코드 생성시각',
	`updated_at` TIMESTAMP NOT NULL COMMENT '레코드 수정시각',
	`deleted_at` TIMESTAMP NULL COMMENT '레코드 삭제시각'
);

-- 뷰 community.v_project_tasks 구조 내보내기
-- VIEW 종속성 오류를 극복하기 위해 임시 테이블을 생성합니다.
CREATE TABLE `v_project_tasks` (
	`id` INT(10) UNSIGNED NOT NULL COMMENT '레코드 ID',
	`project_id` INT(10) UNSIGNED NOT NULL COMMENT '프로젝트 ID',
	`name` VARCHAR(1) NOT NULL COMMENT '프로젝트 이름' COLLATE 'utf8mb4_general_ci',
	`description` VARCHAR(1) NULL COMMENT '프로젝트 설명' COLLATE 'utf8mb4_general_ci',
	`progress` INT(10) UNSIGNED NOT NULL COMMENT '프로젝트 작업 진행도',
	`start_date` TIMESTAMP NULL COMMENT '프로젝트 작업 시작일',
	`end_date` TIMESTAMP NULL COMMENT '프로젝트 작업 종료일',
	`status` ENUM('대기','진행','완료','취소','보류') NOT NULL COMMENT '프로젝트 작업 상태' COLLATE 'utf8mb4_general_ci',
	`created_at` TIMESTAMP NOT NULL COMMENT '레코드 생성시각',
	`updated_at` TIMESTAMP NOT NULL COMMENT '레코드 수정시각'
);

-- 뷰 community.v_teams 구조 내보내기
-- VIEW 종속성 오류를 극복하기 위해 임시 테이블을 생성합니다.
CREATE TABLE `v_teams` (
	`id` DECIMAL(11,0) NOT NULL,
	`origin_id` DECIMAL(10,0) NOT NULL,
	`depth` INT(1) NOT NULL,
	`name` VARCHAR(1) NOT NULL COLLATE 'utf8mb4_general_ci',
	`description` VARCHAR(1) NULL COLLATE 'utf8mb4_general_ci',
	`created_at` TIMESTAMP NOT NULL,
	`updated_at` TIMESTAMP NOT NULL,
	`parent_id` DECIMAL(11,0) NULL
);

-- 트리거 community.tr_log_insert_chat 구조 내보내기
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `tr_log_insert_chat` BEFORE INSERT ON `tb_chat_rooms` FOR EACH ROW BEGIN
	SET @category = 'chat';
	SET @message = CONCAT('새 채팅방: ', NEW.name);
	SET @created_at = NEW.created_at;
	INSERT INTO tb_system_logs (category, message, created_at) VALUES (@category, @message, @created_at);
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- 트리거 community.tr_log_insert_customer 구조 내보내기
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `tr_log_insert_customer` BEFORE INSERT ON `tb_customers` FOR EACH ROW BEGIN
	SET @category = 'customer';
	SET @message = CONCAT('새 고객사: ', NEW.name);
	SET @created_at = NEW.created_at;
	INSERT INTO tb_system_logs (category, message, created_at) VALUES (@category, @message, @created_at);
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- 트리거 community.tr_log_insert_employee 구조 내보내기
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `tr_log_insert_employee` BEFORE INSERT ON `tb_employees` FOR EACH ROW BEGIN
	SET @category = 'employee';
	SET @message = CONCAT('새 직원: ', NEW.name);
	SET @created_at = NEW.created_at;
	INSERT INTO tb_system_logs (category, message, created_at) VALUES (@category, @message, @created_at);
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- 트리거 community.tr_log_insert_post 구조 내보내기
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `tr_log_insert_post` BEFORE INSERT ON `tb_posts` FOR EACH ROW BEGIN
	SET @post_category = (SELECT IFNULL(c.name, 'None') FROM tb_post_category c  WHERE c.id = NEW.id LIMIT 1);
	SET @category = 'post';
	SET @message = CONCAT('새 게시글: ', '[', @post_category, '] ',  NEW.title);
	SET @created_at = NEW.created_at;
	INSERT INTO tb_system_logs (category, message, created_at) VALUES (@category, @message, @created_at);
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- 트리거 community.tr_log_insert_product 구조 내보내기
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `tr_log_insert_product` BEFORE INSERT ON `tb_products` FOR EACH ROW BEGIN
	SET @category = 'product';
	SET @message = CONCAT('새 제품: ', NEW.name);
	SET @created_at = NEW.created_at;
	INSERT INTO tb_system_logs (category, message, created_at) VALUES (@category, @message, @created_at);
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- 트리거 community.tr_log_insert_project 구조 내보내기
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `tr_log_insert_project` BEFORE INSERT ON `tb_projects` FOR EACH ROW BEGIN
	SET @category = 'project';
	SET @message = CONCAT('새 프로젝트: ', NEW.name);
	SET @created_at = NEW.created_at;
	INSERT INTO tb_system_logs (category, message, created_at) VALUES (@category, @message, @created_at);
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- 임시 테이블을 제거하고 최종 VIEW 구조를 생성
DROP TABLE IF EXISTS `v_comments`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `v_comments` AS SELECT 
	c.id, 
	c.post_id, 
	c.employee_id, 
	e.name AS 'employee_name',
	c.content, 
	c.created_at, 
	c.updated_at, 
	c.deleted_at
FROM tb_post_comments c
	LEFT OUTER JOIN tb_employees e ON c.employee_id = e.id 
;

-- 임시 테이블을 제거하고 최종 VIEW 구조를 생성
DROP TABLE IF EXISTS `v_employees`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `v_employees` AS SELECT 
	e.id, 
	e.`name`, 
	e.`description`,
	e.employee_code,
	e.employee_type,
	e.gender, 
	e.birth_date, 
	e.email, 
	e.phone, 
	e.address, 
	e.image_path,
	e.`status`, 
	e.joined_at, 
	e.resigned_at,
	e.resigned_desc,
	c.id 			AS `company_id`,
	c.`name` 	AS `company_name`,
	d.id 			AS `department_id`,
	d.`name` 	AS `department_name`,
	t.id 			AS `team_id`, 
	t.`name` 	AS `team_name`,
	ra.id 		AS `rank_id`, 
	ra.`name` 	AS `rank_name`,
	po.id 		AS `position_id`, 
	po.`name` 	AS `position_name`,
	ro.id 		AS `role_id`, 
	ro.`name` 	AS `role_name`,
	pr.id 		AS `privilege_id`, 
	pr.`name` 	AS `privilege_name`,
	e.login_id,
	e.login_pw,
	e.is_active,
	e.created_at, 
	e.updated_at, 
	e.deleted_at
FROM tb_employees e
	LEFT OUTER JOIN tb_organization_teams t       ON t.id = e.team_id
	LEFT OUTER JOIN tb_organization_departments d ON d.id = t.department_id
	LEFT OUTER JOIN tb_organization_companies c   ON c.id = d.company_id
	LEFT OUTER JOIN tb_organization_ranks ra      ON ra.id = e.rank_id
	LEFT OUTER JOIN tb_organization_positions po  ON po.id = e.position_id
	LEFT OUTER JOIN tb_organization_roles ro      ON ro.id = e.role_id
	LEFT OUTER JOIN tb_organization_privileges pr ON pr.id = e.privilege_id
ORDER BY e.created_at ASC 
;

-- 임시 테이블을 제거하고 최종 VIEW 구조를 생성
DROP TABLE IF EXISTS `v_employee_attendance`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `v_employee_attendance` AS SELECT 
	a.id,
	e.id AS `employee_id`,
	e.`name`,
	e.employee_code,

	c.id      AS `company_id`,
	c.`name`  AS `company_name`,
	d.id      AS `department_id`,
	d.`name`  AS `department_name`,
	t.id      AS `team_id`,
	t.`name`  AS `team_name`,
	
	ra.id     AS `rank_id`,
	ra.`name` AS `rank_name`,
	po.id     AS `position_id`,
	po.`name` AS `position_name`,
	ro.id     AS `role_id`,
	ro.`name` AS `role_name`,
	pr.id     AS `privilege_id`,
	pr.`name` AS `privilege_name`,

	a.start_work_at,
	a.end_work_at,
	SEC_TO_TIME(a.total_work_minutes * 60) AS `total_work_minutes`,
	a.`description`,
	a.created_at,
	a.updated_at
FROM tb_employees e
	LEFT OUTER JOIN tb_employee_attendance a      ON a.employee_id = e.id
	LEFT OUTER JOIN tb_organization_teams t       ON t.id = e.team_id
	LEFT OUTER JOIN tb_organization_departments d ON d.id = t.department_id
	LEFT OUTER JOIN tb_organization_companies c   ON c.id = d.company_id
	LEFT OUTER JOIN tb_organization_ranks ra      ON ra.id = e.rank_id
	LEFT OUTER JOIN tb_organization_positions po  ON po.id = e.position_id
	LEFT OUTER JOIN tb_organization_roles ro      ON ro.id = e.role_id
	LEFT OUTER JOIN tb_organization_privileges pr ON pr.id = e.privilege_id
WHERE 1 = 1
ORDER BY e.id, e.`name` ASC 
;

-- 임시 테이블을 제거하고 최종 VIEW 구조를 생성
DROP TABLE IF EXISTS `v_posts`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `v_posts` AS SELECT 
	p.id,
	p.post_category_id,
	pc.`name` AS 'post_category_name',
	pc.parent_id,
	p.employee_id,
	e.`name` AS 'employee_name',
	p.title,
	p.content,
	p.view_count,
	p.comments,
	p.comment_at,
	p.created_at,
	p.updated_at,
	p.deleted_at
FROM tb_posts p
	LEFT OUTER JOIN tb_post_category pc ON p.post_category_id = pc.id
	LEFT OUTER JOIN tb_employees e ON p.employee_id	= e.id
WHERE 1 = 1
ORDER BY p.created_at ASC 
;

-- 임시 테이블을 제거하고 최종 VIEW 구조를 생성
DROP TABLE IF EXISTS `v_projects`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `v_projects` AS SELECT 
	p.id,
	p.customer_id,
	p.`name`,
	p.`description`,
	p.progress,
	p.start_date,
	p.end_date,
	p.`status`,
	p.created_at,
	p.updated_at,
	p.deleted_at
FROM tb_projects p
ORDER BY p.updated_at ASC 
;

-- 임시 테이블을 제거하고 최종 VIEW 구조를 생성
DROP TABLE IF EXISTS `v_project_tasks`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `v_project_tasks` AS SELECT 
		t.id,
		t.project_id,
		t.`name`,
		t.`description`,
		t.progress,
		t.start_date,
		t.end_date,
		t.`status`,
		t.created_at,
		t.updated_at
	FROM tb_project_tasks t
		LEFT OUTER JOIN tb_projects p ON p.id = t.project_id
	ORDER BY t.created_at ASC 
;

-- 임시 테이블을 제거하고 최종 VIEW 구조를 생성
DROP TABLE IF EXISTS `v_teams`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `v_teams` AS SELECT 1  AS `id`, 1 AS `origin_id`, 0 AS `depth`, '전체' AS `name`, '' AS `description`, CURRENT_TIMESTAMP() AS `created_at`, CURRENT_TIMESTAMP() AS `updated_at`, NULL AS `parent_id` 
UNION ALL
SELECT c.id + 1000 AS `id`, c.id AS `origin_id`, 1 AS `depth`, c.`name`, c.`description`, c.created_at, c.updated_at, 1 AS `parent_id` 
FROM tb_organization_companies c
UNION ALL
SELECT d.id + 2000 AS `id`, d.id AS `origin_id`, 2 AS `depth`, d.`name`, d.`description`, d.created_at, d.updated_at, d.company_id + 1000 AS `parent_id` 
FROM tb_organization_departments d
UNION ALL 
SELECT t.id + 3000 AS `id`, t.id AS `origin_id`, 3 AS `depth`, t.`name`, t.`description`, t.created_at, t.updated_at, t.department_id + 2000 AS `parent_id` 
FROM tb_organization_teams t 
;

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
