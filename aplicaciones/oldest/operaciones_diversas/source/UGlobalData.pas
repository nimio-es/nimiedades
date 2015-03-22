unit UGlobalData;

interface

  (******
    CONSTANTES PÚBLICAS
   ******)
  const
    // constantes de las operaciones que se pueden realizar
    kCodeOpTipo01 = 'T01';
    kCodeOpTipo02 = 'T02';
    kCodeOpTipo03 = 'T03';
    kCodeOpTipo04 = 'T04';
    kCodeOpTipo05 = 'T05';
    kCodeOpTipo06 = 'T06';
    kCodeOpTipo07 = 'T07';
    kCodeOpTipo08 = 'T08';
    kCodeOpTipo09 = 'T09';
    kCodeOpTipo10 = 'T10';
    kCodeOpTipo11 = 'T11';
    kCodeOpTipo12 = 'T12';
    kCodeOpTipo13 = 'T13';
    kCodeOpTipo14 = 'T14';
    kCodeOpTipoDev = 'DEV';
    kCodeOpListado = 'LST';
    kCodeOpSoporte = 'FLE';

  // **** procedimientos de soporte ****
  procedure Inicializacion;
        // **** se encarga de establecer los valores iniciales de las variables gloables

  function getPathExe: String ;
        // **** encargada de devolver la ruta al ejecutable (impide que se modifique)
  function getPathDBFiles: String ;
        // **** encargada de devolver la ruta a los ficheros con los registros...
  function getStationID: String;
        // **** encargada de devolver el código de la estación de trabajo
  function getCanRead: string;
        // **** encargada de devolver la cadena con los códigos de estaciones de las cuales se pueden leer los registros
  function getCanDo: string;
        // **** encargada de devolver la cadena con los tipos de registros que se pueden generar/leer.
  function testStation( const aStationID: string ): boolean ;
        // **** encargada de comprobar si un id de estación concreto se está dentro de la lista
  function testDo( const aType: string ): boolean;
        // **** encargada de comprobar si un tipo de registro se puede manipular en esta estación
  function configure: boolean;
        // **** encargado de lanzar la configuración del sistema

implementation

  uses
    SysUtils,   (* funciones de gestión de directorios *)
    Windows,    (* funciones para consultar datos del ordenador actual *)
    FileCtrl,   (* directoryExists() *)
    inifiles,   (* TIniFile *)
    Controls,   (* valor mrOK *)
    Dialogs,    (* MessageDlg() *)
    CCriptografiaCutre,  (* theCutreCriptoEngine *)
    VConfigSystemForm ;  (* TConfigSystemForm *)

  (******
    CONSTANTES PRIVADAS DEL MÓDULO.
   ******)
  const
    kDefConfigFileName = 'config.ini' ;
    kExtConfigFileName = '.ini';
    // constantes para la rutina de lectura del archivo de configuración
    kSectionINIFile = 'WORKSTATION' ;
    kIdentStationID = 'STATIONID' ;
    kIdentPathToDBFile = 'PATHTODBFILES' ;
    kIdentCanDo = 'CANDO' ;
    kIdentCanRead = 'CANREAD' ;
    kIdentControlCode = 'CODEB';

    kRetOK = 0;
    kRetFileNotExists = -6;
    kRetWrongCodeB = -5;
    kRetSectionNotExists = -1;
    kRetIdentStationIDNotExists = -2;
    kRetIdentPathToDBFilesNotExists = -3;
    kRetIdentCanDoNotExists = -4;

    // mensajes de error de salida
    kErrMsgWrongConfigFile = 'El fichero de configuración no existe o no es correcto.';
    kSubErrMsgNoSection = 'No existe la sección de configuración.';
    kSubErrMsgNoDBPath = 'No se ha indicado el directorio de los datos.' ;
    kSubErrMsgNoIDStation = 'No se ha indicado el número de la estación de trabajo.' ;
    kSubErrMsgNoCanDo = 'No se ha señalado las operaciones que se pueden realizar en esta estación.' ;
    kSubErrMsgWrongCodeControl = 'El código de control del archivo es incorrecto o el archivo ha sido manipulado sin permiso.';


  (******
    VARIABLES PRIVADAS DEL MÓDULO.
    En este caso se trata de las variables globales del sistema
   ******)
  var
    // variables globales para toda la aplicación
    pathToExe: String ;            // ubicación del ejecutable
    pathToConfigFile: String ;     // ubicación del fichero de configuración
    nameOfConfigFile: String ;     // nombre del fichero de configuración (incluyendo su ubicación)
    pathToDBFiles: String ;     // ubicación de los datos (por defecto <pathExe/../dbFiles>)
    stationID: String;        // identificador de la estación de trabajo
    canDo: String;         // cadena separada por comas con los tipos que se pueden tratar (indicar que hay que normalizar a dos dígitos poniendo 0)
    canRead: String;          // cadena separada por comas con los identificadores de las estaciones de trabajo que se pueden leer (y por ende modificar)

    fileIsInTheNet: Boolean;  // cuando el archivo de configuración está en la red, hay que tenerlo en cuenta para el cálculo del Código de control

    // variable auxiliar para errores
    controlCode: string;
    lastReadFileErrorMsg: String;

  (*****
    PROCEDIMIENTOS AUXILIARES Y/O DE SOPORTE
   *****)
  // para el programa mostrando una ventana de error
  procedure ExitWithMessage( const Msg: string );
  begin
    MessageDlg( Msg, mtError, [mbOK], 0 );
    Halt;
  end;  // -- ExitWithMessage

  // una función que devuelve el nombre de la máquina en la que nos encontramos
  function getMyComputerName: String;
  var
    computerName: String;
    lenName: Cardinal;
  begin
    SetLength( computerName, 255 );
    lenName := 255;
    GetComputerName( PChar( computerName ), lenName );
    SetLength( computerName, lenName );
    Result := UpperCase( Trim( computerName ) );
  end;

  // el Path del archivo de configuración se construye en el momento para comprobar los posibles caminos hacia el archivo
  procedure getInitConfigPath;
  begin
    // primero se comprueba la existencia del archivo en el directorio del ejecutable
    pathToConfigFile := ExpandFileName( pathToExe + 'CONFIG\' );
    fileIsInTheNet   := ( getMyComputerName() <> EmptyStr );
    if fileIsInTheNet then
    begin
      nameOfConfigFile := pathToConfigFile + getMyComputerName() + kExtConfigFileName ;
      if fileExists( nameOfConfigFile ) then exit;
    end;
    // si no está con el nombre de la máquina, procedemos a buscar el nombre genérico
    nameOfConfigFile := pathToConfigFile + kDefConfigFileName ;
    fileIsInTheNet := false;
    if fileExists( nameOfConfigFile ) then exit;
    // en tercer lugar se procede a buscar en el disco duro local en el directorio config
    pathToConfigFile := 'C:\';
    nameOfConfigFile := pathToConfigFile + 'OPDIVCONFIG' + kExtConfigFileName;
    fileIsInTheNet   := false;
    if fileExists( nameOfConfigFile ) then exit;
    // si no existe en ninguno de estos sitios pues se configura los valores por defecto
    pathToConfigFile := ExpandFileName( pathToExe + 'CONFIG\' );
    if getMyComputerName() <> EmptyStr then
    begin
      nameOfConfigFile := pathToConfigFile + getMyComputerName() + kExtConfigFileName;
      fileIsInTheNet := true;
    end
    else
    begin
      nameOfConfigFile := pathToConfigFile + kDefConfigFileName ;
      fileIsInTheNet := false;
    end
  end;

  // extrae el Path a partir del ejecutable y, de paso, obtiene la posición donde debería estar el archivo de configuración
  procedure getInitPaths;
  begin
    pathToExe        := ExtractFilePath( ParamStr( 0 ) ) ;
(*
    pathToConfigFile := ExpandFileName( pathToExe + 'CONFIG\' );
    nameOfConfigFile := pathToConfigFile + kConfigFileName ;
*)
    getInitConfigPath();
  end; // -- getInitPaths;

  // se encarga de leer los datos desde el archivo de configuración.
  function readConfigFile( stopIfFileNotExist, stopIfNoAIdent, stopIfWrongCodeB: boolean ): integer;
    // -- stopIfFileNotExist = para el programa en caso de que el fichero no exista
    // -- stopIfNoAIndent = para el programa en caso de que no haya un identificador necesario
    // -- stopIfWrongCodeB = para el programa en caso de que el código B almacenado sea erroneo
    // RETORNA:
    //   0: si todo es correcto
    //  -1: si no existe la sección [WORKSTATION]
    //  -2: si no existe el identificador STATIONID
    //  -3: si no existe el identificador PATHTODBFILES
    //  -4: si no existe el identificador CANDO
    //  -5: si el código B almacenado no se corresponde con el calculado
    //  -6: el fichero no existe
    const
      klSeparador = '^CODE^';
    var
      configFile: TIniFile;
      codigoA: string;
      codigoB: string;
      auxStrCode: string;

    // se encarga de dar el nuevo valor siempre que ya no haya un error indicado
    function setResultIfNoError( oldResult, newResult: integer ): integer;
    begin
      result := oldResult;
      if OldResult = kRetOK then result := newResult;
    end;

  // -- readCondigFile
  begin
    result := kRetOK;
    // se comprueba a ver si el fichero existe
    if not FileExists( nameOfConfigFile ) then
    begin
      lastReadFileErrorMsg := '';
      if stopIfFileNotExist then
        ExitWithMessage( kErrMsgWrongConfigFile )
      else
        result := kRetFileNotExists;
    end
    else
    begin // ---- existe el archivo de configuración y por tanto se procede a leer
      configFile := TIniFile.Create( nameOfConfigFile );
      // se procede a realizar las comprobaciones
      if not configFile.SectionExists( kSectionINIFile ) then
      begin
        lastReadFileErrorMsg := kSubErrMsgNoSection ;
        if stopIfNoAIdent then
          ExitWithMessage( kErrMsgWrongConfigFile + #13 + kSubErrMsgNoSection )
        else
          result := kRetSectionNotExists;
      end
      else
      begin  // ---- existe la sección de configuración
        // -- se compruena StationID
        if not configFile.ValueExists( kSectionIniFile, kIdentStationID ) then
        begin
          lastReadFileErrorMsg := kSubErrMsgNoIDStation ;
          if stopIfNoAIdent then
            ExitWithMessage( kErrMsgWrongConfigFile + #13 + kSubErrMsgNoIDStation )
          else
            result := setResultIfNoError( result, kRetIdentStationIDNotExists );
        end
        else
          stationID := trim( configFile.ReadString( kSectionINIFile, kIdentStationID, '' ) );
        // -- se comprueba PathToDBFiles
        if not configFile.ValueExists( kSectionIniFile, kIdentPathToDBFile ) then
        begin
          lastReadFileErrorMsg := kSubErrMsgNoDBPath ;
          if stopIfNoAIdent then
            ExitWithMessage( kErrMsgWrongConfigFile + #13 + kSubErrMsgNoDBPath )
          else
            result := setResultIfNoError( result, kRetIdentPathToDBFilesNotExists );
        end
        else
          pathToDBFiles := trim( configFile.ReadString( kSectionIniFile, kIdentPathToDBFile, '' ) );
        // -- se comprueba CanDo
        if not configFile.ValueExists( kSectionIniFile, kIdentCanDo ) then
        begin
          lastReadFileErrorMsg := kSubErrMsgNoCanDo ;
          if stopIfNoAIdent then
            ExitWithMessage( kErrMsgWrongConfigFile + #13 + kSubErrMsgNoCanDo )
          else
            result := setResultIfNoError( result, kRetIdentCanDoNotExists );
        end
        else
          canDo := trim( configFile.ReadString( kSectionIniFile, kIdentCanDo, '' ) );
        // -- se lee las estaciones que se pueden tratar
        canRead := trim( configFile.ReadString( kSectionIniFile, kIdentCanRead, '' ) );
        // -- se lee el código B almacenado
        codigoB := trim( configFile.ReadString( kSectionIniFile, kIdentControlCode, '' ) );
        controlCode := codigoB ;
        // -- se crea la cadena sobre la que se calcula el código de control
        auxStrCode := klSeparador + stationID + klSeparador + pathToDBFiles + klSeparador + canDo + klSeparador + canRead + klSeparador ;
        if fileIsInTheNet then auxStrCode := auxStrCode + Trim( getMyComputerName()) + klSeparador ;
        codigoA := theCutreCriptoEngine.getCodeA( auxStrCode );
        if not theCutreCriptoEngine.isCodeBValid( codigoA, codigoB ) then
        begin
          lastReadFileErrorMsg := kSubErrMsgWrongCodeControl ;
          if stopIfWrongCodeB then
            ExitWithMessage( kErrMsgWrongConfigFile + #13 + kSubErrMsgWrongCodeControl )
          else
            result := setResultIfNoError( result, kRetWrongCodeB );
        end;
      end; // --- if .. SectionExistis(...)
      // se libera el archivo de configuración
      configFile.Free;
    end;
  end; // -- readConfigFile(...)

  // se encarga de la inicialización de las variables. Hay dos tipos de variables
  // las que se obtienen a partir del directorio del ejecutable y las que se deben
  // extraer del archivo de configuración.
  procedure Inicializacion;
  begin
    getInitPaths; // path del ejecutable y del directorio de configuración

    // en este punto se comprueba la existencia del directorio de configuración. Si no existe se crea
    if not DirectoryExists( pathToConfigFile ) then
      CreateDir( pathToConfigFile );

    // en este punto se comprueba la existencia del archivo de configuración. Si no existe se llama al proceso de edición.
    // Hay que tener en cuenta que si el procedimiento devuelve un valor indicando que se ha cancelado la edición, el
    // proceso (programa) deberá ser abortado.
    if not FileExists( nameOfConfigFile ) then
    begin
      if not configure then
        ExitWithMessage( kErrMsgWrongConfigFile );
    end;

    // en el caso de que exista hay que comprobar, además, que no ha sido manipulado.
    // Esto se realiza empleando el código B almacenado en el archivo conjuntamente con los datos
    // Si por este motivo, o porque no haya alguno de los identificadores necesarios, se procede
    // a configurar nuevamente el archivo.
    if readConfigFile( true, false, false ) <> kRetOK then
    begin
      MessageDlg( 'Se ha encontrado que el archivo de configuración es erroneo <' + lastReadFileErrorMsg + '>' + #13 + 'Se procede a reconfigurar. Si cancela el progama abortará.', mtWarning, [mbOK], 0 );
      if not configure then
        ExitWithMessage( kErrMsgWrongConfigFile + #13 + lastReadFileErrorMsg );
    end;

  end; // -- Inicialización

  (*****
    IMPLEMENTACIÓN DE FUNCIONES Y PROCEDIMIENTOS PÚBLICOS.
   *****)
  function getPathExe: String ;
  begin
    result := pathToExe ;
  end ; // -- getPathExe

  function getPathDBFiles: String ;
  begin
    result := pathToDBFiles ;
  end; // -- getPathDBFiles

  function getStationID: String ;
  begin
    result := stationID;
  end; // -- getStationID

  function getCanRead: string ;
  begin
    result := canRead;
  end; // -- getCanRead

  function getCanDo: string ;
  begin
    result := canDo;
  end;  // -- getCanTypes

  function testStation( const aStationID: string ): boolean;
  begin
(*
    result := false;
*)
    result := (Trim(aStationID)=stationID)
        or (Pos('*',canRead)>0)
        or (Pos(aStationID,canRead)>0);
(*    if Pos( '*', canRead ) > 0 then
      result := true
    else
      if Trim( aStationID ) = stationID then
        result := true
      if Pos( aStationID, canRead ) > 0 then
        result := true; *)
  end;  // -- testStation

  function testDo( const aType: string ): boolean;
  begin
    result := false;
    if Pos( '*', canDo ) > 0 then
      result := true
    else
      if Pos( aType, canDo ) > 0 then
        result := true;
  end; // -- testType

  function configure: boolean;
  var
    aConfigForm: TConfigSystemForm;
    configFile: TIniFile;
  begin
    aConfigForm := TConfigSystemForm.Create( nil );
    // en el supuesto de que exista un archivo de configuración previo, se procede a leerlo antes de pasárselo al formulario de configuración
    if FileExists( nameOfConfigFile ) then
    begin
      readConfigFile( true, false, false );
      aConfigForm.StationID := stationID ;
      aConfigForm.PathToDBFiles := pathToDBFiles ;
      aConfigForm.CanDo := canDo ;
      aConfigForm.CanRead := canRead ;
      aConfigForm.CodeControl := controlCode ;
    end;

    if fileIsInTheNet then
      aConfigForm.ComputerName := getMyComputerName();

    result := ( aConfigForm.ShowModal = mrOK );
    // en caso de aceptarse la configuración, hay que proceder a escribir el archivo
    if result then
    begin
      // se procede a crear el fichero de configuración a partir de los datos
      // introducidos en el diálogo
      configFile := TIniFile.Create( nameOfConfigFile );
      configFile.WriteString( kSectionINIFile, kIdentStationID, aConfigForm.StationID );
      configFile.WriteString( kSectionINIFile, kIdentPathToDBFile, aConfigForm.PathToDBFiles );
      configFile.WriteString( kSectionINIFile, kIdentCanDo, aConfigForm.CanDo );
      configFile.WriteString( kSectionINIFile, kIdentCanRead, aConfigForm.CanRead );
      configFile.WriteString( kSectionINIFile, kIdentControlCode, aConfigForm.CodeControl );
      configFile.UpdateFile;
      configFile.Free;
      // aprovechamos para actualizar los valores globales
      StationID := aConfigForm.StationID ;
      pathToDBFiles := aConfigForm.PathToDBFiles ;
      CanDo := aConfigForm.CanDo ;
      CanRead := aConfigForm.CanRead ;
    end;

    aConfigForm.Free;
  end; // -- configure

initialization

  Inicializacion;

end.
