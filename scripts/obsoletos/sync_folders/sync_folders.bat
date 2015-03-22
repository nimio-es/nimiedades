@echo off

rem :: -------------------
rem :: Sincroniza dos directorios.
rem :: Si en el directorio existe un archivo de nombre _no_sync_ se ignorará.
rem :: Solamente copia los archivos que hayan sido modificados. 
rem :: -------------------
rem :: %1 directorio origen o mandatorio
rem :: %2 directorio destino 
rem :: -------------------
rem :: Códigos de error (ERRORLEVEL):
rem ::  0 : Concluye correctamente.
rem :: 10 : No se ha indicado el directorio origen.
rem :: 11 : El directorio origen no existe.
rem :: 12 : El directorio origen no es un directorio.
rem :: 20 : No se ha indicado el directorio destino.
rem :: 21 : El directorio destino no existe.
rem :: 22 : El directorio destino no es un directorio.
rem :: 66 : Se produce algún error durante las operaciones de sincronización.
rem :: -------------------
rem :: Necesarias las utilidades GNU on Windows.
rem :: -------------------

rem :: se comprueba que se hayan indicado parámetros, que éstos existan y son del tipo correcto
if "%~1" equ "" call :error "No se ha indicado el directorio de origen" & exit /b 10
if "%~2" equ "" call :error "No se ha indicado el directorio de destino" & exit /b 20
if not exist %~1 call :error "La ruta de directorio origen no existe" & exit /b 11
if not exist %~2 call :error "La ruta de directorio destino no existe" & exit /b 21
call isdir.bat "%~dpnx1">NUL
if %ERRORLEVEL% neq 0 call :error "La ruta origen no se trata de un directorio" & exit /b 12
call isdir.bat "%~dpnx2">NUL 
if %ERRORLEVEL% neq 0 call :error "La ruta destino no se trata de un directorio" & exit /b 22
rem :: ---

setlocal enableDelayedExpansion

rem :: --- algo de depuración --
call :debug " "
call :debug "--- %~nx0 ---"
call :debug "Directorio origen: %~dpnx1"
call :debug "Directorio destino: %~dpnx2"

rem :: conservamos el directorio actual
set CURRENT_DIR_TEMPORAL=%CD%

rem :: El proceso se divide en dos partes

rem :: Primero eliminamos en destino todo lo que no exista en origen
call :debug "Revisar si hay elemengos que eliminar"
rem :: Como el proceso es recursivo solamente antedemos al nivel actual
for /f "delims=" %%e in ('dir /b "%~dpnx2"') do (
	call :debug "Elemento: %%e, ruta %~dpnx2\%%e"

	rem :: confirmamos si tiene que ser eliminado o no si existe o no en el origen
	if not exist "%~dpnx1\%%e" (
		call :debug "El elemento no existe en directorio origen."
		rem :: en caso de directorios hay que tener cuidado para no eliminar los que no deben ser sincronizados
		call isdir.bat "%~dpnx2\%%e"
		if !ERRORLEVEL! equ 0 (
			if not exist "%~dpnx2\%%e\_no_sync_" (
				call :debug "Eliminar directorio %~dpnx2\%%e" 
				rm -rf "%~dpnx2\%%e") else (call :info "El directorio %~dpnx2\%%e está marcado para no ser sincronizado.")
		) else (
			call :debug "Eliminar archivo %~dpnx2\%%e"
			rm -f "%~dpnx2\%%e"
		)
	) else (
		call :debug "Existe en el origen. No se borra."
	)
)

rem :: el segundo paso es copiar desde el origen todo lo que no exista
call :debug "Revisar si hay elemengos nuevos o modificados"
rem :: en destino o haya cambiado
for /f "delims=" %%e in ('dir /b "%~dpnx1"') do (
	call :debug "Elemento: %%e, ruta %~dpnx1\%%e"

	rem :: confirmamos si existe ya en el destino.
	if not exist "%~dpnx2\%%e" (
		call :info "El elemento %~dpnx2\%%e no existe en directorio destino."
		rem :: no existe, directamente copiamos
		rem :: salvo que se trate de un directorio y expresamente hayamos pedido que no se copie.
		call isdir.bat  "%~dpnx1\%%e"
		if !ERRORLEVEL! equ 0 (
			if not exist "%~dpnx1\%%e\_no_sync_" (
				call :debug "Debemos copiar completamente el directorio %~dpnx1\%%e en destino"
				call :debug "Creamos la carpeta en destino %~dpnx2\%%e"
				mkdir "%~dpnx2\%%e"
				call :debug "Invocación recursiva al script"
				call "%~dpnx0" "%~dpnx1\%%e" "%~dpnx2\%%e"
			) else (
			    call :info "No se sincronizará el directorio %~dpnx1\%%e"
			)
		) else (
			call :debug "Copiar el archivo nuevo: %~dpnx1\%%e"
			cp -f --preserve=mode,timestamps "%~dpnx1\%%e" "%~dpnx2\%%e"
		)
	) else (
		call :debug "Ya hay una versión %~dpnx2\%%e en el directorio de destino."
		rem :: si se trata de un directorio, entonces hay que llamar al mismo script de forma recursiva para que procese esa carpeta
		call isdir.bat "%~dpnx1\%%e"
		if !ERRORLEVEL! equ 0 (
			if not exist "%~dpnx1\%%e\_no_sync_" (
				if not exist "%~dpnx2\%%e\_no_sync_" (
					call :debug "Se trata de una carpeta, por lo que necesitamos proceder de forma recursiva."
					call "%~dpnx0" "%~dpnx1\%%e" "%~dpnx2\%%e"
				) else (
					call :info "El directorio destino tiene %~dpnx2\%%e establecido que no sea sincronizado."
				)
			) else (
			    call :info "No se sincronizará el directorio %~dpnx1\%%e"
			)			
		) else (
			call :debug "Necesario comparar ambos archivos para confirmar diferencias"
			for /f "delims=" %%v in ('diff --binary -q -s "%~dpnx1\%%e" "%~dpnx2\%%e" ^| grep -c "differ"') do (
				if %%v neq 0 (
					call :info "Versiones distintas del archivo %%e. Se actualizará en %~dpnx2\%%e"
					cp -f --preserve=mode,timestamps "%~dpnx1\%%e" "%~dpnx2\%%e"
				) else (
					call :debug "Los archivos son identicos. Innecesario actualizar."
				)
			)
		)
	)
)

rem :: volvemos al directorio de origen
cd %CURRENT_DIR_TEMPORAL%

call :debug "--- fin: %~nx0 ---"

endlocal

rem :: todo ok
exit /b 0

rem :: ------------------------------------
rem :: comprueba si estamos en modo debug y muestra por pantalla lo que se le indique
:debug 
setlocal
if "%IN_DEBUG_MODE%" neq "1" goto :eof
for /f "delims=" %%d in ('date /t') do set TMP_INTERNAL_DEBUG_DATE=%%d
for /f "delims=" %%t in ('time /t') do set TMP_INTERNAL_DEBUG_TIME=%%t
echo [DEBUG] [%TMP_INTERNAL_DEBUG_DATE% %TMP_INTERNAL_DEBUG_TIME%] %~1
endlocal
goto :eof

rem :: muestra mensaje de información
:info 
setlocal
for /f "delims=" %%d in ('date /t') do set TMP_INTERNAL_INFO_DATE=%%d
for /f "delims=" %%t in ('time /t') do set TMP_INTERNAL_INFO_TIME=%%t
echo [INFO] [%TMP_INTERNAL_INFO_DATE% %TMP_INTERNAL_INFO_TIME%] %~1
endlocal
goto :eof

rem :: muestra mensaje de error
:error 
setlocal
for /f "delims=" %%d in ('date /t') do set TMP_INTERNAL_ERROR_DATE=%%d
for /f "delims=" %%t in ('time /t') do set TMP_INTERNAL_ERROR_TIME=%%t
echo [DEBUG] [%TMP_INTERNAL_ERROR_DATE% %TMP_INTERNAL_ERROR_TIME%] %~1 1>&2
endlocal
goto :eof