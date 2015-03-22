unit COpDivRecType03;

(*******************************************************************************
 * CLASE: TOpDivRecType03                                                      *
 * FECHA CREACION: 21-09-2001                                                  *
 * PROGRAMADOR: Saulo Alvarado Mateos                                          *
 * DESCRIPCIÓN:                                                                *
 *                                                                             *
 *       Implementación del registro tipo 03 - Regularización de operaciones   *
 * de Sistema de intercambio. Carácter documental.                             *
 *                                                                             *
 * FECHA MODIFICACIÓN: 07-05-2002                                              *
 * PROGRAMADOR: Saulo Alvarado Mateos (CINCA)                                  *
 * DESCRIPCIÓN:                                                                *
 *       Se ajusta la clase a la nueva forma de impresión del registro, tenien-*
 * do ahora un par de métodos intermediarios.                                  *
 *                                                                             *
 * FECHA MODIFICACIÓN: 08-05-2002                                              *
 * PROGRAMADOR: Saulo Alvarado Mateos (CINCA)                                  *
 * DESCRIPCIÓN: Se corrige que, al agrandar la letra de la impresión, el concep*
 * to complementario se truncaba cuando excedía el ancho de la página. Se co-  *
 * rrige saltando a la línea siguiente en los casos en que así suceda.         *
 *******************************************************************************)

interface
  uses
    classes,
    CCustomDBMiddleEngine,
    COpDivSystemRecord ;

  const
    k03_IndicadorSubsistemaItem = '11.01';
    k03_RefInicialItem          = '11.02';
    k03_CodOrdenanteItem        = '11.03';
    k03_NifSufOrdenanteItem     = '11.04';
    k03_NumChequeItem           = '11.05';
    k03_FechaInterInicialItem   = '11.06';
    k03_ConceptoOpItem          = '11.07';
    k03_ConceptoComplementaItem = '11.08';
    k03_NominalInicialItem      = '11.09';
    k03_ComisionInicialItem     = '11.10';
    k03_ComisionReclamacionItem = '11.11';

  type
    TOpDivRecType03 = class( TOpDivSystemRecord )
      protected
        FIndicadorSubsistema: String;
        FRefInicial: String;
        FCodOrdenante: String;
        FNifSufOrdenante: String;
        FNumCheque: String;
        FFechaInterInicial: TDateTime;
        FConceptoOp: String;
        FConceptoComplementa: String;
        FNominalInicial: Double;
        FComisionInicial: Double;
        FComisionReclamacion: Double;

        //*****
        // métodos de soporte a las propiedades
        //*****
        procedure setIndicadorSubsistema( const aString: String );
        procedure setRefInicial( const aString: String );
        procedure setCodOrdenante( const aString: String );
        procedure setNifSufOrdenante( const aString: String );
        procedure setNumCheque( const aString: String );
        procedure setFechaInterInicial( aDate: TDateTime );
        procedure setConceptoOp( const aString: String );
        procedure setConceptoComplementa( const aString: String );
        procedure setNominalInicial( anImporte: Double );
        procedure setComisionInicial( anImporte: Double );
        procedure setComisionReclamacion( anImporte: Double );

        //:: otros métodos de soporte
        procedure initializeData; override;
        function  getStringForCodeData: String; override;
        function  getTipoForPrinted: String; virtual;

        // :: validaciones preaceptación
        procedure ValidaImportes; virtual;
        procedure ValidaFechaIntercambio; virtual;
        procedure ValidaClaveAutoriza; virtual;

        // :: cambios
        procedure changeImporteOperacion; override;

        // 07.05.02
        function  printSpecificType: String; override;
        procedure printSpecificData( aDataString: TStringList ); override;


      public
        // **** PROPIEDADES ****
        //: creamos las propiedades inherentes a este tipo de registro
        property IndicadorSubsistema: String read FIndicadorSubsistema write setIndicadorSubsistema;
        property RefInicial: String read FRefInicial write setRefInicial;
        property CodOrdenante: String read FCodOrdenante write setCodOrdenante;
        property NifSufOrdenante: String read FNifSufOrdenante write setNifSufOrdenante;
        property NumCheque: String read FNumCheque write setNumCheque;
        property FechaInterInicial: TDateTime read FFechaInterInicial write setFechaInterInicial;
        property ConceptoOp: String read FConceptoOp write setConceptoOp;
        property ConceptoComplementa: String read FConceptoComplementa write setConceptoComplementa;
        property NominalInicial: Double read FNominalInicial write setNominalInicial;
        property ComisionInicial: DOuble read FComisionInicial write setComisionInicial;
        property ComisionReclamacion: Double read FComisionReclamacion write setComisionReclamacion;

        //** métodos heredados (algunos de los cuales hay que redefinir )
        procedure setData( aStringList: TStrings ); override;
        procedure getData( aStringList: TStrings ); override;
        procedure TestData; override;
        function getDataAsFileRecord: String; override;
// 07.05.02 - a partir de ahora se encarga un método intermedio de imprimir los datos específicos del registro
//        procedure getDataAsPrintedRecord(anStrList: TStringList); override;

        class function isDocumentable: boolean; override;
    end;

implementation

  uses
    CCriptografiaCutre,
    CQueryEngine,
    SysUtils,
    rxStrUtils,
    UAuxRefOp;

  const
    kIndicadorSubsistema: array [1..6,1..2] of String =
         ( ( '3', 'Transferencias' ),
           ( '4', 'Cheques' ),
           ( '5', 'Adeudos' ),
           ( '6', 'Carburantes / Viajes' ),
           ( '7', 'Efectos' ),
           ( '8', 'Operaciones diversas' ) );
    kConceptoOperacion: array [1..5, 1..2] of String =
         ( ( '1', 'Rechazo de devolución' ),
           ( '2', 'Devolución inicial (caso S.N.C.E. 0006)' ),
           ( '3', 'Devolución fuera de plazo y extraordinarias' ),
           ( '4', 'Reclamación de la devolución' ),
           ( '5', 'Regularización mayores/menores importes' ) );

(*********
 MÉTODOS PRIVADOS
 *********)

  //****** Soporte a las propiedades ******
  procedure TOpDivRecType03.setIndicadorSubsistema( const aString: String );
  var
    theTexto: String;
    theIndicadorIndex: Integer;
    theMsgError: String;
  begin
    theMsgError := '';
    theTexto := trim( aString );
    if FIndicadorSubsistema <> theTexto then
    begin
      for theIndicadorIndex := 1 to 6 do
        if kIndicadorSubsistema[ theIndicadorIndex ][ 1 ] = theTexto then
        begin
          break;
        end
        else
        begin
          theMsgError := theMsgError + #13 + kIndicadorSubsistema[ theIndicadorIndex ][1] + ' - ' + kIndicadorSubsistema[theIndicadorIndex][2] ;
        end;
      if theIndicadorIndex > 6 then
      begin
//        raise Exception.Create( 'Se debe señalar un Indicador del subsistema válido: ' + theMsgError );
        dataErrorEventCall(k03_IndicadorSubsistemaItem, 'Se debe señalar un Indicador del subsistema válido: ' + theMsgError );
        Exit;
      end;

      FIndicadorSubsistema := theTexto;
      // cuando hay un cambio en este campo, se resetean los restantes
      FRefInicial := EmptyStr;
      FCodOrdenante := EmptyStr;
      FNifSufOrdenante := EmptyStr;
      FNumCheque := EmptyStr;

      if (FIndicadorSubsistema <> '8') and (FConceptoOp <> '4') then
        FClaveAutoriza := MS('0', 18);
      changeEventCall();
    end
  end;

  procedure TOpDivRecType03.setRefInicial( const aString: String );
  var
    theTexto: String;
  begin
    theTexto := AddChar( '0', trim( aString ), 16 );
    if FRefInicial <> theTexto then
    begin
(*
      if Trim( ReplaceStr( theTexto, '0', '' ) ) = EmptyStr then
        raise Exception.Create( 'Debe indicarse una referencia válida.' );
*)
      if FIndicadorSubsistema = '8' then  // se comprueba la referencia inicial sólo en el caso del subsistema de operaciones diversas
        if not testReferenciaOperacion(theTexto) then
        begin
//          raise Exception.Create('La referencia indicada no es válida para el Subsistema de Operaciones Diversas.');
          dataErrorEventCall(k03_RefInicialItem, 'La referencia indicada no es válida para el Subsistema de Operaciones Diversas.');
          Exit;
        end;
      FRefInicial := theTexto;
      changeEventCall();
    end
  end;

  procedure TOpDivRecType03.setCodOrdenante( const aString: String );
  var
    theTexto: String;
  begin
    theTexto := Trim( aString );
    if FCodOrdenante <> theTexto then
    begin
      if theTexto = EmptyStr then
      begin
//        raise Exception.Create( 'Debe indicarse un código de ordenante válido.' );
        dataErrorEventCall(k03_CodOrdenanteItem, 'Debe indicarse un código de ordenante válido.');
        Exit;
      end;

      FCodOrdenante := theTexto;
      changeEventCall();
    end
  end;

  procedure TOpDivRecType03.setNifSufOrdenante( const aString: String );
  var
    theTexto: String;
  begin
    theTexto := trim( aString );
    if FNifSufOrdenante <> theTexto then
    begin
      FNifSufOrdenante := theTexto;
      changeEventCall();
    end
  end;

  procedure TOpDivRecType03.setNumCheque( const aString: String );
  var
    theTexto: String;
  begin
    theTexto := Trim( aString );
    if FNumCheque <> theTexto then
    begin
      FNumCheque := theTexto;
      changeEventCall();
    end
  end;

  procedure TOpDivRecType03.setFechaInterInicial( aDate: TDateTime );
  begin
    if FFechaInterInicial <> aDate then
    begin
      FFechaInterInicial := aDate;
      changeEventCall();
    end
  end;

  procedure TOpDivRecType03.setConceptoOp( const aString: String );
  var
    theTexto: String;
    theConceptoIndex: Integer;
    theMsgError: String;
  begin
    theMsgError := EmptyStr;
    theTexto := trim( aString );
    if FConceptoOp <> aString then
    begin
      for theConceptoIndex := 1 to 5 do
        if kConceptoOperacion[theConceptoIndex][1] = theTexto then
          break
        else
          theMsgError := theMsgError + #13 + kConceptoOperacion[theConceptoIndex][1] + ' - ' + kConceptoOperacion[theConceptoIndex][2] ;

        if theConceptoIndex > 5 then
        begin
//          raise Exception.Create( 'Se debe indicar un Concepto válido:' + theMsgError );
          dataErrorEventCall(k03_ConceptoOpItem, 'Se debe indicar un Concepto válido:' + theMsgError);
          Exit;
        end;

        // 02.05.2002 : A partir del 07.05, cuando se refiera como concepto de operación la de tipo 2 (devol.inicial)
        //              SOLA y EXCLUSIVAMENTE podrá ser para el subsistema 6.
        if (theTexto = '2') and (FIndicadorSubsistema <> '6') then
        begin
          dataErrorEventCall(k03_ConceptoOpItem, 'El código de "Concepto de operación" correspondiente a "Devolución inicial" sólo puede usarse, de forma exclusiva, para operaciones del subsistema S.N.C.E. 006.');
          Exit;
        end;

        FConceptoOp := theTexto;
        // vamos a poner ciertos importes a cero dependiendo del concepto...
        if theTexto[1] in ['2', '3', '5'] then
        begin
          FComisionInicial := 0.0;
          FNominalInicial := FImportePrinOp;
        end;
        if theTexto[1] in ['1', '2', '3', '5'] then
          FComisionReclamacion := 0.0;
        if (theTexto[1] <> '4') and not ((theTexto = '3') and (FIndicadorSubsistema = '8')) then
          FClaveAutoriza := MS('0', 18); 
        changeEventCall();
    end
  end;

  procedure TOpDivRecType03.setConceptoComplementa( const aString: String );
  var
    theTexto: String;
  begin
    theTexto := Trim( aString );
    if FConceptoComplementa <> theTexto then
    begin
      FConceptoComplementa := theTexto;
      changeEventCall();
    end
  end;

  procedure TOpDivRecType03.setNominalInicial( anImporte: Double );
  begin
    if FNominalInicial <> anImporte then
    begin
      FNominalInicial := anImporte;
      changeEventCall();
    end
  end;

  procedure TOpDivRecType03.setComisionInicial( anImporte: Double );
//  var
//    oldValue: Double;
  begin
    if FComisionInicial <> anImporte then
    begin
//      oldValue := FComisionInicial;
      FComisionInicial := anImporte;
(*
      Es peligroso hacer la presunción de que el usuario ha insertado bien el importe desde el principio
      if (FNominalInicial + oldValue + FComisionReclamacion) = FImportePrinOp then
        FNominalInicial := FNominalInicial + oldValue - FComisionInicial;
*)
      changeEventCall();
    end
  end;

  procedure TOpDivRecType03.setComisionReclamacion( anImporte: Double );
//  var
//    oldValue: Double;
  begin
    if FComisionReclamacion <> anImporte then
    begin
//      oldValue := FComisionReclamacion;
      FComisionReclamacion := anImporte;
(*
      Es peligroso hacer la presunción de que el usuario ha insertado bien el importe desde el principio
      if (FNominalInicial + FComisionInicial + oldValue) = FImportePrinOp then
        FNominalInicial := FNominalInicial + oldValue - FComisionReclamacion;
*)
      changeEventCall();
    end
  end;

  //***** otros métodos de soporte
  procedure TOpDivRecType03.initializeData;
  begin
    inherited;
    FRecType := '03' ;  // operación tipo 03
    FOpNat := '1';  // siempre se trata de cobros
    //
    FOpNatFixed := false;
    FClaveAutorizaEsObligatoria := false;
    FNumCtaDestinoEsObligatoria := false;

    // también se le van a dar valores iniciales a los datos
    FIndicadorSubsistema := '3';
    FRefInicial := EmptyStr;
    FCodOrdenante := EmptyStr;
    FNifSufOrdenante := EmptyStr;
    FNumCheque := EmptyStr;
    FFechaInterInicial :=  0.0;  // se pone al comienzo de los tiempos
    FConceptoOp := '1';
    FConceptoComplementa := EmptyStr;
    FNominalInicial := 0.0;
    FComisionInicial := 0.0;
    FComisionReclamacion := 0.0;

  end;

  function  TOpDivRecType03.getStringForCodeData: String;
  begin
    result := inherited getDataAsFileRecord()
            + kCodeSeparator + FIndicadorSubsistema
            + kCodeSeparator + FRefInicial
            + kCodeSeparator + FCodOrdenante
            + kCodeSeparator + FNifSufOrdenante
            + kCodeSeparator + FNumCheque
            + kCodeSeparator + dateToStr( FFechaInterInicial )
            + kCodeSeparator + FConceptoOp
            + kCodeSeparator + FConceptoComplementa
            + kCodeSeparator + getValidStringFromDouble( FNominalInicial, 11, 3 )
            + kCodeSeparator + getValidStringFromDouble( FComisionInicial, 11, 3 )
            + kCodeSeparator + getValidStringFromDouble( FComisionReclamacion, 11, 3 )
            + kCodeSeparator ;
  end;

  function  TOpDivRecType03.getTipoForPrinted: String;
  begin
    Result := '03 - REGULARIZACIÓN DE OPS. DE SISTEMAS DE INTERCAMBIO. CARÁCTER DOCUMENTAL.';
  end;

  // :: validaciones
  procedure TOpDivRecType03.ValidaImportes;
  begin
    if (FConceptoOp = '1') or (FConceptoOp = '4') then
      if abs( FImportePrinOp - (FNominalInicial + FComisionInicial + FComisionReclamacion)) > 0.005 then
      begin
//        raise Exception.Create('El importe de la operación debe coincidir con la suma de los importes Nominal Inicial más las comisiones.');
        dataErrorEventCall(k03_NominalInicialItem, 'El importe de la operación debe coincidir con la suma de los importes Nominal Inicial más las comisiones.');
      end;
  end;

  procedure TOpDivRecType03.ValidaFechaIntercambio;
  begin
    if FFechaInterInicial = 0.0 then
//      raise Exception.Create('Se debe indicar la Fecha del Intercambio Inicial.');
      dataErrorEventCall(k03_FechaInterInicialItem, 'Se debe indicar la Fecha del Intercambio Inicial.');
  end;

  procedure TOpDivRecType03.ValidaClaveAutoriza;
  begin
    if Trim(ReplaceStr(FClaveAutoriza, '0', '')) = EmptyStr then
      if (FConceptoOp = '4') or ((FIndicadorSubsistema = '8') and (FConceptoOp = '3')) then
//        raise Exception.Create('Se debe indicar la clave de autorización.');
        dataErrorEventCall(k00_ClaveAutorizaItem, 'Se debe indicar la clave de autorización.');
  end;

  // :: cambios
  procedure TOpDivRecType03.changeImporteOperacion;
  begin
    // al final no se hace nada porque es peligroso cambiar el importe, pues puede haberse dado un error en la primera introducción
    // FNominalInicial := FImportePrinOp - FComisionInicial - FComisionReclamacion;
  end;

(*********
 MÉTODOS PÚBLICOS
 *********)
  procedure TOpDivRecType03.setData( aStringList: TStrings );
  begin
    inherited setData( aStringList );
    if testIndexOf( aStringList, k03_IndicadorSubsistemaItem ) then FIndicadorSubsistema := trim( aStringList.values[ k03_IndicadorSubsistemaItem ] );
    if testIndexOf( aStringList, k03_RefInicialItem ) then FRefInicial := trim( aStringList.Values[ k03_RefInicialItem ] );
    if testIndexOf( aStringList, k03_CodOrdenanteItem ) then FCodOrdenante := trim( aStringList.Values[ k03_CodOrdenanteItem ] );
    if testIndexOf( aStringList, k03_NifSufOrdenanteItem ) then FNifSufOrdenante := trim( aStringList.Values[ k03_NifSufOrdenanteItem ] );
    if testIndexOf( aStringList, k03_NumChequeItem ) then FNumCheque := trim( aStringList.Values[ k03_NumChequeItem ] );
    if testIndexOf( aStringList, k03_FechaInterInicialItem ) then FFechaInterInicial := strToDate( aStringList.Values[ k03_FechaInterInicialItem ] );
    if testIndexOf( aStringList, k03_ConceptoOpItem ) then FConceptoOp := trim( aStringList.Values[ k03_ConceptoOpItem ] );
    if testIndexOf( aStringList, k03_ConceptoComplementaItem ) then FConceptoComplementa := trim( aStringList.Values[ k03_ConceptoComplementaItem ] );
    if testIndexOf( aStringList, k03_NominalInicialItem ) then FNominalInicial := strToFloat( ReplaceStr( aStringList.Values[ k03_NominalInicialItem ], '.', ',' ) );
    if testIndexOf( aStringList, k03_ComisionInicialItem ) then FComisionInicial := strToFloat( ReplaceStr( aStringList.Values[ k03_ComisionInicialItem ], '.', ',' ) );
    if testIndexOf( aStringList, k03_ComisionReclamacionItem ) then FComisionReclamacion := strToFloat( ReplaceStr( aStringList.Values[ k03_ComisionReclamacionItem ], '.', ',' ) );
  end;

  //: devuelve los datos en forma de una StrinList <nombre>=<valor>
  procedure TOpDivRecType03.getData( aStringList: TStrings );
  begin
    inherited getData( aStringList );
    aStringList.Values[ k03_IndicadorSubsistemaItem ] := FIndicadorSubsistema;
    aStringList.Values[ k03_RefInicialItem ] := FRefInicial;
    aStringList.Values[ k03_CodOrdenanteItem ] := FCodOrdenante;
    aStringList.Values[ k03_NifSufOrdenanteItem ] := FNifSufOrdenante;
    aStringList.Values[ k03_NumChequeItem ] := FNumCheque;
    aStringList.Values[ k03_FechaInterInicialItem ] := dateToStr( FFechaInterInicial );
    aStringList.Values[ k03_ConceptoOpItem ] := FConceptoOp;
    aStringList.Values[ k03_ConceptoComplementaItem ] := FConceptoComplementa;
    aStringList.Values[ k03_NominalInicialItem ] := getValidStringFromDouble( FNominalInicial, 11, 3 );
    aStringList.Values[ k03_ComisionInicialItem ] := getValidStringFromDouble( FComisionInicial, 11, 3 );
    aStringList.Values[ k03_ComisionReclamacionItem ] := getValidStringFromDouble( FComisionReclamacion, 11, 3 );
  end;

  //:: se fuerza la comprobación de todos los datos
  procedure TOpDivRecType03.TestData;
  begin
    inherited;

    ValidaImportes();
    ValidaFechaIntercambio();
    ValidaClaveAutoriza();
  end;

  //:: devuelve el contenido del registro como si se tratara del registro del archivo final
  function TOpDivRecType03.getDataAsFileRecord: String;
  begin
    result := inherited getDataAsFileRecord()
         + AddChar('0', FIndicadorSubsistema, 3)
         + AddChar('0', FRefInicial, 16)
         + AddChar(' ', FCodOrdenante, 12)
         + AddChar(' ', FNifSufOrdenante, 12)
         + AddChar('0', FNumCheque, 8);
    if FFechaInterInicial = 0.0 then
      result := result + MS(' ',8)
    else
      result := result + FormatDateTime('ddmmyyyy', FFechaInterInicial);
    Result := Result + AddChar('0', FConceptoOp, 2)
         + AddCharR(' ', FConceptoComplementa, 80)
         + AddChar('0', ReplaceStr( ReplaceStr( FloatToStrF( FNominalInicial, ffNumber, 11, 2), ',', ''), '.', ''), 11)
         + AddChar('0', ReplaceStr( ReplaceStr( FloatToStrF( FComisionInicial, ffNumber, 6, 2), ',', ''), '.', ''), 6)
         + AddChar('0', ReplaceStr( ReplaceStr( FloatToStrF( FComisionReclamacion, ffNumber, 6, 2), ',', ''), '.', ''), 6);
    Result := AddCharR(' ', Result, 352);
  end;

// 07.05.02 -- se encargan de imprimir los datos específicos del registro dos métodos.

  function TOpDivRecType03.printSpecificType: String;
  begin
    Result := 'TIPO: ' + getTipoForPrinted();
  end;

//  procedure TOpDivRecType03.getDataAsPrintedRecord(anStrList: TStringList);
  procedure TOpDivRecType03.printSpecificData(aDataString: TStringList);
  var
    lnPtr: String;
    anStrList: TStringList;  // necesario para hacer alias de la variable de entrada
  begin
    anStrList := aDataString;

//    anStrList.Add('TIPO: ' + getTipoForPrinted());
//    anStrList.Add(MS('_', 80));
//    inherited getDataAsPrintedRecord(anStrList);

    anStrList.Add(EmptyStr);
    // indicador subsistema + ref.inicial
    lnPtr := 'INDICADOR DEL SUBSISTEMA... : ' + AddChar('0', FIndicadorSubsistema, 3) + ' - ' ;
    if      FIndicadorSubsistema = '3' then
      lnPtr := lnPtr + 'TRANSFERENCIAS'
    else if FIndicadorSubsistema = '4' then
      lnPtr := lnPtr + 'CHEQUES'
    else if FIndicadorSubsistema = '5' then
      lnPtr := lnPtr + 'ADEUDOS'
    else if FIndicadorSubsistema = '6' then
      lnPtr := lnPtr + 'CARBURANTES / VIAJES'
    else if FIndicadorSubsistema = '7' then
      lnPtr := lnPtr + 'EFECTOS'
    else if FIndicadorSubsistema = '8' then
      lnPtr := lnPtr + 'OPERACIONES DIVERSAS'
    else
       lnPtr := lnPtr + '??????';
    lnPtr := AddCharR(' ', lnPtr, 50);
    if ReplaceStr(Trim(FRefInicial), '0', '') <> EmptyStr then
      lnPtr := lnPtr + 'REF.INICIAL : ' + FRefInicial;
    anStrList.Add(lnPtr);
    // si el subsistema es adeudos se indica la información pertinente
    // nif-suf ordenante + ref.adeudo
    if FIndicadorSubsistema = '5' then
    begin
      anStrList.Add('ADEUDOS.......................');
      lnPtr := '  NIF/SUFIJO ORDENANTE : ' + AddCharR(' ', Copy(FNifSufOrdenante, 1, 9) + '-' + Copy(FNifSufOrdenante, 10, 3), 13);
      lnPtr := lnPtr + MS(' ',4) + 'REF.ADEUDO : ' + FCodOrdenante;
      anStrList.Add(lnPtr);
    end;
    // núm. cheque o pagaré
    lnPtr := 'NÚMERO DE CHEQUE O PAGARÉ.. : ' + FNumCheque;
    anStrList.Add(lnPtr);
    // concepto de la op.
    lnPtr := 'CONCEPTO DE LA OPERACIÓN... : ' + '0' + FConceptoOp + ' - ';
    if      FConceptoOp = '1' then
      lnPtr := lnPtr + 'RECHAZO DE DEVOLUCIÓN'
    else if FConceptoOp = '2' then
      lnPtr := lnPtr + 'DEVOLUCIÓN INICIAL (S.N.C.E 006)'
    else if FConceptoOp = '3' then
      lnPtr := lnPtr + 'DEV.FUERA DE PLAZO Y EXTRAORDINARIAS DEL S.N.C.E. 005'
    else if FConceptoOp = '4' then
      lnPtr := lnPtr + 'RECLAMACIÓN DE LA DEVOLUCIÓN'
    else if FConceptoOp = '5' then
      lnPtr := lnPtr + 'REGULARIZACIÓN MAYORES/MENORES IMPORTES'
    else
      lnPtr := lnPtr + '??????';
    anStrList.Add(lnPtr);
    // concepto complementario
    if FIndicadorSubsistema = '5' then
      lnPtr := 'NOMBRE DEL OBLIGADO AL PAGO : '
    else
      lnPtr := 'CONCEPTO COMPLEMENTARIO.... : ';
    if length(lnPtr + FConceptoComplementa) > 90 then
    begin
      anStrList.Add(lnPtr);
      anStrList.Add('  ' + FConceptoComplementa);
    end
    else
    begin
      lnPtr := lnPtr + FConceptoComplementa;
      anStrList.Add(lnPtr);
    end;
    if (FConceptoOp = '1') or (FConceptoOp = '4') then
    begin
      // nominal inicial
      lnPtr := 'NOMINAL INICIAL................... : ' + AddChar(' ', FloatToStrF(FNominalInicial, ffNumber, 11, 2 ), 11) + ' €';
      anStrList.Add(lnPtr);
      // comisiones iniciales de devolución
      lnPtr := 'COMISIONES INICIALES DE DEVOLUCIÓN : ' + AddChar(' ', FloatToStrF(FComisionInicial, ffNumber, 11, 2 ), 11) + ' €';
      anStrList.Add(lnPtr);
      // comisiones de reclamación
      lnPtr := 'COMISIONES DE RECLAMACIÓN......... : ' + AddChar(' ', FloatToStrF(FComisionReclamacion, ffNumber, 11, 2), 11) + ' €';
      anStrList.Add(lnPtr);
      // separador total
      lnPtr := '                                     ' + MS('_', 13);
      anStrList.Add(lnPtr);
      // total, que debe coincidir con el importe de la op.
      lnPtr := '                                     '
         + AddChar(' ', FloatToStrF(FNominalInicial + FComisionInicial + FComisionReclamacion, ffNumber, 11, 2) , 11 ) + ' €';
      anStrList.Add(lnPtr)
    end
    else
    begin
      // nominal inicial, pero sólo para el caso de que sea diferente de cero.
      if FNominalInicial <> 0.0 then
      begin
        lnPtr := 'NOMINAL INICIAL............ : '
             + FloatToStrF(FNominalInicial, ffNumber, 11, 2);
        anStrList.Add(lnPtr);
      end
    end;
  end;

  class function TOpDivRecType03.isDocumentable: boolean;
  begin
    result := true;
  end;

end.

