# Problema a resolver

Nos encontramos que tras instanciar dos máquinas virtuales Linux en Azure, ambas a partir de la misma imagen hecha a medida incluyendo WebSphere, durante la fase de instalación de la misma aplicación con WSADMIN, en un caso concluye en un tiempo prudencial y en la otra máquina, tras 24h, acaba fallando. La única diferencia conocida, la IP asignada por Azure.

Tras establecer nivel de traza a "finer", el proceso de instalación genera un archivo de 14 millones de líneas, imposible de comparar manualmente para buscar dónde puede estar dando errores o si el proceso se mete en un bucle infinito del que no puede salir. El primer paso es intentar localizar qué operaciones están tardando más que en el caso bueno. Para ello aprovecharemos que el log deja marca de fecha/hora en la mayoría de las líneas y calcularemos la diferencia entre una fila y otra. Con suerte deberían apreciarse saltos significativos o, comparativamente, una acumulación de tiempo mayor en grupos de operaciones. La hipótesis a manejar es que, siendo la misma aplicación, el log debería respetar bloques posicionales. O sea, que salvo errores (no detectados en una primera búsqueda), la acumlación de tiempo de uno debe coincidir posicionalmente (caer en la misma posición del otro archivi).

# Solución

Script BATCH aprovechando las magníficas GoW (Gnu on Windows) que se pueden descargar e instalar desde https://github.com/bmatzelle/gow/wiki. 

El formato del archivo es el siguiente: 


-------------- 8< ---------------------------------------
************ Start Display Current Environment ************
Host Operating System is Linux, version 2.6.32-431.3.1.el6.x86_64
Java version = 1.6.0, Java Compiler = j9jit26, Java VM name = IBM J9 VM
was.install.root = /opt/IBM/WebSphere855/AppServer
user.install.root = /opt/IBM/WebSphere855/AppServer/profiles/AppSrv01
Java Home = /opt/IBM/WebSphere855/AppServer/java/jre
ws.ext.dirs = /opt/IBM/WebSphere855/AppServer/java/lib:/opt/IBM/WebSphere855/AppServer/classes:/opt/IBM/WebSphere855/AppServer/lib:/opt/IBM/WebSphere855/AppServer/installedChannels:/opt/IBM/WebSphere855/AppServer/lib/ext:/opt/IBM/WebSphere855/AppServer/web/help:/opt/IBM/WebSphere855/AppServer/deploytool/itp/plugins/com.ibm.etools.ejbdeploy/runtime
Classpath = /opt/IBM/WebSphere855/AppServer/profiles/AppSrv01/properties:/opt/IBM/WebSphere855/AppServer/properties:/opt/IBM/WebSphere855/AppServer/lib/startup.jar:/opt/IBM/WebSphere855/AppServer/lib/bootstrap.jar:/opt/IBM/WebSphere855/AppServer/java/lib/tools.jar:/opt/IBM/WebSphere855/AppServer/lib/lmproxy.jar:/opt/IBM/WebSphere855/AppServer/lib/urlprotocols.jar:/opt/IBM/WebSphere855/AppServer/deploytool/itp/batchboot.jar:/opt/IBM/WebSphere855/AppServer/deploytool/itp/batch2.jar
Java Library path = /opt/IBM/WebSphere855/AppServer/java/jre/lib/amd64/compressedrefs:/opt/IBM/WebSphere855/AppServer/java/jre/lib/amd64:/opt/IBM/WebSphere855/AppServer/lib/native/linux/x86_64/:/opt/IBM/WebSphere855/AppServer/bin:/opt/IBM/WebSphere855/AppServer/nulldllsdir:/usr/lib
Orb Version = IBM Java ORB build orb626ifx-20131212.00 (IX90136+IX90137)
Current trace specification = *=info
************* End Display Current Environment *************
[10/16/14 12:19:10:607 UTC] 00000001 ManagerAdmin  I   TRAS0017I: The startup trace state is *=info.
[10/16/14 12:19:10:917 UTC] 00000001 AbstractShell A   WASX7326I: Loaded properties file "/opt/IBM/WebSphere855/AppServer/profiles/AppSrv01/properties/wsadmin.properties"
[10/16/14 12:19:11:493 UTC] 00000001 SSLConfig     W   CWPKI0041W: One or more key stores are using the default password.
[10/16/14 12:19:11:501 UTC] 00000001 SSLConfigMana I   CWPKI0027I: Disabling default hostname verification for HTTPS URL connections.
[10/16/14 12:19:11:797 UTC] 00000001 AdminConfigCl A   WASX7208I: Validation settings in effect now: Level=HIGHEST, Cross-validation=true, Output file=/opt/IBM/WebSphere855/AppServer/profiles/AppSrv01/logs/wsadmin.valout
[10/16/14 12:19:17:449 UTC] 00000001 AbstractShell A   WASX7303I: The following options are passed to the scripting environment and are available as arguments that are stored in the argv variable: "[coinc, /tmp/coinc-ear.ear]"
[10/16/14 12:19:17:450 UTC] 00000001 AbstractShell A   WASX7091I: Executing script: "/tmp/install-app.py"
[10/16/14 12:19:18:706 UTC] 00000001 ManagerAdmin  I   TRAS0018I: The trace state has changed. The new trace state is *=info:com.ibm.*=finer.
-------------- 8< ---------------------------------------

Se aislarán primero las líneas con una fecha y luego se calculará la diferencia entre dos de ellas consecutivas para generar otro archivo que posteriormente pueda ser analizado o representado gráficamente con R o con F#.

## Script: delta_lineas.bat

Será el encargado de coger un archivo y generar, por salida estándar que puede ser redirigido, un conjunto de filas que representan las diferencias entre cada dos filas del archivo original.

## Script: componer.bat

Se le pasarán como parámetros los dos archivos de log (coloquialmente "bueno" y "malo") y se encargará de, utilizando el script anterior, generar un único archivo donde se encuentren las columnas de los dos casos. Pensado para ser suministrado a R.

## Script: bloques.bat

Buscar en el archivo generado por delta_lineas.bat aquellos casos que superen los 5 segundos y, tomando el archivo que origina el caso, generará por salida estándar bloques de 125 líneas de los casos que se han encontrado incluyendo varias lineas anteriores y posteriores. Para remitir a sistemas.

