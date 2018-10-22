CREATE DATABASE  IF NOT EXISTS `agilemeter` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `agilemeter`;
-- MySQL dump 10.13  Distrib 5.7.17, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: agilemeter
-- ------------------------------------------------------
-- Server version	5.7.23

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Asignaciones`
--

DROP TABLE IF EXISTS `Asignaciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Asignaciones` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(50) NOT NULL,
  `Peso` int(11) NOT NULL,
  `SectionId` int(11) NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `IX_Asignaciones_SectionId` (`SectionId`),
  CONSTRAINT `FK_Asignaciones_Sections_SectionId` FOREIGN KEY (`SectionId`) REFERENCES `Sections` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Asignaciones`
--

LOCK TABLES `Asignaciones` WRITE;
/*!40000 ALTER TABLE `Asignaciones` DISABLE KEYS */;
INSERT INTO `Asignaciones` VALUES (1,'Daily',5,1),(2,'Retrospective',30,1),(3,'Sprint Review',20,1),(4,'Sprint Planning',15,1),(5,'Refinement',10,1),(6,'Product Owner',20,2),(7,'Scrum Master',60,2),(8,'Equipo Desarrollo',20,2),(9,'Product Backlog',30,3),(10,'Sprint Backlog',20,3),(11,'Incremento',15,3),(12,'Iteracion',5,3),(13,'Metricas',10,3);
/*!40000 ALTER TABLE `Asignaciones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Evaluaciones`
--

DROP TABLE IF EXISTS `Evaluaciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Evaluaciones` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Estado` bit(1) NOT NULL,
  `Fecha` datetime(6) NOT NULL,
  `NotasEvaluacion` varchar(4000) DEFAULT NULL,
  `NotasObjetivos` varchar(4000) DEFAULT NULL,
  `ProyectoId` int(11) NOT NULL,
  `Puntuacion` double NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `IX_Evaluaciones_ProyectoId` (`ProyectoId`),
  CONSTRAINT `FK_Evaluaciones_Proyectos_ProyectoId` FOREIGN KEY (`ProyectoId`) REFERENCES `Proyectos` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Evaluaciones`
--

LOCK TABLES `Evaluaciones` WRITE;
/*!40000 ALTER TABLE `Evaluaciones` DISABLE KEYS */;
INSERT INTO `Evaluaciones` VALUES (1,'','2018-10-22 11:55:37.489437','TEst','dfgndfh',2,14.8),(2,'\0','2018-10-22 14:17:41.805559',NULL,NULL,1,0);
/*!40000 ALTER TABLE `Evaluaciones` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `agilemeter`.`evaluaciones_AFTER_INSERT` AFTER INSERT ON `Evaluaciones` FOR EACH ROW
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE PreId INT DEFAULT NEW.Id;
    DECLARE ids INT;
    DECLARE cur CURSOR FOR SELECT id FROM Preguntas;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;
        ins_loop: LOOP
            FETCH cur INTO ids;
            IF done THEN
                LEAVE ins_loop;
            END IF;
            INSERT INTO Respuestas (Estado, PreguntaId, EvaluacionId) VALUES (0 , ids , PreId);
        END LOOP;
    CLOSE cur;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `NotasAsignaciones`
--

DROP TABLE IF EXISTS `NotasAsignaciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `NotasAsignaciones` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `AsignacionId` int(11) NOT NULL,
  `EvaluacionId` int(11) NOT NULL,
  `Notas` varchar(4000) DEFAULT NULL,
  PRIMARY KEY (`Id`),
  KEY `IX_NotasAsignaciones_AsignacionId` (`AsignacionId`),
  KEY `IX_NotasAsignaciones_EvaluacionId` (`EvaluacionId`),
  CONSTRAINT `FK_NotasAsignaciones_Asignaciones_AsignacionId` FOREIGN KEY (`AsignacionId`) REFERENCES `Asignaciones` (`Id`) ON DELETE CASCADE,
  CONSTRAINT `FK_NotasAsignaciones_Evaluaciones_EvaluacionId` FOREIGN KEY (`EvaluacionId`) REFERENCES `Evaluaciones` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `NotasAsignaciones`
--

LOCK TABLES `NotasAsignaciones` WRITE;
/*!40000 ALTER TABLE `NotasAsignaciones` DISABLE KEYS */;
/*!40000 ALTER TABLE `NotasAsignaciones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `NotasSections`
--

DROP TABLE IF EXISTS `NotasSections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `NotasSections` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `EvaluacionId` int(11) NOT NULL,
  `Notas` varchar(4000) DEFAULT NULL,
  `SectionId` int(11) NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `IX_NotasSections_EvaluacionId` (`EvaluacionId`),
  KEY `IX_NotasSections_SectionId` (`SectionId`),
  CONSTRAINT `FK_NotasSections_Evaluaciones_EvaluacionId` FOREIGN KEY (`EvaluacionId`) REFERENCES `Evaluaciones` (`Id`) ON DELETE CASCADE,
  CONSTRAINT `FK_NotasSections_Sections_SectionId` FOREIGN KEY (`SectionId`) REFERENCES `Sections` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `NotasSections`
--

LOCK TABLES `NotasSections` WRITE;
/*!40000 ALTER TABLE `NotasSections` DISABLE KEYS */;
/*!40000 ALTER TABLE `NotasSections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Preguntas`
--

DROP TABLE IF EXISTS `Preguntas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Preguntas` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `AsignacionId` int(11) NOT NULL,
  `Correcta` longtext,
  `Pregunta` varchar(120) NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `IX_Preguntas_AsignacionId` (`AsignacionId`),
  CONSTRAINT `FK_Preguntas_Asignaciones_AsignacionId` FOREIGN KEY (`AsignacionId`) REFERENCES `Asignaciones` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=148 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Preguntas`
--

LOCK TABLES `Preguntas` WRITE;
/*!40000 ALTER TABLE `Preguntas` DISABLE KEYS */;
INSERT INTO `Preguntas` VALUES (40,1,NULL,'¿Se realiza la daily?'),(41,1,'Si','¿El equipo completo participa?'),(42,1,'Si','¿Se emplean como máximo 15 min?'),(43,1,'Si','¿Se mencionan los problemas e impedimentos?'),(44,1,'Si','¿Se revisan en cada daily los objetivos del Sprint?'),(45,1,'Si','¿Se realiza siempre a la misma hora y lugar?'),(46,1,'No','¿Participa gente que no pertenece al equipo?'),(47,2,NULL,'¿Se realiza la Retrospective al final de cada sprint?'),(48,2,'Si','¿Se plantean propuestas SMART?'),(49,2,'Si','¿Se implementan las propuestas?'),(50,2,'Si','¿Equipo al completo más PO participan?'),(51,2,'Si','¿Se analizan los problemas en profundidad?'),(52,2,'No','¿Participa gente que no pertenece al equipo?'),(53,2,'Si','¿Todo el equipo expresa su punto de vista?'),(54,2,'Si','¿Se analizan las métricas y su impacto durante la retro?'),(55,3,NULL,'¿Se realiza la Sprint Review al final de cada sprint?'),(56,3,'Si','¿Se muestra software funcionando y probado?'),(57,3,'Si','¿Se recibe feedback de interesados y PO?'),(58,3,'No','¿Se mencionan los items inacabados?'),(59,3,'Si','¿Se revisa si se ha alcanzado el objetivo del Sprint?'),(60,3,'No','¿Se muestran los items acabados al 99%?'),(61,4,NULL,'¿Se realiza Sprint Planning por cada Sprint?'),(62,4,'Si','¿El PO está disponible para dudas?'),(63,4,'Si','¿Está el PB preparado para el Sprint Planning?'),(64,4,'Si','¿El equipo completo participa?'),(65,4,'Si','¿El resultado de la sesión es el plan del Sprint?'),(66,4,'Si','¿El equipo completo cree que el plan es alcanzable?'),(67,4,'Si','¿El PO queda satisfecho con las prioridades?'),(68,4,'Si','¿Los PBI se dividen en tareas?'),(69,4,'Si','¿Las tareas son estimadas?'),(70,4,'Si','¿Se adquiere un compromiso por parte del equipo?'),(71,5,NULL,'¿Se realiza Refinement?'),(72,5,'Si','¿Es el PO quien decide cuando se hace un refinement?'),(73,5,'Si','¿El PO lleva las US definidas para discutir?'),(74,5,'Si','¿Se estima en tamaño relativo?'),(75,5,'Si','¿Existe DoR?'),(76,5,'Si','¿Se aplica DoR?'),(77,5,'Si','¿Se realizan preguntas y propuestas?'),(78,5,'Si','¿Participa todo el equipo?'),(79,5,'No','¿Participa en la estimación personas ajenas al equipo?'),(80,6,NULL,'¿Existe el rol de PO en el equipo?'),(81,6,'Si','¿El PO tiene poder para priorizar los elementos del PB?'),(82,6,'Si','¿El PO tiene el conocimiento suficiente para priorizar?'),(83,6,'Si','¿El PO tiene contacto directo con el equipo?'),(84,6,'Si','¿El PO tiene contacto directo con los interesados?'),(85,6,'Si','¿El PO tiene voz única (Si es equipo, solo hay una opinión)?'),(86,6,'Si','¿El PO tiene la visión del producto?'),(87,6,'No','¿El PO hace otras labores (codificar por ejemplo)?'),(88,6,'No','¿El PO toma decisiones técnicas?'),(89,7,NULL,'¿Existe el rol de SM en el equipo?'),(90,7,'Si','¿El SM se sienta con el equipo?'),(91,7,'Si','¿El SM se enfoca en la resolución de impedimentos?'),(92,7,'Si','¿El SM escala los impedimentos?'),(93,7,'No','¿El SM hace otras labores (codificar/analizar por ejemplo)?'),(94,7,'No','¿El SM toma decisiones técnicas o de negocio?'),(95,7,'Si','¿El SM ayuda/guía al PO para realizar correctamente su trabajo?'),(96,7,'Si','¿El SM empodera al equipo?'),(97,7,'No','¿El SM asume la responsabilidad si el equipo falla?'),(98,7,'Si','¿El SM permite que el equipo experimente y se equivoque?'),(99,7,'Si','¿Los líderes o managers de la organización conocen y/o comparten los principios ágiles?'),(100,8,'Si','¿El equipo tiene todas las habilidades necesarias?'),(101,8,'Si','¿Existen miembros del equipo encasillados, no conociendo absolutamente nada de otras áreas?'),(102,8,'Si','¿Los miembros del equipo se sientan juntos?'),(103,8,'Si','¿Hay com máximo 9 personas por equipo?'),(104,8,'No','¿Hay algún miembro del equipo que odie Scrum?'),(105,8,'No','¿Hay algún miembro del equipo profundamente desmotivado?'),(106,8,'Si','¿Tiene el equipo un drag factor interiorizado, planificado y consensuado con los stakeholders?'),(107,8,'No','¿Se realizan reuniones adicionales que estén fuera del framework de Scrum?'),(108,8,'Si','¿El equipo usa o dispone de herramientas para organizar sus tareas?'),(109,9,NULL,'¿Existe PB?'),(110,9,'Si','¿EL PB es visible y refleja la visión del producto?'),(111,9,'Si','¿Los PBI se priorizan por su valor de negocio?'),(112,9,'Si','¿Los PBI se estiman?'),(113,9,'Si','¿El equipo completo es quien realiza las estimaciones?'),(114,9,'Si','¿Los PBI son tan pequeños como para abordarse en un Sprint?'),(115,9,'Si','¿El PO entiende el propósito de todos los PBI?'),(116,10,NULL,'¿Existe SB?'),(117,10,'Si','¿El SB es visible y refleja el compromiso para el Sprint?'),(118,10,'Si','¿El SB se actualiza diariamente?'),(119,10,'Si','¿El SB es propiedad exclusiva del equipo?'),(120,11,NULL,'¿Existe DoD?'),(121,11,'Si','¿El DoD es alcanzable dentro de cada iteración?'),(122,11,'Si','¿El equipo respeta el DoD?'),(123,11,'Si','¿El Software entregado tiene calidad para subirse a producción si el negocio así lo pidiera?'),(124,11,'Si','¿Se actualiza el DoD?'),(125,11,'Si','¿Tanto PO como equipo están de acuerdo con el DoD?'),(126,12,NULL,'¿Existe iteraciones de tiempo fijo?'),(127,12,'Si','¿La longitud de las iteraciones está entre 2-4 semanas?'),(128,12,'Si','¿Siempre terminan a tiempo?'),(129,12,'No','¿El equipo es interrumpido durante una iteración?'),(130,12,'Si','¿El equipo normalmente entrega lo que comprometió?'),(131,12,'Si','¿Se ha cancelado alguna iteración que ha sido un fracaso?'),(132,13,NULL,'¿Se mide la velodidad del equipo?'),(133,13,'Si','¿Todos los PBI se estiman y se computan en la velocidad?'),(134,13,'Si','¿El PO usa la velocidad para planificar a futuro?'),(135,13,'Si','¿La velocidad sólo incluye PBI terminados?'),(136,13,'Si','¿El equipo tiene un Burndown por Sprint?'),(137,13,'Si','¿El Burndown es visible por todos los miembros del equipo?'),(138,13,'Si','¿El Burndown se actualiza diariamente?'),(139,13,'Si','¿El equipo conoce y entiende sus métricas?'),(140,13,NULL,'¿Se mide la velodidad del equipo?'),(141,13,'Si','¿Todos los PBI se estiman y se computan en la velocidad?'),(142,13,'Si','¿El PO usa la velocidad para planificar a futuro?'),(143,13,'Si','¿La velocidad sólo incluye PBI terminados?'),(144,13,'Si','¿El equipo tiene un Burndown por Sprint?'),(145,13,'Si','¿El Burndown es visible por todos los miembros del equipo?'),(146,13,'Si','¿El Burndown se actualiza diariamente?'),(147,13,'Si','¿El equipo conoce y entiende sus métricas?');
/*!40000 ALTER TABLE `Preguntas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Proyectos`
--

DROP TABLE IF EXISTS `Proyectos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Proyectos` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Fecha` datetime(6) NOT NULL,
  `Nombre` varchar(50) NOT NULL,
  `UserNombre` varchar(127) DEFAULT NULL,
  PRIMARY KEY (`Id`),
  KEY `IX_Proyectos_UserNombre` (`UserNombre`),
  CONSTRAINT `FK_Proyectos_Users_UserNombre` FOREIGN KEY (`UserNombre`) REFERENCES `Users` (`Nombre`) ON DELETE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Proyectos`
--

LOCK TABLES `Proyectos` WRITE;
/*!40000 ALTER TABLE `Proyectos` DISABLE KEYS */;
INSERT INTO `Proyectos` VALUES (1,'2018-07-10 00:00:00.000000','BCA','Admin'),(2,'2018-07-10 00:00:00.000000','TESCO','Admin'),(3,'2018-07-10 00:00:00.000000','BestDay','User'),(4,'2018-07-10 00:00:00.000000','TVE','User'),(5,'2018-07-10 00:00:00.000000','Proyecto Test','Test');
/*!40000 ALTER TABLE `Proyectos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Respuestas`
--

DROP TABLE IF EXISTS `Respuestas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Respuestas` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Estado` int(11) NOT NULL,
  `EvaluacionId` int(11) NOT NULL,
  `Notas` varchar(4000) DEFAULT NULL,
  `NotasAdmin` varchar(4000) DEFAULT NULL,
  `PreguntaId` int(11) NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `IX_Respuestas_EvaluacionId` (`EvaluacionId`),
  KEY `IX_Respuestas_PreguntaId` (`PreguntaId`),
  CONSTRAINT `FK_Respuestas_Evaluaciones_EvaluacionId` FOREIGN KEY (`EvaluacionId`) REFERENCES `Evaluaciones` (`Id`) ON DELETE CASCADE,
  CONSTRAINT `FK_Respuestas_Preguntas_PreguntaId` FOREIGN KEY (`PreguntaId`) REFERENCES `Preguntas` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=217 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Respuestas`
--

LOCK TABLES `Respuestas` WRITE;
/*!40000 ALTER TABLE `Respuestas` DISABLE KEYS */;
INSERT INTO `Respuestas` VALUES (1,2,1,NULL,NULL,40),(2,0,1,NULL,NULL,41),(3,0,1,NULL,NULL,42),(4,0,1,NULL,NULL,43),(5,0,1,NULL,NULL,44),(6,0,1,NULL,NULL,45),(7,0,1,NULL,NULL,46),(8,2,1,NULL,NULL,47),(9,0,1,NULL,NULL,48),(10,0,1,NULL,NULL,49),(11,0,1,NULL,NULL,50),(12,0,1,NULL,NULL,51),(13,0,1,NULL,NULL,52),(14,0,1,NULL,NULL,53),(15,0,1,NULL,NULL,54),(16,1,1,NULL,NULL,55),(17,1,1,NULL,NULL,56),(18,1,1,NULL,NULL,57),(19,2,1,NULL,NULL,58),(20,1,1,NULL,NULL,59),(21,2,1,NULL,NULL,60),(22,2,1,NULL,NULL,61),(23,0,1,NULL,NULL,62),(24,0,1,NULL,NULL,63),(25,0,1,NULL,NULL,64),(26,0,1,NULL,NULL,65),(27,0,1,NULL,NULL,66),(28,0,1,NULL,NULL,67),(29,0,1,NULL,NULL,68),(30,0,1,NULL,NULL,69),(31,0,1,NULL,NULL,70),(32,2,1,NULL,NULL,71),(33,0,1,NULL,NULL,72),(34,0,1,NULL,NULL,73),(35,0,1,NULL,NULL,74),(36,0,1,NULL,NULL,75),(37,0,1,NULL,NULL,76),(38,0,1,NULL,NULL,77),(39,0,1,NULL,NULL,78),(40,0,1,NULL,NULL,79),(41,2,1,NULL,NULL,80),(42,0,1,NULL,NULL,81),(43,0,1,NULL,NULL,82),(44,0,1,NULL,NULL,83),(45,0,1,NULL,NULL,84),(46,0,1,NULL,NULL,85),(47,0,1,NULL,NULL,86),(48,0,1,NULL,NULL,87),(49,0,1,NULL,NULL,88),(50,2,1,NULL,NULL,89),(51,0,1,NULL,NULL,90),(52,0,1,NULL,NULL,91),(53,0,1,NULL,NULL,92),(54,0,1,NULL,NULL,93),(55,0,1,NULL,NULL,94),(56,0,1,NULL,NULL,95),(57,0,1,NULL,NULL,96),(58,0,1,NULL,NULL,97),(59,0,1,NULL,NULL,98),(60,0,1,NULL,NULL,99),(61,2,1,NULL,NULL,100),(62,1,1,NULL,NULL,101),(63,2,1,NULL,NULL,102),(64,1,1,NULL,NULL,103),(65,1,1,NULL,NULL,104),(66,2,1,NULL,NULL,105),(67,2,1,NULL,NULL,106),(68,2,1,NULL,NULL,107),(69,1,1,NULL,NULL,108),(70,2,1,NULL,NULL,109),(71,0,1,NULL,NULL,110),(72,0,1,NULL,NULL,111),(73,0,1,NULL,NULL,112),(74,0,1,NULL,NULL,113),(75,0,1,NULL,NULL,114),(76,0,1,NULL,NULL,115),(77,2,1,NULL,NULL,116),(78,0,1,NULL,NULL,117),(79,0,1,NULL,NULL,118),(80,0,1,NULL,NULL,119),(81,1,1,NULL,NULL,120),(82,1,1,NULL,NULL,121),(83,2,1,NULL,NULL,122),(84,1,1,NULL,NULL,123),(85,1,1,NULL,NULL,124),(86,2,1,NULL,NULL,125),(87,1,1,NULL,NULL,126),(88,2,1,NULL,NULL,127),(89,2,1,NULL,NULL,128),(90,1,1,NULL,NULL,129),(91,1,1,NULL,NULL,130),(92,1,1,NULL,NULL,131),(93,2,1,NULL,NULL,132),(94,0,1,NULL,NULL,133),(95,0,1,NULL,NULL,134),(96,0,1,NULL,NULL,135),(97,0,1,NULL,NULL,136),(98,0,1,NULL,NULL,137),(99,0,1,NULL,NULL,138),(100,0,1,NULL,NULL,139),(101,0,1,NULL,NULL,140),(102,0,1,NULL,NULL,141),(103,0,1,NULL,NULL,142),(104,0,1,NULL,NULL,143),(105,0,1,NULL,NULL,144),(106,0,1,NULL,NULL,145),(107,0,1,NULL,NULL,146),(108,0,1,NULL,NULL,147),(109,0,2,NULL,NULL,40),(110,0,2,NULL,NULL,41),(111,0,2,NULL,NULL,42),(112,0,2,NULL,NULL,43),(113,0,2,NULL,NULL,44),(114,0,2,NULL,NULL,45),(115,0,2,NULL,NULL,46),(116,0,2,NULL,NULL,47),(117,0,2,NULL,NULL,48),(118,0,2,NULL,NULL,49),(119,0,2,NULL,NULL,50),(120,0,2,NULL,NULL,51),(121,0,2,NULL,NULL,52),(122,0,2,NULL,NULL,53),(123,0,2,NULL,NULL,54),(124,0,2,NULL,NULL,55),(125,0,2,NULL,NULL,56),(126,0,2,NULL,NULL,57),(127,0,2,NULL,NULL,58),(128,0,2,NULL,NULL,59),(129,0,2,NULL,NULL,60),(130,0,2,NULL,NULL,61),(131,0,2,NULL,NULL,62),(132,0,2,NULL,NULL,63),(133,0,2,NULL,NULL,64),(134,0,2,NULL,NULL,65),(135,0,2,NULL,NULL,66),(136,0,2,NULL,NULL,67),(137,0,2,NULL,NULL,68),(138,0,2,NULL,NULL,69),(139,0,2,NULL,NULL,70),(140,0,2,NULL,NULL,71),(141,0,2,NULL,NULL,72),(142,0,2,NULL,NULL,73),(143,0,2,NULL,NULL,74),(144,0,2,NULL,NULL,75),(145,0,2,NULL,NULL,76),(146,0,2,NULL,NULL,77),(147,0,2,NULL,NULL,78),(148,0,2,NULL,NULL,79),(149,0,2,NULL,NULL,80),(150,0,2,NULL,NULL,81),(151,0,2,NULL,NULL,82),(152,0,2,NULL,NULL,83),(153,0,2,NULL,NULL,84),(154,0,2,NULL,NULL,85),(155,0,2,NULL,NULL,86),(156,0,2,NULL,NULL,87),(157,0,2,NULL,NULL,88),(158,0,2,NULL,NULL,89),(159,0,2,NULL,NULL,90),(160,0,2,NULL,NULL,91),(161,0,2,NULL,NULL,92),(162,0,2,NULL,NULL,93),(163,0,2,NULL,NULL,94),(164,0,2,NULL,NULL,95),(165,0,2,NULL,NULL,96),(166,0,2,NULL,NULL,97),(167,0,2,NULL,NULL,98),(168,0,2,NULL,NULL,99),(169,0,2,NULL,NULL,100),(170,0,2,NULL,NULL,101),(171,0,2,NULL,NULL,102),(172,0,2,NULL,NULL,103),(173,0,2,NULL,NULL,104),(174,0,2,NULL,NULL,105),(175,0,2,NULL,NULL,106),(176,0,2,NULL,NULL,107),(177,0,2,NULL,NULL,108),(178,0,2,NULL,NULL,109),(179,0,2,NULL,NULL,110),(180,0,2,NULL,NULL,111),(181,0,2,NULL,NULL,112),(182,0,2,NULL,NULL,113),(183,0,2,NULL,NULL,114),(184,0,2,NULL,NULL,115),(185,0,2,NULL,NULL,116),(186,0,2,NULL,NULL,117),(187,0,2,NULL,NULL,118),(188,0,2,NULL,NULL,119),(189,0,2,NULL,NULL,120),(190,0,2,NULL,NULL,121),(191,0,2,NULL,NULL,122),(192,0,2,NULL,NULL,123),(193,0,2,NULL,NULL,124),(194,0,2,NULL,NULL,125),(195,0,2,NULL,NULL,126),(196,0,2,NULL,NULL,127),(197,0,2,NULL,NULL,128),(198,0,2,NULL,NULL,129),(199,0,2,NULL,NULL,130),(200,0,2,NULL,NULL,131),(201,0,2,NULL,NULL,132),(202,0,2,NULL,NULL,133),(203,0,2,NULL,NULL,134),(204,0,2,NULL,NULL,135),(205,0,2,NULL,NULL,136),(206,0,2,NULL,NULL,137),(207,0,2,NULL,NULL,138),(208,0,2,NULL,NULL,139),(209,0,2,NULL,NULL,140),(210,0,2,NULL,NULL,141),(211,0,2,NULL,NULL,142),(212,0,2,NULL,NULL,143),(213,0,2,NULL,NULL,144),(214,0,2,NULL,NULL,145),(215,0,2,NULL,NULL,146),(216,0,2,NULL,NULL,147);
/*!40000 ALTER TABLE `Respuestas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Roles`
--

DROP TABLE IF EXISTS `Roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Roles` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Role` longtext NOT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Roles`
--

LOCK TABLES `Roles` WRITE;
/*!40000 ALTER TABLE `Roles` DISABLE KEYS */;
INSERT INTO `Roles` VALUES (1,'Usuario'),(2,'Administrador');
/*!40000 ALTER TABLE `Roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Sections`
--

DROP TABLE IF EXISTS `Sections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Sections` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(120) NOT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Sections`
--

LOCK TABLES `Sections` WRITE;
/*!40000 ALTER TABLE `Sections` DISABLE KEYS */;
INSERT INTO `Sections` VALUES (1,'CEREMONIAS'),(2,'ROLES'),(3,'ARTEFACTOS');
/*!40000 ALTER TABLE `Sections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `User_Roles`
--

DROP TABLE IF EXISTS `User_Roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `User_Roles` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `RoleId` int(11) NOT NULL,
  `UserNombre` varchar(127) NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `IX_User_Roles_RoleId` (`RoleId`),
  KEY `IX_User_Roles_UserNombre` (`UserNombre`),
  CONSTRAINT `FK_User_Roles_Roles_RoleId` FOREIGN KEY (`RoleId`) REFERENCES `Roles` (`Id`) ON DELETE CASCADE,
  CONSTRAINT `FK_User_Roles_Users_UserNombre` FOREIGN KEY (`UserNombre`) REFERENCES `Users` (`Nombre`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `User_Roles`
--

LOCK TABLES `User_Roles` WRITE;
/*!40000 ALTER TABLE `User_Roles` DISABLE KEYS */;
INSERT INTO `User_Roles` VALUES (1,1,'User'),(2,1,'Admin'),(3,1,'Admin');
/*!40000 ALTER TABLE `User_Roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Users`
--

DROP TABLE IF EXISTS `Users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Users` (
  `Nombre` varchar(127) NOT NULL,
  `Password` longtext NOT NULL,
  PRIMARY KEY (`Nombre`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Users`
--

LOCK TABLES `Users` WRITE;
/*!40000 ALTER TABLE `Users` DISABLE KEYS */;
INSERT INTO `Users` VALUES ('Admin','c1c224b03cd9bc7b6a86d77f5dace40191766c485cd55dc48caf9ac873335d6f'),('Test','532eaabd9574880dbf76b9b8cc00832c20a6ec113d682299550d7a6e0f345e25'),('User','b512d97e7cbf97c273e4db073bbb547aa65a84589227f8f3d9e4a72b9372a24d');
/*!40000 ALTER TABLE `Users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'agilemeter'
--

--
-- Dumping routines for database 'agilemeter'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-10-22 14:20:20
