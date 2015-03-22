unit COpDivRecType14;

(*******************************************************************************
 * CLASE: TOpDivRecType14                                                      *
 * FECHA CREACION: 17-08-2001                                                  *
 * PROGRAMADOR: Saulo Alvarado Mateos                                          *
 * DESCRIPCIÓN:                                                                *
 *       Implementación del registro tipo 14 - Otras Operaciones               *
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
    k14_IndicativoCUCItem       = '11.01';
    k14_ConceptoComplementaItem = '12.01';

  type
    TOpDivRecType14 = class( TOpDivSystemRecord )

      protected
        FIndicativoCUC: String;
        FConceptoComplementa: String;

        //:: soporte propiedades
        function  isRegularizacionCUC: boolean;
        procedure setRegularizacionCUC( isRegularizacion: boolean );
        procedure setConceptoComplementa( const aString: string );

        //:: otros métodos de soporte
        procedure initializeData; override;
        function  getStringForCodeData: String; override;

        // 07.05.02
        function  printSpecificType: String; override;
        procedure printSpecificData( aDataString: TStringList ); override;

      public
        // ** propiedades
        property RegularizacionCUC: boolean read isRegularizacionCUC write setRegularizacionCUC;
        property ConceptoComplmenta: String read FConceptoComplementa write setConceptoComplementa;

        //** métodos heredados (algunos de los cuales hay que redefinir )
        procedure setData( aStringList: TStrings ); override;
        procedure getData( aStringList: TStrings ); override;
        procedure TestData; override;
        function  getDataAsFileRecord: String; override;
// 07.05.02 - ahora se encargan dos métodos intermedios de imprimir la información específica del registro
//        procedure getDataAsPrintedRecord(anStrList: TStringList); override;

    end;

implementation

  uses
    CCriptografiaCutre,
    SysUtils,
    rxStrUtils;

(*********
 MÉTODOS PRIVADOS
 *********)

  //***** soporte de propiedades
  function  TOpDivRecType14.isRegularizacionCUC: boolean;
  begin
    result := ( FIndicativoCUC = '1' );
  end;

  procedure TOpDivRecType14.setRegularizacionCUC( isRegularizacion: boolean );
  const
    kValoresRegulariza: array [boolean] of string = ( '0', '1' );
  begin
    if FIndicativoCUC <> kValoresRegulariza[ isRegularizacion ] then
    begin
      FIndicativoCUC := kValoresRegulariza[ isRegularizacion ];
      changeEventCall();
    end
  end;

  procedure TOpDivRecType14.setConceptoComplementa( const aString: string );
  var
    texto: string;
  begin
    texto := trim( aString );
    if FConceptoComplementa <> texto then
    begin
      FConceptoComplementa := texto;
      changeEventCall();
    end
  end;


  //***** otros métodos de soporte
  procedure TOpDivRecType14.initializeData;
  begin
    inherited;
    FRecType := '14' ;   // operación tipo 09
    FOpNat   := '1';     // en principio suponemos cobros
    FOpNatFixed := false; //
    FClaveAutorizaEsObligatoria := false;

    FIndicativoCUC := '0';
    FConceptoComplementa := EmptyStr;
  end;

  function TOpDivRecType14.getStringForCodeData: String;
  begin
    Result := inherited getStringForCodeData()
            + kCodeSeparator + FIndicativoCUC
            + kCodeSeparator + FConceptoComplementa
            + kCodeSeparator ;
  end;

(*********
 MÉTODOS PÚBLICOS
 *********)

  procedure TOpDivRecType14.setData( aStringList: TStrings );
  begin
    inherited setData( aStringList );

    if testIndexOf( aStringList, k14_IndicativoCUCItem ) then FIndicativoCUC := aStringList.Values[ k14_IndicativoCUCItem ];
    if testIndexOf( aStringList, k14_ConceptoComplementaItem ) then FConceptoComplementa := aStringList.Values[ k14_ConceptoComplementaItem ];
  end;

  //: devuelve los datos en forma de una StrinList <nombre>=<valor>
  procedure TOpDivRecType14.getData( aStringList: TStrings );
  begin
    inherited getData( aStringList );

    aStringList.Values[ k14_IndicativoCUCItem ] := FIndicativoCUC;
    aStringList.Values[ k14_ConceptoComplementaItem ]  := FConceptoComplementa;
  end;

  //:: se fuerza la comprobación de todos los datos
  procedure TOpDivRecType14.TestData;
  begin
    inherited;
  end;

  //:: devuelve el contenido del registro como si se tratara del registro del archivo final
  function TOpDivRecType14.getDataAsFileRecord: String;
  begin
    result := AddCharR( ' ', inherited getDataAsFileRecord()
            + FIndicativoCUC
            + AddCharR( ' ', FConceptoComplementa, 80 ), 352 );
  end;

// 07.05.02 - ahora se encargan dos métodos intermedios de imprimir la información específica del registro

  function TOpDivRecType14.printSpecificType: String;
  begin
    Result := 'TIPO: 14 - OTRAS OPERACIONES';
  end;

//  procedure TOpDivRecType14.getDataAsPrintedRecord(anStrList: TStringList);
  procedure TOpDivRecType14.printSpecificData( aDataString: TStringList );
  var
    lnPtr: String;
    anStrList: TStringList;  // alias del parámetro de entrada para evitar cambiar el código ya escrito
  begin
    anStrList := aDataString;

//    anStrList.Add('TIPO: 14 - OTRAS OPERACIONES');
//    anStrList.Add(MS('_', 90));
//    inherited getDataAsPrintedRecord(anStrList);

    anStrList.Add(EmptyStr);
 {
   -- 07.05.2002 : Ya no se admiten operaciones que provengan de una
                   "regularización de C.U.C.", por lo que se evita ya
                   cualquier referencia a las mismas. 
    // indicativo CUC
    lnPtr := 'INDICATIVO DE C.U.C.: ' + FIndicativoCUC + ' - ';
    if      FIndicativoCUC = '0' then
      lnPtr := lnPtr + 'NO CORRESPONDE A C.U.C.'
    else if FIndicativoCUC = '1' then
      lnPtr := lnPtr + 'REGULARIZACIÓN C.U.C.'
    else
      lnPtr := lnPtr + '?????';
    anStrList.Add(lnPtr);
 }
    // concepto complementario
    lnPtr := 'CONCEPTO COMPLEMENTARIO:';
    anStrList.Add(lnPtr);
    lnPtr := '  ' + Trim(FConceptoComplementa);
    anStrList.Add(lnPtr);
  end;

end.
