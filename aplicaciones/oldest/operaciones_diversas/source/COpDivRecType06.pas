unit COpDivRecType06;

(*******************************************************************************
 * CLASE: TOpDivRecType06                                                      *
 * FECHA CREACION: 01-08-2001                                                  *
 * PROGRAMADOR: Saulo Alvarado Mateos                                          *
 * DESCRIPCIÓN:                                                                *
 *       Implementación del registro tipo 06 - Comisiones y gastos de crécitos *
 * y/o remesas documentarias (cobros)                                          *
 *                                                                             *
 * FECHA MODIFICACIÓN: 07-05-2002                                              *
 * PROGRAMADOR: Saulo Alvarado Mateos (CINCA)                                  *
 * DESCRIPCIÓN:                                                                *
 *       Se ajusta la clase a la nueva forma de impresión del registro, tenien-*
 * do ahora un par de métodos intermediarios.                                  *
 *                                                                             *
 * FECHA MODIFICACIÓN: 08-05-2002                                              *
 * PROGRAMADOR: Saulo Alvarado Mateos (CINCA)                                  *
 * DESCRIPCIÓN:                                                                *
 *       En la nueva especificación, se indica que el campo 11.08 -Importe del *
 * crédito- contiene dos decimales. Este cambio compromete la construcción del *
 * registro que se envía.                                                      *
 *******************************************************************************)

interface
  uses
    classes,
    CCustomDBMiddleEngine,
    COpDivSystemRecord ;

  const
    k06_TipoOperacionItem        = '11.01';
    k06_RefOrdenanteItem         = '11.02';
    k06_NumCreditoItem           = '11.03';
    k06_FechaOpItem              = '11.04';
    k06_EntidadEmisoraItem       = '11.05';
    k06_ClienteEmisorItem        = '11.06';
    k06_ClienteBeneficiarioItem  = '11.07';
    k06_ImporteCreditoItem       = '11.08';
    k06_DivisaCreditoItem        = '11.09';
    k06_ComisionesItem           = '11.10';
    k06_GastosItem               = '11.11';
    k06_DiponibleItem            = '11.12';

  type
    TOpDivRecType06 = class( TOpDivSystemRecord )
      protected
        FDivisaCredito: String;         // Código ISO de la moneda original del crédito o remesa
        FImporteCredito: Double;        // Importe del crédito o remesa
        FComisiones: Double;            // las cominisones del crédito o remesa
        FGastos: Double;                // gastos del crédito o remesa
        FTipoOperacion: String;         // 1 - crédito 2 - remesa
        FRefOrdenante: String;          // referencia del ordenante
        FNumCredito: String;            // Número del crédito o remesa
        FFechaOperacion: TDateTime;     // Fecha de la operación
        FEntidadEmisora: String;        //
        FClienteEmisor: String;         //
        FClienteBeneficiario: String;   //
        FLibre: String;                 // Campo libre

        //*****
        // métodos de soporte a las propiedades
        //*****
        procedure setDivisaCredito( const aDivisa: String );
        procedure setImporteCredito( aImporte: Double );
        procedure setComisiones( aimporte: Double );
        procedure setGastos( aImporte: Double );
        procedure setTipoOperacion( const aString: String );
        procedure setRefOrdenante( const aString: String );
        procedure setNumCredito( const aString: String );
        procedure setFechaOperacion( aFecha: TDateTime );
        procedure setEntidadEmisora( const aString: String );
        procedure setClienteEmisor( const aString: String );
        procedure setClienteBeneficiario( const aString: String );
        procedure setLibre( const aString: String );

        //:: otros métodos de soporte
        procedure initializeData; override;
        function getStringForCodeData: String; override;

        //:: validación
        procedure ValidaImportes; virtual;
        procedure ValidaDivisa; virtual;

        // 07.05.02
        function  printSpecificType: String; override;
        procedure printSpecificData( aDataString: TStringList ); override;

      public
        // **** PROPIEDADES ****
        //: creamos las propiedades inherentes a este tipo de registro
        property DivisaCredito: String read FDivisaCredito write setDivisaCredito;
        property ImporteCredito: Double read FImporteCredito write setImporteCredito;
        property Comisiones: Double read FComisiones write setComisiones;
        property Gastos: Double read FGastos write setGastos;
        property TipoOperacion: String read FTipoOperacion write setTipoOperacion;
        property RefOrdenante: String read FRefOrdenante write setRefOrdenante;
        property NumCredito: String read FNumCredito write setNumCredito;
        property FechaOperacion: TDateTime read FFechaOperacion write setFechaOperacion;
        property EntidadEmisora: String read FEntidadEmisora write setEntidadEmisora;
        property ClienteEmisor: String read FClienteEmisor write setClienteEmisor;
        property ClienteBeneficiario: String read FClienteBeneficiario write setClienteBeneficiario;
        property Libre: String read FLibre write setLibre;

        //** métodos heredados (algunos de los cuales hay que redefinir )
        procedure setData( aStringList: TStrings ); override;
        procedure getData( aStringList: TStrings ); override;
        procedure TestData; override;
        function getDataAsFileRecord: String; override;
// 07.05.02 - son ahora otros métodos, intermediarios, los que se encargan de imprimir los datos específicos
//        procedure getDataAsPrintedRecord(anStrList: TStringList); override;

        class function isDocumentable: boolean; override;

    end;

implementation

  uses
    CCriptografiaCutre,
    CQueryEngine,
    SysUtils,
    rxStrUtils;

(*********
 MÉTODOS PRIVADOS
 *********)

  //****** Soporte a las propiedades ******
  procedure TOpDivRecType06.setDivisaCredito( const aDivisa: String );
  const
    klLongitud = 3;
    klError = 'Debe indicar el código ISO de la moneda (3 caracteres)';
  var
    texto: String;
  begin
    texto := trim( aDivisa) ;
    if ( texto <> EmptyStr ) then
    begin
      if ( length( texto ) < klLongitud ) then
        raise Exception.Create( klError );
      if not theQueryEngine.existsDivisaISO( texto ) then
        raise Exception.Create( klError );
    end;
    if FDivisaCredito <> texto then
    begin
      FDivisaCredito := texto;
      changeEventCall();
    end
  end;

  procedure TOpDivRecType06.setImporteCredito( aImporte: Double );
  const
    klMinImporte = 0.0;
    klError = 'No puede indicar un importe inferior a 0';
  begin
    if aImporte < klMinImporte then
      raise Exception.Create( klError );
    if FImporteCredito <> aImporte then
    begin
      FImporteCredito := aImporte;
      changeEventCall();
    end
  end;

  procedure TOpDivRecType06.setComisiones( aimporte: Double );
  const
    klMinImporte = 0.0;
    klError = 'Debe indicar un importe superior a 0.0';
    klErrorDescuadre = 'Las Comisiones deben coincidir con la resta del Impote de la Operación menos los Gastos.';
//  var
//    oldValue: Double;
  begin
    if aImporte < klMinImporte then
      raise Exception.Create( klError );
    if FComisiones <> aImporte then
    begin
      // se comprueba que las comisiones = importe op - gastos (si están ya asignados)
(*    -- la comprobación se hace al final
      if (FImportePrinOp <> 0 ) and (FGastos <> 0) then
        if aImporte <> ( FImportePrinOp - FGastos ) then
          raise Exception.Create( klErrorDescuadre );
*)
//      oldValue := FComisiones;
      FComisiones := aImporte;
(*
      No debemos hacer este tipo de cambios automáticamente para no presuponer que
      el usuario lo ha hecho bien. También se pudo haber equivocado y así nos dará
      problemas.
      if FImportePrinOp = (FGastos + oldValue) then
        ImportePrinOp := FImportePrinOp + FGastos - oldValue + FComisiones;
*)
      changeEventCall();
    end;
  end;

  procedure TOpDivRecType06.setGastos( aImporte: Double );
  const
    klMinImporte = 0.0;
    klError = 'Debe indicar un importe superior a 0.0';
    klErrorDescuadre = 'Los Gastos deben coincidir con la resta del Impote de la Operación menos las Comisones.';
//  var
//    oldValue: Double;
  begin
    if aImporte < klMinImporte then
      raise Exception.Create( klError );
    if FGastos <> aImporte then
    begin
      // se comprueba que las comisiones = importe op - gastos (si están ya asignados)
(*    -- la comprobación se hace en el momento de guardar
      if (FImportePrinOp <> 0 ) and (FComisiones <> 0) then
        if abs( aImporte - ( FImportePrinOp - FComisiones ) ) > 0.001 then
          raise Exception.Create( klErrorDescuadre );
*)
//      oldValue := FGastos;
(*
      Es peligroso presuponer que el usuario ha insertado correctamente los valores desde el principio
      if FImportePrinOp = (FComisiones + oldValue) then
        ImportePrinOp := FImportePrinOp + FComisiones - oldValue + FGastos;
*)
      FGastos := aImporte;
      changeEventCall();
    end;
  end;

  procedure TOpDivRecType06.setTipoOperacion( const aString: String );
  const
    klTipos: set of char = ['1','2'];
    klError = 'Debe indicar un tipo válido.';
  begin
    if not ( aString[1] in klTipos ) then
      raise Exception.Create( klError );
    if FTipoOperacion <> aString[1] then
    begin
      FTipoOperacion := aString[1] ;
      changeEventCall();
    end;
  end;

  procedure TOpDivRecType06.setRefOrdenante( const aString: String );
  var
    texto: String;
  begin
    texto := trim( aString );
    if texto <> FRefOrdenante then
    begin
      FRefOrdenante := Texto;
      changeEventCall();
    end;
  end;

  procedure TOpDivRecType06.setNumCredito( const aString: String );
  var
    texto: String;
  begin
    texto := trim( aString );
    if texto <> FNumCredito then
    begin
      FNumCredito := Texto;
      changeEventCall();
    end;
  end;

  procedure TOpDivRecType06.setFechaOperacion( aFecha: TDateTime );
  begin
    if FFechaOperacion <> aFecha then
    begin
      FFechaOperacion := aFecha;
      changeEventCall();
    end;
  end;

  procedure TOpDivRecType06.setEntidadEmisora( const aString: String );
  var
    texto: String;
  begin
    texto := trim( aString );
    if FEntidadEmisora <> texto then
    begin
      FEntidadEmisora := texto;
      changeEventCall();
    end;
  end;

  procedure TOpDivRecType06.setClienteEmisor( const aString: String );
  var
    texto: String;
  begin
    texto := trim( aString );
    if FClienteEmisor <> texto then
    begin
      FClienteEmisor := texto;
      changeEventCall();
    end;
  end;

  procedure TOpDivRecType06.setClienteBeneficiario( const aString: String );
  var
    texto: String;
  begin
    texto := trim( aString );
    if FClienteBeneficiario <> texto then
    begin
      FClienteBeneficiario := texto;
      changeEventCall();
    end;
  end;

  procedure TOpDivRecType06.setLibre( const aString: String );
  var
    texto: string;
  begin
    texto := trim( aString );
    if FLibre <> texto then
    begin
      FLibre := texto;
      changeEventCall();
    end;
  end;

  //***** otros métodos de soporte
  procedure TOpDivRecType06.initializeData;
  begin
    inherited;
    FRecType := '06' ;  // operación tipo 06
    FOpNat := '1';  // siempre se trata de cobros
    //
    FOpNatFixed := true;
    FClaveAutorizaEsObligatoria := false;
    FNumCtaDestinoEsObligatoria := false;

    // también se le van a dar valores iniciales a los datos
    FDivisaCredito := '';
    FImporteCredito := 0.0;
    FComisiones := 0.0;
    FGastos := 0.0;
    FTipoOperacion := '1';  // por defecto el primero
    FRefOrdenante := '';
    FNumCredito := '';
    FFechaOperacion := 0.0;  
    FEntidadEmisora := '';
    FClienteEmisor := '';
    FClienteBeneficiario := '' ;
    FLibre := '';
  end;

  function  TOpDivRecType06.getStringForCodeData: String;
  begin
    result := inherited getDataAsFileRecord()
            + kCodeSeparator + FDivisaCredito
            + kCodeSeparator + getValidStringFromDouble( FImporteCredito, 18, 4 )
            + kCodeSeparator + FTipoOperacion
            + kCodeSeparator + FRefOrdenante
            + kCodeSeparator + FNumCredito
            + kCodeSeparator + DateToStr( FFechaOperacion )
            + kCodeSeparator + FEntidadEmisora
            + kCodeSeparator + FClienteEmisor
            + kCodeSeparator + FClienteBeneficiario
            + kCodeSeparator + getValidStringFromDouble( FComisiones, 11, 3 )
            + kCodeSeparator + getValidStringFromDouble( FGastos, 11, 3 )
            + kCodeSeparator + FLibre
            + kCodeSeparator ;
  end;

  procedure TOpDivRecType06.ValidaImportes;
  begin
    if abs(FImportePrinOp - (FComisiones + FGastos)) > 0.005 then
      raise Exception.Create('El importe de la operación debe ser igual a la suma de de las Comisiones más los Gastos.');
  end;

  procedure TOpDivRecType06.ValidaDivisa;
  begin
    if Trim(FDivisaCredito) <> EmptyStr then
      if FImporteCredito = 0.0 then
        raise Exception.Create('Debe indicar un importe del crédito cuando se ha indicado la divisa del mismo.');
  end;

(*********
 MÉTODOS PÚBLICOS
 *********)
  procedure TOpDivRecType06.setData( aStringList: TStrings );
  begin
    inherited setData( aStringList );
    if testIndexOf( aStringList, k06_DivisaCreditoItem )  then FDivisaCredito  := aStringList.values[ k06_DivisaCreditoItem ];
    if testIndexOf( aStringList, k06_ImporteCreditoItem ) then FImporteCredito := strToFloat( ReplaceStr( aStringList.Values[ k06_ImporteCreditoItem ], '.', ',' ) );
    if testIndexOf( aStringList, k06_TipoOperacionItem )  then FTipoOperacion  := aStringList.Values[ k06_TipoOperacionItem ];
    if testIndexOf( aStringList, k06_RefOrdenanteItem )   then FRefOrdenante   := aStringList.Values[ k06_RefOrdenanteItem ];
    if testIndexOf( aStringList, k06_NumCreditoItem )     then FNumCredito     := aStringList.Values[ k06_NumCreditoItem ];
    if testIndexOf( aStringList, k06_FechaOpItem )        then FFechaOperacion := strToDate( aStringList.Values[ k06_FechaOpItem ] );
    if testIndexOf( aStringList, k06_EntidadEmisoraItem ) then FEntidadEmisora := aStringList.Values[ k06_EntidadEmisoraItem ];
    if testIndexOf( aStringList, k06_ClienteEmisorItem )  then FClienteEmisor  := aStringList.Values[ k06_ClienteEmisorItem ];
    if testIndexOf( aStringList, k06_ClienteBeneficiarioItem ) then FClienteBeneficiario := aStringList.Values[ k06_ClienteBeneficiarioItem ];
    if testIndexOf( aStringList, k06_ComisionesItem )     then FComisiones     := strToFloat( ReplaceStr( aStringList.Values[ k06_ComisionesItem ], '.', ',' ) );
    if testIndexOf( aStringList, k06_GastosItem )         then FGastos         := strToFloat( ReplaceStr( aStringList.Values[ k06_GastosItem ], '.', ',' ) );
    if testIndexOf( aStringList, k06_DiponibleItem )      then FLibre          := aStringList.Values[ k06_DiponibleItem ];
  end;

  //: devuelve los datos en forma de una StrinList <nombre>=<valor>
  procedure TOpDivRecType06.getData( aStringList: TStrings );
  begin
    inherited getData( aStringList );
    aStringList.values[ k06_DivisaCreditoItem ] := FDivisaCredito;
    aStringList.Values[ k06_ImporteCreditoItem ] := getValidStringFromDouble( FImporteCredito, 16, 4 );
    aStringList.Values[ k06_TipoOperacionItem ] := FTipoOperacion ;
    aStringList.Values[ k06_RefOrdenanteItem ] := FRefOrdenante ;
    aStringList.Values[ k06_NumCreditoItem ] := FNumCredito ;
    aStringList.Values[ k06_FechaOpItem ] := DateToStr( FFechaOperacion );
    aStringList.Values[ k06_EntidadEmisoraItem ] := FEntidadEmisora ;
    aStringList.Values[ k06_ClienteEmisorItem ] := FClienteEmisor ;
    aStringList.Values[ k06_ClienteBeneficiarioItem ] := FClienteBeneficiario ;
    aStringList.Values[ k06_ComisionesItem ] := getValidStringFromDouble( FComisiones, 11, 3 );
    aStringList.Values[ k06_GastosItem ] := getValidStringFromDouble( FGastos, 11, 3 );
    aStringList.Values[ k06_DiponibleItem ] := FLibre;
  end;

  //:: se fuerza la comprobación de todos los datos
  procedure TOpDivRecType06.TestData;
  const
    klImporteComisionError = 'Debe indicar un importe mayor que 0.0 para las comisiones.';
    klimporteSumaDetalleError  = 'Debe coincidir la suma de las Comisiones y los Gastos con el Importe de la Operación.';
  begin
    inherited;

    ValidaImportes();
    ValidaDivisa();
  end;

  //:: devuelve el contenido del registro como si se tratara del registro del archivo final
  function TOpDivRecType06.getDataAsFileRecord: String;
  var
    auxFechaOp: String;
  begin
    if FFechaOperacion = 0.0 then
      auxFechaOp := MS('0', 8)
    else
      auxFechaOp := FormatDateTime('ddmmyyyy', FFechaOperacion);

    result := AddCharR( ' ', inherited getDataAsFileRecord()
         + FTipoOperacion
         + AddCharR( ' ', FRefOrdenante, 16 )
         + AddCharR( ' ', NumCredito, 16 )
//         + FormatDateTime( 'ddmmyyyy', FFechaOperacion )
         + auxFechaOp
         + AddCharR( ' ', FEntidadEmisora, 35 )
         + AddCharR( ' ', FClienteEmisor, 35 )
         + AddCharR( ' ', FClienteBeneficiario, 35 )
// 08.05.02 - Aunque parezca inaudito, ya se estaba enviando con 3 decimales en la versión antigua.
//            Sin embargo, ahora se exige que sea con 2.
//         + AddChar( '0', trim( ReplaceStr( ReplaceStr( FloatToStrF( FImporteCredito, ffNumber, 15, 3 ), ',', ''), '.', '') ), 15 )
         + AddChar( '0', trim( ReplaceStr( ReplaceStr( FloatToStrF( FImporteCredito, ffNumber, 15, 2 ), ',', ''), '.', '') ), 15 )
         + AddCharR( ' ', FDivisaCredito, 3 )
         + AddChar( '0', trim( ReplaceStr( ReplaceStr( FloatToStrF( FComisiones, ffNumber, 6, 2), ',', ''), '.', '') ), 6 )
         + AddChar( '0', trim( ReplaceStr( ReplaceStr( FloatToStrF( FGastos, ffNumber, 6, 2 ), ',', ''), '.', '') ), 6 )
         + FLibre , 352 );
  end;


// 07.05.02 - son ahora dos métodos los que se encargan de imprimir los datos específicos del registro
  function TOpDivRecType06.printSpecificType: String;
  begin
    Result := 'TIPO: 06 - COMISIONES Y GASTOS DE CRÉDITOS Y/O REMESAS DOCUMENTARIOS.';
  end;

//  procedure TOpDivRecType06.getDataAsPrintedRecord(anStrList: TStringList);
  procedure TOpDivRecType06.printSpecificData( aDataString: TStringList );
  var
    lnPtr: String;
    anStrList: TStringList;
  begin
    anStrList := aDataString;

//    anStrList.Add('TIPO: 06 - COMISIONES Y GASTOS DE CRÉDITOS Y/O REMESAS DOCUMENTARIOS.');
//    anStrList.Add(MS('_',90));
//    inherited getDataAsPrintedRecord(anStrList);

    anStrList.Add(EmptyStr);
    // tipo de operación
    lnPtr := 'TIPO DE OPERACIÓN......... : ' + FTipoOperacion + ' - ';
    if      FTipoOperacion = '1' then
      lnPtr := lnPtr + 'CRÉDITO'
    else if FTipoOperacion = '2' then
      lnPtr := lnPtr + 'REMESA'
    else
      lnPtr := lnPtr + '??????';
    anStrList.Add(lnPtr);
    // referencia del ordenante
    lnPtr := 'REFERENCIA DEL ORDENANTE.. : ' + FRefOrdenante;
    anStrList.Add(lnPtr);
    // número de crédito o remesa
    lnPtr := 'NÚMERO DE CRÉDITO O REMESA : ' + FNumCredito;
    anStrList.Add(lnPtr);
    // fecha de operación
    lnPtr := 'FECHA DE OPERACIÓN........ : ';
    if FFechaOperacion > 0.0 then
      lnPtr := lnPtr + formatDateTime('dd/mm/yyyy', FFechaOperacion);
    anStrList.Add(lnPtr);
    // entidad emisora
    lnPtr := 'ENTIDAD EMISORA........... : ' + FEntidadEmisora;
    anStrList.Add(lnPtr);
    // cliente emisor
    lnPtr := 'CLIENTE EMISOR............ : ' + FClienteEmisor;
    anStrList.Add(lnPtr);
    // cliente beneficiario
    lnPtr := 'CLIENTE BENEFICIARIO...... : ' + FClienteBeneficiario;
    anStrList.Add(lnPtr);
    // importe del crédito o remesa + divisa
    lnPtr := 'IMPORTE CRÉDITO/REMESA.... : ';
    if FImporteCredito <> 0.0 then
      lnPtr := lnPtr + AddCharR(' ', FloatToStrF(FImporteCredito, ffNumber, 15, 2), 15)
    else
      lnPtr := lnPtr + AddCharR(' ', '---', 15);
    lnPtr := lnPtr + MS(' ', 4) + 'DIVISA : ' + FDivisaCredito;
    anStrList.Add(lnPtr);
    // importe comisiones + gastos
    lnPtr := 'IMPORTE COMISIONES........ : ' + AddChar(' ', FloatToStrF(FComisiones, ffNumber, 6, 2), 6) + ' €';
    lnPtr := lnPtr + MS(' ',6);
    lnPtr := lnPtr + 'IMPORTE DE GASTOS : ' + AddChar(' ', FloatToStrF(FGastos, ffNumber, 6, 2), 6) + ' €';
    anStrList.Add(lnPtr);
    
  end;


  class function TOpDivRecType06.isDocumentable;
  begin
    Result := false;
  end;

end.

