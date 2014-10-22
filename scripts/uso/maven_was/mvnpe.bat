@echo off

call mvnp.bat %*

if %ERRORLEVEL%==0 goto DO_EXPLORE

echo Imposible compilar y empaquetar el proyecto 2&>1

EXIT /B %ERRORLEVEL%

:DO_EXPLORE

explorer %cd%\target
