unit COpDivRecType09;

(*******************************************************************************
 * CLASE: TOpDivRecType09                                                      *
 * FECHA CREACION: 07-08-2001                                                  *
 * PROGRAMADOR: Saulo Alvarado Mateos                                          *
 * DESCRIPCIÓN:                                                                *
 *       Implementación del registro tipo 09 - Compraventa de moneda extranjera*
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
    k09_ImporteDivisaItem     = '11.01';
    k09_CodigoDivisaItem      = '11.02';
    k09_FechaContratacionItem = '11.03';
    k09_TipoCambioItem        = '11.04';
    k09_Disponible            = '11.05';

  type
    TOpDivRecType09 = class( TOpDivSystemRecord )
      protected
        //: datos del registro
        FimporteDivisa: Double;         // importe en la divisa de la operación
        FCodigoDivisa: String;          // Código ISO de la divisa
        FFechaContratacion: TDateTime;  // Fecha de la contratación de la operación
        FTipoCambio: Double;            // Euro contra divisa. Factor de conversión divisa / euro en el caso de monedas IN
        FDisponible: String;            // Disponible (204 caracteres)

        //*****
        // métodos de soporte a las propiedades
        //*****
        procedure setImporteDivisa( anImporte: Double );
        procedure setCodigoDivisa( const aString: String );
        procedure setFechaContratacion( aDate: TDateTime );
        procedure setTipoCambio( aDouble: Double );
        procedure setDisponible( const aString: String );

        //:: otros métodos de soporte
        procedure initializeData; override;
        function  getStringForCodeData: String; override;

        //:: procedimientos de validación
        procedure validaDivisa; virtual;
        procedure validaImportes; virtual;

        // 07.05.02
        function  printSpecificType: String; override;
        procedure printSpecificData( aDataString: TStringList ); override;

      public
        // **** PROPIEDADES ****
        //: creamos las propiedades inherentes a este tipo de registro
        property ImporteDivisa: Double read FimporteDivisa write setImporteDivisa;
        property CodigoDivisa: String read FCodigoDivisa write setCodigoDivisa;
        property FechaContratacion: TDateTime read FFechaContratacion write setFechaContratacion;
        property TipoCambio: Double read FTipoCambio write setTipoCambio;
        property Disponible: String read FDisponible write setDisponible;

        //** métodos heredados (algunos de los cuales hay que redefinir )
        procedure setData( aStringList: TStrings ); override;
        procedure getData( aStringList: TStrings ); override;
        procedure TestData; override;
        function getDataAsFileRecord: String; override;
// 07.05.02 - ahora se encargan dos métodos intermedios de imprimir la información específica del registro
//        procedure getDataAsPrintedRecord(anStrList: TStringList); override;

        class function isDocumentable: boolean; override;
    end;

implementation

  uses
    SysUtils,
    rxStrUtils,
    CCriptografiaCutre,
    CQueryEngine;

(*********
 MÉTODOS PRIVADOS
 *********)

  //****** Soporte a las propiedades ******
  procedure TOpDivRecType09.setImporteDivisa( anImporte: Double );
  const
    klMinimo = 0.0;
    klErrorMinimo = 'No puede indicar un importe menor a 0.';
  begin
    if anImporte < klMinimo then
      raise Exception.Create( klErrorMinimo );
    if FImporteDivisa <> anImporte then
    begin
      FImporteDivisa := anImporte ;
      changeEventCall();
    end;
  end;

  procedure TOpDivRecType09.setCodigoDivisa( const aString: String );
  const
    klError = 'Se debe indicar un código de divisa correcto.';
  var
    texto: string;
  begin
    texto := trim( aString );
    if texto <> EmptyStr then
      if not theQueryEngine.existsDivisaISO( texto ) then
        raise Exception.Create( klError );

    if FCodigoDivisa <> texto then
    begin
      FCodigoDivisa := texto;
      changeEventCall();
    end
  end;

  procedure TOpDivRecType09.setFechaContratacion( aDate: TDateTime );
  begin
    if FFechaContratacion <> aDate then
    begin
      FFechaContratacion := aDate ;
      changeEventCall();
    end
  end;

  procedure TOpDivRecType09.setTipoCambio( aDouble: Double );
  const
    klMinimo = 0.0;
    klErrorMinimo = 'Debe indicar un valor superior o igual a cero.';
  begin
    if aDouble < klMinimo then
      raise Exception.Create( klErrorMinimo );

    if FTipoCambio <> aDouble then
    begin
      FTipoCambio := aDouble ;
      changeEventCall();
    end;
  end;

  procedure TOpDivRecType09.setDisponible( const aString: String );
  var
    texto: String;
  begin
    texto := trim( aString );
    if FDisponible <> texto then
    begin
      FDisponible := texto;
      changeEventCall();
    end;
  end;

  //***** otros métodos de soporte
  procedure TOpDivRecType09.initializeData;
  begin
    inherited;
    FRecType := '09' ;  // operación tipo 09
    FOpNat := '1';      // por defecto se supone cobro

    FOpNatFixed := false;

    // también se le van a dar valores iniciales a los datos
    FimporteDivisa := 0.0;
    FCodigoDivisa  := '';
    FFechaContratacion := date();
    FTipoCambio    := 0.0;
    FDisponible    := '';
  end;

  function TOpDivRecType09.getStringForCodeData: String;
  begin
    Result := inherited getStringForCodeData()
            + kCodeSeparator + getValidStringFromDouble( FImporteDivisa, 15, 3 )
            + kCodeSeparator + FCodigoDivisa
            + kCodeSeparator + dateToStr( FFechaContratacion )
            + kCodeSeparator + getValidStringFromDouble( FTipoCambio, 15, 6 )
            + kCodeSeparator + FDisponible
            + kCodeSeparator ;
  end;

  //:: procedimientos de validación
  procedure TOpDivRecType09.validaDivisa;
  begin
    if Trim(FCodigoDivisa) = EmptyStr then
      raise Exception.Create('Se debe indicar una divisa.'); 
  end;

  procedure TOpDivRecType09.validaImportes;
  begin
    // ninguno de los importes puede ser 0
    if FimporteDivisa <= 0.0 then
      raise Exception.Create('Se debe indicar un Importe de la divisa superior a 0.');
    if FTipoCambio <= 0.0 then
      raise Exception.Create('Se debe indicar un Tipo de cambio para la divisa superior a 0.');

    // ahora se comprueba que el importe de la operación es exáctamente el producto del importedeladivisa por el tipo de cambio
    if Abs(FImportePrinOp - (Round((FimporteDivisa / FTipoCambio)*100.0)/100.0)) > 0.001 then
      raise Exception.Create('El importe de la operación ha de coincidir con el producto del Importe de la divisa * Tipo de cambio de la divisa.');
  end;

(*********
 MÉTODOS PÚBLICOS
 *********)

  procedure TOpDivRecType09.setData( aStringList: TStrings );
  begin
    inherited setData( aStringList );

    if testIndexOf( aStringList, k09_ImporteDivisaItem ) then FImporteDivisa := strToFloat( ReplaceStr( aStringList.values[ k09_ImporteDivisaItem ], '.', ',' ) );
    if testIndexOf( aStringList, k09_CodigoDivisaItem )  then FCodigoDivisa  := aStringList.values[ k09_CodigoDivisaItem ];
    if testIndexOf( aStringList, k09_FechaContratacionItem ) then FFechaContratacion := strToDate( aStringList.Values[ k09_FechaContratacionItem ] );
    if testIndexOf( aStringList, k09_TipoCambioItem )    then FTipoCambio    := strToFloat( ReplaceStr( aStringList.Values[ k09_TipoCambioItem ], '.', ',' ) );
    if testIndexOf( aStringList, k09_Disponible )        then FDisponible    := aStringList.Values[ k09_Disponible ];
  end;

  //: devuelve los datos en forma de una StrinList <nombre>=<valor>
  procedure TOpDivRecType09.getData( aStringList: TStrings );
  begin
    inherited getData( aStringList );

    aStringList.values[ k09_ImporteDivisaItem ]     := getValidStringFromDouble( FImporteDivisa, 15, 3 );
    aStringList.values[ k09_CodigoDivisaItem ]      := FCodigoDivisa;
    aStringList.Values[ k09_FechaContratacionItem ] := dateToStr( FFechaContratacion );
    aStringList.Values[ k09_TipoCambioItem ]        := getValidStringFromDouble( FTipoCambio, 15, 6 );
    aStringList.Values[ k09_Disponible ]            := FDisponible;
  end;

  //:: se fuerza la comprobación de todos los datos
  procedure TOpDivRecType09.TestData;
  begin
    inherited;

    validaDivisa();
    validaImportes();
  end;

  //:: devuelve el contenido del registro como si se tratara del registro del archivo final
  function TOpDivRecType09.getDataAsFileRecord: String;
  begin
    Result := AddCharR( ' ', inherited getDataAsFileRecord()
         + AddChar( '0', Trim( ReplaceStr( getValidStringFromDouble( FImporteDivisa, 11, 0 ), '.', '' ) ), 11 )  // importe de la divisa
         + AddCharR( ' ', FCodigoDivisa, 3 )
         + formatDateTime( 'ddmmyyyy', FFechaContratacion )
         + AddChar( '0', Trim( ReplaceStr( getValidStringFromDouble( FTipoCambio, 12, 6 ), '.', '' ) ), 12 )
         + AddCharR( ' ', trim( FDisponible ), 204 ), 352 );
  end;

// 07.05.02 - ahora se encargan dos métodos intermedios de imprimir la información específica del registro

  function TOpDivRecType09.printSpecificType: String;
  begin
    Result := 'TIPO: 09 - COMPRAVENTA DE MONEDA EXTRANJERA';
  end;

//  procedure TOpDivRecType09.getDataAsPrintedRecord(anStrList: TStringList);
  procedure TOpDivRecType09.printSpecificData( aDataString: TStringList );
  var
    lnPtr: String;
    anStrList: TStringList; // necesario para alias del parámetro de entrada/salida
  begin
    anStrList := aDataString;

//    anStrList.Add('TIPO: 09 - COMPRAVENTA DE MONEDA EXTRANJERA');
//    anStrList.Add(MS('_',90));
//    inherited getDataAsPrintedRecord(anStrList);

    anStrList.Add(EmptyStr);
    // fecha de contratación de la operación
    lnPtr := 'FECHA DE CONTRATACIÓN DE LA OPERACIÓN : ' + FormatDateTime('dd/mm/yyyy', FFechaContratacion);
    anStrList.Add(lnPtr);
    // importe de la divisa + divisa
    lnPtr := 'IMPORTE DE LA DIVISA : ' + AddCharR(' ', FloatToStrF(FimporteDivisa, ffNumber, 11, 3), 13);
    lnPtr := lnPtr + MS(' ', 4) + 'DIVISA : ' + FCodigoDivisa + ' - ';
    if theQueryEngine.existsDivisaISO(FCodigoDivisa) then
      lnPtr := lnPtr + theQueryEngine.getDivisaName(FCodigoDivisa);
    anStrList.Add(lnPtr);
    // tipo de cambio
    lnPtr := 'TIPO DE CAMBIO...... : ' + FloatToStrF(FTipoCambio, ffNumber, 12, 6);
    anStrList.Add(lnPtr);
    anStrList.Add(EmptyStr);
    // aclaración
    lnPtr := 'IMPORTE OP.       = IMPORTE DIV.        / TIPO CAMBIO';
    anStrList.Add(lnPtr);
    lnPtr := '_________________   ___________________   _____________________';
    anStrList.Add(lnPtr);
    lnPtr := AddChar(' ', FloatToStrF(FImportePrinOp, ffNumber, 11, 2), 15) + ' €';
    lnPtr := lnPtr + ' = ' + AddChar(' ', FloatToStrF(FimporteDivisa, ffNumber, 11, 3), 15) + ' ' + FCodigoDivisa;
    lnPtr := lnPtr + ' / ' + AddChar(' ', FloatToStrF(FTipoCambio, ffNumber, 12, 6), 15) + ' €/' + FCodigoDivisa ;
    anStrList.Add(lnPtr);
  end;

  class function TOpDivRecType09.isDocumentable: boolean;
  begin
    result := false;
  end;

end.
