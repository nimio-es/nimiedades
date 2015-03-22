unit CDBMiddleEngine;

(*******************************************************************************
 * CLASE: TDBMiddleEngine.                                                     *
 * FECHA DE CREACIÓN: 30-07-2001                                               *
 * PROGRAMADOR: Saulo Alvarado Mateos (CINCA)                                  *
 * DESCRIPCIÓN:                                                                *
 *        Hace las veces de interfaz entre los objetos con los que trabaja el  *
 * sistema y el soporte último en el que se almacenan, que en este caso se     *
 * trata de archivos almacenados individualmente. Por supuesto la idea es      *
 * que hereda de TCurstomDBMiddleEngine, para que se pueda, en el futuro, cam- *
 * biar por cualquier otro soporte o BBDD. Cosa que desde luego no sucederá    *
 * estando yo por estos lares, claro.                                          *
 *                                                                             *
 * FECHA MODIFICACIÓN: 01-10-2001                                              *
 * PROGRAMADOR: Saulo Alvarado Mateos (CINCA)                                  *
 * CAMBIOS (DESCRIPCIÓN):                                                      *
 *         A partir de ahora, el mismo "motor" se encarga de buscar y guardar  *
 * los soportes generados por el programa.                                     *
 *                                                                             *
 * FECHA MODIFICACIÓN: 05-10-2001                                              *
 * PROGRAMADOR: Saulo Alvarado Mateos (CINCA)                                  *
 * CAMBIOS (DESCRIPCIÓN):                                                      *
 *         Se ha hecho una modificación en el procedimiento de asignar el      *
 * siguiente número libre para el soporte. A partir de ahora, si se ha borrado *
 * uno anteriormente, se le asignará ese número (hueco) libre aunque existan   *
 * número de soporte posteriores.                                              *
 *                                                                             *
 * FECHA MODIFICACIÓN: 08-10-2001                                              *
 * PROGRAMADOR: Saulo Alvarado Mateos (CINCA)                                  *
 * CAMBIOS (DESCRIPCIÓN):                                                      *
 *         Cuando se elimina un soporte hay que renumerar todos los que vienen *
 * detrás.                                                                     *
 *                                                                             *
 * FECHA MODIFICACIÓN: 22-10-2001                                              *
 * PROGRAMADOR: Saulo Alvarado Mateos (CINCA)                                  *
 * CAMBIOS (DESCRIPCION):                                                      *
 *         A partir de ahora, cuando se leen los datos de un registro también  *
 * se acompaña de la referencia al soporte en el que viajó                     *
 *                                                                             *
 * FECHA MODIFICACIÓN: 04-11-2001                                              *
 * PROGRAMADOR: Saulo Alvarado Mateos (CINCA)                                  *
 * CAMBIOS (DESCRIPCIÓN):                                                      *
 *         Se quieren incluir más información en el proxy de cada registro     *
 * para mostrarlo en la ventana de lectura y borrado.                          *
 *                                                                             *
 * FECHA MODIFICACIÓN: 13-05-2002                                              *
 * PROGRAMADOR: Saulo Alvarado Mateos (CINCA)                                  *
 * CAMBIOS (DESCRIPCIÓN):                                                      *
 *         Se añaden un conjunto de procedimientos necesario para poder mover  *
 * los registros "viejos" a las carpetas oportunas sin entrar en un posible    *
 * estado de inconsistencia. Hay que hacerlo en dos fases: cada vez que se lee *
 * un registro, se debe crear un archivo de "bloqueo" en el directorio. De es- *
 * ta forma se cancelará el proceso de intentar entrar en modo "Bloqueo total  *
 * de registros". Ahora bien, si se encuentra en ese modo, indicado a su vez   *
 * por un archivo, no se podrán leer registros mientras.                       *
 *         Estos cambios implican una serie de modificaciones importantes en   *
 * el código.                                                                  *
 *                                                                             *
 *******************************************************************************
 * CLASE: TRecordProxy                                                         *
 * FECHA DE CREACIÓN: 30-07-2001                                               *
 * PROGRAMADOR: Saulo Alvarado Mateos (CINCA)                                  *
 * DESCRIPCIÓN:                                                                *
 *       Permite mantener información adicional sobre el archivo que contiene  *
 * objeto para cuando se vuelva a guardar.                                     *
 *******************************************************************************)

interface

  uses
    sysUtils,
    UGlobalData,
    contnrs,  (* TObjectList *)
    classes,
    CCustomDBMiddleEngine,  (* TCustomDBMiddleEngine *)
    COpDivSystemRecord,
    COpDivRecType02,
    COpDivRecType03,
    COpDivRecType04,
    COpDivRecType05,
    COpDivRecType06,
    COpDivRecType07,
    COpDivRecType08,
    COpDivRecType09,
    COpDivRecType10,
    COpDivRecType12,
    COpDivRecType14,
    COpDivRecTypeDEV,
    CSoporte;

  const
    kFileGenSopExt   = '.033';


  type
    // *** declaraciones adelantadas
    TOpDivRecordProxy = class;
    TDBMiddleEngine = class;

    // *** declaraciones de las clases
    TOpDivRecordProxy = class( TCustomRecordProxy )
      public
        FileName: String;
        OID: String;
        StationID: String;
        FechaHora: TDateTime;
        TipoReg: String;
        Descripcion: String;

        // $ 4-11-2001 datos incluídos a partir de esta fecha
        NatOp: String;
        EntOfiDest: String;
        ImportePrinOp: Double;
        DivisaOp: String;
        IncluirSop: String;
        VinculasoSop: Boolean;

        constructor Create; override;

        function isAssignedToSoporte: Boolean;
    end;


    // 13.05.02 - se añade una clase de excepción para indicar que hay un bloque a nivel de terminal/registro
    EDBMiddleTerminalLockedException = class( Exception )
      public
        constructor Create; overload; virtual;
    end;

    // 13.05.02 - se añade una clase de excepción para indicar que hay un bloque general de todos los registros
    //            (para hacer "limpieza").
    EDBMiddleGeneralRecorsLockException = class( Exception )
      public
        constructor Create; overload; virtual;
    end;

    // 14.05.02 - se añade una excepción para indicar que hay un bloque a nivel de soportes
    EDBMiddleSoporteLockedException = class( Exception )
      public
        constructor Create; overload; virtual;
    end;


    // 13.05.02 - parámetros del movimiento de archivos
    TMoveRecFilesParams = class( TObject )
      public
        borrarDelFiles,
        borrarOldFiles: Boolean;
        fechaCorte: TDateTime;

        constructor Create; virtual;
    end;


    //
    TDBMiddleEngine = class( TCustomDBMiddleEngine )
      protected
        FDataDir: String;
        FDataSoporteDir: String;
        FDataSoporteGenDir: String; // se almacena una copia de los soportes generados por el programa como logs...
        FDataAuxDir: String;
        FAuxProxy: TOpDivRecordProxy;

        FVinculadosFile: TStringList;

        function factoryCreateRecordType( aRecProxy: TOpDivRecordProxy ): TOpDivSystemRecord;

        // 13.05.02 - método que comprueba si existe un bloqueo de registros previo
        function testLockRecords: Boolean;
        // 13.05.02 - método que comprueba si hay algún terminal con un registro abierto o en uso
        function testLockTerminal: Boolean;
        
      public
        // $$ constructores
        constructor Create; override;
        destructor Destroy; override;
        // $$ métodos públicos
        function  getListOfRecords: TObjectList; override;
        procedure clearProxy; virtual;
        function  readRecord( aRecProxy: TCustomRecordProxy ): TCustomSystemRecord; override;
        function  readRecordFromOID( anOID: String ): TOpDivSystemRecord; virtual;
        procedure writeRecord( aSystemRecord: TCustomSystemRecord ); override;
        procedure writeRecordNoProxy( aSystemRecord: TOpDivSystemRecord ); virtual;
        procedure deleteRecord( aRecProxy: TCustomRecordProxy ); override;


        // 13.05.02 - rutinas para crear, destruir, archivos de bloqueo de los terminales
        procedure lockTerminal(const terminalId, recType: String);
        procedure unlockTerminal(const terminalId: String);

        // 14.05.02 - rutinas para bloqueo completo de los registros
        procedure lockGlobalRecords(const terminalId: String);  // se indica el terminal para saber quién lo generó
        procedure unlockGlobalRecords;

        // --- para los soportes
        function beginSoporteSection: boolean; virtual;
        function endSoporteSection: boolean; virtual;

        function getNextNumSoporte: Integer;
        procedure setLastNumSoporteUsed( aNumSoporte: Integer );
        function getNextRefNumber: Integer;
        procedure setLastRefNumberUsed( aRefNumber: Integer );

        function getListOfSoportes( aDate: TDateTime ): TObjectList; virtual;
        procedure writeSoporte( aSoporte: TSoporte ); virtual;
        procedure deleteSoporte( aSoporte: TSoporte ); virtual;

        procedure writeSopFile( const fileName: String; textoSoporte: TStrings ); virtual;

        function recordIsInSoporte( aRecProxy: TOpDivRecordProxy ): boolean; virtual;
        function getSoporteOfRecord(const anOID: String): String;

        // 14.05.02 - rutinas auxiliares para mover los soportes
        function getBriefListOfSoportes: TObjectList;
        procedure moveOldSoporte( const theSoporteFileName: String; aMoveParams: TMoveRecFilesParams );
    end;

  // **** VARIABLES PÚBLICAS Y GLOBALES
  var
    TheDBMiddleEngine: TDBMiddleEngine;

implementation

  uses
    rxStrUtils,
    Windows,
    Messages,
    Dialogs,
    IniFiles,
    Forms,
    CCriptografiaCutre,
    CQueryEngine;

  (*****
    CONSTANTES PRIVADAS PARA EL MÓDULO
   *****)
  const
    kHeadSection = '[CABECERA]';
    kDescripcionItem = 'DESCRIPCION';
    kBodySection = '[DATOS]';
    kRecSection  = '[RECORD]';
    kRecordItem  = 'RECORD';
    kCodeControlItem = 'CODECONTROL';
    kFileExtension = '.ROD';
    kSubdirAuxData = 'tablasAuxiliares';
    kSubdirSoportes = 'soportes';

    kSopBodySection  = '[OIDS]';
    kSopExtension    = '.SOP';

    kFileLookSoporte = 'soporte.lock';
    kFileReferences  = 'REFERENCES.LST';
    kNumRefSoporte   = 'SOPORTE';
    kNumRefRecord    = 'RECORD';
    kFileVinculados  = 'VINCULADOS.LST';

    kSubdirSoportesGen = 'archivos';

    // 13.05.02 - constantes para las utilidades de mover archivos
    kSubdirObsoletos = 'obsoletos';
    kExtBloqRecRead = '.lock' ;  // si existe alguno en el directorio se debe evitar
                                // bloquear para mover registros
    kFileLockRecords = 'registros.lock';


(***********************
  TOpDivRecordProxy ...
 ***********************)

  constructor TOpDivRecordProxy.Create;
  begin
    inherited ;

    FileName    := EmptyStr;
    OID         := EmptyStr;
    StationID   := EmptyStr;
    FechaHora   := 0.0;
    TipoReg     := EmptyStr;
    Descripcion := EmptyStr;
  end;

  function  TOpDivRecordProxy.isAssignedToSoporte: Boolean;
  begin
    Result := VinculasoSop;
  end;



(***************************************
  EDBMiddleEngineTerminalLockedException
 ***************************************)

  constructor EDBMiddleTerminalLockedException.Create;
  begin
    inherited Create('Existe al menos un terminal con un registro bloqueado.')
  end;

(************************************
  EDBMiddleGeneralRecorsLockException
 ************************************)

  constructor EDBMiddleGeneralRecorsLockException.Create;
  begin
    inherited Create('Existe un bloqueo general de los registros.' + #13
        + 'De persistir el problema hable con el departamento de informática o con el administardor de la red.' + #13
        + #13
        + 'Archivo de bloqueo: ' + kFileLockRecords );
  end;

(*********************************
  EDBMiddleSoporteLockedException
 *********************************)

  constructor EDBMiddleSoporteLockedException.Create;
  begin
    inherited Create('Existe un bloqueo a nivel de soportes.' + #13
        + 'De persistir el problema hable con el departamento de informática o con el administardor de la red.' + #13
        + #13
        + 'Archivo de bloqueo: ' + kFileLookSoporte );
  end;


(********************
  TMoveRecFilesParams
 ********************)

 constructor TMoveRecFilesParams.Create;
 begin
   borrarDelFiles := TRUE;
   borrarOldFiles := TRUE;
   fechaCorte := date() - 31.0; // se desea que la fecha de corte sea de 30 días atrás  
 end;



(***********************
  TDBMiddleEngine ...
 ***********************)

(*********
  CONSTRUCTORES Y DESTRUCTORES
 *********)

  constructor TDBMiddleEngine.Create;
  begin
    FDataDir := getPathDBFiles();
    if FDataDir[ length( FDataDir ) ] <> '\' then
      FDataDir := FDataDir + '\';
    // el directorio de las tablas auxiliares
    FDataAuxDir := FDataDir + kSubdirAuxData + '\' ;
    // el directorio donde se guardan las referencias de los soportes
    FDataSoporteDir := FDataDir + kSubdirSoportes + '\' ;
    if not DirectoryExists( FDataSoporteDir ) then
      CreateDir( FDataSoporteDir );
    // el directorio donde se guardará una copia de los soportes generados en disquete
    FDataSoporteGenDir := FDataSoporteDir + kSubdirSoportesGen + '\';
    if not DirectoryExists( FDataSoporteGenDir ) then
      CreateDir( FDataSoporteGenDir );
    // se crea el QueryManager (gestor global)
    theQueryEngine := TQueryEngine.Create( FDataAuxDir );
  end;

  destructor TDBMiddleEngine.Destroy;
  begin
    theQueryEngine.Free;
    inherited;
  end;

(*********
  MÉTODOS PRIVADOS
 *********)

   function TDBMiddleEngine.factoryCreateRecordType( aRecProxy: TOpDivRecordProxy ): TOpDivSystemRecord;
   begin
     Result := nil;
     if aRecProxy.TipoReg = '01' then
     else if aRecProxy.TipoReg = '02' then
       Result := TOpDivRecType02.Create()
     else if aRecProxy.TipoReg = '03' then
       Result := TOpDivRecType03.Create()
     else if aRecProxy.TipoReg = '04' then
       Result := TOpDivRecType04.Create()
     else if aRecProxy.TipoReg = '05' then
       Result := TOpDivRecType05.Create()
     else if aRecProxy.TipoReg = '06' then
       Result := TOpDivRecType06.Create()
     else if aRecProxy.TipoReg = '07' then
       Result := TOpDivRecType07.Create()
     else if aRecProxy.TipoReg = '08' then
       Result := TOpDivRecType08.Create()
     else if aRecProxy.TipoReg = '09' then
       Result := TOpDivRecType09.Create()
     else if aRecProxy.TipoReg = '10' then
       Result := TOpDivRecType10.Create()
     else if aRecProxy.TipoReg = '11' then
     else if aRecProxy.TipoReg = '12' then
       Result := TOpDivRecType12.Create()
     else if aRecProxy.TipoReg = '13' then
     else if aRecProxy.TipoReg = '14' then
       Result := TOpDivRecType14.Create()
     else if aRecProxy.TipoReg = 'DEV' then
       Result := TOpDivRecTypeDEV.Create()
   end;  // a partir del objeto Proxy crea el adecuado objeto correspondiente al tipo oportuno.


   //  13.05.02 - este método es bastante sencillo pues se basa en buscar un archivo cuyo nombre es constante
   // devuelve TRUE si hay bloqueo
   //          FALSE si no lo hay
   function TDBMiddleEngine.testLockRecords: Boolean;
   begin
     Result := FileExists( FDataDir + kFileLockRecords );
   end;

   // 13.05.02 - hay que buscar los archivos con determinada extensión.
   // devuelve TRUE si hay bloqueo
   //          FALSE si no lo hay
   function TDBMiddleEngine.testLockTerminal: Boolean;
   var
     iFounded: Integer;
     sr: TSearchRec;
   begin
     // buscamos que exista algún registro de bloqueo
     iFounded := FindFirst( FDataDir + '*' + kExtBloqRecRead, 0, sr );
     Result := (iFounded = 0);
     SysUtils.FindClose( sr );
   end;

(*********
  MÉTODOS PÚBLICOS
 *********)

  function  TDBMiddleEngine.getListOfRecords: TObjectList;
  const
    klHeadSection = 'CABECERA';
    klBodySection = 'DATOS';
  var
    newRecord: TOpDivRecordProxy;
    theIniFile: TIniFile;
    theStringList: TStringList;
    sr: TSearchRec;
    iFounded: integer;
    auxStrToDate: String;
    auxStr: String;
  begin
    Result := TObjectList.Create;

    // 13.05.02 - si existe un bloque general, no se permite una lectura de los registros
    if testLockRecords() then
      raise EDBMiddleGeneralRecorsLockException.Create();

    theStringList := TStringList.Create;
    try

      // buscamos el primero de la lista...
      iFounded := FindFirst( FDataDir + '*' + kFileExtension, 0, sr );
      try
        while iFounded = 0 do
        begin
          // se debe cargar el archivo
          theIniFile := TIniFile.Create( FDataDir + sr.Name );
          try
            newRecord := TOpDivRecordProxy.Create();
            // se crea el registro y se añade a la lista de registros encontrados
            // siempre que tanto la estación de grabación como el tipo pasen la prueba.
            newRecord.FileName    := FDataDir + sr.Name;
            newRecord.OID         := theIniFile.ReadString( klHeadSection, k00_OIDItem, '' );
            newRecord.StationID   := theIniFile.ReadString( klHeadSection, k00_StationIDItem, '' );
            auxStrToDate          := theIniFile.ReadString( klHeadSection, k00_DateCreationItem, '09/05/1972' );
            newRecord.FechaHora   := //SysUtils.strToDateTime( auxStrToDate );
                 strToDate( Copy(auxStrToDate, 1, 10) ) + strToTime( Copy(auxStrToDate, 12, 8) );
            newRecord.TipoReg     := theIniFile.ReadString( klHeadSection, k00_RecTypeItem, '' );
            newRecord.Descripcion := theIniFile.ReadString( klHeadSection, kDescripcionItem, '' );

            // $ 4-11-2001: se deben "cargar" los nuevos datos...
            auxStr := theIniFile.ReadString(klHeadSection, k00_OpNatItem, EmptyStr);
            if auxStr = '1' then
              newRecord.NatOp := 'COBROS'
            else if auxStr = '2' then
              newRecord.NatOp := 'PAGOS'
            else
              newRecord.NatOp := '--ERR--';
            auxStr := theIniFile.ReadString(klBodySection, k00_EntOficDestinoItem, EmptyStr);
            newRecord.EntOfiDest := Copy(auxStr, 1, 4) + '-' + Copy(auxStr, 5, 4);
            newRecord.ImportePrinOp := StrToFloat(ReplaceStr(theIniFile.ReadString(klBodySection, k00_ImportePrinOpItem, '0.0'), '.', ','));
            auxStr := theIniFile.ReadString(klBodySection, k00_DivisaOperacionItem, '0');
            if auxStr = '0' then
              newRecord.DivisaOp := 'EUR'
            else
              newRecord.DivisaOp := 'PTA';
            if StrToBool(theIniFile.ReadString(klBodySection, k00_IncluirSoporteItem, '0')) then
              newRecord.IncluirSop := 'SI'
            else
              newRecord.IncluirSop := 'NO';

            newRecord.VinculasoSop := (getSoporteOfRecord(newRecord.OID) <> EmptyStr);



            if UGlobalData.testStation( newRecord.StationID ) then
            begin
              if newRecord.TipoReg <> 'DEV' then
              begin
                if UGlobalData.testDo( 'T' + newRecord.TipoReg ) then
                  Result.Add( newRecord );
              end
              else if UGlobalData.testDo( newRecord.TipoReg ) then
                Result.Add(newRecord);
            end;
//            newRecord := nil;
          finally
            theIniFile.Free;
          end;
          // buscamos el siguiente registro
          iFounded := FindNext( sr );
        end;
      finally
        SysUtils.FindClose( sr );
      end;
    finally
//      newRecord := nil;
      theStringList.Free;
    end
  end;

  // -- este procedimiento se añade para evitar problemas cuando se leen registros que luego no se van a emplear (sus proxies, que probablemente habrán
  // -- sido eliminados de la memoria por la rutina llamadora. Esta rutina llamadora, debe evitar conflictos invocándo este método para que limpie el
  // -- estado interno del "engine".
  procedure TDBMiddleEngine.clearProxy;
  begin
    FAuxProxy := nil;
  end;

  function  TDBMiddleEngine.readRecord( aRecProxy: TCustomRecordProxy ): TCustomSystemRecord;
  var
    theFile: TStringList;
  begin
    if not assigned( aRecProxy ) then
      raise Exception.Create( 'Se tiene que indicar un registro existente.' );
    if not FileExists( TopDivRecordProxy( aRecProxy ).FileName ) then
      raise Exception.Create( 'El registro señalado no existe.' );
    theFile := TStringList.Create();
    try
      FAuxProxy := TOpDivRecordProxy( aRecProxy );
      theFile.LoadFromFile( FAuxProxy.FileName );
      Result := factoryCreateRecordType( FAuxProxy );
      Result.setData( theFile );
      TOpDivSystemRecord(Result).Soporte := getSoporteOfRecord(Result.OID);
    finally
      theFile.Free;
    end
  end;

  function  TDBMiddleEngine.readRecordFromOID( anOID: String ): TOpDivSystemRecord;
  const
    klHeadSection = 'CABECERA';
  var
    theFile: TStringList;
    theIniFile: TIniFile;
    nameFile: String;
    auxProxy: TOpDivRecordProxy;
  begin
    nameFile := FDataDir + anOID + kFileExtension;
    if not FileExists( nameFile ) then
      raise Exception.Create( 'El registro (OID=' + anOID + ') no existe.' );
    theFile := TStringList.Create();
    theIniFile := TIniFile.Create( nameFile );
    auxProxy := TOpDivRecordProxy.Create();
    try
      // creamos el proxy-record para poder hacer uso de la factoría
      auxProxy.FileName    := nameFile;
      auxProxy.OID         := theIniFile.ReadString( klHeadSection, k00_OIDItem, '' );
      auxProxy.StationID   := theIniFile.ReadString( klHeadSection, k00_StationIDItem, '' );
      auxProxy.FechaHora   := strToDateTime( theIniFile.ReadString( klHeadSection, k00_DateCreationItem, '' ) );
      auxProxy.TipoReg     := theIniFile.ReadString( klHeadSection, k00_RecTypeItem, '' );
      auxProxy.Descripcion := theIniFile.ReadString( klHeadSection, kDescripcionItem, '' );

      // leemos el fichero
      theFile.LoadFromFile( nameFile );

      Result := factoryCreateRecordType( auxProxy );
      Result.setData(theFile);

      Result.Soporte := getSoporteOfRecord(Result.OID);
    finally
      theFile.Free();
      theIniFile.Free();
      auxProxy.Free();
    end;
  end;

  procedure TDBMiddleEngine.writeRecord( aSystemRecord: TCustomSystemRecord );
  var
    descripcion: String;
    fileRecord: TStringList;
    anStringList: TStringList;  // para interrogar al registro
  begin
    descripcion := EmptyStr;
    fileRecord :=  TStringList.Create();
    anStringList := TStringList.Create();
    try
      if assigned( FAuxProxy ) then
        if FAuxProxy.OID = TOpDivSystemRecord( aSystemRecord ).OID then
        begin
          // --  se renombra el archivo destino
          if FileExists( FAuxProxy.FileName + '.OLD' ) then
            SysUtils.DeleteFile( FAuxProxy.FileName + '.OLD' );
          RenameFile( FAuxProxy.FileName, FAuxProxy.FileName + '.OLD' );
          descripcion := FAuxProxy.Descripcion ;
        end
        else
        begin
          // debemos desasignar el valor de FAuxProxu
          FAuxProxy.Free();
          FAuxProxy := nil;
        end;

(*
      if not assigned( FAuxProxy ) then
        descripcion := UpperCase( InputBox( 'Guardar registro...', 'Descripcion', EmptyStr ) );
*)
      descripcion := UpperCase( InputBox( 'Guardar registro...', 'Descripcion', descripcion ) );

      fileRecord.Clear();
      // se crea la cabecera del archivo
      fileRecord.Add( kHeadSection );
      TOpDivSystemRecord( aSystemRecord ).getHead( anStringList );
      fileRecord.AddStrings( anStringList );
      fileRecord.Add( kDescripcionItem + '=' + descripcion );
      fileRecord.Add( kCodeControlItem + '=' + TOpDivSystemRecord( aSystemRecord ).getHeadCode() );
      // ahora se recogen los datos del cuerpo
      fileRecord.Add( EmptyStr );
      fileRecord.Add( kBodySection );
      TOpDivSystemRecord( aSystemRecord ).getData( anStringList );
      fileRecord.AddStrings( anStringList );
      fileRecord.Add( kCodeControlItem + '=' + TOpDivSystemRecord( aSystemRecord ).getDataCode() );
      fileRecord.Add( EmptyStr );
      // aprovechamos y se genera el registro...
      fileRecord.Add( kRecSection );
      fileRecord.Add( kRecordItem + '=' + TOpDivSystemRecord( aSystemRecord ).getDataAsFileRecord() );
      fileRecord.Add( kCodeControlItem + '=' + theCutreCriptoEngine.getCodeA( TOpDivSystemRecord( aSystemRecord ).getDataAsFileRecord() ) );
      // ahora se almacena el archivo
      fileRecord.SaveToFile( FDataDir + TOpDivSystemRecord( aSystemRecord ).OID + kFileExtension );
    finally
      fileRecord.Free();
      anStringList.Free();

      if assigned( FAuxProxy ) then
      begin
//        FAuxProxy.Free();
//  se encarga de borrarlo OpenRecord al destruirse...
        FAuxProxy := nil;
      end;
    end;
  end;

  procedure TDBMiddleEngine.writeRecordNoProxy( aSystemRecord: TOpDivSystemRecord );
  var
    descripcion: String;
    auxStringList: TStringList;
    fileRecord: TStringList;
    aStringList: TStringList;
    nameFile: String;
  begin
    descripcion   := EmptyStr;
    auxStringList := TStringList.Create();
    fileRecord    := TStringList.Create();
    aStringList   := TStringList.Create();

    nameFile := FDataDir + aSystemRecord.OID + kFileExtension;
    try
      // hay que tener en cuenta que la hora de guardar el registro debemos recuperar la descripción de la anterior versión para no perderla...
      if FileExists( nameFile ) then
      begin
        auxStringList.LoadFromFile(nameFile);
        descripcion := auxStringList.Values[kDescripcionItem];
        auxStringList.Clear();
        // de paso renombramos el archivo para no perder las versiones...
        if FileExists(nameFile + '.OLD') then
          SysUtils.DeleteFile(nameFile + '.OLD');
        RenameFile(nameFile, nameFile + '.OLD');
      end;
      // procedemos a generar el archivo final
      fileRecord.Clear();
      // se crea la cabecera del archivo
      fileRecord.Add( kHeadSection );
      aSystemRecord.getHead( aStringList );
      fileRecord.AddStrings( aStringList );
      fileRecord.Add( kDescripcionItem + '=' + descripcion );
      fileRecord.Add( kCodeControlItem + '=' + aSystemRecord.getHeadCode() );
      // ahora se recogen los datos del cuerpo
      fileRecord.Add( EmptyStr );
      fileRecord.Add( kBodySection );
      aSystemRecord.getData( aStringList );
      fileRecord.AddStrings( aStringList );
      fileRecord.Add( kCodeControlItem + '=' + aSystemRecord.getDataCode() );
      fileRecord.Add( EmptyStr );
      // aprovechamos y se genera el registro...
      fileRecord.Add( kRecSection );
      fileRecord.Add( kRecordItem + '=' + aSystemRecord.getDataAsFileRecord() );
      fileRecord.Add( kCodeControlItem + '=' + theCutreCriptoEngine.getCodeA( aSystemRecord.getDataAsFileRecord() ) );
      // ahora se almacena el archivo
      fileRecord.SaveToFile( nameFile );
    finally
      auxStringList.Free();
      fileRecord.Free();
      aStringList.Free();
    end;
  end;

  procedure TDBMiddleEngine.deleteRecord( aRecProxy: TCustomRecordProxy );
  var
    proxy: TOpDivRecordProxy ;
  begin
    proxy := TOpDivRecordProxy( aRecProxy );
    if FileExists( proxy.FileName ) then
      RenameFile( proxy.FileName, proxy.FileName + '.DEL' );

    // aprovechamos para limpiar algunos restos indeseables de
    if assigned( FAuxProxy ) then
      FAuxProxy := nil;
  end;

  // 13.05.02 -- para bloquear/desbloquear terminales

  procedure TDBMiddleEngine.lockTerminal(const terminalId, recType: String);
  var
    theLockFileName: String;
  begin
    theLockFileName := FDataDir + terminalId + '$' + recType + kExtBloqRecRead;
    if not FileExists( theLockFileName ) then
      FileClose( FileCreate( theLockFileName ) );
  end;

  procedure TDBMiddleEngine.unlockTerminal(const terminalId: String);
  var
    iFounded: Integer;
    rs: TSearchRec;
  begin
    iFounded := FindFirst( FDataDir + terminalId + '*' + kExtBloqRecRead, 0, rs);
    try
      while iFounded = 0 do
      begin
        // borramos todos los registros que tengan la extensión de bloqueo y que sean del terminal
        // Esto se hace así para evitar restos debidos a una salida brusca del programa. Sin dar
        // tiempo a una limpieza anterior
        SysUtils.DeleteFile( FDataDir + rs.Name );
        iFounded := FindNext( rs );
      end;
    finally
      SysUtils.FindClose( rs );
    end;
  end;


  procedure TDBMiddleEngine.lockGlobalRecords(const terminalId: String);
  var
    idFile: Integer;
    numCharsWrite: Cardinal;
    textoToWrite: String;
  begin
    if FileExists( FDataSoporteDir + kFileLookSoporte ) then
      raise EDBMiddleSoporteLockedException.Create();

    if not FileExists( FDataDir + kFileLockRecords ) then
    begin
      idFile := FileCreate( FDataDir + kFileLockRecords );
      numCharsWrite := Length( terminalId );
      textoToWrite := terminalId;
      FileWrite(idFile, terminalId, numCharsWrite);
      SysUtils.FileClose( idFile );

      // además abrimos el archivo de soportes vinculados para poder trabajar más rápido con él
      FVinculadosFile := TStringList.Create();
      if FileExists(FDataSoporteDir + kFileVinculados) then
        FVinculadosFile.LoadFromFile(FDataSoporteDir + kFileVinculados);
    end
    else
      raise EDBMiddleGeneralRecorsLockException.Create('Ya existe un bloque general.')
  end;

  procedure TDBMiddleEngine.unlockGlobalRecords;
  begin
    if FileExists( FDataDir + kFileLockRecords ) then
    begin
      FVinculadosFile.SaveToFile(FDataSoporteDir + kFileVinculados);
      SysUtils.DeleteFile( FDataDir + kFileLockRecords );
    end;
  end;

  // ~~~~~~~ para los Soportes ~~~~~~~~~~

  function TDBMiddleEngine.beginSoporteSection: boolean;
  begin
    Result := false;

    // 13.05.02 - sólo podremos entrar en la utilidad de soportes cuando no
    //            exista un bloqueo general de los registros (moviendo registros
    //            antiguos).
    if testLockRecords() then
      raise EDBMiddleGeneralRecorsLockException.Create();

    if not FileExists( FDataSoporteDir + kFileLookSoporte ) then
    begin
      FileClose( FileCreate( FDataSoporteDir + kFileLookSoporte ) );
      // de paso creamos y cargamos en memoria el archivo de vínculos
      FVinculadosFile := TStringList.Create();
      if FileExists(FDataSoporteDir + kFileVinculados) then
        FVinculadosFile.LoadFromFile(FDataSoporteDir + kFileVinculados);
      Result := true;
    end;
  end;

  function TDBMiddleEngine.endSoporteSection: boolean;
  begin
    Result := false;
    if FileExists( FDataSoporteDir + kFileLookSoporte ) then
    begin
      FVinculadosFile.SaveToFile(FDataSoporteDir + kFileVinculados);
      SysUtils.DeleteFile( FDataSoporteDir + kFileLookSoporte );
      Result := true;
    end;
  end;

  function TDBMiddleEngine.getNextNumSoporte: Integer;
  var
(*
    listReferencias: TStringList;
    nameItem: String;
*)
    listSoportes: TObjectList;
    huecos: array [1..100] of boolean;
    iCont: Integer;
  begin
    listSoportes := getListOfSoportes( date() );
    for iCont := 1 to 100 do huecos[iCont] := true;
    try
      // marcamos los huecos libres
      for iCont := 0 to listSoportes.Count-1 do
        huecos[TSoporte(listSoportes.Items[iCont]).NumOrden] := false;
      // buscamos el primero que esté realmente libre
      Result := 1;
      while not huecos[Result] and (Result <= 100) do inc(Result);
      if Result > 100 then
        raise Exception.Create('Demasiados soportes'); 
    finally
      listSoportes.Free();
    end;
(*    Result := 1;
    listReferencias := TStringList.Create();
    try
      if FileExists( FDataSoporteDir + kFileReferences ) then
      begin
        listReferencias.LoadFromFile( FDataSoporteDir + kFileReferences );
        nameItem := kNumRefSoporte + formatDateTime('yyyymmdd',date());
        if listReferencias.IndexOfName( nameItem ) >= 0 then
          Result := strToInt( listReferencias.Values[nameItem] ) + 1;
      end
    finally
      listReferencias.Free();
    end;
*)
  end;

  procedure TDBMiddleEngine.setLastNumSoporteUsed( aNumSoporte: Integer );
  var
    listReferencias: TStringList;
    nameFile: String;
    nameItem: String;
  begin
    nameFile := FDataSoporteDir + kFileReferences;
    nameItem := kNumRefSoporte + formatDateTime('yyyymmdd',date());
    listReferencias := TStringList.Create();
    try
      if FileExists( nameFile ) then
        listReferencias.LoadFromFile(nameFile);
      listReferencias.Values[nameItem] := intToStr(aNumSoporte);
      // volvemos a guardar el archivo de referencias
      listReferencias.SaveToFile(nameFile);
    finally
      listReferencias.Free();
    end
  end;

  function TDBMiddleEngine.getNextRefNumber: Integer;
  var
    listReferencias: TStringList;
    nameFile: String;
    nameItem: String;
  begin
    Result := 1;
    nameFile := FDataSoporteDir + kFileReferences;
    nameItem := kNumRefRecord + formatDateTime('yyyymmdd',date());
    listReferencias := TStringList.Create();
    try
      if FileExists(nameFile) then
      begin
        listReferencias.LoadFromFile(nameFile);
        if listReferencias.IndexOfName(nameItem) >= 0 then
          Result := strToInt(listReferencias.Values[nameItem])+1;
      end
    finally
      listReferencias.Free();
    end
  end;

  procedure TDBMiddleEngine.setLastRefNumberUsed( aRefNumber: Integer );
  var
    nameFile: String;
    nameItem: String;
    listReferencias: TStringList;
  begin
    nameFile := FDataSoporteDir + kFileReferences;
    nameItem := kNumRefRecord + formatDateTime('yyyymmdd',date());
    listReferencias := TStringList.Create();
    try
      if FileExists(nameFile) then
        listReferencias.LoadFromFile(nameFile);
      listReferencias.Values[nameItem] := intToStr(aRefNumber);
      // procedemos a guardar nuevamente el archivo de referencias
      listReferencias.SaveToFile(nameFile);
    finally
    end;
  end;

  function TDBMiddleEngine.getListOfSoportes( aDate: TDateTime ): TObjectList;
  var
    newRecord: TSoporte;
    newOpDiv: TOpDivSystemRecord;
    theStringList: TStringList;
    sr: TSearchRec;
    iFounded: integer;
    prefFechaFile: String;
    iString: integer;
  begin
      Result := TObjectList.Create();

      prefFechaFile := formatDateTime( 'yyyymmdd', aDate );

      // buscamos el primero de la lista...
      iFounded := FindFirst( FDataSoporteDir + prefFechaFile + '*' + kSopExtension, 0, sr );
      try
        while iFounded = 0 do
        begin
          // se debe cargar el archivo
          theStringList := TStringList.Create();
          theStringList.LoadFromFile( FDataSoporteDir + sr.Name );
          try
            newRecord := TSoporte.Create();
            newRecord.OwnsRecordsPointers := true;  // el es el encargado de eliminar sus registros relacionados

            newRecord.Tipo         := TSoporte.strToTipo( theStringList.Values[ kSopTipoItem ] );
            newRecord.FechaSoporte := strToDateTime( theStringList.Values[ kSopFechaItem ] );
            newRecord.NumOrden     := strToInt( theStringList.Values[ kSopNumItem ] );
            newRecord.StationID    := theStringList.Values[kSopEstacionItem];

            // ahora buscamos todos los registros que componen el soporte y los vamos incorporando...
            while theStringList.Strings[0] <> kSopBodySection do theStringList.Delete(0);
            for iString := 1 to theStringList.Count - 1 do
            begin
              newOpDiv := readRecordFromOID( theStringList.Strings[iString] );
              newRecord.AddRegistro( newOpDiv );
            end;

            Result.Add( newRecord );
          finally
            theStringList.Free;
          end;
          // buscamos el siguiente registro
          iFounded := FindNext( sr );
        end;
      finally
        SysUtils.FindClose( sr );
      end;
  end;

  procedure TDBMiddleEngine.writeSoporte( aSoporte: TSoporte );
  var
    fileRecord: TStringList;
    registrosVinculados: TObjectList;
    iRecord: Integer;
    nameFile: String;
  begin
    nameFile := formatDateTime('yyyymmdd', aSoporte.FechaSoporte) + AddChar('0', intToStr(aSoporte.NumOrden), 3);
    nameFIle := FDataSoporteDir + nameFile + kSopExtension;

    fileRecord := TStringList.Create();
    registrosVinculados := TObjectList.Create();
    registrosVinculados.OwnsObjects := false;
    try
      // si existe el fichero se renombra para conservar una versión del mismo
      if FileExists(nameFile) then
      begin
        if FileExists(nameFile + '.OLD') then
          SysUtils.DeleteFile(nameFile + '.OLD');
        RenameFile(nameFile, nameFile + '.OLD');
      end;
      // se comienza construyendo el registro en memoria con la cabecera
      fileRecord.Clear();
      fileRecord.Add(kHeadSection);
      fileRecord.Add(kSopTipoItem + '=' + aSoporte.tipoToStr(aSoporte.Tipo));
      fileRecord.Add(kSopFechaItem + '=' + dateTimeToStr(aSoporte.FechaSoporte));
      fileRecord.Add(kSopNumItem + '=' + intToStr(aSoporte.NumOrden));
      fileRecord.Add(kSopEstacionItem + '=' + getStationID() );
      fileRecord.Add(EmptyStr);

      // luego se introducen los OID's de los registros asociados
      // -- se empieza solicitándolos al soporte con el número de referencia asociado
      aSoporte.getRegistros(registrosVinculados);
      fileRecord.Add(kSopBodySection);
      for iRecord := 0 to registrosVinculados.Count - 1 do
      begin
        fileRecord.Add(TOpDivSystemRecord(registrosVinculados.Items[iRecord]).OID);
        FVinculadosFile.Values[TOpDivSystemRecord(registrosVinculados.Items[iRecord]).OID] := aSoporte.getDesc();
      end;

      // se termina guardando el archivo
      fileRecord.SaveToFile(nameFile);
    finally
      fileRecord.Free();
      registrosVinculados.Free();
    end;
  end;

  procedure TDBMiddleEngine.deleteSoporte( aSoporte: TSoporte );
  var
    fileRecords: TStringList;
    nameFile: String;
    iRecord: Integer;
    maxNumero,
    numeroSoporte: Integer;
    listaSoportes: TObjectList;
    otroSoporte: TSoporte;
  begin
    // se debe renombara el archivo del soporte para hacerlo "desaparecer", pero también hay que quitar las referencias
    // del archivo de vínculos...
    nameFile := FDataSoporteDir + formatDateTime( 'yyyymmdd', aSoporte.FechaSoporte ) + AddChar('0',intToStr(aSoporte.NumOrden),3) + kSopExtension;
    if fileExists(nameFile) then
    begin
      // lo leemos
      fileRecords := TStringList.Create();
      try
        fileRecords.LoadFromFile(nameFile);
        // lo "borramos"
        if FileExists(nameFile + '.DEL') then
          SysUtils.DeleteFile(nameFile + '.DEL');
        RenameFile(nameFile, nameFile + '.DEL');
        // procedemos a limpiar los vínculos
        while fileRecords.Strings[0] <> kSopBodySection do fileRecords.Delete(0);
        for iRecord := 1 to fileRecords.Count - 1 do
          FVinculadosFile.Values[fileRecords.Strings[iRecord]] := EmptyStr;

        // (+)08-10-2001: Hay que renumerar los soportes que vienen detrás
        // ^^^ CUIDADO PORQUE PUEDEN PRODUCIRSE INCONSISTENCIAS EN LAS REFERENCIAS CRUZADAS
        //     ENTRE SOPORTES Y REGISTROS....!!!!!!!!!!!!
        maxNumero := 0;
        listaSoportes := getListOfSoportes(aSoporte.FechaSoporte);
        try
          for numeroSoporte := 0 to listaSoportes.Count - 1 do
          begin
            otroSoporte := TSoporte(listaSoportes.Items[numeroSoporte]);
            if otroSoporte.NumOrden > aSoporte.NumOrden then
            begin
              if maxNumero < otroSoporte.NumOrden then
                maxNumero := otroSoporte.NumOrden;
              otroSoporte.NumOrden := otroSoporte.NumOrden - 1;
              writeSoporte(otroSoporte);
            end;
          end;
          // debemos renombrar también el último de la lista, ya que el hueco se ha ido desplazando hacia arriba...
          if maxNumero > 0 then
          begin
            nameFile := FDataSoporteDir + FormatDateTime('yyyymmdd', aSoporte.FechaSoporte) + AddChar('0', IntToStr(maxNumero), 3) + kSopExtension;
            if not FileExists(nameFile) then
              raise Exception.Create('POSTCONDICIÓN: Debería existir el último soporte');
            if FileExists(nameFile + '.DEL') then
              SysUtils.DeleteFile(nameFile + '.DEL');
            RenameFile(nameFile, nameFile + '.DEL');
          end
        finally
          listaSoportes.Free();
        end;
      finally
        fileRecords.Free();
      end;
    end
  end;

  function  TDBMiddleEngine.recordIsInSoporte( aRecProxy: TOpDivRecordProxy ): boolean;
  begin
    Result := (FVinculadosFile.IndexOfName(aRecProxy.OID) >= 0);
  end;

  function  TDBMiddleEngine.getSoporteOfRecord(const anOID: String): String;
  var
    archivoVinculados: TStringList;
  begin
    Result := EmptyStr;
    archivoVinculados := TStringList.Create();
    try
      archivoVinculados.LoadFromFile(FDataSoporteDir + kFileVinculados);
      if archivoVinculados.IndexOfName(anOID) >= 0 then
      begin
        Result := archivoVinculados.Values[anOID];
        Result := copy(Result, 1, 8) + '.' + copy(Result, 9, 3);
      end
    finally
      archivoVinculados.Free();
    end;
  end;

  procedure TDBMiddleEngine.writeSopFile( const fileName: String; textoSoporte: TStrings );
  var
    prefix: String;
    endNameFile: String;
  begin
    prefix := formatDateTime( 'yyyymmddhhnnsszzz', now() );
    endNameFile := FDataSoporteGenDir + prefix + '.' + fileName;
    if FileExists(endNameFile) then
      raise Exception.Create('No se puede tener dos nombre de archivo iguales.');
    textoSoporte.SaveToFile(endNameFile);
  end;


  // 14.05.02 - se incluyen rutinas para permitir mover los archivos obsoletos

  // el parámetro de entrada, que contiene los parámetros, a su vez, de las opciones elegidas para
  // mover los archivos, se emplea para evitar devolver aquellos soportes que sean superiores a la fecha
  // indicada.
  function TDBMiddleEngine.getBriefListOfSoportes(aMoveParams: TMoveRecFilesParams): TObjectList;
  begin

  end;

  // cuando se mueve el soporte se mueven todos los registros asociados, de tal forma que,
  // a partir de los parámetros del "movimiento", se decide si se borran o se mueven también
  // los archivos DEL y OLD.
  // Pero para ello se debe asegurar que se está en modo "bloqueo general".
  procedure TDBMiddleEngine.moveOldSoporte(const theSoporteFileName: String; aMoveParams: TMoveRecFilesParams );
  begin
    
  end;


initialization

  theDBMiddleEngine := TDBMiddleEngine.Create;

finalization

  theDBMiddleEngine.Free;

end.
