--ANTES DE HACER LA MIGRACIÓN

--Eliminamos Columnas 
ALTER TABLE `agilemeter`.`proyectos` 
DROP COLUMN `ProjectSize`,
DROP COLUMN `TeamName`,
DROP COLUMN `UnityName`,
DROP COLUMN `OfficeName`;


--
-- Table structure for table `oficina`
--

DROP TABLE IF EXISTS `oficina`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `oficina` (
  `OficinaId` int(11) NOT NULL AUTO_INCREMENT,
  `OficinaNombre` varchar(50) NOT NULL,
  PRIMARY KEY (`OficinaId`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oficina`
--

LOCK TABLES `oficina` WRITE;
/*!40000 ALTER TABLE `oficina` DISABLE KEYS */;
INSERT INTO `oficina` VALUES (1,'Madrid'),(2,'Murcia'),(3,'Alicante'),(4,'Salamanca'),(5,'Lisboa'),(6,'Sevilla');
/*!40000 ALTER TABLE `oficina` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `unidad`
--

DROP TABLE IF EXISTS `unidad`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `unidad` (
  `UnidadId` int(11) NOT NULL AUTO_INCREMENT,
  `OficinaId` int(11) NOT NULL,
  `UnidadNombre` varchar(50) NOT NULL,
  PRIMARY KEY (`UnidadId`),
  KEY `IX_Unidad_OficinaId` (`OficinaId`),
  CONSTRAINT `FK_Unidad_Oficina_OficinaId` FOREIGN KEY (`OficinaId`) REFERENCES `oficina` (`OficinaId`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `unidad`
--

LOCK TABLES `unidad` WRITE;
/*!40000 ALTER TABLE `unidad` DISABLE KEYS */;
INSERT INTO `unidad` VALUES (1,1,'Centers'),(2,2,'Centers'),(3,3,'Centers'),(4,4,'Centers'),(5,5,'Centers'),(6,6,'Centers');
/*!40000 ALTER TABLE `unidad` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `linea`
--

DROP TABLE IF EXISTS `linea`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `linea` (
  `LineaId` int(11) NOT NULL AUTO_INCREMENT,
  `LineaNombre` varchar(50) NOT NULL,
  `UnidadId` int(11) NOT NULL,
  PRIMARY KEY (`LineaId`),
  KEY `IX_Linea_UnidadId` (`UnidadId`),
  CONSTRAINT `FK_Linea_Unidad_UnidadId` FOREIGN KEY (`UnidadId`) REFERENCES `unidad` (`UnidadId`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `linea`
--

LOCK TABLES `linea` WRITE;
/*!40000 ALTER TABLE `linea` DISABLE KEYS */;
INSERT INTO `linea` VALUES (1,'L. TESCO',6),(2,'L. BigData',2),(3,'L. CHAFEA',2),(4,'L. Herramientas',3),(5,'GESTOROT',4),(6,'PGECADIS',4),(7,'DES BMW SA3',5),(8,'DES BID',6);
/*!40000 ALTER TABLE `linea` ENABLE KEYS */;
UNLOCK TABLES;



ALTER TABLE proyectos
ADD COLUMN ProjectSize int(11) NOT NULL DEFAULT '0'

ALTER TABLE proyectos
ADD COLUMN LineaId int(11) NOT NULL DEFAULT '0'

ALTER TABLE proyectos
ADD COLUMN OficinaId int(11) NOT NULL DEFAULT '0'

ALTER TABLE proyectos
ADD COLUMN UnidadId int(11) NOT NULL DEFAULT '0'


--Desactivamos la comprobación de las FK
SET FOREIGN_KEY_CHECKS=0;

ALTER TABLE proyectos ADD CONSTRAINT `FK_Proyectos_Linea_LineaId` FOREIGN KEY (`LineaId`) REFERENCES `linea` (`LineaId`);

ALTER TABLE proyectos ADD CONSTRAINT `FK_Proyectos_Oficina_OficinaId` FOREIGN KEY (`OficinaId`) REFERENCES `oficina` (`OficinaId`);

ALTER TABLE proyectos ADD CONSTRAINT `FK_Proyectos_Unidad_UnidadId` FOREIGN KEY (`UnidadId`) REFERENCES `unidad` (`UnidadId`);


--TRAS HACER LA MIGRACIÓN

/*
--Oficinas
INSERT INTO `agilemeter`.`oficina` (`OficinaNombre`) VALUES ('Murcia');
INSERT INTO `agilemeter`.`oficina` (`OficinaNombre`) VALUES ('Alicante');
INSERT INTO `agilemeter`.`oficina` (`OficinaNombre`) VALUES ('Salamanca');
INSERT INTO `agilemeter`.`oficina` (`OficinaNombre`) VALUES ('Lisboa');
INSERT INTO `agilemeter`.`oficina` (`OficinaNombre`) VALUES ('Sevilla');

--Unidades
INSERT INTO `agilemeter`.`unidad` (`OficinaId`, `UnidadNombre`) VALUES ('2', 'Centers');
INSERT INTO `agilemeter`.`unidad` (`OficinaId`, `UnidadNombre`) VALUES ('3', 'Centers');
INSERT INTO `agilemeter`.`unidad` (`OficinaId`, `UnidadNombre`) VALUES ('4', 'Centers');
INSERT INTO `agilemeter`.`unidad` (`OficinaId`, `UnidadNombre`) VALUES ('5', 'Centers');
INSERT INTO `agilemeter`.`unidad` (`OficinaId`, `UnidadNombre`) VALUES ('6', 'Centers');

--Lineas
INSERT INTO `agilemeter`.`linea` (`LineaNombre`, `UnidadId`) VALUES ('L. BigData', '2');
INSERT INTO `agilemeter`.`linea` (`LineaNombre`, `UnidadId`) VALUES ('L. CHAFEA', '2');
INSERT INTO `agilemeter`.`linea` (`LineaNombre`, `UnidadId`) VALUES ('L. Herramientas', '3');
INSERT INTO `agilemeter`.`linea` (`LineaNombre`, `UnidadId`) VALUES ('GESTOROT', '4');
INSERT INTO `agilemeter`.`linea` (`LineaNombre`, `UnidadId`) VALUES ('PGECADIS', '4');
INSERT INTO `agilemeter`.`linea` (`LineaNombre`, `UnidadId`) VALUES ('DES BMW SA3', '5');
INSERT INTO `agilemeter`.`linea` (`LineaNombre`, `UnidadId`) VALUES ('DES BID', '6');
*/

update  `agilemeter`.`proyectos`
set `LineaId`=2, `OficinaId`=2, `ProjectSize`=7, `UnidadId`=2
where Nombre = 'DES BigData UK'

update  `agilemeter`.`proyectos`
set `LineaId`=2, `OficinaId`=2, `ProjectSize`=15, `UnidadId`=2
where Nombre = 'DES BigData Zurich'

update  `agilemeter`.`proyectos`
set `LineaId`=3, `OficinaId`=2, `ProjectSize`=11, `UnidadId`=2
where Nombre = 'DES CHAFEA'

update  `agilemeter`.`proyectos`
set `LineaId`=4, `OficinaId`=3, `ProjectSize`=6, `UnidadId`=3
where Nombre = 'AM CTS'

update  `agilemeter`.`proyectos`
set `LineaId`=5, `OficinaId`=4, `ProjectSize`=6, `UnidadId`=4
where Nombre = 'GESTOROT'

update  `agilemeter`.`proyectos`
set `LineaId`=6, `OficinaId`=4, `ProjectSize`=0, `UnidadId`=4
where Nombre = 'PGECADIS'

update  `agilemeter`.`proyectos`
set `LineaId`=7, `OficinaId`=5, `ProjectSize`=0, `UnidadId`=5
where Nombre = 'DES BMW SA3'

update  `agilemeter`.`proyectos`
set `LineaId`=8, `OficinaId`=6, `ProjectSize`=0, `UnidadId`=6
where Nombre = 'DES BID'

--Equipos
--INSERT INTO `agilemeter`.`proyectos` (`Fecha`, `Nombre`, `UserNombre`, `TestProject`, `LineaId`, `OficinaId`, `ProjectSize`, `UnidadId`) VALUES (NOW(), 'DES BigData UK', 'marcossa', 0,'2', '2','7', '2');
--INSERT INTO `agilemeter`.`proyectos` (`Fecha`, `Nombre`, `UserNombre`, `TestProject`, `LineaId`, `OficinaId`, `ProjectSize`, `UnidadId`) VALUES (NOW(), 'DES BigData Zurich', 'marcossa', 0,'2', '2','15', '2');
--INSERT INTO `agilemeter`.`proyectos` (`Fecha`, `Nombre`, `UserNombre`, `TestProject`, `LineaId`, `OficinaId`, `ProjectSize`, `UnidadId`) VALUES (NOW(), 'DES CHAFEA', 'marcossa', 0,'3', '2','11', '2');
--INSERT INTO `agilemeter`.`proyectos` (`Fecha`, `Nombre`, `UserNombre`, `TestProject`, `LineaId`, `OficinaId`, `ProjectSize`, `UnidadId`) VALUES (NOW(), 'AM CTS', 'marcossa', 0,'4', '3','6', '3');
--INSERT INTO `agilemeter`.`proyectos` (`Fecha`, `Nombre`, `UserNombre`, `TestProject`, `LineaId`, `OficinaId`, `ProjectSize`, `UnidadId`) VALUES (NOW(), 'GESTOROT', 'marcossa', 0,'5', '4','6', '4');
--INSERT INTO `agilemeter`.`proyectos` (`Fecha`, `Nombre`, `UserNombre`, `TestProject`, `LineaId`, `OficinaId`, `ProjectSize`, `UnidadId`) VALUES (NOW(), 'PGECADIS', 'marcossa', 0,'6', '4','0', '4');
--INSERT INTO `agilemeter`.`proyectos` (`Fecha`, `Nombre`, `UserNombre`, `TestProject`, `LineaId`, `OficinaId`, `ProjectSize`, `UnidadId`) VALUES (NOW(), 'DES BMW SA3', 'marcossa', 0,'7', '5','0', '5');
--INSERT INTO `agilemeter`.`proyectos` (`Fecha`, `Nombre`, `UserNombre`, `TestProject`, `LineaId`, `OficinaId`, `ProjectSize`, `UnidadId`) VALUES (NOW(), 'DES BID', 'marcossa', 0,'8', '6','0', '6');

--Activamos la comprobación de las FK
SET FOREIGN_KEY_CHECKS=1;