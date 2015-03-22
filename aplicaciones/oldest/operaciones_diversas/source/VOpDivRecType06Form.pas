unit VOpDivRecType06Form;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  VCustomRecordForm, StdCtrls, ExtCtrls, ToolEdit, CurrEdit, Mask, ComCtrls,
  COpDivSystemRecord, COpDivRecType06, Menus, Buttons;

type
  TOpDivRecType06Form = class(TCustomRecordForm)
    Label6: TLabel;
    tipoOpEdit: TMaskEdit;
    Label7: TLabel;
    Label8: TLabel;
    refOrdenanteEdit: TEdit;
    Label9: TLabel;
    numCreditoEdit: TEdit;
    Label10: TLabel;
    Label11: TLabel;
    entidadEmisoraEdit: TEdit;
    clienteEmisorEdit: TEdit;
    Label13: TLabel;
    clienteBeneficiarioEdit: TEdit;
    ImporteCreditoLabel: TLabel;
    importeCreditoEdit: TRxCalcEdit;
    divisaCreditoEdit: TMaskEdit;
    Label16: TLabel;
    comisionesEdit: TRxCalcEdit;
    Label17: TLabel;
    gastosEdit: TRxCalcEdit;
    Label18: TLabel;
    disponibleEdit: TEdit;
    Label19: TLabel;
    Label1: TLabel;
    fechaOpEdit: TDateEdit;
    procedure tipoOpEditExit(Sender: TObject);
    procedure divisaCreditoEditExit(Sender: TObject);
    procedure importeCreditoEditExit(Sender: TObject);
    procedure comisionesEditExit(Sender: TObject);
    procedure fechaOpEditExit(Sender: TObject);
    procedure refOrdenanteEditExit(Sender: TObject);
    procedure numCreditoEditExit(Sender: TObject);
    procedure entidadEmisoraEditExit(Sender: TObject);
    procedure clienteEmisorEditExit(Sender: TObject);
    procedure clienteBeneficiarioEditChange(Sender: TObject);
    procedure disponibleEditChange(Sender: TObject);
    procedure gastosEditExit(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure onGeneralChange( SystemRecord: TOpDivSystemRecord ); override;
  public
    { Public declarations }
  end;

var
  OpDivRecType06Form: TOpDivRecType06Form;

implementation

{$R *.DFM}

(*************
 MÉTODOS PROTEGIDOS
 *************)

  procedure TOpDivRecType06Form.onGeneralChange( SystemRecord: TOpDivSystemRecord );
  begin
    inherited;

    with TOpDivRecType06( SystemRecord ) do
    begin
      divisaCreditoEdit.Text        := trim( DivisaCredito );
      importeCreditoEdit.Value       := ImporteCredito;
      tipoOpEdit.Text                 := trim( TipoOperacion );
      ComisionesEdit.Value            := Comisiones;
      GastosEdit.Value                := Gastos;
      refOrdenanteEdit.Text           := trim( RefOrdenante );
      numCreditoEdit.Text             := trim( NumCredito );
      FechaOpEdit.Date                := FechaOperacion ;
      entidadEmisoraEdit.Text         := EntidadEmisora;
      ClienteEmisorEdit.Text          := ClienteEmisor;
      ClienteBeneficiarioEdit.Text    := ClienteBeneficiario;
//      DisponibleEdit.Text             := Libre;

      // activar/desactivar entradas
      importeCreditoEdit.Enabled      := trim(DivisaCredito) <> EmptyStr;
      importeCreditoLabel.Enabled     := trim(DivisaCredito) <> EmptyStr;
    end;
  end;

(*************
 EVENTOS
 *************)

procedure TOpDivRecType06Form.tipoOpEditExit(Sender: TObject);
begin
  inherited;
  TOpDivRecType06( FSystemRecord ).TipoOperacion := trim( TEdit( Sender ).Text );
end;

procedure TOpDivRecType06Form.divisaCreditoEditExit(Sender: TObject);
begin
  inherited;
  TOpDivRecType06( FSystemRecord ).DivisaCredito := trim( TEdit( Sender ).Text );
end;

procedure TOpDivRecType06Form.importeCreditoEditExit(Sender: TObject);
begin
  inherited;
  TOpDivRecType06( FSystemRecord ).ImporteCredito := TRxCalcEdit( Sender ).value;
end;

procedure TOpDivRecType06Form.comisionesEditExit(Sender: TObject);
begin
  inherited;
  TOpDivRecType06( FSystemRecord ).Comisiones := TRxCalcEdit( Sender ).value;
end;

procedure TOpDivRecType06Form.fechaOpEditExit(Sender: TObject);
begin
  inherited;
  TOpDivRecType06( FSystemRecord ).FechaOperacion := TDateEdit( Sender ).Date;
end;

procedure TOpDivRecType06Form.refOrdenanteEditExit(Sender: TObject);
begin
  inherited;
  TOpDivRecType06( FSystemRecord ).RefOrdenante := trim( TEdit( Sender ).Text );
end;

procedure TOpDivRecType06Form.numCreditoEditExit(Sender: TObject);
begin
  inherited;
  TOpDivRecType06( FSystemRecord ).NumCredito := trim( TEdit( Sender ).Text );
end;

procedure TOpDivRecType06Form.entidadEmisoraEditExit(Sender: TObject);
begin
  inherited;
  TOpDivRecType06( FSystemRecord ).EntidadEmisora := trim( TEdit( Sender ).Text );
end;

procedure TOpDivRecType06Form.clienteEmisorEditExit(Sender: TObject);
begin
  inherited;
  TOpDivRecType06( FSystemRecord ).ClienteEmisor := trim( TEdit( Sender ).Text );
end;

procedure TOpDivRecType06Form.clienteBeneficiarioEditChange(
  Sender: TObject);
begin
  inherited;
  TOpDivRecType06( FSystemRecord ).ClienteBeneficiario := trim( TEdit( Sender ).Text );
end;

procedure TOpDivRecType06Form.disponibleEditChange(Sender: TObject);
begin
  inherited;
  TOpDivRecType06( FSystemRecord ).Libre := trim( TEdit( Sender ).Text );
end;

procedure TOpDivRecType06Form.gastosEditExit(Sender: TObject);
begin
  inherited;
  TOpDivRecType06( FSystemRecord ).Gastos := TRxCalcEdit( Sender ).value;
end;

end.
