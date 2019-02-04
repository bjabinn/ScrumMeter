--Creamos la columna de PesoNivel1
ALTER TABLE agilemeter.sections
ADD PesoNivel1 int(11);

--Creamos la columna de PesoNivel2
ALTER TABLE agilemeter.sections
ADD PesoNivel2 int(11);

--Creamos la columna de PesoNivel3
ALTER TABLE agilemeter.sections
ADD PesoNivel3 int(11);

--Insertamos el valor del peso de Nivel 1
UPDATE agilemeter.sections
SET PesoNivel1=60;

--Insertamos el valor del peso de Nivel 2
UPDATE agilemeter.sections
SET PesoNivel2=25;

--Insertamos el valor del peso de Nivel 3
UPDATE agilemeter.sections
SET PesoNivel3=15;



