CREATE DATABASE  IF NOT EXISTS `agilemeter` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `agilemeter`;
-- MySQL dump 10.13  Distrib 5.7.17, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: agilemeter
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
-- Table structure for table `__efmigrationshistory`
--

DROP TABLE IF EXISTS `__efmigrationshistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `__efmigrationshistory` (
  `MigrationId` varchar(95) NOT NULL,
  `ProductVersion` varchar(32) NOT NULL,
  PRIMARY KEY (`MigrationId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `__efmigrationshistory`
--

LOCK TABLES `__efmigrationshistory` WRITE;
/*!40000 ALTER TABLE `__efmigrationshistory` DISABLE KEYS */;
INSERT INTO `__efmigrationshistory` VALUES ('20181023105227_AddUserProyecto','2.0.2-rtm-10011'),('20181025094247_RemoveUserRoles','2.0.2-rtm-10011'),('20181026062550_AddAssessments','2.0.2-rtm-10011'),('20181029085809_LinkAssessmentWithSections','2.0.2-rtm-10011'),('20181029103724_LinkEvaluationsWithAssessments','2.0.2-rtm-10011'),('20181113120302_AddUserNameToEvaluation','2.0.2-rtm-10011'),('20181203104813_TestProyects','2.0.2-rtm-10011'),('20181217133407_AñadirPesosASecciones','2.0.2-rtm-10011'),('20181218081534_PreguntaHabilitante','2.0.2-rtm-10011'),('20190108132133_AddLastQuestionUpdate','2.0.2-rtm-10011'),('20190109093506_PesoIntToFloat','2.0.2-rtm-10011'),('20190109135727_NivelPreguntas','2.0.2-rtm-10011');
/*!40000 ALTER TABLE `__efmigrationshistory` ENABLE KEYS */;
UNLOCK TABLES;

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
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `asignaciones`
--

LOCK TABLES `asignaciones` WRITE;
/*!40000 ALTER TABLE `asignaciones` DISABLE KEYS */;
INSERT INTO `asignaciones` VALUES (1,'Product Owner',20,1),(2,'Scrum Master',40,1),(3,'Equipo Desarrollo',40,1),(4,'Daily Scrum',20,2),(5,'Retrospective',30,2),(6,'Sprint Review',10,2),(7,'Sprint Planning',15,2),(8,'Refinement',5,2),(9,'Sprint',20,2),(10,'Product Backlog',40,3),(11,'Sprint Backlog',40,3),(12,'Incremento',20,3),(13,'Cultura',30,4),(14,'Disciplina',35,4),(15,'Mejora Continua',35,4),(16,'Métricas',35,5),(17,'Implementación',40,5),(18,'Objetivos',25,5);
/*!40000 ALTER TABLE `asignaciones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `assessment`
--

DROP TABLE IF EXISTS `assessment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `assessment` (
  `AssessmentId` int(11) NOT NULL AUTO_INCREMENT,
  `AssessmentName` varchar(50) NOT NULL,
  PRIMARY KEY (`AssessmentId`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assessment`
--

LOCK TABLES `assessment` WRITE;
/*!40000 ALTER TABLE `assessment` DISABLE KEYS */;
INSERT INTO `assessment` VALUES (1,'SCRUM');
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
  `AssessmentId` int(11) NOT NULL DEFAULT '1',
  `UserNombre` varchar(127) DEFAULT NULL,
  `LastQuestionUpdated` int(11) DEFAULT NULL,
  PRIMARY KEY (`Id`),
  KEY `IX_Evaluaciones_ProyectoId` (`ProyectoId`),
  KEY `IX_Evaluaciones_AssessmentId` (`AssessmentId`),
  KEY `IX_Evaluaciones_UserNombre` (`UserNombre`),
  CONSTRAINT `FK_Evaluaciones_Assessment_AssessmentId` FOREIGN KEY (`AssessmentId`) REFERENCES `assessment` (`AssessmentId`) ON DELETE CASCADE,
  CONSTRAINT `FK_Evaluaciones_Preguntas_Id` FOREIGN KEY (`Id`) REFERENCES `preguntas` (`Id`) ON DELETE CASCADE,
  CONSTRAINT `FK_Evaluaciones_Proyectos_ProyectoId` FOREIGN KEY (`ProyectoId`) REFERENCES `proyectos` (`Id`) ON DELETE CASCADE,
  CONSTRAINT `FK_Evaluaciones_Users_UserNombre` FOREIGN KEY (`UserNombre`) REFERENCES `users` (`Nombre`) ON DELETE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `evaluaciones`
--

LOCK TABLES `evaluaciones` WRITE;
/*!40000 ALTER TABLE `evaluaciones` DISABLE KEYS */;
INSERT INTO `evaluaciones` VALUES (1,'','2019-01-14 10:24:44',NULL,NULL,5,21.1,1,'jherrric',141),(2,'','2019-01-14 10:24:51',NULL,NULL,5,59.3,1,'jherrric',1),(3,'\0','2019-01-14 10:28:35',NULL,NULL,5,0,1,'jherrric',25),(4,'\0','2019-01-14 12:09:31',NULL,NULL,5,0,1,'jherrric',141),(5,'\0','2019-01-14 12:12:55',NULL,NULL,5,0,1,'jherrric',1),(6,'\0','2019-01-14 12:52:08',NULL,NULL,5,0,1,'jherrric',NULL),(7,'\0','2019-01-14 12:52:09',NULL,NULL,5,0,1,'jherrric',1),(8,'\0','2019-01-14 12:54:12',NULL,NULL,5,0,1,'jherrric',NULL),(9,'\0','2019-01-14 12:55:44',NULL,NULL,5,0,1,'jherrric',10),(10,'','2019-01-14 14:09:41',NULL,NULL,5,14.6,1,'jherrric',93),(11,'','2019-01-14 14:16:28',NULL,NULL,5,30.9,1,'jherrric',141),(12,'','2019-01-14 14:21:24',NULL,NULL,5,16.2,1,'jherrric',141),(13,'','2019-01-14 14:31:46',NULL,NULL,5,33,1,'jherrric',141);
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notasasignaciones`
--

LOCK TABLES `notasasignaciones` WRITE;
/*!40000 ALTER TABLE `notasasignaciones` DISABLE KEYS */;
INSERT INTO `notasasignaciones` VALUES (1,1,2,'nota asignacion\n');
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notassections`
--

LOCK TABLES `notassections` WRITE;
/*!40000 ALTER TABLE `notassections` DISABLE KEYS */;
INSERT INTO `notassections` VALUES (1,2,'nota seccion\n',1);
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
  `Pregunta` varchar(500) NOT NULL,
  `Peso` float NOT NULL,
  `EsHabilitante` bit(1) NOT NULL DEFAULT b'0',
  `PreguntaHabilitanteId` int(11) DEFAULT NULL,
  `Nivel` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`Id`),
  KEY `IX_Preguntas_AsignacionId` (`AsignacionId`),
  KEY `IX_Preguntas_PreguntaHabilitanteId` (`PreguntaHabilitanteId`),
  CONSTRAINT `FK_Preguntas_Asignaciones_AsignacionId` FOREIGN KEY (`AsignacionId`) REFERENCES `asignaciones` (`Id`) ON DELETE CASCADE,
  CONSTRAINT `FK_Preguntas_Preguntas_PreguntaHabilitanteId` FOREIGN KEY (`PreguntaHabilitanteId`) REFERENCES `preguntas` (`Id`) ON DELETE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=142 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `preguntas`
--

LOCK TABLES `preguntas` WRITE;
/*!40000 ALTER TABLE `preguntas` DISABLE KEYS */;
INSERT INTO `preguntas` VALUES (1,1,'Si','¿Existe el rol de Product Owner en el equipo?',0,'',NULL,1),(2,1,'Si','¿El Product Owner tiene poder para priorizar los elementos del Product Backlog?',0.9,'\0',1,2),(3,1,'Si','¿El Product Owner tiene el conocimiento suficiente para priorizar?',0.55,'\0',1,3),(4,1,'Si','¿El Product Owner tiene contacto directo con el equipo de desarrollo?',0.46,'\0',1,1),(5,1,'Si','¿El Product Owner tiene contacto directo con los interesados?',0.06,'\0',1,2),(6,1,'Si','¿El Product Owner tiene voz única (Si hay más de un Product Owner, solo hay una opinión)?',0.45,'\0',1,3),(7,1,'Si','¿El Product Owner tiene la visión del producto?',0.46,'\0',1,1),(8,1,'No','¿El Product Owner hace otras labores (codificar por ejemplo)?',0.04,'\0',1,2),(9,1,'No','¿El Product Owner toma decisiones técnicas?',0.08,'\0',1,1),(10,2,'Si','¿Existe el rol de Scrum Master en el equipo?',0,'',NULL,1),(11,2,'Si','¿El Scrum Master se enfoca en la resolución de impedimentos?',0.48,'\0',10,1),(12,2,'Si','¿El Scrum Master escala los impedimentos?',0.31,'\0',10,2),(13,2,'No','¿El Scrum Master hace otras labores (codificar/analizar por ejemplo)?',0.08,'\0',10,2),(14,2,'No','¿El Scrum Master toma decisiones técnicas o de negocio?',0.15,'\0',10,2),(15,2,'Si','¿El Scrum Master ayuda/guía al Product Owner para realizar correctamente su trabajo?',0.52,'\0',10,1),(16,2,'Si','¿El Scrum Master empodera al equipo?',0.85,'\0',10,3),(17,2,'No','¿El Scrum Master asume la responsabilidad si el equipo falla? ',0.15,'\0',10,3),(18,2,'Si','¿El Scrum Master permite que el equipo experimente y se equivoque?',0.46,'\0',10,2),(19,3,'Si','¿El equipo de desarrollo tiene todas las competencias necesarias?',0.75,'\0',NULL,2),(20,3,'No','¿Existen miembros del equipo de desarrollo encasillados, no conociendo absolutamente nada de otras áreas?',0.06,'\0',NULL,2),(21,3,'Si','¿Los miembros del equipo de desarrollo interactúan juntos en el desarrrollo de la solución?',0.38,'\0',NULL,1),(22,3,'Si','¿Hay como máximo 9 personas en el equipo de desarrollo?',0.46,'\0',NULL,1),(23,3,'No','¿Hay algún miembro del equipo de desarrollo que no esté alineado con Scrum?',0.16,'\0',NULL,1),(24,3,'Si','¿Tiene el equipo de desarrollo un drag factor interiorizado, planificado y consensuado con los stakeholders?',0.15,'\0',NULL,3),(25,3,'Si','¿El equipo de desarrollo usa o dispone de herramientas para organizar sus tareas?',0.19,'\0',NULL,2),(26,3,'No','¿El equipo de desarrollo tiene dependencias no resueltas?',0.85,'\0',NULL,3),(27,4,'Si','¿Se realiza la Daily Scrum?',0,'',NULL,1),(28,4,'Si','¿Solo interviene el equipo de desarrollo?',0.67,'\0',27,1),(29,4,'Si','¿Se emplean como máximo 15 min?',0.13,'\0',27,1),(30,4,'Si','¿Se mencionan los problemas e impedimentos?',0.73,'\0',27,2),(31,4,'Si','¿Se revisan los objetivos del Sprint?',1,'\0',27,3),(32,4,'Si','¿Se realiza siempre a la misma hora y lugar?',0.2,'\0',27,1),(33,4,'No','¿Interviene gente que no pertenece al equipo Scrum?',0.09,'\0',27,2),(34,4,'No','¿Se discute sobre soluciones técnicas durante la Daily Scrum?',0.18,'\0',27,2),(35,5,'Si','¿Se realiza la Retrospective al final de cada sprint?',0,'',NULL,1),(36,5,'Si','¿Hay alguien que haga de facilitador?',0.33,'\0',35,2),(37,5,'Si','¿El equipo Scrum al completo participa?',0.2,'\0',35,1),(38,5,'Si','¿Se analizan los problemas en profundidad?',0.33,'\0',35,2),(39,5,'Si','¿Se proponen soluciones a los problemas detectados?',0.77,'\0',35,1),(40,5,'No','¿Participa gente que no pertenece al equipo?',0.03,'\0',35,1),(41,5,'Si','¿Todo el equipo expresa su punto de vista?',0.75,'\0',35,3),(42,5,'Si','¿Se analizan las métricas y su impacto durante la retro?',0.25,'\0',35,3),(43,5,'Si','¿Se hace seguimiento a las acciones de las Retrospectives anteriores?',0.34,'\0',35,2),(44,6,'Si','¿Se realiza la Sprint Review al final de cada sprint?',0,'',NULL,1),(45,6,'Si','¿Se muestra software funcionando y probado?',0.75,'\0',44,1),(46,6,'Si','¿Se recibe feedback de interesados y Product Owner?',0.35,'\0',44,2),(47,6,'No','¿Se mencionan los items inacabados?',0.06,'\0',44,1),(48,6,'Si','¿Se revisa si se ha alcanzado el objetivo del Sprint?',0.47,'\0',44,2),(49,6,'No','¿Se muestran los items desarrollados pero no probados?',0.06,'\0',44,2),(50,6,'Si','¿Se invitan a los stakeholders a que participen?',0.2,'\0',44,3),(51,6,'Si','¿Se revisa lo que vamos a incluir en el siguiente sprint?',0.8,'\0',44,3),(52,6,'Si','¿Participa todo el equipo Scrum?',0.19,'\0',44,1),(53,6,'Si','¿Es el equipo de desarrollo el que enseña el incremento?',0.12,'\0',44,2),(54,7,'Si','¿Se realiza Sprint Planning por cada Sprint?',0,'',NULL,1),(55,7,'Si','¿El Product Owner está disponible para dudas?',0.27,'\0',54,1),(56,7,'Si','¿El equipo de desarrollo completo participa?',0.36,'\0',54,1),(57,7,'Si','¿El resultado de la sesión es el plan del Sprint?',0.06,'\0',54,1),(58,7,'Si','¿El equipo completo cree que el plan es alcanzable?',0.5,'\0',54,2),(59,7,'Si','¿Se llega a un consenso entre el Product Owner y el equipo de desarrollo en el alcance del Sprint Backlog?',0.38,'\0',54,3),(60,7,'Si','¿Los Product Backlog Items se dividen en tareas?',0.14,'\0',54,1),(61,7,'Si','¿Los Product Backlog Items son estimados?',0.11,'\0',54,1),(62,7,'Si','¿Se adquiere un compromiso por parte del equipo de desarrollo?',0.5,'\0',54,2),(63,7,'Si','¿Se analizan las dependencias que pueden surgir entre los Product Backlog Items?',0.62,'\0',54,3),(64,7,'No','¿Participa el Product Owner/Scrum Master en las estimaciones de los Product Backlog Items?',0.06,'\0',54,1),(65,8,'Si','¿Se realiza Refinement?',0,'',NULL,1),(66,8,'Si','¿Es el Product Owner quien solicita hacer una refinement?',0.77,'\0',65,1),(67,8,'Si','¿El Product Owner lleva las User Stories definidas para discutirlas?',0.83,'\0',65,2),(68,8,'No','¿Se dedica más del 10 % de la capacidad del equipo desarrollo?',1,'\0',65,3),(69,8,'Si','¿Se tratan los Product Backlog Items que son más prioritarios del Product Backlog?',0.23,'\0',65,1),(70,8,'Si','¿Participan los perfiles necesarios en la Refinement?',0.17,'\0',65,2),(71,9,'Si','¿Las iteraciones siempre duran lo mismo?',0,'',NULL,1),(72,9,'Si','¿La duración de las iteraciones es menor a un mes?',1,'\0',71,1),(73,9,'No','¿El equipo varia durante el Sprint?',0.31,'\0',71,2),(74,9,'No','¿Se continua el sprint aunque no tenga sentido el objetivo a alcanzar?',0.69,'\0',71,2),(75,10,'Si','¿Existe PB?',0,'',NULL,1),(76,10,'Si','¿EL PB refleja la visión del producto?',0.23,'\0',75,2),(77,10,'Si','¿El PB es visible para todos los miembros del equipo?',0.47,'\0',75,2),(78,10,'Si','¿Los PBIs se priorizan por su valor de negocio?',0.87,'\0',75,1),(79,10,'Si','¿El alcance de los PBIs más prioritarios está suficientemente claro como para incluirlos en un Sprint?',0.2,'\0',75,2),(80,10,'No','¿Es el alcance de los PBIs inmodificable?',0.41,'\0',75,3),(81,10,'Si','¿Los PBI son tan pequeños como para abordarse en un Sprint?',0.13,'\0',75,1),(82,10,'Si','¿El Equipo Scrum entiende el propósito de todos los PBIs?',0.07,'\0',75,2),(83,10,'Si','¿El equipo de desarrollo influye en la priorización del PB?',0.2,'\0',75,3),(84,10,'Si','¿El PB incluye algunas de las acciones elegidas en la Retrospectiva?',0.39,'\0',75,3),(85,10,'Si','¿Se refinan los PBIs antes de llegar a un Sprint Planning?',0.03,'\0',75,2),(86,11,'Si','¿Existe SB?',0,'',NULL,1),(87,11,'Si','¿El SB refleja el compromiso para el Sprint?',0.58,'\0',86,1),(88,11,'Si','¿El SB es visible para todos los miembros del equipo?',0.42,'\0',86,1),(89,11,'Si','¿El SB se revisa diariamente?',1,'\0',86,2),(90,11,'No','¿El PO ordena la prioridad de los items en el SB?',1,'\0',86,3),(91,12,'Si','¿El incremento tiene calidad para subirse a producción si el negocio así lo pidiera en cualquier momento?',0.6,'\0',NULL,2),(92,12,'No','¿Al finalizar el Sprint el incremento resultante siempre se sube a producción?',0.14,'\0',NULL,2),(93,12,'Si','¿Existe DoD?',0,'',NULL,1),(94,12,'Si','¿El DoD incluye los criterios de aceptación de los PBIs?',0.55,'\0',93,1),(95,12,'Si','¿El DoD incluye los requisitos no funcionales?',0.08,'\0',93,2),(96,12,'Si','¿El DoD es consistente con un incremento del producto potencialmente entregable?',0.68,'\0',93,3),(97,12,'Si','¿El equipo entiende el DoD?',0.45,'\0',93,1),(98,12,'No','¿El DoD es creado sólo por el equipo de desarrollo?',0.02,'\0',93,2),(99,12,'Si','¿Se revisa el DoD para que sea consistente con el propio producto?',0.32,'\0',93,3),(100,12,'Si','¿Tanto PO como equipo están de acuerdo con el DoD?',0.16,'\0',93,2),(101,13,'Si','¿El equipo cumple con el compromiso adquirido?',0.25,'\0',NULL,1),(102,13,'Si','¿Los líderes o managers de la organización conocen y comparten los principios ágiles?',0.75,'\0',NULL,1),(103,13,'Si','¿El SM asesora/guía en Scrum al resto de la organización?',0.81,'\0',NULL,2),(104,13,'No','¿El equipo se resiste a la transformación digital?',0.19,'\0',NULL,2),(105,13,'Si','¿El equipo participa de las decisiones sobre las propuestas de nuevos proyectos o servicios?',0.23,'\0',NULL,3),(106,13,'Si','¿El equipo está involucrado en el proceso de incorporación o salida de los miembros del propio equipo?',0.33,'\0',NULL,3),(107,13,'Si','¿El equipo participa de la transformación de su área?',0.44,'\0',NULL,3),(108,14,'No','¿El equipo es interrumpido frecuentemente durante el Sprint para otras necesidades diferentes al objetivo de propio Sprint?',0.3,'\0',NULL,2),(109,14,'No','¿Se realizan reuniones adicionales que estén fuera del framework de Scrum?',0.3,'\0',NULL,2),(110,14,'Si','¿Se respetan los timeboxes de las reuniones?',0.75,'\0',NULL,1),(111,14,'Si','¿Los miembros del equipo convocados a una reunión están presentes al inicio de la misma?',0.25,'\0',NULL,1),(112,14,'No','¿Se desvían las reuniones de sus objetivos?',0.4,'\0',NULL,2),(113,14,'Si','¿Se respetan las decisiones del equipo que solo afectan al equipo?',1,'\0',NULL,3),(114,15,'Si','¿El equipo practica la mejora continua y evoluciona su forma de trabajo?',0.46,'\0',NULL,1),(115,15,'No','¿Se buscan culpables de las malas decisiones del equipo?',0.28,'\0',NULL,1),(116,15,'Si','¿Existe un ambiente de confianza donde el equipo pueda expresar abiertamente su opinión, cómo se encuentra ...?',1,'\0',NULL,3),(117,15,'Si','¿El equipo dispone de espacio/tiempo para dedicar a la mejora continua?',0.26,'\0',NULL,1),(118,15,'No','¿Existen agentes externos que interfieren en la toma de decisiones del equipo?',1,'\0',NULL,2),(119,16,'No','¿El equipo estima los PBIs en horas?',0.5,'\0',NULL,1),(120,16,'Si','¿El equipo usa patrones para estimar?',0.5,'\0',NULL,1),(121,16,'Si','¿Estos patrones se revisan por el equipo?',0.29,'\0',NULL,2),(122,16,'Si','¿El equipo utiliza estos pratones para estimar las propuestas de nuevos proyectos?',0.12,'\0',NULL,3),(123,16,'Si','¿El equipo conoce su velocidad?',0,'',NULL,2),(124,16,'No','¿Para el cálculo de la velocidad el equipo tiene en cuenta los items no completados?',0.29,'\0',123,2),(125,16,'Si','¿El equipo tiene en cuenta su velocidad para establecer el compromiso en una nueva iteración?',0.75,'\0',123,3),(126,16,'Si','¿El equipo usa el Burndown Chart para visualizar su progreso durante el Sprint?',0,'',NULL,2),(127,16,'Si','¿El Burndown Chart es visible para todos los miembros del equipo?',0.42,'\0',126,2),(128,16,'Si','¿El equipo actualiza su Burndown Chart diariamente?',0.13,'\0',126,3),(129,17,'Si','¿Tiene el equipo la visión global del proyecto?',0.69,'\0',NULL,2),(130,17,'Si','¿Cuenta el equipo con el espacio adecuado para su desempeño?',0.14,'\0',NULL,2),(131,17,'Si','¿Utiliza el equipo un panel físico?',0.47,'\0',NULL,1),(132,17,'Si','¿Utiliza el equipo un panel digital?',0.53,'\0',NULL,1),(133,17,'Si','¿Está todo el equipo deslocalizado?',0,'',NULL,2),(134,17,'Si','¿El equipo utiliza sistemas de videoconferencia para sus reuniones?',0.14,'\0',133,2),(135,17,'Si','¿Cuenta el equipo con un espacio colaborativo para la gestión de la información?',0.03,'\0',133,2),(136,17,'Si','¿Aplican alguna técnica específica para colaborar durante los eventos de manera remota?',1,'\0',133,3),(137,18,'Si','¿El equipo ha definido su misión?',0.44,'\0',NULL,2),(138,18,'Si','¿El equipo ha definido su visión?',0.56,'\0',NULL,2),(139,18,'Si','¿El equipo ha definido sus valores?',0.47,'\0',NULL,3),(140,18,'Si','¿Están alineados éstos con la proyección profesional de sus miembros?',0.53,'\0',NULL,3),(141,18,'Si','¿El equipo conoce lo que la organización espera de él?',1,'\0',NULL,1);
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
  `TestProject` bit(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`Id`),
  KEY `IX_Proyectos_UserNombre` (`UserNombre`),
  CONSTRAINT `FK_Proyectos_Users_UserNombre` FOREIGN KEY (`UserNombre`) REFERENCES `users` (`Nombre`) ON DELETE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `proyectos`
--

LOCK TABLES `proyectos` WRITE;
/*!40000 ALTER TABLE `proyectos` DISABLE KEYS */;
INSERT INTO `proyectos` VALUES (1,'2018-07-10 00:00:00','BCA','Admin','\0'),(2,'2018-07-10 00:00:00','TESCO','Admin','\0'),(3,'2018-07-10 00:00:00','BestDay','User','\0'),(4,'2018-07-10 00:00:00','TVE','User','\0'),(5,'2018-12-18 09:16:38','Proyecto test jherrric','jherrric',''),(6,'2019-01-08 14:25:35','Proyecto test mcampong','mcampong','');
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
) ENGINE=InnoDB AUTO_INCREMENT=1834 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `respuestas`
--

LOCK TABLES `respuestas` WRITE;
/*!40000 ALTER TABLE `respuestas` DISABLE KEYS */;
INSERT INTO `respuestas` VALUES (1,2,1,NULL,NULL,1),(2,0,1,NULL,NULL,2),(3,0,1,NULL,NULL,3),(4,0,1,NULL,NULL,4),(5,0,1,NULL,NULL,5),(6,0,1,NULL,NULL,6),(7,0,1,NULL,NULL,7),(8,0,1,NULL,NULL,8),(9,0,1,NULL,NULL,9),(10,2,1,NULL,NULL,10),(11,0,1,NULL,NULL,11),(12,0,1,NULL,NULL,12),(13,0,1,NULL,NULL,13),(14,0,1,NULL,NULL,14),(15,0,1,NULL,NULL,15),(16,0,1,NULL,NULL,16),(17,0,1,NULL,NULL,17),(18,0,1,NULL,NULL,18),(19,1,1,NULL,NULL,19),(20,1,1,NULL,NULL,20),(21,1,1,NULL,NULL,21),(22,1,1,NULL,NULL,22),(23,1,1,NULL,NULL,23),(24,2,1,NULL,NULL,24),(25,1,1,NULL,NULL,25),(26,1,1,NULL,NULL,26),(27,2,1,NULL,NULL,27),(28,0,1,NULL,NULL,28),(29,0,1,NULL,NULL,29),(30,0,1,NULL,NULL,30),(31,0,1,NULL,NULL,31),(32,0,1,NULL,NULL,32),(33,0,1,NULL,NULL,33),(34,0,1,NULL,NULL,34),(35,2,1,NULL,NULL,35),(36,0,1,NULL,NULL,36),(37,0,1,NULL,NULL,37),(38,0,1,NULL,NULL,38),(39,0,1,NULL,NULL,39),(40,0,1,NULL,NULL,40),(41,0,1,NULL,NULL,41),(42,0,1,NULL,NULL,42),(43,0,1,NULL,NULL,43),(44,2,1,NULL,NULL,44),(45,0,1,NULL,NULL,45),(46,0,1,NULL,NULL,46),(47,0,1,NULL,NULL,47),(48,0,1,NULL,NULL,48),(49,0,1,NULL,NULL,49),(50,0,1,NULL,NULL,50),(51,0,1,NULL,NULL,51),(52,0,1,NULL,NULL,52),(53,0,1,NULL,NULL,53),(54,2,1,NULL,NULL,54),(55,0,1,NULL,NULL,55),(56,0,1,NULL,NULL,56),(57,0,1,NULL,NULL,57),(58,0,1,NULL,NULL,58),(59,0,1,NULL,NULL,59),(60,0,1,NULL,NULL,60),(61,0,1,NULL,NULL,61),(62,0,1,NULL,NULL,62),(63,0,1,NULL,NULL,63),(64,0,1,NULL,NULL,64),(65,2,1,NULL,NULL,65),(66,0,1,NULL,NULL,66),(67,0,1,NULL,NULL,67),(68,0,1,NULL,NULL,68),(69,0,1,NULL,NULL,69),(70,0,1,NULL,NULL,70),(71,2,1,NULL,NULL,71),(72,0,1,NULL,NULL,72),(73,0,1,NULL,NULL,73),(74,0,1,NULL,NULL,74),(75,2,1,NULL,NULL,75),(76,0,1,NULL,NULL,76),(77,0,1,NULL,NULL,77),(78,0,1,NULL,NULL,78),(79,0,1,NULL,NULL,79),(80,0,1,NULL,NULL,80),(81,0,1,NULL,NULL,81),(82,0,1,NULL,NULL,82),(83,0,1,NULL,NULL,83),(84,0,1,NULL,NULL,84),(85,0,1,NULL,NULL,85),(86,2,1,NULL,NULL,86),(87,0,1,NULL,NULL,87),(88,0,1,NULL,NULL,88),(89,0,1,NULL,NULL,89),(90,0,1,NULL,NULL,90),(91,2,1,NULL,NULL,91),(92,2,1,NULL,NULL,92),(93,2,1,NULL,NULL,93),(94,0,1,NULL,NULL,94),(95,0,1,NULL,NULL,95),(96,0,1,NULL,NULL,96),(97,0,1,NULL,NULL,97),(98,0,1,NULL,NULL,98),(99,0,1,NULL,NULL,99),(100,0,1,NULL,NULL,100),(101,1,1,NULL,NULL,101),(102,1,1,NULL,NULL,102),(103,1,1,NULL,NULL,103),(104,1,1,NULL,NULL,104),(105,1,1,NULL,NULL,105),(106,1,1,NULL,NULL,106),(107,1,1,NULL,NULL,107),(108,2,1,NULL,NULL,108),(109,2,1,NULL,NULL,109),(110,2,1,NULL,NULL,110),(111,2,1,NULL,NULL,111),(112,2,1,NULL,NULL,112),(113,2,1,NULL,NULL,113),(114,1,1,NULL,NULL,114),(115,1,1,NULL,NULL,115),(116,1,1,NULL,NULL,116),(117,1,1,NULL,NULL,117),(118,1,1,NULL,NULL,118),(119,1,1,NULL,NULL,119),(120,1,1,NULL,NULL,120),(121,1,1,NULL,NULL,121),(122,1,1,NULL,NULL,122),(123,2,1,NULL,NULL,123),(124,0,1,NULL,NULL,124),(125,0,1,NULL,NULL,125),(126,2,1,NULL,NULL,126),(127,0,1,NULL,NULL,127),(128,0,1,NULL,NULL,128),(129,1,1,NULL,NULL,129),(130,1,1,NULL,NULL,130),(131,1,1,NULL,NULL,131),(132,1,1,NULL,NULL,132),(133,2,1,NULL,NULL,133),(134,0,1,NULL,NULL,134),(135,0,1,NULL,NULL,135),(136,0,1,NULL,NULL,136),(137,1,1,NULL,NULL,137),(138,1,1,NULL,NULL,138),(139,2,1,NULL,NULL,139),(140,2,1,NULL,NULL,140),(141,2,1,NULL,NULL,141),(142,1,2,'nota pregunta',NULL,1),(143,1,2,NULL,NULL,2),(144,1,2,NULL,NULL,3),(145,1,2,NULL,NULL,4),(146,2,2,NULL,NULL,5),(147,2,2,NULL,NULL,6),(148,2,2,NULL,NULL,7),(149,1,2,NULL,NULL,8),(150,1,2,NULL,NULL,9),(151,1,2,NULL,NULL,10),(152,1,2,NULL,NULL,11),(153,1,2,NULL,NULL,12),(154,1,2,NULL,NULL,13),(155,1,2,NULL,NULL,14),(156,1,2,NULL,NULL,15),(157,2,2,NULL,NULL,16),(158,2,2,NULL,NULL,17),(159,2,2,NULL,NULL,18),(160,1,2,NULL,NULL,19),(161,1,2,NULL,NULL,20),(162,1,2,NULL,NULL,21),(163,1,2,NULL,NULL,22),(164,1,2,NULL,NULL,23),(165,1,2,NULL,NULL,24),(166,1,2,NULL,NULL,25),(167,1,2,NULL,NULL,26),(168,1,2,NULL,NULL,27),(169,1,2,NULL,NULL,28),(170,1,2,NULL,NULL,29),(171,2,2,NULL,NULL,30),(172,2,2,NULL,NULL,31),(173,2,2,NULL,NULL,32),(174,2,2,NULL,NULL,33),(175,2,2,NULL,NULL,34),(176,1,2,NULL,NULL,35),(177,1,2,NULL,NULL,36),(178,1,2,NULL,NULL,37),(179,2,2,NULL,NULL,38),(180,2,2,NULL,NULL,39),(181,2,2,NULL,NULL,40),(182,1,2,NULL,NULL,41),(183,1,2,NULL,NULL,42),(184,1,2,NULL,NULL,43),(185,1,2,NULL,NULL,44),(186,1,2,NULL,NULL,45),(187,1,2,NULL,NULL,46),(188,1,2,NULL,NULL,47),(189,2,2,NULL,NULL,48),(190,2,2,NULL,NULL,49),(191,2,2,NULL,NULL,50),(192,1,2,NULL,NULL,51),(193,1,2,NULL,NULL,52),(194,1,2,NULL,NULL,53),(195,1,2,NULL,NULL,54),(196,1,2,NULL,NULL,55),(197,1,2,NULL,NULL,56),(198,1,2,NULL,NULL,57),(199,1,2,NULL,NULL,58),(200,1,2,NULL,NULL,59),(201,2,2,NULL,NULL,60),(202,2,2,NULL,NULL,61),(203,2,2,NULL,NULL,62),(204,2,2,NULL,NULL,63),(205,1,2,NULL,NULL,64),(206,1,2,NULL,NULL,65),(207,1,2,NULL,NULL,66),(208,1,2,NULL,NULL,67),(209,2,2,NULL,NULL,68),(210,2,2,NULL,NULL,69),(211,2,2,NULL,NULL,70),(212,1,2,NULL,NULL,71),(213,1,2,NULL,NULL,72),(214,1,2,NULL,NULL,73),(215,1,2,NULL,NULL,74),(216,1,2,NULL,NULL,75),(217,1,2,NULL,NULL,76),(218,1,2,NULL,NULL,77),(219,1,2,NULL,NULL,78),(220,1,2,NULL,NULL,79),(221,2,2,NULL,NULL,80),(222,2,2,NULL,NULL,81),(223,2,2,NULL,NULL,82),(224,2,2,NULL,NULL,83),(225,2,2,NULL,NULL,84),(226,2,2,NULL,NULL,85),(227,1,2,NULL,NULL,86),(228,1,2,NULL,NULL,87),(229,2,2,NULL,NULL,88),(230,2,2,NULL,NULL,89),(231,2,2,NULL,NULL,90),(232,1,2,NULL,NULL,91),(233,1,2,NULL,NULL,92),(234,1,2,NULL,NULL,93),(235,1,2,NULL,NULL,94),(236,1,2,NULL,NULL,95),(237,1,2,NULL,NULL,96),(238,2,2,NULL,NULL,97),(239,2,2,NULL,NULL,98),(240,2,2,NULL,NULL,99),(241,2,2,NULL,NULL,100),(242,1,2,NULL,NULL,101),(243,1,2,NULL,NULL,102),(244,1,2,NULL,NULL,103),(245,1,2,NULL,NULL,104),(246,1,2,NULL,NULL,105),(247,1,2,NULL,NULL,106),(248,1,2,NULL,NULL,107),(249,1,2,NULL,NULL,108),(250,1,2,NULL,NULL,109),(251,2,2,NULL,NULL,110),(252,2,2,NULL,NULL,111),(253,1,2,NULL,NULL,112),(254,1,2,NULL,NULL,113),(255,1,2,NULL,NULL,114),(256,1,2,NULL,NULL,115),(257,1,2,NULL,NULL,116),(258,1,2,NULL,NULL,117),(259,1,2,NULL,NULL,118),(260,1,2,NULL,NULL,119),(261,1,2,NULL,NULL,120),(262,1,2,NULL,NULL,121),(263,1,2,NULL,NULL,122),(264,2,2,NULL,NULL,123),(265,0,2,NULL,NULL,124),(266,0,2,NULL,NULL,125),(267,2,2,NULL,NULL,126),(268,0,2,NULL,NULL,127),(269,0,2,NULL,NULL,128),(270,1,2,NULL,NULL,129),(271,1,2,NULL,NULL,130),(272,1,2,NULL,NULL,131),(273,1,2,NULL,NULL,132),(274,1,2,NULL,NULL,133),(275,2,2,NULL,NULL,134),(276,2,2,NULL,NULL,135),(277,2,2,NULL,NULL,136),(278,1,2,NULL,NULL,137),(279,1,2,NULL,NULL,138),(280,1,2,NULL,NULL,139),(281,1,2,NULL,NULL,140),(282,1,2,NULL,NULL,141),(283,2,3,NULL,NULL,1),(284,0,3,NULL,NULL,2),(285,0,3,NULL,NULL,3),(286,0,3,NULL,NULL,4),(287,0,3,NULL,NULL,5),(288,0,3,NULL,NULL,6),(289,0,3,NULL,NULL,7),(290,0,3,NULL,NULL,8),(291,0,3,NULL,NULL,9),(292,2,3,NULL,NULL,10),(293,0,3,NULL,NULL,11),(294,0,3,NULL,NULL,12),(295,0,3,NULL,NULL,13),(296,0,3,NULL,NULL,14),(297,0,3,NULL,NULL,15),(298,0,3,NULL,NULL,16),(299,0,3,NULL,NULL,17),(300,0,3,NULL,NULL,18),(301,2,3,NULL,NULL,19),(302,1,3,NULL,NULL,20),(303,1,3,NULL,NULL,21),(304,1,3,NULL,NULL,22),(305,1,3,NULL,NULL,23),(306,1,3,NULL,NULL,24),(307,1,3,NULL,NULL,25),(308,1,3,NULL,NULL,26),(309,0,3,NULL,NULL,27),(310,0,3,NULL,NULL,28),(311,0,3,NULL,NULL,29),(312,0,3,NULL,NULL,30),(313,0,3,NULL,NULL,31),(314,0,3,NULL,NULL,32),(315,0,3,NULL,NULL,33),(316,0,3,NULL,NULL,34),(317,0,3,NULL,NULL,35),(318,0,3,NULL,NULL,36),(319,0,3,NULL,NULL,37),(320,0,3,NULL,NULL,38),(321,0,3,NULL,NULL,39),(322,0,3,NULL,NULL,40),(323,0,3,NULL,NULL,41),(324,0,3,NULL,NULL,42),(325,0,3,NULL,NULL,43),(326,0,3,NULL,NULL,44),(327,0,3,NULL,NULL,45),(328,0,3,NULL,NULL,46),(329,0,3,NULL,NULL,47),(330,0,3,NULL,NULL,48),(331,0,3,NULL,NULL,49),(332,0,3,NULL,NULL,50),(333,0,3,NULL,NULL,51),(334,0,3,NULL,NULL,52),(335,0,3,NULL,NULL,53),(336,0,3,NULL,NULL,54),(337,0,3,NULL,NULL,55),(338,0,3,NULL,NULL,56),(339,0,3,NULL,NULL,57),(340,0,3,NULL,NULL,58),(341,0,3,NULL,NULL,59),(342,0,3,NULL,NULL,60),(343,0,3,NULL,NULL,61),(344,0,3,NULL,NULL,62),(345,0,3,NULL,NULL,63),(346,0,3,NULL,NULL,64),(347,0,3,NULL,NULL,65),(348,0,3,NULL,NULL,66),(349,0,3,NULL,NULL,67),(350,0,3,NULL,NULL,68),(351,0,3,NULL,NULL,69),(352,0,3,NULL,NULL,70),(353,0,3,NULL,NULL,71),(354,0,3,NULL,NULL,72),(355,0,3,NULL,NULL,73),(356,0,3,NULL,NULL,74),(357,0,3,NULL,NULL,75),(358,0,3,NULL,NULL,76),(359,0,3,NULL,NULL,77),(360,0,3,NULL,NULL,78),(361,0,3,NULL,NULL,79),(362,0,3,NULL,NULL,80),(363,0,3,NULL,NULL,81),(364,0,3,NULL,NULL,82),(365,0,3,NULL,NULL,83),(366,0,3,NULL,NULL,84),(367,0,3,NULL,NULL,85),(368,0,3,NULL,NULL,86),(369,0,3,NULL,NULL,87),(370,0,3,NULL,NULL,88),(371,0,3,NULL,NULL,89),(372,0,3,NULL,NULL,90),(373,0,3,NULL,NULL,91),(374,0,3,NULL,NULL,92),(375,1,3,NULL,NULL,93),(376,0,3,NULL,NULL,94),(377,0,3,NULL,NULL,95),(378,0,3,NULL,NULL,96),(379,0,3,NULL,NULL,97),(380,0,3,NULL,NULL,98),(381,0,3,NULL,NULL,99),(382,0,3,NULL,NULL,100),(383,0,3,NULL,NULL,101),(384,0,3,NULL,NULL,102),(385,0,3,NULL,NULL,103),(386,0,3,NULL,NULL,104),(387,0,3,NULL,NULL,105),(388,0,3,NULL,NULL,106),(389,0,3,NULL,NULL,107),(390,0,3,NULL,NULL,108),(391,0,3,NULL,NULL,109),(392,0,3,NULL,NULL,110),(393,0,3,NULL,NULL,111),(394,0,3,NULL,NULL,112),(395,0,3,NULL,NULL,113),(396,0,3,NULL,NULL,114),(397,0,3,NULL,NULL,115),(398,0,3,NULL,NULL,116),(399,0,3,NULL,NULL,117),(400,0,3,NULL,NULL,118),(401,0,3,NULL,NULL,119),(402,1,3,NULL,NULL,120),(403,1,3,NULL,NULL,121),(404,0,3,NULL,NULL,122),(405,2,3,NULL,NULL,123),(406,0,3,NULL,NULL,124),(407,0,3,NULL,NULL,125),(408,0,3,NULL,NULL,126),(409,0,3,NULL,NULL,127),(410,0,3,NULL,NULL,128),(411,0,3,NULL,NULL,129),(412,0,3,NULL,NULL,130),(413,0,3,NULL,NULL,131),(414,0,3,NULL,NULL,132),(415,0,3,NULL,NULL,133),(416,0,3,NULL,NULL,134),(417,0,3,NULL,NULL,135),(418,0,3,NULL,NULL,136),(419,0,3,NULL,NULL,137),(420,0,3,NULL,NULL,138),(421,0,3,NULL,NULL,139),(422,0,3,NULL,NULL,140),(423,0,3,NULL,NULL,141),(424,2,4,NULL,NULL,1),(425,0,4,NULL,NULL,2),(426,0,4,NULL,NULL,3),(427,0,4,NULL,NULL,4),(428,0,4,NULL,NULL,5),(429,0,4,NULL,NULL,6),(430,0,4,NULL,NULL,7),(431,0,4,NULL,NULL,8),(432,0,4,NULL,NULL,9),(433,2,4,NULL,NULL,10),(434,0,4,NULL,NULL,11),(435,0,4,NULL,NULL,12),(436,0,4,NULL,NULL,13),(437,0,4,NULL,NULL,14),(438,0,4,NULL,NULL,15),(439,0,4,NULL,NULL,16),(440,0,4,NULL,NULL,17),(441,0,4,NULL,NULL,18),(442,2,4,NULL,NULL,19),(443,2,4,NULL,NULL,20),(444,2,4,NULL,NULL,21),(445,2,4,NULL,NULL,22),(446,1,4,NULL,NULL,23),(447,1,4,NULL,NULL,24),(448,1,4,NULL,NULL,25),(449,1,4,NULL,NULL,26),(450,2,4,NULL,NULL,27),(451,0,4,NULL,NULL,28),(452,0,4,NULL,NULL,29),(453,0,4,NULL,NULL,30),(454,0,4,NULL,NULL,31),(455,0,4,NULL,NULL,32),(456,0,4,NULL,NULL,33),(457,0,4,NULL,NULL,34),(458,2,4,NULL,NULL,35),(459,0,4,NULL,NULL,36),(460,0,4,NULL,NULL,37),(461,0,4,NULL,NULL,38),(462,0,4,NULL,NULL,39),(463,0,4,NULL,NULL,40),(464,0,4,NULL,NULL,41),(465,0,4,NULL,NULL,42),(466,0,4,NULL,NULL,43),(467,2,4,NULL,NULL,44),(468,0,4,NULL,NULL,45),(469,0,4,NULL,NULL,46),(470,0,4,NULL,NULL,47),(471,0,4,NULL,NULL,48),(472,0,4,NULL,NULL,49),(473,0,4,NULL,NULL,50),(474,0,4,NULL,NULL,51),(475,0,4,NULL,NULL,52),(476,0,4,NULL,NULL,53),(477,2,4,NULL,NULL,54),(478,0,4,NULL,NULL,55),(479,0,4,NULL,NULL,56),(480,0,4,NULL,NULL,57),(481,0,4,NULL,NULL,58),(482,0,4,NULL,NULL,59),(483,0,4,NULL,NULL,60),(484,0,4,NULL,NULL,61),(485,0,4,NULL,NULL,62),(486,0,4,NULL,NULL,63),(487,0,4,NULL,NULL,64),(488,2,4,NULL,NULL,65),(489,0,4,NULL,NULL,66),(490,0,4,NULL,NULL,67),(491,0,4,NULL,NULL,68),(492,0,4,NULL,NULL,69),(493,0,4,NULL,NULL,70),(494,2,4,NULL,NULL,71),(495,0,4,NULL,NULL,72),(496,0,4,NULL,NULL,73),(497,0,4,NULL,NULL,74),(498,2,4,NULL,NULL,75),(499,0,4,NULL,NULL,76),(500,0,4,NULL,NULL,77),(501,0,4,NULL,NULL,78),(502,0,4,NULL,NULL,79),(503,0,4,NULL,NULL,80),(504,0,4,NULL,NULL,81),(505,0,4,NULL,NULL,82),(506,0,4,NULL,NULL,83),(507,0,4,NULL,NULL,84),(508,0,4,NULL,NULL,85),(509,2,4,NULL,NULL,86),(510,0,4,NULL,NULL,87),(511,0,4,NULL,NULL,88),(512,0,4,NULL,NULL,89),(513,0,4,NULL,NULL,90),(514,2,4,NULL,NULL,91),(515,2,4,NULL,NULL,92),(516,2,4,NULL,NULL,93),(517,0,4,NULL,NULL,94),(518,0,4,NULL,NULL,95),(519,0,4,NULL,NULL,96),(520,0,4,NULL,NULL,97),(521,0,4,NULL,NULL,98),(522,0,4,NULL,NULL,99),(523,0,4,NULL,NULL,100),(524,1,4,NULL,NULL,101),(525,1,4,NULL,NULL,102),(526,1,4,NULL,NULL,103),(527,1,4,NULL,NULL,104),(528,2,4,NULL,NULL,105),(529,2,4,NULL,NULL,106),(530,2,4,NULL,NULL,107),(531,2,4,NULL,NULL,108),(532,1,4,NULL,NULL,109),(533,1,4,NULL,NULL,110),(534,1,4,NULL,NULL,111),(535,1,4,NULL,NULL,112),(536,1,4,NULL,NULL,113),(537,1,4,NULL,NULL,114),(538,1,4,NULL,NULL,115),(539,1,4,NULL,NULL,116),(540,2,4,NULL,NULL,117),(541,2,4,NULL,NULL,118),(542,1,4,NULL,NULL,119),(543,1,4,NULL,NULL,120),(544,1,4,NULL,NULL,121),(545,1,4,NULL,NULL,122),(546,2,4,NULL,NULL,123),(547,0,4,NULL,NULL,124),(548,0,4,NULL,NULL,125),(549,2,4,NULL,NULL,126),(550,0,4,NULL,NULL,127),(551,0,4,NULL,NULL,128),(552,1,4,NULL,NULL,129),(553,1,4,NULL,NULL,130),(554,1,4,NULL,NULL,131),(555,1,4,NULL,NULL,132),(556,2,4,NULL,NULL,133),(557,0,4,NULL,NULL,134),(558,0,4,NULL,NULL,135),(559,0,4,NULL,NULL,136),(560,1,4,NULL,NULL,137),(561,1,4,NULL,NULL,138),(562,1,4,NULL,NULL,139),(563,1,4,NULL,NULL,140),(564,1,4,NULL,NULL,141),(565,2,5,NULL,NULL,1),(566,0,5,NULL,NULL,2),(567,0,5,NULL,NULL,3),(568,0,5,NULL,NULL,4),(569,0,5,NULL,NULL,5),(570,0,5,NULL,NULL,6),(571,0,5,NULL,NULL,7),(572,0,5,NULL,NULL,8),(573,0,5,NULL,NULL,9),(574,0,5,NULL,NULL,10),(575,0,5,NULL,NULL,11),(576,0,5,NULL,NULL,12),(577,0,5,NULL,NULL,13),(578,0,5,NULL,NULL,14),(579,0,5,NULL,NULL,15),(580,0,5,NULL,NULL,16),(581,0,5,NULL,NULL,17),(582,0,5,NULL,NULL,18),(583,0,5,NULL,NULL,19),(584,0,5,NULL,NULL,20),(585,0,5,NULL,NULL,21),(586,0,5,NULL,NULL,22),(587,0,5,NULL,NULL,23),(588,0,5,NULL,NULL,24),(589,0,5,NULL,NULL,25),(590,0,5,NULL,NULL,26),(591,0,5,NULL,NULL,27),(592,0,5,NULL,NULL,28),(593,0,5,NULL,NULL,29),(594,0,5,NULL,NULL,30),(595,0,5,NULL,NULL,31),(596,0,5,NULL,NULL,32),(597,0,5,NULL,NULL,33),(598,0,5,NULL,NULL,34),(599,0,5,NULL,NULL,35),(600,0,5,NULL,NULL,36),(601,0,5,NULL,NULL,37),(602,0,5,NULL,NULL,38),(603,0,5,NULL,NULL,39),(604,0,5,NULL,NULL,40),(605,0,5,NULL,NULL,41),(606,0,5,NULL,NULL,42),(607,0,5,NULL,NULL,43),(608,0,5,NULL,NULL,44),(609,0,5,NULL,NULL,45),(610,0,5,NULL,NULL,46),(611,0,5,NULL,NULL,47),(612,0,5,NULL,NULL,48),(613,0,5,NULL,NULL,49),(614,0,5,NULL,NULL,50),(615,0,5,NULL,NULL,51),(616,0,5,NULL,NULL,52),(617,0,5,NULL,NULL,53),(618,0,5,NULL,NULL,54),(619,0,5,NULL,NULL,55),(620,0,5,NULL,NULL,56),(621,0,5,NULL,NULL,57),(622,0,5,NULL,NULL,58),(623,0,5,NULL,NULL,59),(624,0,5,NULL,NULL,60),(625,0,5,NULL,NULL,61),(626,0,5,NULL,NULL,62),(627,0,5,NULL,NULL,63),(628,0,5,NULL,NULL,64),(629,0,5,NULL,NULL,65),(630,0,5,NULL,NULL,66),(631,0,5,NULL,NULL,67),(632,0,5,NULL,NULL,68),(633,0,5,NULL,NULL,69),(634,0,5,NULL,NULL,70),(635,0,5,NULL,NULL,71),(636,0,5,NULL,NULL,72),(637,0,5,NULL,NULL,73),(638,0,5,NULL,NULL,74),(639,0,5,NULL,NULL,75),(640,0,5,NULL,NULL,76),(641,0,5,NULL,NULL,77),(642,0,5,NULL,NULL,78),(643,0,5,NULL,NULL,79),(644,0,5,NULL,NULL,80),(645,0,5,NULL,NULL,81),(646,0,5,NULL,NULL,82),(647,0,5,NULL,NULL,83),(648,0,5,NULL,NULL,84),(649,0,5,NULL,NULL,85),(650,0,5,NULL,NULL,86),(651,0,5,NULL,NULL,87),(652,0,5,NULL,NULL,88),(653,0,5,NULL,NULL,89),(654,0,5,NULL,NULL,90),(655,0,5,NULL,NULL,91),(656,0,5,NULL,NULL,92),(657,0,5,NULL,NULL,93),(658,0,5,NULL,NULL,94),(659,0,5,NULL,NULL,95),(660,0,5,NULL,NULL,96),(661,0,5,NULL,NULL,97),(662,0,5,NULL,NULL,98),(663,0,5,NULL,NULL,99),(664,0,5,NULL,NULL,100),(665,0,5,NULL,NULL,101),(666,0,5,NULL,NULL,102),(667,0,5,NULL,NULL,103),(668,0,5,NULL,NULL,104),(669,0,5,NULL,NULL,105),(670,0,5,NULL,NULL,106),(671,0,5,NULL,NULL,107),(672,0,5,NULL,NULL,108),(673,0,5,NULL,NULL,109),(674,0,5,NULL,NULL,110),(675,0,5,NULL,NULL,111),(676,0,5,NULL,NULL,112),(677,0,5,NULL,NULL,113),(678,0,5,NULL,NULL,114),(679,0,5,NULL,NULL,115),(680,0,5,NULL,NULL,116),(681,0,5,NULL,NULL,117),(682,0,5,NULL,NULL,118),(683,0,5,NULL,NULL,119),(684,0,5,NULL,NULL,120),(685,0,5,NULL,NULL,121),(686,0,5,NULL,NULL,122),(687,0,5,NULL,NULL,123),(688,0,5,NULL,NULL,124),(689,0,5,NULL,NULL,125),(690,0,5,NULL,NULL,126),(691,0,5,NULL,NULL,127),(692,0,5,NULL,NULL,128),(693,0,5,NULL,NULL,129),(694,0,5,NULL,NULL,130),(695,0,5,NULL,NULL,131),(696,0,5,NULL,NULL,132),(697,0,5,NULL,NULL,133),(698,0,5,NULL,NULL,134),(699,0,5,NULL,NULL,135),(700,0,5,NULL,NULL,136),(701,0,5,NULL,NULL,137),(702,0,5,NULL,NULL,138),(703,0,5,NULL,NULL,139),(704,0,5,NULL,NULL,140),(705,0,5,NULL,NULL,141),(706,0,6,NULL,NULL,1),(707,0,6,NULL,NULL,2),(708,0,6,NULL,NULL,3),(709,0,6,NULL,NULL,4),(710,0,6,NULL,NULL,5),(711,0,6,NULL,NULL,6),(712,0,6,NULL,NULL,7),(713,0,6,NULL,NULL,8),(714,0,6,NULL,NULL,9),(715,0,6,NULL,NULL,10),(716,0,6,NULL,NULL,11),(717,0,6,NULL,NULL,12),(718,0,6,NULL,NULL,13),(719,0,6,NULL,NULL,14),(720,0,6,NULL,NULL,15),(721,0,6,NULL,NULL,16),(722,0,6,NULL,NULL,17),(723,0,6,NULL,NULL,18),(724,0,6,NULL,NULL,19),(725,0,6,NULL,NULL,20),(726,0,6,NULL,NULL,21),(727,0,6,NULL,NULL,22),(728,0,6,NULL,NULL,23),(729,0,6,NULL,NULL,24),(730,0,6,NULL,NULL,25),(731,0,6,NULL,NULL,26),(732,0,6,NULL,NULL,27),(733,0,6,NULL,NULL,28),(734,0,6,NULL,NULL,29),(735,0,6,NULL,NULL,30),(736,0,6,NULL,NULL,31),(737,0,6,NULL,NULL,32),(738,0,6,NULL,NULL,33),(739,0,6,NULL,NULL,34),(740,0,6,NULL,NULL,35),(741,0,6,NULL,NULL,36),(742,0,6,NULL,NULL,37),(743,0,6,NULL,NULL,38),(744,0,6,NULL,NULL,39),(745,0,6,NULL,NULL,40),(746,0,6,NULL,NULL,41),(747,0,6,NULL,NULL,42),(748,0,6,NULL,NULL,43),(749,0,6,NULL,NULL,44),(750,0,6,NULL,NULL,45),(751,0,6,NULL,NULL,46),(752,0,6,NULL,NULL,47),(753,0,6,NULL,NULL,48),(754,0,6,NULL,NULL,49),(755,0,6,NULL,NULL,50),(756,0,6,NULL,NULL,51),(757,0,6,NULL,NULL,52),(758,0,6,NULL,NULL,53),(759,0,6,NULL,NULL,54),(760,0,6,NULL,NULL,55),(761,0,6,NULL,NULL,56),(762,0,6,NULL,NULL,57),(763,0,6,NULL,NULL,58),(764,0,6,NULL,NULL,59),(765,0,6,NULL,NULL,60),(766,0,6,NULL,NULL,61),(767,0,6,NULL,NULL,62),(768,0,6,NULL,NULL,63),(769,0,6,NULL,NULL,64),(770,0,6,NULL,NULL,65),(771,0,6,NULL,NULL,66),(772,0,6,NULL,NULL,67),(773,0,6,NULL,NULL,68),(774,0,6,NULL,NULL,69),(775,0,6,NULL,NULL,70),(776,0,6,NULL,NULL,71),(777,0,6,NULL,NULL,72),(778,0,6,NULL,NULL,73),(779,0,6,NULL,NULL,74),(780,0,6,NULL,NULL,75),(781,0,6,NULL,NULL,76),(782,0,6,NULL,NULL,77),(783,0,6,NULL,NULL,78),(784,0,6,NULL,NULL,79),(785,0,6,NULL,NULL,80),(786,0,6,NULL,NULL,81),(787,0,6,NULL,NULL,82),(788,0,6,NULL,NULL,83),(789,0,6,NULL,NULL,84),(790,0,6,NULL,NULL,85),(791,0,6,NULL,NULL,86),(792,0,6,NULL,NULL,87),(793,0,6,NULL,NULL,88),(794,0,6,NULL,NULL,89),(795,0,6,NULL,NULL,90),(796,0,6,NULL,NULL,91),(797,0,6,NULL,NULL,92),(798,0,6,NULL,NULL,93),(799,0,6,NULL,NULL,94),(800,0,6,NULL,NULL,95),(801,0,6,NULL,NULL,96),(802,0,6,NULL,NULL,97),(803,0,6,NULL,NULL,98),(804,0,6,NULL,NULL,99),(805,0,6,NULL,NULL,100),(806,0,6,NULL,NULL,101),(807,0,6,NULL,NULL,102),(808,0,6,NULL,NULL,103),(809,0,6,NULL,NULL,104),(810,0,6,NULL,NULL,105),(811,0,6,NULL,NULL,106),(812,0,6,NULL,NULL,107),(813,0,6,NULL,NULL,108),(814,0,6,NULL,NULL,109),(815,0,6,NULL,NULL,110),(816,0,6,NULL,NULL,111),(817,0,6,NULL,NULL,112),(818,0,6,NULL,NULL,113),(819,0,6,NULL,NULL,114),(820,0,6,NULL,NULL,115),(821,0,6,NULL,NULL,116),(822,0,6,NULL,NULL,117),(823,0,6,NULL,NULL,118),(824,0,6,NULL,NULL,119),(825,0,6,NULL,NULL,120),(826,0,6,NULL,NULL,121),(827,0,6,NULL,NULL,122),(828,0,6,NULL,NULL,123),(829,0,6,NULL,NULL,124),(830,0,6,NULL,NULL,125),(831,0,6,NULL,NULL,126),(832,0,6,NULL,NULL,127),(833,0,6,NULL,NULL,128),(834,0,6,NULL,NULL,129),(835,0,6,NULL,NULL,130),(836,0,6,NULL,NULL,131),(837,0,6,NULL,NULL,132),(838,0,6,NULL,NULL,133),(839,0,6,NULL,NULL,134),(840,0,6,NULL,NULL,135),(841,0,6,NULL,NULL,136),(842,0,6,NULL,NULL,137),(843,0,6,NULL,NULL,138),(844,0,6,NULL,NULL,139),(845,0,6,NULL,NULL,140),(846,0,6,NULL,NULL,141),(847,1,7,NULL,NULL,1),(848,0,7,NULL,NULL,2),(849,0,7,NULL,NULL,3),(850,0,7,NULL,NULL,4),(851,0,7,NULL,NULL,5),(852,0,7,NULL,NULL,6),(853,0,7,NULL,NULL,7),(854,0,7,NULL,NULL,8),(855,0,7,NULL,NULL,9),(856,0,7,NULL,NULL,10),(857,0,7,NULL,NULL,11),(858,0,7,NULL,NULL,12),(859,0,7,NULL,NULL,13),(860,0,7,NULL,NULL,14),(861,0,7,NULL,NULL,15),(862,0,7,NULL,NULL,16),(863,0,7,NULL,NULL,17),(864,0,7,NULL,NULL,18),(865,0,7,NULL,NULL,19),(866,0,7,NULL,NULL,20),(867,0,7,NULL,NULL,21),(868,0,7,NULL,NULL,22),(869,0,7,NULL,NULL,23),(870,0,7,NULL,NULL,24),(871,0,7,NULL,NULL,25),(872,0,7,NULL,NULL,26),(873,0,7,NULL,NULL,27),(874,0,7,NULL,NULL,28),(875,0,7,NULL,NULL,29),(876,0,7,NULL,NULL,30),(877,0,7,NULL,NULL,31),(878,0,7,NULL,NULL,32),(879,0,7,NULL,NULL,33),(880,0,7,NULL,NULL,34),(881,0,7,NULL,NULL,35),(882,0,7,NULL,NULL,36),(883,0,7,NULL,NULL,37),(884,0,7,NULL,NULL,38),(885,0,7,NULL,NULL,39),(886,0,7,NULL,NULL,40),(887,0,7,NULL,NULL,41),(888,0,7,NULL,NULL,42),(889,0,7,NULL,NULL,43),(890,0,7,NULL,NULL,44),(891,0,7,NULL,NULL,45),(892,0,7,NULL,NULL,46),(893,0,7,NULL,NULL,47),(894,0,7,NULL,NULL,48),(895,0,7,NULL,NULL,49),(896,0,7,NULL,NULL,50),(897,0,7,NULL,NULL,51),(898,0,7,NULL,NULL,52),(899,0,7,NULL,NULL,53),(900,0,7,NULL,NULL,54),(901,0,7,NULL,NULL,55),(902,0,7,NULL,NULL,56),(903,0,7,NULL,NULL,57),(904,0,7,NULL,NULL,58),(905,0,7,NULL,NULL,59),(906,0,7,NULL,NULL,60),(907,0,7,NULL,NULL,61),(908,0,7,NULL,NULL,62),(909,0,7,NULL,NULL,63),(910,0,7,NULL,NULL,64),(911,0,7,NULL,NULL,65),(912,0,7,NULL,NULL,66),(913,0,7,NULL,NULL,67),(914,0,7,NULL,NULL,68),(915,0,7,NULL,NULL,69),(916,0,7,NULL,NULL,70),(917,0,7,NULL,NULL,71),(918,0,7,NULL,NULL,72),(919,0,7,NULL,NULL,73),(920,0,7,NULL,NULL,74),(921,0,7,NULL,NULL,75),(922,0,7,NULL,NULL,76),(923,0,7,NULL,NULL,77),(924,0,7,NULL,NULL,78),(925,0,7,NULL,NULL,79),(926,0,7,NULL,NULL,80),(927,0,7,NULL,NULL,81),(928,0,7,NULL,NULL,82),(929,0,7,NULL,NULL,83),(930,0,7,NULL,NULL,84),(931,0,7,NULL,NULL,85),(932,0,7,NULL,NULL,86),(933,0,7,NULL,NULL,87),(934,0,7,NULL,NULL,88),(935,0,7,NULL,NULL,89),(936,0,7,NULL,NULL,90),(937,0,7,NULL,NULL,91),(938,0,7,NULL,NULL,92),(939,0,7,NULL,NULL,93),(940,0,7,NULL,NULL,94),(941,0,7,NULL,NULL,95),(942,0,7,NULL,NULL,96),(943,0,7,NULL,NULL,97),(944,0,7,NULL,NULL,98),(945,0,7,NULL,NULL,99),(946,0,7,NULL,NULL,100),(947,0,7,NULL,NULL,101),(948,0,7,NULL,NULL,102),(949,0,7,NULL,NULL,103),(950,0,7,NULL,NULL,104),(951,0,7,NULL,NULL,105),(952,0,7,NULL,NULL,106),(953,0,7,NULL,NULL,107),(954,0,7,NULL,NULL,108),(955,0,7,NULL,NULL,109),(956,0,7,NULL,NULL,110),(957,0,7,NULL,NULL,111),(958,0,7,NULL,NULL,112),(959,0,7,NULL,NULL,113),(960,0,7,NULL,NULL,114),(961,0,7,NULL,NULL,115),(962,0,7,NULL,NULL,116),(963,0,7,NULL,NULL,117),(964,0,7,NULL,NULL,118),(965,0,7,NULL,NULL,119),(966,0,7,NULL,NULL,120),(967,0,7,NULL,NULL,121),(968,0,7,NULL,NULL,122),(969,0,7,NULL,NULL,123),(970,0,7,NULL,NULL,124),(971,0,7,NULL,NULL,125),(972,0,7,NULL,NULL,126),(973,0,7,NULL,NULL,127),(974,0,7,NULL,NULL,128),(975,0,7,NULL,NULL,129),(976,0,7,NULL,NULL,130),(977,0,7,NULL,NULL,131),(978,0,7,NULL,NULL,132),(979,0,7,NULL,NULL,133),(980,0,7,NULL,NULL,134),(981,0,7,NULL,NULL,135),(982,0,7,NULL,NULL,136),(983,0,7,NULL,NULL,137),(984,0,7,NULL,NULL,138),(985,0,7,NULL,NULL,139),(986,0,7,NULL,NULL,140),(987,0,7,NULL,NULL,141),(988,0,8,NULL,NULL,1),(989,0,8,NULL,NULL,2),(990,0,8,NULL,NULL,3),(991,0,8,NULL,NULL,4),(992,0,8,NULL,NULL,5),(993,0,8,NULL,NULL,6),(994,0,8,NULL,NULL,7),(995,0,8,NULL,NULL,8),(996,0,8,NULL,NULL,9),(997,0,8,NULL,NULL,10),(998,0,8,NULL,NULL,11),(999,0,8,NULL,NULL,12),(1000,0,8,NULL,NULL,13),(1001,0,8,NULL,NULL,14),(1002,0,8,NULL,NULL,15),(1003,0,8,NULL,NULL,16),(1004,0,8,NULL,NULL,17),(1005,0,8,NULL,NULL,18),(1006,0,8,NULL,NULL,19),(1007,0,8,NULL,NULL,20),(1008,0,8,NULL,NULL,21),(1009,0,8,NULL,NULL,22),(1010,0,8,NULL,NULL,23),(1011,0,8,NULL,NULL,24),(1012,0,8,NULL,NULL,25),(1013,0,8,NULL,NULL,26),(1014,0,8,NULL,NULL,27),(1015,0,8,NULL,NULL,28),(1016,0,8,NULL,NULL,29),(1017,0,8,NULL,NULL,30),(1018,0,8,NULL,NULL,31),(1019,0,8,NULL,NULL,32),(1020,0,8,NULL,NULL,33),(1021,0,8,NULL,NULL,34),(1022,0,8,NULL,NULL,35),(1023,0,8,NULL,NULL,36),(1024,0,8,NULL,NULL,37),(1025,0,8,NULL,NULL,38),(1026,0,8,NULL,NULL,39),(1027,0,8,NULL,NULL,40),(1028,0,8,NULL,NULL,41),(1029,0,8,NULL,NULL,42),(1030,0,8,NULL,NULL,43),(1031,0,8,NULL,NULL,44),(1032,0,8,NULL,NULL,45),(1033,0,8,NULL,NULL,46),(1034,0,8,NULL,NULL,47),(1035,0,8,NULL,NULL,48),(1036,0,8,NULL,NULL,49),(1037,0,8,NULL,NULL,50),(1038,0,8,NULL,NULL,51),(1039,0,8,NULL,NULL,52),(1040,0,8,NULL,NULL,53),(1041,0,8,NULL,NULL,54),(1042,0,8,NULL,NULL,55),(1043,0,8,NULL,NULL,56),(1044,0,8,NULL,NULL,57),(1045,0,8,NULL,NULL,58),(1046,0,8,NULL,NULL,59),(1047,0,8,NULL,NULL,60),(1048,0,8,NULL,NULL,61),(1049,0,8,NULL,NULL,62),(1050,0,8,NULL,NULL,63),(1051,0,8,NULL,NULL,64),(1052,0,8,NULL,NULL,65),(1053,0,8,NULL,NULL,66),(1054,0,8,NULL,NULL,67),(1055,0,8,NULL,NULL,68),(1056,0,8,NULL,NULL,69),(1057,0,8,NULL,NULL,70),(1058,0,8,NULL,NULL,71),(1059,0,8,NULL,NULL,72),(1060,0,8,NULL,NULL,73),(1061,0,8,NULL,NULL,74),(1062,0,8,NULL,NULL,75),(1063,0,8,NULL,NULL,76),(1064,0,8,NULL,NULL,77),(1065,0,8,NULL,NULL,78),(1066,0,8,NULL,NULL,79),(1067,0,8,NULL,NULL,80),(1068,0,8,NULL,NULL,81),(1069,0,8,NULL,NULL,82),(1070,0,8,NULL,NULL,83),(1071,0,8,NULL,NULL,84),(1072,0,8,NULL,NULL,85),(1073,0,8,NULL,NULL,86),(1074,0,8,NULL,NULL,87),(1075,0,8,NULL,NULL,88),(1076,0,8,NULL,NULL,89),(1077,0,8,NULL,NULL,90),(1078,0,8,NULL,NULL,91),(1079,0,8,NULL,NULL,92),(1080,0,8,NULL,NULL,93),(1081,0,8,NULL,NULL,94),(1082,0,8,NULL,NULL,95),(1083,0,8,NULL,NULL,96),(1084,0,8,NULL,NULL,97),(1085,0,8,NULL,NULL,98),(1086,0,8,NULL,NULL,99),(1087,0,8,NULL,NULL,100),(1088,0,8,NULL,NULL,101),(1089,0,8,NULL,NULL,102),(1090,0,8,NULL,NULL,103),(1091,0,8,NULL,NULL,104),(1092,0,8,NULL,NULL,105),(1093,0,8,NULL,NULL,106),(1094,0,8,NULL,NULL,107),(1095,0,8,NULL,NULL,108),(1096,0,8,NULL,NULL,109),(1097,0,8,NULL,NULL,110),(1098,0,8,NULL,NULL,111),(1099,0,8,NULL,NULL,112),(1100,0,8,NULL,NULL,113),(1101,0,8,NULL,NULL,114),(1102,0,8,NULL,NULL,115),(1103,0,8,NULL,NULL,116),(1104,0,8,NULL,NULL,117),(1105,0,8,NULL,NULL,118),(1106,0,8,NULL,NULL,119),(1107,0,8,NULL,NULL,120),(1108,0,8,NULL,NULL,121),(1109,0,8,NULL,NULL,122),(1110,0,8,NULL,NULL,123),(1111,0,8,NULL,NULL,124),(1112,0,8,NULL,NULL,125),(1113,0,8,NULL,NULL,126),(1114,0,8,NULL,NULL,127),(1115,0,8,NULL,NULL,128),(1116,0,8,NULL,NULL,129),(1117,0,8,NULL,NULL,130),(1118,0,8,NULL,NULL,131),(1119,0,8,NULL,NULL,132),(1120,0,8,NULL,NULL,133),(1121,0,8,NULL,NULL,134),(1122,0,8,NULL,NULL,135),(1123,0,8,NULL,NULL,136),(1124,0,8,NULL,NULL,137),(1125,0,8,NULL,NULL,138),(1126,0,8,NULL,NULL,139),(1127,0,8,NULL,NULL,140),(1128,0,8,NULL,NULL,141),(1129,2,9,NULL,NULL,1),(1130,0,9,NULL,NULL,2),(1131,0,9,NULL,NULL,3),(1132,0,9,NULL,NULL,4),(1133,0,9,NULL,NULL,5),(1134,0,9,NULL,NULL,6),(1135,0,9,NULL,NULL,7),(1136,0,9,NULL,NULL,8),(1137,0,9,NULL,NULL,9),(1138,2,9,NULL,NULL,10),(1139,0,9,NULL,NULL,11),(1140,0,9,NULL,NULL,12),(1141,0,9,NULL,NULL,13),(1142,0,9,NULL,NULL,14),(1143,0,9,NULL,NULL,15),(1144,0,9,NULL,NULL,16),(1145,0,9,NULL,NULL,17),(1146,0,9,NULL,NULL,18),(1147,0,9,NULL,NULL,19),(1148,0,9,NULL,NULL,20),(1149,0,9,NULL,NULL,21),(1150,0,9,NULL,NULL,22),(1151,0,9,NULL,NULL,23),(1152,0,9,NULL,NULL,24),(1153,0,9,NULL,NULL,25),(1154,0,9,NULL,NULL,26),(1155,0,9,NULL,NULL,27),(1156,0,9,NULL,NULL,28),(1157,0,9,NULL,NULL,29),(1158,0,9,NULL,NULL,30),(1159,0,9,NULL,NULL,31),(1160,0,9,NULL,NULL,32),(1161,0,9,NULL,NULL,33),(1162,0,9,NULL,NULL,34),(1163,0,9,NULL,NULL,35),(1164,0,9,NULL,NULL,36),(1165,0,9,NULL,NULL,37),(1166,0,9,NULL,NULL,38),(1167,0,9,NULL,NULL,39),(1168,0,9,NULL,NULL,40),(1169,0,9,NULL,NULL,41),(1170,0,9,NULL,NULL,42),(1171,0,9,NULL,NULL,43),(1172,0,9,NULL,NULL,44),(1173,0,9,NULL,NULL,45),(1174,0,9,NULL,NULL,46),(1175,0,9,NULL,NULL,47),(1176,0,9,NULL,NULL,48),(1177,0,9,NULL,NULL,49),(1178,0,9,NULL,NULL,50),(1179,0,9,NULL,NULL,51),(1180,0,9,NULL,NULL,52),(1181,0,9,NULL,NULL,53),(1182,0,9,NULL,NULL,54),(1183,0,9,NULL,NULL,55),(1184,0,9,NULL,NULL,56),(1185,0,9,NULL,NULL,57),(1186,0,9,NULL,NULL,58),(1187,0,9,NULL,NULL,59),(1188,0,9,NULL,NULL,60),(1189,0,9,NULL,NULL,61),(1190,0,9,NULL,NULL,62),(1191,0,9,NULL,NULL,63),(1192,0,9,NULL,NULL,64),(1193,0,9,NULL,NULL,65),(1194,0,9,NULL,NULL,66),(1195,0,9,NULL,NULL,67),(1196,0,9,NULL,NULL,68),(1197,0,9,NULL,NULL,69),(1198,0,9,NULL,NULL,70),(1199,0,9,NULL,NULL,71),(1200,0,9,NULL,NULL,72),(1201,0,9,NULL,NULL,73),(1202,0,9,NULL,NULL,74),(1203,0,9,NULL,NULL,75),(1204,0,9,NULL,NULL,76),(1205,0,9,NULL,NULL,77),(1206,0,9,NULL,NULL,78),(1207,0,9,NULL,NULL,79),(1208,0,9,NULL,NULL,80),(1209,0,9,NULL,NULL,81),(1210,0,9,NULL,NULL,82),(1211,0,9,NULL,NULL,83),(1212,0,9,NULL,NULL,84),(1213,0,9,NULL,NULL,85),(1214,0,9,NULL,NULL,86),(1215,0,9,NULL,NULL,87),(1216,0,9,NULL,NULL,88),(1217,0,9,NULL,NULL,89),(1218,0,9,NULL,NULL,90),(1219,0,9,NULL,NULL,91),(1220,0,9,NULL,NULL,92),(1221,0,9,NULL,NULL,93),(1222,0,9,NULL,NULL,94),(1223,0,9,NULL,NULL,95),(1224,0,9,NULL,NULL,96),(1225,0,9,NULL,NULL,97),(1226,0,9,NULL,NULL,98),(1227,0,9,NULL,NULL,99),(1228,0,9,NULL,NULL,100),(1229,0,9,NULL,NULL,101),(1230,0,9,NULL,NULL,102),(1231,0,9,NULL,NULL,103),(1232,0,9,NULL,NULL,104),(1233,0,9,NULL,NULL,105),(1234,0,9,NULL,NULL,106),(1235,0,9,NULL,NULL,107),(1236,0,9,NULL,NULL,108),(1237,0,9,NULL,NULL,109),(1238,0,9,NULL,NULL,110),(1239,0,9,NULL,NULL,111),(1240,0,9,NULL,NULL,112),(1241,0,9,NULL,NULL,113),(1242,0,9,NULL,NULL,114),(1243,0,9,NULL,NULL,115),(1244,0,9,NULL,NULL,116),(1245,0,9,NULL,NULL,117),(1246,0,9,NULL,NULL,118),(1247,0,9,NULL,NULL,119),(1248,0,9,NULL,NULL,120),(1249,0,9,NULL,NULL,121),(1250,0,9,NULL,NULL,122),(1251,0,9,NULL,NULL,123),(1252,0,9,NULL,NULL,124),(1253,0,9,NULL,NULL,125),(1254,0,9,NULL,NULL,126),(1255,0,9,NULL,NULL,127),(1256,0,9,NULL,NULL,128),(1257,0,9,NULL,NULL,129),(1258,0,9,NULL,NULL,130),(1259,0,9,NULL,NULL,131),(1260,0,9,NULL,NULL,132),(1261,0,9,NULL,NULL,133),(1262,0,9,NULL,NULL,134),(1263,0,9,NULL,NULL,135),(1264,0,9,NULL,NULL,136),(1265,0,9,NULL,NULL,137),(1266,0,9,NULL,NULL,138),(1267,0,9,NULL,NULL,139),(1268,0,9,NULL,NULL,140),(1269,0,9,NULL,NULL,141),(1270,2,10,NULL,NULL,1),(1271,0,10,NULL,NULL,2),(1272,0,10,NULL,NULL,3),(1273,0,10,NULL,NULL,4),(1274,0,10,NULL,NULL,5),(1275,0,10,NULL,NULL,6),(1276,0,10,NULL,NULL,7),(1277,0,10,NULL,NULL,8),(1278,0,10,NULL,NULL,9),(1279,2,10,NULL,NULL,10),(1280,0,10,NULL,NULL,11),(1281,0,10,NULL,NULL,12),(1282,0,10,NULL,NULL,13),(1283,0,10,NULL,NULL,14),(1284,0,10,NULL,NULL,15),(1285,0,10,NULL,NULL,16),(1286,0,10,NULL,NULL,17),(1287,0,10,NULL,NULL,18),(1288,2,10,NULL,NULL,19),(1289,2,10,NULL,NULL,20),(1290,2,10,NULL,NULL,21),(1291,2,10,NULL,NULL,22),(1292,2,10,NULL,NULL,23),(1293,2,10,NULL,NULL,24),(1294,2,10,NULL,NULL,25),(1295,2,10,NULL,NULL,26),(1296,2,10,NULL,NULL,27),(1297,0,10,NULL,NULL,28),(1298,0,10,NULL,NULL,29),(1299,0,10,NULL,NULL,30),(1300,0,10,NULL,NULL,31),(1301,0,10,NULL,NULL,32),(1302,0,10,NULL,NULL,33),(1303,0,10,NULL,NULL,34),(1304,2,10,NULL,NULL,35),(1305,0,10,NULL,NULL,36),(1306,0,10,NULL,NULL,37),(1307,0,10,NULL,NULL,38),(1308,0,10,NULL,NULL,39),(1309,0,10,NULL,NULL,40),(1310,0,10,NULL,NULL,41),(1311,0,10,NULL,NULL,42),(1312,0,10,NULL,NULL,43),(1313,2,10,NULL,NULL,44),(1314,0,10,NULL,NULL,45),(1315,0,10,NULL,NULL,46),(1316,0,10,NULL,NULL,47),(1317,0,10,NULL,NULL,48),(1318,0,10,NULL,NULL,49),(1319,0,10,NULL,NULL,50),(1320,0,10,NULL,NULL,51),(1321,0,10,NULL,NULL,52),(1322,0,10,NULL,NULL,53),(1323,2,10,NULL,NULL,54),(1324,0,10,NULL,NULL,55),(1325,0,10,NULL,NULL,56),(1326,0,10,NULL,NULL,57),(1327,0,10,NULL,NULL,58),(1328,0,10,NULL,NULL,59),(1329,0,10,NULL,NULL,60),(1330,0,10,NULL,NULL,61),(1331,0,10,NULL,NULL,62),(1332,0,10,NULL,NULL,63),(1333,0,10,NULL,NULL,64),(1334,2,10,NULL,NULL,65),(1335,0,10,NULL,NULL,66),(1336,0,10,NULL,NULL,67),(1337,0,10,NULL,NULL,68),(1338,0,10,NULL,NULL,69),(1339,0,10,NULL,NULL,70),(1340,2,10,NULL,NULL,71),(1341,0,10,NULL,NULL,72),(1342,0,10,NULL,NULL,73),(1343,0,10,NULL,NULL,74),(1344,2,10,NULL,NULL,75),(1345,0,10,NULL,NULL,76),(1346,0,10,NULL,NULL,77),(1347,0,10,NULL,NULL,78),(1348,0,10,NULL,NULL,79),(1349,0,10,NULL,NULL,80),(1350,0,10,NULL,NULL,81),(1351,0,10,NULL,NULL,82),(1352,0,10,NULL,NULL,83),(1353,0,10,NULL,NULL,84),(1354,0,10,NULL,NULL,85),(1355,2,10,NULL,NULL,86),(1356,0,10,NULL,NULL,87),(1357,0,10,NULL,NULL,88),(1358,0,10,NULL,NULL,89),(1359,0,10,NULL,NULL,90),(1360,2,10,NULL,NULL,91),(1361,2,10,NULL,NULL,92),(1362,2,10,NULL,NULL,93),(1363,0,10,NULL,NULL,94),(1364,0,10,NULL,NULL,95),(1365,0,10,NULL,NULL,96),(1366,0,10,NULL,NULL,97),(1367,0,10,NULL,NULL,98),(1368,0,10,NULL,NULL,99),(1369,0,10,NULL,NULL,100),(1370,1,10,NULL,NULL,101),(1371,1,10,NULL,NULL,102),(1372,2,10,NULL,NULL,103),(1373,1,10,NULL,NULL,104),(1374,1,10,NULL,NULL,105),(1375,1,10,NULL,NULL,106),(1376,1,10,NULL,NULL,107),(1377,1,10,NULL,NULL,108),(1378,1,10,NULL,NULL,109),(1379,1,10,NULL,NULL,110),(1380,1,10,NULL,NULL,111),(1381,1,10,NULL,NULL,112),(1382,1,10,NULL,NULL,113),(1383,1,10,NULL,NULL,114),(1384,2,10,NULL,NULL,115),(1385,1,10,NULL,NULL,116),(1386,1,10,NULL,NULL,117),(1387,1,10,NULL,NULL,118),(1388,2,10,NULL,NULL,119),(1389,2,10,NULL,NULL,120),(1390,2,10,NULL,NULL,121),(1391,2,10,NULL,NULL,122),(1392,2,10,NULL,NULL,123),(1393,0,10,NULL,NULL,124),(1394,0,10,NULL,NULL,125),(1395,2,10,NULL,NULL,126),(1396,0,10,NULL,NULL,127),(1397,0,10,NULL,NULL,128),(1398,2,10,NULL,NULL,129),(1399,2,10,NULL,NULL,130),(1400,2,10,NULL,NULL,131),(1401,2,10,NULL,NULL,132),(1402,2,10,NULL,NULL,133),(1403,0,10,NULL,NULL,134),(1404,0,10,NULL,NULL,135),(1405,0,10,NULL,NULL,136),(1406,2,10,NULL,NULL,137),(1407,2,10,NULL,NULL,138),(1408,2,10,NULL,NULL,139),(1409,2,10,NULL,NULL,140),(1410,2,10,NULL,NULL,141),(1411,1,11,NULL,NULL,1),(1412,2,11,NULL,NULL,2),(1413,1,11,NULL,NULL,3),(1414,1,11,NULL,NULL,4),(1415,2,11,NULL,NULL,5),(1416,1,11,NULL,NULL,6),(1417,1,11,NULL,NULL,7),(1418,1,11,NULL,NULL,8),(1419,2,11,NULL,NULL,9),(1420,1,11,NULL,NULL,10),(1421,2,11,NULL,NULL,11),(1422,1,11,NULL,NULL,12),(1423,1,11,NULL,NULL,13),(1424,1,11,NULL,NULL,14),(1425,1,11,NULL,NULL,15),(1426,1,11,NULL,NULL,16),(1427,2,11,NULL,NULL,17),(1428,2,11,NULL,NULL,18),(1429,2,11,NULL,NULL,19),(1430,1,11,NULL,NULL,20),(1431,1,11,NULL,NULL,21),(1432,1,11,NULL,NULL,22),(1433,2,11,NULL,NULL,23),(1434,1,11,NULL,NULL,24),(1435,2,11,NULL,NULL,25),(1436,2,11,NULL,NULL,26),(1437,1,11,NULL,NULL,27),(1438,1,11,NULL,NULL,28),(1439,1,11,NULL,NULL,29),(1440,1,11,NULL,NULL,30),(1441,1,11,NULL,NULL,31),(1442,1,11,NULL,NULL,32),(1443,1,11,NULL,NULL,33),(1444,1,11,NULL,NULL,34),(1445,1,11,NULL,NULL,35),(1446,1,11,NULL,NULL,36),(1447,1,11,NULL,NULL,37),(1448,1,11,NULL,NULL,38),(1449,1,11,NULL,NULL,39),(1450,1,11,NULL,NULL,40),(1451,1,11,NULL,NULL,41),(1452,1,11,NULL,NULL,42),(1453,1,11,NULL,NULL,43),(1454,2,11,NULL,NULL,44),(1455,0,11,NULL,NULL,45),(1456,0,11,NULL,NULL,46),(1457,0,11,NULL,NULL,47),(1458,0,11,NULL,NULL,48),(1459,0,11,NULL,NULL,49),(1460,0,11,NULL,NULL,50),(1461,0,11,NULL,NULL,51),(1462,0,11,NULL,NULL,52),(1463,0,11,NULL,NULL,53),(1464,2,11,NULL,NULL,54),(1465,0,11,NULL,NULL,55),(1466,0,11,NULL,NULL,56),(1467,0,11,NULL,NULL,57),(1468,0,11,NULL,NULL,58),(1469,0,11,NULL,NULL,59),(1470,0,11,NULL,NULL,60),(1471,0,11,NULL,NULL,61),(1472,0,11,NULL,NULL,62),(1473,0,11,NULL,NULL,63),(1474,0,11,NULL,NULL,64),(1475,2,11,NULL,NULL,65),(1476,0,11,NULL,NULL,66),(1477,0,11,NULL,NULL,67),(1478,0,11,NULL,NULL,68),(1479,0,11,NULL,NULL,69),(1480,0,11,NULL,NULL,70),(1481,2,11,NULL,NULL,71),(1482,0,11,NULL,NULL,72),(1483,0,11,NULL,NULL,73),(1484,0,11,NULL,NULL,74),(1485,2,11,NULL,NULL,75),(1486,0,11,NULL,NULL,76),(1487,0,11,NULL,NULL,77),(1488,0,11,NULL,NULL,78),(1489,0,11,NULL,NULL,79),(1490,0,11,NULL,NULL,80),(1491,0,11,NULL,NULL,81),(1492,0,11,NULL,NULL,82),(1493,0,11,NULL,NULL,83),(1494,0,11,NULL,NULL,84),(1495,0,11,NULL,NULL,85),(1496,2,11,NULL,NULL,86),(1497,0,11,NULL,NULL,87),(1498,0,11,NULL,NULL,88),(1499,0,11,NULL,NULL,89),(1500,0,11,NULL,NULL,90),(1501,2,11,NULL,NULL,91),(1502,2,11,NULL,NULL,92),(1503,2,11,NULL,NULL,93),(1504,0,11,NULL,NULL,94),(1505,0,11,NULL,NULL,95),(1506,0,11,NULL,NULL,96),(1507,0,11,NULL,NULL,97),(1508,0,11,NULL,NULL,98),(1509,0,11,NULL,NULL,99),(1510,0,11,NULL,NULL,100),(1511,2,11,NULL,NULL,101),(1512,2,11,NULL,NULL,102),(1513,2,11,NULL,NULL,103),(1514,2,11,NULL,NULL,104),(1515,2,11,NULL,NULL,105),(1516,2,11,NULL,NULL,106),(1517,2,11,NULL,NULL,107),(1518,2,11,NULL,NULL,108),(1519,2,11,NULL,NULL,109),(1520,2,11,NULL,NULL,110),(1521,2,11,NULL,NULL,111),(1522,2,11,NULL,NULL,112),(1523,2,11,NULL,NULL,113),(1524,2,11,NULL,NULL,114),(1525,2,11,NULL,NULL,115),(1526,2,11,NULL,NULL,116),(1527,2,11,NULL,NULL,117),(1528,2,11,NULL,NULL,118),(1529,2,11,NULL,NULL,119),(1530,2,11,NULL,NULL,120),(1531,2,11,NULL,NULL,121),(1532,2,11,NULL,NULL,122),(1533,2,11,NULL,NULL,123),(1534,0,11,NULL,NULL,124),(1535,0,11,NULL,NULL,125),(1536,2,11,NULL,NULL,126),(1537,0,11,NULL,NULL,127),(1538,0,11,NULL,NULL,128),(1539,2,11,NULL,NULL,129),(1540,2,11,NULL,NULL,130),(1541,2,11,NULL,NULL,131),(1542,2,11,NULL,NULL,132),(1543,2,11,NULL,NULL,133),(1544,0,11,NULL,NULL,134),(1545,0,11,NULL,NULL,135),(1546,0,11,NULL,NULL,136),(1547,2,11,NULL,NULL,137),(1548,2,11,NULL,NULL,138),(1549,2,11,NULL,NULL,139),(1550,2,11,NULL,NULL,140),(1551,2,11,NULL,NULL,141),(1552,1,12,NULL,NULL,1),(1553,2,12,NULL,NULL,2),(1554,1,12,NULL,NULL,3),(1555,1,12,NULL,NULL,4),(1556,2,12,NULL,NULL,5),(1557,1,12,NULL,NULL,6),(1558,1,12,NULL,NULL,7),(1559,1,12,NULL,NULL,8),(1560,2,12,NULL,NULL,9),(1561,1,12,NULL,NULL,10),(1562,1,12,NULL,NULL,11),(1563,2,12,NULL,NULL,12),(1564,1,12,NULL,NULL,13),(1565,1,12,NULL,NULL,14),(1566,1,12,NULL,NULL,15),(1567,1,12,NULL,NULL,16),(1568,1,12,NULL,NULL,17),(1569,2,12,NULL,NULL,18),(1570,2,12,NULL,NULL,19),(1571,1,12,NULL,NULL,20),(1572,1,12,NULL,NULL,21),(1573,1,12,NULL,NULL,22),(1574,2,12,NULL,NULL,23),(1575,1,12,NULL,NULL,24),(1576,2,12,NULL,NULL,25),(1577,2,12,NULL,NULL,26),(1578,2,12,NULL,NULL,27),(1579,0,12,NULL,NULL,28),(1580,0,12,NULL,NULL,29),(1581,0,12,NULL,NULL,30),(1582,0,12,NULL,NULL,31),(1583,0,12,NULL,NULL,32),(1584,0,12,NULL,NULL,33),(1585,0,12,NULL,NULL,34),(1586,2,12,NULL,NULL,35),(1587,0,12,NULL,NULL,36),(1588,0,12,NULL,NULL,37),(1589,0,12,NULL,NULL,38),(1590,0,12,NULL,NULL,39),(1591,0,12,NULL,NULL,40),(1592,0,12,NULL,NULL,41),(1593,0,12,NULL,NULL,42),(1594,0,12,NULL,NULL,43),(1595,2,12,NULL,NULL,44),(1596,0,12,NULL,NULL,45),(1597,0,12,NULL,NULL,46),(1598,0,12,NULL,NULL,47),(1599,0,12,NULL,NULL,48),(1600,0,12,NULL,NULL,49),(1601,0,12,NULL,NULL,50),(1602,0,12,NULL,NULL,51),(1603,0,12,NULL,NULL,52),(1604,0,12,NULL,NULL,53),(1605,2,12,NULL,NULL,54),(1606,0,12,NULL,NULL,55),(1607,0,12,NULL,NULL,56),(1608,0,12,NULL,NULL,57),(1609,0,12,NULL,NULL,58),(1610,0,12,NULL,NULL,59),(1611,0,12,NULL,NULL,60),(1612,0,12,NULL,NULL,61),(1613,0,12,NULL,NULL,62),(1614,0,12,NULL,NULL,63),(1615,0,12,NULL,NULL,64),(1616,2,12,NULL,NULL,65),(1617,0,12,NULL,NULL,66),(1618,0,12,NULL,NULL,67),(1619,0,12,NULL,NULL,68),(1620,0,12,NULL,NULL,69),(1621,0,12,NULL,NULL,70),(1622,2,12,NULL,NULL,71),(1623,0,12,NULL,NULL,72),(1624,0,12,NULL,NULL,73),(1625,0,12,NULL,NULL,74),(1626,2,12,NULL,NULL,75),(1627,0,12,NULL,NULL,76),(1628,0,12,NULL,NULL,77),(1629,0,12,NULL,NULL,78),(1630,0,12,NULL,NULL,79),(1631,0,12,NULL,NULL,80),(1632,0,12,NULL,NULL,81),(1633,0,12,NULL,NULL,82),(1634,0,12,NULL,NULL,83),(1635,0,12,NULL,NULL,84),(1636,0,12,NULL,NULL,85),(1637,2,12,NULL,NULL,86),(1638,0,12,NULL,NULL,87),(1639,0,12,NULL,NULL,88),(1640,0,12,NULL,NULL,89),(1641,0,12,NULL,NULL,90),(1642,2,12,NULL,NULL,91),(1643,2,12,NULL,NULL,92),(1644,2,12,NULL,NULL,93),(1645,0,12,NULL,NULL,94),(1646,0,12,NULL,NULL,95),(1647,0,12,NULL,NULL,96),(1648,0,12,NULL,NULL,97),(1649,0,12,NULL,NULL,98),(1650,0,12,NULL,NULL,99),(1651,0,12,NULL,NULL,100),(1652,2,12,NULL,NULL,101),(1653,2,12,NULL,NULL,102),(1654,2,12,NULL,NULL,103),(1655,2,12,NULL,NULL,104),(1656,2,12,NULL,NULL,105),(1657,2,12,NULL,NULL,106),(1658,2,12,NULL,NULL,107),(1659,2,12,NULL,NULL,108),(1660,2,12,NULL,NULL,109),(1661,2,12,NULL,NULL,110),(1662,2,12,NULL,NULL,111),(1663,2,12,NULL,NULL,112),(1664,2,12,NULL,NULL,113),(1665,2,12,NULL,NULL,114),(1666,2,12,NULL,NULL,115),(1667,2,12,NULL,NULL,116),(1668,2,12,NULL,NULL,117),(1669,2,12,NULL,NULL,118),(1670,2,12,NULL,NULL,119),(1671,2,12,NULL,NULL,120),(1672,2,12,NULL,NULL,121),(1673,2,12,NULL,NULL,122),(1674,2,12,NULL,NULL,123),(1675,0,12,NULL,NULL,124),(1676,0,12,NULL,NULL,125),(1677,2,12,NULL,NULL,126),(1678,0,12,NULL,NULL,127),(1679,0,12,NULL,NULL,128),(1680,2,12,NULL,NULL,129),(1681,2,12,NULL,NULL,130),(1682,2,12,NULL,NULL,131),(1683,2,12,NULL,NULL,132),(1684,2,12,NULL,NULL,133),(1685,0,12,NULL,NULL,134),(1686,0,12,NULL,NULL,135),(1687,0,12,NULL,NULL,136),(1688,2,12,NULL,NULL,137),(1689,2,12,NULL,NULL,138),(1690,2,12,NULL,NULL,139),(1691,2,12,NULL,NULL,140),(1692,2,12,NULL,NULL,141),(1693,1,13,NULL,NULL,1),(1694,1,13,NULL,NULL,2),(1695,1,13,NULL,NULL,3),(1696,1,13,NULL,NULL,4),(1697,1,13,NULL,NULL,5),(1698,1,13,NULL,NULL,6),(1699,1,13,NULL,NULL,7),(1700,1,13,NULL,NULL,8),(1701,2,13,NULL,NULL,9),(1702,1,13,NULL,NULL,10),(1703,1,13,NULL,NULL,11),(1704,1,13,NULL,NULL,12),(1705,2,13,NULL,NULL,13),(1706,2,13,NULL,NULL,14),(1707,1,13,NULL,NULL,15),(1708,1,13,NULL,NULL,16),(1709,2,13,NULL,NULL,17),(1710,1,13,NULL,NULL,18),(1711,1,13,NULL,NULL,19),(1712,2,13,NULL,NULL,20),(1713,1,13,NULL,NULL,21),(1714,1,13,NULL,NULL,22),(1715,2,13,NULL,NULL,23),(1716,1,13,NULL,NULL,24),(1717,1,13,NULL,NULL,25),(1718,2,13,NULL,NULL,26),(1719,2,13,NULL,NULL,27),(1720,0,13,NULL,NULL,28),(1721,0,13,NULL,NULL,29),(1722,0,13,NULL,NULL,30),(1723,0,13,NULL,NULL,31),(1724,0,13,NULL,NULL,32),(1725,0,13,NULL,NULL,33),(1726,0,13,NULL,NULL,34),(1727,2,13,NULL,NULL,35),(1728,0,13,NULL,NULL,36),(1729,0,13,NULL,NULL,37),(1730,0,13,NULL,NULL,38),(1731,0,13,NULL,NULL,39),(1732,0,13,NULL,NULL,40),(1733,0,13,NULL,NULL,41),(1734,0,13,NULL,NULL,42),(1735,0,13,NULL,NULL,43),(1736,2,13,NULL,NULL,44),(1737,0,13,NULL,NULL,45),(1738,0,13,NULL,NULL,46),(1739,0,13,NULL,NULL,47),(1740,0,13,NULL,NULL,48),(1741,0,13,NULL,NULL,49),(1742,0,13,NULL,NULL,50),(1743,0,13,NULL,NULL,51),(1744,0,13,NULL,NULL,52),(1745,0,13,NULL,NULL,53),(1746,2,13,NULL,NULL,54),(1747,0,13,NULL,NULL,55),(1748,0,13,NULL,NULL,56),(1749,0,13,NULL,NULL,57),(1750,0,13,NULL,NULL,58),(1751,0,13,NULL,NULL,59),(1752,0,13,NULL,NULL,60),(1753,0,13,NULL,NULL,61),(1754,0,13,NULL,NULL,62),(1755,0,13,NULL,NULL,63),(1756,0,13,NULL,NULL,64),(1757,2,13,NULL,NULL,65),(1758,0,13,NULL,NULL,66),(1759,0,13,NULL,NULL,67),(1760,0,13,NULL,NULL,68),(1761,0,13,NULL,NULL,69),(1762,0,13,NULL,NULL,70),(1763,2,13,NULL,NULL,71),(1764,0,13,NULL,NULL,72),(1765,0,13,NULL,NULL,73),(1766,0,13,NULL,NULL,74),(1767,2,13,NULL,NULL,75),(1768,0,13,NULL,NULL,76),(1769,0,13,NULL,NULL,77),(1770,0,13,NULL,NULL,78),(1771,0,13,NULL,NULL,79),(1772,0,13,NULL,NULL,80),(1773,0,13,NULL,NULL,81),(1774,0,13,NULL,NULL,82),(1775,0,13,NULL,NULL,83),(1776,0,13,NULL,NULL,84),(1777,0,13,NULL,NULL,85),(1778,2,13,NULL,NULL,86),(1779,0,13,NULL,NULL,87),(1780,0,13,NULL,NULL,88),(1781,0,13,NULL,NULL,89),(1782,0,13,NULL,NULL,90),(1783,2,13,NULL,NULL,91),(1784,2,13,NULL,NULL,92),(1785,2,13,NULL,NULL,93),(1786,0,13,NULL,NULL,94),(1787,0,13,NULL,NULL,95),(1788,0,13,NULL,NULL,96),(1789,0,13,NULL,NULL,97),(1790,0,13,NULL,NULL,98),(1791,0,13,NULL,NULL,99),(1792,0,13,NULL,NULL,100),(1793,2,13,NULL,NULL,101),(1794,1,13,NULL,NULL,102),(1795,1,13,NULL,NULL,103),(1796,1,13,NULL,NULL,104),(1797,1,13,NULL,NULL,105),(1798,1,13,NULL,NULL,106),(1799,1,13,NULL,NULL,107),(1800,1,13,NULL,NULL,108),(1801,1,13,NULL,NULL,109),(1802,1,13,NULL,NULL,110),(1803,1,13,NULL,NULL,111),(1804,1,13,NULL,NULL,112),(1805,1,13,NULL,NULL,113),(1806,1,13,NULL,NULL,114),(1807,1,13,NULL,NULL,115),(1808,1,13,NULL,NULL,116),(1809,1,13,NULL,NULL,117),(1810,1,13,NULL,NULL,118),(1811,1,13,NULL,NULL,119),(1812,2,13,NULL,NULL,120),(1813,1,13,NULL,NULL,121),(1814,2,13,NULL,NULL,122),(1815,2,13,NULL,NULL,123),(1816,0,13,NULL,NULL,124),(1817,0,13,NULL,NULL,125),(1818,2,13,NULL,NULL,126),(1819,0,13,NULL,NULL,127),(1820,0,13,NULL,NULL,128),(1821,1,13,NULL,NULL,129),(1822,1,13,NULL,NULL,130),(1823,1,13,NULL,NULL,131),(1824,1,13,NULL,NULL,132),(1825,2,13,NULL,NULL,133),(1826,0,13,NULL,NULL,134),(1827,0,13,NULL,NULL,135),(1828,0,13,NULL,NULL,136),(1829,1,13,NULL,NULL,137),(1830,1,13,NULL,NULL,138),(1831,1,13,NULL,NULL,139),(1832,2,13,NULL,NULL,140),(1833,2,13,NULL,NULL,141);
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'Usuario'),(2,'Administrador'),(3,'Evaluador');
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
  `AssessmentId` int(11) NOT NULL DEFAULT '1',
  `Peso` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`Id`),
  KEY `IX_Sections_AssessmentId` (`AssessmentId`),
  CONSTRAINT `FK_Sections_Assessment_AssessmentId` FOREIGN KEY (`AssessmentId`) REFERENCES `assessment` (`AssessmentId`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sections`
--

LOCK TABLES `sections` WRITE;
/*!40000 ALTER TABLE `sections` DISABLE KEYS */;
INSERT INTO `sections` VALUES (1,'EQUIPO',1,20),(2,'EVENTOS',1,20),(3,' HERRAMIENTAS ',1,20),(4,'MINDSET',1,10),(5,'APLICACIÓN PRÁCTICA',1,30);
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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `userproyectos`
--

LOCK TABLES `userproyectos` WRITE;
/*!40000 ALTER TABLE `userproyectos` DISABLE KEYS */;
INSERT INTO `userproyectos` VALUES (1,'Admin',1),(2,'Admin',2),(3,'Admin',3),(4,'User',1),(5,'jherrric',5),(6,'mcampong',6);
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
INSERT INTO `users` VALUES ('Admin','c1c224b03cd9bc7b6a86d77f5dace40191766c485cd55dc48caf9ac873335d6f',2),('jherrric','default-password',1),('mcampong','default-password',1),('Test','532eaabd9574880dbf76b9b8cc00832c20a6ec113d682299550d7a6e0f345e25',1),('User','b512d97e7cbf97c273e4db073bbb547aa65a84589227f8f3d9e4a72b9372a24d',1);
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

-- Dump completed on 2019-01-15  8:56:07
