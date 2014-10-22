# Aclaración:

El software aquí provisto no tiene garantía alguna. Úsalo bajo tu entera responsabilidad.

# Motivación

Trabajando para Gneis (https://www.gneis.bankinter.com/) como externo tenía que hacer innumerables pruebas en servidores WebSphere de los cambios que iba realizando en las aplicaciones. Para no andar con la consola, he realizado una serie de scripts que faciliten el empaquetado y despliegue de un WAR. Además de algunas otras utilidades.

La arquitectura establecida usaba también librerías compartidas en WebSphere (Shared Libraries). Éstas se definián como un pom.xml cuyo empaquetado es de tipo pom y que se deben descargar en una carpeta determinada.

# Dependencias

* Script WSADMIN, que se instala junto con WebSphere: http://www-01.ibm.com/software/es/websphere/
* Maven: http://maven.apache.org/
* GNU On Windows: https://github.com/bmatzelle/gow/wiki

# Scripts

## descargar-lba.bat

Genérico para descargar las librerías compartidas a partir de un pom.xml de tipo pom.

Uso:

    descargar-lba LBA VERSION DIR

Donde:

* LBA es el nombre del artefacto que contiene las dependencias que componen ese conjunto de librerías compartidas.
* VERSION el número de versión que se quiere instalar
* DIR directorio final donde se copiarán los elementos descargados

## lbal.bat

Específico para descargar la última versión de una LBA (Librería Compartida) fija. Usa el anterior.

## lbar.bat 

Específico para descargar la última RELEASE de una LBA (Librería Compartida) fija. Usa el anterior.

## lbav.bat 

Específico para descargar una versión determinada de una LBA (Librería Compartida) fija. Usa el anterior.

Uso:

    lbav VERSION

Donde:

* VERSION: Versión de el conjunto "lba-arq" que se quiere instalar.

## m2p.bat

Elimina todo el software de la casa (empaquetados como com.gneis) del directorio .m2

## mij.bat

Instala en la caché local una librería (.JAR).

Se debe ejecutar en la carpeta donde se encuentre el pom.xml del empaquetado JAR.

## mvnp.bat

Compila un proyecto de tipo WAR con los parámetros habituales para entornos WebSphere.

Se debe ejecutar en la carpeta donde se encuentre el pom.xml del empaquetado WAR.

## mvnpe.bat 

Usa el anterior, para compilar y empaquetar y abre una ventana del explorador de Windows para mostrar la carpeta target.

Se debe ejecutar en la carpeta donde se encuentre el pom.xml del empaquetado WAR.

## mvnpw.bat 

Como el anterior, empaqueta, pero despliega en WebSphere usando WSADMIN y el script Python que se encuentra en la subcarpeta was_deploy.

Se debe ejecutar en la carpeta donde se encuentre el pom.xml del empaquetado WAR.

