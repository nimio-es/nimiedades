unit CCustomDBMiddleEngine;

(*******************************************************************************
 * CLASE: TCustomDBMiddleEngine.                                               *
 * FECHA DE CREACIÓN: 30-07-2001                                               *
 * PROGRAMADOR: Saulo Alvarado Mateos (CINCA)                                  *
 * DESCRIPCIÓN:                                                                *
 *      La finalidad es la de crear un esqueleto reusable de un objeto que     *
 * permita mantener separados la representación interna de los objetos de el   *
 * soporte de almacenamiento de los mismos. Es una clase abstracta que deberá  *
 * ser redefinida por sus descendientes.                                       *
 *      Esta clase hace uso de la clase, también en este módulo,               *
 * TCustomRecordProxy.                                                         *
 *                                                                             *
 * FECHA MODIFICACIÓN:                                                         *
 * CAMBIOS (DESCRIPCIÓN):                                                      *
 *                                                                             *
 *******************************************************************************
 * CLASE: TCustomRecordProxy                                                   *
 * FECHA DE CREACIÓN: 30-07-2001                                               *
 * PROGRAMADOR: Saulo Alvarado Mateos (CINCA)                                  *
 * DESCRIPCIÓN:                                                                *
 *       Establece un intermediario para manejar los registros de forma común  *
 * para operaciones como la de selección, que luego será convertido al tipo    *
 * oportuno como si de una factoría se tratara.                                *
 *******************************************************************************)


interface

  uses
    classes,
    contnrs;  (* TObjectList *)

  type
    (*******
     DEFINICIÓN ANTICIPADA DE LAS CLASES PARA REFERENCIAS CRUZADAS
     *******)
    TCustomRecordProxy = class;
    TCustomSystemRecord = class;
    TCustomDBMiddleEngine = class;

    (*******
     DEFINICIÓN DETALLADA DE LAS CLASES E INTERFACES
     ******)

    TCustomSystemRecord = class( TObject )
      protected
        FOID: String;  // identificador único del registro

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
        // otros métodos públicos
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

  (**** MÉTODOS PÚBLICOS ****)
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
