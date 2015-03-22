unit CSoporte;

interface

  uses
    SysUtils,
    classes,
    contnrs,
    COpDivSystemRecord;

  const
    kSopTipoItem    = 'TIPO';
    kSopFechaItem   = 'FECHA';
    kSopNumItem     = 'NUMSOPORTE';
    kSopEstacionItem = 'ESTACION';

  type
    TTipoSoporte = ( tsDocumental, tsNoDocumental );

    TSoporte = class( TObject )
      protected
        FTipo: TTipoSoporte;
        FFechaSoporte: TDateTime;
        FNumOrden: Integer;
        FStationID: String;
        FRegistrosAsociados: TObjectList;

        procedure setOwnsRecords( aValue: boolean );
        function  getOwnsRecords: Boolean;
        function  getImporte: Double;
        function  getNumRegistros: Integer;

      public
        property Tipo: TTipoSoporte read FTipo write FTipo;
        property FechaSoporte: TDateTime read FFechaSoporte write FFechaSoporte;
        property NumOrden: Integer read FNumOrden write FNumOrden;
        property Importe: Double read getImporte;
        property NumRegistros: Integer read getNumRegistros;
        property StationID: String read FStationID write FStationID;
        property OwnsRecordsPointers: boolean read getOwnsRecords write setOwnsRecords;

        constructor Create; virtual;
        destructor Destroy; override;

        procedure AddRegistro( unRegistro: TOpDivSystemRecord );
        procedure ClearRegistros;
        procedure getRegistros( aObjectList: TObjectList );
        procedure getRegistrosAsOIDS( aStrings: TStrings );
        procedure getRegistrosAsOIDSWithRef(aStrings: TStrings);

        function  getDesc: String;

        //*** utilidades auxiliares de conversion (funciones de clase)
        class function tipoToStr( unTipo: TTipoSoporte ): String;
        class function strToTipo( const unaString: String ): TTipoSoporte;
    end;

implementation

  uses
    rxStrUtils;

(************
  MÉTODOS PRIVADOS
 ************)

  procedure TSoporte.setOwnsRecords( aValue: Boolean );
  begin
    FRegistrosAsociados.OwnsObjects := aValue;
  end;

  function  TSoporte.getOwnsRecords: Boolean;
  begin
    Result := FRegistrosAsociados.OwnsObjects;
  end;

  function  TSoporte.getImporte: Double;
  var
    iRecord: Integer;
  begin
    Result := 0.0;
    for iRecord := 0 to FRegistrosAsociados.Count - 1 do
      Result := Result + TOpDivSystemRecord(FregistrosAsociados.Items[iRecord]).ImportePrinOp;
  end;

  function  TSoporte.getNumRegistros: Integer;
  begin
    Result := FRegistrosAsociados.Count;
  end;

  
(************
  MÉTODOS PÚBLICOS
 ************)

 constructor TSoporte.Create;
 begin
   inherited;
   FTipo         := tsDocumental ;
   FFechaSoporte := Now();
   FNumOrden     := 0;
   FRegistrosAsociados := TObjectList.Create();
   FRegistrosAsociados.OwnsObjects := false;
   FRegistrosAsociados.Clear();
 end;

 destructor TSoporte.Destroy();
 begin
   FRegistrosAsociados.Free();
   inherited;
 end;

 //***

 procedure TSoporte.AddRegistro( unRegistro: TOpDivSystemRecord );
 begin
   FRegistrosAsociados.Add( unRegistro );
 end;

 procedure TSoporte.ClearRegistros;
 begin
   FRegistrosAsociados.Clear();
 end;

 procedure TSoporte.getRegistrosAsOIDS( aStrings: TStrings );
 var
   iRegistro: Integer;
 begin
   aStrings.Clear();
   for iRegistro := 0 to FRegistrosAsociados.Count -1 do
     aStrings.Add( TOpDivSystemRecord( FRegistrosAsociados.Items[iRegistro] ).OID);
 end;

 procedure TSoporte.getRegistrosAsOIDSWithRef( aStrings: TStrings );
 var
   iRegistro: Integer;
 begin
   aStrings.Clear();
   for iRegistro := 0 to FRegistrosAsociados.Count -1 do
     aStrings.Add( TOpDivSystemRecord( FRegistrosAsociados.Items[iRegistro] ).OID + '=' + TOpDivSystemRecord( FRegistrosAsociados.Items[iRegistro] ).OpRef );
 end;

 procedure TSoporte.getRegistros( aObjectList: TObjectList );
 begin
   aObjectList.OwnsObjects := false;  // nunca le pertenecen
   aObjectList.Assign(FRegistrosAsociados);
 end;

 function TSoporte.getDesc: String;
 begin
   Result := formatDateTime('yyyymmdd', FFechaSoporte) + AddChar('0', intToStr(FNumOrden), 3); 
 end;


(************
  MÉTODOS DE CLASE
 ************)

  class function TSoporte.tipoToStr( unTipo: TTipoSoporte ): String;
  begin
    if unTipo = tsDocumental then Result := 'DOCUMENTAL'
    else Result := 'NO DOCUMENTAL';
  end;

  class function TSoporte.strToTipo( const unaString: String ): TTipoSoporte;
  begin
    if unaString = 'DOCUMENTAL' then Result := tsDocumental
    else Result := tsNoDocumental;
  end;

end.
