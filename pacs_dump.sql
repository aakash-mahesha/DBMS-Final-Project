CREATE DATABASE  IF NOT EXISTS `pacs` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `pacs`;
-- MySQL dump 10.13  Distrib 8.0.34, for Win64 (x86_64)
--
-- Host: localhost    Database: pacs
-- ------------------------------------------------------
-- Server version	8.0.34

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

--
-- Table structure for table `agency_partnered_vet_hospitals`
--

DROP TABLE IF EXISTS `agency_partnered_vet_hospitals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `agency_partnered_vet_hospitals` (
  `agency_name` varchar(50) NOT NULL,
  `hospital_name` varchar(50) NOT NULL,
  KEY `partnered_agency_fk` (`agency_name`),
  KEY `partnered_vet_fk` (`hospital_name`),
  CONSTRAINT `partnered_agency_fk` FOREIGN KEY (`agency_name`) REFERENCES `animal_agency` (`agency_name`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `partnered_vet_fk` FOREIGN KEY (`hospital_name`) REFERENCES `vet_hospital` (`hospital_name`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `agency_partnered_vet_hospitals`
--

LOCK TABLES `agency_partnered_vet_hospitals` WRITE;
/*!40000 ALTER TABLE `agency_partnered_vet_hospitals` DISABLE KEYS */;
INSERT INTO `agency_partnered_vet_hospitals` VALUES ('Happy Paws Rescue','City Pets Clinic'),('Wildlife Haven','Country Veterinary Care'),('Feathered Friends Sanctuary','Coastal Animal Hospital'),('Critter Care Center','Mountain View Vet Clinic'),('Aquatic Wonders Rescue','Paws and Claws Veterinary');
/*!40000 ALTER TABLE `agency_partnered_vet_hospitals` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `animal_agency`
--

DROP TABLE IF EXISTS `animal_agency`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `animal_agency` (
  `agency_name` varchar(50) NOT NULL,
  `agency_password` varchar(50) NOT NULL,
  `agency_street_no` varchar(10) NOT NULL,
  `agency_street_name` varchar(20) NOT NULL,
  `agency_city` varchar(20) NOT NULL,
  `agency_state` varchar(15) NOT NULL,
  `agency_zip` varchar(5) NOT NULL,
  `agency_contact_first_name` varchar(10) NOT NULL,
  `agency_contact_last_name` varchar(10) NOT NULL,
  `agency_contact_number` varchar(10) NOT NULL,
  PRIMARY KEY (`agency_name`),
  UNIQUE KEY `agency_contact_number` (`agency_contact_number`),
  UNIQUE KEY `agency_unique_address` (`agency_street_no`,`agency_street_name`,`agency_city`,`agency_state`,`agency_zip`),
  UNIQUE KEY `agency_unique_contact` (`agency_contact_first_name`,`agency_contact_last_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `animal_agency`
--

LOCK TABLES `animal_agency` WRITE;
/*!40000 ALTER TABLE `animal_agency` DISABLE KEYS */;
INSERT INTO `animal_agency` VALUES ('Aquatic Wonders Rescue','Aquatic202','202','Coral Street','Seaside','Oregon','97201','Hannah','Miller','5553456789'),('Bunny Bliss Shelter','Bunny606','606','Bunny Lane','Rabbitville','Ohio','44101','Sophie','Turner','5554321098'),('Critter Care Center','Critter101','101','Meadow Road','Woodland Hills','Colorado','80302','Nicholas','Brown','5558765432'),('Critter Cove Rescue','Critter707','707','Harbor View Road','Marine Haven','California','92614','Lucas','White','5558901234'),('Feathered Friends Sanctuary','Feathered789','789','Skyline Drive','Aviaryville','Florida','33123','Isabella','Taylor','5552345678'),('Happy Paws Rescue','HappyPaws123','123','Sunset Avenue','Sunsetville','California','90210','Emily','Johnson','5551234567'),('Horse Haven Ranch','Horse505','505','Stable Drive','Equestrian Meadows','Kentucky','40202','Oliver','Anderson','5556543210'),('Purrfect Companions','Purrfect303','303','Whisker Lane','Feline City','New York','10001','Elijah','Clark','5557654321'),('Scales and Tails Haven','Scales404','404','Reptile Road','Herpetopolis','Arizona','85001','Grace','Garcia','5552345679'),('Wildlife Haven','Wildlife456','456','Forest Lane','Naturetown','Texas','75001','Daniel','Smith','5559876543');
/*!40000 ALTER TABLE `animal_agency` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `doctor`
--

DROP TABLE IF EXISTS `doctor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `doctor` (
  `doctor_id` varchar(10) NOT NULL,
  `doctor_first_name` varchar(20) NOT NULL,
  `doctor_last_name` varchar(20) NOT NULL,
  `degree` varchar(10) DEFAULT NULL,
  `experience` int DEFAULT NULL,
  `works_at_hospital_name` varchar(50) NOT NULL,
  PRIMARY KEY (`doctor_id`),
  KEY `hospital_name_fk` (`works_at_hospital_name`),
  CONSTRAINT `hospital_name_fk` FOREIGN KEY (`works_at_hospital_name`) REFERENCES `vet_hospital` (`hospital_name`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `doctor`
--

LOCK TABLES `doctor` WRITE;
/*!40000 ALTER TABLE `doctor` DISABLE KEYS */;
INSERT INTO `doctor` VALUES ('D001','John','Smith','DVM',5,'City Pets Clinic'),('D002','Emily','Jones','VMD',8,'City Pets Clinic'),('D003','Daniel','Miller','DVM',3,'Country Veterinary Care'),('D004','Emma','Wilson','VMD',6,'Coastal Animal Hospital'),('D005','Nicholas','Taylor','DVM',4,'Mountain View Vet Clinic'),('D006','Sophia','Brown','VMD',7,'Mountain View Vet Clinic');
/*!40000 ALTER TABLE `doctor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pet`
--

DROP TABLE IF EXISTS `pet`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pet` (
  `pet_id` int NOT NULL AUTO_INCREMENT,
  `pet_name` varchar(10) NOT NULL,
  `pet_type` enum('Dog','Cat','Bird','Rodents') NOT NULL,
  `age` int NOT NULL,
  `height` int NOT NULL,
  `weight` int NOT NULL,
  `color` varchar(10) NOT NULL,
  `breed_name` varchar(20) DEFAULT NULL,
  `adopted` tinyint(1) NOT NULL,
  `adopted_by` varchar(20) DEFAULT NULL,
  `adoption_date` date DEFAULT NULL,
  `provided_by_agency` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`pet_id`),
  KEY `breed_name_fk` (`breed_name`),
  KEY `provided_agency_fk` (`provided_by_agency`),
  KEY `adopted_by_fk` (`adopted_by`),
  CONSTRAINT `adopted_by_fk` FOREIGN KEY (`adopted_by`) REFERENCES `user` (`username`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `breed_name_fk` FOREIGN KEY (`breed_name`) REFERENCES `pet_breed` (`breed_name`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `provided_agency_fk` FOREIGN KEY (`provided_by_agency`) REFERENCES `animal_agency` (`agency_name`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `check_adopted_false` CHECK (((`adopted` = 1) or ((`adopted_by` is null) and (`adoption_date` is null)))),
  CONSTRAINT `check_adopted_true` CHECK (((`adopted` = 0) or ((`adopted_by` is not null) and (`adoption_date` is not null))))
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pet`
--

LOCK TABLES `pet` WRITE;
/*!40000 ALTER TABLE `pet` DISABLE KEYS */;
INSERT INTO `pet` VALUES (1,'Buddy','Dog',3,12,25,'Brown','beagle',0,NULL,NULL,'Happy Paws Rescue'),(2,'Luna','Cat',2,8,10,'Gray','persian_cat',1,'john_doe','2023-01-15','Wildlife Haven'),(3,'Kiwi','Bird',1,6,1,'Green','lovebird',0,NULL,NULL,'Happy Paws Rescue'),(4,'Nibbles','Rodents',1,4,0,'White','guinea_pig',0,NULL,NULL,'Wildlife Haven'),(5,'Max','Dog',4,15,30,'Golden','golden_retriever',1,'alice_smith','2022-11-05','Happy Paws Rescue');
/*!40000 ALTER TABLE `pet` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pet_breed`
--

DROP TABLE IF EXISTS `pet_breed`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pet_breed` (
  `breed_name` varchar(20) NOT NULL,
  `breed_description` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`breed_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pet_breed`
--

LOCK TABLES `pet_breed` WRITE;
/*!40000 ALTER TABLE `pet_breed` DISABLE KEYS */;
INSERT INTO `pet_breed` VALUES ('beagle','Friendly, curious, and great with families'),('bengal_cat','Distinctive spotted or marbled coat pattern'),('budgerigar','Commonly known as the budgie, a small parakeet'),('bulldog','Docile, willful, and friendly'),('cockatiel','Small, crested bird with a distinctive appearance'),('cockatoo','Large parrot with a distinctive crest'),('gerbil','Small burrowing rodent with a long tail'),('german_shepherd','Intelligent, versatile, and loyal'),('golden_retriever','Friendly and intelligent breed known for retrieving'),('guinea_pig','Social and docile rodent, popular as a companion animal'),('hamster','Small, nocturnal rodent often kept as a pet'),('lovebird','Small, sociable birds that are often kept in pairs'),('maine_coon','One of the largest domesticated cat breeds'),('mouse','Small, intelligent rodents often kept in cages'),('parakeet','Small and colorful species of pet parrot'),('persian_cat','Long-haired breed known for its distinctive appearance'),('poodle','Highly intelligent and trainable dog breed'),('ragdoll','Known for its docile temperament and striking blue eyes'),('rat','Intelligent and social animals often kept as pets'),('siamese_cat','Distinctive short-haired breed with blue almond-shaped eyes');
/*!40000 ALTER TABLE `pet_breed` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pet_image`
--

DROP TABLE IF EXISTS `pet_image`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pet_image` (
  `image_id` int NOT NULL AUTO_INCREMENT,
  `image_url` varchar(500) NOT NULL,
  `image_of_pet` int NOT NULL,
  PRIMARY KEY (`image_id`),
  KEY `pet_fk` (`image_of_pet`),
  CONSTRAINT `pet_fk` FOREIGN KEY (`image_of_pet`) REFERENCES `pet` (`pet_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pet_image`
--

LOCK TABLES `pet_image` WRITE;
/*!40000 ALTER TABLE `pet_image` DISABLE KEYS */;
/*!40000 ALTER TABLE `pet_image` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pet_visit_doctor`
--

DROP TABLE IF EXISTS `pet_visit_doctor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pet_visit_doctor` (
  `pet_id` int DEFAULT NULL,
  `doctor_id` varchar(10) DEFAULT NULL,
  `visit_id` int NOT NULL AUTO_INCREMENT,
  `visit_date` date NOT NULL,
  `diagnosis` varchar(100) NOT NULL,
  `medications` varchar(50) NOT NULL,
  `health_level` enum('Great','Good','Moderate','Need Care') NOT NULL,
  PRIMARY KEY (`visit_id`),
  KEY `doctor_visit_pet_id_fk` (`pet_id`),
  KEY `doctor_fk` (`doctor_id`),
  CONSTRAINT `doctor_fk` FOREIGN KEY (`doctor_id`) REFERENCES `doctor` (`doctor_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `doctor_visit_pet_id_fk` FOREIGN KEY (`pet_id`) REFERENCES `pet` (`pet_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pet_visit_doctor`
--

LOCK TABLES `pet_visit_doctor` WRITE;
/*!40000 ALTER TABLE `pet_visit_doctor` DISABLE KEYS */;
INSERT INTO `pet_visit_doctor` VALUES (1,'D001',1,'2023-01-10','Routine checkup, all parameters normal','None','Great'),(2,'D002',2,'2023-01-15','Minor cough and sneezing','Prescribed antibiotics','Good'),(1,'D001',3,'2023-02-05','Limping on right hind leg','Prescribed pain relievers','Moderate'),(2,'D002',4,'2023-02-12','Healthy and active','None','Great'),(3,'D001',5,'2023-03-20','Feathers appear dull, possible nutrient deficiency','Prescribed avian supplement','Moderate'),(4,'D002',6,'2023-04-02','Small wound on tail, cleaned and bandaged','Prescribed topical ointment','Good');
/*!40000 ALTER TABLE `pet_visit_doctor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `username` varchar(20) NOT NULL,
  `user_password` varchar(20) NOT NULL,
  `email` varchar(50) NOT NULL,
  `first_name` varchar(20) NOT NULL,
  `last_name` varchar(20) NOT NULL,
  `address_id` int DEFAULT NULL,
  PRIMARY KEY (`username`),
  KEY `address_id_fk` (`address_id`),
  CONSTRAINT `address_id_fk` FOREIGN KEY (`address_id`) REFERENCES `user_address` (`address_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES ('Akm','Akm','Akm@gmail.com','Akm','Akm',NULL),('Akm2','Akm2','Akm2@gmail.com','Akm2','Akm2',NULL),('alice_smith','pass456','alice.smith@email.com','Alice','Smith',2),('amy_wilson','amyPass','amy.wilson@email.com','Amy','Wilson',10),('bob_jones','secret789','bob.jones@email.com','Bob','Jones',3),('chris_lee','chrisPass','chris.lee@email.com','Chris','Lee',9),('david_clark','david123','david.clark@email.com','David','Clark',7),('emma_white','emmaPass','emma.white@email.com','Emma','White',4),('john_doe','password123','john.doe@email.com','John','Doe',1),('linda_taylor','linda456','linda.taylor@email.com','Linda','Taylor',8),('mike_brown','mikePass','mike.brown@email.com','Mike','Brown',5),('sara_miller','saraPass','sara.miller@email.com','Sara','Miller',6);
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_address`
--

DROP TABLE IF EXISTS `user_address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_address` (
  `address_id` int NOT NULL AUTO_INCREMENT,
  `street_no` varchar(10) NOT NULL,
  `street_name` varchar(20) NOT NULL,
  `city` varchar(15) NOT NULL,
  `state` varchar(15) NOT NULL,
  `zip` int NOT NULL,
  PRIMARY KEY (`address_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_address`
--

LOCK TABLES `user_address` WRITE;
/*!40000 ALTER TABLE `user_address` DISABLE KEYS */;
INSERT INTO `user_address` VALUES (1,'123','Main Street','New York','New York',10001),(2,'456','Oak Avenue','Los Angeles','California',90001),(3,'789','Maple Lane','Chicago','Illinois',60601),(4,'101','Pine Street','Houston','Texas',77001),(5,'202','Cedar Road','Phoenix','Arizona',85001),(6,'303','Elm Boulevard','Philadelphia','Pennsylvania',19101),(7,'404','Spruce Drive','San Antonio','Texas',78201),(8,'505','Birch Lane','San Diego','California',92101),(9,'606','Holly Street','Dallas','Texas',75201),(10,'707','Sycamore Avenue','San Francisco','California',94101);
/*!40000 ALTER TABLE `user_address` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_comment_pets`
--

DROP TABLE IF EXISTS `user_comment_pets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_comment_pets` (
  `pet_id` int DEFAULT NULL,
  `username` varchar(20) DEFAULT NULL,
  `comment_id` int NOT NULL AUTO_INCREMENT,
  `comment_text` varchar(100) DEFAULT NULL,
  `comment_date` datetime DEFAULT NULL,
  PRIMARY KEY (`comment_id`),
  UNIQUE KEY `pet_id` (`pet_id`,`username`,`comment_id`),
  KEY `user_fk` (`username`),
  CONSTRAINT `pet_id_fk` FOREIGN KEY (`pet_id`) REFERENCES `pet` (`pet_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `user_fk` FOREIGN KEY (`username`) REFERENCES `user` (`username`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_comment_pets`
--

LOCK TABLES `user_comment_pets` WRITE;
/*!40000 ALTER TABLE `user_comment_pets` DISABLE KEYS */;
INSERT INTO `user_comment_pets` VALUES (1,'john_doe',1,'Buddy is such an energetic and friendly dog!','2023-01-20 08:30:00'),(2,'alice_smith',2,'Luna is the sweetest cat ever!','2023-01-21 10:45:00'),(1,'john_doe',3,'Buddy loves going for long walks in the park.','2023-01-22 15:20:00'),(2,'alice_smith',4,'Luna enjoys cuddling and purring.','2023-01-23 12:10:00'),(3,'emma_white',5,'Kiwi chirps happily every morning!','2023-01-24 09:05:00'),(4,'mike_brown',6,'Nibbles is a curious little rodent!','2023-01-25 14:30:00'),(5,'sara_miller',7,'Max, the Golden Retriever, is very playful!','2023-01-26 11:15:00');
/*!40000 ALTER TABLE `user_comment_pets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_pet_interactions`
--

DROP TABLE IF EXISTS `user_pet_interactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_pet_interactions` (
  `username` varchar(20) DEFAULT NULL,
  `pet_id` int DEFAULT NULL,
  `interaction_id` int NOT NULL AUTO_INCREMENT,
  `interaction_type` enum('Play','Feed','Pet') NOT NULL,
  `interaction_date` date NOT NULL,
  `interaction_start_time` time DEFAULT NULL,
  `interaction_end_time` time DEFAULT NULL,
  PRIMARY KEY (`interaction_id`),
  KEY `interaction_pet_id_fk` (`pet_id`),
  KEY `interaction_user_fk` (`username`),
  CONSTRAINT `interaction_pet_id_fk` FOREIGN KEY (`pet_id`) REFERENCES `pet` (`pet_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `interaction_user_fk` FOREIGN KEY (`username`) REFERENCES `user` (`username`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_pet_interactions`
--

LOCK TABLES `user_pet_interactions` WRITE;
/*!40000 ALTER TABLE `user_pet_interactions` DISABLE KEYS */;
INSERT INTO `user_pet_interactions` VALUES ('john_doe',1,1,'Play','2023-01-20','10:00:00','10:30:00'),('alice_smith',2,2,'Feed','2023-01-21','12:45:00','13:15:00'),('mike_brown',4,4,'Play','2023-01-23','11:00:00','11:30:00'),('sara_miller',5,5,'Feed','2023-01-24','09:30:00','10:00:00'),('john_doe',1,6,'Pet','2023-01-25','14:00:00','14:30:00'),('alice_smith',2,7,'Play','2023-01-26','16:30:00','17:00:00'),('emma_white',3,8,'Feed','2023-01-27','12:00:00','12:30:00'),('mike_brown',4,9,'Pet','2023-01-28','13:45:00','14:15:00'),('sara_miller',5,10,'Play','2023-01-29','10:30:00','11:00:00'),('Akm2',1,11,'Feed','2023-12-27','15:27:00','15:30:00'),('Akm2',1,12,'Feed','2023-12-27','15:27:00','15:30:00'),('Akm2',1,13,'Feed','2023-12-27','15:27:00','15:30:00'),('Akm2',1,14,'Feed','2023-12-27','15:27:00','15:30:00'),('Akm2',3,15,'Play','2023-12-26','16:56:00','16:56:00'),('Akm2',4,16,'Play','2023-12-26','03:56:00','05:58:00');
/*!40000 ALTER TABLE `user_pet_interactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vet_hospital`
--

DROP TABLE IF EXISTS `vet_hospital`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vet_hospital` (
  `hospital_name` varchar(50) NOT NULL,
  `hospital_street_no` varchar(10) NOT NULL,
  `hospital_street_name` varchar(20) NOT NULL,
  `hospital_city` varchar(15) NOT NULL,
  `hospital_state` varchar(15) NOT NULL,
  `hospital_zip` varchar(5) NOT NULL,
  `hospital_contact_first_name` varchar(10) NOT NULL,
  `hospital_contact_last_name` varchar(10) NOT NULL,
  `hospital_contact_number` varchar(10) NOT NULL,
  PRIMARY KEY (`hospital_name`),
  UNIQUE KEY `hospital_contact_number` (`hospital_contact_number`),
  UNIQUE KEY `hospital_unique_address` (`hospital_street_no`,`hospital_street_name`,`hospital_city`,`hospital_state`,`hospital_zip`),
  UNIQUE KEY `hospital_unique_contact` (`hospital_contact_first_name`,`hospital_contact_last_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vet_hospital`
--

LOCK TABLES `vet_hospital` WRITE;
/*!40000 ALTER TABLE `vet_hospital` DISABLE KEYS */;
INSERT INTO `vet_hospital` VALUES ('City Pets Clinic','321','Oak Street','Urbanville','California','90210','Alice','Johnson','5551234567'),('Coastal Animal Hospital','789','Palm Lane','Seaside','Florida','33123','Emma','Taylor','5552345678'),('Country Veterinary Care','456','Maple Avenue','Ruraltown','Texas','75001','John','Smith','5559876543'),('Golden State Animal Hospital','303','Redwood Boulevard','Valley City','California','94566','Ethan','Clark','5557654321'),('Harborview Animal Hospital','606','Sycamore Avenue','Harbor City','New York','10001','Ava','Turner','5554321098'),('Mountain View Vet Clinic','101','Pine Road','Hillside','Colorado','80302','Michael','Brown','5558765432'),('Paws and Claws Veterinary','202','Cedar Street','Woodland','Washington','98101','Sophia','Miller','5553456789'),('Riverfront Pet Clinic','404','Birch Lane','Riverside','Oregon','97201','Olivia','Garcia','5552345679'),('Skyline Veterinary Center','505','Spruce Drive','Mountainview','Arizona','85001','William','Anderson','5556543210'),('Sunset Pet Care','707','Lakeside Drive','Sunset Beach','Florida','33706','Logan','White','5558901234');
/*!40000 ALTER TABLE `vet_hospital` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'pacs'
--

--
-- Dumping routines for database 'pacs'
--
/*!50003 DROP PROCEDURE IF EXISTS `add_comment_to_database` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_comment_to_database`(
	IN c_pet_id INT,
    IN c_username VARCHAR(20),
    IN c_comment_text VARCHAR(100),
    IN c_comment_date DATETIME
)
BEGIN
    INSERT INTO user_comment_pets (pet_id, username, comment_text, comment_date)
    VALUES (c_pet_id, c_username, c_comment_text, c_comment_date);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `delete_comment_by_id` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_comment_by_id`(IN in_comment_id INT)
BEGIN
    DELETE FROM user_comment_pets WHERE comment_id = in_comment_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `delete_interaction_by_id` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_interaction_by_id`(
    IN in_interaction_id INT
)
BEGIN
    DELETE FROM user_pet_interactions WHERE interaction_id = in_interaction_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_all_pet_details` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_all_pet_details`(IN pet_id INT)
BEGIN
    SELECT * FROM pet WHERE pet.pet_id = pet_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_comment_by_id` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_comment_by_id`(IN in_comment_id INT)
BEGIN
    SELECT * FROM user_comment_pets WHERE comment_id = in_comment_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_interaction_details_by_id` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_interaction_details_by_id`(IN in_interaction_id INT)
BEGIN
    SELECT * FROM user_pet_interactions WHERE interaction_id = in_interaction_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_pet_images_links` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_pet_images_links`(IN pet_id INT)
BEGIN
	SELECT image_url FROM pet_image WHERE image_of_pet= pet_id;
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_pet_name_breed_image` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_pet_name_breed_image`()
BEGIN
    SELECT 
        pet.pet_id,
        pet.pet_name,
        pet_breed.breed_name,
        (
            SELECT pi.image_url
            FROM pet_image pi
            WHERE pi.image_of_pet = pet.pet_id
            ORDER BY pi.image_id ASC
            LIMIT 1
        ) AS image_link
    FROM 
        pet
    JOIN pet_breed ON pet.breed_name = pet_breed.breed_name
    WHERE pet.adopted = 0;
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_recent_pet_doctor_visit` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_recent_pet_doctor_visit`(IN pet_id_param INT)
BEGIN
    SELECT pvd.*, d.doctor_first_name, d.doctor_last_name, vh.hospital_name
    FROM pet_visit_doctor pvd
    JOIN doctor d ON pvd.doctor_id = d.doctor_id
    JOIN vet_hospital vh ON d.works_at_hospital_name = vh.hospital_name
    WHERE pvd.pet_id = pet_id_param
    ORDER BY pvd.visit_date DESC
    LIMIT 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_schedule_list_per_pet` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_schedule_list_per_pet`(
    IN in_pet_id INT,
    IN in_username VARCHAR(20)
)
BEGIN
    SELECT *
    FROM user_pet_interactions
    WHERE pet_id = in_pet_id AND username = in_username;
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_user_comments_for_pet` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_user_comments_for_pet`(IN pet_id_param INT)
BEGIN
    SELECT username, comment_text, comment_date FROM user_comment_pets WHERE pet_id = pet_id_param ORDER BY comment_date DESC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insert_user_pet_interaction` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_user_pet_interaction`(
    IN p_username VARCHAR(20),
    IN p_pet_id INT,
    IN p_interaction_type ENUM('Play','Feed','Pet'),
    IN p_interaction_date DATE,
    IN p_interaction_start_time TIME,
    IN p_interaction_end_time TIME
)
BEGIN
    INSERT INTO user_pet_interactions 
        (username, pet_id, interaction_type, interaction_date, interaction_start_time, interaction_end_time)
    VALUES (p_username, p_pet_id, p_interaction_type, p_interaction_date, p_interaction_start_time, p_interaction_end_time);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_interaction_details` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_interaction_details`(
    IN in_interaction_id INT,
    IN in_new_visit_date DATE,
    IN in_new_start_time TIME,
    IN in_new_end_time TIME,
    IN in_new_visit_type ENUM('Play','Feed','Pet')
)
BEGIN
    UPDATE user_pet_interactions
    SET interaction_date = in_new_visit_date,
        interaction_start_time = in_new_start_time,
        interaction_end_time = in_new_end_time,
        interaction_type = in_new_visit_type
    WHERE interaction_id = in_interaction_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;



-- Dump completed on 2023-12-04  2:43:50
