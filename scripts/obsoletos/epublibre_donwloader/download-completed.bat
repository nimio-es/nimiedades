@echo OFF

echo Descarga finalizada de %3

if /I "%~x3" == ".EPUB" GOTO ACEPTADO

echo No tiene extensión EPUB, por lo que se ignorará.
echo.

EXIT /B 0

:ACEPTADO

echo hecho>"%~dpn3.ended"