unit COpDivRecType07;

(*******************************************************************************
 * CLASE: TOpDivRecType07                                                      *
 * FECHA CREACION: 06-08-2001                                                  *
 * PROGRAMADOR: Saulo Alvarado Mateos                                          *
 * DESCRIPCIÓN:                                                                *
 *       Implementación del registro tipo 07 - Pagos en notaría (pagos)        *
 *                                                                             *
 * FECHA MODIFICACION: 05-05-2002                                              *
 * PROGRAMADOR: Saulo Alvarado Mateos                                          *
 * DESCRIPCIÓN:                                                                *
 *       A partir de ahora, existe la posibilidad de indicar que la fecha de   *
 * vencimiento está próxima ("vencimientos a la vista"). En estos casos, el    *
 * campo se indicará con la cadena 00000001. Para evitar realiar cambios a     *
 * bajo nivel en los campos (cambiar el formato de representación interno      *
 * y añadir verificaciones adicionales al campo Fecha de vencimiento) se ha    *
 * optado por añadir un nuevo campo auxiliar -fecha vencimiento a la vista-    *
 * y unas verificaciones bastante sencillas. De esta forma se acelera el       *
 * el proceso de programación.                                                 *
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

    // 05.05.02 - Se añade un campo auxiliar para indicar cuándo un vencimiento
    //            está a la vista o próximo.
    k07_VencimientoALaVista       = '11.X1';
    
    k07_FechaVencimientoItem      = '11.01';
    k07_IDSubsistemaPresentaItem  = '11.02';
    k07_RefInicialSubsistemaItem  = '11.03';
    k07_PagoParcialItem           = '11.04';
    k07_NominalInicialItem        = '11.05';
    k07_ImportePagadoItem         = '11.06';
    k07_FechaDevolucionItem       = '11.07';
    k07_ComisionDevolucionItem    = '11.08';
    k07_ConceptoComplemItem       = '11.09';
    k07_FiguraEntidadPresentaItem = '11.10';

  type
    TOpDivRecType07 = class( TOpDivSystemRecord )
      protected
        //: datos del registro

        // 05.05.02 - Se añade un campo auxiliar para indicar cuándo un vencimiento
        //            está a la vista o próximo.
        FVencimientoALaVista: Boolean;

        FFechaVencimiento: TDateTime;
        FIDSubsistemaPresentacion: String;
        FRefInicialSubsistema: String;
        FPagoParcial: String;
        FNominalInicial: Double;
        FImportePagado: Double;
        FFechaDevolucion: TDateTime;
        FComisionDevolucion: Double;
        FConceptoComplementario: String;
        FFigEntidadPresenta: String;


        //*****
        // métodos de soporte a las propiedades
        //*****
        // 05.05.02 - se añade un campo adicional para indicar cuándo es a la vista el vencimiento
        procedure setVencimientoALaVista( esALaVista: Boolean );

        procedure setFechaVencimiento( aDate: TDateTime );
        procedure setIDSubsistemaPresentacion( const aString: String );
        procedure setRefInicialSubsistema( const aString: String );
        procedure setPagoParcial( const aString: String );
        procedure setNominalInicial( aImporte: Double );
        procedure setImportePagado( aImporte: Double );
        procedure setFechaDevolucion( aDate: TDateTime );
        procedure setComisionDevolucion( aImporte: Double );
        procedure setConceptoComplementario( const aString: String );
        procedure setFigEntidadPresenta( const aString: String );


        // :: cambios
        procedure changeImporteOperacion; override;

        //:: otros métodos de soporte
        procedure initializeData; override;
        function  getStringForCodeData: String; override;

        //:: procedimientos de validación
        procedure validaImportes; virtual;

        // 07.05.02
        function  printSpecificType: String; override;
        procedure printSpecificData( aDataString: TStringList ); override;

      public
        // **** PROPIEDADES ****
        //: creamos las propiedades inherentes a este tipo de registro
        // 05.05.02 - se crea un nuevo campo para indicar vencimientos próximos
        property VencimientoALaVista: Boolean read FVencimientoALaVista write setVencimientoALaVista;

        property FechaVencimiento: TDateTime read FFechaVencimiento write setFechaVencimiento;
        property IDSubsistemaPresentacion: String read FIDSubsistemaPresentacion write setIDSubsistemaPresentacion;
        property RefInicialSubsistema: String read FRefInicialSubsistema write setRefInicialSubsistema;
        property PagoParcial: String read FPagoParcial write setPagoParcial;
        property NominalInicial: Double read FNominalInicial write setNominalInicial;
        property ImportePagado: Double read FImportePagado write setImportePagado;
        property FechaDevolucion: TDateTime read FFechaDevolucion write setFechaDevolucion;
        property ComisionDevolucion: Double read FComisionDevolucion write setComisionDevolucion;
        property ConceptoComplementario: String read FConceptoComplementario write setConceptoComplementario ;
        property FigEntidadPresenta: String read FFigEntidadPresenta write setFigEntidadPresenta;

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
    CCriptografiaCutre,
    SysUtils,
    rxStrUtils,
    UAuxRefOp;

(*********
 MÉTODOS PRIVADOS
 *********)

  //****** Soporte a las propiedades ******
  procedure TOpDivRecType07.setVencimientoALaVista( esALaVista: Boolean );
  begin
    if FVencimientoALaVista <> esALaVista then
    begin
      FVencimientoALaVista := esALaVista;
      FFechaVencimiento := 0.0;  // se borra el contenido
      changeEventCall();
    end
  end;

  procedure TOpDivRecType07.setFechaVencimiento( aDate: TDateTime );
  begin
    if FFechaVencimiento <> aDate then
    begin
      // 05.05.02 - como ahora se ha añadido un elemento nuevo (indicando que es un vencimiento a la vista) no
      //            se permite especificar ninguna fecha si se ha puesto que éste es próximo.
      if FVencimientoALaVista and (aDate <> 0.0) then
      begin
        dataErrorEventCall(k07_FechaVencimientoItem, 'No se puede indicar una fecha de vencimiento si ya se ha señalado que el vencimiento está a la vista.');
        Exit;
      end;
      FFechaVencimiento := aDate;
      changeEventCall();
    end
  end;

  procedure TOpDivRecType07.setIDSubsistemaPresentacion( const aString: String );
  const
    klValoresPosibles: set of char = [ '0', '1', '2', '3' ];
    klError = 'se debe indicar un valor válido (0,1,2,3)';
  var
    texto: String;
  begin
    texto := trim( aString );
    if not ( texto[1] in klValoresPosibles ) then
      raise Exception.Create( klError );
    if FIDSubsistemaPresentacion <> texto then
    begin
      FIDSubsistemaPresentacion := texto;
      changeEventCall();
    end;
  end;

  procedure TOpDivRecType07.setRefInicialSubsistema( const aString: String );
  var
    texto: String;
  begin
    texto := AddChar('0',trim( aString ), 16);
    if FRefInicialSubsistema <>  texto then
    begin
      if ReplaceStr(texto, '0', '') <> EmptyStr then
        if FIDSubsistemaPresentacion = '3' then
          if not testReferenciaOperacion(texto) then
            Raise Exception.Create('Se debe indicar una referencia válida para el Subsistema 008.');
      FRefInicialSubsistema := texto ;
      changeEventCall();
    end;
  end;

  procedure TOpDivRecType07.setPagoParcial( const aString: String );
  const
    klValoresPosibles: set of char = [ '1', '2' ];
    klError = 'se debe indicar un valor válido (1,2)';
  var
    texto: String;
  begin
    texto := trim( aString );
    if not ( texto[1] in klValoresPosibles ) then
      raise Exception.Create( klError );
    if FPagoParcial <> texto then
    begin
      FPagoParcial:= texto;
      if FPagoParcial = '1' then
        FNominalInicial := 0.0
      else
        FNominalInicial := FImportePrinOp;
      changeEventCall();
    end;
  end;

  procedure TOpDivRecType07.setNominalInicial( aImporte: Double );
  begin
    if FNominalInicial <> aImporte then
    begin
      FNominalInicial := aImporte;
      changeEventCall();
    end
  end;

  procedure TOpDivRecType07.setImportePagado( aImporte: Double );
  const
    klErrorNegativo  = 'El importe no puede ser negativo.';
    klErrorDescuadre = 'La suma del Importe Pagado y de la Comisión por devolución debe coincidir con el principal de la operación (en Euros).';
  begin
    if aImporte < 0.0 then
      raise Exception.Create( klErrorNegativo );
    if FImportePagado <> aImporte then
    begin
(*
      -- no se puede hacer aquí o no dejará cambiarlo nunca una vez se incurra en fallo
      if ( FImportePrinOp <> 0 ) and ( FComisionDevolucion <> 0 ) then
        if abs( FImportePrinOp - ( aImporte + FComisionDevolucion ) ) > 0.0001 then
          raise Exception.Create( klErrorDescuadre );
*)
      FImportePagado := aImporte;
      changeEventCall();
    end
  end;

  procedure TOpDivRecType07.setFechaDevolucion( aDate: TDateTime );
  begin
    if FFechaDevolucion <> aDate then
    begin
      FFechaDevolucion := aDate;
      changeEventCall();
    end;
  end;

  procedure TOpDivRecType07.setComisionDevolucion( aImporte: Double );
  const
    klErrorNegativo  = 'El importe no piede ser negativo.';
    klErrorDescuadre = 'La suma del Importe Pagado y de la Comisión por devolución debe coincidir con el principal de la operación (en Euros).';
  begin
    if aImporte < 0.0 then
      raise Exception.Create( klErrorNegativo );
    if FComisionDevolucion <> aImporte then
    begin
(* -- no se puede hacer aquí o no dejará cambiarlo nunca una vez se incurra en fallo
      if ( FImportePrinOp <> 0 ) and ( FImportePagado <> 0 ) then
        if abs( FImportePrinOp - ( FImportePagado + aImporte ) ) > 0.005 then
          raise Exception.Create( klErrorDescuadre );
*)
      FComisionDevolucion := aImporte;
      changeEventCall();
    end
  end;

  procedure TOpDivRecType07.setConceptoComplementario( const aString: String );
  var
    texto: string;
  begin
    texto := trim( aString );
    if FConceptoComplementario <> texto then
    begin
      FConceptoComplementario := texto;
      changeEventCall();
    end;
  end;

  procedure TOpDivRecType07.setFigEntidadPresenta( const aString: String );
  const
    klValoresPosibles: set of char = [ '1', '2'];
    klError = 'se debe indicar un valor válido (1,2)';
  var
    texto: String;
  begin
    texto := trim( aString );
    if not ( texto[1] in klValoresPosibles ) then
      raise Exception.Create( klError );
    if FFigEntidadPresenta <> texto then
    begin
      FFigEntidadPresenta := texto;
      changeEventCall();
    end;
  end;

  //:: cambios
  procedure TOpDivRecType07.changeImporteOperacion;
  begin
    inherited;
    if FPagoParcial = '2' then
      // se fuerza a que el campo nominal inicial sea el mismo que el de la operación
      FNominalInicial := FImportePrinOp;
  end;

  //***** otros métodos de soporte
  procedure TOpDivRecType07.initializeData;
  begin
    inherited;
    FRecType := '07' ;  // operación tipo 07
    FOpNat := '2';  // siempre se trata de pagos
    //
    FOpNatFixed := true;
    FClaveAutorizaEsObligatoria := false ;
    FNumCtaDestinoEsObligatoria := false ;

    // también se le van a dar valores iniciales a los datos

    // 05.05.02 - se ha añadido un campo para señalar cuándo el vencimiento está próximo
    FVencimientoALaVista := false;

    FFechaVencimiento := 0.0;   // no hay fecha señalada
    FPagoParcial    := '2';   // se indica que no se paga inicialmente de forma parcial
    FNominalInicial := 0.0;
    FImportePagado  := 0.0;
    FFechaDevolucion := 0.0;   // no hay inicialmente fecha de devolución señalada
    FComisionDevolucion := 0.0;
    FConceptoComplementario := '';
    FIDSubsistemaPresentacion := '3';
    FRefInicialSubsistema := '0000000000000000';
    FFigEntidadPresenta := '2';

  end;

  function  TOpDivRecType07.getStringForCodeData: String;
  begin
    Result := inherited getStringForCodeData()
    // 05.05.02 - se ha añadido un campo adicional para indicar cuándo el vencimiento está próximo
            + kCodeSeparator + BoolToStr( FVencimientoALaVista, TRUE )

            + kCodeSeparator + dateToStr( FFechaVencimiento )
            + kCodeSeparator + FIDSubsistemaPresentacion
            + kCodeSeparator + FRefInicialSubsistema
            + kCodeSeparator + FPagoParcial
            + kCodeSeparator + getValidStringFromDouble( FNominalInicial, 15, 3 )
            + kCodeSeparator + getValidStringFromDouble( FImportePagado, 15, 3 )
            + kCodeSeparator + dateToStr( FFechaDevolucion )
            + kCodeSeparator + getValidStringFromDouble( FComisionDevolucion, 15, 3 )
            + kCodeSeparator + FConceptoComplementario
            + kCodeSeparator + FFigEntidadPresenta
            + kCodeSeparator;
  end;

  //:: procedimientos de validación
  procedure TOpDivRecType07.validaImportes;
  begin
    // se valida que el importe principal ha de ser la suma
    if Abs(FImportePrinOp - (FComisionDevolucion + FImportePagado)) > 0.005 then
    begin
//      raise Exception.Create('El importe de la operación ha de ser igual a la suma del "Importe pagado" y "Devolución de comisiones".');
      dataErrorEventCall(k07_ComisionDevolucionItem, 'El importe de la operación ha de ser igual a la suma del "Importe pagado" y "Devolución de comisiones".');
      Exit;
    end;
    if FPagoParcial = '2' then
    begin
      if FNominalInicial <> FImportePrinOp then
        dataErrorEventCall(k07_NominalInicialItem, 'Cuando no se trata de un Pago parcial, el Nominal inicial y el Importe de la Op. deben coincidir.');
    end
    else
      if FImportePrinOp > FNominalInicial then
        dataErrorEventCall(k07_NominalInicialItem, 'Cuando se trata de un Pago parcial, el Nominal inicial ha de ser superior al Importe dela Op.');
  end;


(*********
 MÉTODOS PÚBLICOS
 *********)

  procedure TOpDivRecType07.setData( aStringList: TStrings );
  begin

    inherited setData( aStringList );

    // 05.05.02 - se ha añadido un nuevo campo. Por defecto su valor es falso,
    //            por lo que no importa que no exista en la lectura de registros antiguos
    if testIndexOf( aStringList, k07_VencimientoALaVista )      then FVencimientoALaVista := StrToBool( aStringList.Values[ k07_VencimientoALaVista ] );

    if testIndexOf( aStringList, k07_FechaVencimientoItem )     then FFechaVencimiento := strToDate( aStringList.Values[ k07_FechaVencimientoItem ] );
    if testIndexOf( aStringList, k07_IDSubsistemaPresentaItem ) then FIDSubsistemaPresentacion := aStringList.Values[ k07_IDSubsistemaPresentaItem ];
    if testIndexOf( aStringList, k07_RefInicialSubsistemaItem ) then FRefInicialSubsistema := aStringList.Values[ k07_RefInicialSubsistemaItem ];
    if testIndexOf( aStringList, k07_PagoParcialItem )          then FPagoParcial := aStringList.Values[ k07_PagoParcialItem ];
    if testIndexOf( aStringList, k07_NominalInicialItem )       then FNominalInicial := strToFloat( ReplaceStr( aStringList.Values[ k07_NominalInicialItem ], '.', ',' ) );
    if testIndexOf( aStringList, k07_ImportePagadoItem )        then FImportePagado := strToFloat( ReplaceStr( aStringList.Values[ k07_ImportePagadoItem ], '.', ',' ) );
    if testIndexOf( aStringList, k07_FechaDevolucionItem )      then FFechaDevolucion := strToDate( aStringList.Values[ k07_FechaDevolucionItem ] );
    if testIndexOf( aStringList, k07_ComisionDevolucionItem )   then FComisionDevolucion := strToFloat( ReplaceStr( aStringList.Values[ k07_ComisionDevolucionItem ], '.', ',' ) );
    if testIndexOf( aStringList, k07_ConceptoComplemItem )      then FConceptoComplementario := aStringList.Values[ k07_ConceptoComplemItem ];
    if testIndexOf( aStringList, k07_FiguraEntidadPresentaItem ) then FFigEntidadPresenta := aStringList.Values[ k07_FiguraEntidadPresentaItem ];
  end;

  //: devuelve los datos en forma de una StrinList <nombre>=<valor>
  procedure TOpDivRecType07.getData( aStringList: TStrings );
  begin

    inherited getData( aStringList );

    // 05.05.02 - se añade un nuevo campo para indicar la proximidad de un vencimiento
    aStringList.Values[ k07_VencimientoALaVista ] := BoolToStr( FVencimientoALaVista, FALSE );

    aStringList.Values[ k07_FechaVencimientoItem ] := dateToStr( FFechaVencimiento );
    aStringList.Values[ k07_IDSubsistemaPresentaItem ] := FIDSubsistemaPresentacion ;
    aStringList.Values[ k07_RefInicialSubsistemaItem ] := FRefInicialSubsistema ;
    aStringList.Values[ k07_PagoParcialItem ] := FPagoParcial;
    aStringList.Values[ k07_NominalInicialItem ] := getValidStringFromDouble( FNominalInicial, 15, 3 );
    aStringList.Values[ k07_ImportePagadoItem ] := getValidStringFromDouble( FImportePagado, 15, 3 );
    aStringList.Values[ k07_FechaDevolucionItem ] := dateToStr( FFechaDevolucion );
    aStringList.Values[ k07_ComisionDevolucionItem ] := getValidStringFromDouble( FComisionDevolucion, 15, 3 );
    aStringList.Values[ k07_ConceptoComplemItem ] := FConceptoComplementario;
    aStringList.Values[ k07_FiguraEntidadPresentaItem ] := FFigEntidadPresenta ;
  end;

  //:: se fuerza la comprobación de todos los datos
  procedure TOpDivRecType07.TestData;
  begin
    inherited;

    validaImportes();
  end;

  //:: devuelve el contenido del registro como si se tratara del registro del archivo final
  function TOpDivRecType07.getDataAsFileRecord: String;
  var
    auxFechaVencimiento,
    auxFechaDevolucion: String;
  begin
    // 05.05.02 - se ha añadido un campo para indicar la proximidad del vencimiento.
    //            En estos casos, se ha de señalar el campo con 00000001.
    if FVencimientoALaVista then
      auxFechaVencimiento := MS('0', 7) + '1'
    else if FFechaVencimiento = 0.0 then
      auxFechaVencimiento := MS('0', 8)
    else
      auxFechaVencimiento := FormatDateTime('ddmmyyyy', FFechaVencimiento);

    if FFechaDevolucion = 0.0 then
      auxFechaDevolucion := MS('0', 8)
    else
      auxFechaDevolucion := FormatDateTime('ddmmyyyy', FFechaDevolucion);

    result := ( inherited getDataAsFileRecord() )
//         + FormatDateTime( 'ddmmyyyy', FFechaVencimiento )
         + auxFechaVencimiento
         + FIDSubsistemaPresentacion
         + AddChar( '0', FRefInicialSubsistema, 16 )
         + FPagoParcial
         + AddChar('0', trim( ReplaceStr( ReplaceStr( FloatToStrF( FNominalInicial, ffNumber, 11, 2 ), ',', ''), '.', '') ), 11)
         + AddChar( '0', trim( ReplaceStr( ReplaceStr( FloatToStrF( FImportePagado, ffNumber, 11, 2 ), ',', '' ), '.', '' ) ), 11 )
//         + FormatDateTime( 'ddmmyyyy', FFechaDevolucion )
         + auxFechaDevolucion
         + AddChar( '0', trim( ReplaceStr( ReplaceStr( FloatToStrF( FComisionDevolucion, ffNumber, 6, 2 ), ',', '' ), '.', '' ) ), 6 )
         + AddCharR( ' ', FConceptoComplementario, 80 )
         + FFigEntidadPresenta ;
  end;

// 07.05.02 - ahora se encargan dos métodos intermediarios de imprimir los datos específicos del registro

  function TOpDivRecType07.printSpecificType: String;
  begin
    Result := 'TIPO: 07 - PAGOS EN NOTARÍA.';
  end;

//  procedure TOpDivRecType07.getDataAsPrintedRecord(anStrList: TStringList);
  procedure TOpDivRecType07.printSpecificData( aDataString: TStringList );
  var
    lnPtr: String;
    anStrList: TStringList;  // alias con el parámetro de entrada/salida
  begin
    anStrList := aDataString;

//    anStrList.Add('TIPO: 07 - PAGOS EN NOTARÍA.');
//    anStrList.Add(MS('_', 90));
//    inherited getDataAsPrintedRecord(anStrList);

    anStrList.Add(EmptyStr);
    // vencimiento
    lnPtr := 'VENCIMIENTO............. : ' ;
    // 05.05.02 - se ha añadido un campo para indicar que el vencimiento está próximo.
    //            Así que se opta por indicarlo en la hoja de salida del registro
    if FVencimientoALaVista then
      lnPtr := lnPtr + 'A LA VISTA.'
    else if FFechaVencimiento <> 0.0 then
      lnPtr := lnPtr + formatDateTime('dd/mm/yyyy', FFechaVencimiento)
    else
      lnPtr := lnPtr + 'NO INDICADO.';
    anStrList.Add(lnPtr);
    // identificación del subsistema de presentación inicial
    lnPtr := 'IDENTIFICACIÓN DEL SUBSISTEMA DE';
    anStrList.Add(lnPtr);
    lnPtr := 'PRESENTACIÓN INICIAL.... : ' + FIDSubsistemaPresentacion + ' - ';
    if      FIDSubsistemaPresentacion = '0' then
      lnPtr := lnPtr + 'DESCONOCIDO'
    else if FIDSubsistemaPresentacion = '1' then
      lnPtr := lnPtr + 'S.N.C.E. 004'
    else if FIDSubsistemaPresentacion = '2' then
      lnPtr := lnPtr + 'S.N.C.E. 007'
    else if FIDSubsistemaPresentacion = '3' then
      lnPtr := lnPtr + 'S.N.C.E. 008';
    // referencia inicial del subsistema de presentación
    lnPtr := 'REFERENCIA INICIAL';
    anStrList.Add(lnPtr);
    lnPtr := 'SUBSISTEMA DE PRESENTACIÓN...... : ' + FRefInicialSubsistema;
    anStrList.Add(lnPtr);
    // pago parcial + nominal presentación inicial
    lnPtr := 'PAGO PARCIAL : ' ;
    if FPagoParcial = '1' then
      lnPtr := lnPtr + 'SÍ'
    else if FPagoParcial = '2' then
      lnPtr := lnPtr + 'NO'
    else
      lnPtr := lnPtr + '??';
    lnPtr := lnPtr + MS(' ', 6);
    lnPtr := lnPtr + 'NOMINAL PRESENTACIÓN INICIAL : ' + FloatToStrF(FNominalInicial, ffNumber, 11, 2) + ' €';
    anStrList.Add(lnPtr);
    // importe pagado
    lnPtr := 'IMPORTE PAGADO...................... : ' + FloatToStrF(FImportePagado, ffNumber, 11, 2) + ' €';
    anStrList.Add(lnPtr);
    // fecha de dev. inicial
    lnPtr := 'FECHA DE DEVOLUCIÓN INICIAL......... : ' ;
    if FFechaDevolucion <> 0.0 then
      lnPtr := lnPtr + FormatDateTime('dd/mm/yyyy', FFechaDevolucion );
    anStrList.Add(lnPtr);
    // importe de comisiones de devolución
    lnPtr := 'IMPORTES DE COMISIONES DE DEVOLUCIÓN : ' + FloatToStrF(FComisionDevolucion, ffNumber, 11, 2) + ' €';
    anStrList.Add(lnPtr);
    // concepto complementario
    lnPtr := 'CONCEPTO COMPLEMETARIO : ';
    anStrList.Add(lnPtr);
    if Trim(FConceptoComplementario) <> EmptyStr then
      anStrList.Add( '  ' + FConceptoComplementario);
    // figura de la entidad presentador
    lnPtr := 'FIGURA DE LA ENTIDAD PRESENTADOR.... : ' + FFigEntidadPresenta + ' - ' ;
    if FFigEntidadPresenta = '1' then
      lnPtr := lnPtr + 'TERCERA ENTIDAD'
    else if FFigEntidadPresenta = '2' then
      lnPtr := lnPtr + 'DOMICILIATARIA'
    else
      lnPtr := lnPtr + '??????';
    anStrList.Add(lnPtr);
    
  end;


end.
