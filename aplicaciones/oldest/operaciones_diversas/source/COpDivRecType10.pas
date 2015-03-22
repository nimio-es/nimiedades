unit COpDivRecType10;

(*******************************************************************************
 * CLASE: TOpDivRecType10                                                      *
 * FECHA CREACION: 14-08-2001                                                  *
 * PROGRAMADOR: Saulo Alvarado Mateos                                          *
 * DESCRIPCIÓN:                                                                *
 *       Implementación del registro tipo 10 - Reembolsos                      *
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
    k10_OrdenanteItem           = '11.01';
    k10_ConceptoItem            = '11.02';
    k10_ConceptoComplementaItem = '11.03';
    k10_IndicadorResidenciaItem = '11.04';

  type
    TOpDivRecType10 = class( TOpDivSystemRecord )

      protected
        FOrdenanteReembolso : String;
        FConceptoReembolso: String;
        FConceptoComplementa: String;
        FIndicadorResidencia: String;

        //:: soporte propiedades
        procedure setOrdenanteReembolso( const aString: String );
        function  getOrdenanteDescripcion: String;
        procedure setConceptoReembolso( const aString: String );
        function  getConceptoDescripcion: String;
        procedure setConceptoComplementa( const aString: String );
        procedure setIndicadorResidencia( const aString: String );

        //:: otros métodos de soporte
        procedure initializeData; override;
        function  getStringForCodeData: String; override;

        // 07.05.02
        function  printSpecificType: String; override;
        procedure printSpecificData( aDataString: TStringList ); override;

      public
        // ** propiedades
        property OrdenanteReembolso: String read FOrdenanteReembolso write setOrdenanteReembolso;
        property OrdenanteDescripcion: String read getOrdenanteDescripcion;
        property ConceptoReembolso: String read FConceptoReembolso write setConceptoReembolso;
        property ConceptoDescripcion: String read getConceptoDescripcion;
        property ConceptoComplementa: String read FConceptoComplementa write setConceptoComplementa;
        property IndicadorResidencia: String read FIndicadorResidencia write setIndicadorResidencia;

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
    CCriptografiaCutre,
    SysUtils,
    rxStrUtils,
    CQueryEngine;

  const
    kOrdenantes: array [1..6,1..2] of string = ( ( '01', 'SERMEPA' ), ( '02', '4B' ), ( '03', 'EURO 6000' ), ( '04', 'VISA INTERNACIONAL' ), ( '05', 'MASTERCARD INTERNACIONAL' ), ('06', 'Otros ordenantes' ) );
    kOrdenanteMaximo = 6;
    kOrdenanteMinimo = 1;

(*********
 MÉTODOS PRIVADOS
 *********)

  //***** soporte de propiedades
  procedure TOpDivRecType10.setOrdenanteReembolso( const aString: String );
  var
   iMsg: integer;
   iOrdena: integer;
   texto: string;
   msgError: string;
  begin
    texto := AddChar( '0', trim( aString ), 2 );
    if ReplaceStr( texto, '0', '' ) <> EmptyStr then
    begin
      iOrdena := strToint( texto );
      if (iOrdena < kOrdenanteMinimo) or (iOrdena > kOrdenanteMaximo) then
      begin
        msgError := 'El ordenante debe ser alguno de los siguientes: ';
        for iMsg := 1 to 6 do
          msgError := msgError + #13 + kOrdenantes[iMsg,1] + ' - ' + kOrdenantes[iMsg,2] ;
        raise Exception.Create( msgError );
      end;
    end;
    if (FOrdenanteReembolso <> texto) and ( ReplaceStr( texto, '0', '' ) <> EmptyStr ) then
    begin
      FOrdenanteReembolso := texto;
      changeEventCall();
    end
  end;

  function  TOpDivRecType10.getOrdenanteDescripcion: String;
  var
    iOrden: integer;
  begin
    iorden := strToInt( FOrdenanteReembolso ) ;
    result := kOrdenantes[ iOrden, 2 ];
  end;

  procedure TOpDivRecType10.setConceptoReembolso( const aString: String );
  const
    klErrorNoExiste = 'El Código de reembolso indicado no existe.';
  var
    texto: String;
  begin
    texto := AddChar( '0', trim( aString ), 2 );
    if ( FConceptoReembolso <> texto ) then
    begin
      if not theQueryEngine.existsConceptoReembolso( texto ) then
        raise Exception.Create(klErrorNoExiste);
      FConceptoReembolso := texto;
      changeEventCall();
    end;
  end;

  function  TOpDivRecType10.getConceptoDescripcion: String;
  begin
    Result := theQueryEngine.getConceptoReembolso(FConceptoReembolso);
  end;

  procedure TOpDivRecType10.setConceptoComplementa( const aString: String );
  var
    texto: String;
  begin
    texto := trim( aString );
    if FConceptoComplementa <> texto then
    begin
      FConceptoComplementa := texto;
      changeEventCall();
    end;
  end;

  procedure TOpDivRecType10.setIndicadorResidencia( const aString: String );
  var
    texto: String;
  begin
    texto := trim( aString );
    if texto <> EmptyStr then
    begin
      if ( texto <> '1' ) and ( texto <> '2' ) then
        raise Exception.Create( 'El indicador de residencia sólo puede contener 1 ó 2, Residente y No residentes respectivamente.' );
    end;
    if FIndicadorResidencia <> texto then
    begin
      FIndicadorResidencia := texto ;
      changeEventCall();
    end
  end;

  //***** otros métodos de soporte
  procedure TOpDivRecType10.initializeData;
  begin
    inherited;
    FRecType := '10' ;   // operación tipo 10
    FOpNat   := '1';     // en principio suponemos cobros
    FOpNatFixed := false; //
    FClaveAutorizaEsObligatoria := false;

    FOrdenanteReembolso  := '01';
    FConceptoReembolso   := '24';
    FConceptoComplementa := '';
    FIndicadorResidencia := '1';
  end;

  function TOpDivRecType10.getStringForCodeData: String;
  begin
    Result := inherited getStringForCodeData()
            + kCodeSeparator + FOrdenanteReembolso
            + kCodeSeparator + FConceptoReembolso
            + kCodeSeparator + FConceptoComplementa
            + kCodeSeparator + FIndicadorResidencia
            + kCodeSeparator ;
  end;

(*********
 MÉTODOS PÚBLICOS
 *********)

  procedure TOpDivRecType10.setData( aStringList: TStrings );
  var
    oldData: String;
  begin
    inherited setData( aStringList );

// 02.05.02 - Ahora hay un nuevo Ordenante del reembolso: MASTERCARD INTERNACIONAL que pasa a ocupar el lugar del que antes era "Otros ordenantes".
//            Por ello, cuando se lee un registro antiguo, se procede a "actualizar" al valor correcto.
//    if testIndexOf( aStringList, k10_OrdenanteItem ) then FOrdenanteReembolso := aStringList.Values[ k10_OrdenanteItem ];
    if testIndexOf( aStringList, k10_OrdenanteItem ) then
    begin
      oldData := aStringList.Values[ k10_OrdenanteItem ];
      if (oldData = '05') and (FDateCreation < EncodeDate( 2002, 05, 07 )) then
        oldData := '06';
      FOrdenanteReembolso := oldData;
    end;
    if testIndexOf( aStringList, k10_ConceptoItem )  then FConceptoReembolso  := aStringList.Values[ k10_ConceptoItem ];
    if testIndexOf( aStringList, k10_ConceptoComplementaItem ) then FConceptoComplementa := aStringList.Values[ k10_ConceptoComplementaItem ];
    if testIndexOf( aStringList, k10_IndicadorResidenciaItem ) then FIndicadorResidencia := aStringList.Values[ k10_IndicadorResidenciaItem ];
  end;

  //: devuelve los datos en forma de una StrinList <nombre>=<valor>
  procedure TOpDivRecType10.getData( aStringList: TStrings );
  begin
    inherited getData( aStringList );

    aStringList.Values[ k10_OrdenanteItem ] := FOrdenanteReembolso ;
    aStringList.Values[ k10_ConceptoItem ]  := FConceptoReembolso ;
    astringList.Values[ k10_ConceptoComplementaItem ] := FConceptoComplementa ;
    aStringList.Values[ k10_IndicadorResidenciaItem ] := FIndicadorResidencia;
  end;

  //:: se fuerza la comprobación de todos los datos
  procedure TOpDivRecType10.TestData;
  begin
    inherited;
  end;

  //:: devuelve el contenido del registro como si se tratara del registro del archivo final
  function TOpDivRecType10.getDataAsFileRecord: String;
  begin
    result := AddCharR( ' ', inherited getDataAsFileRecord()
            + FOrdenanteReembolso
            + FConceptoReembolso
            + AddCharR( ' ', FConceptoComplementa, 80 )
            + FIndicadorResidencia, 352 );
  end;

// 07.05.02 - ahora se encargan dos métodos intermedios de imprimir la información específica del registro

  function TOpDivRecType10.printSpecificType: String;
  begin
    Result := 'TIPO: 10 - REEMBOLSOS';
  end;

//  procedure TOpDivRecType10.getDataAsPrintedRecord(anStrList: TStringList);
  procedure TOpDivRecType10.printSpecificData( aDataString: TStringList );
  var
    lnPtr: String;
    anStrList: TStringList;  // alias del parámetro de entrada/salida para no cambiar todo el código ya escrito
  begin
    anStrList := aDataString;

//    anStrList.Add('TIPO: 10 - REEMBOLSOS');
//    anStrList.Add(MS('_',90));
//    inherited getDataAsPrintedRecord(anStrList);

    anStrList.Add(EmptyStr);
    // ordenante reembolso
    lnPtr := 'ORDENANTE REEMBOLSO.... : ' + FOrdenanteReembolso + ' - ';
    if FOrdenanteReembolso = '01' then
      lnPtr := lnPtr + 'SERMEPA'
    else if FOrdenanteReembolso = '02' then
      lnPtr := lnPtr + '4B'
    else if FOrdenanteReembolso = '03' then
      lnPtr := lnPtr + 'EURO 6000'
    else if FOrdenanteReembolso = '04' then
      lnPtr := lnPtr + 'VISA INTERNACIONAL'
    else if FOrdenanteReembolso = '05' then
      lnPtr := lnPtr + 'OTROS ORDENANTES'
    else
      lnPtr := lnPtr + '??????';
    anStrList.Add(lnPtr);
    // concepto reembolso
    lnPtr := 'CONCEPTO REEMBOLSO..... : ' + FConceptoReembolso + ' - ' ;
    if theQueryEngine.existsConceptoReembolso(FConceptoReembolso) then
      lnPtr := lnPtr + theQueryEngine.getConceptoReembolso(FConceptoReembolso)
    else
      lnPtr := lnPtr + '??????';
    anStrList.Add(lnPtr);
    // concepto complementario
    lnPtr := 'CONCEPTO COMPLEMENTARIO : ' ;
    anStrList.Add(lnPtr);
    if Trim(FConceptoComplementa) <> EmptyStr then
    begin
      lnPtr := '  ' + Trim(FConceptoComplementa);
      anStrList.Add(lnPtr);
    end;
    // indicador de residencia
    lnPtr := 'INDICADOR DE RESIDENCIA : ' + FIndicadorResidencia + ' - ';
    if FIndicadorResidencia = '1' then
      lnPtr := lnPtr + 'RESIDENTE'
    else if FIndicadorResidencia = '2' then
      lnPtr := lnPtr + 'NO RESIDENTE'
    else
      lnPtr := lnPtr + '??????';
    anStrList.Add(lnPtr);
  end;

  class function TOpDivRecType10.isDocumentable: boolean;
  begin
    result := false;
  end;

end.
