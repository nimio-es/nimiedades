@echo OFF

echo Descarga finalizada de %3

if /I "%~x3" == ".EPUB" GOTO ACEPTADO

echo No tiene extensi�n EPUB, por lo que se ignorar�.
echo.

EXIT /B 0

:ACEPTADO

echo hecho>"%~dpn3.ended"