#ANTES DE HACER LA MIGRACIÓN

#Eliminamos Columnas 
ALTER TABLE `agilemeter`.`proyectos` 
DROP COLUMN `ProjectSize`,
DROP COLUMN `TeamName`,
DROP COLUMN `UnityName`,
DROP COLUMN `OfficeName`;

#Desactivamos la comprobación de las FK
SET GLOBAL FOREIGN_KEY_CHECKS=0;


#TRAS HACER LA MIGRACIÓN
#Datos de prueba 
INSERT INTO `agilemeter`.`oficina` (`OficinaNombre`) VALUES ('Oficina de Prueba');
INSERT INTO `agilemeter`.`unidad` (`OficinaId`, `UnidadNombre`) VALUES ('1', 'Unidad de Prueba');
INSERT INTO `agilemeter`.`linea` (`LineaNombre`, `UnidadId`) VALUES ('Linea de Prueba', '1');

#Oficinas
INSERT INTO `agilemeter`.`oficina` (`OficinaNombre`) VALUES ('Murcia');
INSERT INTO `agilemeter`.`oficina` (`OficinaNombre`) VALUES ('Alicante');
INSERT INTO `agilemeter`.`oficina` (`OficinaNombre`) VALUES ('Salamanca');
INSERT INTO `agilemeter`.`oficina` (`OficinaNombre`) VALUES ('Lisboa');
INSERT INTO `agilemeter`.`oficina` (`OficinaNombre`) VALUES ('Sevilla');

#Unidades
INSERT INTO `agilemeter`.`unidad` (`OficinaId`, `UnidadNombre`) VALUES ('2', 'Centers');
INSERT INTO `agilemeter`.`unidad` (`OficinaId`, `UnidadNombre`) VALUES ('3', 'Centers');
INSERT INTO `agilemeter`.`unidad` (`OficinaId`, `UnidadNombre`) VALUES ('4', 'Centers');
INSERT INTO `agilemeter`.`unidad` (`OficinaId`, `UnidadNombre`) VALUES ('5', 'Centers');
INSERT INTO `agilemeter`.`unidad` (`OficinaId`, `UnidadNombre`) VALUES ('6', 'Centers');

#Lineas
INSERT INTO `agilemeter`.`linea` (`LineaNombre`, `UnidadId`) VALUES ('L. BigData', '2');
INSERT INTO `agilemeter`.`linea` (`LineaNombre`, `UnidadId`) VALUES ('L. CHAFEA', '2');
INSERT INTO `agilemeter`.`linea` (`LineaNombre`, `UnidadId`) VALUES ('L. Herramientas', '3');
INSERT INTO `agilemeter`.`linea` (`LineaNombre`, `UnidadId`) VALUES ('GESTOROT', '4');
INSERT INTO `agilemeter`.`linea` (`LineaNombre`, `UnidadId`) VALUES ('PGECADIS', '4');
INSERT INTO `agilemeter`.`linea` (`LineaNombre`, `UnidadId`) VALUES ('DES BMW SA3', '5');
INSERT INTO `agilemeter`.`linea` (`LineaNombre`, `UnidadId`) VALUES ('DES BID', '6');

#Equipos
INSERT INTO `agilemeter`.`proyectos` (`Fecha`, `Nombre`, `UserNombre`, `TestProject`, `LineaId`, `OficinaId`, `ProjectSize`, `UnidadId`) VALUES (NOW(), 'DES BigData UK', 'marcossa', 0,'2', '2','7', '2');
INSERT INTO `agilemeter`.`proyectos` (`Fecha`, `Nombre`, `UserNombre`, `TestProject`, `LineaId`, `OficinaId`, `ProjectSize`, `UnidadId`) VALUES (NOW(), 'DES BigData Zurich', 'marcossa', 0,'2', '2','15', '2');
INSERT INTO `agilemeter`.`proyectos` (`Fecha`, `Nombre`, `UserNombre`, `TestProject`, `LineaId`, `OficinaId`, `ProjectSize`, `UnidadId`) VALUES (NOW(), 'DES CHAFEA', 'marcossa', 0,'3', '2','11', '2');
INSERT INTO `agilemeter`.`proyectos` (`Fecha`, `Nombre`, `UserNombre`, `TestProject`, `LineaId`, `OficinaId`, `ProjectSize`, `UnidadId`) VALUES (NOW(), 'AM CTS', 'marcossa', 0,'4', '3','6', '3');
INSERT INTO `agilemeter`.`proyectos` (`Fecha`, `Nombre`, `UserNombre`, `TestProject`, `LineaId`, `OficinaId`, `ProjectSize`, `UnidadId`) VALUES (NOW(), 'GESTOROT', 'marcossa', 0,'5', '4','6', '4');
INSERT INTO `agilemeter`.`proyectos` (`Fecha`, `Nombre`, `UserNombre`, `TestProject`, `LineaId`, `OficinaId`, `ProjectSize`, `UnidadId`) VALUES (NOW(), 'PGECADIS', 'marcossa', 0,'6', '4','0', '4');
INSERT INTO `agilemeter`.`proyectos` (`Fecha`, `Nombre`, `UserNombre`, `TestProject`, `LineaId`, `OficinaId`, `ProjectSize`, `UnidadId`) VALUES (NOW(), 'DES BMW SA3', 'marcossa', 0,'7', '5','0', '5');
INSERT INTO `agilemeter`.`proyectos` (`Fecha`, `Nombre`, `UserNombre`, `TestProject`, `LineaId`, `OficinaId`, `ProjectSize`, `UnidadId`) VALUES (NOW(), 'DES BID', 'marcossa', 0,'8', '6','0', '6');

#Activamos la comprobación de las FK
SET GLOBAL FOREIGN_KEY_CHECKS=1;