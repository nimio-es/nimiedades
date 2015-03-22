unit COpDivRecType04;

(*******************************************************************************
 * CLASE: TOpDivRecType04                                                      *
 * FECHA CREACION: 25-09-2001                                                  *
 * PROGRAMADOR: Saulo Alvarado Mateos                                          *
 * DESCRIPCI�N:                                                                *
 *                                                                             *
 *       Implementaci�n del registro tipo 04 - Regularizaci�n de operaciones   *
 * de Sistema de intercambio. Car�cter no documental.                          *
 *       Al tratarse del tipo 03 pero sin ser documental, s�mplemente se han   *
 * sobreescrito algunos m�todos, reusando todo lo codificado en el tipo 03     *
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

        //:: otros m�todos de soporte
        procedure initializeData; override;

        //:: procedimientos de validaci�n
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


  //***** otros m�todos de soporte
  procedure TOpDivRecType04.initializeData;
  begin
    inherited;
    FRecType := '04' ;  // s�mplemente hay que cambiar el tipo se�alado en el tipo 03, el resto ser� igual
  end;

  procedure TOpDivRecType04.ValidaConceptoComplementa;
  begin
    if Trim(FConceptoComplementa) = EmptyStr then
      if FConceptoOp = '1' then
        raise Exception.Create('Se debe indicar el Concepto complementario para este tipo de operaci�n.');
  end;

  function  TOpDivRecType04.getTipoForPrinted: String;
  begin
    Result := '04 - REGULARIZACI�N DE OPS. DE SISTEMAS DE INTERCAMBIO. CAR�CTER NO DOCUMENTAL.';
  end;


  //*****************
  // M�TODOS P�BLICOS
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
