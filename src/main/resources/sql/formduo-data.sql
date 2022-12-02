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
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
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
-- insert test account
--
-- INSERT INTO `member` VALUES (``, `test@formduo.com`, `{bcrypt}$2a$10$Hr84RxtEWAZazMdKO9jZUugaI3gpRIVG3yhJHSn2qlCWhAwSI0pem`, `test user`, NULL, NULL, `N`, NOW());
-- INSERT INTO `member_authority` VALUES ((SELECT member_id FROM MEMBER WHERE email = `test@formduo.com`), `ROLE_USER`)



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