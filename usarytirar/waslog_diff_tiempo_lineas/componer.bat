@echo off

rem :: se tratra de componer un archivo a partir del resultado obetnido de las diferencias del archivo log "bueno" y el archivo "log" malo, 
rem :: rutas pasadas como parámetros del script. Se hará uso del script que calcula las deltas de las líneas y, con el resutlado de las diferencias
rem :: se compondrá un único archivo conteniendo todas las columnas. Pensado para luego procesar con R o con F# para mostrar una gráfica.

rem :: %1 

echo Calcular las diferencias del log que representa el despliegue bueno...

call "%~dp0delta_lineas.bat" %1 >"%~dp1tiempos-buenos.txt"

echo Calcular las diferencias del log que representa el despliegue problemático...

call "%~dp0delta_lineas.bat" %2 >"%~dp2tiempos-malos.txt"

echo unimos los dos en un único archivo

echo bueno.linea;bueno.stampanterior;bueno.stampactual;bueno.diffmils;malo.linea;malo.stampanterior;malo.stampactual;malo.diffmils>%3

pr -m -T -s; "%~dp1tiempos-buenos.txt" "%~dp2tiempos-malos.txt"|sed "s/^;/;;;;/"|sed "s/;$/;;;;/">>%3
