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
  `employee_id` int(10) unsigned NOT NULL COMMENT '작성자 직원 ID',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
  `is_deleted` enum('Y','N') NOT NULL DEFAULT 'N' COMMENT '레코드 삭제 여부',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='채팅방 별 멤버';

-- 테이블 데이터 community.tb_chat_members:~0 rows (대략적) 내보내기

-- 테이블 community.tb_chat_messages 구조 내보내기
CREATE TABLE IF NOT EXISTS `tb_chat_messages` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
  `chat_member_id` int(10) unsigned NOT NULL COMMENT '채팅방 멤버 ID',
  `message` varchar(255) NOT NULL COMMENT '메시지 내용',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
  `is_deleted` enum('Y','N') NOT NULL DEFAULT 'N' COMMENT '레코드 삭제 여부',
  PRIMARY KEY (`id`)
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
  `is_deleted` enum('Y','N') NOT NULL DEFAULT 'N' COMMENT '레코드 삭제 여부',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='채팅방 리스트';

-- 테이블 데이터 community.tb_chat_rooms:~0 rows (대략적) 내보내기

-- 테이블 community.tb_customers 구조 내보내기
CREATE TABLE IF NOT EXISTS `tb_customers` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
  `location_id` int(10) unsigned DEFAULT NULL COMMENT '지역 ID',
  `name` varchar(255) NOT NULL COMMENT '고객 이름',
  `description` varchar(255) DEFAULT NULL COMMENT '고객 설명',
  `image_path` varchar(255) DEFAULT NULL COMMENT '고객 사진 경로 또는 URL',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
  `is_deleted` enum('Y','N') NOT NULL DEFAULT 'N' COMMENT '레코드 삭제 여부',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='고객 리스트';

-- 테이블 데이터 community.tb_customers:~0 rows (대략적) 내보내기

-- 테이블 community.tb_customer_products 구조 내보내기
CREATE TABLE IF NOT EXISTS `tb_customer_products` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
  `customer_id` int(10) unsigned NOT NULL COMMENT '고객 ID',
  `product_id` int(10) unsigned NOT NULL COMMENT '제품 ID',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
  PRIMARY KEY (`id`)
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
  `login_id` varchar(255) DEFAULT NULL COMMENT '로그인 ID',
  `login_pw` varchar(255) DEFAULT NULL COMMENT '로그인 PW',
  `is_active` enum('Y','N') DEFAULT NULL COMMENT '로그인 계정 상태',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
  `is_deleted` enum('Y','N') NOT NULL DEFAULT 'N' COMMENT '레코드 삭제 여부',
  PRIMARY KEY (`id`),
  UNIQUE KEY `login_id` (`login_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='직원 리스트';

-- 테이블 데이터 community.tb_employees:~4 rows (대략적) 내보내기
INSERT INTO `tb_employees` (`id`, `name`, `description`, `employee_code`, `gender`, `birth_date`, `email`, `phone`, `address`, `image_path`, `status`, `joined_at`, `resigned_at`, `team_id`, `rank_id`, `position_id`, `role_id`, `login_id`, `login_pw`, `is_active`, `created_at`, `updated_at`, `is_deleted`) VALUES
	(1, 'test', '테스트계정', NULL, '기타', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-02 17:06:14', '2025-11-03 05:05:38', 'N'),
	(2, 'TEST02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'asd111', '1234', 'Y', '2025-11-02 17:23:43', '2025-11-02 17:23:43', 'N'),
	(3, 'TEST02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-02 17:26:32', '2025-11-02 17:26:32', 'N'),
	(4, 'TEST03', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-02 17:26:39', '2025-11-02 17:26:39', 'N');

-- 테이블 community.tb_employee_leaves 구조 내보내기
CREATE TABLE IF NOT EXISTS `tb_employee_leaves` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
  `employee_id` int(10) unsigned NOT NULL COMMENT '휴가 직원 ID',
  `approver_id` int(10) unsigned NOT NULL COMMENT '승인 직원 ID',
  `leave_type` enum('연차','병가','무급','출산','육아','특별','대체') NOT NULL DEFAULT '연차' COMMENT '휴가 구분',
  `start_dt` timestamp NOT NULL COMMENT '휴가 시작일',
  `end_dt` timestamp NOT NULL COMMENT '휴가 종료일',
  `description` varchar(255) DEFAULT NULL COMMENT '휴가 내용',
  `leave_result` enum('대기','승인','반려','취소','완료') NOT NULL DEFAULT '대기' COMMENT '승인 결과',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='직원 별 휴가 이력';

-- 테이블 데이터 community.tb_employee_leaves:~0 rows (대략적) 내보내기

-- 테이블 community.tb_employee_privileges 구조 내보내기
CREATE TABLE IF NOT EXISTS `tb_employee_privileges` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
  `employee_id` int(10) unsigned NOT NULL COMMENT '직원 ID',
  `privileges_id` int(10) unsigned NOT NULL COMMENT '권한 ID',
  `is_allowed` enum('Y','N') NOT NULL DEFAULT 'Y' COMMENT '권한 허용 여부',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
  PRIMARY KEY (`id`),
  KEY `FK_tb_employee_privileges_tb_employees` (`employee_id`),
  KEY `FK_tb_employee_privileges_tb_system_privileges` (`privileges_id`),
  CONSTRAINT `FK_tb_employee_privileges_tb_employees` FOREIGN KEY (`employee_id`) REFERENCES `tb_employees` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_tb_employee_privileges_tb_system_privileges` FOREIGN KEY (`privileges_id`) REFERENCES `tb_system_privileges` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='직원 별 권한 내역';

-- 테이블 데이터 community.tb_employee_privileges:~8 rows (대략적) 내보내기
INSERT INTO `tb_employee_privileges` (`id`, `employee_id`, `privileges_id`, `is_allowed`, `created_at`, `updated_at`) VALUES
	(1, 1, 1, 'Y', '2025-11-02 17:12:07', '2025-11-02 17:12:07'),
	(2, 1, 2, 'Y', '2025-11-02 17:13:27', '2025-11-02 17:13:27'),
	(3, 1, 3, 'Y', '2025-11-02 17:13:32', '2025-11-02 17:13:32'),
	(4, 1, 4, 'Y', '2025-11-02 17:13:39', '2025-11-02 17:13:39'),
	(5, 1, 5, 'Y', '2025-11-02 17:13:45', '2025-11-02 17:13:45'),
	(6, 1, 6, 'Y', '2025-11-02 17:13:51', '2025-11-02 17:13:51'),
	(7, 1, 7, 'Y', '2025-11-02 17:13:57', '2025-11-02 17:13:57'),
	(8, 1, 8, 'Y', '2025-11-02 17:14:03', '2025-11-02 17:14:03');

-- 테이블 community.tb_employee_reviews 구조 내보내기
CREATE TABLE IF NOT EXISTS `tb_employee_reviews` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
  `employee_id` int(10) unsigned NOT NULL COMMENT '평가대상 직원 ID',
  `reviewer_id` int(10) unsigned NOT NULL COMMENT '평가자 직원 ID',
  `review_date` timestamp NULL DEFAULT NULL COMMENT '평가일',
  `review_type` enum('1차평가','2차평가','최종평가','자기평가','동료평가') NOT NULL DEFAULT '1차평가' COMMENT '평가 구분',
  `score` int(10) DEFAULT NULL COMMENT '평가 점수',
  `description` varchar(255) DEFAULT NULL COMMENT '평가 내용',
  `review_result` enum('매우우수(S)','우수(A)','양호(B)','보통(C)','미흡(D)','부족(E)','미달(F)') NOT NULL DEFAULT '매우우수(S)' COMMENT '평가 결과',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
  PRIMARY KEY (`id`)
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='회사 리스트';

-- 테이블 데이터 community.tb_organization_companies:~1 rows (대략적) 내보내기
INSERT INTO `tb_organization_companies` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES
	(1, '00회사', NULL, '2025-11-01 11:19:40', '2025-11-01 14:06:58');

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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='부서 리스트';

-- 테이블 데이터 community.tb_organization_departments:~3 rows (대략적) 내보내기
INSERT INTO `tb_organization_departments` (`id`, `company_id`, `name`, `description`, `created_at`, `updated_at`) VALUES
	(1, 1, '개발부', NULL, '2025-11-01 11:29:07', '2025-11-01 11:29:07'),
	(2, 1, '영업부', NULL, '2025-11-02 04:13:02', '2025-11-02 04:13:02'),
	(3, 1, '총무부', NULL, '2025-11-02 04:13:15', '2025-11-02 04:13:39');

-- 테이블 community.tb_organization_locations 구조 내보내기
CREATE TABLE IF NOT EXISTS `tb_organization_locations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
  `name` varchar(255) NOT NULL COMMENT '지역 이름',
  `description` varchar(255) DEFAULT NULL COMMENT '지역 설명',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='지역 리스트';

-- 테이블 데이터 community.tb_organization_locations:~1 rows (대략적) 내보내기
INSERT INTO `tb_organization_locations` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES
	(1, '서울', NULL, '2025-11-01 11:18:46', '2025-11-01 11:18:46');

-- 테이블 community.tb_organization_positions 구조 내보내기
CREATE TABLE IF NOT EXISTS `tb_organization_positions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
  `name` varchar(255) NOT NULL COMMENT '직책 이름',
  `description` varchar(255) DEFAULT NULL COMMENT '직책 설명',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='직책 리스트';

-- 테이블 데이터 community.tb_organization_positions:~6 rows (대략적) 내보내기
INSERT INTO `tb_organization_positions` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES
	(1, '파트장', NULL, '2025-11-01 11:37:52', '2025-11-01 11:37:52'),
	(2, '팀장', NULL, '2025-11-02 04:16:05', '2025-11-02 04:16:05'),
	(3, 'PM', NULL, '2025-11-02 04:16:15', '2025-11-02 04:16:15'),
	(4, 'PL', NULL, '2025-11-02 04:16:21', '2025-11-02 04:16:21'),
	(5, 'CEO', NULL, '2025-11-02 04:16:35', '2025-11-02 04:16:35'),
	(6, 'CTO', NULL, '2025-11-02 04:16:40', '2025-11-02 04:16:40');

-- 테이블 community.tb_organization_ranks 구조 내보내기
CREATE TABLE IF NOT EXISTS `tb_organization_ranks` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
  `name` varchar(255) NOT NULL COMMENT '직급 이름',
  `description` varchar(255) DEFAULT NULL COMMENT '직급 설명',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='직급 리스트';

-- 테이블 데이터 community.tb_organization_ranks:~10 rows (대략적) 내보내기
INSERT INTO `tb_organization_ranks` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES
	(1, '사원', NULL, '2025-11-01 11:34:23', '2025-11-01 11:34:23'),
	(2, '주임', NULL, '2025-11-02 04:15:13', '2025-11-02 04:15:13'),
	(3, '대리', NULL, '2025-11-02 04:15:17', '2025-11-02 04:15:17'),
	(4, '과장', NULL, '2025-11-02 04:15:22', '2025-11-02 04:15:22'),
	(5, '부장', NULL, '2025-11-02 04:15:27', '2025-11-02 04:15:27'),
	(6, '차장', NULL, '2025-11-02 04:15:31', '2025-11-02 04:15:31'),
	(7, '이사', NULL, '2025-11-02 04:15:37', '2025-11-02 04:15:37'),
	(8, '상무', NULL, '2025-11-02 04:15:41', '2025-11-02 04:15:41'),
	(9, '전무', NULL, '2025-11-02 04:15:47', '2025-11-02 04:15:47'),
	(10, '사장', NULL, '2025-11-02 04:15:53', '2025-11-02 04:15:53');

-- 테이블 community.tb_organization_roles 구조 내보내기
CREATE TABLE IF NOT EXISTS `tb_organization_roles` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
  `name` varchar(255) NOT NULL COMMENT '역할 이름',
  `description` varchar(255) DEFAULT NULL COMMENT '역할 설명',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='역할 리스트';

-- 테이블 데이터 community.tb_organization_roles:~11 rows (대략적) 내보내기
INSERT INTO `tb_organization_roles` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES
	(1, '개발', NULL, '2025-11-01 11:34:34', '2025-11-01 11:37:58'),
	(2, 'role1', NULL, '2025-11-02 03:09:58', '2025-11-02 03:09:58'),
	(3, '경리', '', '2025-11-02 04:12:19', '2025-11-02 04:12:19'),
	(4, '영업', '', '2025-11-02 04:12:19', '2025-11-02 04:12:19'),
	(5, '생산', '', '2025-11-02 04:12:19', '2025-11-02 04:12:19'),
	(6, '품질', '', '2025-11-02 04:12:19', '2025-11-02 04:12:19'),
	(7, '디자이너', '', '2025-11-02 04:12:19', '2025-11-02 04:12:19'),
	(8, '개발', '', '2025-11-02 04:12:19', '2025-11-02 04:12:19'),
	(9, '인사', '', '2025-11-02 04:12:19', '2025-11-02 04:12:19'),
	(10, '지원', '', '2025-11-02 04:12:19', '2025-11-02 04:12:19'),
	(11, 'role1', NULL, '2025-11-02 04:40:01', '2025-11-02 04:40:01');

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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='팀 리스트';

-- 테이블 데이터 community.tb_organization_teams:~6 rows (대략적) 내보내기
INSERT INTO `tb_organization_teams` (`id`, `department_id`, `name`, `description`, `created_at`, `updated_at`) VALUES
	(1, 1, '그룹웨어팀', NULL, '2025-11-01 11:34:04', '2025-11-01 11:34:04'),
	(2, 1, '아트팀', NULL, '2025-11-02 04:14:14', '2025-11-02 04:14:14'),
	(3, 2, '마케팅팀', NULL, '2025-11-02 04:14:32', '2025-11-02 04:14:32'),
	(4, 2, '회계팀', NULL, '2025-11-02 04:14:41', '2025-11-02 04:14:41'),
	(5, 3, '관리팀', NULL, '2025-11-02 04:14:54', '2025-11-02 04:14:54'),
	(6, 3, '인사팀', NULL, '2025-11-02 04:15:01', '2025-11-02 04:15:01');

-- 테이블 community.tb_posts 구조 내보내기
CREATE TABLE IF NOT EXISTS `tb_posts` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
  `employee_id` int(10) unsigned NOT NULL COMMENT '작성자 직원 ID',
  `title` varchar(255) NOT NULL COMMENT '게시글 제목',
  `content` text NOT NULL COMMENT '게시글 내용',
  `comments` int(10) unsigned NOT NULL COMMENT '댓글 수',
  `comment_at` timestamp NULL DEFAULT NULL COMMENT '마지막 댓글 생성시각',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
  `is_deleted` enum('Y','N') NOT NULL DEFAULT 'N' COMMENT '레코드 삭제 여부',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='게시글 리스트';

-- 테이블 데이터 community.tb_posts:~0 rows (대략적) 내보내기

-- 테이블 community.tb_post_comments 구조 내보내기
CREATE TABLE IF NOT EXISTS `tb_post_comments` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
  `post_id` int(10) unsigned NOT NULL COMMENT '게시글 ID',
  `employee_id` int(10) unsigned NOT NULL COMMENT '작성자 직원 ID',
  `content` varchar(255) NOT NULL COMMENT '댓글 내용',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
  `is_deleted` enum('Y','N') NOT NULL DEFAULT 'N' COMMENT '레코드 삭제 여부',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='게시글 별 댓글';

-- 테이블 데이터 community.tb_post_comments:~0 rows (대략적) 내보내기

-- 테이블 community.tb_products 구조 내보내기
CREATE TABLE IF NOT EXISTS `tb_products` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
  `name` varchar(255) NOT NULL COMMENT '제품 이름',
  `content` text DEFAULT NULL COMMENT '제품 상세 설명',
  `description` varchar(255) DEFAULT NULL COMMENT '제품 간단 설명',
  `image_path` varchar(255) DEFAULT NULL COMMENT '제품 사진 경로 또는 URL',
  `total_count` int(10) unsigned DEFAULT NULL COMMENT '제품 재고 수량',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
  `is_deleted` enum('Y','N') NOT NULL DEFAULT 'N' COMMENT '레코드 삭제 여부',
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
  PRIMARY KEY (`id`)
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
  `is_deleted` enum('Y','N') NOT NULL DEFAULT 'N' COMMENT '레코드 삭제 여부',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='프로젝트 리스트';

-- 테이블 데이터 community.tb_projects:~0 rows (대략적) 내보내기

-- 테이블 community.tb_project_members 구조 내보내기
CREATE TABLE IF NOT EXISTS `tb_project_members` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
  `project_id` int(10) unsigned NOT NULL COMMENT '프로젝트 ID',
  `employee_id` int(10) unsigned NOT NULL COMMENT '프로젝트 직원 ID',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='프로젝트 별 멤버';

-- 테이블 데이터 community.tb_project_members:~0 rows (대략적) 내보내기

-- 테이블 community.tb_project_tasks 구조 내보내기
CREATE TABLE IF NOT EXISTS `tb_project_tasks` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
  `project_id` int(10) unsigned NOT NULL COMMENT '프로젝트 ID',
  `name` varchar(255) NOT NULL COMMENT '프로젝트 이름',
  `description` varchar(255) DEFAULT NULL COMMENT '프로젝트 설명',
  `progress` int(10) unsigned NOT NULL COMMENT '프로젝트 작업 진행도',
  `start_date` timestamp NULL DEFAULT NULL COMMENT '프로젝트 작업 시작일',
  `end_date` timestamp NULL DEFAULT NULL COMMENT '프로젝트 작업 종료일',
  `status` enum('대기','진행','완료','취소','보류') NOT NULL DEFAULT '대기' COMMENT '프로젝트 작업 상태',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='프로젝트 별 작업';

-- 테이블 데이터 community.tb_project_tasks:~0 rows (대략적) 내보내기

-- 테이블 community.tb_project_task_members 구조 내보내기
CREATE TABLE IF NOT EXISTS `tb_project_task_members` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
  `project_task_id` int(10) unsigned NOT NULL COMMENT '프로젝트 작업 ID',
  `project_member_id` int(10) unsigned NOT NULL COMMENT '프로젝트 작업 직원 ID',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='프로젝트 별 작업 멤버';

-- 테이블 데이터 community.tb_project_task_members:~0 rows (대략적) 내보내기

-- 테이블 community.tb_system_logs 구조 내보내기
CREATE TABLE IF NOT EXISTS `tb_system_logs` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
  `log_id` int(10) unsigned NOT NULL COMMENT '로그 ID',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='시스템 로그 이력';

-- 테이블 데이터 community.tb_system_logs:~0 rows (대략적) 내보내기

-- 테이블 community.tb_system_log_list 구조 내보내기
CREATE TABLE IF NOT EXISTS `tb_system_log_list` (
  `id` int(10) unsigned NOT NULL COMMENT '로그 ID',
  `category` enum('normal','error') NOT NULL DEFAULT 'normal' COMMENT '로그 구분',
  `description` varchar(255) DEFAULT NULL COMMENT '로그 내용',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='시스템 로그 리스트';

-- 테이블 데이터 community.tb_system_log_list:~0 rows (대략적) 내보내기

-- 테이블 community.tb_system_monitor 구조 내보내기
CREATE TABLE IF NOT EXISTS `tb_system_monitor` (
  `id` int(10) unsigned NOT NULL COMMENT '모니터링 ID',
  `name` varchar(255) NOT NULL COMMENT '모니터링 이름',
  `value_number` int(10) unsigned DEFAULT NULL COMMENT '숫자형태 상태값',
  `value_text` varchar(255) DEFAULT NULL COMMENT '문자형태 상태값',
  `description` varchar(255) DEFAULT NULL COMMENT '모니터링 설명',
  `check_interval` int(10) unsigned DEFAULT NULL COMMENT '모니터링 체크 주기 (필요 시)',
  `checked_at` timestamp NULL DEFAULT NULL COMMENT '모니터링 체크 시각 (필요 시)',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='시스템 모니터링 리스트';

-- 테이블 데이터 community.tb_system_monitor:~0 rows (대략적) 내보내기

-- 테이블 community.tb_system_privileges 구조 내보내기
CREATE TABLE IF NOT EXISTS `tb_system_privileges` (
  `id` int(10) unsigned NOT NULL COMMENT '권한 ID',
  `name` varchar(255) NOT NULL COMMENT '권한 이름',
  `description` varchar(255) DEFAULT NULL COMMENT '권한 설명',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
  `is_deleted` enum('Y','N') NOT NULL DEFAULT 'N' COMMENT '레코드 삭제 여부',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='시스템 권한';

-- 테이블 데이터 community.tb_system_privileges:~8 rows (대략적) 내보내기
INSERT INTO `tb_system_privileges` (`id`, `name`, `description`, `created_at`, `updated_at`, `is_deleted`) VALUES
	(1, 'Post', NULL, '2025-11-02 17:07:31', '2025-11-02 17:07:31', 'N'),
	(2, 'Chat', NULL, '2025-11-02 17:07:41', '2025-11-02 17:07:41', 'N'),
	(3, 'Customer', NULL, '2025-11-02 17:08:09', '2025-11-02 17:08:20', 'N'),
	(4, 'Project', NULL, '2025-11-02 17:07:56', '2025-11-02 17:08:22', 'N'),
	(5, 'Product', NULL, '2025-11-02 17:08:42', '2025-11-02 17:08:42', 'N'),
	(6, 'Employee', NULL, '2025-11-02 17:09:01', '2025-11-02 17:09:01', 'N'),
	(7, 'Organization', NULL, '2025-11-02 17:09:20', '2025-11-02 17:09:20', 'N'),
	(8, 'System', NULL, '2025-11-02 17:09:28', '2025-11-02 17:09:28', 'N');

-- 테이블 community.tb_system_settings 구조 내보내기
CREATE TABLE IF NOT EXISTS `tb_system_settings` (
  `id` int(10) unsigned NOT NULL COMMENT '설정 ID',
  `name` varchar(255) NOT NULL COMMENT '설정 이름',
  `value_number` int(10) unsigned DEFAULT NULL COMMENT '숫자형태 설정값',
  `value_text` varchar(255) DEFAULT NULL COMMENT '문자형태 설정값',
  `description` varchar(255) DEFAULT NULL COMMENT '설정 설명',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='시스템 세팅 리스트';

-- 테이블 데이터 community.tb_system_settings:~0 rows (대략적) 내보내기

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
