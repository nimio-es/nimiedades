import sys
import AdminApplication
from com.ibm.ws.exception import RedundantStateChangeException

def calcularIdAppExacto(app_name_propuesto):
	"""Funci�n para calcular el nombre exacto de la aplicaci�n cuando se pasa un car�cter de interrogaci�n al final"""

	app_name_calculado = app_name_propuesto.strip()

	# Si el nombre actual termina en interrogaci�n, habr� que buscar la aplicaci�n que empiece por �l
	if(app_name_calculado.endswith('?')):
		app_name_calculado = app_name_calculado.replace('?','')

		# Se solicita la lista de aplicaciones instaladas
		lista_aplicaciones_inicial = AdminApp.list().split('\r\n')

		lista_aplicaciones_final = []
		for aplicacion in lista_aplicaciones_inicial:
			if aplicacion.startswith(app_name_calculado):
				lista_aplicaciones_final.append(aplicacion)

		# si no existe ninguno, error
		if len(lista_aplicaciones_final) == 0: 
			print '�No hay ninguna aplicaci�n que encaje con el valor indicado!'
			return ''

		# al final debe existir solamente una aplicaci�n que coincida con el nombre indicado
		if len(lista_aplicaciones_final) > 1:
			print 'ERROR: �Hay demasiadas aplicaciones que coincidan con el prefijo indicado!'
			for aplicacion in lista_aplicaciones_final:
				print '   ' + aplicacion
			sys.exit(-1)

		# la restante se asigna al valor a devolver
		app_name_calculado = lista_aplicaciones_final[0]

	return app_name_calculado


def calcularDirectorioFinal(appname, install_folder_propuesto):
	"""Calcula la ruta de instalaci�n en el servidor destino"""

	# si no se ha pasado un interrogante como par�metro, se devuelve tal cual
	if (install_folder_propuesto.strip() != '?'): return install_folder_propuesto

	return AdminApp.view(appname, '-installed.ear.destination').split(':')[1].strip()


def calcularVirtualHost(appname, virtual_host_propuesto):
	"""Obtiene el host virtual asociado a la aplicaci�n si se ha enviado un car�cter interrogante"""

	# Esta vez es un poco m�s complejo, dado que el valor que queremos est� dentro 
	# de un app y no se accede directamente
	app_ctxroot = AdminApp.view(appname, '-MapWebModToVH').split('\r\n')

	# el valor que queremos est� repartido en los �ltimos registros
	modulo = app_ctxroot[len(app_ctxroot) - 3].split(':')[1].strip()
	uri = app_ctxroot[len(app_ctxroot) - 2].split(':')[1].strip()
	vh = app_ctxroot[len(app_ctxroot) - 1].split(':')[1].strip()

	# si no se ha enviado un interrogante, se utliza el valor propuesto
	if virtual_host_propuesto.strip() != '?': vh = virtual_host_propuesto

	# se compone el valor a usar
	return '-MapWebModToVH [[ ' + modulo + ' ' + uri  + ' ' + vh + ' ]]'


def calcularMapModulesToServers(appname):
	"""Obtiene la estructura que se debe pasar en MapModulesToServers"""

	app_mapmodules = AdminApp.view(appname, '-MapModulesToServers').split('\r\n')

	#se empieza por el final buscando el �ndice de la primera fila que no tiene :
	posicion = len(app_mapmodules)-1
	while(':' in app_mapmodules[posicion]): 
		posicion = posicion - 1

	linea_concatenada = ''

	# ajustamos porque es la siguiente a la l�nea de salida
	for i in range(posicion+1, len(app_mapmodules)):
		linea_concatenada = linea_concatenada + ' ' + ":".join(app_mapmodules[i].split(':')[1::]).strip()

	return '-MapModulesToServers [[' + linea_concatenada + ' ]]'

def calcularMetadataCompleteForModules(appname):
	"""Obtiene la estructura que se debe pasar en MetadataCompleteForModules"""

	app_metadata = AdminApp.view(appname, '-MetadataCompleteForModules').split('\r\n')

	#se empieza por el final buscando el �ndice de la primera fila que no tiene :
	posicion = len(app_metadata)-1
	while(':' in app_metadata[posicion]): 
		posicion = posicion - 1

	linea_concatenada = ''

	# ajustamos porque es la siguiente a la l�nea de salida
	for i in range(posicion+1, len(app_metadata)):
		linea_concatenada = linea_concatenada + ' ' + ":".join(app_metadata[i].split(':')[1::]).strip()

	return '-MetadataCompleteForModules [[' + linea_concatenada + ' ]]'



def obtenerBuildVersionActual(appname):
	"""Devuelve la versi�n de la construcci�n actual"""

	return AdminApp.view(appname, '-buildVersion').split(':')[1].strip()


def actualizarAplicacionCompleta(appname, binpath):
	"""Instala el archivo se�alado como una aplicaci�n completa"""

	install_folder='?'
	virtual_host='?'

	final_app_name = appname
	final_bin_path = binpath
	final_install_folder = calcularDirectorioFinal(final_app_name, install_folder)
	final_virtual_host = calcularVirtualHost(final_app_name, virtual_host)
	final_process_mgr = calcularMapModulesToServers(final_app_name)
	final_metadata_modules = calcularMetadataCompleteForModules(final_app_name)

	print 'Par�metros de ejecuci�n (tras evaluaci�n de los casos no indicados):'
	print '   Nombre aplicaci�n: ' + final_app_name
	print '   Binario a instalar: ' + final_bin_path
	print '   Directorio instalaci�n final: ' + final_install_folder
	print '   Virtual Host: ' + final_virtual_host
	print '   Proceso de servidor: ' + final_process_mgr
	print '   Esquema de metadatos: ' + final_metadata_modules
	print '-------------------------------------------------------------------------'

	datos_operacion = '[ -operation update ' \
		+ '-contents "' + final_bin_path + '" ' \
		+ '-nopreCompileJSPs ' \
		+ '-installed.ear.destination ' + final_install_folder + ' ' \
		+ '-distributeApp ' \
		+ '-useMetaDataFromBinary ' \
		+ '-deployejb ' \
		+ '-createMBeansForResources ' \
		+ '-noreloadEnabled ' \
		+ '-nodeployws ' \
		+ '-validateinstall warn ' \
		+ '-noprocessEmbeddedConfig ' \
		+ '-filepermission .*\.dll=755#.*\.so=755#.*\.a=755#.*\.sl=755 ' \
		+ '-noallowDispatchRemoteInclude ' \
		+ '-noallowServiceRemoteInclude ' \
		+ '-asyncRequestDispatchType DISABLED ' \
		+ '-useAutoLink ' \
		+ '-noenableClientModule ' \
		+ '-novalidateSchema ' \
		+ final_virtual_host + ' ' \
		+ final_metadata_modules + ' ' \
		+ final_process_mgr + ' ' \
		+ ']'

	print '\n\nLa operaci�n que se lanzar� es:'
	print "AdminApp.update( " + final_app_name + ", 'app', '" + datos_operacion + "')"

	print '\n\nProcesando...\n'

	try:
		AdminApp.update(final_app_name, 'app', datos_operacion)

		print '\nGuardando los cambios...\n'
		AdminConfig.save();

		# ahora se lee informaci�n de estado
		print '\nLeer el estado tras el despliegue...\n'
		isAppReady = AdminApp.isAppReady(final_app_name);
		status = AdminApp.getDeployStatus(final_app_name);

	except:
		( kind, value ) = sys.exc_info()[ :2 ]
		( kind, value ) = str( kind ), str( value )
		print 'Exception type-' + kind
		print 'Exception value-' + value
		sys.exit(1)

	print '\n-------------------------------------------------------------------------'
	print 'Deploy status:' + status
	print 'isAppReady:' + isAppReady
# ------------------------------------------------


def actualizarModuloAplicacion(modulename, binpath):
	"""Entonces de lo que se trata es de instalar un m�dulo en una aplicaci�n."""

	# por convenci�n el nombre de todos los m�dulos se compone del nombre de aplicaci�n
	# separado por un gui�n del nombre del m�dulo en s� mismo.
	ear_name = modulename.split('-')[0]

	# Pero no porque tengamos el nombre la aplicaci�n debe existir. Preguntamos
	if not AdminApplication.checkIfAppExists(ear_name):
		print "ERROR: No existe un EAR con el nombre seg�n convenci�n"
		sys.exit(1)

	# si existe directamente a�adimos o actualizamos 
	# por convenci�n la segunda parte del nombre debe ser el contextroot
	context_root = modulename.split('-')[1]

	AdminApplication.addUpdateSingleModuleFileToAnAppWithUpdateCommand(ear_name, binpath, modulename + '.war', '/' + context_root)

	## preguntamos si todo va bien
	print '\nGuardando los cambios...\n'
	AdminConfig.save();

	# ahora se lee informaci�n de estado
	print '\nLeer el estado tras el despliegue...\n'
	isAppReady = AdminApp.isAppReady(ear_name);
	status = AdminApp.getDeployStatus(ear_name);

	print '\n-------------------------------------------------------------------------'
	print 'Deploy status:' + status
	print 'isAppReady:' + isAppReady
# ------------------------------------------------



# ##################################################################################
# Main Main Main Main Main Main Main Main Main Main Main Main Main Main Main Main 
# ##################################################################################

print '\n\n-------------------------------------------------------------------------'
print 'SCRIPT JYTHON PARA SOPORTE DE DESPLIEGUE BASADO EN B�SQUEDA DE PARAMETROS'
print '-------------------------------------------------------------------------'

# Al menos deben llegar dos par�metros
if len(sys.argv) < 2:
	print 'ERROR: �No llegan al menos dos par�metros!'
	sys.exit(-1)

# leemos los par�metros pasados a la aplicaci�n
app_name=sys.argv[0]
bin_path=sys.argv[1]

print 'Par�metros de entrada:'
print '   Nombre aplicaci�n/m�dulo: ' + app_name
print '   Binario a instalar: ' + bin_path
print '-------------------------------------------------------------------------'

c_app_name = calcularIdAppExacto(app_name)

# Hay que contemplar el caso en que lo que haya que instalar sea un m�dulo, caso 
# en que el m�todo anterior devolver�a una cadena vac�a.
if c_app_name!='':
	actualizarAplicacionCompleta(c_app_name, bin_path)
else:
	actualizarModuloAplicacion(app_name.replace('?',''), bin_path)

print '-------------------------------------------------------------------------'
print 'SCRIPT JYTHON FINALIZADO'
print '-------------------------------------------------------------------------'
sys.exit(0)