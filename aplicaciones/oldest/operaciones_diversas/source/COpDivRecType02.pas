unit COpDivRecType02;

(*******************************************************************************
 * CLASE: TOpDivRecType02                                                      *
 * FECHA CREACION: 01-08-2001                                                  *
 * PROGRAMADOR: Saulo Alvarado Mateos                                          *
 * DESCRIPCIÓN:                                                                *
                                                                               *
 *       Implementación del registro tipo 02 - Cheques (COBROS)                *
 *                                                                             *
 * FECHA MODIFICACIÓN: 05-05-2002                                              *
 * PROGRAMADOR: Saulo Alvarado Mateos                                          *
 * DESCRIPCIÓN: Se añade una condición adicional a el campo "Justificación de  *
 * cobro del exterior", para evitar que se active cuando el importe sea infe-  *
 * rior a 12500 Euros.                                                         *
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
    k02_TipoDocumentoItem     = '11.01';
    k02_ClausulaGastosItem    = '11.02';
    k02_CodigoIdentificaItem  = '11.03A';
    k02_NumDocumentoItem      = '11.03B';
    k02_ClaveCtaAbonoItem     = '11.04';
    k02_JustificaCobroExtItem = '11.05';
    k02_PresentaParcialItem   = '11.06';
    k02_ImporteOriginalItem    = '11.07';
    k02_ProvinciaTomadoraItem = '11.08';

  type
    TOpDivRecType02 = class( TOpDivSystemRecord )
      protected
        FTipoDocumento: String;
        FClausulaGastos: String;
        FCodigoIdentifica: String;
        FNumDocumento: String;
        FClaveCtaAbono: String;
        FJustificaCobroExt: String;
        FPresentaParcial: String;
        FImporteOriginal: Double;
        FProvinciaTomadora: String;

        //*****
        // métodos de soporte a las propiedades
        //*****
        procedure setTipoDocumento( const aString: String );
        procedure setClausulaGastos( const aString: String );
        procedure setCodigoIdentifica(const aString: String);
        procedure setNumDocumento( const aString: String );
        procedure setResidente( esResidente: boolean );
        function  esResidente: boolean;
        procedure setJustificaCobroExt( esExterior: boolean );
        function  esJustificaCobroExt: boolean;
        procedure setPresentaParcial( esParcial: boolean );
        function  esPresentaParcial: boolean;
        procedure setImporteOriginal( unImporte: Double );
        procedure setProvinciaTomadora( const aString: String );
        function  getDescProvTomadora: string;

        //:: otros métodos de soporte
        procedure initializeData; override;
        function  getStringForCodeData: String; override;

        //:: cuando se cambia el importe de la opeación
        procedure changeImporteOperacion; override;

        //:: métodos de validación
        procedure ValidaParcial; virtual;
        procedure ValidaNumDoc; virtual;
        procedure ValidaProvincia; virtual;

        // 07.05.02
        function  printSpecificType: String; override;
        procedure printSpecificData( aDataString: TStringList ); override;

      public
        // **** PROPIEDADES ****
        //: creamos las propiedades inherentes a este tipo de registro
        property TipoDocumento: String  read FTipoDocumento  write setTipoDocumento;
        property ClausulaGastos: String read FClausulaGastos write setClausulaGastos;
        property CodigoIdentifica: String read FCodigoIdentifica write setCodigoIdentifica;
        property NumDocumento: String   read FNumDocumento   write setNumDocumento;
        property Residente: Boolean     read esResidente     write setResidente;
        property JustificaCobroExt: Boolean read esJustificaCobroExt write setJustificaCobroExt;
        property PresentaParcial: Boolean read esPresentaParcial write setPresentaParcial;
        property ImporteOriginal: Double read FImporteOriginal write setImporteOriginal;
        property ProvinciaTomadora: String read FProvinciaTomadora write setProvinciaTomadora;
        property DescProvTomadora: String read getDescProvTomadora;

        //** métodos heredados (algunos de los cuales hay que redefinir )
        procedure setData( aStringList: TStrings ); override;
        procedure getData( aStringList: TStrings ); override;
        procedure TestData; override;
        function  getDataAsFileRecord: String; override;
//  07.05.02 - a partir de ahora se imprimen los datos específicos en un método intermedio
//        procedure getDataAsPrintedRecord(anStrList: TStringList); override;
    end;

implementation

  uses
    CCriptografiaCutre,
    CQueryEngine,
    SysUtils,
    rxStrUtils;

  const
    kTiposDocumento: array [1..4,1..2] of String =
         ( ( '01', 'Normalizado.' ), ( '02', 'No normalizado.' ),
           ( '03', 'Solicitud de abono con garantía de reposición por extravío.' ),
           ( '04', 'Vales carburante.' ) );
(* -- se vuelve a activar bajo petición de Juan Francisco
    kTiposDocumento: array [1..3,1..2] of String =
         ( ( '01', 'Normalizado.' ), ( '02', 'No normalizado.' ),
           ( '03', 'Solicitud de abono con garantía de reposición por extravío.' ) );
*)
    kClausulasGastos: array [0..2,1..2] of String =
         ( ( '0', 'Sin protesto/Sin declaración.' ),
           ( '1', 'Con declaración equivalente.' ),
           ( '2', 'Con protesto notarial.' ) );

(*********
 MÉTODOS PRIVADOS
 *********)

  //****** Soporte a lass propiedades ******
  procedure TOpDivRecType02.setTipoDocumento( const aString: String );
  var
    texto: string;
    iTipo: integer;
    msg: String;
  begin
    texto := AddChar( '0', trim( aString ), 2 );
    iTipo := strToInt( texto );
    if (iTipo < 1) or ( iTipo > 4 ) then
    begin
      msg := 'Se debe indicar uno de los tipos válidos.';
      for iTipo := 1 to 4 do
        msg := msg + #13 + kTiposDocumento[iTipo][1] + ' - ' + kTiposDocumento[iTipo][2] ;
      dataErrorEventCall(k02_TipoDocumentoItem, msg);
//      raise Exception.Create( msg );
      Exit;
    end;
    if (FTipoDocumento <> texto) then
    begin
      FTipoDocumento := texto;
      // hacemos algunos ajustes...
      if (texto <> '01') and (texto <> '04') then
      begin
        FCodigoIdentifica := MS('0', 4);
(*  al incluir el código de indetificación se recorta el número
        FNumDocumento := MS('0', 12);
*)
        FNumDocumento := MS('0', 7);
      end;
      if texto <> '04' then
        FProvinciaTomadora := '00';
      changeEventCall();
    end;
  end;

  procedure TOpDivRecType02.setClausulaGastos( const aString: String );
  var
    texto: string;
    iClausula: integer;
    msg: String;
  begin
    texto := AddChar( '0', trim( aString ), 1 );
    iClausula := strToInt( texto );
    if (iClausula < 0) or (iClausula > 2) then
    begin
      msg := 'Se debe indicar una de las cláusulas válidas:';
      for iClausula := 0 to 2 do
        msg := msg + #13 + kClausulasGastos[iClausula][1] + ' - ' + kClausulasGastos[iClausula][2] ;
//      raise Exception.Create( msg );
      dataErrorEventCall(k02_ClausulaGastosItem, msg);
      Exit;
    end;
    if (FClausulaGastos <> texto) then
    begin
      FClausulaGastos := texto;
      changeEventCall();
    end
  end;

  procedure TOpDivRecType02.setCodigoIdentifica(const aString: String);
  var
    theCodigo: String;
  begin
    theCodigo := AddChar('0', Trim(aString), 4);
    if FCodigoIdentifica <> theCodigo then
    begin
      if ReplaceStr(theCodigo, '0', '') = EmptyStr then
        if (FTipoDocumento = '01') or (FTipoDocumento = '04') then
        begin
//          raise Exception.Create('Se debe indicar un Código de indentificación válido para este tipo de documento.');
          dataErrorEventCall(k02_CodigoIdentificaItem, 'Se debe indicar un Código de indentificación válido para este tipo de documento.');
          Exit;
        end;
      FCodigoIdentifica := theCodigo;
      changeEventCall();
    end
  end;

  procedure TOpDivRecType02.setNumDocumento( const aString: String );
  var
    texto: String;
  begin
(*  incluir el código de indentificación implica una reducción de la parte del número
    texto := AddChar( '0', trim( aString ), 12 );
*)
    texto := AddChar('0', trim(aString), 7);
    if ReplaceStr( texto, '0', '' ) = EmptyStr then
      if (FTipoDocumento = '01') or (FTipoDocumento='04') then
      begin
//        raise Exception.Create( 'Se debe indicar un Número de documento válido para este tipo de documento.' );
        dataErrorEventCall(k02_NumDocumentoItem, 'Se debe indicar un Número de documento válido para este tipo de documento.');
        Exit;
      end;

    if FNumDocumento <> texto then
    begin
      FNumDocumento := texto;
      changeEventCall();
    end
  end;

  procedure TOpDivRecType02.setResidente( esResidente: boolean );
  const
    kValResidente: array [boolean] of string = ( '2', '1' );
  begin
    if FClaveCtaAbono <> kValResidente[ esResidente ] then
    begin
      FClaveCtaAbono := kValResidente[ esResidente ];
      if not esResidente then
        FJustificaCobroExt := '2';
      changeEventCall();
    end
  end;

  function  TOpDivRecType02.esResidente: boolean;
  begin
    Result := (FClaveCtaAbono = '1');
  end;

  procedure TOpDivRecType02.setJustificaCobroExt( esExterior: boolean );
  const
    kValJustifica: array [boolean] of string = ( '2', '1' );
  begin
    if FJustificaCobroExt <> kValJustifica[ esExterior ] then
    begin
      if FClaveCtaAbono = '2' then
      begin
//        raise Exception.Create( 'No se puede señalar que No es externa cuando el obligado no es residente.' );
        dataErrorEventCall(k02_JustificaCobroExtItem, 'No se puede señalar que es externa cuando el obligado no es residente.');
      end;

// 05.05.02 - se añade una nueva condición para cuando se quiere indicar una justificación de cobro desde el exterior.
      if esExterior then
        if FImportePrinOp < 12500 then
        begin
          dataErrorEventCall(k02_JustificaCobroExtItem, 'No se puede usar el indicador de Justificación del cobro del exterior cuando el importe sea menor a 12.500 Euros.');
          Exit;
        end;

      FJustificaCobroExt := kValJustifica[ esExterior ];
      changeEventCall();
    end;
  end;

  function  TOpDivRecType02.esJustificaCobroExt: boolean;
  begin
    Result := ( FJustificaCobroExt = '1' );
  end;

  procedure TOpDivRecType02.setPresentaParcial( esParcial: boolean );
  const
    kValPresenta: array [boolean]of string = ( '2', '1' );
  begin
    if FPresentaParcial <> kvalPresenta[esParcial] then
    begin
      FPresentaParcial := kValPresenta[esParcial];
      if esParcial then
        FImporteOriginal := 0.0
      else
        FImporteOriginal := ImportePrinOp ;
      changeEventCall();
    end
  end;

  function  TOpDivRecType02.esPresentaParcial: boolean;
  begin
    Result := (FPresentaParcial = '1');
  end;

  procedure TOpDivRecType02.setImporteOriginal( unImporte: Double );
  begin
    if FImporteOriginal <> unImporte then
    begin
      if unImporte < 0.0 then
        raise Exception.Create( 'No se puede indicar un importe inferior a cero.' );
      if FPresentaParcial = '1' then
        if unImporte <= FimportePrinOp then
        begin
//          raise Exception.Create( 'No tiene sentido que el importe original sea inferior al importe de la operación al tratarse de un parcial.' );
          dataErrorEventCall(k02_ImporteOriginalItem, 'No tiene sentido que el importe original sea inferior al importe de la operación al tratarse de un parcial.');
          Exit;
        end;
      FImporteOriginal := unImporte;
      changeEventCall();
    end
  end;

  procedure TOpDivRecType02.setProvinciaTomadora( const aString: String );
  var
    texto: String;
  begin
    texto := AddChar( '0', trim( aString ), 2 );
    if FProvinciaTomadora <> texto then
    begin
      if ReplaceStr( texto, '0', '' ) = EmptyStr then
        if FTipoDocumento = '04' then
        begin
//          raise Exception.Create( 'En este tipo de documento es obligatorio señalar la Provincia Tomadora.' )
          dataErrorEventCall(k02_ProvinciaTomadoraItem, 'En este tipo de documento es obligatorio señalar la Provincia Tomadora.');
          Exit;
        end
        else
          texto := '00';
      FProvinciaTomadora := texto;
      changeEventCall();
    end
  end;

  function TOpDivRecType02.getDescProvTomadora: String;
  begin
    Result := EmptyStr;
    if theQueryEngine.existsProvincia(trim(FProvinciaTomadora)) then
      result := theQueryEngine.getProvinciaName( trim( FProvinciaTomadora ) );
  end;

  //***** otros métodos de soporte
  procedure TOpDivRecType02.initializeData;
  begin
    inherited;
    FRecType := '02' ;  // operación tipo 06
    FOpNat := '1';  // siempre se trata de cobros
    //
    FOpNatFixed := true;
    FClaveAutorizaEsObligatoria := false;
    FNumCtaDestinoEsObligatoria := false;

    // también se le van a dar valores iniciales a los datos
    FTipoDocumento  := '01';
    FClausulaGastos := '0';
    FCodigoIdentifica := MS('0', 4);
    FNumDocumento     := MS( '0', 7 );
    FClaveCtaAbono  := '1';
    FJustificaCobroExt := '2';
    FPresentaParcial := '2';
    FImporteOriginal := 0.0;
    FProvinciaTomadora := '00';
  end;

  function  TOpDivRecType02.getStringForCodeData: String;
  begin
    result := inherited getDataAsFileRecord()
            + kCodeSeparator + FTipoDocumento
            + kCodeSeparator + FClausulaGastos
            + kCodeSeparator + FCodigoIdentifica 
            + kCodeSeparator + FNumDocumento
            + kCodeSeparator + FClaveCtaAbono
            + kCodeSeparator + FJustificaCobroExt
            + kCodeSeparator + FPresentaParcial
            + kCodeSeparator + getValidStringFromDouble( FImporteOriginal, 11, 3 )
            + kCodeSeparator + FProvinciaTomadora
            + kCodeSeparator ;
  end;

  procedure TOpDivRecType02.changeImporteOperacion;
  begin
    if FPresentaParcial = '2' then
      FImporteOriginal := FImportePrinOp;

    // 05.05.02 -- a partir de ahora, el Justificante de cobro del exterior sólo se podrá activar cuando se
    //             trate de un importe igual o superior a los 12500 euros
    if FImportePrinOp < 12500 then
      FJustificaCobroExt := '2';
  end;


  // Métodos para validación.

  procedure TOpDivRecType02.ValidaParcial;
  begin
    if (FPresentaParcial = '1') then
    begin
      if FImporteOriginal <= 0.0 then
      begin
//        raise Exception.Create('Se debe señalar el importe original de la operación, pues se ha indicado que es una presentación parcial.');
        dataErrorEventCall(k02_ImporteOriginalItem, 'Se debe señalar el importe original de la operación, pues se ha indicado que es una presentación parcial.');
        Exit;
      end;
      if FImporteOriginal < FImportePrinOp then
//        raise Exception.Create('El Importe original en pagos parciales no puede ser nunca inferior al pago parcial (importe de la operación).');
        dataErrorEventCall(k02_ImporteOriginalItem, 'El Importe original en pagos parciales no puede ser nunca inferior al pago parcial (importe de la operación).');
    end;
  end;

  procedure TOpDivRecType02.ValidaNumDoc;
  begin
//    if (ReplaceStr(FNumDocumento, '0', '') = EmptyStr) or (ReplaceStr(FCodigoIdentifica, '0', '') = EmptyStr) then
    if (ReplaceStr(FNumDocumento, '0', '') = EmptyStr) then
    begin
      if (FTipoDocumento = '01') or (FTipoDocumento = '04') then
//        raise Exception.Create('Se debe indicar el Número de documento para este Tipo concreto.');
        dataErrorEventCall(k02_NumDocumentoItem, 'Se debe indicar el Número de documento para este Tipo concreto.');
    end
  end;

  procedure TOpDivRecType02.ValidaProvincia;
  begin
    if not theQueryEngine.existsProvincia(FProvinciaTomadora) then
      if FTipoDocumento = '04' then
//        raise Exception.Create('Se debe indicar la Provincia tomadora cuando se trata de Vales de carburante.');
        dataErrorEventCall(k02_ProvinciaTomadoraItem, 'Se debe indicar la Provincia tomadora cuando se trata de Vales de carburante.');
  end;

(*********
 MÉTODOS PÚBLICOS
 *********)
  procedure TOpDivRecType02.setData( aStringList: TStrings );
  begin
    inherited setData( aStringList );
    if testIndexOf( aStringList, k02_TipoDocumentoItem )  then FTipoDocumento  := trim( aStringList.values[ k02_TipoDocumentoItem ] );
    if testIndexOf( aStringList, k02_ClausulaGastosItem ) then FClausulaGastos := trim( aStringList.values[ k02_ClausulaGastosItem ] );
    if testIndexOf( aStringList, k02_CodigoIdentificaItem ) then FCodigoIdentifica := trim( aStringList.Values[k02_CodigoIdentificaItem]);
    if testIndexOf( aStringList, k02_NumDocumentoItem )   then FNumDocumento   := trim( aStringList.Values[ k02_NumDocumentoItem ] );
    if testIndexOf( aStringList, k02_ClaveCtaAbonoItem )  then FClaveCtaAbono  := trim( aStringList.Values[ k02_ClaveCtaAbonoItem ] );
    if testIndexOf( aStringList, k02_JustificaCobroExtItem )then FJustificaCobroExt := trim( aStringList.Values[ k02_JustificaCobroExtItem ] );
    if testIndexOf( aStringList, k02_PresentaParcialItem )then FPresentaParcial := trim( aStringList.Values[ k02_PresentaParcialItem ] ); 
    if testIndexOf( aStringList, k02_ImporteOriginalItem ) then FImporteOriginal := StrToFloat( ReplaceStr( aStringList.Values[ k02_ImporteOriginalItem ], '.', ',' ) );
    if testIndexOf( aStringList, k02_ProvinciaTomadoraItem )then FProvinciaTomadora := aStringList.Values[ k02_ProvinciaTomadoraItem ];
  end;

  //: devuelve los datos en forma de una StrinList <nombre>=<valor>
  procedure TOpDivRecType02.getData( aStringList: TStrings );
  begin
    inherited getData( aStringList );
    aStringList.values[ k02_TipoDocumentoItem ]  := FTipoDocumento;
    aStringList.Values[ k02_ClausulaGastosItem ] := FClausulaGastos;
    aStringList.Values[ k02_CodigoIdentificaItem ] := FCodigoIdentifica;
    aStringList.Values[ k02_NumDocumentoItem ]   := FNumDocumento;
    aStringList.Values[ k02_ClaveCtaAbonoItem ]  := FClaveCtaAbono;
    aStringList.Values[ k02_JustificaCobroExtItem ] := FJustificaCobroExt;
    aStringList.Values[ k02_PresentaParcialItem ] := FPresentaParcial;
    aStringList.Values[ k02_ImporteOriginalItem ] := getValidStringFromDouble( FImporteOriginal, 11, 3 );
    aStringList.Values[ k02_ProvinciaTomadoraItem ] := FProvinciaTomadora ;
  end;

  //:: se fuerza la comprobación de todos los datos
  procedure TOpDivRecType02.TestData;
  begin
    inherited;

    ValidaParcial();
    ValidaNumDoc();
    ValidaProvincia();
  end;

  //:: devuelve el contenido del registro como si se tratara del registro del archivo final
  function TOpDivRecType02.getDataAsFileRecord: String;
  begin
    result := AddCharR( ' ', inherited getDataAsFileRecord()
         + FTipoDocumento
         + FClausulaGastos
(*  -- después de la inserción del código de identificación hay que insertarlo de otra forma
         + FNumDocumento
*)
         + FCodigoIdentifica + '0' + FNumDocumento
         + FClaveCtaAbono
         + FJustificaCobroExt
         + FPresentaParcial
         + AddChar( '0', ReplaceStr(getValidStringFromDouble( FImporteOriginal, 11, 2 ), '.', ''), 11 )
         + FProvinciaTomadora
         , 352 );
  end;

// 07.05.02 - a partir de ahora se encarga un procedimiento intermedio de imprimir los datos
  function TOpDivRecType02.printSpecificType: String;
  begin
    Result := 'TIPO: 02 - CHEQUES.';
  end;

//  procedure TOpDivRecType02.getDataAsPrintedRecord(anStrList: TStringList);
  procedure TOpDivRecType02.printSpecificData( aDataString: TStringList );
  var
    lnPtr: String;
    anStrList: TStringList;  // necesario como alias para evitar cambiar todo el código
  begin
    anStrList := aDataString;

//    anStrList.Add('TIPO: 02 - CHEQUES.');
//    anStrList.Add(MS('_', 90));
//    inherited getDataAsPrintedRecord(anStrList);
    anStrList.Add(EmptyStr);
    // Tipo documento
    lnPtr := 'TIPO DOCUMENTO...... : ' + FTipoDocumento + ' - ';
    if      FTipoDocumento = '01' then
      lnPtr := lnPtr + 'NORMALIZADO'
    else if FTipoDocumento = '02' then
      lnPtr := lnPtr + 'NO NORMALIZADO'
    else if FTipoDocumento = '03' then
      lnPtr := lnPtr + 'SOLICITUD DE ABONO CON GARANTÍA DE REPOSICIÓN POR EXTRAVÍO.'
    else if FTipoDocumento = '04' then
      lnPtr := lnPtr + 'VALES CARBURANTE'
    else
      lnPtr := lnPtr + '??????';
    anStrList.Add(lnPtr);
    // cláusula de gastos
    lnPtr := 'CLAUSULA DE GASTOS.. : ' + FClausulaGastos + ' - ';
    if      FClausulaGastos = '0' then
      lnPtr := lnPtr + 'SIN PROTESTO/SIN DECLARACIÓN'
    else if FClausulaGastos = '1' then
      lnPtr := lnPtr + 'CON DECLARACIÓN EQUIVALENTE'
    else if FClausulaGastos = '2' then
      lnPtr := lnPtr + 'CON PROTESTO NOTARIAL'
    else
      lnPtr := lnPtr + '??????';
    anStrList.Add(lnPtr);
    // código del documento
    lnPtr := 'CÓDIGO DEL DOCUMENTO : ';
    if ReplaceStr(FCodigoIdentifica + FNumDocumento, '0', '') <> EmptyStr then
      lnPtr := lnPtr + FCodigoIdentifica + '0' + FNumDocumento;
    anStrList.Add(lnPtr);
    // residente + justificación cobro ext.
    lnPtr := 'CLAVE CTA. ABONO.... : ' + FClaveCtaAbono + ' - ';
    if FClaveCtaAbono = '1' then
      lnPtr := lnPtr + 'RESIDENTE'
    else
      lnPtr := lnPtr + 'NO RESIDENTE';
    lnPtr := AddCharR(' ', lnPtr, 48) + 'JUST. COBRO DEL EXTERIOR :' ;
    if FJustificaCobroExt = '1' then
      lnPtr := lnPtr + 'SÍ'
    else
      lnPtr := lnPtr + 'NO';
    anStrList.Add(lnPtr);
    // presentación parcial + importe inicial
    lnPtr := 'PRESENTACIÓN PARCIAL : ' ;
    if FPresentaParcial = '1' then
      lnPtr := lnPtr + 'SÍ'
    else
      lnPtr := lnPtr + 'NO';
    lnPtr := lnPtr + MS(' ', 10) + 'IMPORTE DOCUMENTO ORIGINAL : '
         + FloatToStrF(FImporteOriginal, ffNumber, 11, 2);
    anStrList.Add(lnPtr);
    // provincia tomadora
    if FTipoDocumento = '04' then
    begin
      lnPtr := 'PROVINCIA TOMADORA.. : ' + FProvinciaTomadora + ' - ';
      if theQueryEngine.existsProvincia(FProvinciaTomadora) then
        lnPtr := lnPtr + theQueryEngine.getProvinciaName(FProvinciaTomadora)
      else
        lnPtr := lnPtr + '??????';
      anStrList.Add(lnPtr);
    end;

  end;

end.
