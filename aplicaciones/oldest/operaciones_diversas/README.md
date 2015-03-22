# Unas pocas palabras introductorias

Esta aplicación la programé en muy poco tiempo. Al menos la parte importante. El resto del tiempo me lo pasé haciendo pequeños arreglos y correcciones, y muchos cambios. ¿Pero qué era exactamente? Corría finales del año 2001 y había pactado con la empresa jornada hiper-reducida de modo que pudiese acabar la licenciatura que justo había retomado después de 5 años abandonada. También por aquel entonces La Caja Insular de Ahorros, ahora parte de Bankia, andaba migrando todos los procesos a ATCA (Asosación Técnica de Cajas de Ahorros), montada con otras cuatro cajas, y que situaba su centro de datos y procesos en Zaragoza. Pero necesitaban incorporar un nuevo tipo de cuaderno interbancario, aún no finalizada su definición, en los procesos ATCA, pero sin poder esperar a que desde allí programasen la interfaz de usuario. Así se gesta esta aplicación, cuyas principales características eran:

- Se podrá ejecutar en cualquier Windows 95/98 (que es lo que había entonces) sin necesitar instalación. Lo que ahora se llamaría "portable".
- No podrá usar base de datos. Tirar de sistema de archivos.
- El tiempo de vida y uso estimado es de cuatro meses, así que algo que solo sirva para capturar los datos en un ordenador (o varios) y generar con ellos un archivo de intercambio bancario.
- Control de seguridad a nivel de terminal, de forma que se defina qué terminales pueden modificar/leer según qué tipos y según qué registros generados por otros terminales.
- Eso sí, pueden trabajar varias personas a la vez, dado que cubre diferentes operativas, y es necesario que haya control de qué archivos/registros se están manipulando en cada caso.

Y todo ello con la llegada del EURO.

# Algunas curiosidades.

De todo lo que programé estando en CINCA, junio 1998 a junio 2002, ésta es la única de las aplicaciones de las que he conseguido conservar el código. Tal como mencionaba al principio, fue durante un período en el que trabajaba 6 horas/semana, más horas extras. Eché algunas extras, obvio. Pero me quedaba en casa la mayor parte del tiempo trabajando. (No fue mi primera experiencia con teletrabajo). Así que todo el código lo escribí en mi portátil personal y de ahí que tenga copia de seguridad.

La aplicación la entregé a finales de noviembre de 2001 y, como comentaba antes, se esperaba no superase un tiempo de vida que venía limitado por marzo o abril de 2002, motivo por el que se suponía que no debía preocuparme demasiado de la perfección. Funcional y poco más. En mayo de 2002, poco antes de terminar mi relación con la empresa, el cliente pidió unos pocos cambios adicionales. De momento había superado el tiempo esperado de vida.

Ya hacía año y medio que había dejado CINCA, creo que durante la Navidad de 2003-2004, o tal vez ya en enero de 2004, coincidí paseando con uno de los usuarios habituales que ayudaron en la fase de pruebas de la aplicación. Aún se seguía usando y estaban encantados con ella. Para un programa que había nacido con muchas limitaciones y por quien nadie apostaba, superar los dos años de vida/uso ya fue motivo de orgullo. Causa por la que, además, encontrar esta copia de seguridad tuvo un refuerzo positivo para mi ego.

# Tecnología

Desde finales de 1996 hasta mediados de 2002 el lenguaje/entorno de programación en el que me desenvolvía mejor fue Delphi. Esta aplicación, en concreto, está escrita para ser compilada con *Delphi 6*.

Todos los datos son almacenados y manejados, además de ser controlados, utilizando el sistema de archivos con una carpeta compartida en red. Cada archivo representa un registro.

# Uso y limitaciones

Los puestos de trabajo de La Caja eran usados exclusivamente por el empleado destinado al mismo. El acceso ya era garantizado por la autenticación de la sesión. Una de las exigencias era que la aplicación no permitiría hacer uso de todas las operaciones a todos los usuarios. Es necesario configurar el puesto de trabajo, generando un archivo de configuración con un código de control que garantiza que ninguno de los parámetros ha sido modificado. Debe usarse el programa GenConfig (incluido en la carpeta de eejcutables) para generar ese archivo de inicio. Se toma el nombre de máquina como garante de que se trata de ella, por lo que el archivo debe ser generado indicando el nombre de la máquina donde se ejecutará y guardarse con ese mismo nombre.

También deben existir una serie de archivos donde habrá listados de datos que son auxiliares y que permiten, por un lado, autorrellenar descripciones, y por otro, garantizar que no se introduce un valor no admitido. Forman parte de la carpeta dbfiles.

La mecánica de trabajo es muy sencilla. Una vez iniciada la aplicación se mostrará un menú que ocupa el contenido de la ventana principal y que podrá ser usado tanto pinchando en las opciones como tecleando el número asociado a cada una. Esto básicamente copia el mecanismo diseñado por un compañero con el que monté una empresa (junto a otros cuatro) entre 1995 y 1997. Este compañero llevaba tiempo usando un estilo de menú parecido en sus programas y, además, les resultó muy natural a los trabajadores de La Caja. El trabajo diario del personal de esta entidad se basaba en una aplicación donde toda transacción venía asociada de un código que debían conocer y teclear en el único campo de texto existente. Una vez rellenado el campo se abría una ventana que ya mostraba el formulario de dicha transacción.

Poco más se puede decir de éste programa (y tampoco merece mucho la pena seguir con ello).

# Ejecutables

Dada la imposibilidad actual de conseguir una versión de Delphi 6 que permita recompilar el código, y tan solo para los curiosos, he incluido los ejecutables necesarios. Han pasado el análisis del antivirus, pero eso no es garantía de nada. Así que queda enteramente bajo tu responsabilidad el usarlos en tu ordenador.

Incluyo algunas capturas a nivel ilustrativo del aspecto que tiene la aplicación.

