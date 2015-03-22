unit COpDivRecType08;

(*******************************************************************************
 * CLASE: TOpDivRecType07                                                      *
 * FECHA CREACION: 08-08-2001                                                  *
 * PROGRAMADOR: Saulo Alvarado Mateos                                          *
 * DESCRIPCI�N:                                                                *
 *       Implementaci�n del registro tipo 08 - Cesiones de efectivo            *
 *  Este formato no a�ade nada al objeto base, salvo que la clave de autoriza- *
 *  ci�n es obligatoria.                                                       *
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
    CCustomDBMiddleEngine,
    COpDivSystemRecord ;

  type
    TOpDivRecType08 = class( TOpDivSystemRecord )

      protected
        // :::: m�todos de validaci�n
        procedure testImportePrinOp; override;

        //:: otros m�todos de soporte
        procedure initializeData; override;
        function  getStringForCodeData: String; override;

        // 07.05.02
        function  printSpecificType: String; override;
        procedure printSpecificData( aDataString: TStringList ); override;

      public
        //** m�todos heredados (algunos de los cuales hay que redefinir )
        procedure setData( aStringList: TStrings ); override;
        procedure getData( aStringList: TStrings ); override;
        procedure TestData; override;
        function getDataAsFileRecord: String; override;
// 07.05.02 - ahora se encargand dos m�todos intermediarios de imprimir los datos espec�ficos del registro
//        procedure getDataAsPrintedRecord(anStrList: TStringList); override;

        class function isDocumentable: boolean; override;
    end;

implementation

  uses
    CCriptografiaCutre,
    SysUtils,
    rxStrUtils;

(*********
 M�TODOS PRIVADOS
 *********)

  procedure TOpDivRecType08.testImportePrinOp;
  begin
    inherited;
    if FImportePrinOp > 30000 then
      raise Exception.Create('La operaci�n no soporta importes superiores a 30.000 �.');
  end;

  //***** otros m�todos de soporte
  procedure TOpDivRecType08.initializeData;
  begin
    inherited;
    FRecType := '08' ;   // operaci�n tipo 08
    FOpNat   := '1';     // siempre se trata de cobros
    FOpNatFixed := true; //
    FClaveAutorizaEsObligatoria := true;
  end;

  function TOpDivRecType08.getStringForCodeData: String;
  begin
    Result := inherited getStringForCodeData() + kCodeSeparator ;
  end;

(*********
 M�TODOS P�BLICOS
 *********)

  procedure TOpDivRecType08.setData( aStringList: TStrings );
  begin
    inherited setData( aStringList );
  end;

  //: devuelve los datos en forma de una StrinList <nombre>=<valor>
  procedure TOpDivRecType08.getData( aStringList: TStrings );
  begin
    inherited getData( aStringList );
  end;

  //:: se fuerza la comprobaci�n de todos los datos
  procedure TOpDivRecType08.TestData;
  begin
    inherited;
  end;

  //:: devuelve el contenido del registro como si se tratara del registro del archivo final
  function TOpDivRecType08.getDataAsFileRecord: String;
  begin
    result := AddCharR( ' ', inherited getDataAsFileRecord(), 352 );
  end;

// 07.05.02 - ahora se encargand dos m�todos intermediarios de imprimir los datos espec�ficos del registro

  function TOpDivRecType08.printSpecificType: String;
  begin
    Result := 'TIPO: 08 - CESIONES DE EFECTIVO.';
  end;

//  procedure TOpDivRecType08.getDataAsPrintedRecord(anStrList: TStringList);
  procedure TOpDivRecType08.printSpecificData( aDataString: TStringList );
  begin
//    anStrList.Add('TIPO: 08 - CESIONES DE EFECTIVO.');
//    anStrList.Add(MS('_',90));
//    inherited getDataAsPrintedRecord(anStrList);
  end;


  class function TOpDivRecType08.isDocumentable: boolean;
  begin
    result := false;
  end;

end.
