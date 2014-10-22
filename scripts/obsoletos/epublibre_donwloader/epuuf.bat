@ECHO OFF

SET NUMERO=%1

REM  :: N�MERO DE SEGUNDOS QUE SE ESPERA ANTES DE DESCARTAR UNA DESCARGA (POR DEFECTO 20 MINUTOS)
SET ESPERA_DOWNLOAD=1200

REM  :: EL TIEMPO QUE SE SIRVE EL ARCHIVO UNA VEZ DESCARGADO (POR DEFECTO 10 MINUTOS)
SET SEED_TIME=10

REM  :: N�MERO DE DESCARGAS CONCURRENTES (POR DEFECTO 10)
SET DESCARGAS_PARALELO=15

ECHO NUMERO DE ARCHIVOS A DESCARGAR=%NUMERO%

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

REM  :: CREAMOS LA CARPETA DE LA OPERACI�N
MKDIR %OPERACION%

REM  :: DESCARGA LA �LTIMA VERSI�N DEL ARCHIVO DE LIBROS DE EPUBLIBRE
curl --output epublibre.zip http://ubuntuone.com/5PqcPufzQaclxGDdSEgsmI

:UNZIP_IT
REM  :: SE DESCOMPRIME
unzip epublibre.zip
DEL epublibre.zip

REM  :: EL ARCHIVO VIENE CON CABECERA, POR LO QUE HAY QUE IGNORARLA
SET /A FILAS=%NUMERO%+1

REM  :: PROCESAMOS EL ARCHIVO PARA EXTRAER LOS ENLACES
head -q -n %FILAS% epublibre.csv^
 | tail -q -n %NUMERO%^
 | awk -F\",\" "{if( index($15,\",\") == 0) {print $1\":\"$15} else {split($15,a,\", \"); for(id in a) print $1\"_\"id\":\"a[id]}}"^
 | tr -d \042^
 | awk -F: "{print \"magnet:?xt=urn:btih:\"$2\"^&dn=EPL_\"$1\"^&tr=udp://tracker.openbittorrent.com:80^&tr=udp://tracker.publicbt.com:80\"}" > %OPERACION%\lista-ultimos.txt

REM  :: LANZAMOS EL PROCESO DE DESCARGA
call aria2c -d .\%OPERACION%^
 --log=.\%OPERACION%\log-ultimos.log^
 --input-file=.\%OPERACION%\lista-ultimos.txt^
 --bt-stop-timeout=%ESPERA_DOWNLOAD%^
 --seed-time=%SEED_TIME%^
 --max-concurrent-downloads=%DESCARGAS_PARALELO%^
 --on-bt-download-complete=C:\Utils\bin\pirato\download-completed.bat

REM  :: SE PROCESAN LOS ARCHIVOS DESCARGADOS DE TIPO EPUBLIBRE

ECHO SE PROCESAR�N LOS ARCHIVOS DESCARGADOS

FOR %%F IN (.\%OPERACION%\*.ended) DO "C:\Program Files (x86)\Git\bin\sh.exe" "%~dp0\dwnlcmpl.sh" "%%~dpnF.epub"

POPD
