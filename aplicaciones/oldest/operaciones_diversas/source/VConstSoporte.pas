unit VConstSoporte;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls;

type
  TConstSoporteForm = class(TForm)
    Label1: TLabel;
    FechaSoporteEdit: TEdit;
    disponiblesListView: TListView;
    Panel1: TPanel;
    documentalRadioButton: TRadioButton;
    NoDocumentalRadioButton: TRadioButton;
    Panel2: TPanel;
    vinculadosListView: TListView;
    addButton: TButton;
    addAllButton: TButton;
    delButton: TButton;
    delAllButton: TButton;
    CancelarButton: TButton;
    aceptarButton: TButton;
    IncluirPendientesCheckBox: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure documentalRadioButtonClick(Sender: TObject);
    procedure disponiblesListViewSelectItem(Sender: TObject;
      Item: TListItem; Selected: Boolean);
    procedure vinculadosListViewSelectItem(Sender: TObject;
      Item: TListItem; Selected: Boolean);
  private
    FOnChangeNat: TNotifyEvent;
  public
    property OnChangeNat: TNotifyEvent read FOnChangeNat write FOnChangeNat;
  end;

var
  ConstSoporteForm: TConstSoporteForm;

implementation

{$R *.dfm}

procedure TConstSoporteForm.FormCreate(Sender: TObject);
begin
  FOnChangeNat := nil;
end;

procedure TConstSoporteForm.documentalRadioButtonClick(Sender: TObject);
begin
  if assigned( FOnChangeNat ) then FOnChangeNat( Self );
end;

procedure TConstSoporteForm.disponiblesListViewSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
  addButton.Enabled := Selected;
end;

procedure TConstSoporteForm.vinculadosListViewSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
  delButton.Enabled := Selected;
end;

end.
