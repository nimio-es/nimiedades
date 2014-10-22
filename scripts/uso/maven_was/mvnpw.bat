@echo off

if "%WAS_HOME%"=="" goto :SINWASHOME

ECHO *** Necesario disponer de una herramienta como GREP.

where /q grep 

if %ERRORLEVEL%==0 goto COMPILAR

ECHO No hay grep instalado en el sistema, por lo que no podemos comprobar si el servidor está en marcha. ¿Por qué no te intalas Gow? 2&>1

EXIT /B -1

:COMPILAR

rem -------------------------------------------------------------------------
rem COMPILAMOS EL PAQUETE
rem -------------------------------------------------------------------------

call mvnp.bat %*

if %ERRORLEVEL%==0 goto DO_WAS

echo Imposible compilar y empaquetar el proyecto 1>&2

EXIT /B %ERRORLEVEL%

:SINWASHOME

echo No hay una variable de entorno WAS_HOME definida 1>&2

EXIT /B -1

rem -------------------------------------------------------------------------
rem DESPLEGAMOS
rem -------------------------------------------------------------------------

:DO_WAS


echo. & echo. & echo Vamos a invocar el proceso de despliegue:

SET EXCLUDE_PATTERN="^\[INF|^\[WAR|Down"

rem  :: obtenemos el nombre (para llamar al script de despliegue)
mvn help:evaluate -Dexpression=project.name | grep -v -E %EXCLUDE_PATTERN% | tr -d \r\n > %TMP%\variable.txt
SET /p APPNAME= < %TMP%\variable.txt

rem  :: obtenemos el nombre del directorio final
mvn help:evaluate -Dexpression=project.build.directory | grep -v -E %EXCLUDE_PATTERN% | tr -d \r\n > %TMP%\variable.txt
SET /p TARGET= < %TMP%\variable.txt

rem  :: el nombre del componente compilado
mvn help:evaluate -Dexpression=project.build.finalName | grep -v -E %EXCLUDE_PATTERN% | tr -d \r\n > %TMP%\variable.txt
SET /p FINALNAME= < %TMP%\variable.txt

rem  :: el empaquetado
mvn help:evaluate -Dexpression=project.packaging | grep -v -E %EXCLUDE_PATTERN% | tr -d \r\n > %TMP%\variable.txt
SET /p PACKAGE= < %TMP%\variable.txt


echo App name: %APPNAME%
echo Directorio target: %TARGET%
echo Nombre componente: %FINALNAME%
echo Tipo de empaquetado: %PACKAGE%

IF "%PACKAGE%" NEQ "war" (ECHO NO ES DE TIPO WAR 1>&2 & EXIT /B -1)

call %WAS_HOME%\profiles\AppSrv01\bin\setupCmdLine.bat

call %WAS_HOME%\bin\wsadmin.bat -f %~dp0\was_deploy\deploy-ng.py %FINALNAME%? %TARGET:\=/%/%FINALNAME%.%PACKAGE%

