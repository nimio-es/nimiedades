unit VOpenRecord;

(*******************************************************************************
 * CLASE: TOpenRecord.                                                         *
 * FECHA DE CREACIÓN: 07-2001                                                  *
 * PROGRAMADOR: Saulo Alvarado Mateos (CINCA)                                  *
 * DESCRIPCIÓN:                                                                *
 *      Formulario (Vista) y Agente (Controlador) en una misma clase. Su fina- *
 * lidad es la de mostrar los registros que actualmente se encuentran como     *
 * archivos en el directorio de trabajo y manipular la vista de los mismos,    *
 * mostrando dicha información ordenado de una u otra forma.                   *
 *                                                                             *
 * FECHA DE MODIFICACIÓN: 13-05-2002                                           *
 * PROGRAMADOR: Saulo Alvarado Mateos (CINCA)                                  *
 * DESCRIPCIÓN:                                                                *
 *      Se debe tener en cuenta ahora, en el momento de crear el formulario,   *
 * que puede existir una Excepción de bloqueo general. Como se ha programado   *
 * como un formulario Delphi (que yo permite excepciones en el constructor     *
 * con el fin de no obtener resultados extraños), se intercepta la excepción   *
 * y se muestra la lista de registros completamente vacía.                     *
 *                                                                             *
 *******************************************************************************)


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Grids, StdCtrls, ComCtrls, contnrs, CDBMiddleEngine;

type
  TOpenRecord = class(TForm)
    panelBotones: TPanel;
    btnAceptar: TButton;
    btnCancelar: TButton;
    RecordsListView: TListView;
    panelFiltro: TPanel;
    mostrarVinculadosCheckBox: TCheckBox;
    panelBloqueo: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnAceptarClick(Sender: TObject);
    procedure RecordsListViewCompare(Sender: TObject; Item1,
      Item2: TListItem; Data: Integer; var Compare: Integer);
    procedure RecordsListViewColumnClick(Sender: TObject;
      Column: TListColumn);
    procedure mostrarVinculadosCheckBoxClick(Sender: TObject);
  private
    FRecordList: TObjectList;
    FMostrarVinculados: Boolean;
    FKindOfSort: Integer;

    procedure ShowLista;
       // -- muestra la lista de registros encontrados

  public
    RecordSelected: TOpDivRecordProxy;
    function Execute(couldListAsoc:Boolean): Boolean;
  end;

var
  OpenRecord: TOpenRecord;

implementation

{$R *.DFM}

  // *** métodos privados
  procedure TOpenRecord.ShowLista;
  var
    iCount: integer;
    newItem: TListItem;
  begin
    // eliminamos cualquier referencia al tipo de orden
    RecordsListView.SortType := stNone;
    // vaciamos la lista anteriores (si la hubiere)
    RecordsListView.Clear();
    // rellenamos la lista
    for iCount := 0 to FRecordList.Count-1 do
    begin
      if FMostrarVinculados
           or ( not FMostrarVinculados and not TOpDivRecordProxy( FRecordList.Items[ iCount ] ).isAssignedToSoporte()) then
      begin
        newItem := RecordsListView.Items.Add() ;
        newItem.Caption := TOpDivRecordProxy( FRecordList.Items[ iCount ] ).StationID ;
        newItem.Data := FRecordList.Items[ iCount ];
        newItem.SubItems.Add( TOpDivRecordProxy( FRecordList.Items[ iCount ] ).OID );
        newItem.SubItems.Add( dateTimeToStr( TOpDivRecordProxy( FRecordList.Items[ iCount ] ).FechaHora ) );
        newItem.SubItems.Add( TOpDivRecordProxy( FRecordList.Items[ iCount ] ).TipoReg );
        newItem.SubItems.Add( TOpDivRecordProxy( FRecordList.Items[ iCount ] ).NatOp );
        newItem.SubItems.Add( TOpDivRecordProxy( FRecordList.Items[ iCount ] ).EntOfiDest );
        newItem.SubItems.Add( FloatToStrF(TOpDivRecordProxy( FRecordList.Items[ iCount ] ).ImportePrinOp, ffNumber, 12, 2) + ' €');
        newItem.SubItems.Add( TOpDivRecordProxy( FRecordList.Items[ iCount ] ).DivisaOp );
        newItem.SubItems.Add( TOpDivRecordProxy( FRecordList.Items[ iCount ] ).IncluirSop );
        newItem.SubItems.Add( TOpDivRecordProxy( FRecordList.Items[ iCount ] ).Descripcion );
      end;
    end;
    // obligamos a que se ordene...
    if FKindOfSort = 0 then
      RecordsListView.SortType := stNone
    else
      RecordsListView.SortType := stData;
    // se selecciona automáticamente el primero
    if FRecordList.Count > 0 then
    begin
      RecordsListView.Selected := RecordsListView.Items[0];
    end
  end;

  // *** métodos públicos

  function TOpenRecord.Execute(couldListAsoc:Boolean): boolean;
  begin
    if not couldListAsoc then
    begin
      panelFiltro.Align := alNone;
      panelFiltro.Hide();
    end;
    result := ( Self.ShowModal = mrYes );
  end;  // -- Execute

// 13.05.02 - se reescribe el método para adaptarlo a las necesidades de la
//            nueva excepción creada con el fin de indicar que se van a mover
//            los registros.
procedure TOpenRecord.FormCreate(Sender: TObject);
begin
  try
    try
      FRecordList := TheDBMiddleEngine.getListOfRecords();
    except
      on EDBMiddleGeneralRecorsLockException do
      begin
        // se crea una lista de registros vacía para evitar errores en el manejo de los datos
        FRecordList := TObjectList.Create();
        // además, para rematar la faena, se muestra el panel de bloqueos, muy llamativo
        panelBloqueo.Visible := TRUE;
        Raise;  // y se vuelve a lanzar la excepción
      end;
    end;
  finally
    FMostrarVinculados := FALSE;  // no se quieren ver los que ya han sido vinculados a un soporte
    FKindOfSort := 0;  // por defecto vía texto
    showLista();
  end;
end;

procedure TOpenRecord.FormDestroy(Sender: TObject);
begin
  FRecordList.Free;
end;

procedure TOpenRecord.btnAceptarClick(Sender: TObject);
begin
  RecordSelected := TOpDivRecordProxy( Self.RecordsListView.Selected.Data );
  ModalResult := mrYes ;
end;

procedure TOpenRecord.RecordsListViewCompare(Sender: TObject; Item1,
  Item2: TListItem; Data: Integer; var Compare: Integer);

  function generalTextCompare(const text1, text2: String): Integer;
  begin
    Result := 0;
    if UpperCase(text1) < UpperCase(text2) then
      Result := -1
    else if UpperCase(text1) > UpperCase(text2) then
      Result := 1;
  end;

  function generalDateCompare(date1, date2: TDateTime): Integer;
  begin
    Result := 0;
    if date1 < date2 then
      Result := -1
    else if date1 > date2 then
      Result := 1
  end;

  function generalDoubleCompare(double1, double2: Double): Integer;
  begin
    Result := 0;
    if double1 < double2 then
      Result := -1
    else if double1 > double2 then
      Result := 1
  end;

begin
  Compare := 0;  // en principio son exáctamente iguales
  if FKindOfSort <> 0 then
  begin
    case Abs(FKindOfSort) of
      1: Compare := generalTextCompare(TOpDivRecordProxy(Item1.Data).OID, TOpDivRecordProxy(Item2.Data).OID);
      2: Compare := generalDateCompare(TOpDivRecordProxy(Item1.Data).FechaHora, TOpDivRecordProxy(Item2.Data).FechaHora);
      3: Compare := generalTextCompare(TOpDivRecordProxy(Item1.Data).TipoReg, TOpDivRecordProxy(Item2.Data).TipoReg);
      4: Compare := generalTextCompare(TOpDivRecordProxy(Item1.Data).NatOp, TOpDivRecordProxy(Item2.Data).NatOp);
      5: Compare := generalTextCompare(TOpDivRecordProxy(Item1.Data).EntOfiDest, TOpDivRecordProxy(Item2.Data).EntOfiDest);
      6: Compare := generalDoubleCompare(TOpDivRecordProxy(Item1.Data).ImportePrinOp, TOpDivRecordProxy(Item2.Data).ImportePrinOp);
      7: Compare := generalTextCompare(TOpDivRecordProxy(Item1.Data).DivisaOp, TOpDivRecordProxy(Item2.Data).DivisaOp);
      8: Compare := generalTextCompare(TOpDivRecordProxy(Item1.Data).IncluirSop, TOpDivRecordProxy(Item2.Data).IncluirSop);
      9: Compare := generalTextCompare(TOpDivRecordProxy(Item1.Data).Descripcion, TOpDivRecordProxy(Item2.Data).Descripcion);
    end;

    // se multiplica por el signo de la operación de ordenación para hacerlos ascendente o descendente
    Compare := Compare * (FKindOfSort div Abs(FKindOfSort));  
  end
end;

procedure TOpenRecord.RecordsListViewColumnClick(Sender: TObject;
  Column: TListColumn);
var
  nextKindOfSort: Integer;
begin
  nextKindOfSort := Column.Index;
  if Abs(FKindOfSort) = nextKindOfSort then
    FKindOfSort := -FKindOfSort  // se invierte el orden
  else
    FKindOfSort := nextKindOfSort;

  TListView(Sender).SortType := stNone;
  if FKindOfSort = 0 then
    TListView(Sender).SortType := stText
  else
    TListView(Sender).SortType := stData;
end;

procedure TOpenRecord.mostrarVinculadosCheckBoxClick(Sender: TObject);
begin
  FMostrarVinculados := TCheckBox(Sender).Checked;
  ShowLista();
end;

end.
