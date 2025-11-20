/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19-11.8.4-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: community
-- ------------------------------------------------------
-- Server version	11.8.4-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*M!100616 SET @OLD_NOTE_VERBOSITY=@@NOTE_VERBOSITY, NOTE_VERBOSITY=0 */;

--
-- Table structure for table `tb_chat_members`
--

DROP TABLE IF EXISTS `tb_chat_members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_chat_members` (
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
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='채팅방 별 멤버';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_chat_members`
--

LOCK TABLES `tb_chat_members` WRITE;
/*!40000 ALTER TABLE `tb_chat_members` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `tb_chat_members` VALUES
(2,3,13,'2025-11-14 10:11:41',NULL),
(8,4,13,'2025-11-14 10:53:28',NULL);
/*!40000 ALTER TABLE `tb_chat_members` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `tb_chat_messages`
--

DROP TABLE IF EXISTS `tb_chat_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_chat_messages` (
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='채팅방 별 메시지';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_chat_messages`
--

LOCK TABLES `tb_chat_messages` WRITE;
/*!40000 ALTER TABLE `tb_chat_messages` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `tb_chat_messages` VALUES
(1,4,13,'안녕하세요?','2025-11-19 11:49:28',NULL);
/*!40000 ALTER TABLE `tb_chat_messages` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `tb_chat_rooms`
--

DROP TABLE IF EXISTS `tb_chat_rooms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_chat_rooms` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
  `name` varchar(255) NOT NULL COMMENT '채팅방 이름',
  `description` varchar(255) DEFAULT NULL COMMENT '채팅방 설명',
  `message_at` timestamp NULL DEFAULT NULL COMMENT '마지막 메시지 생성시각',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
  `deleted_at` timestamp NULL DEFAULT NULL COMMENT '레코드 삭제시각',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='채팅방 리스트';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_chat_rooms`
--

LOCK TABLES `tb_chat_rooms` WRITE;
/*!40000 ALTER TABLE `tb_chat_rooms` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `tb_chat_rooms` VALUES
(3,'자유 채팅방',NULL,NULL,'2025-11-14 06:59:37','2025-11-14 06:59:37',NULL),
(4,'총무부','비번: 총무부 번호',NULL,'2025-11-14 06:59:47','2025-11-14 07:04:20',NULL);
/*!40000 ALTER TABLE `tb_chat_rooms` ENABLE KEYS */;
UNLOCK TABLES;
commit;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`user7`@`localhost`*/ /*!50003 TRIGGER `tr_log_insert_chat` BEFORE INSERT ON `tb_chat_rooms` FOR EACH ROW BEGIN
	SET @message = CONCAT('add chat ', NEW.id, ', ', NEW.name);
	INSERT INTO tb_system_logs (message) VALUES (@message);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tb_customer_products`
--

DROP TABLE IF EXISTS `tb_customer_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_customer_products` (
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_customer_products`
--

LOCK TABLES `tb_customer_products` WRITE;
/*!40000 ALTER TABLE `tb_customer_products` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `tb_customer_products` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `tb_customer_services`
--

DROP TABLE IF EXISTS `tb_customer_services`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_customer_services` (
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_customer_services`
--

LOCK TABLES `tb_customer_services` WRITE;
/*!40000 ALTER TABLE `tb_customer_services` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `tb_customer_services` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `tb_customers`
--

DROP TABLE IF EXISTS `tb_customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_customers` (
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
  KEY `FK_tb_customers_tb_organization_locations` (`location_id`),
  CONSTRAINT `FK_tb_customers_tb_organization_locations` FOREIGN KEY (`location_id`) REFERENCES `tb_organization_locations` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='고객 리스트';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_customers`
--

LOCK TABLES `tb_customers` WRITE;
/*!40000 ALTER TABLE `tb_customers` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `tb_customers` ENABLE KEYS */;
UNLOCK TABLES;
commit;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`user7`@`localhost`*/ /*!50003 TRIGGER `tr_log_insert_customer` BEFORE INSERT ON `tb_customers` FOR EACH ROW BEGIN
	SET @message = CONCAT('add customer ', NEW.id, ', ', NEW.name);
	INSERT INTO tb_system_logs (message) VALUES (@message);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tb_employee_leaves`
--

DROP TABLE IF EXISTS `tb_employee_leaves`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_employee_leaves` (
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_employee_leaves`
--

LOCK TABLES `tb_employee_leaves` WRITE;
/*!40000 ALTER TABLE `tb_employee_leaves` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `tb_employee_leaves` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `tb_employee_reviews`
--

DROP TABLE IF EXISTS `tb_employee_reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_employee_reviews` (
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_employee_reviews`
--

LOCK TABLES `tb_employee_reviews` WRITE;
/*!40000 ALTER TABLE `tb_employee_reviews` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `tb_employee_reviews` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `tb_employees`
--

DROP TABLE IF EXISTS `tb_employees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_employees` (
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_employees`
--

LOCK TABLES `tb_employees` WRITE;
/*!40000 ALTER TABLE `tb_employees` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `tb_employees` VALUES
(13,'제임슨',NULL,'A0001','남','2025-11-19','jameson@123.com','000-1234-5678','00시 00구 00군 0000-123','/uploads\\1762842668197-11.png','재직','2025-11-19 08:30:50',NULL,15,14,8,12,NULL,'123','123','Y','2025-11-11 05:15:04','2025-11-19 08:31:11',NULL);
/*!40000 ALTER TABLE `tb_employees` ENABLE KEYS */;
UNLOCK TABLES;
commit;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`user7`@`localhost`*/ /*!50003 TRIGGER `tr_log_insert_employee` BEFORE INSERT ON `tb_employees` FOR EACH ROW BEGIN
	SET @message = CONCAT('add employee ', NEW.id, ', ', NEW.name);
	INSERT INTO tb_system_logs (message) VALUES (@message);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tb_organization_companies`
--

DROP TABLE IF EXISTS `tb_organization_companies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_organization_companies` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
  `name` varchar(255) NOT NULL COMMENT '회사 이름',
  `description` varchar(255) DEFAULT NULL COMMENT '회사 설명',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='회사 리스트';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_organization_companies`
--

LOCK TABLES `tb_organization_companies` WRITE;
/*!40000 ALTER TABLE `tb_organization_companies` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `tb_organization_companies` VALUES
(8,'00전자',NULL,'2025-11-13 02:23:57','2025-11-13 02:23:57'),
(9,'새회사','내용없음','2025-11-13 13:20:01','2025-11-13 13:20:01'),
(10,'00무역','호주 무역 회사','2025-11-13 13:46:35','2025-11-13 13:51:55'),
(11,'00기획','종합 기획사','2025-11-13 13:48:27','2025-11-13 13:52:05'),
(12,'00용역2','외주','2025-11-13 13:50:41','2025-11-13 13:54:21'),
(13,'00용역2','외주','2025-11-13 13:54:28','2025-11-13 13:54:28'),
(14,'00개발',NULL,'2025-11-14 01:10:56','2025-11-14 01:10:56'),
(15,'서울00회사','구로구 ...','2025-11-14 05:43:31','2025-11-14 05:43:31');
/*!40000 ALTER TABLE `tb_organization_companies` ENABLE KEYS */;
UNLOCK TABLES;
commit;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`user7`@`localhost`*/ /*!50003 TRIGGER `tr_log_insert_company` BEFORE INSERT ON `tb_organization_companies` FOR EACH ROW BEGIN

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tb_organization_departments`
--

DROP TABLE IF EXISTS `tb_organization_departments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_organization_departments` (
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_organization_departments`
--

LOCK TABLES `tb_organization_departments` WRITE;
/*!40000 ALTER TABLE `tb_organization_departments` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `tb_organization_departments` VALUES
(4,8,'총무부',NULL,'2025-11-13 02:24:06','2025-11-13 14:02:20'),
(5,8,'개발부',NULL,'2025-11-13 14:02:52','2025-11-13 14:02:52'),
(10,14,'인사',NULL,'2025-11-14 01:19:57','2025-11-14 01:19:57'),
(11,14,'회계',NULL,'2025-11-14 01:20:03','2025-11-14 01:20:03'),
(12,14,'기획',NULL,'2025-11-14 01:20:07','2025-11-14 01:20:07'),
(13,14,'디자인',NULL,'2025-11-14 01:20:12','2025-11-14 01:20:12'),
(14,14,'시설',NULL,'2025-11-14 01:20:19','2025-11-14 01:20:19'),
(15,14,'전산',NULL,'2025-11-14 01:20:23','2025-11-14 01:20:23'),
(16,14,'개발',NULL,'2025-11-14 01:20:26','2025-11-14 01:20:26'),
(17,15,'개발부서','설명 ...','2025-11-14 05:43:43','2025-11-14 05:43:52');
/*!40000 ALTER TABLE `tb_organization_departments` ENABLE KEYS */;
UNLOCK TABLES;
commit;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`user7`@`localhost`*/ /*!50003 TRIGGER `tr_log_insert_department` BEFORE INSERT ON `tb_organization_departments` FOR EACH ROW BEGIN

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tb_organization_locations`
--

DROP TABLE IF EXISTS `tb_organization_locations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_organization_locations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
  `name` varchar(255) NOT NULL COMMENT '지역 이름',
  `description` varchar(255) DEFAULT NULL COMMENT '지역 설명',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='지역 리스트';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_organization_locations`
--

LOCK TABLES `tb_organization_locations` WRITE;
/*!40000 ALTER TABLE `tb_organization_locations` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `tb_organization_locations` ENABLE KEYS */;
UNLOCK TABLES;
commit;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`user7`@`localhost`*/ /*!50003 TRIGGER `tr_log_insert_location` BEFORE INSERT ON `tb_organization_locations` FOR EACH ROW BEGIN

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tb_organization_positions`
--

DROP TABLE IF EXISTS `tb_organization_positions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_organization_positions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
  `name` varchar(255) NOT NULL COMMENT '직책 이름',
  `description` varchar(255) DEFAULT NULL COMMENT '직책 설명',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='직책 리스트';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_organization_positions`
--

LOCK TABLES `tb_organization_positions` WRITE;
/*!40000 ALTER TABLE `tb_organization_positions` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `tb_organization_positions` VALUES
(7,'팀장',NULL,'2025-11-14 00:38:59','2025-11-14 00:38:59'),
(8,'본부장',NULL,'2025-11-14 01:00:56','2025-11-14 01:00:56'),
(9,'파트장',NULL,'2025-11-14 01:01:00','2025-11-14 01:01:00');
/*!40000 ALTER TABLE `tb_organization_positions` ENABLE KEYS */;
UNLOCK TABLES;
commit;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`user7`@`localhost`*/ /*!50003 TRIGGER `tr_log_insert_position` BEFORE INSERT ON `tb_organization_positions` FOR EACH ROW BEGIN

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tb_organization_privileges`
--

DROP TABLE IF EXISTS `tb_organization_privileges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_organization_privileges` (
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_organization_privileges`
--

LOCK TABLES `tb_organization_privileges` WRITE;
/*!40000 ALTER TABLE `tb_organization_privileges` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `tb_organization_privileges` ENABLE KEYS */;
UNLOCK TABLES;
commit;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`user7`@`localhost`*/ /*!50003 TRIGGER `tr_log_insert_privilege` BEFORE INSERT ON `tb_organization_privileges` FOR EACH ROW BEGIN

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tb_organization_ranks`
--

DROP TABLE IF EXISTS `tb_organization_ranks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_organization_ranks` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
  `name` varchar(255) NOT NULL COMMENT '직급 이름',
  `description` varchar(255) DEFAULT NULL COMMENT '직급 설명',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='직급 리스트';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_organization_ranks`
--

LOCK TABLES `tb_organization_ranks` WRITE;
/*!40000 ALTER TABLE `tb_organization_ranks` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `tb_organization_ranks` VALUES
(11,'사원',NULL,'2025-11-13 14:03:48','2025-11-13 14:03:48'),
(12,'주임',NULL,'2025-11-14 00:36:42','2025-11-14 00:36:42'),
(13,'대리',NULL,'2025-11-14 00:39:11','2025-11-14 00:39:11'),
(14,'과장',NULL,'2025-11-14 00:39:16','2025-11-14 00:39:16'),
(15,'차장',NULL,'2025-11-14 00:39:19','2025-11-14 00:39:26'),
(16,'부장','','2025-11-14 00:41:44','2025-11-14 00:52:38'),
(18,'이사','이사직급','2025-11-14 01:00:27','2025-11-14 01:00:34');
/*!40000 ALTER TABLE `tb_organization_ranks` ENABLE KEYS */;
UNLOCK TABLES;
commit;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`user7`@`localhost`*/ /*!50003 TRIGGER `tr_log_insert_rank` BEFORE INSERT ON `tb_organization_ranks` FOR EACH ROW BEGIN

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tb_organization_roles`
--

DROP TABLE IF EXISTS `tb_organization_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_organization_roles` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
  `name` varchar(255) NOT NULL COMMENT '역할 이름',
  `description` varchar(255) DEFAULT NULL COMMENT '역할 설명',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='역할 리스트';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_organization_roles`
--

LOCK TABLES `tb_organization_roles` WRITE;
/*!40000 ALTER TABLE `tb_organization_roles` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `tb_organization_roles` VALUES
(12,'CS 개발',NULL,'2025-11-14 00:39:04','2025-11-14 00:39:04'),
(13,'백엔드 개발',NULL,'2025-11-14 01:01:21','2025-11-14 01:01:21'),
(14,'프론트 개발',NULL,'2025-11-14 01:01:27','2025-11-14 01:01:27'),
(15,'갤럭시 개발',NULL,'2025-11-14 01:01:39','2025-11-14 01:01:39'),
(16,'아이폰 개발',NULL,'2025-11-14 01:01:43','2025-11-14 01:01:43'),
(17,'펌웨어 개발',NULL,'2025-11-14 01:01:56','2025-11-14 01:01:56'),
(18,'퍼플리셔',NULL,'2025-11-14 01:02:09','2025-11-14 01:02:09'),
(19,'디자이너',NULL,'2025-11-14 01:02:14','2025-11-14 01:02:14'),
(20,'기획',NULL,'2025-11-14 01:02:18','2025-11-14 01:02:18');
/*!40000 ALTER TABLE `tb_organization_roles` ENABLE KEYS */;
UNLOCK TABLES;
commit;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`user7`@`localhost`*/ /*!50003 TRIGGER `tr_log_insert_role` BEFORE INSERT ON `tb_organization_roles` FOR EACH ROW BEGIN

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tb_organization_teams`
--

DROP TABLE IF EXISTS `tb_organization_teams`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_organization_teams` (
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_organization_teams`
--

LOCK TABLES `tb_organization_teams` WRITE;
/*!40000 ALTER TABLE `tb_organization_teams` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `tb_organization_teams` VALUES
(7,4,'인사 1팀',NULL,'2025-11-13 02:24:15','2025-11-13 14:02:31'),
(8,16,'프론트엔드',NULL,'2025-11-14 01:20:44','2025-11-14 01:20:44'),
(9,16,'백엔드',NULL,'2025-11-14 01:20:47','2025-11-14 01:20:47'),
(10,16,'CS',NULL,'2025-11-14 01:20:50','2025-11-14 01:20:50'),
(11,16,'QA',NULL,'2025-11-14 01:20:53','2025-11-14 01:20:53'),
(12,16,'QC',NULL,'2025-11-14 01:21:01','2025-11-14 01:21:01'),
(13,16,'기술지원',NULL,'2025-11-14 01:21:11','2025-11-14 01:21:11'),
(15,17,'CS 개발',NULL,'2025-11-14 05:44:07','2025-11-14 05:44:07');
/*!40000 ALTER TABLE `tb_organization_teams` ENABLE KEYS */;
UNLOCK TABLES;
commit;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`user7`@`localhost`*/ /*!50003 TRIGGER `tr_log_insert_team` BEFORE INSERT ON `tb_organization_teams` FOR EACH ROW BEGIN

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tb_post_category`
--

DROP TABLE IF EXISTS `tb_post_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_post_category` (
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_post_category`
--

LOCK TABLES `tb_post_category` WRITE;
/*!40000 ALTER TABLE `tb_post_category` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `tb_post_category` VALUES
(1,NULL,'📢 공지사항',NULL,'2025-11-11 10:16:30','2025-11-11 11:20:15'),
(7,NULL,'자유 게시판',NULL,'2025-11-11 10:12:29','2025-11-11 11:20:18'),
(8,7,'자유게시판1',NULL,'2025-11-11 10:12:41','2025-11-11 10:12:41'),
(9,7,'자유게시판2',NULL,'2025-11-11 10:12:49','2025-11-11 10:12:49'),
(10,7,'자유게시판3',NULL,'2025-11-11 10:12:56','2025-11-11 10:12:56'),
(11,NULL,'부서 게시판',NULL,'2025-11-11 10:13:11','2025-11-11 11:20:21'),
(12,11,'마케팅',NULL,'2025-11-11 10:13:28','2025-11-11 10:13:28'),
(13,11,'기획',NULL,'2025-11-11 10:13:38','2025-11-11 10:13:38'),
(14,11,'생산',NULL,'2025-11-11 10:13:49','2025-11-11 10:13:49'),
(15,11,'개발',NULL,'2025-11-11 10:15:20','2025-11-11 10:15:20'),
(16,11,'영업',NULL,'2025-11-11 10:15:29','2025-11-11 10:15:29'),
(17,11,'총무',NULL,'2025-11-11 10:15:58','2025-11-11 10:15:58'),
(18,NULL,'고객의 소리',NULL,'2025-11-11 10:16:24','2025-11-11 10:16:24'),
(20,18,'세모전자',NULL,'2025-11-11 10:16:49','2025-11-11 10:16:49'),
(21,18,'동그라미 마트',NULL,'2025-11-11 10:17:31','2025-11-11 10:17:31'),
(22,18,'네모 호텔&리조트',NULL,'2025-11-11 10:17:48','2025-11-11 10:17:54'),
(23,NULL,'신규 게시판',NULL,'2025-11-13 06:05:49','2025-11-13 06:05:49'),
(24,NULL,'마감 게시판',NULL,'2025-11-13 06:06:43','2025-11-13 06:06:43');
/*!40000 ALTER TABLE `tb_post_category` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `tb_post_comments`
--

DROP TABLE IF EXISTS `tb_post_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_post_comments` (
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_post_comments`
--

LOCK TABLES `tb_post_comments` WRITE;
/*!40000 ALTER TABLE `tb_post_comments` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `tb_post_comments` VALUES
(1,64,13,'123','2025-11-13 08:47:18','2025-11-13 08:47:18',NULL),
(2,64,13,'123','2025-11-13 08:50:52','2025-11-13 08:50:52',NULL),
(3,64,13,'123','2025-11-13 08:51:13','2025-11-13 08:51:13',NULL),
(4,64,13,'123','2025-11-13 08:51:46','2025-11-13 08:51:46',NULL),
(5,64,13,'123','2025-11-13 08:52:14','2025-11-13 08:52:14',NULL),
(6,64,13,'123','2025-11-13 08:54:14','2025-11-13 08:54:14',NULL),
(7,64,13,'123','2025-11-13 08:55:00','2025-11-13 08:55:00',NULL),
(8,64,13,'123','2025-11-13 08:56:35','2025-11-13 08:56:35',NULL),
(9,64,13,'123','2025-11-13 08:59:03','2025-11-13 08:59:03',NULL),
(10,64,13,'123','2025-11-13 09:05:35','2025-11-13 09:05:35',NULL),
(11,64,13,'123','2025-11-13 09:06:01','2025-11-13 09:06:01',NULL),
(12,64,13,'123','2025-11-13 09:06:34','2025-11-13 09:06:34',NULL),
(13,64,13,'3214dfgd sgf ','2025-11-13 09:06:58','2025-11-13 09:06:58',NULL),
(14,64,13,'fv 23v f3f','2025-11-13 09:07:00','2025-11-13 09:07:00',NULL),
(15,64,13,'1. 자유게시판 어쩌구\r\n2. 제임슨 어쩌구\r\n3. 이 댓글은 어쩌구 저쩌구\r\n4. 그래서 이렇게 해주세요!','2025-11-13 09:12:02','2025-11-13 09:12:02',NULL);
/*!40000 ALTER TABLE `tb_post_comments` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `tb_posts`
--

DROP TABLE IF EXISTS `tb_posts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_posts` (
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_posts`
--

LOCK TABLES `tb_posts` WRITE;
/*!40000 ALTER TABLE `tb_posts` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `tb_posts` VALUES
(32,7,13,'새 글','본문',0,0,NULL,'2025-11-11 11:17:34','2025-11-11 11:17:34',NULL),
(33,7,13,'새 글','본문',0,0,NULL,'2025-11-11 11:17:34','2025-11-11 11:17:34',NULL),
(34,7,13,'새 글','본문',0,0,NULL,'2025-11-11 11:17:34','2025-11-11 11:17:34',NULL),
(35,7,13,'새 글','본문',0,0,NULL,'2025-11-11 11:17:34','2025-11-11 11:17:34',NULL),
(36,7,13,'새 글','본문',0,0,NULL,'2025-11-11 11:17:34','2025-11-11 11:17:34',NULL),
(37,7,13,'새 글','본문',0,0,NULL,'2025-11-11 11:17:35','2025-11-11 11:17:35',NULL),
(38,7,13,'새 글','본문',0,0,NULL,'2025-11-11 11:17:35','2025-11-11 11:17:35',NULL),
(39,7,13,'새 글','본문',0,0,NULL,'2025-11-11 11:17:35','2025-11-11 11:17:35',NULL),
(40,7,13,'새 글','본문',0,0,NULL,'2025-11-11 11:17:35','2025-11-11 11:17:35',NULL),
(41,7,13,'새 글','본문',0,0,NULL,'2025-11-11 11:17:35','2025-11-11 11:17:35',NULL),
(42,7,13,'새 글','본문',0,0,NULL,'2025-11-11 11:17:35','2025-11-11 11:17:35',NULL),
(43,7,13,'새 글','본문',0,0,NULL,'2025-11-11 11:17:36','2025-11-11 11:17:36',NULL),
(44,7,13,'새 글','본문',0,0,NULL,'2025-11-11 11:17:36','2025-11-11 11:17:36',NULL),
(45,7,13,'새 글','본문',0,0,NULL,'2025-11-11 11:17:36','2025-11-11 11:17:36',NULL),
(46,7,13,'새 글','본문',0,0,NULL,'2025-11-11 11:17:36','2025-11-11 11:17:36',NULL),
(47,7,13,'새 글','본문',0,0,NULL,'2025-11-11 11:17:36','2025-11-11 11:17:36',NULL),
(48,7,13,'새 글','본문',0,0,NULL,'2025-11-11 11:17:36','2025-11-11 11:17:36',NULL),
(49,7,13,'새 글','본문',0,0,NULL,'2025-11-11 11:17:36','2025-11-11 11:17:36',NULL),
(50,7,13,'새 글','본문',0,0,NULL,'2025-11-11 11:17:37','2025-11-11 11:17:37',NULL),
(51,7,13,'새 글','본문',0,0,NULL,'2025-11-11 11:17:37','2025-11-11 11:17:37',NULL),
(52,7,13,'새 글','본문',0,0,NULL,'2025-11-11 11:17:37','2025-11-11 11:17:37',NULL),
(53,7,13,'새 글','본문',0,0,NULL,'2025-11-11 11:17:37','2025-11-11 11:17:37',NULL),
(54,7,13,'새 글','본문',0,0,NULL,'2025-11-11 11:17:37','2025-11-11 11:17:37',NULL),
(55,7,13,'새 글','본문',0,0,NULL,'2025-11-11 11:17:37','2025-11-11 11:17:37',NULL),
(56,7,13,'새 글','본문',0,0,NULL,'2025-11-11 11:17:38','2025-11-11 11:17:38',NULL),
(57,7,13,'새 글','본문',0,0,NULL,'2025-11-11 11:17:38','2025-11-11 11:17:38',NULL),
(58,7,13,'새 글','본문',0,0,NULL,'2025-11-11 11:17:38','2025-11-11 11:17:38',NULL),
(59,8,13,'자유게시판1 첫 글입니다.','안녕하세요',0,0,NULL,'2025-11-13 06:48:11','2025-11-13 06:48:11',NULL),
(60,8,13,'자유게시판1 첫 글입니다.','안녕하세요',0,0,NULL,'2025-11-13 06:48:57','2025-11-13 06:48:57',NULL),
(61,8,13,'자유게시판1 첫 글입니다.','안녕하세요',0,0,NULL,'2025-11-13 06:50:32','2025-11-13 06:50:32',NULL),
(62,9,13,'댓글이 없는 자유게시판2','자유게시판2',0,0,NULL,'2025-11-13 06:51:54','2025-11-13 09:24:35',NULL),
(63,10,13,'댓글이 없는 자유게시판','내용',0,0,NULL,'2025-11-13 06:53:58','2025-11-13 09:24:07',NULL),
(64,7,13,'댓글이 많은 자유게시판','본문입니다',0,0,NULL,'2025-11-13 06:55:35','2025-11-13 09:23:37',NULL),
(65,15,13,'풍속계 개발의뢰','2030년 2월까지 요청합니다.',0,0,NULL,'2025-11-13 07:03:59','2025-11-13 07:03:59',NULL),
(66,7,13,'새로운 게시글','내용은 ...',0,0,NULL,'2025-11-19 06:14:46','2025-11-19 06:14:46',NULL),
(67,7,13,'새 게시글2','내용 없음',0,0,NULL,'2025-11-19 06:16:12','2025-11-19 06:16:12',NULL);
/*!40000 ALTER TABLE `tb_posts` ENABLE KEYS */;
UNLOCK TABLES;
commit;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`user7`@`localhost`*/ /*!50003 TRIGGER `tr_log_insert_post` BEFORE INSERT ON `tb_posts` FOR EACH ROW BEGIN
	SET @message = CONCAT('add post ', NEW.id, ', ', NEW.title);
	INSERT INTO tb_system_logs (message) VALUES (@message);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tb_product_inventory`
--

DROP TABLE IF EXISTS `tb_product_inventory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_product_inventory` (
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_product_inventory`
--

LOCK TABLES `tb_product_inventory` WRITE;
/*!40000 ALTER TABLE `tb_product_inventory` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `tb_product_inventory` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `tb_products`
--

DROP TABLE IF EXISTS `tb_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_products` (
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_products`
--

LOCK TABLES `tb_products` WRITE;
/*!40000 ALTER TABLE `tb_products` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `tb_products` ENABLE KEYS */;
UNLOCK TABLES;
commit;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`user7`@`localhost`*/ /*!50003 TRIGGER `tr_log_insert_product` BEFORE INSERT ON `tb_products` FOR EACH ROW BEGIN
	SET @message = CONCAT('add product ', NEW.id, ', ', NEW.name);
	INSERT INTO tb_system_logs (message) VALUES (@message);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tb_project_members`
--

DROP TABLE IF EXISTS `tb_project_members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_project_members` (
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_project_members`
--

LOCK TABLES `tb_project_members` WRITE;
/*!40000 ALTER TABLE `tb_project_members` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `tb_project_members` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `tb_project_task_members`
--

DROP TABLE IF EXISTS `tb_project_task_members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_project_task_members` (
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_project_task_members`
--

LOCK TABLES `tb_project_task_members` WRITE;
/*!40000 ALTER TABLE `tb_project_task_members` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `tb_project_task_members` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `tb_project_tasks`
--

DROP TABLE IF EXISTS `tb_project_tasks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_project_tasks` (
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='프로젝트 별 작업';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_project_tasks`
--

LOCK TABLES `tb_project_tasks` WRITE;
/*!40000 ALTER TABLE `tb_project_tasks` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `tb_project_tasks` VALUES
(1,38,'모바일앱','갤럭시',12,'2025-05-18 08:02:18','2025-08-18 08:02:19','진행','2025-11-18 08:02:25','2025-11-18 08:03:07');
/*!40000 ALTER TABLE `tb_project_tasks` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `tb_projects`
--

DROP TABLE IF EXISTS `tb_projects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_projects` (
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
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='프로젝트 리스트';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_projects`
--

LOCK TABLES `tb_projects` WRITE;
/*!40000 ALTER TABLE `tb_projects` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `tb_projects` VALUES
(37,NULL,'태양광 제어 시스템 개발','데스크탑 프로그램',0,'2025-11-18 03:37:35','2025-11-30 03:37:51','대기','2025-11-18 03:35:15','2025-11-18 03:37:57',NULL),
(38,NULL,'제습기 모바일 제어','갤럭시/iOS 앱',12,'2025-03-18 03:37:39','2025-12-01 03:37:47','진행','2025-11-18 03:37:31','2025-11-18 05:08:31',NULL),
(39,NULL,'한전 연계 전기 검진기계 수정',NULL,50,'2025-11-20 03:39:44','2026-04-05 03:39:51','대기','2025-11-18 03:39:16','2025-11-18 03:40:01',NULL),
(40,NULL,'엑스포 전시 준비',NULL,20,'2025-11-18 03:39:45','2026-02-01 03:40:07','보류','2025-11-18 03:39:44','2025-11-18 05:08:41',NULL),
(41,NULL,'수도검침 모듈 개선','기기,앱 연계',100,'2025-01-05 05:08:51','2025-05-13 05:09:00','완료','2025-11-18 05:09:47','2025-11-18 05:09:47',NULL),
(42,NULL,'차세대 통신망',NULL,7,NULL,NULL,'취소','2025-11-18 05:10:22','2025-11-18 05:10:22',NULL);
/*!40000 ALTER TABLE `tb_projects` ENABLE KEYS */;
UNLOCK TABLES;
commit;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`user7`@`localhost`*/ /*!50003 TRIGGER `tr_log_insert_project` BEFORE INSERT ON `tb_projects` FOR EACH ROW BEGIN
	SET @message = CONCAT('add project ', NEW.id, ', ', NEW.name);
	INSERT INTO tb_system_logs (message) VALUES (@message);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tb_system_config`
--

DROP TABLE IF EXISTS `tb_system_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_system_config` (
  `id` int(10) unsigned NOT NULL COMMENT '레코드 ID',
  `name` varchar(255) NOT NULL COMMENT '레코드 이름',
  `value_number` int(10) unsigned DEFAULT NULL COMMENT '숫자형태 상태값',
  `value_text` varchar(255) DEFAULT NULL COMMENT '문자형태 상태값',
  `description` varchar(255) DEFAULT NULL COMMENT '레코드 설명',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '레코드 수정시각',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='시스템 정보';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_system_config`
--

LOCK TABLES `tb_system_config` WRITE;
/*!40000 ALTER TABLE `tb_system_config` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `tb_system_config` VALUES
(1,'총 게시글 수',30023,NULL,NULL,'2025-11-12 14:35:40','2025-11-12 14:35:40'),
(2,'총 댓글 수',12333,NULL,NULL,'2025-11-12 14:35:40','2025-11-12 14:35:40'),
(3,'활성 사용자 수 (최근 24시간)',132,NULL,NULL,'2025-11-12 14:35:40','2025-11-12 14:35:40'),
(4,'총 프로젝트 수',12323,NULL,NULL,'2025-11-12 14:35:40','2025-11-12 14:35:40'),
(5,'총 고객사 수',123,NULL,NULL,'2025-11-12 14:35:40','2025-11-12 14:35:40'),
(6,'총 제품 수',5525,NULL,NULL,'2025-11-12 14:35:40','2025-11-12 14:35:40'),
(7,'총 직원 수',465,NULL,NULL,'2025-11-12 14:35:40','2025-11-12 14:35:40'),
(8,'시스템 접속 로그 수',232,NULL,NULL,'2025-11-12 14:35:40','2025-11-12 14:35:40'),
(9,'프로그램 테마',NULL,'기본',NULL,'2025-11-12 14:35:40','2025-11-12 14:35:40'),
(400,'서버 CPU',30,NULL,NULL,'2025-11-12 14:35:40','2025-11-12 14:35:40'),
(401,'서버 GPU',7,NULL,NULL,'2025-11-12 14:35:40','2025-11-12 14:35:40'),
(402,'서버 RAM',56,NULL,NULL,'2025-11-12 14:35:40','2025-11-12 14:35:40'),
(403,'최근 백업 일시',NULL,'2025-11-12',NULL,'2025-11-12 14:35:40','2025-11-12 14:35:40'),
(404,'에러 로그 수',12,NULL,NULL,'2025-11-12 14:35:40','2025-11-12 14:35:40'),
(405,'업타임',7239,NULL,NULL,'2025-11-12 14:35:40','2025-11-12 14:35:40');
/*!40000 ALTER TABLE `tb_system_config` ENABLE KEYS */;
UNLOCK TABLES;
commit;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`user7`@`localhost`*/ /*!50003 TRIGGER `tr_log_update_config` BEFORE UPDATE ON `tb_system_config` FOR EACH ROW BEGIN

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tb_system_logs`
--

DROP TABLE IF EXISTS `tb_system_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_system_logs` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '레코드 ID',
  `category` enum('normal','error') NOT NULL DEFAULT 'normal' COMMENT '로그 구분',
  `message` varchar(255) NOT NULL COMMENT '로그 내용',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성시각',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='시스템 로그';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_system_logs`
--

LOCK TABLES `tb_system_logs` WRITE;
/*!40000 ALTER TABLE `tb_system_logs` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `tb_system_logs` VALUES
(1,'normal','add post 0, 새로운 게시글','2025-11-19 06:14:46'),
(2,'normal','add post 0, 새 게시글2','2025-11-19 06:16:12');
/*!40000 ALTER TABLE `tb_system_logs` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Temporary table structure for view `v_employees`
--

DROP TABLE IF EXISTS `v_employees`;
/*!50001 DROP VIEW IF EXISTS `v_employees`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `v_employees` AS SELECT
 1 AS `id`,
  1 AS `name`,
  1 AS `description`,
  1 AS `employee_code`,
  1 AS `gender`,
  1 AS `birth_date`,
  1 AS `email`,
  1 AS `phone`,
  1 AS `address`,
  1 AS `image_path`,
  1 AS `status`,
  1 AS `joined_at`,
  1 AS `resigned_at`,
  1 AS `company_id`,
  1 AS `company_name`,
  1 AS `department_id`,
  1 AS `department_name`,
  1 AS `team_id`,
  1 AS `team_name`,
  1 AS `rank_id`,
  1 AS `rank_name`,
  1 AS `position_id`,
  1 AS `position_name`,
  1 AS `role_id`,
  1 AS `role_name`,
  1 AS `privilege_id`,
  1 AS `privilege_name`,
  1 AS `is_active`,
  1 AS `created_at`,
  1 AS `updated_at`,
  1 AS `deleted_at` */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_posts`
--

DROP TABLE IF EXISTS `v_posts`;
/*!50001 DROP VIEW IF EXISTS `v_posts`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `v_posts` AS SELECT
 1 AS `id`,
  1 AS `post_category_id`,
  1 AS `post_category_name`,
  1 AS `parent_id`,
  1 AS `employee_id`,
  1 AS `employee_name`,
  1 AS `title`,
  1 AS `content`,
  1 AS `view_count`,
  1 AS `comments`,
  1 AS `comment_at`,
  1 AS `created_at`,
  1 AS `updated_at`,
  1 AS `deleted_at` */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_project_tasks`
--

DROP TABLE IF EXISTS `v_project_tasks`;
/*!50001 DROP VIEW IF EXISTS `v_project_tasks`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `v_project_tasks` AS SELECT
 1 AS `id`,
  1 AS `project_id`,
  1 AS `name`,
  1 AS `description`,
  1 AS `progress`,
  1 AS `start_date`,
  1 AS `end_date`,
  1 AS `status`,
  1 AS `created_at`,
  1 AS `updated_at` */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_projects`
--

DROP TABLE IF EXISTS `v_projects`;
/*!50001 DROP VIEW IF EXISTS `v_projects`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `v_projects` AS SELECT
 1 AS `id`,
  1 AS `customer_id`,
  1 AS `name`,
  1 AS `description`,
  1 AS `progress`,
  1 AS `start_date`,
  1 AS `end_date`,
  1 AS `status`,
  1 AS `created_at`,
  1 AS `updated_at`,
  1 AS `deleted_at` */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_teams`
--

DROP TABLE IF EXISTS `v_teams`;
/*!50001 DROP VIEW IF EXISTS `v_teams`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `v_teams` AS SELECT
 1 AS `id`,
  1 AS `origin_id`,
  1 AS `depth`,
  1 AS `name`,
  1 AS `description`,
  1 AS `created_at`,
  1 AS `updated_at`,
  1 AS `parent_id` */;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `v_employees`
--

/*!50001 DROP VIEW IF EXISTS `v_employees`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_uca1400_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`user7`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_employees` AS select `e`.`id` AS `id`,`e`.`name` AS `name`,`e`.`description` AS `description`,`e`.`employee_code` AS `employee_code`,`e`.`gender` AS `gender`,`e`.`birth_date` AS `birth_date`,`e`.`email` AS `email`,`e`.`phone` AS `phone`,`e`.`address` AS `address`,`e`.`image_path` AS `image_path`,`e`.`status` AS `status`,`e`.`joined_at` AS `joined_at`,`e`.`resigned_at` AS `resigned_at`,`c`.`id` AS `company_id`,`c`.`name` AS `company_name`,`d`.`id` AS `department_id`,`d`.`name` AS `department_name`,`t`.`id` AS `team_id`,`t`.`name` AS `team_name`,`ra`.`id` AS `rank_id`,`ra`.`name` AS `rank_name`,`po`.`id` AS `position_id`,`po`.`name` AS `position_name`,`ro`.`id` AS `role_id`,`ro`.`name` AS `role_name`,`pr`.`id` AS `privilege_id`,`pr`.`name` AS `privilege_name`,`e`.`is_active` AS `is_active`,`e`.`created_at` AS `created_at`,`e`.`updated_at` AS `updated_at`,`e`.`deleted_at` AS `deleted_at` from (((((((`tb_employees` `e` left join `tb_organization_teams` `t` on(`t`.`id` = `e`.`team_id`)) left join `tb_organization_departments` `d` on(`d`.`id` = `t`.`department_id`)) left join `tb_organization_companies` `c` on(`c`.`id` = `d`.`company_id`)) left join `tb_organization_ranks` `ra` on(`ra`.`id` = `e`.`rank_id`)) left join `tb_organization_positions` `po` on(`po`.`id` = `e`.`position_id`)) left join `tb_organization_roles` `ro` on(`ro`.`id` = `e`.`role_id`)) left join `tb_organization_privileges` `pr` on(`pr`.`id` = `e`.`privilege_id`)) order by `e`.`created_at` limit 1000 */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_posts`
--

/*!50001 DROP VIEW IF EXISTS `v_posts`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_uca1400_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_posts` AS select `p`.`id` AS `id`,`p`.`post_category_id` AS `post_category_id`,`pc`.`name` AS `post_category_name`,`pc`.`parent_id` AS `parent_id`,`p`.`employee_id` AS `employee_id`,`e`.`name` AS `employee_name`,`p`.`title` AS `title`,`p`.`content` AS `content`,`p`.`view_count` AS `view_count`,`p`.`comments` AS `comments`,`p`.`comment_at` AS `comment_at`,`p`.`created_at` AS `created_at`,`p`.`updated_at` AS `updated_at`,`p`.`deleted_at` AS `deleted_at` from ((`tb_posts` `p` left join `tb_post_category` `pc` on(`p`.`post_category_id` = `pc`.`id`)) left join `tb_employees` `e` on(`p`.`employee_id` = `e`.`id`)) where 1 = 1 order by `p`.`created_at` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_project_tasks`
--

/*!50001 DROP VIEW IF EXISTS `v_project_tasks`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_uca1400_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`user7`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_project_tasks` AS select `t`.`id` AS `id`,`t`.`project_id` AS `project_id`,`t`.`name` AS `name`,`t`.`description` AS `description`,`t`.`progress` AS `progress`,`t`.`start_date` AS `start_date`,`t`.`end_date` AS `end_date`,`t`.`status` AS `status`,`t`.`created_at` AS `created_at`,`t`.`updated_at` AS `updated_at` from (`tb_project_tasks` `t` left join `tb_projects` `p` on(`p`.`id` = `t`.`project_id`)) order by `t`.`created_at` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_projects`
--

/*!50001 DROP VIEW IF EXISTS `v_projects`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_uca1400_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`user7`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_projects` AS select `p`.`id` AS `id`,`p`.`customer_id` AS `customer_id`,`p`.`name` AS `name`,`p`.`description` AS `description`,`p`.`progress` AS `progress`,`p`.`start_date` AS `start_date`,`p`.`end_date` AS `end_date`,`p`.`status` AS `status`,`p`.`created_at` AS `created_at`,`p`.`updated_at` AS `updated_at`,`p`.`deleted_at` AS `deleted_at` from `tb_projects` `p` order by `p`.`updated_at` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_teams`
--

/*!50001 DROP VIEW IF EXISTS `v_teams`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_uca1400_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_teams` AS select `c`.`id` + 1000 AS `id`,`c`.`id` AS `origin_id`,0 AS `depth`,`c`.`name` AS `name`,`c`.`description` AS `description`,`c`.`created_at` AS `created_at`,`c`.`updated_at` AS `updated_at`,NULL AS `parent_id` from `tb_organization_companies` `c` union all select `d`.`id` + 2000 AS `id`,`d`.`id` AS `origin_id`,1 AS `depth`,`d`.`name` AS `name`,`d`.`description` AS `description`,`d`.`created_at` AS `created_at`,`d`.`updated_at` AS `updated_at`,`d`.`company_id` + 1000 AS `parent_id` from `tb_organization_departments` `d` union all select `t`.`id` + 3000 AS `id`,`t`.`id` AS `origin_id`,2 AS `depth`,`t`.`name` AS `name`,`t`.`description` AS `description`,`t`.`created_at` AS `created_at`,`t`.`updated_at` AS `updated_at`,`t`.`department_id` + 2000 AS `parent_id` from `tb_organization_teams` `t` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2025-11-20 11:02:07
