unit CCustomDBMiddleEngine;

(*******************************************************************************
 * CLASE: TCustomDBMiddleEngine.                                               *
 * FECHA DE CREACI�N: 30-07-2001                                               *
 * PROGRAMADOR: Saulo Alvarado Mateos (CINCA)                                  *
 * DESCRIPCI�N:                                                                *
 *      La finalidad es la de crear un esqueleto reusable de un objeto que     *
 * permita mantener separados la representaci�n interna de los objetos de el   *
 * soporte de almacenamiento de los mismos. Es una clase abstracta que deber�  *
 * ser redefinida por sus descendientes.                                       *
 *      Esta clase hace uso de la clase, tambi�n en este m�dulo,               *
 * TCustomRecordProxy.                                                         *
 *                                                                             *
 * FECHA MODIFICACI�N:                                                         *
 * CAMBIOS (DESCRIPCI�N):                                                      *
 *                                                                             *
 *******************************************************************************
 * CLASE: TCustomRecordProxy                                                   *
 * FECHA DE CREACI�N: 30-07-2001                                               *
 * PROGRAMADOR: Saulo Alvarado Mateos (CINCA)                                  *
 * DESCRIPCI�N:                                                                *
 *       Establece un intermediario para manejar los registros de forma com�n  *
 * para operaciones como la de selecci�n, que luego ser� convertido al tipo    *
 * oportuno como si de una factor�a se tratara.                                *
 *******************************************************************************)


interface

  uses
    classes,
    contnrs;  (* TObjectList *)

  type
    (*******
     DEFINICI�N ANTICIPADA DE LAS CLASES PARA REFERENCIAS CRUZADAS
     *******)
    TCustomRecordProxy = class;
    TCustomSystemRecord = class;
    TCustomDBMiddleEngine = class;

    (*******
     DEFINICI�N DETALLADA DE LAS CLASES E INTERFACES
     ******)

    TCustomSystemRecord = class( TObject )
      protected
        FOID: String;  // identificador �nico del registro

      public
        // propiedades:
        property OID: String read FOID;

        constructor Create; overload; virtual;
        constructor Create( aProxy: TCustomRecordProxy ); overload; virtual; abstract; 

        procedure getData( aStringList: TStrings ); virtual; abstract;
        procedure setData( aStringList: TStrings ); virtual; abstract;        
    end; // -- TCustomSystemRecord

    // ::
    TCustomRecordProxy = class( TObject )
      protected
        FData: TStringList;
      public
        // constructores y destructores
        constructor Create; virtual;
        constructor CreateWithData( aStrings: TStrings ); virtual;
        destructor Destroy; override;
        // otros m�todos p�blicos
        procedure getData( aStringList: TStrings ); virtual;
    end; // -- TCustomRecordProxy

    // ::
    TCustomDBMiddleEngine = class( TObject )
      public
        constructor Create; virtual; abstract;

        function getListOfRecords: TObjectList ; virtual; abstract;
        function readRecord( aRecProxy: TCustomRecordProxy ): TCustomSystemRecord; virtual; abstract;
        procedure writeRecord( aSystemRecord: TCustomSystemRecord ); virtual; abstract;
        procedure deleteRecord( aRecProxy: TCustomRecordProxy ); virtual; abstract;
//        function getRecFromProxy( aRecordProxy: TCustomRecordProxy ): TCustomSystemRecord; virtual; abstract;
    end; // -- TCustomDBMiddleEngine

//************
implementation
//************

(***************************************************)
(*************** TCustomRecordProxy ****************)
(***************************************************)

  (**** CONSTRUCTORES Y DESTRUCTORES ****)
  constructor TCustomRecordProxy.Create;
  begin
    inherited;
    FData := TStringList.Create;
  end;  // -- TCustomRecordProxy.Create;

  constructor TCustomRecordProxy.CreateWithData( aStrings: TStrings );
  begin
    self.Create();
    FData.Assign( aStrings );
  end;

  destructor TCustomRecordProxy.Destroy;
  begin
    FData.Free;
    inherited;
  end;   // -- TCustomRecordProxy.Destroy

  (**** M�TODOS P�BLICOS ****)
  procedure TCustomRecordProxy.getData( aStringList: TStrings );
  begin
    aStringList.Assign( FData );
  end;   // -- TCustomRecordProxy.getDate(...)

(***************************************************)
(*************** TCustomSystemRecord ***************)
(***************************************************)

  (**** CONSTRUCTORES Y DESTRUCTORES ****)
  constructor TCustomSystemRecord.Create;
  begin
    inherited;
  end;

end.
