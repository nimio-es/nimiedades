@echo off

rem :: el funcionamiento es tremandamente tonto, dado que nos bsaremos en el script hermano: isdir. 
rem :: si no es un directorio, entonces es una archivo. Simple, ¿eh?

rem :: aunque supone un problema utilizar ERRORLEVEL para comunicar resultado y para gestionar
rem :: errores, diremos que devolverá 1 si no es un archivo y -1 si hay errores de lógica (falta
rem :: parámetro.)

call :debug " "
call :debug "%~nx0"
call :debug "Parámetro de entrada: %~1"
call :debug "Ruta completa: %~dpnx1"


rem :: en caso de ser un fichero, se indicará en la variable de entorno ISFILE_RESULT y como salida 
rem :: consola. También como ERRORLEVEL = 0. 

rem :: se comprueba el parámetro 
if "%~1" equ "" echo No se ha indicado parámetro 1>&2 & exit /b -1

call :debug " "
call :debug "Llamamos al script isdir.bat"

call isdir.bat "%~dpnx1">NUL
rem  :: no es un directorio
if %ERRORLEVEL% equ 1 (
	set ISFILE_RESULT=1 
	call :debug "--- fin: %~nx0 ---"
	echo 1 
	exit /b 0
)

rem  :: sí es un directorio
set ISFILE_RESULT=0
call :debug "--- fin: %~nx0 ---"
echo 0
exit /b 1

rem :: comprueba si estamos en modo debug y muestra por pantalla lo que se le indique
:debug 
setlocal
for /f "delims=" %%d in ('date /t') do set TMP_INTERNAL_DEBUG_DATE=%%d
for /f "delims=" %%t in ('time /t') do set TMP_INTERNAL_DEBUG_TIME=%%t
if "%IN_DEBUG_MODE%" equ "1" echo [DEBUG] [%TMP_INTERNAL_DEBUG_DATE% %TMP_INTERNAL_DEBUG_TIME%] %~1
endlocal
goto :eof
