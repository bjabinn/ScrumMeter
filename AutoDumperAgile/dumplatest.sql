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
INSERT INTO `__efmigrationshistory` VALUES ('20181023105227_AddUserProyecto','2.0.2-rtm-10011'),('20181025094247_RemoveUserRoles','2.0.2-rtm-10011'),('20181026062550_AddAssessments','2.0.2-rtm-10011'),('20181029085809_LinkAssessmentWithSections','2.0.2-rtm-10011'),('20181029103724_LinkEvaluationsWithAssessments','2.0.2-rtm-10011'),('20181113120302_AddUserNameToEvaluation','2.0.2-rtm-10011'),('20181203104813_TestProyects','2.0.2-rtm-10011'),('20181217133407_AñadirPesosASecciones','2.0.2-rtm-10011'),('20181218081534_PreguntaHabilitante','2.0.2-rtm-10011'),('20190108132133_AddLastQuestionUpdate','2.0.2-rtm-10011'),('20190109093506_PesoIntToFloat','2.0.2-rtm-10011');
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
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `asignaciones`
--

LOCK TABLES `asignaciones` WRITE;
/*!40000 ALTER TABLE `asignaciones` DISABLE KEYS */;
INSERT INTO `asignaciones` VALUES (1,'Product Owner',0,1),(2,'Scrum Master',0,1),(3,'Equipo Desarrollo',0,1),(4,'Daily Scrum',0,2),(5,'Retrospective',0,2),(6,'Sprint Review',0,2),(7,'Sprint Planning',0,2),(8,'Refinement',0,2),(9,'Sprint',0,2),(10,'Product Backlog',0,3),(11,'Sprint Backlog',0,3),(12,'Incremento',0,3),(13,'Cultura',0,4),(14,'Disciplina',0,4),(15,'Mejora Continua',0,4),(16,'Métricas',0,5),(17,'Implementación',0,5),(18,'Objetivos',0,5),(19,'Daily-KB',5,6),(20,'Retrospective-KB',30,6),(21,'Sprint Review-KB',20,6),(22,'Sprint Planning-KB',15,6),(23,'Refinement-KB',10,6),(24,'Product Owner-KB',20,7),(25,'Scrum Master',60,7),(26,'Equipo Desarrollo',20,7);
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
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
) ENGINE=InnoDB AUTO_INCREMENT=157 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `evaluaciones`
--

LOCK TABLES `evaluaciones` WRITE;
/*!40000 ALTER TABLE `evaluaciones` DISABLE KEYS */;
INSERT INTO `evaluaciones` VALUES (1,'\0','2018-10-23 12:06:07',NULL,NULL,2,0,1,NULL,NULL),(2,'','2018-10-06 00:00:00','i','ggg',1,59.5,1,NULL,NULL),(3,'','2018-10-24 14:53:29','test','irh',1,2.8,1,NULL,NULL),(145,'\0','2019-01-08 14:25:42',NULL,NULL,6,0,2,'mcampong',149),(146,'\0','2019-01-08 15:04:13',NULL,NULL,6,0,1,'mcampong',30),(147,'\0','2019-01-08 15:10:43',NULL,NULL,6,0,1,'mcampong',47),(154,'\0','2019-01-09 10:43:07',NULL,NULL,5,0,1,'jherrric',9),(155,'','2019-01-09 10:43:32',NULL,NULL,5,0,1,'jherrric',141),(156,'','2019-01-09 10:45:12',NULL,NULL,5,0,1,'jherrric',141);
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
  `Pregunta` varchar(500) NOT NULL,
  `Peso` float NOT NULL,
  `EsHabilitante` bit(1) NOT NULL DEFAULT b'0',
  `PreguntaHabilitanteId` int(11) DEFAULT NULL,
  PRIMARY KEY (`Id`),
  KEY `IX_Preguntas_AsignacionId` (`AsignacionId`),
  KEY `IX_Preguntas_PreguntaHabilitanteId` (`PreguntaHabilitanteId`),
  CONSTRAINT `FK_Preguntas_Asignaciones_AsignacionId` FOREIGN KEY (`AsignacionId`) REFERENCES `asignaciones` (`Id`) ON DELETE CASCADE,
  CONSTRAINT `FK_Preguntas_Preguntas_PreguntaHabilitanteId` FOREIGN KEY (`PreguntaHabilitanteId`) REFERENCES `preguntas` (`Id`) ON DELETE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=211 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `preguntas`
--

LOCK TABLES `preguntas` WRITE;
/*!40000 ALTER TABLE `preguntas` DISABLE KEYS */;
INSERT INTO `preguntas` VALUES (1,1,'Si','¿Existe el rol de Product Owner en el equipo?',0,'',NULL),(2,1,'Si','¿El Product Owner tiene poder para priorizar los elementos del Product Backlog?',0.902256,'\0',1),(3,1,'Si','¿El Product Owner tiene el conocimiento suficiente para priorizar?',0.545455,'\0',1),(4,1,'Si','¿El Product Owner tiene contacto directo con el equipo de desarrollo?',0.461538,'\0',1),(5,1,'Si','¿El Product Owner tiene contacto directo con los interesados?',0.0601504,'\0',1),(6,1,'Si','¿El Product Owner tiene voz única (Si hay más de un Product Owner, solo hay una opinión)?',0.454545,'\0',1),(7,1,'Si','¿El Product Owner tiene la visión del producto?',0.461538,'\0',1),(8,1,'No','¿El Product Owner hace otras labores (codificar por ejemplo)?',0.037594,'\0',1),(9,1,'No','¿El Product Owner toma decisiones técnicas?',0.0769231,'\0',1),(10,2,'Si','¿Existe el rol de Scrum Master en el equipo?',0,'',NULL),(11,2,'Si','¿El Scrum Master se enfoca en la resolución de impedimentos?',0.483871,'\0',10),(12,2,'Si','¿El Scrum Master escala los impedimentos?',0.307692,'\0',10),(13,2,'No','¿El Scrum Master hace otras labores (codificar/analizar por ejemplo)?',0.0769231,'\0',10),(14,2,'No','¿El Scrum Master toma decisiones técnicas o de negocio?',0.153846,'\0',10),(15,2,'Si','¿El Scrum Master ayuda/guía al Product Owner para realizar correctamente su trabajo?',0.516129,'\0',10),(16,2,'Si','¿El Scrum Master empodera al equipo?',0.857143,'\0',10),(17,2,'No','¿El Scrum Master asume la responsabilidad si el equipo falla? ',0.142857,'\0',10),(18,2,'Si','¿El Scrum Master permite que el equipo experimente y se equivoque?',0.461538,'\0',10),(19,3,'Si','¿El equipo de desarrollo tiene todas las competencias necesarias?',0.75,'\0',NULL),(20,3,'No','¿Existen miembros del equipo de desarrollo encasillados, no conociendo absolutamente nada de otras áreas?',0.0625,'\0',NULL),(21,3,'Si','¿Los miembros del equipo de desarrollo interactúan juntos en el desarrrollo de la solución?',0.384615,'\0',NULL),(22,3,'Si','¿Hay como máximo 9 personas en el equipo de desarrollo?',0.461538,'\0',NULL),(23,3,'No','¿Hay algún miembro del equipo de desarrollo que no esté alineado con Scrum?',0.153846,'\0',NULL),(24,3,'Si','¿Tiene el equipo de desarrollo un drag factor interiorizado, planificado y consensuado con los stakeholders?',0.142857,'\0',NULL),(25,3,'Si','¿El equipo de desarrollo usa o dispone de herramientas para organizar sus tareas?',0.1875,'\0',NULL),(26,3,'No','¿El equipo de desarrollo tiene dependencias no resueltas?',0.857143,'\0',NULL),(27,4,'Si','¿Se realiza la Daily Scrum?',0,'',NULL),(28,4,'Si','¿Solo interviene el equipo de desarrollo?',0.666667,'\0',27),(29,4,'Si','¿Se emplean como máximo 15 min?',0.133333,'\0',27),(30,4,'Si','¿Se mencionan los problemas e impedimentos?',0.727273,'\0',27),(31,4,'Si','¿Se revisan los objetivos del Sprint?',1,'\0',27),(32,4,'Si','¿Se realiza siempre a la misma hora y lugar?',0.2,'\0',27),(33,4,'No','¿Interviene gente que no pertenece al equipo Scrum?',0.0909091,'\0',27),(34,4,'No','¿Se discute sobre soluciones técnicas durante la Daily Scrum?',0.181818,'\0',27),(35,5,'Si','¿Se realiza la Retrospective al final de cada sprint?',0,'',NULL),(36,5,'Si','¿Hay alguien que haga de facilitador?',0.333333,'\0',35),(37,5,'Si','¿El equipo Scrum al completo participa?',0.193548,'\0',35),(38,5,'Si','¿Se analizan los problemas en profundidad?',0.333333,'\0',35),(39,5,'Si','¿Se proponen soluciones a los problemas detectados?',0.774194,'\0',35),(40,5,'No','¿Participa gente que no pertenece al equipo?',0.0322581,'\0',35),(41,5,'Si','¿Todo el equipo expresa su punto de vista?',0.75,'\0',35),(42,5,'Si','¿Se analizan las métricas y su impacto durante la retro?',0.25,'\0',35),(43,5,'Si','¿Se hace seguimiento a las acciones de las Retrospectives anteriores?',0.333333,'\0',35),(44,6,'Si','¿Se realiza la Sprint Review al final de cada sprint?',0,'',NULL),(45,6,'Si','¿Se muestra software funcionando y probado?',0.75,'\0',44),(46,6,'Si','¿Se recibe feedback de interesados y Product Owner?',0.352941,'\0',44),(47,6,'No','¿Se mencionan los items inacabados?',0.0625,'\0',44),(48,6,'Si','¿Se revisa si se ha alcanzado el objetivo del Sprint?',0.470588,'\0',44),(49,6,'No','¿Se muestran los items desarrollados pero no probados?',0.0588235,'\0',44),(50,6,'Si','¿Se invitan a los stakeholders a que participen?',0.2,'\0',44),(51,6,'Si','¿Se revisa lo que vamos a incluir en el siguiente sprint?',0.8,'\0',44),(52,6,'Si','¿Participa todo el equipo Scrum?',0.1875,'\0',44),(53,6,'Si','¿Es el equipo de desarrollo el que enseña el incremento?',0.117647,'\0',44),(54,7,'Si','¿Se realiza Sprint Planning por cada Sprint?',0,'',NULL),(55,7,'Si','¿El Product Owner está disponible para dudas?',0.269461,'\0',54),(56,7,'Si','¿El equipo de desarrollo completo participa?',0.359281,'\0',54),(57,7,'Si','¿El resultado de la sesión es el plan del Sprint?',0.0598802,'\0',54),(58,7,'Si','¿El equipo completo cree que el plan es alcanzable?',0.5,'\0',54),(59,7,'Si','¿Se llega a un consenso entre el Product Owner y el equipo de desarrollo en el alcance del Sprint Backlog?',0.384615,'\0',54),(60,7,'Si','¿Los Product Backlog Items se dividen en tareas?',0.143713,'\0',54),(61,7,'Si','¿Los Product Backlog Items son estimados?',0.107784,'\0',54),(62,7,'Si','¿Se adquiere un compromiso por parte del equipo de desarrollo?',0.5,'\0',54),(63,7,'Si','¿Se analizan las dependencias que pueden surgir entre los Product Backlog Items?',0.615385,'\0',54),(64,7,'No','¿Participa el Product Owner/Scrum Master en las estimaciones de los Product Backlog Items?',0.0598802,'\0',54),(65,8,'Si','¿Se realiza Refinement?',0,'',NULL),(66,8,'Si','¿Es el Product Owner quien solicita hacer una refinement?',0.769231,'\0',65),(67,8,'Si','¿El Product Owner lleva las User Stories definidas para discutirlas?',0.833333,'\0',65),(68,8,'No','¿Se dedica más del 10 % de la capacidad del equipo desarrollo?',1,'\0',65),(69,8,'Si','¿Se tratan los Product Backlog Items que son más prioritarios del Product Backlog?',0.230769,'\0',65),(70,8,'Si','¿Participan los perfiles necesarios en la Refinement?',0.166667,'\0',65),(71,9,'Si','¿Las iteraciones siempre duran lo mismo?',0,'',NULL),(72,9,'Si','¿La duración de las iteraciones es menor a un mes?',1,'\0',71),(73,9,'No','¿El equipo varia durante el Sprint?',0.310345,'\0',71),(74,9,'No','¿Se continua el sprint aunque no tenga sentido el objetivo a alcanzar?',0.689655,'\0',71),(75,10,'Si','¿Existe PB?',0,'',NULL),(76,10,'Si','¿EL PB refleja la visión del producto?',0.235294,'\0',75),(77,10,'Si','¿El PB es visible para todos los miembros del equipo?',0.470588,'\0',75),(78,10,'Si','¿Los PBIs se priorizan por su valor de negocio?',0.870968,'\0',75),(79,10,'Si','¿El alcance de los PBIs más prioritarios está suficientemente claro como para incluirlos en un Sprint?',0.196078,'\0',75),(80,10,'No','¿Es el alcance de los PBIs inmodificable?',0.411765,'\0',75),(81,10,'Si','¿Los PBI son tan pequeños como para abordarse en un Sprint?',0.129032,'\0',75),(82,10,'Si','¿El Equipo Scrum entiende el propósito de todos los PBIs?',0.0653595,'\0',75),(83,10,'Si','¿El equipo de desarrollo influye en la priorización del PB?',0.196078,'\0',75),(84,10,'Si','¿El PB incluye algunas de las acciones elegidas en la Retrospectiva?',0.392157,'\0',75),(85,10,'Si','¿Se refinan los PBIs antes de llegar a un Sprint Planning?',0.0326797,'\0',75),(86,11,'Si','¿Existe SB?',0,'',NULL),(87,11,'Si','¿El SB refleja el compromiso para el Sprint?',0.583333,'\0',86),(88,11,'Si','¿El SB es visible para todos los miembros del equipo?',0.416667,'\0',86),(89,11,'Si','¿El SB se revisa diariamente?',1,'\0',86),(90,11,'No','¿El PO ordena la prioridad de los items en el SB?',1,'\0',86),(91,12,'Si','¿El incremento tiene calidad para subirse a producción si el negocio así lo pidiera en cualquier momento?',0.594452,'\0',NULL),(92,12,'No','¿Al finalizar el Sprint el incremento resultante siempre se sube a producción?',0.142668,'\0',NULL),(93,12,'Si','¿Existe DoD?',0,'',NULL),(94,12,'Si','¿El DoD incluye los criterios de aceptación de los PBIs?',0.545455,'\0',93),(95,12,'Si','¿El DoD incluye los requisitos no funcionales?',0.0845443,'\0',93),(96,12,'Si','¿El DoD es consistente con un incremento del producto potencialmente entregable?',0.681818,'\0',93),(97,12,'Si','¿El equipo entiende el DoD?',0.454545,'\0',93),(98,12,'No','¿El DoD es creado sólo por el equipo de desarrollo?',0.0198151,'\0',93),(99,12,'Si','¿Se revisa el DoD para que sea consistente con el propio producto?',0.318182,'\0',93),(100,12,'Si','¿Tanto PO como equipo están de acuerdo con el DoD?',0.15852,'\0',93),(101,13,'Si','¿El equipo cumple con el compromiso adquirido?',0.25,'\0',NULL),(102,13,'Si','¿Los líderes o managers de la organización conocen y comparten los principios ágiles?',0.75,'\0',NULL),(103,13,'Si','¿El SM asesora/guía en Scrum al resto de la organización?',0.806452,'\0',NULL),(104,13,'No','¿El equipo se resiste a la transformación digital?',0.193548,'\0',NULL),(105,13,'Si','¿El equipo participa de las decisiones sobre las propuestas de nuevos proyectos o servicios?',0.222222,'\0',NULL),(106,13,'Si','¿El equipo está involucrado en el proceso de incorporación o salida de los miembros del propio equipo?',0.333333,'\0',NULL),(107,13,'Si','¿El equipo participa de la transformación de su área?',0.444444,'\0',NULL),(108,14,'No','¿El equipo es interrumpido frecuentemente durante el Sprint para otras necesidades diferentes al objetivo de propio Sprint?',0.3,'\0',NULL),(109,14,'No','¿Se realizan reuniones adicionales que estén fuera del framework de Scrum?',0.3,'\0',NULL),(110,14,'Si','¿Se respetan los timeboxes de las reuniones?',0.75,'\0',NULL),(111,14,'Si','¿Los miembros del equipo convocados a una reunión están presentes al inicio de la misma?',0.25,'\0',NULL),(112,14,'No','¿Se desvían las reuniones de sus objetivos?',0.4,'\0',NULL),(113,14,'Si','¿Se respetan las decisiones del equipo que solo afectan al equipo?',1,'\0',NULL),(114,15,'Si','¿El equipo practica la mejora continua y evoluciona su forma de trabajo?',0.464789,'\0',NULL),(115,15,'No','¿Se buscan culpables de las malas decisiones del equipo?',0.28169,'\0',NULL),(116,15,'Si','¿Existe un ambiente de confianza donde el equipo pueda expresar abiertamente su opinión, cómo se encuentra ...?',1,'\0',NULL),(117,15,'Si','¿El equipo dispone de espacio/tiempo para dedicar a la mejora continua?',0.253521,'\0',NULL),(118,15,'No','¿Existen agentes externos que interfieren en la toma de decisiones del equipo?',1,'\0',NULL),(119,16,'No','¿El equipo estima los PBIs en horas?',0.5,'\0',NULL),(120,16,'Si','¿El equipo usa patrones para estimar?',0.5,'\0',NULL),(121,16,'Si','¿Estos patrones se revisan por el equipo?',0.285714,'\0',NULL),(122,16,'Si','¿El equipo utiliza estos pratones para estimar las propuestas de nuevos proyectos?',0.125,'\0',NULL),(123,16,'Si','¿El equipo conoce su velocidad?',0,'',NULL),(124,16,'No','¿Para el cálculo de la velocidad el equipo tiene en cuenta los items no completados?',0.285714,'\0',123),(125,16,'Si','¿El equipo tiene en cuenta su velocidad para establecer el compromiso en una nueva iteración?',0.75,'\0',123),(126,16,'Si','¿El equipo usa el Burndown Chart para visualizar su progreso durante el Sprint?',0,'',NULL),(127,16,'Si','¿El Burndown Chart es visible para todos los miembros del equipo?',0.428571,'\0',126),(128,16,'Si','¿El equipo actualiza su Burndown Chart diariamente?',0.125,'\0',126),(129,17,'Si','¿Tiene el equipo la visión global del proyecto?',0.689655,'\0',NULL),(130,17,'Si','¿Cuenta el equipo con el espacio adecuado para su desempeño?',0.444444,'\0',NULL),(131,17,'Si','¿Utiliza el equipo un panel físico?',0.473684,'\0',NULL),(132,17,'Si','¿Utiliza el equipo un panel digital?',0.526316,'\0',NULL),(133,17,'Si','¿Está todo el equipo deslocalizado?',0,'',NULL),(134,17,'Si','¿El equipo utiliza sistemas de videoconferencia para sus reuniones?',0.444444,'\0',133),(135,17,'Si','¿Cuenta el equipo con un espacio colaborativo para la gestión de la información?',0.111111,'\0',133),(136,17,'Si','¿Aplican alguna técnica específica para colaborar durante los eventos de manera remota?',1,'\0',133),(137,18,'Si','¿El equipo ha definido su misión?',0.444444,'\0',NULL),(138,18,'Si','¿El equipo ha definido su visión?',0.555556,'\0',NULL),(139,18,'Si','¿El equipo ha definido sus valores?',0.473684,'\0',NULL),(140,18,'Si','¿Están alineados éstos con la proyección profesional de sus miembros?',0.526316,'\0',NULL),(141,18,'Si','¿El equipo conoce lo que la organización espera de él?',1,'\0',NULL),(142,19,'null','¿Se realiza la daily en Kanban?',0,'\0',NULL),(143,19,'Si','¿El equipo completo participa?',0,'\0',NULL),(144,19,'Si','¿Se emplean como máximo 15 min?',0,'\0',NULL),(145,19,'Si','¿Se mencionan los problemas e impedimentos?',0,'\0',NULL),(146,19,'Si','¿Se revisan en cada daily los objetivos del Sprint?',0,'\0',NULL),(147,19,'Si','¿Se realiza siempre a la misma hora y lugar?',0,'\0',NULL),(148,19,'No','¿Participa gente que no pertenece al equipo?',0,'\0',NULL),(149,20,'null','¿Se realiza la Retrospective al final de cada sprint?',0,'\0',NULL),(150,20,'Si','¿Se plantean propuestas SMART?',0,'\0',NULL),(151,20,'Si','¿Se implementan las propuestas?',0,'\0',NULL),(152,20,'Si','¿Equipo al completo más PO participan?',0,'\0',NULL),(153,20,'Si','¿Se analizan los problemas en profundidad?',0,'\0',NULL),(154,20,'No','¿Participa gente que no pertenece al equipo?',0,'\0',NULL),(155,20,'Si','¿Todo el equipo expresa su punto de vista?',0,'\0',NULL),(156,20,'Si','¿Se analizan las métricas y su impacto durante la retro?',0,'\0',NULL),(157,21,'null','¿Se realiza la Sprint Review al final de cada sprint?',0,'\0',NULL),(158,21,'Si','¿Se muestra software funcionando y probado?',0,'\0',NULL),(159,21,'Si','¿Se recibe feedback de interesados y PO?',0,'\0',NULL),(160,21,'No','¿Se mencionan los items inacabados?',0,'\0',NULL),(161,21,'Si','¿Se revisa si se ha alcanzado el objetivo del Sprint?',0,'\0',NULL),(162,21,'No','¿Se muestran los items acabados al 99%?',0,'\0',NULL),(163,22,'null','¿Se realiza Sprint Planning por cada Sprint?',0,'\0',NULL),(164,22,'Si','¿El PO está disponible para dudas?',0,'\0',NULL),(165,22,'Si','¿Está el PB preparado para el Sprint Planning?',0,'\0',NULL),(166,22,'Si','¿El equipo completo participa?',0,'\0',NULL),(167,22,'Si','¿El resultado de la sesión es el plan del Sprint?',0,'\0',NULL),(168,22,'Si','¿El equipo completo cree que el plan es alcanzable?',0,'\0',NULL),(169,22,'Si','¿El PO queda satisfecho con las prioridades?',0,'\0',NULL),(170,22,'Si','¿Los PBI se dividen en tareas?',0,'\0',NULL),(171,22,'Si','¿Las tareas son estimadas?',0,'\0',NULL),(172,22,'Si','¿Se adquiere un compromiso por parte del equipo?',0,'\0',NULL),(173,23,'null','¿Se realiza Refinement?',0,'\0',NULL),(174,23,'Si','¿Es el PO quien decide cuando se hace un refinement?',0,'\0',NULL),(175,23,'Si','¿El PO lleva las US definidas para discutir?',0,'\0',NULL),(176,23,'Si','¿Se estima en tamaño relativo?',0,'\0',NULL),(177,23,'Si','¿Existe DoR?',0,'\0',NULL),(178,23,'Si','¿Se aplica DoR?',0,'\0',NULL),(179,23,'Si','¿Se realizan preguntas y propuestas?',0,'\0',NULL),(180,23,'Si','¿Participa todo el equipo?',0,'\0',NULL),(181,23,'No','¿Participa en la estimación personas ajenas al equipo?',0,'\0',NULL),(182,24,'null','¿Existe el rol de PO en el equipo?',0,'\0',NULL),(183,24,'Si','¿El PO tiene poder para priorizar los elementos del PB?',0,'\0',NULL),(184,24,'Si','¿El PO tiene el conocimiento suficiente para priorizar?',0,'\0',NULL),(185,24,'Si','¿El PO tiene contacto directo con el equipo?',0,'\0',NULL),(186,24,'Si','¿El PO tiene contacto directo con los interesados?',0,'\0',NULL),(187,24,'Si','¿El PO tiene voz única (Si es equipo, solo hay una opinión)?',0,'\0',NULL),(188,24,'Si','¿El PO tiene la visión del producto?',0,'\0',NULL),(189,24,'No','¿El PO hace otras labores (codificar por ejemplo)?',0,'\0',NULL),(190,24,'No','¿El PO toma decisiones técnicas?',0,'\0',NULL),(191,25,'null','¿Existe el rol de SM en el equipo?',0,'\0',NULL),(192,25,'Si','¿El SM se sienta con el equipo?',0,'\0',NULL),(193,25,'Si','¿El SM se enfoca en la resolución de impedimentos?',0,'\0',NULL),(194,25,'Si','¿El SM escala los impedimentos?',0,'\0',NULL),(195,25,'No','¿El SM hace otras labores (codificar/analizar por ejemplo)?',0,'\0',NULL),(196,25,'No','¿El SM toma decisiones técnicas o de negocio?',0,'\0',NULL),(197,25,'Si','¿El SM ayuda/guía al PO para realizar correctamente su trabajo?',0,'\0',NULL),(198,25,'Si','¿El SM empodera al equipo?',0,'\0',NULL),(199,25,'No','¿El SM asume la responsabilidad si el equipo falla?',0,'\0',NULL),(200,25,'Si','¿El SM permite que el equipo experimente y se equivoque?',0,'\0',NULL),(201,25,'Si','¿Los líderes o managers de la organización conocen y/o comparten los principios ágiles?',0,'\0',NULL),(202,26,'Si','¿El equipo tiene todas las habilidades necesarias?',0,'\0',NULL),(203,26,'Si','¿Existen miembros del equipo encasillados, no conociendo absolutamente nada de otras áreas?',0,'\0',NULL),(204,26,'Si','¿Los miembros del equipo se sientan juntos?',0,'\0',NULL),(205,26,'Si','¿Hay com máximo 9 personas por equipo?',0,'\0',NULL),(206,26,'No','¿Hay algún miembro del equipo que odie Scrum?',0,'\0',NULL),(207,26,'No','¿Hay algún miembro del equipo profundamente desmotivado?',0,'\0',NULL),(208,26,'Si','¿Tiene el equipo un drag factor interiorizado, planificado y consensuado con los stakeholders?',0,'\0',NULL),(209,26,'No','¿Se realizan reuniones adicionales que estén fuera del framework de Scrum?',0,'\0',NULL),(210,26,'Si','¿El equipo usa o dispone de herramientas para organizar sus tareas?',0,'\0',NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=32308 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `respuestas`
--

LOCK TABLES `respuestas` WRITE;
/*!40000 ALTER TABLE `respuestas` DISABLE KEYS */;
INSERT INTO `respuestas` VALUES (29788,0,145,NULL,NULL,1),(29789,0,145,NULL,NULL,2),(29790,0,145,NULL,NULL,3),(29791,0,145,NULL,NULL,4),(29792,0,145,NULL,NULL,5),(29793,0,145,NULL,NULL,6),(29794,0,145,NULL,NULL,7),(29795,0,145,NULL,NULL,8),(29796,0,145,NULL,NULL,9),(29797,0,145,NULL,NULL,10),(29798,0,145,NULL,NULL,11),(29799,0,145,NULL,NULL,12),(29800,0,145,NULL,NULL,13),(29801,0,145,NULL,NULL,14),(29802,0,145,NULL,NULL,15),(29803,0,145,NULL,NULL,16),(29804,0,145,NULL,NULL,17),(29805,0,145,NULL,NULL,18),(29806,0,145,NULL,NULL,19),(29807,0,145,NULL,NULL,20),(29808,0,145,NULL,NULL,21),(29809,0,145,NULL,NULL,22),(29810,0,145,NULL,NULL,23),(29811,0,145,NULL,NULL,24),(29812,0,145,NULL,NULL,25),(29813,0,145,NULL,NULL,26),(29814,0,145,NULL,NULL,27),(29815,0,145,NULL,NULL,28),(29816,0,145,NULL,NULL,29),(29817,0,145,NULL,NULL,30),(29818,0,145,NULL,NULL,31),(29819,0,145,NULL,NULL,32),(29820,0,145,NULL,NULL,33),(29821,0,145,NULL,NULL,34),(29822,0,145,NULL,NULL,35),(29823,0,145,NULL,NULL,36),(29824,0,145,NULL,NULL,37),(29825,0,145,NULL,NULL,38),(29826,0,145,NULL,NULL,39),(29827,0,145,NULL,NULL,40),(29828,0,145,NULL,NULL,41),(29829,0,145,NULL,NULL,42),(29830,0,145,NULL,NULL,43),(29831,0,145,NULL,NULL,44),(29832,0,145,NULL,NULL,45),(29833,0,145,NULL,NULL,46),(29834,0,145,NULL,NULL,47),(29835,0,145,NULL,NULL,48),(29836,0,145,NULL,NULL,49),(29837,0,145,NULL,NULL,50),(29838,0,145,NULL,NULL,51),(29839,0,145,NULL,NULL,52),(29840,0,145,NULL,NULL,53),(29841,0,145,NULL,NULL,54),(29842,0,145,NULL,NULL,55),(29843,0,145,NULL,NULL,56),(29844,0,145,NULL,NULL,57),(29845,0,145,NULL,NULL,58),(29846,0,145,NULL,NULL,59),(29847,0,145,NULL,NULL,60),(29848,0,145,NULL,NULL,61),(29849,0,145,NULL,NULL,62),(29850,0,145,NULL,NULL,63),(29851,0,145,NULL,NULL,64),(29852,0,145,NULL,NULL,65),(29853,0,145,NULL,NULL,66),(29854,0,145,NULL,NULL,67),(29855,0,145,NULL,NULL,68),(29856,0,145,NULL,NULL,69),(29857,0,145,NULL,NULL,70),(29858,0,145,NULL,NULL,71),(29859,0,145,NULL,NULL,72),(29860,0,145,NULL,NULL,73),(29861,0,145,NULL,NULL,74),(29862,0,145,NULL,NULL,75),(29863,0,145,NULL,NULL,76),(29864,0,145,NULL,NULL,77),(29865,0,145,NULL,NULL,78),(29866,0,145,NULL,NULL,79),(29867,0,145,NULL,NULL,80),(29868,0,145,NULL,NULL,81),(29869,0,145,NULL,NULL,82),(29870,0,145,NULL,NULL,83),(29871,0,145,NULL,NULL,84),(29872,0,145,NULL,NULL,85),(29873,0,145,NULL,NULL,86),(29874,0,145,NULL,NULL,87),(29875,0,145,NULL,NULL,88),(29876,0,145,NULL,NULL,89),(29877,0,145,NULL,NULL,90),(29878,0,145,NULL,NULL,91),(29879,0,145,NULL,NULL,92),(29880,0,145,NULL,NULL,93),(29881,0,145,NULL,NULL,94),(29882,0,145,NULL,NULL,95),(29883,0,145,NULL,NULL,96),(29884,0,145,NULL,NULL,97),(29885,0,145,NULL,NULL,98),(29886,0,145,NULL,NULL,99),(29887,0,145,NULL,NULL,100),(29888,0,145,NULL,NULL,101),(29889,0,145,NULL,NULL,102),(29890,0,145,NULL,NULL,103),(29891,0,145,NULL,NULL,104),(29892,0,145,NULL,NULL,105),(29893,0,145,NULL,NULL,106),(29894,0,145,NULL,NULL,107),(29895,0,145,NULL,NULL,108),(29896,0,145,NULL,NULL,109),(29897,0,145,NULL,NULL,110),(29898,0,145,NULL,NULL,111),(29899,0,145,NULL,NULL,112),(29900,0,145,NULL,NULL,113),(29901,0,145,NULL,NULL,114),(29902,0,145,NULL,NULL,115),(29903,0,145,NULL,NULL,116),(29904,0,145,NULL,NULL,117),(29905,0,145,NULL,NULL,118),(29906,0,145,NULL,NULL,119),(29907,0,145,NULL,NULL,120),(29908,0,145,NULL,NULL,121),(29909,0,145,NULL,NULL,122),(29910,0,145,NULL,NULL,123),(29911,0,145,NULL,NULL,124),(29912,0,145,NULL,NULL,125),(29913,0,145,NULL,NULL,126),(29914,0,145,NULL,NULL,127),(29915,0,145,NULL,NULL,128),(29916,0,145,NULL,NULL,129),(29917,0,145,NULL,NULL,130),(29918,0,145,NULL,NULL,131),(29919,0,145,NULL,NULL,132),(29920,0,145,NULL,NULL,133),(29921,0,145,NULL,NULL,134),(29922,0,145,NULL,NULL,135),(29923,0,145,NULL,NULL,136),(29924,0,145,NULL,NULL,137),(29925,0,145,NULL,NULL,138),(29926,0,145,NULL,NULL,139),(29927,0,145,NULL,NULL,140),(29928,0,145,NULL,NULL,141),(29929,2,145,NULL,NULL,142),(29930,2,145,NULL,NULL,143),(29931,1,145,NULL,NULL,144),(29932,1,145,NULL,NULL,145),(29933,2,145,NULL,NULL,146),(29934,2,145,NULL,NULL,147),(29935,2,145,NULL,NULL,148),(29936,2,145,NULL,NULL,149),(29937,2,145,NULL,NULL,150),(29938,2,145,NULL,NULL,151),(29939,2,145,NULL,NULL,152),(29940,2,145,NULL,NULL,153),(29941,2,145,NULL,NULL,154),(29942,0,145,NULL,NULL,155),(29943,0,145,NULL,NULL,156),(29944,0,145,NULL,NULL,157),(29945,0,145,NULL,NULL,158),(29946,0,145,NULL,NULL,159),(29947,0,145,NULL,NULL,160),(29948,0,145,NULL,NULL,161),(29949,0,145,NULL,NULL,162),(29950,0,145,NULL,NULL,163),(29951,0,145,NULL,NULL,164),(29952,0,145,NULL,NULL,165),(29953,0,145,NULL,NULL,166),(29954,0,145,NULL,NULL,167),(29955,0,145,NULL,NULL,168),(29956,0,145,NULL,NULL,169),(29957,0,145,NULL,NULL,170),(29958,0,145,NULL,NULL,171),(29959,0,145,NULL,NULL,172),(29960,0,145,NULL,NULL,173),(29961,0,145,NULL,NULL,174),(29962,0,145,NULL,NULL,175),(29963,0,145,NULL,NULL,176),(29964,0,145,NULL,NULL,177),(29965,0,145,NULL,NULL,178),(29966,0,145,NULL,NULL,179),(29967,0,145,NULL,NULL,180),(29968,0,145,NULL,NULL,181),(29969,0,145,NULL,NULL,182),(29970,0,145,NULL,NULL,183),(29971,0,145,NULL,NULL,184),(29972,0,145,NULL,NULL,185),(29973,0,145,NULL,NULL,186),(29974,0,145,NULL,NULL,187),(29975,0,145,NULL,NULL,188),(29976,0,145,NULL,NULL,189),(29977,0,145,NULL,NULL,190),(29978,0,145,NULL,NULL,191),(29979,0,145,NULL,NULL,192),(29980,0,145,NULL,NULL,193),(29981,0,145,NULL,NULL,194),(29982,0,145,NULL,NULL,195),(29983,0,145,NULL,NULL,196),(29984,0,145,NULL,NULL,197),(29985,0,145,NULL,NULL,198),(29986,0,145,NULL,NULL,199),(29987,0,145,NULL,NULL,200),(29988,0,145,NULL,NULL,201),(29989,0,145,NULL,NULL,202),(29990,0,145,NULL,NULL,203),(29991,0,145,NULL,NULL,204),(29992,0,145,NULL,NULL,205),(29993,0,145,NULL,NULL,206),(29994,0,145,NULL,NULL,207),(29995,0,145,NULL,NULL,208),(29996,0,145,NULL,NULL,209),(29997,0,145,NULL,NULL,210),(29998,1,146,NULL,NULL,1),(29999,2,146,NULL,NULL,2),(30000,1,146,NULL,NULL,3),(30001,0,146,NULL,NULL,4),(30002,0,146,NULL,NULL,5),(30003,0,146,NULL,NULL,6),(30004,0,146,NULL,NULL,7),(30005,0,146,NULL,NULL,8),(30006,0,146,NULL,NULL,9),(30007,2,146,NULL,NULL,10),(30008,0,146,NULL,NULL,11),(30009,0,146,NULL,NULL,12),(30010,0,146,NULL,NULL,13),(30011,0,146,NULL,NULL,14),(30012,0,146,NULL,NULL,15),(30013,0,146,NULL,NULL,16),(30014,0,146,NULL,NULL,17),(30015,0,146,NULL,NULL,18),(30016,2,146,NULL,NULL,19),(30017,0,146,NULL,NULL,20),(30018,0,146,NULL,NULL,21),(30019,0,146,NULL,NULL,22),(30020,0,146,NULL,NULL,23),(30021,0,146,NULL,NULL,24),(30022,0,146,NULL,NULL,25),(30023,0,146,NULL,NULL,26),(30024,1,146,NULL,NULL,27),(30025,0,146,NULL,NULL,28),(30026,0,146,NULL,NULL,29),(30027,2,146,NULL,NULL,30),(30028,0,146,NULL,NULL,31),(30029,0,146,NULL,NULL,32),(30030,0,146,NULL,NULL,33),(30031,0,146,NULL,NULL,34),(30032,2,146,NULL,NULL,35),(30033,0,146,NULL,NULL,36),(30034,0,146,NULL,NULL,37),(30035,0,146,NULL,NULL,38),(30036,0,146,NULL,NULL,39),(30037,0,146,NULL,NULL,40),(30038,0,146,NULL,NULL,41),(30039,0,146,NULL,NULL,42),(30040,0,146,NULL,NULL,43),(30041,1,146,NULL,NULL,44),(30042,0,146,NULL,NULL,45),(30043,0,146,NULL,NULL,46),(30044,0,146,NULL,NULL,47),(30045,0,146,NULL,NULL,48),(30046,0,146,NULL,NULL,49),(30047,0,146,NULL,NULL,50),(30048,0,146,NULL,NULL,51),(30049,0,146,NULL,NULL,52),(30050,0,146,NULL,NULL,53),(30051,0,146,NULL,NULL,54),(30052,0,146,NULL,NULL,55),(30053,0,146,NULL,NULL,56),(30054,0,146,NULL,NULL,57),(30055,0,146,NULL,NULL,58),(30056,0,146,NULL,NULL,59),(30057,0,146,NULL,NULL,60),(30058,0,146,NULL,NULL,61),(30059,0,146,NULL,NULL,62),(30060,0,146,NULL,NULL,63),(30061,0,146,NULL,NULL,64),(30062,0,146,NULL,NULL,65),(30063,0,146,NULL,NULL,66),(30064,0,146,NULL,NULL,67),(30065,0,146,NULL,NULL,68),(30066,0,146,NULL,NULL,69),(30067,0,146,NULL,NULL,70),(30068,0,146,NULL,NULL,71),(30069,0,146,NULL,NULL,72),(30070,0,146,NULL,NULL,73),(30071,0,146,NULL,NULL,74),(30072,0,146,NULL,NULL,75),(30073,0,146,NULL,NULL,76),(30074,0,146,NULL,NULL,77),(30075,0,146,NULL,NULL,78),(30076,0,146,NULL,NULL,79),(30077,0,146,NULL,NULL,80),(30078,0,146,NULL,NULL,81),(30079,0,146,NULL,NULL,82),(30080,0,146,NULL,NULL,83),(30081,0,146,NULL,NULL,84),(30082,0,146,NULL,NULL,85),(30083,0,146,NULL,NULL,86),(30084,0,146,NULL,NULL,87),(30085,0,146,NULL,NULL,88),(30086,0,146,NULL,NULL,89),(30087,0,146,NULL,NULL,90),(30088,0,146,NULL,NULL,91),(30089,0,146,NULL,NULL,92),(30090,0,146,NULL,NULL,93),(30091,0,146,NULL,NULL,94),(30092,0,146,NULL,NULL,95),(30093,0,146,NULL,NULL,96),(30094,0,146,NULL,NULL,97),(30095,0,146,NULL,NULL,98),(30096,0,146,NULL,NULL,99),(30097,0,146,NULL,NULL,100),(30098,0,146,NULL,NULL,101),(30099,0,146,NULL,NULL,102),(30100,0,146,NULL,NULL,103),(30101,0,146,NULL,NULL,104),(30102,0,146,NULL,NULL,105),(30103,0,146,NULL,NULL,106),(30104,0,146,NULL,NULL,107),(30105,0,146,NULL,NULL,108),(30106,0,146,NULL,NULL,109),(30107,0,146,NULL,NULL,110),(30108,0,146,NULL,NULL,111),(30109,0,146,NULL,NULL,112),(30110,0,146,NULL,NULL,113),(30111,0,146,NULL,NULL,114),(30112,0,146,NULL,NULL,115),(30113,0,146,NULL,NULL,116),(30114,0,146,NULL,NULL,117),(30115,0,146,NULL,NULL,118),(30116,0,146,NULL,NULL,119),(30117,0,146,NULL,NULL,120),(30118,0,146,NULL,NULL,121),(30119,0,146,NULL,NULL,122),(30120,0,146,NULL,NULL,123),(30121,0,146,NULL,NULL,124),(30122,0,146,NULL,NULL,125),(30123,0,146,NULL,NULL,126),(30124,0,146,NULL,NULL,127),(30125,0,146,NULL,NULL,128),(30126,0,146,NULL,NULL,129),(30127,0,146,NULL,NULL,130),(30128,0,146,NULL,NULL,131),(30129,0,146,NULL,NULL,132),(30130,0,146,NULL,NULL,133),(30131,0,146,NULL,NULL,134),(30132,0,146,NULL,NULL,135),(30133,0,146,NULL,NULL,136),(30134,0,146,NULL,NULL,137),(30135,0,146,NULL,NULL,138),(30136,0,146,NULL,NULL,139),(30137,0,146,NULL,NULL,140),(30138,0,146,NULL,NULL,141),(30139,0,146,NULL,NULL,142),(30140,0,146,NULL,NULL,143),(30141,0,146,NULL,NULL,144),(30142,0,146,NULL,NULL,145),(30143,0,146,NULL,NULL,146),(30144,0,146,NULL,NULL,147),(30145,0,146,NULL,NULL,148),(30146,0,146,NULL,NULL,149),(30147,0,146,NULL,NULL,150),(30148,0,146,NULL,NULL,151),(30149,0,146,NULL,NULL,152),(30150,0,146,NULL,NULL,153),(30151,0,146,NULL,NULL,154),(30152,0,146,NULL,NULL,155),(30153,0,146,NULL,NULL,156),(30154,0,146,NULL,NULL,157),(30155,0,146,NULL,NULL,158),(30156,0,146,NULL,NULL,159),(30157,0,146,NULL,NULL,160),(30158,0,146,NULL,NULL,161),(30159,0,146,NULL,NULL,162),(30160,0,146,NULL,NULL,163),(30161,0,146,NULL,NULL,164),(30162,0,146,NULL,NULL,165),(30163,0,146,NULL,NULL,166),(30164,0,146,NULL,NULL,167),(30165,0,146,NULL,NULL,168),(30166,0,146,NULL,NULL,169),(30167,0,146,NULL,NULL,170),(30168,0,146,NULL,NULL,171),(30169,0,146,NULL,NULL,172),(30170,0,146,NULL,NULL,173),(30171,0,146,NULL,NULL,174),(30172,0,146,NULL,NULL,175),(30173,0,146,NULL,NULL,176),(30174,0,146,NULL,NULL,177),(30175,0,146,NULL,NULL,178),(30176,0,146,NULL,NULL,179),(30177,0,146,NULL,NULL,180),(30178,0,146,NULL,NULL,181),(30179,0,146,NULL,NULL,182),(30180,0,146,NULL,NULL,183),(30181,0,146,NULL,NULL,184),(30182,0,146,NULL,NULL,185),(30183,0,146,NULL,NULL,186),(30184,0,146,NULL,NULL,187),(30185,0,146,NULL,NULL,188),(30186,0,146,NULL,NULL,189),(30187,0,146,NULL,NULL,190),(30188,0,146,NULL,NULL,191),(30189,0,146,NULL,NULL,192),(30190,0,146,NULL,NULL,193),(30191,0,146,NULL,NULL,194),(30192,0,146,NULL,NULL,195),(30193,0,146,NULL,NULL,196),(30194,0,146,NULL,NULL,197),(30195,0,146,NULL,NULL,198),(30196,0,146,NULL,NULL,199),(30197,0,146,NULL,NULL,200),(30198,0,146,NULL,NULL,201),(30199,0,146,NULL,NULL,202),(30200,0,146,NULL,NULL,203),(30201,0,146,NULL,NULL,204),(30202,0,146,NULL,NULL,205),(30203,0,146,NULL,NULL,206),(30204,0,146,NULL,NULL,207),(30205,0,146,NULL,NULL,208),(30206,0,146,NULL,NULL,209),(30207,0,146,NULL,NULL,210),(30208,2,147,NULL,NULL,1),(30209,0,147,NULL,NULL,2),(30210,0,147,NULL,NULL,3),(30211,0,147,NULL,NULL,4),(30212,0,147,NULL,NULL,5),(30213,0,147,NULL,NULL,6),(30214,0,147,NULL,NULL,7),(30215,0,147,NULL,NULL,8),(30216,0,147,NULL,NULL,9),(30217,2,147,NULL,NULL,10),(30218,0,147,NULL,NULL,11),(30219,0,147,NULL,NULL,12),(30220,0,147,NULL,NULL,13),(30221,0,147,NULL,NULL,14),(30222,0,147,NULL,NULL,15),(30223,0,147,NULL,NULL,16),(30224,0,147,NULL,NULL,17),(30225,0,147,NULL,NULL,18),(30226,2,147,NULL,NULL,19),(30227,0,147,NULL,NULL,20),(30228,0,147,NULL,NULL,21),(30229,0,147,NULL,NULL,22),(30230,0,147,NULL,NULL,23),(30231,0,147,NULL,NULL,24),(30232,0,147,NULL,NULL,25),(30233,0,147,NULL,NULL,26),(30234,2,147,NULL,NULL,27),(30235,0,147,NULL,NULL,28),(30236,0,147,NULL,NULL,29),(30237,0,147,NULL,NULL,30),(30238,0,147,NULL,NULL,31),(30239,0,147,NULL,NULL,32),(30240,0,147,NULL,NULL,33),(30241,0,147,NULL,NULL,34),(30242,2,147,NULL,NULL,35),(30243,0,147,NULL,NULL,36),(30244,0,147,NULL,NULL,37),(30245,0,147,NULL,NULL,38),(30246,0,147,NULL,NULL,39),(30247,0,147,NULL,NULL,40),(30248,0,147,NULL,NULL,41),(30249,0,147,NULL,NULL,42),(30250,0,147,NULL,NULL,43),(30251,1,147,NULL,NULL,44),(30252,0,147,NULL,NULL,45),(30253,0,147,NULL,NULL,46),(30254,1,147,NULL,NULL,47),(30255,0,147,NULL,NULL,48),(30256,0,147,NULL,NULL,49),(30257,0,147,NULL,NULL,50),(30258,0,147,NULL,NULL,51),(30259,0,147,NULL,NULL,52),(30260,0,147,NULL,NULL,53),(30261,2,147,NULL,NULL,54),(30262,0,147,NULL,NULL,55),(30263,0,147,NULL,NULL,56),(30264,0,147,NULL,NULL,57),(30265,0,147,NULL,NULL,58),(30266,0,147,NULL,NULL,59),(30267,0,147,NULL,NULL,60),(30268,0,147,NULL,NULL,61),(30269,0,147,NULL,NULL,62),(30270,0,147,NULL,NULL,63),(30271,0,147,NULL,NULL,64),(30272,0,147,NULL,NULL,65),(30273,0,147,NULL,NULL,66),(30274,0,147,NULL,NULL,67),(30275,0,147,NULL,NULL,68),(30276,0,147,NULL,NULL,69),(30277,0,147,NULL,NULL,70),(30278,0,147,NULL,NULL,71),(30279,0,147,NULL,NULL,72),(30280,0,147,NULL,NULL,73),(30281,0,147,NULL,NULL,74),(30282,0,147,NULL,NULL,75),(30283,0,147,NULL,NULL,76),(30284,0,147,NULL,NULL,77),(30285,0,147,NULL,NULL,78),(30286,0,147,NULL,NULL,79),(30287,0,147,NULL,NULL,80),(30288,0,147,NULL,NULL,81),(30289,0,147,NULL,NULL,82),(30290,0,147,NULL,NULL,83),(30291,0,147,NULL,NULL,84),(30292,0,147,NULL,NULL,85),(30293,0,147,NULL,NULL,86),(30294,0,147,NULL,NULL,87),(30295,0,147,NULL,NULL,88),(30296,0,147,NULL,NULL,89),(30297,0,147,NULL,NULL,90),(30298,0,147,NULL,NULL,91),(30299,0,147,NULL,NULL,92),(30300,0,147,NULL,NULL,93),(30301,0,147,NULL,NULL,94),(30302,0,147,NULL,NULL,95),(30303,0,147,NULL,NULL,96),(30304,0,147,NULL,NULL,97),(30305,0,147,NULL,NULL,98),(30306,0,147,NULL,NULL,99),(30307,0,147,NULL,NULL,100),(30308,0,147,NULL,NULL,101),(30309,0,147,NULL,NULL,102),(30310,0,147,NULL,NULL,103),(30311,0,147,NULL,NULL,104),(30312,0,147,NULL,NULL,105),(30313,0,147,NULL,NULL,106),(30314,0,147,NULL,NULL,107),(30315,0,147,NULL,NULL,108),(30316,0,147,NULL,NULL,109),(30317,0,147,NULL,NULL,110),(30318,0,147,NULL,NULL,111),(30319,0,147,NULL,NULL,112),(30320,0,147,NULL,NULL,113),(30321,0,147,NULL,NULL,114),(30322,0,147,NULL,NULL,115),(30323,0,147,NULL,NULL,116),(30324,0,147,NULL,NULL,117),(30325,0,147,NULL,NULL,118),(30326,0,147,NULL,NULL,119),(30327,0,147,NULL,NULL,120),(30328,0,147,NULL,NULL,121),(30329,0,147,NULL,NULL,122),(30330,0,147,NULL,NULL,123),(30331,0,147,NULL,NULL,124),(30332,0,147,NULL,NULL,125),(30333,0,147,NULL,NULL,126),(30334,0,147,NULL,NULL,127),(30335,0,147,NULL,NULL,128),(30336,0,147,NULL,NULL,129),(30337,0,147,NULL,NULL,130),(30338,0,147,NULL,NULL,131),(30339,0,147,NULL,NULL,132),(30340,0,147,NULL,NULL,133),(30341,0,147,NULL,NULL,134),(30342,0,147,NULL,NULL,135),(30343,0,147,NULL,NULL,136),(30344,0,147,NULL,NULL,137),(30345,0,147,NULL,NULL,138),(30346,0,147,NULL,NULL,139),(30347,0,147,NULL,NULL,140),(30348,0,147,NULL,NULL,141),(30349,0,147,NULL,NULL,142),(30350,0,147,NULL,NULL,143),(30351,0,147,NULL,NULL,144),(30352,0,147,NULL,NULL,145),(30353,0,147,NULL,NULL,146),(30354,0,147,NULL,NULL,147),(30355,0,147,NULL,NULL,148),(30356,0,147,NULL,NULL,149),(30357,0,147,NULL,NULL,150),(30358,0,147,NULL,NULL,151),(30359,0,147,NULL,NULL,152),(30360,0,147,NULL,NULL,153),(30361,0,147,NULL,NULL,154),(30362,0,147,NULL,NULL,155),(30363,0,147,NULL,NULL,156),(30364,0,147,NULL,NULL,157),(30365,0,147,NULL,NULL,158),(30366,0,147,NULL,NULL,159),(30367,0,147,NULL,NULL,160),(30368,0,147,NULL,NULL,161),(30369,0,147,NULL,NULL,162),(30370,0,147,NULL,NULL,163),(30371,0,147,NULL,NULL,164),(30372,0,147,NULL,NULL,165),(30373,0,147,NULL,NULL,166),(30374,0,147,NULL,NULL,167),(30375,0,147,NULL,NULL,168),(30376,0,147,NULL,NULL,169),(30377,0,147,NULL,NULL,170),(30378,0,147,NULL,NULL,171),(30379,0,147,NULL,NULL,172),(30380,0,147,NULL,NULL,173),(30381,0,147,NULL,NULL,174),(30382,0,147,NULL,NULL,175),(30383,0,147,NULL,NULL,176),(30384,0,147,NULL,NULL,177),(30385,0,147,NULL,NULL,178),(30386,0,147,NULL,NULL,179),(30387,0,147,NULL,NULL,180),(30388,0,147,NULL,NULL,181),(30389,0,147,NULL,NULL,182),(30390,0,147,NULL,NULL,183),(30391,0,147,NULL,NULL,184),(30392,0,147,NULL,NULL,185),(30393,0,147,NULL,NULL,186),(30394,0,147,NULL,NULL,187),(30395,0,147,NULL,NULL,188),(30396,0,147,NULL,NULL,189),(30397,0,147,NULL,NULL,190),(30398,0,147,NULL,NULL,191),(30399,0,147,NULL,NULL,192),(30400,0,147,NULL,NULL,193),(30401,0,147,NULL,NULL,194),(30402,0,147,NULL,NULL,195),(30403,0,147,NULL,NULL,196),(30404,0,147,NULL,NULL,197),(30405,0,147,NULL,NULL,198),(30406,0,147,NULL,NULL,199),(30407,0,147,NULL,NULL,200),(30408,0,147,NULL,NULL,201),(30409,0,147,NULL,NULL,202),(30410,0,147,NULL,NULL,203),(30411,0,147,NULL,NULL,204),(30412,0,147,NULL,NULL,205),(30413,0,147,NULL,NULL,206),(30414,0,147,NULL,NULL,207),(30415,0,147,NULL,NULL,208),(30416,0,147,NULL,NULL,209),(30417,0,147,NULL,NULL,210),(31678,1,154,NULL,NULL,1),(31679,1,154,NULL,NULL,2),(31680,1,154,NULL,NULL,3),(31681,2,154,NULL,NULL,4),(31682,1,154,NULL,NULL,5),(31683,1,154,NULL,NULL,6),(31684,1,154,NULL,NULL,7),(31685,1,154,NULL,NULL,8),(31686,1,154,NULL,NULL,9),(31687,0,154,NULL,NULL,10),(31688,0,154,NULL,NULL,11),(31689,0,154,NULL,NULL,12),(31690,0,154,NULL,NULL,13),(31691,0,154,NULL,NULL,14),(31692,0,154,NULL,NULL,15),(31693,0,154,NULL,NULL,16),(31694,0,154,NULL,NULL,17),(31695,0,154,NULL,NULL,18),(31696,0,154,NULL,NULL,19),(31697,0,154,NULL,NULL,20),(31698,0,154,NULL,NULL,21),(31699,0,154,NULL,NULL,22),(31700,0,154,NULL,NULL,23),(31701,0,154,NULL,NULL,24),(31702,0,154,NULL,NULL,25),(31703,0,154,NULL,NULL,26),(31704,0,154,NULL,NULL,27),(31705,0,154,NULL,NULL,28),(31706,0,154,NULL,NULL,29),(31707,0,154,NULL,NULL,30),(31708,0,154,NULL,NULL,31),(31709,0,154,NULL,NULL,32),(31710,0,154,NULL,NULL,33),(31711,0,154,NULL,NULL,34),(31712,0,154,NULL,NULL,35),(31713,0,154,NULL,NULL,36),(31714,0,154,NULL,NULL,37),(31715,0,154,NULL,NULL,38),(31716,0,154,NULL,NULL,39),(31717,0,154,NULL,NULL,40),(31718,0,154,NULL,NULL,41),(31719,0,154,NULL,NULL,42),(31720,0,154,NULL,NULL,43),(31721,0,154,NULL,NULL,44),(31722,0,154,NULL,NULL,45),(31723,0,154,NULL,NULL,46),(31724,0,154,NULL,NULL,47),(31725,0,154,NULL,NULL,48),(31726,0,154,NULL,NULL,49),(31727,0,154,NULL,NULL,50),(31728,0,154,NULL,NULL,51),(31729,0,154,NULL,NULL,52),(31730,0,154,NULL,NULL,53),(31731,0,154,NULL,NULL,54),(31732,0,154,NULL,NULL,55),(31733,0,154,NULL,NULL,56),(31734,0,154,NULL,NULL,57),(31735,0,154,NULL,NULL,58),(31736,0,154,NULL,NULL,59),(31737,0,154,NULL,NULL,60),(31738,0,154,NULL,NULL,61),(31739,0,154,NULL,NULL,62),(31740,0,154,NULL,NULL,63),(31741,0,154,NULL,NULL,64),(31742,0,154,NULL,NULL,65),(31743,0,154,NULL,NULL,66),(31744,0,154,NULL,NULL,67),(31745,0,154,NULL,NULL,68),(31746,0,154,NULL,NULL,69),(31747,0,154,NULL,NULL,70),(31748,0,154,NULL,NULL,71),(31749,0,154,NULL,NULL,72),(31750,0,154,NULL,NULL,73),(31751,0,154,NULL,NULL,74),(31752,0,154,NULL,NULL,75),(31753,0,154,NULL,NULL,76),(31754,0,154,NULL,NULL,77),(31755,0,154,NULL,NULL,78),(31756,0,154,NULL,NULL,79),(31757,0,154,NULL,NULL,80),(31758,0,154,NULL,NULL,81),(31759,0,154,NULL,NULL,82),(31760,0,154,NULL,NULL,83),(31761,0,154,NULL,NULL,84),(31762,0,154,NULL,NULL,85),(31763,0,154,NULL,NULL,86),(31764,0,154,NULL,NULL,87),(31765,0,154,NULL,NULL,88),(31766,0,154,NULL,NULL,89),(31767,0,154,NULL,NULL,90),(31768,0,154,NULL,NULL,91),(31769,0,154,NULL,NULL,92),(31770,0,154,NULL,NULL,93),(31771,0,154,NULL,NULL,94),(31772,0,154,NULL,NULL,95),(31773,0,154,NULL,NULL,96),(31774,0,154,NULL,NULL,97),(31775,0,154,NULL,NULL,98),(31776,0,154,NULL,NULL,99),(31777,0,154,NULL,NULL,100),(31778,0,154,NULL,NULL,101),(31779,0,154,NULL,NULL,102),(31780,0,154,NULL,NULL,103),(31781,0,154,NULL,NULL,104),(31782,0,154,NULL,NULL,105),(31783,0,154,NULL,NULL,106),(31784,0,154,NULL,NULL,107),(31785,0,154,NULL,NULL,108),(31786,0,154,NULL,NULL,109),(31787,0,154,NULL,NULL,110),(31788,0,154,NULL,NULL,111),(31789,0,154,NULL,NULL,112),(31790,0,154,NULL,NULL,113),(31791,0,154,NULL,NULL,114),(31792,0,154,NULL,NULL,115),(31793,0,154,NULL,NULL,116),(31794,0,154,NULL,NULL,117),(31795,0,154,NULL,NULL,118),(31796,0,154,NULL,NULL,119),(31797,0,154,NULL,NULL,120),(31798,0,154,NULL,NULL,121),(31799,0,154,NULL,NULL,122),(31800,0,154,NULL,NULL,123),(31801,0,154,NULL,NULL,124),(31802,0,154,NULL,NULL,125),(31803,0,154,NULL,NULL,126),(31804,0,154,NULL,NULL,127),(31805,0,154,NULL,NULL,128),(31806,0,154,NULL,NULL,129),(31807,0,154,NULL,NULL,130),(31808,0,154,NULL,NULL,131),(31809,0,154,NULL,NULL,132),(31810,0,154,NULL,NULL,133),(31811,0,154,NULL,NULL,134),(31812,0,154,NULL,NULL,135),(31813,0,154,NULL,NULL,136),(31814,0,154,NULL,NULL,137),(31815,0,154,NULL,NULL,138),(31816,0,154,NULL,NULL,139),(31817,0,154,NULL,NULL,140),(31818,0,154,NULL,NULL,141),(31819,0,154,NULL,NULL,142),(31820,0,154,NULL,NULL,143),(31821,0,154,NULL,NULL,144),(31822,0,154,NULL,NULL,145),(31823,0,154,NULL,NULL,146),(31824,0,154,NULL,NULL,147),(31825,0,154,NULL,NULL,148),(31826,0,154,NULL,NULL,149),(31827,0,154,NULL,NULL,150),(31828,0,154,NULL,NULL,151),(31829,0,154,NULL,NULL,152),(31830,0,154,NULL,NULL,153),(31831,0,154,NULL,NULL,154),(31832,0,154,NULL,NULL,155),(31833,0,154,NULL,NULL,156),(31834,0,154,NULL,NULL,157),(31835,0,154,NULL,NULL,158),(31836,0,154,NULL,NULL,159),(31837,0,154,NULL,NULL,160),(31838,0,154,NULL,NULL,161),(31839,0,154,NULL,NULL,162),(31840,0,154,NULL,NULL,163),(31841,0,154,NULL,NULL,164),(31842,0,154,NULL,NULL,165),(31843,0,154,NULL,NULL,166),(31844,0,154,NULL,NULL,167),(31845,0,154,NULL,NULL,168),(31846,0,154,NULL,NULL,169),(31847,0,154,NULL,NULL,170),(31848,0,154,NULL,NULL,171),(31849,0,154,NULL,NULL,172),(31850,0,154,NULL,NULL,173),(31851,0,154,NULL,NULL,174),(31852,0,154,NULL,NULL,175),(31853,0,154,NULL,NULL,176),(31854,0,154,NULL,NULL,177),(31855,0,154,NULL,NULL,178),(31856,0,154,NULL,NULL,179),(31857,0,154,NULL,NULL,180),(31858,0,154,NULL,NULL,181),(31859,0,154,NULL,NULL,182),(31860,0,154,NULL,NULL,183),(31861,0,154,NULL,NULL,184),(31862,0,154,NULL,NULL,185),(31863,0,154,NULL,NULL,186),(31864,0,154,NULL,NULL,187),(31865,0,154,NULL,NULL,188),(31866,0,154,NULL,NULL,189),(31867,0,154,NULL,NULL,190),(31868,0,154,NULL,NULL,191),(31869,0,154,NULL,NULL,192),(31870,0,154,NULL,NULL,193),(31871,0,154,NULL,NULL,194),(31872,0,154,NULL,NULL,195),(31873,0,154,NULL,NULL,196),(31874,0,154,NULL,NULL,197),(31875,0,154,NULL,NULL,198),(31876,0,154,NULL,NULL,199),(31877,0,154,NULL,NULL,200),(31878,0,154,NULL,NULL,201),(31879,0,154,NULL,NULL,202),(31880,0,154,NULL,NULL,203),(31881,0,154,NULL,NULL,204),(31882,0,154,NULL,NULL,205),(31883,0,154,NULL,NULL,206),(31884,0,154,NULL,NULL,207),(31885,0,154,NULL,NULL,208),(31886,0,154,NULL,NULL,209),(31887,0,154,NULL,NULL,210),(31888,1,155,NULL,NULL,1),(31889,1,155,NULL,NULL,2),(31890,1,155,NULL,NULL,3),(31891,1,155,NULL,NULL,4),(31892,1,155,NULL,NULL,5),(31893,1,155,NULL,NULL,6),(31894,1,155,NULL,NULL,7),(31895,1,155,NULL,NULL,8),(31896,1,155,NULL,NULL,9),(31897,1,155,NULL,NULL,10),(31898,1,155,NULL,NULL,11),(31899,1,155,NULL,NULL,12),(31900,1,155,NULL,NULL,13),(31901,1,155,NULL,NULL,14),(31902,1,155,NULL,NULL,15),(31903,1,155,NULL,NULL,16),(31904,1,155,NULL,NULL,17),(31905,1,155,NULL,NULL,18),(31906,1,155,NULL,NULL,19),(31907,1,155,NULL,NULL,20),(31908,1,155,NULL,NULL,21),(31909,1,155,NULL,NULL,22),(31910,1,155,NULL,NULL,23),(31911,1,155,NULL,NULL,24),(31912,1,155,NULL,NULL,25),(31913,1,155,NULL,NULL,26),(31914,1,155,NULL,NULL,27),(31915,1,155,NULL,NULL,28),(31916,1,155,NULL,NULL,29),(31917,1,155,NULL,NULL,30),(31918,1,155,NULL,NULL,31),(31919,1,155,NULL,NULL,32),(31920,1,155,NULL,NULL,33),(31921,1,155,NULL,NULL,34),(31922,1,155,NULL,NULL,35),(31923,1,155,NULL,NULL,36),(31924,1,155,NULL,NULL,37),(31925,1,155,NULL,NULL,38),(31926,1,155,NULL,NULL,39),(31927,1,155,NULL,NULL,40),(31928,1,155,NULL,NULL,41),(31929,1,155,NULL,NULL,42),(31930,1,155,NULL,NULL,43),(31931,1,155,NULL,NULL,44),(31932,1,155,NULL,NULL,45),(31933,1,155,NULL,NULL,46),(31934,1,155,NULL,NULL,47),(31935,1,155,NULL,NULL,48),(31936,1,155,NULL,NULL,49),(31937,1,155,NULL,NULL,50),(31938,1,155,NULL,NULL,51),(31939,1,155,NULL,NULL,52),(31940,1,155,NULL,NULL,53),(31941,1,155,NULL,NULL,54),(31942,1,155,NULL,NULL,55),(31943,1,155,NULL,NULL,56),(31944,1,155,NULL,NULL,57),(31945,1,155,NULL,NULL,58),(31946,1,155,NULL,NULL,59),(31947,1,155,NULL,NULL,60),(31948,1,155,NULL,NULL,61),(31949,1,155,NULL,NULL,62),(31950,1,155,NULL,NULL,63),(31951,1,155,NULL,NULL,64),(31952,1,155,NULL,NULL,65),(31953,1,155,NULL,NULL,66),(31954,1,155,NULL,NULL,67),(31955,1,155,NULL,NULL,68),(31956,1,155,NULL,NULL,69),(31957,1,155,NULL,NULL,70),(31958,1,155,NULL,NULL,71),(31959,1,155,NULL,NULL,72),(31960,1,155,NULL,NULL,73),(31961,1,155,NULL,NULL,74),(31962,1,155,NULL,NULL,75),(31963,1,155,NULL,NULL,76),(31964,1,155,NULL,NULL,77),(31965,1,155,NULL,NULL,78),(31966,1,155,NULL,NULL,79),(31967,1,155,NULL,NULL,80),(31968,1,155,NULL,NULL,81),(31969,1,155,NULL,NULL,82),(31970,1,155,NULL,NULL,83),(31971,1,155,NULL,NULL,84),(31972,1,155,NULL,NULL,85),(31973,1,155,NULL,NULL,86),(31974,1,155,NULL,NULL,87),(31975,1,155,NULL,NULL,88),(31976,1,155,NULL,NULL,89),(31977,1,155,NULL,NULL,90),(31978,1,155,NULL,NULL,91),(31979,1,155,NULL,NULL,92),(31980,1,155,NULL,NULL,93),(31981,1,155,NULL,NULL,94),(31982,1,155,NULL,NULL,95),(31983,1,155,NULL,NULL,96),(31984,1,155,NULL,NULL,97),(31985,1,155,NULL,NULL,98),(31986,1,155,NULL,NULL,99),(31987,1,155,NULL,NULL,100),(31988,1,155,NULL,NULL,101),(31989,1,155,NULL,NULL,102),(31990,1,155,NULL,NULL,103),(31991,1,155,NULL,NULL,104),(31992,1,155,NULL,NULL,105),(31993,1,155,NULL,NULL,106),(31994,1,155,NULL,NULL,107),(31995,1,155,NULL,NULL,108),(31996,1,155,NULL,NULL,109),(31997,1,155,NULL,NULL,110),(31998,1,155,NULL,NULL,111),(31999,1,155,NULL,NULL,112),(32000,1,155,NULL,NULL,113),(32001,1,155,NULL,NULL,114),(32002,1,155,NULL,NULL,115),(32003,1,155,NULL,NULL,116),(32004,1,155,NULL,NULL,117),(32005,1,155,NULL,NULL,118),(32006,1,155,NULL,NULL,119),(32007,1,155,NULL,NULL,120),(32008,1,155,NULL,NULL,121),(32009,1,155,NULL,NULL,122),(32010,1,155,NULL,NULL,123),(32011,1,155,NULL,NULL,124),(32012,1,155,NULL,NULL,125),(32013,1,155,NULL,NULL,126),(32014,1,155,NULL,NULL,127),(32015,1,155,NULL,NULL,128),(32016,1,155,NULL,NULL,129),(32017,1,155,NULL,NULL,130),(32018,1,155,NULL,NULL,131),(32019,1,155,NULL,NULL,132),(32020,1,155,NULL,NULL,133),(32021,1,155,NULL,NULL,134),(32022,1,155,NULL,NULL,135),(32023,1,155,NULL,NULL,136),(32024,1,155,NULL,NULL,137),(32025,1,155,NULL,NULL,138),(32026,1,155,NULL,NULL,139),(32027,1,155,NULL,NULL,140),(32028,1,155,NULL,NULL,141),(32029,0,155,NULL,NULL,142),(32030,0,155,NULL,NULL,143),(32031,0,155,NULL,NULL,144),(32032,0,155,NULL,NULL,145),(32033,0,155,NULL,NULL,146),(32034,0,155,NULL,NULL,147),(32035,0,155,NULL,NULL,148),(32036,0,155,NULL,NULL,149),(32037,0,155,NULL,NULL,150),(32038,0,155,NULL,NULL,151),(32039,0,155,NULL,NULL,152),(32040,0,155,NULL,NULL,153),(32041,0,155,NULL,NULL,154),(32042,0,155,NULL,NULL,155),(32043,0,155,NULL,NULL,156),(32044,0,155,NULL,NULL,157),(32045,0,155,NULL,NULL,158),(32046,0,155,NULL,NULL,159),(32047,0,155,NULL,NULL,160),(32048,0,155,NULL,NULL,161),(32049,0,155,NULL,NULL,162),(32050,0,155,NULL,NULL,163),(32051,0,155,NULL,NULL,164),(32052,0,155,NULL,NULL,165),(32053,0,155,NULL,NULL,166),(32054,0,155,NULL,NULL,167),(32055,0,155,NULL,NULL,168),(32056,0,155,NULL,NULL,169),(32057,0,155,NULL,NULL,170),(32058,0,155,NULL,NULL,171),(32059,0,155,NULL,NULL,172),(32060,0,155,NULL,NULL,173),(32061,0,155,NULL,NULL,174),(32062,0,155,NULL,NULL,175),(32063,0,155,NULL,NULL,176),(32064,0,155,NULL,NULL,177),(32065,0,155,NULL,NULL,178),(32066,0,155,NULL,NULL,179),(32067,0,155,NULL,NULL,180),(32068,0,155,NULL,NULL,181),(32069,0,155,NULL,NULL,182),(32070,0,155,NULL,NULL,183),(32071,0,155,NULL,NULL,184),(32072,0,155,NULL,NULL,185),(32073,0,155,NULL,NULL,186),(32074,0,155,NULL,NULL,187),(32075,0,155,NULL,NULL,188),(32076,0,155,NULL,NULL,189),(32077,0,155,NULL,NULL,190),(32078,0,155,NULL,NULL,191),(32079,0,155,NULL,NULL,192),(32080,0,155,NULL,NULL,193),(32081,0,155,NULL,NULL,194),(32082,0,155,NULL,NULL,195),(32083,0,155,NULL,NULL,196),(32084,0,155,NULL,NULL,197),(32085,0,155,NULL,NULL,198),(32086,0,155,NULL,NULL,199),(32087,0,155,NULL,NULL,200),(32088,0,155,NULL,NULL,201),(32089,0,155,NULL,NULL,202),(32090,0,155,NULL,NULL,203),(32091,0,155,NULL,NULL,204),(32092,0,155,NULL,NULL,205),(32093,0,155,NULL,NULL,206),(32094,0,155,NULL,NULL,207),(32095,0,155,NULL,NULL,208),(32096,0,155,NULL,NULL,209),(32097,0,155,NULL,NULL,210),(32098,1,156,NULL,NULL,1),(32099,1,156,NULL,NULL,2),(32100,1,156,NULL,NULL,3),(32101,1,156,NULL,NULL,4),(32102,1,156,NULL,NULL,5),(32103,1,156,NULL,NULL,6),(32104,1,156,NULL,NULL,7),(32105,1,156,NULL,NULL,8),(32106,1,156,NULL,NULL,9),(32107,1,156,NULL,NULL,10),(32108,1,156,NULL,NULL,11),(32109,1,156,NULL,NULL,12),(32110,1,156,NULL,NULL,13),(32111,1,156,NULL,NULL,14),(32112,1,156,NULL,NULL,15),(32113,1,156,NULL,NULL,16),(32114,1,156,NULL,NULL,17),(32115,1,156,NULL,NULL,18),(32116,1,156,NULL,NULL,19),(32117,1,156,NULL,NULL,20),(32118,1,156,NULL,NULL,21),(32119,1,156,NULL,NULL,22),(32120,1,156,NULL,NULL,23),(32121,1,156,NULL,NULL,24),(32122,1,156,NULL,NULL,25),(32123,1,156,NULL,NULL,26),(32124,1,156,NULL,NULL,27),(32125,1,156,NULL,NULL,28),(32126,1,156,NULL,NULL,29),(32127,1,156,NULL,NULL,30),(32128,1,156,NULL,NULL,31),(32129,1,156,NULL,NULL,32),(32130,1,156,NULL,NULL,33),(32131,1,156,NULL,NULL,34),(32132,1,156,NULL,NULL,35),(32133,1,156,NULL,NULL,36),(32134,1,156,NULL,NULL,37),(32135,1,156,NULL,NULL,38),(32136,1,156,NULL,NULL,39),(32137,1,156,NULL,NULL,40),(32138,1,156,NULL,NULL,41),(32139,1,156,NULL,NULL,42),(32140,1,156,NULL,NULL,43),(32141,1,156,NULL,NULL,44),(32142,1,156,NULL,NULL,45),(32143,1,156,NULL,NULL,46),(32144,1,156,NULL,NULL,47),(32145,1,156,NULL,NULL,48),(32146,1,156,NULL,NULL,49),(32147,1,156,NULL,NULL,50),(32148,1,156,NULL,NULL,51),(32149,1,156,NULL,NULL,52),(32150,1,156,NULL,NULL,53),(32151,1,156,NULL,NULL,54),(32152,1,156,NULL,NULL,55),(32153,1,156,NULL,NULL,56),(32154,1,156,NULL,NULL,57),(32155,1,156,NULL,NULL,58),(32156,1,156,NULL,NULL,59),(32157,1,156,NULL,NULL,60),(32158,1,156,NULL,NULL,61),(32159,1,156,NULL,NULL,62),(32160,1,156,NULL,NULL,63),(32161,1,156,NULL,NULL,64),(32162,1,156,NULL,NULL,65),(32163,1,156,NULL,NULL,66),(32164,1,156,NULL,NULL,67),(32165,1,156,NULL,NULL,68),(32166,1,156,NULL,NULL,69),(32167,1,156,NULL,NULL,70),(32168,1,156,NULL,NULL,71),(32169,1,156,NULL,NULL,72),(32170,1,156,NULL,NULL,73),(32171,1,156,NULL,NULL,74),(32172,1,156,NULL,NULL,75),(32173,1,156,NULL,NULL,76),(32174,1,156,NULL,NULL,77),(32175,1,156,NULL,NULL,78),(32176,1,156,NULL,NULL,79),(32177,1,156,NULL,NULL,80),(32178,1,156,NULL,NULL,81),(32179,1,156,NULL,NULL,82),(32180,1,156,NULL,NULL,83),(32181,1,156,NULL,NULL,84),(32182,1,156,NULL,NULL,85),(32183,1,156,NULL,NULL,86),(32184,1,156,NULL,NULL,87),(32185,1,156,NULL,NULL,88),(32186,1,156,NULL,NULL,89),(32187,1,156,NULL,NULL,90),(32188,1,156,NULL,NULL,91),(32189,1,156,NULL,NULL,92),(32190,1,156,NULL,NULL,93),(32191,1,156,NULL,NULL,94),(32192,1,156,NULL,NULL,95),(32193,1,156,NULL,NULL,96),(32194,1,156,NULL,NULL,97),(32195,1,156,NULL,NULL,98),(32196,1,156,NULL,NULL,99),(32197,1,156,NULL,NULL,100),(32198,1,156,NULL,NULL,101),(32199,1,156,NULL,NULL,102),(32200,1,156,NULL,NULL,103),(32201,1,156,NULL,NULL,104),(32202,1,156,NULL,NULL,105),(32203,1,156,NULL,NULL,106),(32204,1,156,NULL,NULL,107),(32205,1,156,NULL,NULL,108),(32206,1,156,NULL,NULL,109),(32207,1,156,NULL,NULL,110),(32208,1,156,NULL,NULL,111),(32209,1,156,NULL,NULL,112),(32210,1,156,NULL,NULL,113),(32211,1,156,NULL,NULL,114),(32212,1,156,NULL,NULL,115),(32213,1,156,NULL,NULL,116),(32214,1,156,NULL,NULL,117),(32215,1,156,NULL,NULL,118),(32216,1,156,NULL,NULL,119),(32217,1,156,NULL,NULL,120),(32218,1,156,NULL,NULL,121),(32219,1,156,NULL,NULL,122),(32220,1,156,NULL,NULL,123),(32221,1,156,NULL,NULL,124),(32222,1,156,NULL,NULL,125),(32223,1,156,NULL,NULL,126),(32224,1,156,NULL,NULL,127),(32225,1,156,NULL,NULL,128),(32226,1,156,NULL,NULL,129),(32227,1,156,NULL,NULL,130),(32228,1,156,NULL,NULL,131),(32229,1,156,NULL,NULL,132),(32230,1,156,NULL,NULL,133),(32231,1,156,NULL,NULL,134),(32232,1,156,NULL,NULL,135),(32233,1,156,NULL,NULL,136),(32234,1,156,NULL,NULL,137),(32235,1,156,NULL,NULL,138),(32236,1,156,NULL,NULL,139),(32237,1,156,NULL,NULL,140),(32238,1,156,NULL,NULL,141),(32239,0,156,NULL,NULL,142),(32240,0,156,NULL,NULL,143),(32241,0,156,NULL,NULL,144),(32242,0,156,NULL,NULL,145),(32243,0,156,NULL,NULL,146),(32244,0,156,NULL,NULL,147),(32245,0,156,NULL,NULL,148),(32246,0,156,NULL,NULL,149),(32247,0,156,NULL,NULL,150),(32248,0,156,NULL,NULL,151),(32249,0,156,NULL,NULL,152),(32250,0,156,NULL,NULL,153),(32251,0,156,NULL,NULL,154),(32252,0,156,NULL,NULL,155),(32253,0,156,NULL,NULL,156),(32254,0,156,NULL,NULL,157),(32255,0,156,NULL,NULL,158),(32256,0,156,NULL,NULL,159),(32257,0,156,NULL,NULL,160),(32258,0,156,NULL,NULL,161),(32259,0,156,NULL,NULL,162),(32260,0,156,NULL,NULL,163),(32261,0,156,NULL,NULL,164),(32262,0,156,NULL,NULL,165),(32263,0,156,NULL,NULL,166),(32264,0,156,NULL,NULL,167),(32265,0,156,NULL,NULL,168),(32266,0,156,NULL,NULL,169),(32267,0,156,NULL,NULL,170),(32268,0,156,NULL,NULL,171),(32269,0,156,NULL,NULL,172),(32270,0,156,NULL,NULL,173),(32271,0,156,NULL,NULL,174),(32272,0,156,NULL,NULL,175),(32273,0,156,NULL,NULL,176),(32274,0,156,NULL,NULL,177),(32275,0,156,NULL,NULL,178),(32276,0,156,NULL,NULL,179),(32277,0,156,NULL,NULL,180),(32278,0,156,NULL,NULL,181),(32279,0,156,NULL,NULL,182),(32280,0,156,NULL,NULL,183),(32281,0,156,NULL,NULL,184),(32282,0,156,NULL,NULL,185),(32283,0,156,NULL,NULL,186),(32284,0,156,NULL,NULL,187),(32285,0,156,NULL,NULL,188),(32286,0,156,NULL,NULL,189),(32287,0,156,NULL,NULL,190),(32288,0,156,NULL,NULL,191),(32289,0,156,NULL,NULL,192),(32290,0,156,NULL,NULL,193),(32291,0,156,NULL,NULL,194),(32292,0,156,NULL,NULL,195),(32293,0,156,NULL,NULL,196),(32294,0,156,NULL,NULL,197),(32295,0,156,NULL,NULL,198),(32296,0,156,NULL,NULL,199),(32297,0,156,NULL,NULL,200),(32298,0,156,NULL,NULL,201),(32299,0,156,NULL,NULL,202),(32300,0,156,NULL,NULL,203),(32301,0,156,NULL,NULL,204),(32302,0,156,NULL,NULL,205),(32303,0,156,NULL,NULL,206),(32304,0,156,NULL,NULL,207),(32305,0,156,NULL,NULL,208),(32306,0,156,NULL,NULL,209),(32307,0,156,NULL,NULL,210);
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
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sections`
--

LOCK TABLES `sections` WRITE;
/*!40000 ALTER TABLE `sections` DISABLE KEYS */;
INSERT INTO `sections` VALUES (1,'EQUIPO',1,0),(2,'EVENTOS',1,0),(3,'HERRAMIENTAS',1,0),(4,'MINDSET',1,0),(5,'APLICACIÓN PRÁCTICA',1,0),(6,'KANBAN-CEREMONIAS',2,0),(7,'KANBAN-ROLES',2,0);
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

-- Dump completed on 2019-01-09 10:49:33
