#!"C:\Program Files (x86)\Gow\bin\bash.exe"

echo
echo "PROCESAR EL ARCHIVO $1"
echo

# SACAMOS LOS METADATOS DEL ARCHIVO
ebook-meta --to-opf=metadata.opf "$1">datos-libro.txt

# COGEMOS TITULO Y AUTOR
titulo=`grep -i "Title" datos-libro.txt | awk '-F: ' '{print $2}'`
autor=`grep -i "Author" datos-libro.txt | awk '-F: ' '{if (index($2,"[") >0) {print substr($2,1,index($2,"[")-2)} else {print $2}}'`

echo "-------------------"
echo "Autor: $autor"
echo "Título: $titulo"
echo "-------------------"

libreria="\\\\NIMIONAS1\\Libros\\Narrativa"

# BUSCAMOS SI EXISTE YA EL LIBRO PARA ESE AUTOR
busqueda="title:\"=$titulo\" and authors:\"=$autor\""
echo $busqueda
idlibro=`calibredb list --search="$busqueda" --with-library=$libreria | grep -v -i "id" | awk '{print $1}'`

# COMPROBAR SI YA EXISTE

echo "ID=$idlibro"

if [ -n "$idlibro" ] 
then

	echo "El libro $titulo del autor $autor ya existe en la base de datos de libros: hay que actualizar."

	calibredb add_format --with-library=$libreria $idlibro "$1"

	# Y LOS METADATOS
	calibredb set_metadata --with-library=$libreria $idlibro metadata.opf

	# EXTRAEMOS LA CAR?TULA
	ebook-meta --get-cover=cover.jpg "$1"

	# Y SE LA A?DIMOS
	calibredb set_metadata --with-library=$libreria -f cover:cover.jpg $idlibro

else

	echo "El libro $titulo del autor $autor no existe en la base de datos de libros. Se buscará solamente por título."

	busqueda="title:\"=$titulo\""
	idlibro=`calibredb list --search="$busqueda" --with-library=$libreria | grep -v -i "id" | awk '{print $1}'`

	if [ -n "$idlibro" ]
	then

		echo "Se ha encontrado otro libro con el título $titulo. Se añadirá como duplicado."

		calibredb add -d --with-library=$libreria "$1"

	else

		echo "No existe el libro, por lo que se añadirá como nuevo."

		calibredb add --with-library=$libreria "$1"

	fi
fi
