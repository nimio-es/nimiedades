@echo off

rem :: Este script toma el resultado de los tiempos asociado a un log y la ruta del wsadmin.traceout asociado y, 
rem :: en aquellos casos en que se supera una cantidad de tiempo determinada (5 segundos) se sacará un bloque de
rem :: 125 líneas para ser estudiado.

rem :: %1 ruta wsadmin.traceout
rem :: %2 ruta tiempos.txt
rem :: El resultado se escribirá en salida estándar. Redirigir si es necesario almacenar.

set TEMP_FILE_GRUPOS=%TEMP%\los-peores.txt

awk "-F;" "{if($4 > 30000) { printf \""%%s\n\"",$2}}" %2 >%TEMP_FILE_GRUPOS%

cat %TEMP_FILE_GRUPOS%

for /f "delims=" %%d in (%TEMP_FILE_GRUPOS%) do (
	echo -------------- %%d ------------------
   	grep -m 10 -B 25 -A 100 -e "%%d" %1
   	echo. & echo.
)

rem :: no dejar suciedad
del %TEMP_FILE_GRUPOS%
