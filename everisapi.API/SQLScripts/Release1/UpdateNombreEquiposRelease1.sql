--Se agrega el equipo BlackOps al nombre del proyecto
UPDATE agilemeter.proyectos 
SET NOMBRE = concat(NOMBRE, ' - BlackOps')
WHERE NOMBRE in ('TESCO');