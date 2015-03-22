unit COpDivRecType12;

(*******************************************************************************
 * CLASE: TOpDivRecType12                                                      *
 * FECHA CREACION: 07-08-2001                                                  *
 * PROGRAMADOR: Saulo Alvarado Mateos                                          *
 * DESCRIPCIÓN:                                                                *
 *       Implementación del registro tipo 12 - Comisiones (Cobros )            *
 *                                                                             *
 * FECHA MODIFICACIÓN: 07-05-2002                                              *
 * PROGRAMADOR: Saulo Alvarado Mateos (CINCA)                                  *
 * DESCRIPCIÓN:                                                                *
 *       Se ajusta la clase a la nueva forma de impresión del registro, tenien-*
 * do ahora un par de métodos intermediarios.                                  *
 *******************************************************************************)

interface
  uses
    classes,
    CCustomDBMiddleEngine,
    COpDivSystemRecord ;

  const
    k12_ConceptoItem               = '11.01';
    k12_NumTarjetaItem             = '11.02';
    k12_ImporteComisionItem        = '11.03';
    k12_TipoImpuestoItem           = '11.04';
    k12_ImporteImpuestoItem        = '11.05';
    k12_ImporteRecompensaItem      = '11.06';
    k12_ConceptoComplementarioItem = '11.07';

  type
    TOpDivRecType12 = class( TOpDivSystemRecord )
      protected
        //: datos del registro
        FCodigoConcepto: String;        // código del concepto de la comisión
        FNumTarjeta: String;            // número de la tarjeta
        FImporteComision: Double;
        FTipoImpuesto: String;          // cuando proceda
        FImporteImpuesto: Double;
        FImporteRecompensa: Double;
        FConceptoComplementario: String;

        //*****
        // métodos de soporte a las propiedades
        //*****
        function  getConceptoIndex: integer;
        procedure setConceptoIndex( anIndex: Integer );
        procedure setNumTarjeta( const aString: String );
        procedure setImporteComision( aDouble: Double );
        function  getImpuestoIndex: integer;
        procedure setImpuestoIndex( anIndex: Integer );
        procedure setImporteImpuesto( aDouble: Double );
        procedure setImporteRecompensa( aDouble: Double );
        procedure setConceptoComplementario( const aString: String );

        //:: otros métodos de soporte
        procedure initializeData; override;
        function  getStringForCodeData: String; override;

        //:: procedimientos de validación
        procedure validaImporte;

        // 07.05.02
        function  printSpecificType: String; override;
        procedure printSpecificData( aDataString: TStringList ); override;

      public
        // **** PROPIEDADES ****
        //: creamos las propiedades inherentes a este tipo de registro
        property ConceptoIndex: Integer read getConceptoIndex write setConceptoIndex;
        property NumTarjeta: String read FNumTarjeta write setNumTarjeta;
        property ImporteComision: Double read FImporteComision write setImporteComision;
        property ImpuestoIndex: Integer read getImpuestoIndex write setImpuestoIndex;
        property ImporteImpuesto: Double read FImporteImpuesto write setImporteImpuesto;
        property importeRecompensa: Double read FImporteRecompensa write setImporteRecompensa;
        property ConceptoComplementario: String read FConceptoComplementario write setConceptoComplementario;

        //** métodos heredados (algunos de los cuales hay que redefinir )
        procedure setData( aStringList: TStrings ); override;
        procedure getData( aStringList: TStrings ); override;
        procedure TestData; override;
        function getDataAsFileRecord: String; override;
// 07.05.02 - ahora se encargan dos métodos intermedios de imprimir la información específica del registro
//        procedure getDataAsPrintedRecord(anStrList: TStringList); override;

    end;

implementation

  uses
    SysUtils,
    rxStrUtils,
    CCriptografiaCutre,
    CQueryEngine;


  (*********
    CONSTANTES PRIVADAS AL MÓDULO
   *********)
  const
    kCodigosConcepto: array [0..5] of string = ( '01', '02', '03', '04', '05', '06' );
    kTiposImpuesto: array [0..2] of string = ( '1', '2', '3' );


(*********
 MÉTODOS PRIVADOS
 *********)

  //****** Soporte a las propiedades ******
  function  TOpDivRecType12.getConceptoIndex: integer;
  begin
    result := strToInt( FCodigoConcepto ) - 1 ;
  end;

  procedure TOpDivRecType12.setConceptoIndex( anIndex: Integer );
  var
    codigo: String;
  begin
    codigo := kCodigosConcepto[ anIndex ];
    if FCodigoConcepto <> codigo then
    begin
      FCodigoConcepto := codigo;
      // ahora debemos reajustar otros parámetros...
      if not ( anIndex in [ 0, 1 ] ) then
      begin
        FNumTarjeta := EmptyStr ;
        FTipoImpuesto := EmptyStr;
        FImporteImpuesto := 0.0;
      end;
      if anIndex <> 1 then
        FImporteRecompensa := 0.0;
      changeEventCall();
    end
  end;

  procedure TOpDivRecType12.setNumTarjeta( const aString: String );
  const
    klErrorNoAplicable = 'No se puede introducir este dato cuando no se trata de una "recuperación de tarjeta".';
  var
    texto: String;
  begin
    texto := trim( aString );
    if FNumTarjeta <> texto then
    begin
      if ( FCodigoConcepto <> '01' ) and ( FCodigoConcepto <> '02' ) then
        raise Exception.Create( klErrorNoAplicable );
        
      FNumTarjeta := texto;
      changeEventCall();
    end;
  end;

  procedure TOpDivRecType12.setImporteComision( aDouble: Double );
  const
    klErrorMinimo = 'Debe indicar un importe superior a cero.';
  begin
    if aDouble < 0.0 then
      raise Exception.Create( klErrorMinimo );

    if FImporteComision <> aDouble then
    begin
      FImporteComision := aDouble;
      changeEventCall();
    end;
  end;

  function  TOpDivRecType12.getImpuestoIndex: integer;
  begin
    if FTipoImpuesto = EmptyStr then
      result := -1
    else
      result := strToInt( FTipoImpuesto ) - 1 ;
  end;

  procedure TOpDivRecType12.setImpuestoIndex( anIndex: Integer );
  const
    klError = 'No se puede establecer el tipo de impuesto para este Concepto.';
  var
    tipo: String;
  begin
    if anIndex = -1 then tipo := EmptyStr
    else
      tipo := kTiposImpuesto[ anIndex ];

    if tipo <> EmptyStr then
      if ( FCodigoConcepto <> '01' ) and ( FCodigoConcepto <> '02' ) then
        raise Exception.Create( klError ); 

    if FTipoImpuesto <> tipo then
    begin
      FTipoImpuesto := tipo;
      changeEventCall();
    end
  end;

  procedure TOpDivRecType12.setImporteImpuesto( aDouble: Double );
  const
    klErrorNoAplicable = 'No se puede indicar este valor cuando no se haya establecido un Tipo de Impuesto.';
    klErrorMinimo = 'No se puede introducir una cantidad inferior a 0.';
  begin
    if FImporteImpuesto <> aDouble then
    begin
      if FTipoImpuesto = EmptyStr then
        raise Exception.Create( klErrorNoAplicable );
      if aDouble < 0.0 then
        raise Exception.Create( klErrorMinimo );

      FImporteImpuesto := aDouble;
      changeEventCall();
    end
  end;

  procedure TOpDivRecType12.setImporteRecompensa( aDouble: Double );
  const
    klErrorNoAplicable = 'No se puede aplicar un valor a este dato cuando no se trata de una "Recuperación de Tarjeta en Comercio".';
    klErrorMinimo = 'No se puede introducir una cantidad inferior a 0.';
  begin
    if FImporteRecompensa <> aDouble then
    begin
      if aDouble <> 0.0 then
      begin
        if FCodigoConcepto <> '02' then
          raise Exception.Create( klErrorNoAplicable );
        if aDouble < 0.0 then
          raise Exception.Create( klErrorMinimo );
      end;

      FImporteRecompensa := aDouble;
      changeEventCall();
    end
  end;

  procedure TOpDivRecType12.setConceptoComplementario( const aString: String );
  var
    texto: string;
  begin
    texto := Trim( aString );
    if FConceptoComplementario <> texto then
    begin
      FConceptoComplementario := texto ;
      changeEventCall();
    end
  end;


  //***** otros métodos de soporte
  procedure TOpDivRecType12.initializeData;
  begin
    inherited;
    FRecType := '12' ;  // operación tipo 12
    FOpNat := '1';      // siempre es un cobro
    FOpNatFixed := true;
    
    // también se le van a dar valores iniciales a los datos
    FCodigoConcepto    := '01';  // se supone que el primer caso (recuperación de tarjeta en entidad de crédito)
    FNumTarjeta        := EmptyStr;
    FImporteComision   := 0.0;
    FTipoImpuesto      := '2';  // estamos en Canarias, por lo que inicialmente es IGIC
    FImporteImpuesto   := 0.0;
    FImporteRecompensa := 0.0;
    FConceptoComplementario := EmptyStr;
  end;

  function TOpDivRecType12.getStringForCodeData: String;
  begin
    Result := inherited getStringForCodeData()
            + kCodeSeparator + FCodigoConcepto
            + kCodeSeparator + FNumTarjeta
            + kCodeSeparator + getValidStringFromDouble( FImporteComision, 15, 3 )
            + kCodeSeparator + FTipoImpuesto
            + kCodeSeparator + getValidStringFromDouble( FImporteImpuesto, 15, 3 )
            + kCodeSeparator + getValidStringFromDouble( FImporteRecompensa, 15, 3 )
            + kCodeSeparator + FConceptoComplementario
            + kCodeSeparator ;
  end;

  procedure TOpDivRecType12.validaImporte;
  begin
    if Abs(FImportePrinOp - (FImporteImpuesto + FImporteComision + FImporteRecompensa)) > 0.005 then
      raise Exception.Create('El Importe de la operación debe ser equivalente a la suma del Importe Impuestos + Importe Comisiones + Importe de Recompensa.');
  end;

(*********
 MÉTODOS PÚBLICOS
 *********)

  procedure TOpDivRecType12.setData( aStringList: TStrings );
  begin
    inherited setData( aStringList );

    if testIndexOf( aStringList, k12_ConceptoItem )        then FCodigoConcepto := aStringList.Values[ k12_ConceptoItem ];
    if testIndexOf( aStringList, k12_NumTarjetaItem )      then FNumTarjeta   := aStringList.Values[ k12_NumTarjetaItem ];
    if testIndexOf( aStringList, k12_ImporteComisionItem ) then FImporteComision := strToFloat( ReplaceStr( aStringList.Values[ k12_ImporteComisionItem ], '.', ',' ) );
    if testIndexOf( aStringList, k12_TipoImpuestoItem )    then FTipoImpuesto := aStringList.Values[ k12_TipoImpuestoItem ];
    if testIndexOf( aStringList, k12_ImporteImpuestoItem ) then FImporteImpuesto := strToFloat( ReplaceStr( aStringList.Values[ k12_ImporteImpuestoItem ], '.', ',' ) );
    if testIndexOf( aStringList, k12_ImporteRecompensaItem ) then FImporteRecompensa :=  strToFloat( ReplaceStr( aStringList.Values[ k12_ImporteRecompensaItem ], '.', ',' ) );
    if testIndexOf( aStringList, k12_ConceptoComplementarioItem ) then FConceptoComplementario := aStringList.Values[ k12_ConceptoComplementarioItem ];
  end;

  //: devuelve los datos en forma de una StrinList <nombre>=<valor>
  procedure TOpDivRecType12.getData( aStringList: TStrings );
  begin
    inherited getData( aStringList );

    aStringList.Values[ k12_ConceptoItem ]         := FCodigoConcepto ;
    aStringList.Values[ k12_NumTarjetaItem ]       := FNumTarjeta ;
    aStringList.Values[ k12_ImporteComisionItem ]  := getValidStringFromDouble( FImporteComision, 15, 3 );
    aStringList.Values[ k12_TipoImpuestoItem ]     := FTipoImpuesto ;
    aStringList.Values[ k12_ImporteImpuestoItem ]  := getValidStringFromDouble( FImporteImpuesto, 15, 3 );
    aStringList.Values[ k12_ImporteRecompensaItem ] := getValidStringFromDouble( FImporteRecompensa, 15, 3 );
    aStringList.Values[ k12_ConceptoComplementarioItem ] := FConceptoComplementario;
  end;

  //:: se fuerza la comprobación de todos los datos
  procedure TOpDivRecType12.TestData;
  begin
    inherited;

    validaImporte();
  end;

  //:: devuelve el contenido del registro como si se tratara del registro del archivo final
  function TOpDivRecType12.getDataAsFileRecord: String;
  begin
    result := AddCharR( ' ',inherited getDataAsFileRecord()
         + FCodigoConcepto
         + AddChar( '0', trim( FNumTarjeta ), 16 )
         + AddChar( '0', Trim( ReplaceStr( getValidStringFromDouble( FImporteComision, 6, 2 ), '.', '' ) ), 6 )
         + FTipoImpuesto
         + AddChar( '0', Trim( ReplaceStr( getValidStringFromDouble( FImporteImpuesto, 6, 2 ), '.', '' ) ), 6 )
         + AddChar( '0', Trim( ReplaceStr( getValidStringFromDouble( FImporteRecompensa, 6, 2 ), '.', '' ) ), 6 )
         + AddCharR( ' ', FConceptoComplementario, 80 ), 352 );
  end;

// 07.05.02 - ahora se encargan dos métodos intermedios de imprimir la información específica del registro

  function TOpDivRecType12.printSpecificType: String;
  begin
    Result := 'TIPO: 12 - COMISIONES';
  end;

//  procedure TOpDivRecType12.getDataAsPrintedRecord(anStrList: TStringList);
  procedure TOpDivRecType12.printSpecificData( aDataString: TStringList );
  var
    lnPtr: String;
    anStrList: TStringList;  // alias necesario para no cambiar todo el código escrito
  begin
    anStrList := aDataString;

//    anStrList.Add('TIPO: 12 - COMISIONES');
//    anStrList.Add(MS('_',90));
//    inherited getDataAsPrintedRecord(anStrList);

    anStrList.Add(EmptyStr);
    // concept
    lnPtr := 'CONCEPTO : ' + FCodigoConcepto + ' - ' ;
    if      FCodigoConcepto = '01' then
      lnPtr := lnPtr + 'RECUPERACIÓN DE TARJETA EN ENTIDAD DE CRÉDITO'
    else if FCodigoConcepto = '02' then
      lnPtr := lnPtr + 'RECUPERACIÓN DE TARJETA EN COMERCIO'
    else if FCodigoConcepto = '03' then
      lnPtr := lnPtr + 'COMISIONES COMPENSATORIAS POR CANALIZACIÓN INDEBIDA DE DOCUMENTOS'
    else if FCodigoConcepto = '04' then
      lnPtr := lnPtr + 'SOLICITUD DE TRUNCADOS'
    else if FCodigoConcepto = '05' then
      lnPtr := lnPtr + 'AVALES ENTRE ENTIDADES'
    else if FCodigoConcepto = '06' then
      lnPtr := lnPtr + 'OTRAS COMISIONES'
    else
       lnPtr := lnPtr + '??????';
    anStrList.Add(lnPtr);
    // número de tarjeta
    if (FCodigoConcepto = '01') or (FCodigoConcepto = '02') then
    begin
      lnPtr := 'NÚMERO DE TARJETA : ' + FNumTarjeta;
      anStrList.Add(lnPtr);
    end;
    // importe comisión
    lnPtr := 'IMPORTE COMISIÓN : ' + FloatToStrF( FImporteComision, ffNumber, 6, 2) + ' €';
    anStrList.Add(lnPtr);
    // tipo de impuesto + importe impuesto
    if (FCodigoConcepto = '01') or (FCodigoConcepto = '02') then
    begin
      lnPtr := 'TIPO DE IMPUESTO : ' + FTipoImpuesto + ' - ' ;
      if      FTipoImpuesto = '1' then
        lnPtr := lnPtr + 'I.V.A.'
      else if FTipoImpuesto = '2' then
        lnPtr := lnPtr + 'I.G.I.C.'
      else if FTipoImpuesto = '3' then
        lnPtr := lnPtr + 'I.P.S.I.C.C.M.'
      else
        lnPtr := lnPtr + '??????';
      lnPtr := AddCharR(' ', lnPtr, 40);
      lnPtr := lnPtr + 'IMPORTE IMPUESTO : ' + FloatToStrF( FImporteImpuesto, ffNumber, 6, 2) + ' €';
      anStrList.Add(lnPtr);
    end;
    // importe recompensa
    if (FCodigoConcepto = '02') then
    begin
      lnPtr := 'IMPORTE RECOMPENSA : ' + FloatToStrF(FImporteRecompensa, ffNumber, 6, 2) + ' €';
      anStrList.Add(lnPtr);
    end;
    // concepto complementario
    lnPtr := 'CONCEPTO COMPLEMENTARIO : ';
    anStrList.Add(lnPtr);
    lnPtr := '  ' + Trim(FConceptoComplementario);
    anStrList.Add(lnPtr);
  end;

end.
