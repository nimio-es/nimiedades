@echo off

rem :: Coge un archivo WebSphere y atiende las líneas que tienen una fecha. Tomando dos líneas consecutivas calcula la diferencia de tiempo
rem :: desde que se imprime la primera hasta que se imprime la segunda. 

rem :: %1 El archivo de log de WebSphere que se quiere procesar.
rem :: El resultado se mostrará por salida estándar. Redirigir a un archivo para tratamiento posterior.

rem :: se trata de quedarnos primero con las líneas que cumplen tener una fecha y luego ir sustityendo y filtrando hasta que tengamos una 
rem :: representación adecuada para operar con ella aritméticamente.
cat %1^
 | grep -e "^\[.*\UTC\]"^
 | gawk "-F]" "{print $1}"^
 | gawk "-F[" "{print $2}"^
 | sed "s/ UTC//"^
 | sed "s/ /:/g"^
 | sed "s/\//:/g"^
 | awk "-F:" "BEGIN {x=0; ln=1} {if( x == 0) {mx=$1\""/\""$2\""/\""$3\""\40\""$4\"":\""$5\"":\""$6\"":\""$7; x = $2 * 86400000 + $4 * 3600000 + $5 * 60000 + $6 * 1000.0 + $7;} else {nmx=$1\""/\""$2\""/\""$3\""\40\""$4\"":\""$5\"":\""$6\"":\""$7; printf \""%%d;%%s;%%s;%%d\n\"",ln,mx,nmx,($2 * 86400000 + $4 * 3600000 + $5 * 60000 + $6 * 1000.0 + $7 * 1.0)-x;mx=nmx;x = $2 * 86400000 + $4 * 3600000 + $5 * 60000 + $6 * 1000.0 + $7 * 1.0; ln++}}"

