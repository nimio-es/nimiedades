@echo off

setLocal enableDelayedExpansion

set LBA=%1
set VERSION=%2
set DIRCOPIA=%3

if [%LBA%] == [] ( GOTO ERROR_USO )

set ARTIFACT_LBA=%LBA%

if [%VERSION%] == [] (
    set ARTIFACT_VERSION=LATEST
    GOTO CHECK_DIR
)

set ARTIFACT_VERSION=%VERSION%

:CHECK_DIR

if [%DIRCOPIA%] == [] (
    set ARTIFACT_DIRCOPIA=C:\tmp\%ARTIFACT_LBA%
    GOTO DOWNLOAD
)

set ARTIFACT_DIRCOPIA=%DIRCOPIA%

:DOWNLOAD

echo. & echo Se procede a descargar el pom de la línea base & echo. & echo.

rem Se presupone que existe la variable de entorno TEMP asociada al usuario

mkdir %TEMP%\%ARTIFACT_LBA%

call mvn org.apache.maven.plugins:maven-dependency-plugin:2.8:get ^
 -Dartifact=com.gneis.lba:%ARTIFACT_LBA%:%ARTIFACT_VERSION% ^
 -Dpackaging=pom ^
 -Ddest=%TEMP%\%ARTIFACT_LBA%\pom.xml ^
 -U

if %ERRORLEVEL% NEQ 0 GOTO ERROR_DOWNLOAD

echo. & echo Ahora se procede a recopilar todas las dependencias de tipo "provided" & echo. & echo.

rem Primero se limpia

call mvn org.apache.maven.plugins:maven-clean-plugin:2.5:clean ^
 -f %TEMP%\%ARTIFACT_LBA%\pom.xml ^
 -U

call mvn org.apache.maven.plugins:maven-dependency-plugin:2.8:copy-dependencies ^
 -f %TEMP%\%ARTIFACT_LBA%\pom.xml ^
 -U

if %ERRORLEVEL% NEQ 0 GOTO ERROR_PROVIDING

echo. & echo Ahora copiamos todos los archivos a la ruta establecida & echo. & echo.

if exist %ARTIFACT_DIRCOPIA% del /Q %ARTIFACT_DIRCOPIA%\*

xcopy %TEMP%\%ARTIFACT_LBA%\target\dependency %ARTIFACT_DIRCOPIA% /Y

echo. & echo Se eliminan los datos temporales & echo. & echo.

rmdir /S /Q %TEMP%\%ARTIFACT_LBA% 

echo. & echo. & echo Final del proceso...

exit /b 0

:ERROR_DOWNLOAD

echo. & echo. & echo SE produce un error durante el proceso de descarga 1>&2
exit %ERRORLEVEL%

:ERROR_PROVIDING

echo. & echo. & echo Se produce un error durante la fase de provisión de las dependencias 1>&2
exit %ERRORLEVEL%

:ERROR_USO

echo. & echo. & echo Debe indicar al menos el ID de la LBA a utilizar 1>&2
exit /B -1

endLocal
