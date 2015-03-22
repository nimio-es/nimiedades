(*******************************************************************************
 *                                                                             *
 * FECHA: 27-10-2001                                                           *
 * PROGRAMADOR: Saulo Alvarado Mateos (CINCA)                                  *
 * DESCRIPCIÓN:                                                                *
 *      Se añade un sistema de eventos para notificar una "excepción" a la     *
 * vista/control que manipula el objeto. En este evento se le pasa una noti-   *
 * ficación del error en concreto. Con ello se intenta que sea la propia vista *
 * la que organice la respuesta a las excepciones o, en su defecto, que tome   *
 * la decisión oportuna respecto a mostrarla o no y a "enterarse" o ignorarla. *
 *      En la notificación se indica el campo sobre el que incide el error y   *
 * el mensaje del mismo.                                                       *
 *      Asimismo, esto requiere que se eliminen todas las excepciones del có-  *
 * digo, pues ahora sólo se notifica, nunca se lanza una excepción y ha de ser *
 * la vista la que lance la excepción si así lo considera oportuno.            *
 *                                                                             *
 * FECHA: 07-05-2002                                                           *
 * PROGRAMADOR: Saulo Alvarado Mateos (CINCA)                                  *
 * DESCRIPCIÓN:                                                                *
 *      Se solicita la inclusión de un campo "observaciones" para que los      *
 * usuarios puedan introducir aclaraciones con objeto de adjuntarlas en el im- *
 * preso, que se está empleando para entregarlo en las entidades destinatarias *
 * como documentación anexa. Dado que se permiten varias líneas está  implemen-*
 * tado como un TStringList que interactúa con un memo.                        *
 *      Otro cambio que se introduce es el necesario para poder imprimir co-   *
 * rrectamente el registro en el papel. La idea es que se imprima los campos   *
 * comunes arriba, tal como se hace hasta ahora, pero con las observaciones al *
 * final. Para ello se ha de crear un nuevo método "virtual y abstracto" que   *
 * deberán implementar todos los registros pero que, realmente, lo que hace es *
 * sustituir a la sobrecarga del método actual de impresión.                   *
 *                                                                             *
 * FECHA: 08-05-2002                                                           *
 * PROGRAMADOR: Saulo Alvarado Mateos (CINCA)                                  *
 * DESRCIPCIÓN: Cambio de denominación del campo observaciones. Pasa a mostar- *
 * se en el listado como "DISPONIBLE", siendo afín a otras entidades y a lo que*
 * dispone la relación de registros.                                           *
 *******************************************************************************)

unit COpDivSystemRecord;

interface

  uses
    classes,
    rxStrUtils,
    CCustomDBMiddleEngine; (* TCustomSystemRecord *)

  (********
   CONSTANTES PÚBLICAS
   ********)
  const
(*    kNameOfOID = 'OID';
    kNameOfStationID = 'STATIONID';
    kNameOfRecType = 'RECORDTYPE';
    kNameOfOpRef = 'OPERATIONREFERENCE';
    kNameOfDateCreation = 'DATETIMEOFCREATION';
    kNameOfOpNat = 'OPERATIONNATURAL';
*)
    kDivisaEuro              = 0;
    kDivisaPta               = 1;

    k_GenericFieldError      = '00.00';

    k00_OIDItem              = 'HH.01';
    k00_StationIDItem        = 'HH.02';
    k00_DateCreationItem     = 'HH.03';
    k00_OpNatItem            = '03.01';
    k00_RecTypeItem          = '04.01';
    k00_OpRefItem            = '05.01';

    k00_EntOficOrigenItem    = '06.01';
    k00_EntOficDestinoItem   = '07.03';
    k00_DCEntOficDestinoItem = '07.04';
    k00_DCNumCtaDestinoItem  = '07.05';
    k00_NumCtaDestinoItem    = '07.06';
    k00_DivisaOperacionItem  = 'XX.01';
    k00_ImportePrinOpItem    = '08.01';
    k00_ClaveAutorizaItem    = '09.01';
    k00_ImporteOrigOpItem    = '10.01';

    k00_IncluirSoporteItem   = 'XX.02';

    // 07.05.05 - se añaden observaciones a todos los registros con el fin de que
    //            los usuarios puedan aclarar más la información que introducen de
    //            cara a la presentación del impreso en la entidad destino.
    k00_NumLineasObservaItem = 'XX.03';
    k00_PrefixLineaObservaIten = 'OB.L';

    kMaxLineasObserva = 10;

    kNoNameFound = -1;

    kCodeSeparator = '^^CODE^^';


  type
    TDivisaOperacion = 0..1;

    TOpDivSystemRecord = class;

    TNotifyChangeDataEvent = procedure( SystemRecord: TOpDivSystemRecord) of object;
    TNotifyDataErrorEvent  = procedure( SystemRecord: TOpDivSystemRecord; const FieldWithError, ErrorMsg: String) of object;

    TOpDivSystemRecord = class( TCustomSystemRecord )
      protected
        //: datos de la cabecera
        FStationID: String;  // estación en la que se grabó el registro
        FDateCreation: TDateTime; // fecha y hora de creación del registro
        //: datos del cuerpo
        FOpNat: String;
        FRecType: String; // tipo de operación (diversa) de la que se trata
        FOpRef: String;  // referencia de la operación... cuando ya se le ha adjudicado
        FEntOficOrigen: String;
        FEntOficDestino: String;
        FNumCtaDestino: String;
        FDivisaOperacion: TDivisaOperacion;
        FImportePrinOp: Double;
        FClaveAutoriza: String;
        FImporteOrigOp: Double;

        FIncluirSoporte: Boolean;

        // :22/10/2001: se añade un campo más para el tema de los listados...
        FSoporte: String;

        // 07.05.2002 : se añade un campo para observaciones. Este campo se implementa como un StringList
        FObservaciones: TStringList;

        //: datos de control (campos que son obligatorios)
        FOpNatFixed: boolean;
        FNumCtaDestinoEsObligatoria: boolean;
        FClaveAutorizaEsObligatoria: boolean;
        FExternalImporteSet: boolean;    // permite establecer el valor de pesetas/ contravalor euros desde el exterior

        //: eventos
        FGeneralChange:  TNotifyChangeDataEvent;
        FDataErrorEvent: TNotifyDataErrorEvent;

        //******* MÉTODOS PRIVADOS ******

        // :: de soporte a las propiedades
        procedure setOpNat( const aString: String );
        procedure setOpRef(const aString: String);
        procedure setEntOficOrigen( const aString: String );
        function  getOficOrigenName: String;
        procedure setEntOficDestino( const aString: String );
        function  getEntDestinoName: String;
        procedure setNumCtaDestino( const aString: String );
        function  getDCEntOficDestino: String;
        function  getDCNumCtaDestino: String;
        procedure setDivisaOperacion( aDivisa: TDivisaOperacion );
        procedure setImportePrinOp( anImporte: Double );
        procedure setImporteOrigOp( anImporte: Double );
        procedure setImporteOperacion( anImporte: Double );
        procedure setClaveAutoriza( const aString: String );
        procedure setIncluirSoporte(incluir: Boolean);

        procedure setGeneralChange( aNotifyEvent: TNotifyChangeDataEvent );
        procedure setDataErrorEvent( aNotifyEvent: TNotifyDataErrorEvent );

        // :: auxiliares
        // :::: de validación
        procedure ValidateEntOficOrigen; virtual;
        procedure ValidateEntOficDetino; virtual;
        procedure ValidateNumCtaDestino; virtual;
        procedure validateImportePrinOp; virtual;
        procedure ValidateClaveAutoriza; virtual;

        // :::: de validación a la hora de insertar
        procedure TestImportePrinOp; virtual;

        // :: cambios
        procedure changeImporteOperacion; virtual;

        // :::: otros
        procedure initializeData; virtual;
        procedure readStringList( aStringList: TStrings ); virtual;
        function  getStringForCodeData: String; virtual;
        procedure changeEventCall;
        procedure dataErrorEventCall(const ErrorField, ErrorMsg: String);

        function testIndexOf( aStringList: TStrings; aName: String ): boolean;

        // 07.05.02 - se crea una función intermediaria para imprimir los datos
        //            del registro entre los datos comunes y las observacioes.
        function  printSpecificType: String; virtual; abstract;
        procedure printSpecificData( aDataString: TStringList ); virtual; abstract;

      public
        //: propiedades:
        //: cabecera
        property StationID: String read FStationID;
        property DateCreation: TDateTime read FDateCreation;
        //: datos
        property OpNat: String read FOpNat write setOpNat;
        property RecType: String read FRecType;
        property OpRef: String read FOpRef write setOpRef;
        property EntOficOrigen: String read FEntOficOrigen write setEntOficOrigen;
        property OficOrigenName: String read getOficOrigenName ;
        property EntOficDestino: String read FEntOficDestino write setEntOficDestino;
        property EntDestinoName: String read getEntDestinoName;
        property DCEntOficDestino: String read getDCEntOficDestino;
        property DCNumCtaDestino: String read getDCNumCtaDestino;
        property NumCtaDestino: String read FNumCtaDestino write setNumCtaDestino;
        property DivisaOperacion: TDivisaOperacion read FDivisaOperacion write setDivisaOperacion;
        property ImportePrinOp: Double read FImportePrinop write setImportePrinOp;
        property ImporteOrigOp: Double read FImporteOrigOp write setImporteOrigOp;
        property ImporteOperacion: Double write setImporteOperacion;
        property ClaveAutoriza: String read FClaveAutoriza write setClaveAutoriza;
        property IncluirSoporte: Boolean read FIncluirSoporte write setIncluirSoporte;

        property ExternalImporteSet: Boolean read FExternalImporteSet write FExternalImporteSet;

        property Soporte: String read FSoporte write FSoporte;
        //: eventos
        property GeneralChange: TNotifyChangeDataEvent read FGeneralChange write setGeneralChange;
        property DataErrorEvent: TNotifyDataErrorEvent read FDataErrorEvent write setDataErrorEvent;

        // constructores
        constructor Create; override;
        constructor Create( aProxy: TCustomRecordProxy ); override;

        // 07.05.02 -- dado que ahora hay un objeto que se crea en el constructor hay que usar un destructor para eliminarlo
        destructor Destroy; override;

        // 07.05.02 - las observaciones, al tratarse de un TStringList se han de tratar con funciones get/set específicas
        //            no pudiendo usarse una propiedad (se podría usar una con índice, pero para facilitar el tratamiento
        //            vamos a emplear dos procedimientos simples).
        procedure setObservaciones( anObservationList: TStrings );
        procedure getObservaciones( anObservationList: TStrings );

        // de consulta
        function  isAssignetToSoporte: Boolean;

        // otros métodos públicos
        procedure getHead( aStringList: TStrings ); virtual;
        function  getHeadCode: String; virtual;
        procedure setData( aStringList: TStrings ); override;
        procedure getData( aStringList: TStrings ); override;
        function  getDataCode: String; virtual;

        function  getDataAsFileRecord: String; virtual;
        procedure getDataAsPrintedRecord(anStrList: TStringList); virtual;
        procedure TestData; virtual;   // se encarga de comprobar que TODO es correcto para poder guardar la información

        // otros métodos de utilidad (en este caso a nivel de clase)
        class function isDocumentable: boolean; virtual;
        class function getOpNatDesc( const opNat: String ): String;
        class function getValidStringFromDouble( anImporte: Double; prec, dig: integer ): String;
        class function getDoubleFromString( const aString: String ): Double;
        class function getDayOfTheYear( fromDate: TDateTime ): word ;
    end;

implementation

  uses
    sysUtils,
    CCriptografiaCutre,
    UGlobalData,
    UAuxRefOp,
    UAuxClaveAut,
    CQueryEngine,
    Dialogs;

(******
 CONSTRUCTORES
 ******)
  constructor TOpDivSystemRecord.Create;
  begin
    inherited;

    // 07.05.02 -- el objeto FObservaciones debe crearse en el creador, no en el inicializador
    FObservaciones := TStringList.Create();

    initializeData;
  end;  // -- TOpDivSystemRecodr.Create

  constructor TOpDivSystemRecord.Create( aProxy: TCustomRecordProxy );
  var
    theStringList: TStringList;
  begin
    self.Create;

    theStringList := TStringList.Create;
    try
      aProxy.getData( theStringList );
      // procedemos a rellenar los datos desde el proxy del registro
    finally
      theStringList.Free;
    end;
  end;

  destructor TOpDivSystemRecord.Destroy;
  begin
    FObservaciones.Free();

    inherited;
  end;

(******
  MÉTODOS PÚBLICOS
 ******)

  // 07.05.02 - hay que establecer/leer el campo "observaciones".
  procedure TOpDivSystemRecord.setObservaciones( anObservationList: TStrings );
  begin
    FObservaciones.Assign( anObservationList );
  end;

  procedure TOpDivSystemRecord.getObservaciones( anObservationList: TStrings );
  begin
    anObservationList.Assign( FObservaciones );
  end; 

  function  TOpDivSystemRecord.isAssignetToSoporte: Boolean;
  begin
    Result := (FSoporte <> EmptyStr);
  end;

  function  TOpDivSystemRecord.getDataAsFileRecord: String;
  begin
    // la primera parte del registro es siempre similar...
    result := '30' // código del registro
            + '62' // código de la operación
            + FOpNat
            + FRecType
            + FOpRef
            + FEntOficOrigen
            + '  '  // código del país
            + '00'  // dígitos de control
            + FEntOficDestino
            + DCEntOficDestino
            + DCNumCtaDestino
            + FNumCtaDestino
            + MS( ' ', 10 ) // IBAN - disponible
            + AddChar( '0', Trim( ReplaceStr( getValidStringFromDouble( FImportePrinOp, 11, 2 ), '.', '' ) ), 11 )
            + '0'  // naturaleza de la comisión
            + '00' // clave de la comisión
            + '000000' // importe de la comisión en euros
            + AddChar( '0', FClaveAutoriza, 18 )
            + AddChar( '0', Trim( ReplaceStr( getValidStringFromDouble( FImporteOrigOp, 11, 0 ), '.', '' ) ), 11 ) ;
  end;

  procedure TOpDivSystemRecord.getDataAsPrintedRecord(anStrList: TStringList);
  var
    lnPrn: String;
    auxStr: String;
    iLine: Integer;
  begin
    anStrList.Add( printSpecificType() );
    anStrList.Add(MS('_', 90));
    
    anStrList.Add('OID : ' + FOID + MS(' ', 4) + 'ESTACIÓN: ' + FStationID
          + MS(' ', 4) + 'FECHA CREACIÓN: ' + FormatDateTime('dd/mm/yyyy', FDateCreation) );
    anStrList.Add(EmptyStr);

    // los importes
    lnPrn := 'IMPORTE PRINCIPAL OPERACIÓN : ' + FloatToStrF( FImportePrinOp, ffNumber, 11, 2 ) + ' €';
    if FImporteOrigOp <> 0.0 then
      lnPrn := lnPrn + MS(' ', 8 ) + 'IMPORTE ORIGINAL : ' + FloatToStrF( FImporteOrigOp, ffNumber, 11, 0) + ' Pt';
    anStrList.Add( lnPrn );
    anStrList.Add( EmptyStr );

    lnPrn := 'REFERENCIA: ';
    if FOpRef[16]='?' then
      lnPrn := lnPrn + AddCharR(' ', '<PENDIENTE>', 16)
    else
      lnPrn := lnPrn + AddChar('0', FOpRef, 16);
    lnPrn := lnPrn + MS(' ', 8);
    lnPrn := lnPrn + 'NAT. OP.: ' + AddCharR(' ', UpperCase( Self.getOpNatDesc(FOpNat) ), 6);
//    lnPrn := lnPrn + MS(' ', 8);
//    lnPrn := lnPrn + 'FECHA CREACION: ' + FormatDateTime('dd/mm/yyyy', FDateCreation);
    anStrList.Add( lnPrn );
    auxStr := Copy(FEntOficOrigen, 5, 4);
    lnPrn := 'ENT/OFIC. ORIGEN OPERACIÓN  : ' + Copy(FEntOficOrigen, 1, 4) + '-' + auxStr;
    lnPrn := lnPrn + MS(' ', 4);
    if theQueryEngine.existsOfiCaja(auxStr) then
      lnPrn := lnPrn + theQueryEngine.getOfiCajaName(auxStr)
    else
      lnPrn := lnPrn + '?????';
    anStrList.Add( lnPrn );
    auxStr := Copy(FEntOficDestino, 1, 4 );
    lnPrn := 'ENT/OFIC. DESTINO OPERACIÓN : ' + auxStr + '-' + Copy(FEntOficDestino, 5, 4) + '-' + DCEntOficDestino;
    lnPrn := lnPrn + MS(' ', 2);
    if theQueryEngine.existsEntidad(auxStr) then
      lnPrn := lnPrn + theQueryEngine.getEntidadName(auxStr)
    else
      lnPrn := lnPrn + '??????';
    anStrList.Add( lnPrn );
    lnPrn := 'NÚM. CTA. DESTINO OPERACIÓN : ' + DCNumCtaDestino + '-' + FNumCtaDestino;
    anStrList.Add( lnPrn );
    // se imprime la clave de autorización si se ha introducido...
    if ReplaceStr(Trim(FClaveAutoriza), '0', '') <> EmptyStr then
      anStrList.Add('CLAVE AUTORIZACIÓN......... : ' + AddChar('0', Trim(FClaveAutoriza), 18 ) );


    // 07.05.02 - a partir de ahora se necesita que se impriman los datos específicos en medio del registro para
    //            colocar las observaciones al final.
    printSpecificData( anStrList );

    if FObservaciones.Count > 0 then
    begin
      anStrList.Add(EMPTYSTR);
      anStrList.Add(EMPTYSTR);
      anStrList.Add('DISPONIBLE :');
      for iLine := 0 to FObservaciones.Count - 1 do
        anStrList.Add( '  ' + FObservaciones.Strings[iLine] )
    end;
  end;

  // :: validación de los campos comunes
  procedure TOpDivSystemRecord.TestData;
  begin
    // se procede a validar los datos comunes
    ValidateEntOficOrigen();
    ValidateEntOficDetino();
    ValidateNumCtaDestino();
    validateImportePrinOp();
    ValidateClaveAutoriza();
  end;

  // :: recoge los campos de descripción del registro y los guarda en la lista que se le pasa de la forma Name=Value
  // :: de esta forma, un objeto puede acceder a los valores internos y almacenarlos en otro soporte
  procedure TOpDivSystemRecord.getHead( aStringList: TStrings );
  begin
    aStringList.Clear;
    aStringList.Values[ k00_OIDItem ] := FOID;
    aStringList.Values[ k00_DateCreationItem ] := DateTimeToStr( FDateCreation );
    aStringList.Values[ k00_StationIDItem ] := FStationID;
    aStringList.values[ k00_OpNatItem ] := FOpNat;
    aStringList.Values[ k00_OpRefItem ] := FOpRef;
    aStringList.Values[ k00_RecTypeItem ] := FRecType;
  end; // -- TopDivSystemRecord.getHead(..)

  // :: se encarga de calcular el código de control de la cabecera. De esta forma se pueden averiguar si ha habido manipulación de los datos
  function TOpDivSystemRecord.getHeadCode: String;
  begin
    result := theCutreCriptoEngine.getCodeA(
          kCodeSeparator + FOID
        + kCodeSeparator + DateTimeToStr( FDateCreation )
        + kCodeSeparator + FStationID
        + kCodeSeparator + FOpRef
        + kCodeSeparator + FRecType
        + kCodeSeparator );
  end;

  procedure TOpDivSystemRecord.setData( aStringList: TStrings );
  var
    numLines,
    iLine: Integer;
  begin

    // validaciones de control...
    // 1. debe coincidir el valor de la operación indicado en la lista de strings con el generado al inicializar el objeto
    if aStringList.IndexOfName( k00_RecTypeItem ) > kNoNameFound then
      if FRecType <> aStringList.Values[ k00_RecTypeItem ] then
        raise Exception.Create( 'El objeto se intenta rellenar con datos de otro objeto.' );


    if aStringList.IndexOfName( k00_OIDItem ) > kNoNameFound then
      FOID := aStringList.Values[ k00_OIDItem ];
    if aStringList.indexOfName( k00_StationIDItem ) > kNoNameFound then
      FStationID := aStringList.Values[ k00_StationIDItem ];
    if aStringList.IndexOfName( k00_DateCreationItem ) > kNoNameFound then
      FDateCreation := strToDateTime( aStringList.Values[ k00_DateCreationItem ] );
    if aStringList.IndexOfName( k00_OpNatItem ) > kNoNameFound then
      FOpNat := aStringList.Values[ k00_OpNatItem ];
    if aStringList.IndexOfName( k00_OpRefItem ) > kNoNameFound then
      FOpRef := aStringList.Values[ k00_OpRefItem ];

    if aStringList.IndexOfName( k00_EntOficOrigenItem ) > kNoNameFound then
      FEntOficOrigen := aStringList.Values[ k00_EntOficOrigenItem ];
    if aStringList.IndexOfName( k00_EntOficDestinoItem ) > kNoNameFound then
      FEntOficDestino := aStringList.Values[ k00_EntOficDestinoItem ];
    if aStringList.IndexOfName( k00_NumCtaDestinoItem ) > kNoNameFound then
      FNumCtaDestino := aStringList.Values[ k00_NumCtaDestinoItem ];
    if aStringList.IndexOfName( k00_DivisaOperacionItem ) > kNoNameFound then
      FDivisaOperacion := strToInt( aStringList.Values[ k00_DivisaOperacionItem ] );
    if aStringList.IndexOfName( k00_ImportePrinOpItem ) > kNoNameFound then
      FImportePrinOp := strToFloat( ReplaceStr( aStringList.Values[ k00_ImportePrinOpItem ], '.', ',' ) );
    if aStringList.IndexOfName( k00_ImporteOrigOpItem ) > kNoNameFound then
      FImporteOrigOp := strToFloat( ReplaceStr( aStringList.Values[ k00_ImporteOrigOpItem ], '.', ',' ) );
    if aStringList.IndexOfName( k00_ClaveAutorizaItem ) > kNoNameFound then
      FClaveAutoriza := aStringList.Values[ k00_ClaveAutorizaItem ];
    if aStringList.IndexOfName( k00_IncluirSoporteItem ) > kNoNameFound then
      FIncluirSoporte := StrToBool( aStringList.Values[ k00_IncluirSoporteItem ] );

    // 07.05.02 - hay que leer las líneas del campo observaciones.
    if aStringList.IndexOfName( k00_NumLineasObservaItem ) > kNoNameFound then
    begin
      numLines := strToInt( aStringList.Values[k00_NumLineasObservaItem] );

      for iLine := 0 to numLines-1 do
        if aStringList.IndexOfName( k00_PrefixLineaObservaIten + AddChar('0', intToStr(iLine), 2) ) > kNoNameFound then
          FObservaciones.Add( aStringList.Values[ k00_PrefixLineaObservaIten + AddChar('0', intToStr(iLine), 2) ] )
        else
          FObservaciones.Add( EMPTYSTR );
    end;

  end;

  procedure TOpDivSystemRecord.getData( aStringList: TStrings );
  var
    numLines,
    iLine: Integer;
  begin
    aStringList.Clear();
    aStringList.Values[ k00_EntOficOrigenItem    ] := FEntOficOrigen;
    aStringList.Values[ k00_EntOficDestinoItem   ] := FEntOficDestino;
    aStringList.Values[ k00_DCEntOficDestinoItem ] := DCEntOficDestino;
    aStringList.Values[ k00_DCNumCtaDestinoItem  ] := DCNumCtaDestino;
    aStringList.Values[ k00_NumCtaDestinoItem    ] := FNumCtaDestino;
    aStringList.Values[ k00_DivisaOperacionItem  ] := IntToStr( FDivisaOperacion );
    aStringList.Values[ k00_ImportePrinOpItem    ] := getValidStringFromDouble( FImportePrinOp, 15, 3 );
    aStringList.Values[ k00_ClaveAutorizaItem    ] := FClaveAutoriza;
    aStringList.Values[ k00_ImporteOrigOpItem    ] := getValidStringFromDouble( FImporteOrigOp, 15, 0 );
    aStringList.Values[ k00_IncluirSoporteItem   ] := BoolToStr(FIncluirSoporte);

    // 07.05.02 - las observaciones
    numLines := FObservaciones.Count;
    if numLines > 0 then
    begin
      if numLines > kMaxLineasObserva then
        numLines := kMaxLineasObserva;

      aStringList.Values[ k00_NumLineasObservaItem ] := intToStr(numLines);
      for iLine := 0 to numLines - 1 do
        aStringList.Values[ k00_PrefixLineaObservaIten + AddChar('0', intToStr(iLine), 2) ] := FObservaciones.Strings[iLine];
    end;
  end;

  function  TopDivSystemRecord.getDataCode: String;
  begin
    result := theCutreCriptoEngine.getCodeA( Self.getStringForCodeData );
  end;

  // ************* DE CLASE **************
  class function TOpDivSystemRecord.isDocumentable: boolean;
  begin
    result := true;  // por defecto se estima que los tipos son documentales
  end;

  class function TOpDivSystemRecord.getOpNatDesc( const opNat: String ):String;
  begin
    if opNat = '1' then result := 'Cobros'
    else if opNat = '2' then result := 'Pagos'
    else result := 'N/A';
  end;

  class function TOpDivSystemRecord.getValidStringFromDouble( anImporte: Double; prec, dig: integer ): String;
  begin
    result := trim( ReplaceStr( ReplaceStr( FloatToStrF( anImporte, ffNumber, prec, dig ), '.', ''), ',', '.') );
  end;

  class function TOpDivSystemRecord.getDoubleFromString( const aString: String ): Double;
  begin
    result := StrToFloat( aString );
  end;

  class function TOpDivSystemRecord.getDayOfTheYear( fromDate: TDateTime ): word ;
  const
    diasAcumMeses: array [boolean] of array [1..12] of integer =
      ( ( 0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334 ),
        ( 0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335 ) );
  var
    anno,
    mes,
    dia: word;
  begin
    DecodeDate( fromDate, anno, mes, dia );
    result := diasAcumMeses[ isLeapYear( anno ) ][ mes ] + dia;
  end;


(**********
 MÉTODOS PRIVADOS
 **********)

  //********************************
  // :: de soporte a las propiedades
  //********************************
  procedure TOpDivSystemRecord.setOpNat( const aString: String );
  var
    texto: string;
  begin
    texto := trim( aString );
    if FOpNatFixed and ( texto <> FOpNat ) then
    begin
      dataErrorEventCall(k00_OpNatItem, 'No se puede cambiar el valor de la "Naturaleza de la operación" en este tipo.');
//      raise Exception.Create( 'No se puede cambiar el valor de la "Naturaleza de la operación" en este tipo.' );
      Exit;
    end;
    if (texto <> '1') and (texto <> '2') then
    begin
      dataErrorEventCall(k00_OpNatItem, 'Sólo se permiten los valores "1" o "2" como válidos para la "Naturaleza de la operación".');
//      raise Exception.Create( 'Sólo se permiten los valores "1" o "2" como válidos para la "Naturaleza de la operación".' );
      Exit;
    end;

    if FOpNat <> texto then
    begin
      FopNat := texto;
      changeEventCall();
    end
  end;

  procedure TOpDivSystemRecord.setOpRef(const aString:String);
  var
    referencia: String;
  begin
    referencia := AddChar('0', Trim(aString), 16);
    if ReplaceStr(referencia,'0','') = EmptyStr then
      referencia := MS('0', 15) + '?';
    if FOpRef <> referencia then
    begin
      if referencia[16] <> '?' then
        if not testReferenciaOperacion(referencia) then
        begin
          dataErrorEventCall(k00_OpRefItem, 'La referencia introducida no es válida.');
//          raise Exception.Create('La referencia introducida no es válida.');
          Exit;
        end;

      FOpRef := referencia;
      changeEventCall();
    end
  end;

  procedure TOpDivSystemRecord.setEntOficOrigen( const aString: String );
  var
    texto: String;
  begin
    texto := trim( aString );
    if texto <> EmptyStr then
    begin
      if length( texto ) < 8 then
        raise Exception.Create( 'Se debe indicar la entidad y la oficina.' );

      if FEntOficOrigen <> texto then
      begin
        if not theQueryEngine.existsOfiCaja( copy( texto, 5, 4 ) ) then
        begin
          dataErrorEventCall(k00_EntOficOrigenItem, 'La oficina de La Caja señalada no existe en la BB.DD.');
//          raise Exception.Create( 'La oficina de La Caja señalada no existe en la BB.DD.' );
          Exit;
        end
        else
        begin
        FEntOficOrigen := texto;
        changeEventCall();
        end
      end
    end
  end;

  function  TOpDivSystemRecord.getOficOrigenName: String;
  var
    oficinaCode: String;
  begin
    oficinaCode := trim( copy( FEntOficOrigen, 5, 4 ) );
    if oficinaCode <> EmptyStr then
      result := theQueryEngine.getOfiCajaName( oficinaCode )
    else
      result := '';
  end;

  procedure TOpDivSystemRecord.setEntOficDestino( const aString: String );
  var
    entidad,
    oficina: String;
//    texto: String;
  begin
    entidad := Trim(Copy(ReplaceStr(aString, '-', ''), 1, 4));
    oficina := Trim(Copy(ReplaceStr(aString, '-', ''), 5, 4));
//    texto := trim( ReplaceStr( aString, '-', '' ) );
    if (entidad + oficina) <> EmptyStr then
    begin
      // completamos la entidad
      if length( entidad ) < 4 then
        entidad := AddChar('0', entidad, 4);
      if length(oficina) < 4 then
        oficina := AddChar('0', oficina, 4);

//      if FEntOficDestino <> texto then
      if FEntOficDestino <> (entidad+oficina) then
      begin
        if not theQueryEngine.existsEntidad(entidad) then
        begin
          dataErrorEventCall(k00_EntOficDestinoItem, 'La entidad señalada no existe en la Base de Datos.');
          Exit;
// ***          raise Exception.Create('La entidad señalada no existe en la Base de Datos.');
        end;

        if not theQueryEngine.existsSucursal(entidad, oficina) then
          MessageDlg('La oficina indicada no existe en la Base de Datos', mtWarning, [mbOK], 0);
(*
        if not theQueryEngine.existsEntidad( copy( texto, 1, 4 ) ) then
                raise Exception.Create( 'La entidad señalada no existe en la BB.DD.' );
        if not theQueryEngine.existsSucursal( copy( texto, 1, 4 ), copy( texto, 5, 4 ) ) then
          MessageDlg( 'La oficina indicada no existe.', mtWarning, [mbOk], 0);
*)
(* 08-10-2001: En caso de que no exista la sucursal no salimos con error, sino que se notifica
          raise Exception.Create( 'La sucursal asociada a la entidad señaladas no existe en la BB.DD.' );
*)
//        FEntOficDestino := texto;
        FEntOficDestino := entidad + oficina; 
        changeEventCall();
      end
    end
  end;

  function  TOpDivSystemRecord.getEntDestinoName: String;
  var
    entidadCode: String;
  begin
    entidadCode := trim( copy( FEntOficDestino, 1, 4 ) );
    if trim( ReplaceStr( entidadCode, '0', '' ) ) <> EmptyStr then
      result := theQueryEngine.getEntidadName( entidadCode )
    else
      result := '';
  end;

  procedure TOpDivSystemRecord.setNumCtaDestino( const aString: String );
  var
    texto: String;
  begin
    texto := trim( aString );
    if texto <> EmptyStr then
    begin
      if length( texto ) < 10 then
        texto := addChar( '0', texto, 10 );

      if FNumCtaDestino <> texto then
      begin
        FNumCtaDestino := texto;
        changeEventCall();
      end
    end
  end;

  function  TOpDivSystemRecord.getDCEntOficDestino: String;
  const
    kPesos: array [1..8] of integer =
       ( 4,8,5,10,9,7,3,6 );
  var
    suma,
    dc,
    contador: integer;
  begin
    suma := 0;
    for contador := 1 to 8 do
      suma := suma + ( strToInt( FEntOficDestino[ contador ] ) * kPesos[ contador ] );
    dc := 11 - (suma mod 11);
    if dc = 10 then dc := 1;
    if dc = 11 then dc := 0;
    result := trim( intToStr( dc ) );
  end;

  function  TOpDivSystemRecord.getDCNumCtaDestino: String;
  const
    kPesos: array [1..10] of integer =
       ( 1,2,4,8,5,10,9,7,3,6 );
  var
    suma,
    dc,
    contador: integer;
  begin
    suma := 0;
    for contador := 1 to 10 do
      suma := suma + ( strToInt( FNumCtaDestino[ contador ] ) * kPesos[ contador ] );
    dc := 11 - (suma mod 11);
    if dc = 10 then dc := 1;
    if dc = 11 then dc := 0;
    result := trim( intToStr( dc ) );
  end;

  procedure TOpDivSystemRecord.setDivisaOperacion( aDivisa: TDivisaOperacion );
  const
    klValEuro = 0;
    klValPta  = 1;
    klEuro2Pta = 166.386;
  begin
    if FDivisaOperacion <> aDivisa then
    begin
      if aDivisa = klValEuro then FImporteOrigOp := 0.0
      else
      begin
        FImporteOrigOp := 0.0;
        FImportePrinOp := 0.0;
      end;
      FDivisaOperacion := aDivisa;
      changeEventCall();
    end;
  end;

  procedure TOpDivSystemRecord.setImportePrinOp( anImporte: Double );
  var
    oldImporte: Double;
  begin
    if anImporte < 0.0 then
    begin
      dataErrorEventCall(k00_ImportePrinOpItem, 'El importe no puede ser inferior a 0,00 euros.');
//      raise Exception.Create( 'El importe no puede ser inferior a 0 euros.' );
    end
    else if FImportePrinOp <> anImporte then
    begin
      oldImporte := FImportePrinOp;
      FImportePrinOp := anImporte ;
      try
        TestImportePrinOp();
      except
        FImportePrinOp := oldImporte;
        raise;
      end;
      if not FExternalImporteSet then  // si no se fija desde el exterior, se indica que es cero
        FImporteOrigOp := 0.0;   
      changeImporteOperacion();
      changeEventCall();
    end
  end;

  procedure TOpDivSystemRecord.setImporteOrigOp( anImporte: Double );
  const
    klEuro2Pta = 166.386;
  begin
    if anImporte < 0.0 then
    begin
      dataErrorEventCall(k00_ImporteOrigOpItem, 'El importe no puede ser inferior a 0 pesetas.');
//      raise Exception.Create( 'El importe no puede ser inferior a 0 pesetas.' );
    end
    else if FImporteOrigOp <> anImporte then
    begin
      if not FExternalImporteSet then
        FImportePrinOp := round( ( anImporte / klEuro2Pta ) * 100.0 ) / 100.0 ;  // redondeamos a 3 cifras
      FImporteOrigOp := anImporte;
      changeImporteOperacion();
      changeEventCall();
    end
  end;

  procedure TOpDivSystemRecord.setImporteOperacion( anImporte: Double );
  const
    klValEuro = 0;
  begin
    if FDivisaOperacion = klValEuro then ImportePrinOp := anImporte
    else                                 ImporteOrigOp := anImporte;
  end;

  procedure TOpDivSystemRecord.setClaveAutoriza( const aString: String );
  var
    texto: String;
  begin
    texto := AddChar( '0', trim( aString ), 18 );
    if ( ReplaceStr(texto, '0', '') = EmptyStr ) and FClaveAutorizaEsObligatoria then
    begin
      dataErrorEventCall(k00_ClaveAutorizaItem, 'Es obligatorio indicar la Clave de Autorización');
//      raise Exception.Create( 'Es obligatorio indicar la Clave de Autorización' );
    end
    else if texto <> FClaveAutoriza then
    begin
      // cuando se intente introducir una, aunque sea "opcional", se debe indicar una válida
      if not testClaveAutoriza(texto) then
      begin
        dataErrorEventCall(k00_ClaveAutorizaItem, getClaveAutErrorMsg());
        Exit;
      end;
      FClaveAutoriza := texto;
      changeEventCall();
    end
  end;

  procedure TOpDivSystemRecord.setIncluirSoporte(incluir: Boolean);
  begin
    if FIncluirSoporte <> incluir then
    begin
      FIncluirSoporte := incluir;
      changeEventCall();
    end
  end;

  procedure TOpDivSystemRecord.setGeneralChange( aNotifyEvent: TNotifyChangeDataEvent );
  begin
    FGeneralChange := aNotifyEvent ;
    if assigned( FGeneralChange ) then
      FGeneralChange( Self );
  end;

  procedure TOpDivSystemRecord.setDataErrorEvent(aNotifyEvent: TNotifyDataErrorEvent);
  begin
    FDataErrorEvent := aNotifyEvent;
  end;

  //********************************
  // :::: de validación
  //********************************

  procedure TOpDivSystemRecord.ValidateEntOficOrigen;
  var
    texto : String;
  begin
    texto := trim( ReplaceStr( FEntOficOrigen, '0', '' ) );
    if texto = EmptyStr then
      dataErrorEventCall(k00_EntOficOrigenItem, 'Se debe indicar un valor válido para la Entidad-Oficina de Origen.');
//      raise Exception.Create( 'Se debe indicar un valor válido para la Entidad-Oficina de Origen.' );
  end;

  procedure TOpDivSystemRecord.ValidateEntOficDetino;
  var
    texto: String;
  begin
    texto := trim( ReplaceStr( FEntOficDestino, '0', '' ) );
    if texto = EmptyStr then
      dataErrorEventCall(k00_EntOficDestinoItem, 'Se debe indicar un valor válido para la Entidad-Oficina de Destino.')
//      raise Exception.Create( 'Se debe indicar un valor válido para la Entidad-Oficina de Destino.' );
  end;

  procedure TOpDivSystemRecord.ValidateNumCtaDestino;
  var
    texto : String;
  begin
    if FNumCtaDestinoEsObligatoria then
    begin
      texto := trim( replaceStr( FNumCtaDestino, '0', '' ) );
      if texto = EmptyStr then
        dataErrorEventCall(k00_NumCtaDestinoItem, 'Se debe indicar un valor válido para el Número de Cta.');
//        raise Exception.Create( 'Se debe indicar un valor válido para el Número de Cta.' );

    end;
    // lo reajustamos...
    FNumCtaDestino := AddChar( '0', FNumCtaDestino, 10 );
  end;

  procedure TOpDivSystemRecord.validateImportePrinOp;
  begin
    // se debe indicar un valor principal...
    if FImportePrinOp = 0.0 then
      dataErrorEventCall(k00_ImportePrinOpItem, 'Se debe indicar un Importe diferente de 0 para la operación.');
//      raise Exception.Create( 'Se debe indicar un Importe diferente de 0 para la operación.' );
  end;

  procedure TOpDivSystemRecord.ValidateClaveAutoriza;
  begin
    if FClaveAutorizaEsObligatoria then
    begin
      if Trim( ReplaceStr( FClaveAutoriza, '0', '' ) ) = EmptyStr then
        dataErrorEventCall(k00_ClaveAutorizaItem, 'Se debe señalar una Clave de Autorización válida.');
//        raise Exception.Create( 'Se debe señalar una Clave de Autorización válida.' );
    end
  end;

  procedure TOpDivSystemRecord.TestImportePrinOp;
  begin
    // ... no se hace nada, se encarga de hacerlo cada operación
  end;

  // *** otros métodos auxiliares

  procedure TOpDivSystemRecord.changeImporteOperacion;
  begin
    //: no se hace nada...
  end;

  procedure TOpDivSystemRecord.initializeData;
  begin

    FStationID := getStationID();
    FDateCreation := now();
    FOID := FStationID + FormatDateTime( 'yyyymmddhhnnsszzz', FDateCreation );

    // FOpNat    -- se debe indicar en los descendientes
    // FRecType  -- se debe indicar en los descendientes
    FOpRef := '2052' + formatDateTime( 'yyyy', FDateCreation )[4] + AddChar( '0', IntToStr( getDayOfTheYear( FDateCreation ) ), 3 ) + MS( '0', 7 ) + '?';

    FEntOficOrigen  := '20528888';
    FEntOficDestino := MS( '0', 8 );
    FNumCtaDestino  := MS( '0', 10 );
    if date() > strToDate( '31/12/2001' ) then
      FDivisaOperacion := kDivisaEuro
    else
      FDivisaOperacion := kDivisaPta;
    FImportePrinOp := 0.0;
    FImporteOrigOp := 0.0;
    FClaveAutoriza := MS( '0', 18 );

    FOpNatFixed := false;  // por defecto se suponque que no es fijo, pero debe ser indicado en los descendientes
    FNumCtaDestinoEsObligatoria := false;
    FClaveAutorizaEsObligatoria := false;

    FExternalImporteSet := false;

    FGeneralChange  := nil;
    FDataErrorEvent := nil;

    FIncluirSoporte := True;

    // 07.05.02 -- observaciones
    FObservaciones.Clear();

  end;

  procedure TOpDivSystemRecord.readStringList( aStringList: TStrings );
  begin
    // escribimos los datos extraídos de la lista
(*    if aStringList.IndexOfName( kNameOfOID ) <> kNoNameFound then
      FOID := aStringList.Values[ kNameOfOID ];
    if aStringList.IndexOfName( kNameOfDateCreation ) <> kNoNameFound then
      FDateCreation := StrToDateTime( aStringList.Values[ kNameOfDateCreation ] );
    if aStringList.IndexOfName( kNameOfStationID ) <> kNoNameFound then
      FStationID := aStringList.Values[ kNameOfStationID ];
    if aStringList.IndexOfName( kNameOfOpRef ) <> kNoNameFound then
      FOpRef := aStringList.Values[ kNameOfOpRef ];
    if aStringList.IndexOfName( kNameOfRecType ) <> kNoNameFound then
      FRecType := aStringList.Values[ kNameOfRecType ];
    if aStringList.IndexOfName( kNameOfOpNat ) <> kNoNameFound then
      FOpNat := aStringList.Values[ kNameOfOpNat ];
*)  end;

  function  TOpDivSystemRecord.getStringForCodeData: String;
  begin
    result := kCodeSeparator + FStationID
            + kCodeSeparator + FOpNat
            + kCodeSeparator + FRecType
            + kCodeSeparator + FOpRef
            + kCodeSeparator + FEntOficOrigen
            + kCodeSeparator + FEntOficDestino
            + kCodeSeparator + DCEntOficDestino
            + kCodeSeparator + DCNumCtaDestino
            + kCodeSeparator + FNumCtaDestino
            + kCodeSeparator + intToStr( FDivisaOperacion )
            + kCodeSeparator + getValidStringFromDouble( FImportePrinOp, 15, 3 )
            + kCodeSeparator + getValidStringFromDouble( FImporteOrigOp, 15, 0 );
  end;

  procedure TOpDivSystemRecord.changeEventCall;
  begin
    if assigned( FGeneralChange ) then FGeneralChange( Self );
  end;

  procedure TOpDivSystemRecord.dataErrorEventCall(const ErrorField, ErrorMsg: String);
  begin
    if assigned(FDataErrorEvent) then FDataErrorEvent(Self, ErrorField, ErrorMsg);
  end;

  function TOpDivSystemRecord.testIndexOf( aStringList: TStrings; aName: String ): boolean;
  begin
    Result := ( aStringList.IndexOfName( aName ) > kNoNameFound );
  end;

end.
