unit VSearchRecAux;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, ValEdit, StdCtrls, ExtCtrls, ComCtrls;

type
  TSearchRecAuxForm = class(TForm)
    Panel1: TPanel;
    AceptarBtn: TButton;
    CancelarBtn: TButton;
    ElementsListView: TListView;
    Label1: TLabel;
    buscarEdit: TEdit;
    procedure ElementsListViewSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure buscarEditChange(Sender: TObject);
    procedure ElementsListViewColumnClick(Sender: TObject;
      Column: TListColumn);
    procedure ElementsListViewCompare(Sender: TObject; Item1,
      Item2: TListItem; Data: Integer; var Compare: Integer);
    procedure AceptarBtnClick(Sender: TObject);
  private
    FComparationIndex: Integer;
    FValorSeleccionado: String;
  public
    procedure showElements(anElementsList: TStringList);
    function  getSelectedValue: String;
  end;

var
  SearchRecAuxForm: TSearchRecAuxForm;

implementation

{$R *.dfm}


(****************
 MÉTODOS PÚBLICOS
 ****************)

 procedure TSearchRecAuxForm.showElements(anElementsList: TStringList);
 var
   numElement: Integer;
   auxName: String;
   newListItem: TListItem;
 begin
   ElementsListView.Clear();
   for numElement := 0 to anElementsList.Count - 1 do
   begin
     auxName := anElementsList.Names[numElement];
     //
     newListItem := ElementsListView.Items.Add();
     newListItem.Caption := auxName;
     newListItem.SubItems.Add(anElementsList.Values[auxName]);
   end
 end;

 function TSearchRecAuxForm.getSelectedValue: String;
 begin
   Result := FValorSeleccionado;
 end;

procedure TSearchRecAuxForm.ElementsListViewSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
  AceptarBtn.Enabled := (Item <> nil);
end;

procedure TSearchRecAuxForm.buscarEditChange(Sender: TObject);
var
  numItem: Integer;
  textToSearch: String;
  saltoScroll: Integer;
begin
  textToSearch := UpperCase(Trim(TEdit(Sender).Text));
  if textToSearch <> EmptyStr then
  begin
    for numItem := 0 to ElementsListView.Items.Count - 1 do
      if ( Pos(textToSearch, UpperCase(ElementsListView.Items[numItem].Caption) ) > 0 )
            or ( Pos(textToSearch, UpperCase(ElementsListView.Items[numItem].SubItems.Strings[0]) ) > 0 ) then
      begin
        ElementsListView.ItemFocused := ElementsListView.Items[numItem];
        ElementsListView.ItemIndex   := numItem;
        ElementsListView.Selected    := ElementsListView.Items[numItem];
        saltoScroll := ElementsListView.ItemFocused.Top - 20;
        ElementsListView.Scroll(0,saltoScroll);
        break;
      end
  end;
end;

procedure TSearchRecAuxForm.ElementsListViewColumnClick(Sender: TObject;
  Column: TListColumn);
begin
  FComparationIndex := Column.Index;
  TListView(Sender).SortType := stBoth;
end;

procedure TSearchRecAuxForm.ElementsListViewCompare(Sender: TObject; Item1,
  Item2: TListItem; Data: Integer; var Compare: Integer);
begin
  Compare := 0;  // en principio son iguales
  if FComparationIndex = 0 then
  begin
    if UpperCase(Item1.Caption) < UpperCase(Item2.Caption) then
      Compare := -1
    else if UpperCase(Item1.Caption) > UpperCase(Item2.Caption) then
      Compare := 1
  end
  else
  begin
    if UpperCase(Item1.SubItems.Strings[0]) < UpperCase(Item2.SubItems.Strings[0]) then
      Compare := -1
    else if UpperCase(Item1.SubItems.Strings[0]) > UpperCase(Item2.SubItems.Strings[0]) then
      Compare := 1
  end
end;

procedure TSearchRecAuxForm.AceptarBtnClick(Sender: TObject);
begin
  FValorSeleccionado := EmptyStr;
  if ElementsListView.Selected <> nil then
    FValorSeleccionado := ElementsListView.Selected.Caption;
  ModalResult := mrOK;
end;

end.
