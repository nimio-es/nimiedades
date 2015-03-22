unit VOpDivRecType07Form;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  VCustomRecordForm, StdCtrls, ExtCtrls, Mask, ComCtrls, ToolEdit, CurrEdit,
  COpDivSystemRecord, COpDivRecType07, Menus, Buttons ;

type
  TOpDivRecType07Form = class(TCustomRecordForm)
    vencimientoLabel: TLabel;
    Label6: TLabel;
    IdSubsistemaPresentacionEdit: TMaskEdit;
    Label7: TLabel;
    RefInicSubsEdit: TMaskEdit;
    Label8: TLabel;
    Label9: TLabel;
    FigEntidadPresentaEdit: TMaskEdit;
    Label4: TLabel;
    pagoParcialCheckBox: TCheckBox;
    nominalInicialLabel: TLabel;
    NominalInicialEdit: TRxCalcEdit;
    ImportePagadoEdit: TRxCalcEdit;
    Label12: TLabel;
    vencimientoEdit: TDateEdit;
    Label13: TLabel;
    devolucionEdit: TDateEdit;
    Label15: TLabel;
    ComisionDevolucionEdit: TRxCalcEdit;
    Label16: TLabel;
    conceptoComplementarioEdit: TEdit;
    vencimientoALaVistaCheckBox: TCheckBox;
    procedure vencimientoEditExit(Sender: TObject);
    procedure NominalInicialEditExit(Sender: TObject);
    procedure IdSubsistemaPresentacionEditExit(Sender: TObject);
    procedure RefInicSubsEditExit(Sender: TObject);
    procedure pagoParcialCheckBoxClick(Sender: TObject);
    procedure ImportePagadoEditExit(Sender: TObject);
    procedure devolucionEditExit(Sender: TObject);
    procedure ComisionDevolucionEditExit(Sender: TObject);
    procedure conceptoComplementarioEditExit(Sender: TObject);
    procedure FigEntidadPresentaEditExit(Sender: TObject);
    procedure vencimientoALaVistaCheckBoxClick(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure onGeneralChange( SystemRecord: TOpDivSystemRecord ); override;
  public
    { Public declarations }
  end;

var
  OpDivRecType07Form: TOpDivRecType07Form;

implementation

{$R *.DFM}

(*************
 MÉTODOS PROTEGIDOS
 *************)

  procedure TOpDivRecType07Form.onGeneralChange( SystemRecord: TOpDivSystemRecord );
  begin
    inherited;

    with TOpDivRecType07( SystemRecord ) do
    begin
      vencimientoALaVistaCheckBox.Checked := VencimientoALaVista;
      if (FechaVencimiento > 0.0) and (not VencimientoALaVista) then
        vencimientoEdit.Date := FechaVencimiento
      else
        vencimientoEdit.Clear();
      vencimientoLabel.Enabled := not VencimientoALaVista;
      vencimientoEdit.Enabled := not VencimientoALaVista;
      NominalInicialEdit.Value := NominalInicial;
      IdSubsistemaPresentacionEdit.Text := trim( IDSubsistemaPresentacion );
      RefInicSubsEdit.Text := trim( RefInicialSubsistema );
      pagoParcialCheckBox.Checked := ( PagoParcial = '1' );
      ImportePagadoEdit.Value := ImportePagado;
      if FechaDevolucion > 0.0 then
        DevolucionEdit.Date := FechaDevolucion
      else
        DevolucionEdit.Clear();
      ComisionDevolucionEdit.Value := ComisionDevolucion;
      conceptoComplementarioEdit.Text := trim( ConceptoComplementario );
      FigEntidadPresentaEdit.Text := trim( FigEntidadPresenta );

      // activar/desactivar
      NominalInicialLabel.Enabled := (PagoParcial = '1');
      NominalInicialEdit.Enabled := (PagoParcial = '1');
    end;
  end;

(*************
 EVENTOS
 *************)

procedure TOpDivRecType07Form.vencimientoEditExit(Sender: TObject);
begin
  inherited;
  TOpDivRecType07( FSystemRecord ).FechaVencimiento := TDateEdit( Sender ).Date;
end;

procedure TOpDivRecType07Form.NominalInicialEditExit(Sender: TObject);
begin
  inherited;
  TOpDivRecType07( FSystemRecord ).NominalInicial := TRxCalcEdit( Sender ).Value;
end;

procedure TOpDivRecType07Form.IdSubsistemaPresentacionEditExit(
  Sender: TObject);
begin
  inherited;
  TOpDivRecType07( FSystemRecord ).IDSubsistemaPresentacion := TEdit( Sender ).Text;
end;

procedure TOpDivRecType07Form.RefInicSubsEditExit(Sender: TObject);
begin
  inherited;
  TOpDivRecType07( FSystemRecord ).RefInicialSubsistema := TEdit( Sender ).Text ;
end;

procedure TOpDivRecType07Form.pagoParcialCheckBoxClick(Sender: TObject);
begin
  inherited;

  if TCheckBox( Sender ).Checked then
    TOpDivRecType07( FSystemRecord ).PagoParcial := '1'
  else
    TOpDivRecType07( FSystemRecord ).PagoParcial := '2'
end;

procedure TOpDivRecType07Form.ImportePagadoEditExit(Sender: TObject);
begin
  inherited;
  TOpDivRecType07( FSystemRecord ).ImportePagado := TRxCalcEdit( Sender ).Value;
end;

procedure TOpDivRecType07Form.devolucionEditExit(Sender: TObject);
begin
  inherited;
  TOpDivRecType07( FSystemRecord ).FechaDevolucion := TDateEdit( Sender ).Date ;
end;

procedure TOpDivRecType07Form.ComisionDevolucionEditExit(Sender: TObject);
begin
  inherited;
  TOpDivRecType07( FSystemRecord ).ComisionDevolucion := TRxCalcEdit( Sender ).Value;
end;

procedure TOpDivRecType07Form.conceptoComplementarioEditExit(
  Sender: TObject);
begin
  inherited;
  TOpDivRecType07( FSystemRecord ).ConceptoComplementario := TEdit( Sender ).Text;
end;

procedure TOpDivRecType07Form.FigEntidadPresentaEditExit(Sender: TObject);
begin
  inherited;
  TOpDivRecType07( FSystemRecord ).FigEntidadPresenta := TEdit( Sender ).Text ;
end;

procedure TOpDivRecType07Form.vencimientoALaVistaCheckBoxClick(
  Sender: TObject);
begin
  inherited;
  TOpDivRecType07( FSystemRecord ).VencimientoALaVista := TCheckBox( Sender ).Checked ;
end;

end.
