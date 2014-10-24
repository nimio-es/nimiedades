@echo off

rem  :: el funcionamiento es tan tonto como intentar solicitar el contenido del directorio pero solamente de las carpetas
rem  :: y contar el número de coincidencias.

rem  :: es complicado utilizar el mismo sistema de ERRORLEVEL para indicar una excepción o que no es un directorio,
rem  :: pero vamos a utilizar un valor negativo para indicar un error de llamada, mientras que 1 para indicar que 
rem  :: no se trata de una carpeta o directorio, sino de un archivo. Además se utilizará la variable ISDIR_RESULT para indicar 
rem  :: si es o no es, usando lógica diferente a ERRORLEVEL: 0 = no es directorio, 1 = sí es directorio.
rem  :: Además, tmabién se mostrará en pantalla ese valor, para procesos que quieran usar la salida en lugar de la variable.

rem :: se comprueba el parámetro 
if "%~1" equ "" echo No se ha indicado parámetro 1>&2 & exit /b -1

call :debug " "
call :debug "--- %~nx0 ---"
call :debug "Parámetro de entrada: %~1"
call :debug "Ruta: %~dp1"
call :debug "Final: %~nx1"

set ISDIR_CHECK_PATH=%~1

rem  :: hay que evitar problemas cuando la ruta termina con el carácter de separación
if %ISDIR_CHECK_PATH:~-1%==\ set ISDIR_CHECK_PATH=%ISDIR_CHECK_PATH:~0,-1%

rem  :: hacemos la búsqueda 
set ISDIR_TEMPORAL_C=0
set ISDIR_RESULT=0
for /f "delims=" %%d in ('echo "%ISDIR_CHECK_PATH%"') do for /f "delims=" %%c in ('dir /ad /b "%%~dpd" ^| grep -i -c -w -s "%%~nxd"') do set ISDIR_TEMPORAL_C=%%c

call :debug "Coincidencias encontradas: %ISDIR_TEMPORAL_C%"

if %ISDIR_TEMPORAL_C% neq 0 goto yes_it_is

rem :: -- no es una carpeta --
call :debug "No se toma como directorio"
rem :: limpiamos las variables temporales
set ISDIR_TEMPORAL_C=
set ISDIR_CHECK_PATH=
rem :: fijamos el resultado y salimos
set ISDIR_RESULT=0
call :debug "ISDIR_RESULT=%ISDIR_RESULT%"
call :debug "--- fin: %~nx0 ---"
echo 0
exit /b 1

rem :: se trata de un directorio
:yes_it_is
call :debug "Se establece como directorio"
rem :: limpiamos las variables temporales
set ISDIR_TEMPORAL_C=
set ISDIR_CHECK_PATH=
rem :: fijamos el resultado y salimos
set ISDIR_RESULT=1
call :debug "ISDIR_RESULT=%ISDIR_RESULT%"
call :debug "--- fin: %~nx0 ---"
echo 1
exit /b 0


rem :: comprueba si estamos en modo debug y muestra por pantalla lo que se le indique
:debug 
setlocal
for /f "delims=" %%d in ('date /t') do set TMP_INTERNAL_DEBUG_DATE=%%d
for /f "delims=" %%t in ('time /t') do set TMP_INTERNAL_DEBUG_TIME=%%t
if "%IN_DEBUG_MODE%" equ "1" echo [DEBUG] [%TMP_INTERNAL_DEBUG_DATE% %TMP_INTERNAL_DEBUG_TIME%] %~1
endlocal
goto :eof
