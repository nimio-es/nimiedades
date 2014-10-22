@ECHO OFF

SET FILTRO=%~1

REM  :: NÚMERO DE SEGUNDOS QUE SE ESPERA ANTES DE DESCARTAR UNA DESCARGA (POR DEFECTO 20 MINUTOS)
SET ESPERA_DOWNLOAD=1200

REM  :: EL TIEMPO QUE SE SIRVE EL ARCHIVO UNA VEZ DESCARGADO (POR DEFECTO 10 MINUTOS)
SET SEED_TIME=2

REM  :: NÚMERO DE DESCARGAS CONCURRENTES (POR DEFECTO 10)
SET DESCARGAS_PARALELO=15

ECHO FILTRO A APLICAR: %FILTRO%

REM  :: Y NOS POSICIONAMOS EN LA CARPETA TEMPORAL
PUSHD %TMP%

REM  :: SI NO EXISTE LA CARPETA EPUBLIBRE, LA CREAMOS
IF NOT EXIST EPUBLIBRE MKDIR EPUBLIBRE
CD .\EPUBLIBRE

SET OPERACION=1
:LOOP
IF NOT EXIST %OPERACION% GOTO LIMPIA

SET /A OPERACION=%OPERACION%+1
GOTO LOOP

:LIMPIA
REM  :: SE BORRA LA COPIA ANTERIOR (SI EXISTE)
IF EXIST epublibre.csv DEL epublibre.csv
IF EXIST epublibre.zip GOTO UNZIP_IT

REM  :: CREAMOS LA CARPETA DE LA OPERACIÓN
MKDIR %OPERACION%

REM  :: DESCARGA LA ÚLTIMA VERSIÓN DEL ARCHIVO DE LIBROS DE EPUBLIBRE
curl --output epublibre.zip http://ubuntuone.com/5PqcPufzQaclxGDdSEgsmI

:UNZIP_IT
REM  :: SE DESCOMPRIME
unzip epublibre.zip
DEL epublibre.zip

REM  :: PROCESAMOS EL ARCHIVO PARA EXTRAER LOS ENLACES
grep -i "%FILTRO%" epublibre.csv^
 | awk -F\",\" "{if( index($15,\",\") == 0) {print $1\":\"$15} else {split($15,a,\", \"); for(id in a) print $1\"_\"id\":\"a[id]}}"^
 | tr -d \042^
 | awk -F: "{print \"magnet:?xt=urn:btih:\"$2\"^&dn=EPL_\"$1\"^&tr=udp://tracker.openbittorrent.com:80^&tr=udp://tracker.publicbt.com:80\"}" > %OPERACION%\lista-filtro.txt

REM  :: LANZAMOS EL PROCESO DE DESCARGA
call aria2c -d .\%OPERACION%^
 --log=.\%OPERACION%\log-filtro.log^
 --input-file=.\%OPERACION%\lista-filtro.txt^
 --bt-stop-timeout=%ESPERA_DOWNLOAD%^
 --seed-time=%SEED_TIME%^
 --max-concurrent-downloads=%DESCARGAS_PARALELO%^
 --on-bt-download-complete=C:\Utils\bin\pirato\download-completed.bat

REM  :: SE PROCESAN LOS ARCHIVOS DESCARGADOS DE TIPO EPUBLIBRE

ECHO SE PROCESARÁN LOS ARCHIVOS DESCARGADOS

FOR %%F IN (.\%OPERACION%\*.ended) DO "C:\Program Files (x86)\Git\bin\sh.exe" "%~dp0dwnlcmpl.sh" "%%~dpnF.epub"

POPD
