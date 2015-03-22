unit VOpDivRecType09Form;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  VCustomRecordForm, StdCtrls, ExtCtrls, ToolEdit, CurrEdit, Mask,
  COpDivSystemRecord, COpDivRecType09, Menus, Buttons;

type
  TOpDivRecType09Form = class(TCustomRecordForm)
    Label3: TLabel;
    fechaContratacionEdit: TDateEdit;
    Label4: TLabel;
    importeDivisaEdit: TRxCalcEdit;
    Label6: TLabel;
    divisaEdit: TEdit;
    Label7: TLabel;
    tipoCambioEdit: TRxCalcEdit;
    calcularImporteOp: TButton;
    Label1: TLabel;
    procedure fechaContratacionEditExit(Sender: TObject);
    procedure divisaEditExit(Sender: TObject);
    procedure importeDivisaEditExit(Sender: TObject);
    procedure tipoCambioEditExit(Sender: TObject);
    procedure disponibleMemoExit(Sender: TObject);
    procedure calcularImporteOpClick(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure onGeneralChange( SystemRecord: TOpDivSystemRecord ); override;
  public
    { Public declarations }
  end;

var
  OpDivRecType09Form: TOpDivRecType09Form;

implementation

{$R *.DFM}

(*************
 MÉTODOS PROTEGIDOS
 *************)

  procedure TOpDivRecType09Form.onGeneralChange( SystemRecord: TOpDivSystemRecord );
  begin
    inherited;

    with TOpDivRecType09( SystemRecord ) do
    begin
      fechaContratacionEdit.Date := FechaContratacion;
      divisaEdit.Text             := CodigoDivisa;
      importeDivisaEdit.Value    := ImporteDivisa;
      tipoCambioEdit.Value       := TipoCambio;
//      disponibleMemo.Text        := Disponible;
    end;
  end;

  
(*************
 EVENTOS
 *************)

procedure TOpDivRecType09Form.fechaContratacionEditExit(Sender: TObject);
begin
  inherited;
  TOpDivRecType09( FSystemRecord ).FechaContratacion := TDateEdit( Sender ).Date;
end;

procedure TOpDivRecType09Form.divisaEditExit(Sender: TObject);
begin
  inherited;
  TOpDivRecType09( FSystemRecord ).CodigoDivisa := TEdit( Sender ).Text;
end;

procedure TOpDivRecType09Form.importeDivisaEditExit(Sender: TObject);
begin
  inherited;
  TOpDivRecType09( FSystemRecord ).ImporteDivisa := TRxCalcEdit( Sender ).Value;
end;

procedure TOpDivRecType09Form.tipoCambioEditExit(Sender: TObject);
begin
  inherited;
  TOpDivRecType09( FSystemRecord ).TipoCambio := TRxCalcEdit( Sender ).Value
end;

procedure TOpDivRecType09Form.disponibleMemoExit(Sender: TObject);
begin
  inherited;
  TMemo( Sender ).Text := upperCase( TMemo( Sender ).Text );
  TOpDivRecType09( FSystemRecord ).Disponible := TMemo( Sender ).Text;
end;

procedure TOpDivRecType09Form.calcularImporteOpClick(Sender: TObject);
begin
  inherited;

  with TOpDivRecType09(FSystemRecord) do
  begin
    if TipoCambio = 0.0 then
      Application.MessageBox('Debe indicar un importe superior a 0 en el Tipo de Cambio antes de poder calcular la operación.'
            , 'Error')
    else
      if DivisaOperacion = kDivisaPta then
      begin
        ExternalImporteSet := true;
        ImportePrinOp    := Round((ImporteDivisa / TipoCambio) * 100.0) / 100.0;
        ImporteOperacion := Round((ImporteDivisa / TipoCambio) * 166.386);
        ExternalImporteSet := false;
      end
      else
        ImporteOperacion := Round((ImporteDivisa / TipoCambio) * 100.0) / 100.0;
  end;
end;

end.

