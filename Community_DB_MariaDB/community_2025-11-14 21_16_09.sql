-- --------------------------------------------------------
-- 호스트:                          127.0.0.1
-- 서버 버전:                        11.8.3-MariaDB - mariadb.org binary distribution
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
CREATE DATABASE IF NOT EXISTS `community` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;
USE `community`;

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
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='채팅방 별 멤버';

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='채팅방 별 메시지';

-- 테이블 데이터 community.tb_chat_messages:~0 rows (대략적) 내보내기

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
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
  `deleted_at` timestamp NULL DEFAULT NULL COMMENT '레코드 삭제시각',
  PRIMARY KEY (`id`),
  KEY `FK_tb_customers_tb_organization_locations` (`location_id`),
  CONSTRAINT `FK_tb_customers_tb_organization_locations` FOREIGN KEY (`location_id`) REFERENCES `tb_organization_locations` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='고객 리스트';

-- 테이블 데이터 community.tb_customers:~0 rows (대략적) 내보내기

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

-- 테이블 community.tb_employees 구조 내보내기
CREATE TABLE IF NOT EXISTS `tb_employees` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
  `name` varchar(255) NOT NULL COMMENT '직원 이름',
  `description` varchar(255) DEFAULT NULL COMMENT '직원 설명',
  `employee_code` varchar(255) DEFAULT NULL COMMENT '직원 코드 (필요 시)',
  `gender` enum('남','여','기타') DEFAULT NULL COMMENT '직원 성별',
  `birth_date` date DEFAULT NULL COMMENT '직원 생년월일',
  `email` varchar(255) DEFAULT NULL COMMENT '직원 이메일',
  `phone` varchar(255) DEFAULT NULL COMMENT '직원 전화번호',
  `address` varchar(255) DEFAULT NULL COMMENT '직원 자택주소',
  `image_path` varchar(255) DEFAULT NULL COMMENT '직원 사진 경로 또는 URL',
  `status` enum('재직','휴가','정직','퇴직','대기','계약해지') DEFAULT NULL COMMENT '직원 상태',
  `joined_at` timestamp NULL DEFAULT NULL COMMENT '직원 입사일',
  `resigned_at` timestamp NULL DEFAULT NULL COMMENT '직원 퇴사일',
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
  KEY `FK_tb_employees_tb_organization_teams` (`team_id`),
  KEY `FK_tb_employees_tb_organization_ranks` (`rank_id`),
  KEY `FK_tb_employees_tb_organization_positions` (`position_id`),
  KEY `FK_tb_employees_tb_organization_roles` (`role_id`),
  KEY `FK_tb_employees_tb_organization_privileges` (`privilege_id`),
  CONSTRAINT `FK_tb_employees_tb_organization_positions` FOREIGN KEY (`position_id`) REFERENCES `tb_organization_positions` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_tb_employees_tb_organization_privileges` FOREIGN KEY (`privilege_id`) REFERENCES `tb_organization_privileges` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_tb_employees_tb_organization_ranks` FOREIGN KEY (`rank_id`) REFERENCES `tb_organization_ranks` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_tb_employees_tb_organization_roles` FOREIGN KEY (`role_id`) REFERENCES `tb_organization_roles` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_tb_employees_tb_organization_teams` FOREIGN KEY (`team_id`) REFERENCES `tb_organization_teams` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='직원 리스트';

-- 테이블 데이터 community.tb_employees:~0 rows (대략적) 내보내기
INSERT INTO `tb_employees` (`id`, `name`, `description`, `employee_code`, `gender`, `birth_date`, `email`, `phone`, `address`, `image_path`, `status`, `joined_at`, `resigned_at`, `team_id`, `rank_id`, `position_id`, `role_id`, `privilege_id`, `login_id`, `login_pw`, `is_active`, `created_at`, `updated_at`, `deleted_at`) VALUES
	(13, '제임슨', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '/uploads\\1762842668197-11.png', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '123', '123', NULL, '2025-11-11 05:15:04', '2025-11-14 04:20:54', NULL);

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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='회사 리스트';

-- 테이블 데이터 community.tb_organization_companies:~8 rows (대략적) 내보내기
INSERT INTO `tb_organization_companies` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES
	(8, '00전자', NULL, '2025-11-13 02:23:57', '2025-11-13 02:23:57'),
	(9, '새회사', '내용없음', '2025-11-13 13:20:01', '2025-11-13 13:20:01'),
	(10, '00무역', '호주 무역 회사', '2025-11-13 13:46:35', '2025-11-13 13:51:55'),
	(11, '00기획', '종합 기획사', '2025-11-13 13:48:27', '2025-11-13 13:52:05'),
	(12, '00용역2', '외주', '2025-11-13 13:50:41', '2025-11-13 13:54:21'),
	(13, '00용역2', '외주', '2025-11-13 13:54:28', '2025-11-13 13:54:28'),
	(14, '00개발', NULL, '2025-11-14 01:10:56', '2025-11-14 01:10:56'),
	(15, '서울00회사', '구로구 ...', '2025-11-14 05:43:31', '2025-11-14 05:43:31');

-- 테이블 community.tb_organization_departments 구조 내보내기
CREATE TABLE IF NOT EXISTS `tb_organization_departments` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
  `company_id` int(10) unsigned NOT NULL COMMENT '회사 ID',
  `name` varchar(255) NOT NULL COMMENT '부서 이름',
  `description` varchar(255) DEFAULT NULL COMMENT '부서 설명',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
  PRIMARY KEY (`id`),
  KEY `FK_tb_organization_departments_tb_organization_companies` (`company_id`),
  CONSTRAINT `FK_tb_organization_departments_tb_organization_companies` FOREIGN KEY (`company_id`) REFERENCES `tb_organization_companies` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='부서 리스트';

-- 테이블 데이터 community.tb_organization_departments:~10 rows (대략적) 내보내기
INSERT INTO `tb_organization_departments` (`id`, `company_id`, `name`, `description`, `created_at`, `updated_at`) VALUES
	(4, 8, '총무부', NULL, '2025-11-13 02:24:06', '2025-11-13 14:02:20'),
	(5, 8, '개발부', NULL, '2025-11-13 14:02:52', '2025-11-13 14:02:52'),
	(10, 14, '인사', NULL, '2025-11-14 01:19:57', '2025-11-14 01:19:57'),
	(11, 14, '회계', NULL, '2025-11-14 01:20:03', '2025-11-14 01:20:03'),
	(12, 14, '기획', NULL, '2025-11-14 01:20:07', '2025-11-14 01:20:07'),
	(13, 14, '디자인', NULL, '2025-11-14 01:20:12', '2025-11-14 01:20:12'),
	(14, 14, '시설', NULL, '2025-11-14 01:20:19', '2025-11-14 01:20:19'),
	(15, 14, '전산', NULL, '2025-11-14 01:20:23', '2025-11-14 01:20:23'),
	(16, 14, '개발', NULL, '2025-11-14 01:20:26', '2025-11-14 01:20:26'),
	(17, 15, '개발부서', '설명 ...', '2025-11-14 05:43:43', '2025-11-14 05:43:52');

-- 테이블 community.tb_organization_locations 구조 내보내기
CREATE TABLE IF NOT EXISTS `tb_organization_locations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
  `name` varchar(255) NOT NULL COMMENT '지역 이름',
  `description` varchar(255) DEFAULT NULL COMMENT '지역 설명',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='지역 리스트';

-- 테이블 데이터 community.tb_organization_locations:~0 rows (대략적) 내보내기

-- 테이블 community.tb_organization_positions 구조 내보내기
CREATE TABLE IF NOT EXISTS `tb_organization_positions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
  `name` varchar(255) NOT NULL COMMENT '직책 이름',
  `description` varchar(255) DEFAULT NULL COMMENT '직책 설명',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='직책 리스트';

-- 테이블 데이터 community.tb_organization_positions:~3 rows (대략적) 내보내기
INSERT INTO `tb_organization_positions` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES
	(7, '팀장', NULL, '2025-11-14 00:38:59', '2025-11-14 00:38:59'),
	(8, '본부장', NULL, '2025-11-14 01:00:56', '2025-11-14 01:00:56'),
	(9, '파트장', NULL, '2025-11-14 01:01:00', '2025-11-14 01:01:00');

-- 테이블 community.tb_organization_privileges 구조 내보내기
CREATE TABLE IF NOT EXISTS `tb_organization_privileges` (
  `id` int(10) unsigned NOT NULL COMMENT '권한 ID',
  `name` varchar(255) NOT NULL COMMENT '권한 이름',
  `description` varchar(255) DEFAULT NULL COMMENT '권한 설명',
  `auth_post` enum('R','W','RW') DEFAULT 'R',
  `auth_chat` enum('R','W','RW') DEFAULT 'R',
  `auth_project` enum('R','W','RW') DEFAULT 'R',
  `auth_customer` enum('R','W','RW') DEFAULT 'R',
  `auth_product` enum('R','W','RW') DEFAULT 'R',
  `auth_employee` enum('R','W','RW') DEFAULT 'R',
  `auth_system` enum('R','W','RW') DEFAULT 'R',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='권한';

-- 테이블 데이터 community.tb_organization_privileges:~0 rows (대략적) 내보내기

-- 테이블 community.tb_organization_ranks 구조 내보내기
CREATE TABLE IF NOT EXISTS `tb_organization_ranks` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
  `name` varchar(255) NOT NULL COMMENT '직급 이름',
  `description` varchar(255) DEFAULT NULL COMMENT '직급 설명',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='직급 리스트';

-- 테이블 데이터 community.tb_organization_ranks:~7 rows (대략적) 내보내기
INSERT INTO `tb_organization_ranks` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES
	(11, '사원', NULL, '2025-11-13 14:03:48', '2025-11-13 14:03:48'),
	(12, '주임', NULL, '2025-11-14 00:36:42', '2025-11-14 00:36:42'),
	(13, '대리', NULL, '2025-11-14 00:39:11', '2025-11-14 00:39:11'),
	(14, '과장', NULL, '2025-11-14 00:39:16', '2025-11-14 00:39:16'),
	(15, '차장', NULL, '2025-11-14 00:39:19', '2025-11-14 00:39:26'),
	(16, '부장', '', '2025-11-14 00:41:44', '2025-11-14 00:52:38'),
	(18, '이사', '이사직급', '2025-11-14 01:00:27', '2025-11-14 01:00:34');

-- 테이블 community.tb_organization_roles 구조 내보내기
CREATE TABLE IF NOT EXISTS `tb_organization_roles` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
  `name` varchar(255) NOT NULL COMMENT '역할 이름',
  `description` varchar(255) DEFAULT NULL COMMENT '역할 설명',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='역할 리스트';

-- 테이블 데이터 community.tb_organization_roles:~9 rows (대략적) 내보내기
INSERT INTO `tb_organization_roles` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES
	(12, 'CS 개발', NULL, '2025-11-14 00:39:04', '2025-11-14 00:39:04'),
	(13, '백엔드 개발', NULL, '2025-11-14 01:01:21', '2025-11-14 01:01:21'),
	(14, '프론트 개발', NULL, '2025-11-14 01:01:27', '2025-11-14 01:01:27'),
	(15, '갤럭시 개발', NULL, '2025-11-14 01:01:39', '2025-11-14 01:01:39'),
	(16, '아이폰 개발', NULL, '2025-11-14 01:01:43', '2025-11-14 01:01:43'),
	(17, '펌웨어 개발', NULL, '2025-11-14 01:01:56', '2025-11-14 01:01:56'),
	(18, '퍼플리셔', NULL, '2025-11-14 01:02:09', '2025-11-14 01:02:09'),
	(19, '디자이너', NULL, '2025-11-14 01:02:14', '2025-11-14 01:02:14'),
	(20, '기획', NULL, '2025-11-14 01:02:18', '2025-11-14 01:02:18');

-- 테이블 community.tb_organization_teams 구조 내보내기
CREATE TABLE IF NOT EXISTS `tb_organization_teams` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
  `department_id` int(10) unsigned NOT NULL COMMENT '부서 ID',
  `name` varchar(255) NOT NULL COMMENT '팀 이름',
  `description` varchar(255) DEFAULT NULL COMMENT '팀 설명',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
  PRIMARY KEY (`id`),
  KEY `FK_tb_organization_teams_tb_organization_departments` (`department_id`),
  CONSTRAINT `FK_tb_organization_teams_tb_organization_departments` FOREIGN KEY (`department_id`) REFERENCES `tb_organization_departments` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='팀 리스트';

-- 테이블 데이터 community.tb_organization_teams:~8 rows (대략적) 내보내기
INSERT INTO `tb_organization_teams` (`id`, `department_id`, `name`, `description`, `created_at`, `updated_at`) VALUES
	(7, 4, '인사 1팀', NULL, '2025-11-13 02:24:15', '2025-11-13 14:02:31'),
	(8, 16, '프론트엔드', NULL, '2025-11-14 01:20:44', '2025-11-14 01:20:44'),
	(9, 16, '백엔드', NULL, '2025-11-14 01:20:47', '2025-11-14 01:20:47'),
	(10, 16, 'CS', NULL, '2025-11-14 01:20:50', '2025-11-14 01:20:50'),
	(11, 16, 'QA', NULL, '2025-11-14 01:20:53', '2025-11-14 01:20:53'),
	(12, 16, 'QC', NULL, '2025-11-14 01:21:01', '2025-11-14 01:21:01'),
	(13, 16, '기술지원', NULL, '2025-11-14 01:21:11', '2025-11-14 01:21:11'),
	(15, 17, 'CS 개발', NULL, '2025-11-14 05:44:07', '2025-11-14 05:44:07');

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
) ENGINE=InnoDB AUTO_INCREMENT=66 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='게시글 리스트';

-- 테이블 데이터 community.tb_posts:~34 rows (대략적) 내보내기
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
	(65, 15, 13, '풍속계 개발의뢰', '2030년 2월까지 요청합니다.', 0, 0, NULL, '2025-11-13 07:03:59', '2025-11-13 07:03:59', NULL);

-- 테이블 community.tb_post_category 구조 내보내기
CREATE TABLE IF NOT EXISTS `tb_post_category` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `parent_id` int(10) unsigned DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `FK_tb_post_category_tb_post_category` (`parent_id`),
  CONSTRAINT `FK_tb_post_category_tb_post_category` FOREIGN KEY (`parent_id`) REFERENCES `tb_post_category` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 테이블 데이터 community.tb_post_category:~18 rows (대략적) 내보내기
INSERT INTO `tb_post_category` (`id`, `parent_id`, `name`, `description`, `created_at`, `updated_at`) VALUES
	(1, NULL, '📢 공지사항', NULL, '2025-11-11 10:16:30', '2025-11-11 11:20:15'),
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
  `progress` int(10) unsigned NOT NULL COMMENT '프로젝트 진행도',
  `start_date` timestamp NULL DEFAULT NULL COMMENT '프로젝트 시작일',
  `end_date` timestamp NULL DEFAULT NULL COMMENT '프로젝트 종료일',
  `status` enum('대기','진행','완료','취소','보류') NOT NULL DEFAULT '대기' COMMENT '프로젝트 상태',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
  `deleted_at` timestamp NULL DEFAULT NULL COMMENT '레코드 삭제시각',
  PRIMARY KEY (`id`),
  KEY `FK_tb_projects_tb_customers` (`customer_id`),
  CONSTRAINT `FK_tb_projects_tb_customers` FOREIGN KEY (`customer_id`) REFERENCES `tb_customers` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='프로젝트 리스트';

-- 테이블 데이터 community.tb_projects:~0 rows (대략적) 내보내기

-- 테이블 community.tb_project_members 구조 내보내기
CREATE TABLE IF NOT EXISTS `tb_project_members` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
  `project_id` int(10) unsigned NOT NULL COMMENT '프로젝트 ID',
  `employee_id` int(10) unsigned NOT NULL COMMENT '프로젝트 직원 ID',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
  PRIMARY KEY (`id`),
  KEY `FK_tb_project_members_tb_projects` (`project_id`),
  KEY `FK_tb_project_members_tb_employees` (`employee_id`),
  CONSTRAINT `FK_tb_project_members_tb_employees` FOREIGN KEY (`employee_id`) REFERENCES `tb_employees` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_tb_project_members_tb_projects` FOREIGN KEY (`project_id`) REFERENCES `tb_projects` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='프로젝트 별 멤버';

-- 테이블 데이터 community.tb_project_members:~0 rows (대략적) 내보내기

-- 테이블 community.tb_project_tasks 구조 내보내기
CREATE TABLE IF NOT EXISTS `tb_project_tasks` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
  `project_id` int(10) unsigned NOT NULL COMMENT '프로젝트 ID',
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
  CONSTRAINT `FK_tb_project_tasks_tb_projects` FOREIGN KEY (`project_id`) REFERENCES `tb_projects` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='프로젝트 별 작업';

-- 테이블 데이터 community.tb_project_tasks:~0 rows (대략적) 내보내기

-- 테이블 community.tb_project_task_members 구조 내보내기
CREATE TABLE IF NOT EXISTS `tb_project_task_members` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
  `project_task_id` int(10) unsigned NOT NULL COMMENT '프로젝트 작업 ID',
  `project_member_id` int(10) unsigned NOT NULL COMMENT '프로젝트 작업 직원 ID',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
  PRIMARY KEY (`id`),
  KEY `FK_tb_project_task_members_tb_project_tasks` (`project_task_id`),
  KEY `FK_tb_project_task_members_tb_project_members` (`project_member_id`),
  CONSTRAINT `FK_tb_project_task_members_tb_project_members` FOREIGN KEY (`project_member_id`) REFERENCES `tb_project_members` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_tb_project_task_members_tb_project_tasks` FOREIGN KEY (`project_task_id`) REFERENCES `tb_project_tasks` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='프로젝트 별 작업 멤버';

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
  `category` enum('normal','error') DEFAULT NULL COMMENT '로그 구분',
  `message` varchar(255) NOT NULL COMMENT '로그 내용',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='시스템 로그';

-- 테이블 데이터 community.tb_system_logs:~0 rows (대략적) 내보내기

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

-- 뷰 community.v_teams 구조 내보내기
-- VIEW 종속성 오류를 극복하기 위해 임시 테이블을 생성합니다.
CREATE TABLE `v_teams` (
	`id` BIGINT(11) UNSIGNED NOT NULL,
	`origin_id` INT(10) UNSIGNED NOT NULL,
	`depth` INT(1) NOT NULL,
	`name` VARCHAR(1) NOT NULL COLLATE 'utf8mb4_general_ci',
	`description` VARCHAR(1) NULL COLLATE 'utf8mb4_general_ci',
	`created_at` TIMESTAMP NOT NULL,
	`updated_at` TIMESTAMP NOT NULL,
	`parent_id` DECIMAL(11,0) NULL
);

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
DROP TABLE IF EXISTS `v_teams`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `v_teams` AS SELECT c.id + 1000 AS `id`, c.id AS `origin_id`, 0 AS `depth`, c.`name`, c.`description`, c.created_at, c.updated_at, NULL AS `parent_id` FROM tb_organization_companies c
UNION ALL
SELECT d.id + 2000 AS `id`, d.id AS `origin_id`, 1 AS `depth`, d.`name`, d.`description`, d.created_at, d.updated_at, d.company_id + 1000 AS `parent_id` FROM tb_organization_departments d
UNION ALL 
SELECT t.id + 3000 AS `id`, t.id AS `origin_id`, 2 AS `depth`, t.`name`, t.`description`, t.created_at, t.updated_at, t.department_id + 2000 AS `parent_id` FROM tb_organization_teams t 
;

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
