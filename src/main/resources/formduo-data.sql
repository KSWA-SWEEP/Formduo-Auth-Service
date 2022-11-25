-- MySQL dump 10.13  Distrib 8.0.28, for macos11 (x86_64)
--
-- Host: 210.109.60.247    Database: sweep
-- ------------------------------------------------------
-- Server version	5.7.33-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
-- SET @MYSQLDUMP_TEMP_LOG_BIN = @@SESSION.SQL_LOG_BIN;
-- SET @@SESSION.SQL_LOG_BIN= 0;

--
-- GTID state at the beginning of the backup
--

-- SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ 'a07705b1-4533-11ed-92bf-fa163e18e2ef:1-20524';

SET foreign_key_checks = 0;
DROP TABLE IF EXISTS `member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `member` (
                          `member_id` bigint(20) NOT NULL AUTO_INCREMENT,
                          `activated` bit(1) DEFAULT NULL,
                          `email` varchar(255) COLLATE utf8mb4_bin NOT NULL,
                          `password` varchar(255) COLLATE utf8mb4_bin NOT NULL,
                          `username` varchar(50) COLLATE utf8mb4_bin NOT NULL,
                          `red_dt` datetime DEFAULT NULL,
                          `upd_dt` datetime DEFAULT NULL,
                          `del_yn` char(1) COLLATE utf8mb4_bin DEFAULT NULL,
                          `reg_dt` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
                          PRIMARY KEY (`member_id`),
                          UNIQUE KEY `UK_mbmcqelty0fbrvxp1q58dn57t` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=82 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `member_authority`
--
DROP TABLE IF EXISTS `member_authority`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `member_authority` (
                                    `member_id` bigint(20) NOT NULL,
                                    `authority_name` varchar(50) COLLATE utf8mb4_bin NOT NULL,
                                    PRIMARY KEY (`member_id`,`authority_name`),
                                    KEY `FKasnmjar8jr5gaxvd7966p19ir` (`authority_name`),
                                    CONSTRAINT `FK8uf5ff5jr0nuvbj4yfp5ob9sq` FOREIGN KEY (`member_id`) REFERENCES `member` (`member_id`),
                                    CONSTRAINT `FKasnmjar8jr5gaxvd7966p19ir` FOREIGN KEY (`authority_name`) REFERENCES `authority` (`authority_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `authority`
--
DROP TABLE IF EXISTS `authority`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `authority` (
                             `authority_name` varchar(50) COLLATE utf8mb4_bin NOT NULL,
                             PRIMARY KEY (`authority_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `authority`
--

LOCK TABLES `authority` WRITE;
/*!40000 ALTER TABLE `authority` DISABLE KEYS */;
INSERT INTO `authority` VALUES ('ROLE_ADMIN'),('ROLE_USER');
/*!40000 ALTER TABLE `authority` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member`
--




--
-- Table structure for table `refresh_token`
--

DROP TABLE IF EXISTS `refresh_token`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `refresh_token` (
                                 `email` varchar(255) COLLATE utf8mb4_bin NOT NULL,
                                 `value` varchar(255) COLLATE utf8mb4_bin NOT NULL,
                                 PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `tb_qbox`
--

DROP TABLE IF EXISTS `tb_qbox`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_qbox` (
                           `q_id` int(11) NOT NULL AUTO_INCREMENT,
                           `content_yn` char(1) COLLATE utf8mb4_bin DEFAULT NULL,
                           `del_yn` char(1) COLLATE utf8mb4_bin DEFAULT NULL,
                           `name` varchar(255) COLLATE utf8mb4_bin NOT NULL,
                           `q_contents` json NOT NULL,
                           `q_image` varchar(255) COLLATE utf8mb4_bin NOT NULL,
                           `q_info` varchar(255) COLLATE utf8mb4_bin NOT NULL,
                           `q_multi` varchar(255) COLLATE utf8mb4_bin NOT NULL,
                           `q_title` varchar(255) COLLATE utf8mb4_bin NOT NULL,
                           `q_video` varchar(255) COLLATE utf8mb4_bin NOT NULL,
                           `reg_dt` datetime DEFAULT NULL,
                           `upd_dt` datetime DEFAULT NULL,
                           PRIMARY KEY (`q_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_qbox`
--

LOCK TABLES `tb_qbox` WRITE;
/*!40000 ALTER TABLE `tb_qbox` DISABLE KEYS */;
INSERT INTO `tb_qbox` VALUES (1,'y','N','string','[{\"additionalProp1\": {}, \"additionalProp2\": {}, \"additionalProp3\": {}}]','string','string','string','string','string','2022-10-25 19:52:36','2022-10-25 19:52:36'),(2,'y','N','string','[{\"additionalProp1\": {}, \"additionalProp2\": {}, \"additionalProp3\": {}}]','string','string','string','string','string','2022-10-25 19:55:55','2022-10-25 19:55:55'),(3,'Y','N','string','[{\"additionalProp1\": {}, \"additionalProp2\": {}, \"additionalProp3\": {}}]','string','string','string','string','string','2022-10-26 00:16:47','2022-10-26 00:16:47'),(4,'y','N','string','[{\"additionalProp1\": {}, \"additionalProp2\": {}, \"additionalProp3\": {}}]','string','string','string','string','string','2022-10-26 00:18:37','2022-10-26 00:18:37'),(5,'y','N','객관식','[{\"qContentId\": 1, \"qContentVal\": \"학생\"}, {\"qContentId\": 2, \"qContentVal\": \"주부\"}, {\"qContentId\": 3, \"qContentVal\": \"회사원\"}, {\"qContentId\": 4, \"qContentVal\": \"자영업자\"}, {\"qContentId\": 5, \"qContentVal\": \"농부\"}, {\"qContentId\": 6, \"qContentVal\": \"공무원\"}, {\"qContentId\": 7, \"qContentVal\": \"엔지니어\"}, {\"qContentId\": 8, \"qContentVal\": \"무직\"}]','','','','','','2022-10-26 00:21:50','2022-10-26 00:21:50'),(6,'y','N','객관식','[{\"qContentId\": 1, \"qContentVal\": \"학생\"}]','','','','본인의 직업은 무엇입니까?','','2022-10-26 00:24:10','2022-10-26 00:24:10'),(7,'n','N','주관식','[{\"qContentId\": 1, \"qContentVal\": \"\"}]','','ex)20','','나이를 입력하세요','','2022-10-26 00:38:30','2022-10-26 00:38:30'),(8,'n','N','날짜','[{\"qContentId\": 1, \"qContentVal\": \"\"}]','','','','생일을 입력하세요.','','2022-10-26 00:39:00','2022-10-26 00:39:00'),(9,'n','N','주관식','[{\"qContentId\": 1, \"qContentVal\": \"\"}]','','ex) test@gmail.com','','이메일을 입력하세요.','','2022-10-26 00:39:29','2022-10-26 00:39:29'),(10,'y','N','체크박스','[{\"qContentId\": 1, \"qContentVal\": \"한식\"}, {\"qContentId\": 2, \"qContentVal\": \"양식\"}, {\"qContentId\": 3, \"qContentVal\": \"중식\"}, {\"qContentId\": 4, \"qContentVal\": \"일식\"}]','','','','오늘 점심 메뉴는?','','2022-10-26 00:42:16','2022-10-26 00:42:16'),(11,'y','N','드롭박스','[{\"qContentId\": 1, \"qContentVal\": \"경영대학\"}, {\"qContentId\": 2, \"qContentVal\": \"사회과학대학\"}, {\"qContentId\": 3, \"qContentVal\": \"법과대학\"}, {\"qContentId\": 4, \"qContentVal\": \"IT융합대학\"}, {\"qContentId\": 5, \"qContentVal\": \"사회과학대학\"}, {\"qContentId\": 6, \"qContentVal\": \"예술체육대학\"}, {\"qContentId\": 7, \"qContentVal\": \"공과대학\"}, {\"qContentId\": 8, \"qContentVal\": \"의과대학\"}, {\"qContentId\": 9, \"qContentVal\": \"인문대학\"}]','','정확히 일치하는 대학명이 없다면, 비슷한 계열의 대학을 선택하세요.','','본인의 소속을 선택하세요.','','2022-10-26 00:44:10','2022-10-26 00:44:10'),(12,'y','N','드롭박스','[{\"qContentId\": 1, \"qContentVal\": \"사장\"}, {\"qContentId\": 2, \"qContentVal\": \"부사장\"}, {\"qContentId\": 3, \"qContentVal\": \"전무\"}, {\"qContentId\": 4, \"qContentVal\": \"상무\"}, {\"qContentId\": 5, \"qContentVal\": \"이사\"}, {\"qContentId\": 6, \"qContentVal\": \"부장\"}, {\"qContentId\": 7, \"qContentVal\": \"차장\"}, {\"qContentId\": 8, \"qContentVal\": \"과장\"}, {\"qContentId\": 9, \"qContentVal\": \"대리\"}, {\"qContentId\": 10, \"qContentVal\": \"주임\"}, {\"qContentId\": 11, \"qContentVal\": \"사원\"}, {\"qContentId\": 12, \"qContentVal\": \"인턴\"}]','','','','본인의 직책을 선택하세요.','','2022-10-26 00:45:37','2022-10-26 00:45:37'),(13,'y','N','드롭박스','[{\"qContentId\": 1, \"qContentVal\": \"INFJ\"}, {\"qContentId\": 2, \"qContentVal\": \"INFP\"}, {\"qContentId\": 3, \"qContentVal\": \"INTJ\"}, {\"qContentId\": 4, \"qContentVal\": \"INTP\"}, {\"qContentId\": 5, \"qContentVal\": \"ISFJ\"}, {\"qContentId\": 6, \"qContentVal\": \"ISFP\"}, {\"qContentId\": 7, \"qContentVal\": \"ISTJ\"}, {\"qContentId\": 8, \"qContentVal\": \"ISTP\"}, {\"qContentId\": 9, \"qContentVal\": \"ENFJ\"}, {\"qContentId\": 10, \"qContentVal\": \"ENFP\"}, {\"qContentId\": 11, \"qContentVal\": \"ENTJ\"}, {\"qContentId\": 12, \"qContentVal\": \"ENTP\"}, {\"qContentId\": 13, \"qContentVal\": \"ESFJ\"}, {\"qContentId\": 14, \"qContentVal\": \"ESFP\"}, {\"qContentId\": 15, \"qContentVal\": \"ESTJ\"}, {\"qContentId\": 16, \"qContentVal\": \"ESTP\"}]','','','','본인의 MBTI를 선택하세요.','','2022-10-26 00:46:40','2022-10-26 00:46:40');
/*!40000 ALTER TABLE `tb_qbox` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_svy`
--

DROP TABLE IF EXISTS `tb_svy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_svy` (
                          `svy_id` int(11) NOT NULL AUTO_INCREMENT,
                          `del_yn` char(1) COLLATE utf8mb4_bin DEFAULT NULL,
                          `reg_dt` datetime DEFAULT NULL,
                          `reg_user` varchar(255) COLLATE utf8mb4_bin NOT NULL,
                          `svy_content` json DEFAULT NULL,
                          `svy_end_dt` datetime DEFAULT NULL,
                          `svy_end_msg` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
                          `svy_intro` longtext COLLATE utf8mb4_bin,
                          `svy_resp_count` int(11) DEFAULT NULL,
                          `svy_resp_max` int(11) DEFAULT NULL,
                          `svy_st` varchar(6) COLLATE utf8mb4_bin NOT NULL,
                          `svy_start_dt` datetime DEFAULT NULL,
                          `svy_title` varchar(30) COLLATE utf8mb4_bin NOT NULL,
                          `upd_dt` datetime DEFAULT NULL,
                          `reg_id` bigint(20) DEFAULT NULL,
                          `svy_type` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
                          PRIMARY KEY (`svy_id`),
                          KEY `FKkjh6evlkwgi43qqyr85qthoey` (`reg_id`),
                          CONSTRAINT `FKkjh6evlkwgi43qqyr85qthoey` FOREIGN KEY (`reg_id`) REFERENCES `member` (`member_id`)
) ENGINE=InnoDB AUTO_INCREMENT=620 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table `tb_svy_resp`
--

DROP TABLE IF EXISTS `tb_svy_resp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_svy_resp` (
                               `svy_resp_id` int(11) NOT NULL AUTO_INCREMENT,
                               `svy_resp_content` json NOT NULL,
                               `svy_resp_dt` datetime DEFAULT NULL,
                               `svy_id` int(11) DEFAULT NULL,
                               `survey` int(11) DEFAULT NULL,
                               PRIMARY KEY (`svy_resp_id`),
                               KEY `FK5sqmdcm9ri6mqrsj716ry2c6g` (`svy_id`),
                               KEY `FKd761jtkhvbu74skaorwo96x4x` (`survey`),
                               CONSTRAINT `FK5sqmdcm9ri6mqrsj716ry2c6g` FOREIGN KEY (`svy_id`) REFERENCES `tb_svy` (`svy_id`),
                               CONSTRAINT `FKd761jtkhvbu74skaorwo96x4x` FOREIGN KEY (`survey`) REFERENCES `tb_svy` (`svy_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2995 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
SET foreign_key_checks = 1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_svy_resp`
--
-- SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-11-17  1:25:19

-- INSERT INTO AUTHORITY(AUTHORITY_NAME)
-- VALUES('ROLE_ADMIN'),
--       ('ROLE_USER'),
--       ('GUEST');