@echo off

set DIR_FINAL=C:\gn\sl\arq

del /Q %DIR_FINAL%\*.*

call descargar-lba.bat lba-arq "RELEASE" %DIR_FINAL%

