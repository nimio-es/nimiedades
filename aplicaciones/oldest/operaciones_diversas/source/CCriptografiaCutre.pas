unit CCriptografiaCutre;

interface

  (*******
   CLASE: TCriptografiaCutre
          Encargada de, dada una cadena, hacer un conjunto de operaciones a nivel de byte y devolver
          una cadena de código, que necesita un contracódigo para terminar la autenticación. Si cabe,
          el contracódigo es más chorra aún.
   *******)
   type
     TCutreCriptoEngine = class( TObject )
       public
         function getCodeA( const strWorking: String ): String;
         function getCodeB( const codeA: String ): String;
         function isCodeBValid( const codeA, codeB: String ): boolean;
     end;

   (*******
    VARIABLES GLOBALES DEL MÓDULO.
    *******)
   var
     theCutreCriptoEngine: TCutreCriptoEngine;

implementation

  (******
   CONSTANTES PRIVADAS
   ******)
  const
    kBaseTrabajoCriptoEngine = 11;
    kTablaConversion: array [0..(kBaseTrabajoCriptoEngine-1)] of char
         = ( 'Z', 'Y', 'A', '4', 'M', '0', 'Q', 'S', 'P', '7', 'L' );
// ** cuando la base es 19        = ( 'Z', 'Y', 'A', '4', 'M', '0', 'Q', 'S', 'P', '7', 'L', 'W', 'X', '3', 'K', 'T', '1', 'E', 'B' );
    kNumOfRepeatsOfWorkStr = 100;
    kLenOfCodeA = 6;
    kStrXORCodeA: String[ kLenOfCodeA ] = '%$#@&?';  // al hacer un XOR con esta cadena, se supone que obtendremos el códigoB

  (******
    IMPLEMENTACIÓN: Clase TCutreCriptoEngine
   ******)
  // se encarga de, a partir una cadena y sumando los valores de los caracteres, obtener una ristra (código A) de varios caracteres. Luego, esta ristra se normaliza a base 19, que se representa según una tabla de conversión particular
  // Hay que hacer notar que, previamente, a los bytes de la cadena se les resta un valor para normalizar (anterior al espacio en blanco), pero que si su valor es menor que 32 automáticamente se colocan a 0 (no influyen en el valor final)
  function TCutreCriptoEngine.getCodeA( const strWorking: String ): String;
  const
    klBaseNormalizaCadena = 16;
  var
    cadenaBytes: array [0..100] of byte;
    currentChar: integer;
    numRep: integer;  // para controlar el número de veces que se repite la cadena de trabajo ( de esta forma se incrementa el código A)
    strWorkAux: String;

    // normaliza los caracteres de la cadena de trabajo. Para ello les resta el valor indicado como constante.
    function normalizaCaracterBase( theChar: char ): byte;
    var
      tmpResult: integer;
    begin
      tmpResult := ord(theChar) - klBaseNormalizaCadena;
      if tmpResult < 0 then
        result := 0
      else
        result := tmpResult;
    end;

    // borra los bytes de la suma
    procedure resetBytes;
    var
      i: integer;
    begin
      for i:=0 to 100 do cadenaBytes[i] := 0;
    end;

    // suma un byte a la cadena de bytes en la base especificada
    procedure addByte( sumando: byte ) ;
    var
      acarreo: byte;
      byteTrabajo: integer;
    begin
      cadenaBytes[0] := cadenaBytes[0] + sumando ;
      byteTrabajo := 0;
      while cadenaBytes[ byteTrabajo ] >= kBaseTrabajoCriptoEngine do
      begin
        acarreo := cadenaBytes[ byteTrabajo ] div kBaseTrabajoCriptoEngine ;
        cadenaBytes[ byteTrabajo ] := cadenaBytes[ byteTrabajo ] mod kBaseTrabajoCriptoEngine ;
        inc( byteTrabajo );
        cadenaBytes[ byteTrabajo ] := cadenaBytes[ byteTrabajo ] + acarreo ;
      end;
    end;

    // convierte la cadena de bytes en una cadena de caracteres según la tabla de conversión indicada
    function bytesToString: String;
    var
      curByte: integer;
    begin
      result := '';
      for curByte:= 0 to kLenOfCodeA - 1 do
        result := kTablaConversion[ cadenaBytes[ curByte ] ] + result ;
    end;


  // getCodeA
  begin
    resetBytes;
    // se repite la cadena de trabajo el nº de veces que se indica
    strWorkAux := '';
    for numRep:= 1 to kNumOfRepeatsOfWorkStr do
     strWorkAux := strWorkAux + strWorking ;

    // se procesa la cadena de trabajo (auxiliar)
    for currentChar := 1 to length( strWorkAux ) do
      addByte( normalizaCaracterBase( strWorkAux[ currentChar ] ) ) ;
    // se devuelve la cadena normalizada a nuestra tabla de códigos particular
    result := bytesToString;
  end; // TCutreCriptoEngine.getCodeA()

  // esta es una función auxiliar para obtener un código B a partir de uno A
  function TCutreCriptoEngine.getCodeB( const codeA: String ): string;
  const
    klNormalizaCadenaBInf = 40;
    klNormalizaCadenaBSup = 127;
  var
    curChar: integer;
    ordCharB: integer;
  begin
    result := ' ';
    setLength( result, kLenOfCodeA );
    for curChar := 1 to kLenOfCodeA do
    begin
      ordCharB := ord( codeA[ curChar ] ) xor ( ord( kStrXORCodeA[ curChar ] ) * ord( codeA[ ( curChar + 2 ) mod kLenOfCodeA ] ) );
      if ordCharB >= klNormalizaCadenaBSup then ordCharB := ordCharB mod klNormalizaCadenaBSup;
      if ordCharB < klNormalizaCadenaBInf then ordCharB := ordCharB + klNormalizaCadenaBInf ;
      result[ curChar ] := UpCase( Chr( ordCharB ) );
    end;
  end; // TCutreCriptoEngine.getCodeB()

  // comprueba que el código B es la contrapartida del código A
  function TCutreCriptoEngine.isCodeBValid( const codeA, codeB: String ): boolean ;
  begin
    result := (getCodeB( codeA ) = codeB) ;
  end; // TCutreCriptoEngine.isCodeBValid()

initialization
  // se crea la instancia del criptografiador
  theCutreCriptoEngine := TCutreCriptoEngine.Create ;

finalization
  // se debe destruir la instancia del criptografiador
  theCutreCriptoEngine.Free ;

end.
