# Aclaración importante: **Leer antes de usar**

No proveo, ni he provisto nunca, enlace alguno para descargar contenido sujeto a derechos de autor, **sin conocimiento o autorización del autor**, y que estuviese en un ordenador o sistema informático de mi propiedad ni de terceros. Los enlaces que se encuentran en estos scripts son, en el momento de publicar los mismos, **innaccesibles o están en deshuso**. El caso particular de la página http://epublibre.org, sigue funcionando, pero no representa descarga directa de ningún contenido, sino un portal donde se pueden encontrar los mismos y que será un acto consciente y libre el de aquel que decida seguirlo y utilizarlo, nunca reprochable en forma de delito a quien aquí lo relaciona. Asimismo el autor de estos scripts no tiene nada que ver con la página referida, ni comercial ni personalmente. Estos scripts deben tomarse como un entretenimiento y aquel que los utilice lo hará bajo su propia responsabilidad y bajo la legislación que esté vigente en ese momento sin por ello caber responsabilidad ni penal ni civil del autor, el que esto escribe, quien los publica simplemente por hacerlos públicos y como ejercicio de construcción de los mismos. La consulta, descarga y/o uso de los mismos implica la aceptación de cualquier descarga de responsabilidad por mi parte. Asimismo **no cabe garantía alguna de funcionamiento**.

## Objeto y descripción

Lo lanzaba una vez cada 10 o 15 días. Descargaba un archivo CSV con la lista de todos los libros disponibles en epublibre.org y lanzaba aria2c para descargar pasándole la ruta magnetlink. Luego los añadía a Calibre utilizando el api python que ofrece.

## Dependencias

* Gnu On Windows: https://github.com/bmatzelle/gow/wiki
* aria2c: http://aria2.sourceforge.net/
* Calibre: http://calibre-ebook.com/
* Git: http://git-scm.com/download/win (porque trae shell sh)

## Uso

Hay dos scripts BAT principales.

* epuuf.bat
* epuff.bat

Además hay dos scripts auxiliares:

* download-completed.bat
* dwnlcmpl.sh

### epuuf.bat

Descarga los primeros N (parámetro) libros que se encuentran en el archivo descargado con la lista de libros. 

Por ejemplo:

    epuuf.bat 100

descargará los primeros 100 libros que aparezcan en el listado.

### epuff.bat 

Descarga todos los libros que cumplan un filtro pasado por parámetro.

Por ejemplo:

    epuff.bat Reverte 

descargará todos los libros en cuyo título o autor aparezca la palabra "reverte".
