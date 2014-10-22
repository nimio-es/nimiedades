@echo off

if exist %cd%\pom.xml goto DO_MAVEN

echo No existe un archivo pom.xml en el directorio 2&>1

EXIT /B -1

:DO_MAVEN

call mvn clean install ^
 -DskipTests=true ^
 -Dlinea.base.arquitectura.scope=provided ^
 -Pjpa-base-oracle ^
 %*

EXIT /B %ERRORLEVEL%
