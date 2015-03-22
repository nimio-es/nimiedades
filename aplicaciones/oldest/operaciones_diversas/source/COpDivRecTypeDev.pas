unit COpDivRecTypeDev;

(*******************************************************************************
 * CLASE: TOpDivRecTypeDev                                                     *
 * FECHA CREACION: 10-10-2001                                                  *
 * PROGRAMADOR: Saulo Alvarado Mateos (CINCA)                                  *
 * DESCRIPCI�N:                                                                *                                                                              *
 *       Implementaci�n de las devoluciones de operaciones.                    *
 *       Hay que tener unas cuantas cosillas en cuenta. Para aprovechar lo     *
 * escrito hasta el momento (el c�digo), se han reusado algunos campos pero    *
 * cambiando el sentido. En particular sucede con las entidades y oficinas de  *
 * origen y destino, que han intercambiado su "sentido" en este tipo. Asimismo *
 * es necesario crear un campo adicional para contener el tipo original de la  *
 * operaci�n motivo de la devoluci�n, aunque el campo f�sico final sea ex�c-   *
 * tamente el mismo que en los casos de los tipos de operaciones convencio-    *
 * nales. Otro tema, adem�s, es que el m�todo de clase que indica si es un     *
 * tipo documental o no se debe convertir en un m�todo del objeto para acceder *
 * al tipo de operaci�n original y valorar en ese caso.                        *
 *                                                                             *
 * FECHA MODIFICACI�N: 01-05-2002                                              *
 * PROGRAMADOR: Saulo Alvarado Mateos (CINCA)                                  *
 * DESCRIPCI�N:                                                                *
 *       A partir de este momento, dado que ciertos c�digos para motivos de    *
 * devoluci�n incluyen elementos sem�nticos (dependencias con otros valores),  *
 * se construye la clase para autocontener una descripci�n de estos c�digos    *
 * -tabla constante- y con funciones de comprobaci�n de coherencia, prescin-   *
 * di�ndose as� de la necesidad de una tabla externa con los valores.          *               
 *                                                                             *
 * FECHA MODIFICACI�N: 07-05-2002                                              *
 * PROGRAMADOR: Saulo Alvarado Mateos (CINCA)                                  *
 * DESCRIPCI�N:                                                                *
 *       Se ajusta la clase a la nueva forma de impresi�n del registro, tenien-*
 * do ahora un par de m�todos intermediarios.                                  *
 *******************************************************************************)

interface
  uses
    classes,
    UAuxRefOp,
    CCustomDBMiddleEngine,
    COpDivSystemRecord ;

  const
    kDEV_TipoOpOriginalItem      = 'DEV.01';
    kDEV_FechaPresentaItem       = '11.01';
    kDEV_ImporteInicialItem      = '11.02';
    kDEV_DevParcialItem          = '11.03';
    kDEV_MotivoDevolucionItem    = '11.04';
    kDEV_ConceptoComplementaItem = '11.06';

  type
    TOpDivRecTypeDEV = class( TOpDivSystemRecord )
      protected
        FTipoOpOriginal: String;
        FFechaPresenta: TDateTime;
        FImporteInicial: Double;
        FDevParcial: String;
        FMotivoDev: String;
        FConceptoComplementa: String;

        //*****
        // m�todos de soporte a las propiedades
        //*****
        procedure setTipoOriginal( const aString: String);
        procedure setFechaPresenta( aDate: TDateTime );
        procedure setImporteInicial( aDouble: Double );
        procedure setDevParcial( isParcial: Boolean );
        function  getDevParcial: Boolean;
        procedure setMotivoDev(const aString: String);
        function  getMotivoDevDesc: String;
        procedure setConceptoComplementa(const aString: String);

        //:: cambios
        procedure changeImporteOperacion; override;

        //:: otros m�todos de soporte
        procedure initializeData; override;
        function getStringForCodeData: String; override;

        //:: m�todos de validaci�n preaceptaci�n
        procedure validaImporte;
        procedure validaTipoOriginal;
        procedure validaReferenciaOp;
        procedure validaFechaPresenta;
        procedure validaCodigoDevolucion;  // inclu�da en modificaci�n del 01.05.02

        //:: m�todos adicionales para la b�squeda de informaci�n relacionada
        //   (inclu�dos en modificaci�n del 01.05.02).
        function testCodigoDevolucion(const codigoMotivo: String; var anErrMsg: String): Boolean;
        function existsConceptoDevolucion(const codigoMotivo: String): Boolean;
        function getConceptoDevolucion(const codigoMotivo: String): String;

        // 07.05.02
        function  printSpecificType: String; override;
        procedure printSpecificData( aDataString: TStringList ); override;

       public
        // **** PROPIEDADES ****
        //: creamos las propiedades inherentes a este tipo de registro
        property TipoOpOriginal: String read FTipoOpOriginal write setTipoOriginal;
        property FechaPresenta: TDateTime read FFechaPresenta write setFechaPresenta;
        property ImporteInicial: Double read FImporteInicial write setImporteInicial;
        property DevParcial: Boolean read getDevParcial write setDevParcial;
        property MotivoDev: String read FMotivoDev write setMotivoDev;
        property MotivoDevDesc: String read getMotivoDevDesc;
        property ConceptoComplementa: String read FConceptoComplementa write setConceptoComplementa;

        //** m�todos heredados (algunos de los cuales hay que redefinir )
        procedure setData( aStringList: TStrings ); override;
        procedure getData( aStringList: TStrings ); override;
        procedure TestData; override;
        function getDataAsFileRecord: String; override;
// 07.05.02 - ahora se encargan dos m�todos intermedios de imprimir la informaci�n espec�fica del registro
//        procedure getDataAsPrintedRecord(anStrList: TStringList); override;

        // se sobrecarga el m�todo que devuelve si un tipo es documental o no pero
        // haci�ndolo de la instancia en vez de la clase, dado que ahora se tiene
        // en cuenta el Tipo Original
        function isDocumentable: boolean; virtual;

        // funciones de la clase
        class function isOfThisNatOp(const opType, opNat: String): Boolean;

    end;

implementation

  uses
    CCriptografiaCutre,
    CQueryEngine,
    SysUtils,
    rxStrUtils;

  const
    k_NUM_MOTIVOS_DEV = 15;
    k_MOTIVOS_DEV_TABLA: array [1 .. k_NUM_MOTIVOS_DEV, 1..2] of String =
        ( ( '10', 'VALIDACI�N INFORM�TICA' ),
          ( '15', 'DISCREPANCIA EN EL IMPORTE' ),
          ( '20', 'ORDEN DE NO PAGAR' ),
          ( '25', 'DEFECTO DE FORMA (PARA TIPOS 01 Y 02)' ),
          ( '30', 'INCORRIENTE'),
          ( '35', 'DATOS INSUFICIENTES PARA APLICAR' ),
          ( '40', 'SIN INSTRUCCIONES' ),
          ( '45', 'CLAVE DE AUTORIZACI�N INEXISTENTE, ERR�NEA O VENCIDA' ),
          ( '50', 'TIPO DE OPERACI�N NO CORRESPONDE' ),
          ( '60', 'APLICACI�N R.D. 338/1990, SOBRE N.I.F.' ),
          ( '65', 'ENTIDAD NO CORRESPONDE' ),
          ( '70', 'CUENTA DE NO RESIDENTE (APLICABLE EN TIPOS 01 Y 02)' ),
          ( '80', 'FALTA DE DOCUMENTO' ),
          ( '85', 'DOCUMENTO NO PERMITIDO (INCLUIDO YA PAGADOS O DUPLICIDADES)' ),
          ( '90', 'OTROS' ) );


(* ******************
   M�TODOS PROTEGIDOS
   ******************)

  //****** Soporte a lass propiedades ******
  procedure TOpDivRecTypeDEV.setTipoOriginal( const aString: String);
  var
    tipo: String;
  begin
    tipo := AddChar('0', Trim(aString), 2);
    if FTipoOpOriginal <> tipo then
    begin
      if tipo <> EmptyStr then
        if (strToInt(tipo) < 1) or (strToInt(tipo) > 14) then
        begin
//          raise Exception.Create('El tipo de operaci�n original indicado no es v�lido.');
          dataErrorEventCall(kDEV_TipoOpOriginalItem, 'El tipo de operaci�n original indicado no es v�lido.');
          Exit;
        end;

      FTipoOpOriginal := tipo;
      changeEventCall();
    end
  end;

  procedure TOpDivRecTypeDEV.setFechaPresenta( aDate: TDateTime );
  begin
    if FFechaPresenta <> aDate then
    begin
      FFechaPresenta := aDate;
      changeEventCall();
    end
  end;

  procedure TOpDivRecTypeDEV.setImporteInicial( aDouble: Double );
  begin
    if FImporteInicial <> aDouble then
    begin
      if aDouble < 0.0 then
      begin
//        raise Exception.Create('El importe no puede ser inferiro a 0');
        dataErrorEventCall(kDEV_ImporteInicialItem, 'El importe no puede ser inferiro a 0');
        Exit;
      end;
      if FDevParcial = '1' then
        if abs(aDouble) < 0.01 then
        begin
//          raise Exception.Create('Se debe indicar un Importe inicial cuando se trata de devoluciones parciales.');
          dataErrorEventCall(kDEV_ImporteInicialItem, 'Se debe indicar un Importe inicial cuando se trata de devoluciones parciales.');
        end;

      FImporteInicial := aDouble;
      changeEventCall();
    end
  end;

  procedure TOpDivRecTypeDEV.setDevParcial( isParcial: Boolean );
  var
    strParcial: String;
  begin
    strParcial := '2';
    if isParcial then strParcial := '1';
    if FDevParcial <> strParcial then
    begin
      FDevParcial := strParcial;
      if not isParcial then FImporteInicial := FImportePrinOp;  // por simetr�a en la operaci�n
      changeEventCall();
    end;
  end;

  function  TOpDivRecTypeDEV.getDevParcial: Boolean;
  begin
    result := (FDevParcial = '1');
  end;

  procedure TOpDivRecTypeDEV.setMotivoDev(const aString: String);
  var
    codigoMotivo,
    theErrMsg: String;
  begin
    codigoMotivo := AddChar('0', Trim(aString), 2);
    if FMotivoDev <> codigoMotivo then
    begin
// 01.05.02 -- a partir de ahora, la validaci�n de los motivos de devoluci�n est� autocontenida en la clase
//             De la validaci�n, inclu�da la comprobaci�n de que existe, se encarga una funci�n creada para
//             tal fin.
//      if not theQueryEngine.existsConceptoDevolucion(codigoMotivo) then
//        raise Exception.Create('No existe el C�digo se�alado para el Motivo de la devoluci�n en la BB.DD.');
      if not testCodigoDevolucion(codigoMotivo, theErrMsg) then
      begin
        dataErrorEventCall(kDEV_MotivoDevolucionItem, theErrMsg);
        Exit;
      end;
      
      FMotivoDev := codigoMotivo;
      changeEventCall();
    end
  end;

  function  TOpDivRecTypeDEV.getMotivoDevDesc: String;
  begin
// 01.05.02 -- a partir de ahora, la validaci�n de los motivos de devoluci�n est� autocontenida en la clase
//    Result := theQueryEngine.getConceptoDevolucion(FMotivoDev);
    Result := getConceptoDevolucion(FMotivoDev)
  end;

  procedure TOpDivRecTypeDEV.setConceptoComplementa(const aString: String);
  var
    concepto:String;
  begin
    concepto := Copy(UpperCase(Trim(aString)), 1, 80);
    if FConceptoComplementa <> concepto then
    begin
      FConceptoComplementa := concepto;
      changeEventCall();
    end
  end;

  //:: cambios
  procedure TOpDivRecTypeDEV.changeImporteOperacion;
  begin
    if FDevParcial = '2' then // cuando no es parcial, se tienen que igualar los valores
      FImporteInicial := FImportePrinOp;
  end;


  //***** otros m�todos de soporte
  procedure TOpDivRecTypeDEV.initializeData;
  begin
    inherited;
    FRecType := 'DEV' ;  // operaci�n tipo 06
    FOpNat := '1';  // siempre se trata de cobros
    //
    FOpNatFixed := false;
    FClaveAutorizaEsObligatoria := false;
    FNumCtaDestinoEsObligatoria := false;

    // dado que es una devoluci�n, no debemos confundir al usuario con una referencia t�pica de La Caja
    FOpRef := EmptyStr;

    // tambi�n se le van a dar valores iniciales a los datos
    FTipoOpOriginal := EmptyStr;  // vamos a suponer que siempre se empieza con el valor 2...
    FFechaPresenta  := 0.0 ;  // hay que indicar la fecha...
    FImporteInicial := 0.0;
    FDevParcial     := '2';   // no hay presentaci�n parcial
// 01.05.02 -- Dado que desde este momento, el motivo 90 no es v�lido para todos los tipos,
//             ponemos por defecto el nuevo motivo "50, TIPO OPERACI�N NO CORRESPONDE".
//    FMotivoDev      := '90';  // el motivo de la devoluci�n se establece inicialmente a OTROS
    FMotivoDev := '50';
    FConceptoComplementa := EmptyStr;

  end;

  function  TOpDivRecTypeDEV.getStringForCodeData: String;
  begin
    result := inherited getDataAsFileRecord()
            + kCodeSeparator + FTipoOpOriginal
            + kCodeSeparator + dateToStr(FFechaPresenta)
            + kCodeSeparator + getValidStringFromDouble( FImporteInicial, 11, 3 )
            + kCodeSeparator + FDevParcial
            + kCodeSeparator + FMotivoDev
            + kCodeSeparator + FConceptoComplementa
            + kCodeSeparator ;
  end;


  // M�todos para validaci�n.

  procedure TOpDivRecTypeDEV.validaImporte;
  begin
    if FDevParcial = '1' then  // el importe debe ser superior siempre
    begin
      if FImporteInicial <= FImportePrinOp then
        dataErrorEventCall(kDEV_ImporteInicialItem, 'Cuando se trata de una devoluci�n parcial, se ha de indicar un Importe de la operaci�n inicial superior al de la devoluci�n.');
    end
    else
      if FImporteInicial <> FImportePrinOp then
        dataErrorEventCall(kDEV_ImporteInicialItem, 'Cuando no se trata de una devoluci�n parcial, el Importe de la operaci�n inicial debe coincidir con el de la devoluci�n.');
  end;

  procedure TOpDivRecTypeDEV.validaTipoOriginal;
  begin
    if trim(FTipoOpOriginal) = EmptyStr then
      raise Exception.Create('Se debe introducir el Tipo de operaci�n del documento original.');
  end;

  procedure TOpDivRecTypeDEV.validaReferenciaOp;
  begin
    if not testReferenciaOperacion(FOpRef) then
      raise Exception.Create('La Referencia insertada no es v�lida.');
  end;

  procedure TOpDivRecTypeDEV.validaFechaPresenta;
  begin
    if FFechaPresenta = 0.0 then
      raise Exception.Create('Se debe indicar una Fecha de presentaci�n v�lida.'); 
  end;

  // 01.05.02 - Inclu�do: necesidad de verificar ciertas dependencias entre
  //            motivos de devoluci�n y otros datos.
  procedure TOpDivRecTypeDEV.validaCodigoDevolucion;
  var
    theErrorMsg: String;
  begin
    if not testCodigoDevolucion( FMotivoDev, theErrorMsg ) then
      raise Exception.Create(theErrorMsg);
  end;


  // 01.05.02 - Inclu�dos.
  // M�todos necesarios para la validaci�n de los c�digos de motivo de devoluci�n
  function TOpDivRecTypeDEV.testCodigoDevolucion(const codigoMotivo: String; var anErrMsg: String): Boolean;
  begin
    Result := TRUE;
    // la varificaci�n comienza con la comprobaci�n de la existencia del c�digo del motivo
    if not existsConceptoDevolucion(codigoMotivo) then
    begin
      anErrMsg := 'El C�digo se�alado -' + '''' + codigoMotivo + '''' + '- no es v�lido.';
      Result := FALSE;
      Exit;
    end;
    // comienzan las comprobaciones "sem�nticas".
    if codigoMotivo = '25' then // MOTIVO: DEFECTO DE FORMA...
      if (FTipoOpOriginal <> '01') and (FTipoOpOriginal <> '02') then
      begin
        anErrMsg := 'S�lo se puede emplear la devoluci�n por "Defecto de forma" para los tipos de operaciones 01 y 02.';
        Result := FALSE;
        Exit;
      end;
    if codigoMotivo = '30' then // MOTIVO: INCORRIENTE...
      if FOpNat <> '1' then
      begin
        anErrMsg := 'S�lo se puede emplear la devoluci�n por "Incorriente" para las operaciones de "cobro".';
        Result := FALSE;
        Exit;
      end;
    if codigoMotivo = '70' then // CUENTA NO RESIDENTE...
      if (FTipoOpOriginal <> '01') and (FTipoOpOriginal <> '02') then
      begin
        anErrMsg := 'S�lo se puede emplear la devoluci�n por "Cuenta de no residente" para los tipos de operaciones 01 y 02.';
        Result := FALSE;
        Exit;
      end
      else  // pero cuando lo son, adem�s hay que comprobar que el importe sea igual o superior a los 12500 euros
      begin
        if FImporteInicial < 12500 then
        begin
          anErrMsg := 'S�lo se puede emplear la devoluci�n por "Cuenta de no residente" para importes sea igual o superior a 12.500 Euros.';
          Result := FALSE;
          Exit;
        end;
      end;
    if codigoMotivo = '80' then // FALTA DE DOCUMENTO
      if not isDocumentable then
      begin
        anErrMsg := 'S�lo se puede emplear la devoluci�n por "Falta de documento" para aquellas operaciones con car�cter documental.';
        Result := FALSE;
        Exit;
      end;
    if codigoMotivo = '90' then // OTROS
      if (FTipoOpOriginal = '01') or (FTipoOpOriginal = '02') then
      begin
        anErrMsg := 'La devoluci�n por "Otros" no puede ser empleada en los tipos de operaciones 01 y 02.';
        Result := FALSE;
        Exit;
      end;
  end;

  function TOpDivRecTypeDEV.existsConceptoDevolucion(const codigoMotivo: String): Boolean;
  var
    indTbl: Integer;
  begin
    Result := FALSE;
    for indTbl := 1 to k_NUM_MOTIVOS_DEV do
      if k_MOTIVOS_DEV_TABLA[indTbl][1] = codigoMotivo then
      begin
        Result := TRUE;
        break;
      end;
  end;

  function TOpDivRecTypeDEV.getConceptoDevolucion(const codigoMotivo: String): String;
  var
    indTbl: Integer;
  begin
    Result := EMPTYSTR;
    for indTbl := 1 to k_NUM_MOTIVOS_DEV do
      if k_MOTIVOS_DEV_TABLA[indTbl][1] = codigoMotivo then
      begin
        Result := k_MOTIVOS_DEV_TABLA[indTbl][2] ;
        break;
      end;
  end;

(*********
 M�TODOS P�BLICOS
 *********)
  procedure TOpDivRecTypeDEV.setData( aStringList: TStrings );
  begin
    inherited setData( aStringList );
    if testIndexOf(aStringList, kDEV_TipoOpOriginalItem) then FTipoOpOriginal := trim( aStringList.values[ kDEV_TipoOpOriginalItem ] );
    if testIndexOf(aStringList, kDEV_FechaPresentaItem)  then FFechaPresenta := strToDate(trim( aStringList.Values[kDEV_FechaPresentaItem]));
    if testIndexOf(aStringList, kDEV_ImporteInicialItem) then FImporteInicial := strToFloat(ReplaceStr(aStringList.Values[kDEV_ImporteInicialItem], '.', ','));
    if testIndexOf(aStringList, kDEV_DevParcialItem)     then FDevParcial := trim(aStringList.Values[kDEV_DevParcialItem]);
    if testIndexOf(aStringList, kDEV_MotivoDevolucionItem) then FMotivoDev := trim(aStringList.Values[kDEV_MotivoDevolucionItem]);
    if testIndexOf(aStringList, kDEV_ConceptoComplementaItem) then FConceptoComplementa := trim(aStringList.Values[kDEV_ConceptoComplementaItem]);
  end;

  //: devuelve los datos en forma de una StrinList <nombre>=<valor>
  procedure TOpDivRecTypeDEV.getData( aStringList: TStrings );
  begin
    inherited getData( aStringList );
    aStringList.Values[kDEV_TipoOpOriginalItem] := FTipoOpOriginal;
    aStringList.Values[kDEV_FechaPresentaItem]  := dateToStr(FFechaPresenta);
    aStringList.Values[kDEV_ImporteInicialItem] := getValidStringFromDouble( FImporteInicial, 11, 3 );
    aStringList.Values[kDEV_DevParcialItem]     := FDevParcial;
    aStringList.Values[kDEV_MotivoDevolucionItem] := FMotivoDev;
    aStringList.Values[kDEV_ConceptoComplementaItem] := FConceptoComplementa; 
  end;

  //:: se fuerza la comprobaci�n de todos los datos
  procedure TOpDivRecTypeDEV.TestData;
  begin
    inherited;

    validaImporte();
    validaTipoOriginal();
    validaReferenciaOp();
    validaFechaPresenta();
    validaCodigoDevolucion();
  end;

  //:: devuelve el contenido del registro como si se tratara del registro del archivo final
  function TOpDivRecTypeDEV.getDataAsFileRecord: String;
  begin
    // en este caso no vamos a poder hacer uso de la herencia, pues hay unas posiciones que cambian...
    Result := '70' // c�digo del registro  (*cambio respecto al heredado)
            + '62' // c�digo de la operaci�n
            + FOpNat
            + FTipoOpOriginal  // la operaci�n sobre la que se hace la devoluci�n (*cambio respecto al heredado)
            + FOpRef
            + FEntOficOrigen
            + '  '  // c�digo del pa�s
            + '00'  // d�gitos de control
            + FEntOficDestino
            + DCEntOficDestino
            + '0'
            + MS('0', 10)
            + MS( ' ', 10 ) // IBAN - disponible
            + AddChar( '0', Trim( ReplaceStr( getValidStringFromDouble( FImportePrinOp, 11, 2 ), '.', '' ) ), 11 )
            + '0'  // naturaleza de la comisi�n
            + '00' // clave de la comisi�n
            + '000000' // importe de la comisi�n en euros
            + AddChar( '0', FClaveAutoriza, 18 )
            + AddChar( '0', Trim( ReplaceStr( getValidStringFromDouble( FImporteOrigOp, 11, 0 ), '.', '' ) ), 11 );
    if FFechaPresenta > 0.0 then
      Result := Result + FormatDateTime('ddmmyyyy', FFechaPresenta)
    else
      Result := Result + MS('0', 8);
    Result := Result + AddChar('0', Trim( ReplaceStr( getValidStringFromDouble(FImporteInicial, 11, 2), '.', '') ), 11)
            + FDevParcial
            + FMotivoDev
            + MS(' ', 8)    // Concepto de la validaci�n inform�tica
            + AddCharR(' ', FConceptoComplementa, 80);

    Result := AddCharR(' ', Result, 352);
  end;

// 07.05.02 - ahora se encargan dos m�todos intermedios de imprimir la informaci�n espec�fica del registro

  function TOpDivRecTypeDEV.printSpecificType: String;
  begin
    Result := 'TIPO: DEVOLUCIONES - ' + FTipoOpOriginal;
  end;

//  procedure TOpDivRecTypeDEV.getDataAsPrintedRecord(anStrList: TStringList);
  procedure TOpDivRecTypeDEV.printSpecificData( aDataString: TStringList );
  var
    lnPtr: String;
    anStrList: TStringList;  // alias necesario para no cambiar todo el c�digo
  begin
    anStrList := aDataString;

//    anStrList.Add('TIPO: DEVOLUCIONES - ' + FTipoOpOriginal);
//    anStrList.Add(MS('_',90));
//    inherited getDataAsPrintedRecord(anStrList);

    anStrList.Add(EmptyStr);
    // tipo original de la operaci�n
    lnPtr := 'TIPO DE OPERACI�N INICIAL : ' + FTipoOpOriginal + ' - ';
    if      FTipoOpOriginal = '01' then
      lnPtr := lnPtr + 'EFECTOS'
    else if FTipoOpOriginal = '02' then
      lnPtr := lnPtr + 'CHEQUES'
    else if FTipoOpOriginal = '03' then
      lnPtr := lnPtr + 'REGULARIZACI�N DE OPERACIONES DE SISTEMAS DE INTERCAMBIO. CAR�CTER DOCUMENTAL'
    else if FTipoOpOriginal = '04' then
      lnPtr := lnPtr + 'REGULARIZACI�N DE OPERACIONES DE SISTEMAS DE INTERCAMBIO. SIN CAR�CTER DOCUMENTAL'
    else if FTipoOpOriginal = '05' then
      lnPtr := lnPtr + 'ACTAS DE PROTESTO'
    else if FTipoOpOriginal = '06' then
      lnPtr := lnPtr + 'COMISIONES Y GASTOS DE CR�DITO Y/O REMESAS DOCUMENTARIOS'
    else if FTipoOpOriginal = '07' then
      lnPtr := lnPtr + 'PAGOS EN NOTAR�A'
    else if FTipoOpOriginal = '08' then
      lnPtr := lnPtr + 'CESIONES DE EFECTIVO'
    else if FTipoOpOriginal = '09' then
      lnPtr := lnPtr + 'COMPRAVENTA DE MONEDA EXTRANJERA'
    else if FTipoOpOriginal = '10' then
      lnPtr := lnPtr + 'REEMBOLSOS'
    else if FTipoOpOriginal = '11' then
      lnPtr := lnPtr + 'REGULARIZACI�N DESFASES TESOREROS'
    else if FTipoOpOriginal = '12' then
      lnPtr := lnPtr + 'COMISIONES'
    else if FTipoOpOriginal = '13' then
      lnPtr := lnPtr + 'RECUPERACI�N DE COMISIONES Y/O INTERESES DE LOS SUBSISTEMAS DE INTERCAMBIO'
    else if FTipoOpOriginal = '14' then
      lnPtr := lnPtr + 'OTRAS OPERACIONES'
    else
      lnPtr := lnPtr + '?????';
    anStrList.Add(lnPtr);
    // fecha presentaci�n inicial
    lnPtr := 'FECHA DE PRESENTACI�N INICIAL.. : ' + FormatDateTime('dd/mm/yyyy', FFechaPresenta);
    anStrList.Add(lnPtr);
    // importe operaci�n inicial + devoluci�n parcial
    lnPtr := 'IMPORTE DE LA OPERACI�N INICIAL : ' + AddCharR(' ', FloatToStrF(FImporteInicial, ffNumber, 11, 2) + ' �', 14);
    lnPtr := lnPtr + MS(' ',4) + 'DEVOLUCI�N PARCIAL : ';
    if FDevParcial = '1' then
      lnPtr := lnPtr + 'S�'
    else if FDevParcial = '2' then
      lnPtr := lnPtr + 'NO'
    else
      lnPtr := lnPtr + '??';
    anStrList.Add(lnPtr);
    // motivo de la devoluci�n
    lnPtr := 'MOTIVO DE LA DEVOLUCI�N........ : ' + FMotivoDev + ' - ';
// 01.05.02 : A partir de ahora, las operaciones sobre la "tabla" de valores posibles est� autocontenida en la clase
//    if theQueryEngine.existsConceptoDevolucion(FMotivoDev) then
//      lnPtr := lnPtr + theQueryEngine.getConceptoDevolucion(FMotivoDev)
    if existsConceptoDevolucion(FMotivoDev) then
      lnPtr := lnPtr + getConceptoDevolucion(FMotivoDev)
    else
      lnPtr := lnPtr + '??????';
    anStrList.Add(lnPtr);
    // concepto complementario
    lnPtr := 'CONCEPTO COMPLEMENTARIO :';
    anStrList.Add(lnPtr);
    lnPtr := '  ' + FConceptoComplementa;
    anStrList.Add(lnPtr);
  end;

  function TOpDivRecTypeDEV.isDocumentable: Boolean;
  const kDocTipo: array [0..14] of Boolean =
          ( false, true, true, true, false, true, false, true,
            false, false, false, false, true, true, true );
  begin
    if FTipoOpOriginal = EmptyStr then
      Result := kDocTipo[0]
    else
      Result := kDocTipo[strToInt(FTipoOpOriginal)];
  end;


  // :: funciones de clase
  class function TOpDivRecTypeDEV.isOfThisNatOp(const opType, opNat: String): Boolean;
  const
    NAT_OF_TYPES: array [1..14, 1..2] of Boolean =
       ( ( TRUE, FALSE ),   // Tipo 01
         ( TRUE, FALSE ),   // Tipo 02
         ( TRUE, TRUE ),   // Tipo 03
         ( TRUE, TRUE ),   // Tipo 04
         ( TRUE, FALSE ),   // Tipo 05
         ( TRUE, FALSE ),   // Tipo 06
         ( FALSE, TRUE ),   // Tipo 07
         ( TRUE, FALSE ),   // Tipo 08
         ( TRUE, TRUE ),   // Tipo 09
         ( TRUE, TRUE ),   // Tipo 10
         ( TRUE, TRUE ),   // Tipo 11
         ( TRUE, FALSE ),   // Tipo 12
         ( TRUE, FALSE ),   // Tipo 13
         ( TRUE, TRUE ) );   // Tipo 14
  var
    numOpType,
    numOpNat: Integer;
  begin
    Result := FALSE;
    if Trim(opType) <> EmptyStr then
    begin
      numOpType := StrToInt(opType);
      numOpNat  := StrToInt(opNat);
      Result := NAT_OF_TYPES[numOpType, numOpNat];
    end;
  end;

end.
