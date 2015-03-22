unit COpDivRecType04;

(*******************************************************************************
 * CLASE: TOpDivRecType04                                                      *
 * FECHA CREACION: 25-09-2001                                                  *
 * PROGRAMADOR: Saulo Alvarado Mateos                                          *
 * DESCRIPCIÓN:                                                                *
 *                                                                             *
 *       Implementación del registro tipo 04 - Regularización de operaciones   *
 * de Sistema de intercambio. Carácter no documental.                          *
 *       Al tratarse del tipo 03 pero sin ser documental, símplemente se han   *
 * sobreescrito algunos métodos, reusando todo lo codificado en el tipo 03     *
 *******************************************************************************)

interface
  uses
    classes,
    CCustomDBMiddleEngine,
    COpDivSystemRecord,
    COpDivRecType03 ;

  type
    TOpDivRecType04 = class( TOpDivRecType03 )
      protected

        //:: otros métodos de soporte
        procedure initializeData; override;

        //:: procedimientos de validación
        procedure ValidaConceptoComplementa; virtual;

        //:: otros
        function  getTipoForPrinted: String; override;


      public
        procedure TestData; override;

        class function isDocumentable: boolean; override;
    end;

implementation

  uses
    CCriptografiaCutre,
    CQueryEngine,
    SysUtils,
    rxStrUtils;


  //***** otros métodos de soporte
  procedure TOpDivRecType04.initializeData;
  begin
    inherited;
    FRecType := '04' ;  // símplemente hay que cambiar el tipo señalado en el tipo 03, el resto será igual
  end;

  procedure TOpDivRecType04.ValidaConceptoComplementa;
  begin
    if Trim(FConceptoComplementa) = EmptyStr then
      if FConceptoOp = '1' then
        raise Exception.Create('Se debe indicar el Concepto complementario para este tipo de operación.');
  end;

  function  TOpDivRecType04.getTipoForPrinted: String;
  begin
    Result := '04 - REGULARIZACIÓN DE OPS. DE SISTEMAS DE INTERCAMBIO. CARÁCTER NO DOCUMENTAL.';
  end;


  //*****************
  // MÉTODOS PÚBLICOS
  //*****************

  procedure TOpDivRecType04.TestData;
  begin
    inherited;
    ValidaConceptoComplementa();
  end;

  class function TOpDivRecType04.isDocumentable: boolean;
  begin
    result := false;
  end;

end.
