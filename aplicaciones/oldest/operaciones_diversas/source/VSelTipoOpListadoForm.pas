unit VSelTipoOpListadoForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CheckLst;

type
  TSelTipoOpListadoForm = class(TForm)
    separarTerminalesCheckBox: TCheckBox;
    indicarSoporteEnvioCheckBox: TCheckBox;
    incluirSoloTiposCheckBox: TCheckBox;
    tiposAIncluirCheckListBox: TCheckListBox;
    emitirResumenCheckBox: TCheckBox;
    saltoPaginaCheckBox: TCheckBox;
    AceptarBtn: TButton;
    CancelarBtn: TButton;
    separarDiasCheckBox: TCheckBox;
    separarTiposCheckBox: TCheckBox;
    separarPorSoporteCheckBox: TCheckBox;
    anadirDatosEspecificosOpCheckBox: TCheckBox;
    LabelCabecera: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure incluirSoloTiposCheckBoxClick(Sender: TObject);
    procedure indicarSoporteEnvioCheckBoxClick(Sender: TObject);
    procedure separarTiposCheckBoxClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SelTipoOpListadoForm: TSelTipoOpListadoForm;

implementation

{$R *.dfm}

procedure TSelTipoOpListadoForm.FormCreate(Sender: TObject);
var
  numItem: Integer;
begin
  for numItem := 0 to tiposAIncluirCheckListBox.Count - 1 do
    tiposAIncluirCheckListBox.Checked[numItem] := true;
end;

procedure TSelTipoOpListadoForm.incluirSoloTiposCheckBoxClick(
  Sender: TObject);
begin
  tiposAIncluirCheckListBox.Enabled := TCheckBox(Sender).Checked; 
end;

procedure TSelTipoOpListadoForm.indicarSoporteEnvioCheckBoxClick(
  Sender: TObject);
begin
  if not TCheckBox(Sender).Checked then
  begin
    separarPorSoporteCheckBox.Checked := FALSE;
    separarPorSoporteCheckBox.Enabled := FALSE;
  end
  else
    separarPorSoporteCheckBox.Enabled := TRUE;
end;

procedure TSelTipoOpListadoForm.separarTiposCheckBoxClick(Sender: TObject);
begin
  if not TCheckBox(Sender).Checked then
  begin
    anadirDatosEspecificosOpCheckBox.Checked := FALSE;
    anadirDatosEspecificosOpCheckBox.Enabled := FALSE;
  end
  else
    anadirDatosEspecificosOpCheckBox.Enabled := TRUE;
end;

end.
