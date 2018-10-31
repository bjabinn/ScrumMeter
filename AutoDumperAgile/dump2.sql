CREATE DATABASE  IF NOT EXISTS `agilemeter` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `agilemeter`;
-- MySQL dump 10.13  Distrib 5.7.17, for Win64 (x86_64)
--
-- Host: localhost    Database: agilemeter
-- ------------------------------------------------------
-- Server version	5.7.24

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
-- Table structure for table `asignaciones`
--

DROP TABLE IF EXISTS `asignaciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `asignaciones` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(50) NOT NULL,
  `Peso` int(11) DEFAULT '0',
  `SectionId` int(11) NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `IX_Asignaciones_SectionId` (`SectionId`),
  CONSTRAINT `FK_Asignaciones_Sections_SectionId` FOREIGN KEY (`SectionId`) REFERENCES `sections` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `asignaciones`
--

LOCK TABLES `asignaciones` WRITE;
/*!40000 ALTER TABLE `asignaciones` DISABLE KEYS */;
INSERT INTO `asignaciones` VALUES (1,'Daily',5,1),(2,'Retrospective',30,1),(3,'Sprint Review',20,1),(4,'Sprint Planning',15,1),(5,'Refinement',10,1),(6,'Product Owner',20,2),(7,'Scrum Master',60,2),(8,'Equipo Desarrollo',20,2),(9,'Product Backlog',30,3),(10,'Sprint Backlog',20,3),(11,'Incremento',15,3),(12,'Iteracion',5,3),(13,'Metricas',10,3);
/*!40000 ALTER TABLE `asignaciones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `assessment`
--

DROP TABLE IF EXISTS `assessment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `assessment` (
  `AssessmentId` int(11) NOT NULL,
  `AssessmentName` longtext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assessment`
--

LOCK TABLES `assessment` WRITE;
/*!40000 ALTER TABLE `assessment` DISABLE KEYS */;
INSERT INTO `assessment` VALUES (1,'SCRUM'),(2,'KANBAN');
/*!40000 ALTER TABLE `assessment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `evaluaciones`
--

DROP TABLE IF EXISTS `evaluaciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `evaluaciones` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Estado` bit(1) NOT NULL,
  `Fecha` datetime NOT NULL,
  `NotasEvaluacion` varchar(4000) DEFAULT NULL,
  `NotasObjetivos` varchar(4000) DEFAULT NULL,
  `ProyectoId` int(11) NOT NULL,
  `Puntuacion` double DEFAULT '0',
  PRIMARY KEY (`Id`),
  KEY `IX_Evaluaciones_ProyectoId` (`ProyectoId`),
  CONSTRAINT `FK_Evaluaciones_Proyectos_ProyectoId` FOREIGN KEY (`ProyectoId`) REFERENCES `proyectos` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `evaluaciones`
--

LOCK TABLES `evaluaciones` WRITE;
/*!40000 ALTER TABLE `evaluaciones` DISABLE KEYS */;
INSERT INTO `evaluaciones` VALUES (1,'\0','2018-10-23 12:06:07',NULL,NULL,2,0),(2,'','2018-10-24 14:49:36',NULL,NULL,1,59.5),(3,'','2018-10-24 14:53:29',NULL,NULL,1,2.8),(4,'\0','2018-10-26 10:19:41',NULL,NULL,5,0);
/*!40000 ALTER TABLE `evaluaciones` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `agilemeter`.`evaluaciones_AFTER_INSERT` AFTER INSERT ON `evaluaciones` FOR EACH ROW
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE PreId INT DEFAULT NEW.Id;
    DECLARE ids INT;
    DECLARE cur CURSOR FOR SELECT id FROM preguntas;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;
        ins_loop: LOOP
            FETCH cur INTO ids;
            IF done THEN
                LEAVE ins_loop;
            END IF;
            INSERT INTO respuestas (Estado, PreguntaId, EvaluacionId) VALUES (0 , ids , PreId);
        END LOOP;
    CLOSE cur;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `notasasignaciones`
--

DROP TABLE IF EXISTS `notasasignaciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notasasignaciones` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `AsignacionId` int(11) NOT NULL,
  `EvaluacionId` int(11) NOT NULL,
  `Notas` varchar(4000) DEFAULT NULL,
  PRIMARY KEY (`Id`),
  KEY `IX_NotasAsignaciones_AsignacionId` (`AsignacionId`),
  KEY `IX_NotasAsignaciones_EvaluacionId` (`EvaluacionId`),
  CONSTRAINT `FK_NotasAsignaciones_Asignaciones_AsignacionId` FOREIGN KEY (`AsignacionId`) REFERENCES `asignaciones` (`Id`) ON DELETE CASCADE,
  CONSTRAINT `FK_NotasAsignaciones_Evaluaciones_EvaluacionId` FOREIGN KEY (`EvaluacionId`) REFERENCES `evaluaciones` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notasasignaciones`
--

LOCK TABLES `notasasignaciones` WRITE;
/*!40000 ALTER TABLE `notasasignaciones` DISABLE KEYS */;
/*!40000 ALTER TABLE `notasasignaciones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notassections`
--

DROP TABLE IF EXISTS `notassections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notassections` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `EvaluacionId` int(11) NOT NULL,
  `Notas` varchar(4000) DEFAULT NULL,
  `SectionId` int(11) NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `IX_NotasSections_EvaluacionId` (`EvaluacionId`),
  KEY `IX_NotasSections_SectionId` (`SectionId`),
  CONSTRAINT `FK_NotasSections_Evaluaciones_EvaluacionId` FOREIGN KEY (`EvaluacionId`) REFERENCES `evaluaciones` (`Id`) ON DELETE CASCADE,
  CONSTRAINT `FK_NotasSections_Sections_SectionId` FOREIGN KEY (`SectionId`) REFERENCES `sections` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notassections`
--

LOCK TABLES `notassections` WRITE;
/*!40000 ALTER TABLE `notassections` DISABLE KEYS */;
/*!40000 ALTER TABLE `notassections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `preguntas`
--

DROP TABLE IF EXISTS `preguntas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `preguntas` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `AsignacionId` int(11) NOT NULL,
  `Correcta` longtext,
  `Pregunta` varchar(120) NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `IX_Preguntas_AsignacionId` (`AsignacionId`),
  CONSTRAINT `FK_Preguntas_Asignaciones_AsignacionId` FOREIGN KEY (`AsignacionId`) REFERENCES `asignaciones` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `preguntas`
--

LOCK TABLES `preguntas` WRITE;
/*!40000 ALTER TABLE `preguntas` DISABLE KEYS */;
INSERT INTO `preguntas` VALUES (1,1,NULL,'¿Se realiza la daily?'),(2,1,'Si','¿El equipo completo participa?'),(3,1,'Si','¿Se emplean como máximo 15 min?'),(4,1,'Si','¿Se mencionan los problemas e impedimentos?'),(5,1,'Si','¿Se revisan en cada daily los objetivos del Sprint?'),(6,1,'Si','¿Se realiza siempre a la misma hora y lugar?'),(7,1,'No','¿Participa gente que no pertenece al equipo?'),(8,2,NULL,'¿Se realiza la Retrospective al final de cada sprint?'),(9,2,'Si','¿Se plantean propuestas SMART?'),(10,2,'Si','¿Se implementan las propuestas?'),(11,2,'Si','¿Equipo al completo más PO participan?'),(12,2,'Si','¿Se analizan los problemas en profundidad?'),(13,2,'No','¿Participa gente que no pertenece al equipo?'),(14,2,'Si','¿Todo el equipo expresa su punto de vista?'),(15,2,'Si','¿Se analizan las métricas y su impacto durante la retro?'),(16,3,NULL,'¿Se realiza la Sprint Review al final de cada sprint?'),(17,3,'Si','¿Se muestra software funcionando y probado?'),(18,3,'Si','¿Se recibe feedback de interesados y PO?'),(19,3,'No','¿Se mencionan los items inacabados?'),(20,3,'Si','¿Se revisa si se ha alcanzado el objetivo del Sprint?'),(21,3,'No','¿Se muestran los items acabados al 99%?'),(22,4,NULL,'¿Se realiza Sprint Planning por cada Sprint?'),(23,4,'Si','¿El PO está disponible para dudas?'),(24,4,'Si','¿Está el PB preparado para el Sprint Planning?'),(25,4,'Si','¿El equipo completo participa?'),(26,4,'Si','¿El resultado de la sesión es el plan del Sprint?'),(27,4,'Si','¿El equipo completo cree que el plan es alcanzable?'),(28,4,'Si','¿El PO queda satisfecho con las prioridades?'),(29,4,'Si','¿Los PBI se dividen en tareas?'),(30,4,'Si','¿Las tareas son estimadas?'),(31,4,'Si','¿Se adquiere un compromiso por parte del equipo?'),(32,5,NULL,'¿Se realiza Refinement?'),(33,5,'Si','¿Es el PO quien decide cuando se hace un refinement?'),(34,5,'Si','¿El PO lleva las US definidas para discutir?'),(35,5,'Si','¿Se estima en tamaño relativo?'),(36,5,'Si','¿Existe DoR?'),(37,5,'Si','¿Se aplica DoR?'),(38,5,'Si','¿Se realizan preguntas y propuestas?'),(39,5,'Si','¿Participa todo el equipo?'),(40,5,'No','¿Participa en la estimación personas ajenas al equipo?'),(41,6,NULL,'¿Existe el rol de PO en el equipo?'),(42,6,'Si','¿El PO tiene poder para priorizar los elementos del PB?'),(43,6,'Si','¿El PO tiene el conocimiento suficiente para priorizar?'),(44,6,'Si','¿El PO tiene contacto directo con el equipo?'),(45,6,'Si','¿El PO tiene contacto directo con los interesados?'),(46,6,'Si','¿El PO tiene voz única (Si es equipo, solo hay una opinión)?'),(47,6,'Si','¿El PO tiene la visión del producto?'),(48,6,'No','¿El PO hace otras labores (codificar por ejemplo)?'),(49,6,'No','¿El PO toma decisiones técnicas?'),(50,7,NULL,'¿Existe el rol de SM en el equipo?'),(51,7,'Si','¿El SM se sienta con el equipo?'),(52,7,'Si','¿El SM se enfoca en la resolución de impedimentos?'),(53,7,'Si','¿El SM escala los impedimentos?'),(54,7,'No','¿El SM hace otras labores (codificar/analizar por ejemplo)?'),(55,7,'No','¿El SM toma decisiones técnicas o de negocio?'),(56,7,'Si','¿El SM ayuda/guía al PO para realizar correctamente su trabajo?'),(57,7,'Si','¿El SM empodera al equipo?'),(58,7,'No','¿El SM asume la responsabilidad si el equipo falla?'),(59,7,'Si','¿El SM permite que el equipo experimente y se equivoque?'),(60,7,'Si','¿Los líderes o managers de la organización conocen y/o comparten los principios ágiles?'),(61,8,'Si','¿El equipo tiene todas las habilidades necesarias?'),(62,8,'Si','¿Existen miembros del equipo encasillados, no conociendo absolutamente nada de otras áreas?'),(63,8,'Si','¿Los miembros del equipo se sientan juntos?'),(64,8,'Si','¿Hay com máximo 9 personas por equipo?'),(65,8,'No','¿Hay algún miembro del equipo que odie Scrum?'),(66,8,'No','¿Hay algún miembro del equipo profundamente desmotivado?'),(67,8,'Si','¿Tiene el equipo un drag factor interiorizado, planificado y consensuado con los stakeholders?'),(68,8,'No','¿Se realizan reuniones adicionales que estén fuera del framework de Scrum?'),(69,8,'Si','¿El equipo usa o dispone de herramientas para organizar sus tareas?'),(70,9,NULL,'¿Existe PB?'),(71,9,'Si','¿EL PB es visible y refleja la visión del producto?'),(72,9,'Si','¿Los PBI se priorizan por su valor de negocio?'),(73,9,'Si','¿Los PBI se estiman?'),(74,9,'Si','¿El equipo completo es quien realiza las estimaciones?'),(75,9,'Si','¿Los PBI son tan pequeños como para abordarse en un Sprint?'),(76,9,'Si','¿El PO entiende el propósito de todos los PBI?'),(77,10,NULL,'¿Existe SB?'),(78,10,'Si','¿El SB es visible y refleja el compromiso para el Sprint?'),(79,10,'Si','¿El SB se actualiza diariamente?'),(80,10,'Si','¿El SB es propiedad exclusiva del equipo?'),(81,11,NULL,'¿Existe DoD?'),(82,11,'Si','¿El DoD es alcanzable dentro de cada iteración?'),(83,11,'Si','¿El equipo respeta el DoD?'),(84,11,'Si','¿El Software entregado tiene calidad para subirse a producción si el negocio así lo pidiera?'),(85,11,'Si','¿Se actualiza el DoD?'),(86,11,'Si','¿Tanto PO como equipo están de acuerdo con el DoD?'),(87,12,NULL,'¿Existe iteraciones de tiempo fijo?'),(88,12,'Si','¿La longitud de las iteraciones está entre 2-4 semanas?'),(89,12,'Si','¿Siempre terminan a tiempo?'),(90,12,'No','¿El equipo es interrumpido durante una iteración?'),(91,12,'Si','¿El equipo normalmente entrega lo que comprometió?'),(92,12,'Si','¿Se ha cancelado alguna iteración que ha sido un fracaso?'),(93,13,NULL,'¿Se mide la velodidad del equipo?'),(94,13,'Si','¿Todos los PBI se estiman y se computan en la velocidad?'),(95,13,'Si','¿El PO usa la velocidad para planificar a futuro?'),(96,13,'Si','¿La velocidad sólo incluye PBI terminados?'),(97,13,'Si','¿El equipo tiene un Burndown por Sprint?'),(98,13,'Si','¿El Burndown es visible por todos los miembros del equipo?'),(99,13,'Si','¿El Burndown se actualiza diariamente?'),(100,13,'Si','¿El equipo conoce y entiende sus métricas?');
/*!40000 ALTER TABLE `preguntas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `proyectos`
--

DROP TABLE IF EXISTS `proyectos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `proyectos` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Fecha` datetime NOT NULL,
  `Nombre` varchar(50) NOT NULL,
  `UserNombre` varchar(127) DEFAULT NULL,
  PRIMARY KEY (`Id`),
  KEY `IX_Proyectos_UserNombre` (`UserNombre`),
  CONSTRAINT `FK_Proyectos_Users_UserNombre` FOREIGN KEY (`UserNombre`) REFERENCES `users` (`Nombre`) ON DELETE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `proyectos`
--

LOCK TABLES `proyectos` WRITE;
/*!40000 ALTER TABLE `proyectos` DISABLE KEYS */;
INSERT INTO `proyectos` VALUES (1,'2018-07-10 00:00:00','BCA','Admin'),(2,'2018-07-10 00:00:00','TESCO','Admin'),(3,'2018-07-10 00:00:00','BestDay','User'),(4,'2018-07-10 00:00:00','TVE','User'),(5,'2018-07-10 00:00:00','Proyecto Test','Test');
/*!40000 ALTER TABLE `proyectos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `respuestas`
--

DROP TABLE IF EXISTS `respuestas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `respuestas` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Estado` int(11) DEFAULT '0',
  `EvaluacionId` int(11) NOT NULL,
  `Notas` varchar(4000) DEFAULT NULL,
  `NotasAdmin` varchar(4000) DEFAULT NULL,
  `PreguntaId` int(11) NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `IX_Respuestas_EvaluacionId` (`EvaluacionId`),
  KEY `IX_Respuestas_PreguntaId` (`PreguntaId`),
  CONSTRAINT `FK_Respuestas_Evaluaciones_EvaluacionId` FOREIGN KEY (`EvaluacionId`) REFERENCES `evaluaciones` (`Id`) ON DELETE CASCADE,
  CONSTRAINT `FK_Respuestas_Preguntas_PreguntaId` FOREIGN KEY (`PreguntaId`) REFERENCES `preguntas` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=401 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `respuestas`
--

LOCK TABLES `respuestas` WRITE;
/*!40000 ALTER TABLE `respuestas` DISABLE KEYS */;
INSERT INTO `respuestas` VALUES (1,2,1,NULL,NULL,1),(2,0,1,NULL,NULL,2),(3,0,1,NULL,NULL,3),(4,0,1,NULL,NULL,4),(5,0,1,NULL,NULL,5),(6,0,1,NULL,NULL,6),(7,0,1,NULL,NULL,7),(8,0,1,NULL,NULL,8),(9,0,1,NULL,NULL,9),(10,0,1,NULL,NULL,10),(11,0,1,NULL,NULL,11),(12,0,1,NULL,NULL,12),(13,0,1,NULL,NULL,13),(14,0,1,NULL,NULL,14),(15,0,1,NULL,NULL,15),(16,0,1,NULL,NULL,16),(17,0,1,NULL,NULL,17),(18,0,1,NULL,NULL,18),(19,0,1,NULL,NULL,19),(20,0,1,NULL,NULL,20),(21,0,1,NULL,NULL,21),(22,0,1,NULL,NULL,22),(23,0,1,NULL,NULL,23),(24,0,1,NULL,NULL,24),(25,0,1,NULL,NULL,25),(26,0,1,NULL,NULL,26),(27,0,1,NULL,NULL,27),(28,0,1,NULL,NULL,28),(29,0,1,NULL,NULL,29),(30,0,1,NULL,NULL,30),(31,0,1,NULL,NULL,31),(32,0,1,NULL,NULL,32),(33,0,1,NULL,NULL,33),(34,0,1,NULL,NULL,34),(35,0,1,NULL,NULL,35),(36,0,1,NULL,NULL,36),(37,0,1,NULL,NULL,37),(38,0,1,NULL,NULL,38),(39,0,1,NULL,NULL,39),(40,0,1,NULL,NULL,40),(41,0,1,NULL,NULL,41),(42,0,1,NULL,NULL,42),(43,0,1,NULL,NULL,43),(44,0,1,NULL,NULL,44),(45,0,1,NULL,NULL,45),(46,0,1,NULL,NULL,46),(47,0,1,NULL,NULL,47),(48,0,1,NULL,NULL,48),(49,0,1,NULL,NULL,49),(50,0,1,NULL,NULL,50),(51,0,1,NULL,NULL,51),(52,0,1,NULL,NULL,52),(53,0,1,NULL,NULL,53),(54,0,1,NULL,NULL,54),(55,0,1,NULL,NULL,55),(56,0,1,NULL,NULL,56),(57,0,1,NULL,NULL,57),(58,0,1,NULL,NULL,58),(59,0,1,NULL,NULL,59),(60,0,1,NULL,NULL,60),(61,0,1,NULL,NULL,61),(62,0,1,NULL,NULL,62),(63,0,1,NULL,NULL,63),(64,0,1,NULL,NULL,64),(65,0,1,NULL,NULL,65),(66,0,1,NULL,NULL,66),(67,0,1,NULL,NULL,67),(68,0,1,NULL,NULL,68),(69,0,1,NULL,NULL,69),(70,0,1,NULL,NULL,70),(71,0,1,NULL,NULL,71),(72,0,1,NULL,NULL,72),(73,0,1,NULL,NULL,73),(74,0,1,NULL,NULL,74),(75,0,1,NULL,NULL,75),(76,0,1,NULL,NULL,76),(77,0,1,NULL,NULL,77),(78,0,1,NULL,NULL,78),(79,0,1,NULL,NULL,79),(80,0,1,NULL,NULL,80),(81,0,1,NULL,NULL,81),(82,0,1,NULL,NULL,82),(83,0,1,NULL,NULL,83),(84,0,1,NULL,NULL,84),(85,0,1,NULL,NULL,85),(86,0,1,NULL,NULL,86),(87,0,1,NULL,NULL,87),(88,0,1,NULL,NULL,88),(89,0,1,NULL,NULL,89),(90,0,1,NULL,NULL,90),(91,0,1,NULL,NULL,91),(92,0,1,NULL,NULL,92),(93,0,1,NULL,NULL,93),(94,0,1,NULL,NULL,94),(95,0,1,NULL,NULL,95),(96,0,1,NULL,NULL,96),(97,0,1,NULL,NULL,97),(98,0,1,NULL,NULL,98),(99,0,1,NULL,NULL,99),(100,0,1,NULL,NULL,100),(101,1,2,NULL,NULL,1),(102,1,2,NULL,NULL,2),(103,1,2,NULL,NULL,3),(104,1,2,NULL,NULL,4),(105,1,2,NULL,NULL,5),(106,2,2,NULL,NULL,6),(107,2,2,NULL,NULL,7),(108,1,2,NULL,NULL,8),(109,1,2,NULL,NULL,9),(110,2,2,NULL,NULL,10),(111,2,2,NULL,NULL,11),(112,1,2,NULL,NULL,12),(113,1,2,NULL,NULL,13),(114,1,2,NULL,NULL,14),(115,2,2,NULL,NULL,15),(116,1,2,NULL,NULL,16),(117,1,2,NULL,NULL,17),(118,1,2,NULL,NULL,18),(119,2,2,NULL,NULL,19),(120,1,2,NULL,NULL,20),(121,1,2,NULL,NULL,21),(122,1,2,NULL,NULL,22),(123,1,2,NULL,NULL,23),(124,2,2,NULL,NULL,24),(125,1,2,NULL,NULL,25),(126,1,2,NULL,NULL,26),(127,1,2,NULL,NULL,27),(128,2,2,NULL,NULL,28),(129,1,2,NULL,NULL,29),(130,1,2,NULL,NULL,30),(131,2,2,NULL,NULL,31),(132,1,2,NULL,NULL,32),(133,1,2,NULL,NULL,33),(134,1,2,NULL,NULL,34),(135,2,2,NULL,NULL,35),(136,1,2,NULL,NULL,36),(137,2,2,NULL,NULL,37),(138,1,2,NULL,NULL,38),(139,1,2,NULL,NULL,39),(140,1,2,NULL,NULL,40),(141,1,2,NULL,NULL,41),(142,1,2,NULL,NULL,42),(143,1,2,NULL,NULL,43),(144,1,2,NULL,NULL,44),(145,1,2,NULL,NULL,45),(146,2,2,NULL,NULL,46),(147,1,2,NULL,NULL,47),(148,2,2,NULL,NULL,48),(149,1,2,NULL,NULL,49),(150,1,2,NULL,NULL,50),(151,1,2,NULL,NULL,51),(152,1,2,NULL,NULL,52),(153,2,2,NULL,NULL,53),(154,1,2,NULL,NULL,54),(155,1,2,NULL,NULL,55),(156,1,2,NULL,NULL,56),(157,1,2,NULL,NULL,57),(158,1,2,NULL,NULL,58),(159,2,2,NULL,NULL,59),(160,1,2,NULL,NULL,60),(161,1,2,NULL,NULL,61),(162,1,2,NULL,NULL,62),(163,2,2,NULL,NULL,63),(164,2,2,NULL,NULL,64),(165,1,2,NULL,NULL,65),(166,1,2,NULL,NULL,66),(167,2,2,NULL,NULL,67),(168,1,2,NULL,NULL,68),(169,1,2,NULL,NULL,69),(170,1,2,NULL,NULL,70),(171,1,2,NULL,NULL,71),(172,2,2,NULL,NULL,72),(173,1,2,NULL,NULL,73),(174,1,2,NULL,NULL,74),(175,1,2,NULL,NULL,75),(176,1,2,NULL,NULL,76),(177,1,2,NULL,NULL,77),(178,1,2,NULL,NULL,78),(179,1,2,NULL,NULL,79),(180,2,2,NULL,NULL,80),(181,1,2,NULL,NULL,81),(182,1,2,NULL,NULL,82),(183,1,2,NULL,NULL,83),(184,1,2,NULL,NULL,84),(185,2,2,NULL,NULL,85),(186,1,2,NULL,NULL,86),(187,1,2,NULL,NULL,87),(188,1,2,NULL,NULL,88),(189,2,2,NULL,NULL,89),(190,2,2,NULL,NULL,90),(191,1,2,NULL,NULL,91),(192,1,2,NULL,NULL,92),(193,1,2,NULL,NULL,93),(194,1,2,NULL,NULL,94),(195,1,2,NULL,NULL,95),(196,2,2,NULL,NULL,96),(197,2,2,NULL,NULL,97),(198,1,2,NULL,NULL,98),(199,1,2,NULL,NULL,99),(200,1,2,NULL,NULL,100),(201,1,3,NULL,NULL,1),(202,0,3,NULL,NULL,2),(203,1,3,NULL,NULL,3),(204,1,3,NULL,NULL,4),(205,0,3,NULL,NULL,5),(206,0,3,NULL,NULL,6),(207,1,3,NULL,NULL,7),(208,1,3,NULL,NULL,8),(209,0,3,NULL,NULL,9),(210,1,3,NULL,NULL,10),(211,0,3,NULL,NULL,11),(212,0,3,NULL,NULL,12),(213,1,3,NULL,NULL,13),(214,0,3,NULL,NULL,14),(215,1,3,NULL,NULL,15),(216,1,3,NULL,NULL,16),(217,0,3,NULL,NULL,17),(218,0,3,NULL,NULL,18),(219,0,3,NULL,NULL,19),(220,0,3,NULL,NULL,20),(221,1,3,NULL,NULL,21),(222,0,3,NULL,NULL,22),(223,0,3,NULL,NULL,23),(224,0,3,NULL,NULL,24),(225,0,3,NULL,NULL,25),(226,0,3,NULL,NULL,26),(227,0,3,NULL,NULL,27),(228,0,3,NULL,NULL,28),(229,0,3,NULL,NULL,29),(230,0,3,NULL,NULL,30),(231,0,3,NULL,NULL,31),(232,0,3,NULL,NULL,32),(233,0,3,NULL,NULL,33),(234,0,3,NULL,NULL,34),(235,0,3,NULL,NULL,35),(236,0,3,NULL,NULL,36),(237,0,3,NULL,NULL,37),(238,0,3,NULL,NULL,38),(239,0,3,NULL,NULL,39),(240,0,3,NULL,NULL,40),(241,0,3,NULL,NULL,41),(242,0,3,NULL,NULL,42),(243,0,3,NULL,NULL,43),(244,0,3,NULL,NULL,44),(245,0,3,NULL,NULL,45),(246,0,3,NULL,NULL,46),(247,0,3,NULL,NULL,47),(248,0,3,NULL,NULL,48),(249,0,3,NULL,NULL,49),(250,0,3,NULL,NULL,50),(251,0,3,NULL,NULL,51),(252,0,3,NULL,NULL,52),(253,0,3,NULL,NULL,53),(254,0,3,NULL,NULL,54),(255,0,3,NULL,NULL,55),(256,0,3,NULL,NULL,56),(257,0,3,NULL,NULL,57),(258,0,3,NULL,NULL,58),(259,0,3,NULL,NULL,59),(260,0,3,NULL,NULL,60),(261,0,3,NULL,NULL,61),(262,0,3,NULL,NULL,62),(263,0,3,NULL,NULL,63),(264,0,3,NULL,NULL,64),(265,0,3,NULL,NULL,65),(266,0,3,NULL,NULL,66),(267,0,3,NULL,NULL,67),(268,0,3,NULL,NULL,68),(269,0,3,NULL,NULL,69),(270,0,3,NULL,NULL,70),(271,0,3,NULL,NULL,71),(272,0,3,NULL,NULL,72),(273,0,3,NULL,NULL,73),(274,0,3,NULL,NULL,74),(275,0,3,NULL,NULL,75),(276,0,3,NULL,NULL,76),(277,0,3,NULL,NULL,77),(278,0,3,NULL,NULL,78),(279,0,3,NULL,NULL,79),(280,0,3,NULL,NULL,80),(281,0,3,NULL,NULL,81),(282,0,3,NULL,NULL,82),(283,0,3,NULL,NULL,83),(284,0,3,NULL,NULL,84),(285,0,3,NULL,NULL,85),(286,0,3,NULL,NULL,86),(287,0,3,NULL,NULL,87),(288,0,3,NULL,NULL,88),(289,0,3,NULL,NULL,89),(290,0,3,NULL,NULL,90),(291,0,3,NULL,NULL,91),(292,0,3,NULL,NULL,92),(293,0,3,NULL,NULL,93),(294,0,3,NULL,NULL,94),(295,0,3,NULL,NULL,95),(296,0,3,NULL,NULL,96),(297,0,3,NULL,NULL,97),(298,0,3,NULL,NULL,98),(299,0,3,NULL,NULL,99),(300,0,3,NULL,NULL,100),(301,0,4,NULL,NULL,1),(302,0,4,NULL,NULL,2),(303,0,4,NULL,NULL,3),(304,0,4,NULL,NULL,4),(305,0,4,NULL,NULL,5),(306,0,4,NULL,NULL,6),(307,0,4,NULL,NULL,7),(308,0,4,NULL,NULL,8),(309,0,4,NULL,NULL,9),(310,0,4,NULL,NULL,10),(311,0,4,NULL,NULL,11),(312,0,4,NULL,NULL,12),(313,0,4,NULL,NULL,13),(314,0,4,NULL,NULL,14),(315,0,4,NULL,NULL,15),(316,0,4,NULL,NULL,16),(317,0,4,NULL,NULL,17),(318,0,4,NULL,NULL,18),(319,0,4,NULL,NULL,19),(320,0,4,NULL,NULL,20),(321,0,4,NULL,NULL,21),(322,0,4,NULL,NULL,22),(323,0,4,NULL,NULL,23),(324,0,4,NULL,NULL,24),(325,0,4,NULL,NULL,25),(326,0,4,NULL,NULL,26),(327,0,4,NULL,NULL,27),(328,0,4,NULL,NULL,28),(329,0,4,NULL,NULL,29),(330,0,4,NULL,NULL,30),(331,0,4,NULL,NULL,31),(332,0,4,NULL,NULL,32),(333,0,4,NULL,NULL,33),(334,0,4,NULL,NULL,34),(335,0,4,NULL,NULL,35),(336,0,4,NULL,NULL,36),(337,0,4,NULL,NULL,37),(338,0,4,NULL,NULL,38),(339,0,4,NULL,NULL,39),(340,0,4,NULL,NULL,40),(341,0,4,NULL,NULL,41),(342,0,4,NULL,NULL,42),(343,0,4,NULL,NULL,43),(344,0,4,NULL,NULL,44),(345,0,4,NULL,NULL,45),(346,0,4,NULL,NULL,46),(347,0,4,NULL,NULL,47),(348,0,4,NULL,NULL,48),(349,0,4,NULL,NULL,49),(350,0,4,NULL,NULL,50),(351,0,4,NULL,NULL,51),(352,0,4,NULL,NULL,52),(353,0,4,NULL,NULL,53),(354,0,4,NULL,NULL,54),(355,0,4,NULL,NULL,55),(356,0,4,NULL,NULL,56),(357,0,4,NULL,NULL,57),(358,0,4,NULL,NULL,58),(359,0,4,NULL,NULL,59),(360,0,4,NULL,NULL,60),(361,0,4,NULL,NULL,61),(362,0,4,NULL,NULL,62),(363,0,4,NULL,NULL,63),(364,0,4,NULL,NULL,64),(365,0,4,NULL,NULL,65),(366,0,4,NULL,NULL,66),(367,0,4,NULL,NULL,67),(368,0,4,NULL,NULL,68),(369,0,4,NULL,NULL,69),(370,0,4,NULL,NULL,70),(371,0,4,NULL,NULL,71),(372,0,4,NULL,NULL,72),(373,0,4,NULL,NULL,73),(374,0,4,NULL,NULL,74),(375,0,4,NULL,NULL,75),(376,0,4,NULL,NULL,76),(377,0,4,NULL,NULL,77),(378,0,4,NULL,NULL,78),(379,0,4,NULL,NULL,79),(380,0,4,NULL,NULL,80),(381,0,4,NULL,NULL,81),(382,0,4,NULL,NULL,82),(383,0,4,NULL,NULL,83),(384,0,4,NULL,NULL,84),(385,0,4,NULL,NULL,85),(386,0,4,NULL,NULL,86),(387,0,4,NULL,NULL,87),(388,0,4,NULL,NULL,88),(389,0,4,NULL,NULL,89),(390,0,4,NULL,NULL,90),(391,0,4,NULL,NULL,91),(392,0,4,NULL,NULL,92),(393,0,4,NULL,NULL,93),(394,0,4,NULL,NULL,94),(395,0,4,NULL,NULL,95),(396,0,4,NULL,NULL,96),(397,0,4,NULL,NULL,97),(398,0,4,NULL,NULL,98),(399,0,4,NULL,NULL,99),(400,0,4,NULL,NULL,100);
/*!40000 ALTER TABLE `respuestas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `roles` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Role` longtext NOT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'Usuario'),(2,'Administrador');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sections`
--

DROP TABLE IF EXISTS `sections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sections` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(120) NOT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sections`
--

LOCK TABLES `sections` WRITE;
/*!40000 ALTER TABLE `sections` DISABLE KEYS */;
INSERT INTO `sections` VALUES (1,'CEREMONIAS'),(2,'ROLES'),(3,'ARTEFACTOS');
/*!40000 ALTER TABLE `sections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `userproyectos`
--

DROP TABLE IF EXISTS `userproyectos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `userproyectos` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `UserNombre` varchar(127) NOT NULL,
  `ProyectoId` int(11) NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `IX_UserProyecto_ProyectoId` (`ProyectoId`),
  KEY `IX_UserProyecto_UserNombre` (`UserNombre`),
  CONSTRAINT `FK_UserProyecto_Proyectos_ProyectoId` FOREIGN KEY (`ProyectoId`) REFERENCES `proyectos` (`Id`) ON DELETE CASCADE,
  CONSTRAINT `FK_UserProyecto_Users_UserNombre` FOREIGN KEY (`UserNombre`) REFERENCES `users` (`Nombre`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `userproyectos`
--

LOCK TABLES `userproyectos` WRITE;
/*!40000 ALTER TABLE `userproyectos` DISABLE KEYS */;
INSERT INTO `userproyectos` VALUES (1,'Admin',1),(2,'Admin',2),(3,'Admin',3),(4,'User',1),(5,'mgonzaez',5);
/*!40000 ALTER TABLE `userproyectos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `Nombre` varchar(127) NOT NULL,
  `Password` longtext NOT NULL,
  `RoleId` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`Nombre`),
  KEY `IX_Users_RoleId` (`RoleId`),
  CONSTRAINT `FK_Users_Roles_RoleId` FOREIGN KEY (`RoleId`) REFERENCES `roles` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES ('Admin','c1c224b03cd9bc7b6a86d77f5dace40191766c485cd55dc48caf9ac873335d6f',2),('mgonzaez','default-password',1),('Test','532eaabd9574880dbf76b9b8cc00832c20a6ec113d682299550d7a6e0f345e25',1),('User','b512d97e7cbf97c273e4db073bbb547aa65a84589227f8f3d9e4a72b9372a24d',1);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
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

-- Dump completed on 2018-10-26 10:55:33
