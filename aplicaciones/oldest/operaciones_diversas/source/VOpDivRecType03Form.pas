unit VOpDivRecType03Form;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  VCustomRecordForm, ToolEdit, CurrEdit, StdCtrls, Mask, ExtCtrls,
  COpDivSystemRecord, COpDivRecType03, Menus, Buttons;

type
  TOpDivRecType03Form = class(TCustomRecordForm)
    Label1: TLabel;
    IndicadorSubsistemaEdit: TMaskEdit;
    Label2: TLabel;
    RefInicialLabel: TLabel;
    RefInicialEdit: TMaskEdit;
    refAdeudoLabel: TLabel;
    refAdeudoEdit: TEdit;
    NifSufijoLabel: TLabel;
    nifOrdenanteEdit: TEdit;
    numChequeLabel: TLabel;
    numChequeEdit: TMaskEdit;
    Label7: TLabel;
    fechaIntercambioEdit: TDateEdit;
    Label8: TLabel;
    conceptoOperacionEdit: TMaskEdit;
    Label9: TLabel;
    ConceptoComplementaLabel: TLabel;
    conceptoComplementarioEdit: TEdit;
    NominalInicialLabel: TLabel;
    nominaInicialEdit: TRxCalcEdit;
    ComisionesDevolucionEdit: TRxCalcEdit;
    ComisionesDevolucionLabel: TLabel;
    ComisionesReclamacionLabel: TLabel;
    ComisionesReclamacionEdit: TRxCalcEdit;
    Sumar2ImporteOpButton: TButton;
    procedure IndicadorSubsistemaEditExit(Sender: TObject);
    procedure RefInicialEditExit(Sender: TObject);
    procedure refAdeudoEditExit(Sender: TObject);
    procedure nifOrdenanteEditExit(Sender: TObject);
    procedure numChequeEditExit(Sender: TObject);
    procedure fechaIntercambioEditExit(Sender: TObject);
    procedure conceptoOperacionEditExit(Sender: TObject);
    procedure conceptoComplementarioEditExit(Sender: TObject);
    procedure nominaInicialEditExit(Sender: TObject);
    procedure ComisionesDevolucionEditExit(Sender: TObject);
    procedure ComisionesReclamacionEditExit(Sender: TObject);
    procedure Sumar2ImporteOpButtonClick(Sender: TObject);
    procedure IndicadorSubsistemaEditChange(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure onGeneralChange( SystemRecord: TOpDivSystemRecord ); override;
    procedure setErrorControlPos(const FieldWithError: String); override;
  public
    { Public declarations }
  end;

var
  OpDivRecType03Form: TOpDivRecType03Form;

implementation

{$R *.DFM}

  (**
    MÉTODOS PROTEGIDOS
   **)

  procedure TOpDivRecType03Form.onGeneralChange( SystemRecord: TOpDivSystemRecord );
  begin
    inherited;

    with TOpDivRecType03( SystemRecord ) do
    begin
      IndicadorSubsistemaEdit.Text := IndicadorSubsistema;
      RefInicialEdit.Text := RefInicial;
      RefAdeudoEdit.Text := CodOrdenante;
      nifOrdenanteEdit.Text := NifSufOrdenante;
      numChequeEdit.Text := NumCheque;
      if FechaInterInicial < strToDate( '01/01/2001' ) then
        fechaIntercambioEdit.Text := EmptyStr
      else
        fechaIntercambioEdit.Date := FechaInterInicial;
      ConceptoOperacionEdit.Text := ConceptoOp;
      conceptoComplementarioEdit.Text := ConceptoComplementa;
      nominaInicialEdit.Value := NominalInicial;
      ComisionesDevolucionEdit.Value := ComisionInicial;
      ComisionesReclamacionEdit.Value := ComisionReclamacion;

      // se activan/desactivan ciertas entradas dependiendo de los datos
      RefInicialLabel.Enabled  := (IndicadorSubsistema <> '5');
      RefInicialEdit.Enabled   := (IndicadorSubsistema <> '5');
      NifSufijoLabel.Enabled   := (IndicadorSubsistema = '5');
      NifOrdenanteEdit.Enabled := (IndicadorSubsistema = '5');
      RefAdeudoLabel.Enabled   := (IndicadorSubsistema = '5');
      RefAdeudoEdit.Enabled    := (IndicadorSubsistema = '5');
      numChequeLabel.Enabled   := (IndicadorSubsistema = '4')
                or (IndicadorSubsistema = '6') or (IndicadorSubsistema = '7')
                or (IndicadorSubsistema = '8');
      numChequeEdit.Enabled    := (IndicadorSubsistema = '4')
                or (IndicadorSubsistema = '6') or (IndicadorSubsistema = '7')
                or (IndicadorSubsistema = '8');
      if (IndicadorSubsistema = '5') then
        ConceptoComplementaLabel.Caption := 'Nombre del obligado:'
      else
        ConceptoComplementaLabel.Caption := 'Concepto complementario:';
      ClaveAutorizaLabel.Enabled  := (ConceptoOp = '4') or ((ConceptoOp = '3') and (IndicadorSubsistema = '8'));
      claveAutorizaEdit.Enabled   := (ConceptoOp = '4') or ((ConceptoOp = '3') and (IndicadorSubsistema = '8'));
//      nominaInicialEdit.Enabled   := (ConceptoOp = '1') or (ConceptoOp = '4');
//      nominalInicialLabel.Enabled := (ConceptoOp = '1') or (ConceptoOp = '4');
      ComisionesDevolucionLabel.Enabled := (ConceptoOp = '1') or (ConceptoOp = '4');
      ComisionesDevolucionEdit.Enabled  := (ConceptoOp = '1') or (ConceptoOp = '4');
      ComisionesReclamacionLabel.Enabled := (ConceptoOp = '4');
      ComisionesReclamacionEdit.Enabled  := (ConceptoOp = '4');
    end;
  end;

  procedure TOpDivRecType03Form.setErrorControlPos(const FieldWithError: String);
  begin
    inherited setErrorControlPos(FieldWithError);

    if FieldWithError <> k_GenericFieldError then
    begin

      if      FieldWithError = k03_IndicadorSubsistemaItem then
        IndicadorSubsistemaEdit.SetFocus()
      else if FieldWithError = k03_RefInicialItem then
        RefInicialEdit.SetFocus()
      else if FieldWithError = k03_CodOrdenanteItem then
        refAdeudoEdit.SetFocus()
      else if FieldWithError = k03_NifSufOrdenanteItem then
        nifOrdenanteEdit.SetFocus()
      else if FieldWithError = k03_NumChequeItem then
        numChequeEdit.SetFocus()
      else if FieldWithError = k03_FechaInterInicialItem then
        fechaIntercambioEdit.SetFocus()
      else if FieldWithError = k03_ConceptoOpItem then
        conceptoOperacionEdit.SetFocus()
      else if FieldWithError = k03_ConceptoComplementaItem then
        conceptoComplementarioEdit.SetFocus()
      else if FieldWithError = k03_NominalInicialItem then
        nominaInicialEdit.SetFocus()
      else if FieldWithError = k03_ComisionInicialItem then
        ComisionesDevolucionEdit.SetFocus()
      else if FieldWithError = k03_ComisionReclamacionItem then
        ComisionesReclamacionEdit.SetFocus()
    end;
  end;

  (****
    EVENTOS
   ****)

procedure TOpDivRecType03Form.IndicadorSubsistemaEditExit(Sender: TObject);
begin
  inherited;
  TOpDivRecType03( FSystemRecord ).IndicadorSubsistema := TEdit( Sender ).Text;
end;

procedure TOpDivRecType03Form.RefInicialEditExit(Sender: TObject);
begin
  inherited;
  TOpDivRecType03( FSystemRecord ).RefInicial := TEdit( Sender ).Text;
end;

procedure TOpDivRecType03Form.refAdeudoEditExit(Sender: TObject);
begin
  inherited;
  TOpDivRecType03( FSystemRecord ).CodOrdenante := TEdit( Sender ).Text;
end;

procedure TOpDivRecType03Form.nifOrdenanteEditExit(Sender: TObject);
begin
  inherited;
  TOpDivRecType03( FSystemRecord ).NifSufOrdenante := TEdit( Sender ).Text ;
end;

procedure TOpDivRecType03Form.numChequeEditExit(Sender: TObject);
begin
  inherited;
  TOpDivRecType03( FSystemRecord ).NumCheque := TEdit( Sender ).Text;
end;

procedure TOpDivRecType03Form.fechaIntercambioEditExit(Sender: TObject);
begin
  inherited;
  TOpDivRecType03( FSystemRecord).FechaInterInicial := TDateEdit( Sender ).Date;
end;

procedure TOpDivRecType03Form.conceptoOperacionEditExit(Sender: TObject);
begin
  inherited;
  TOpDivRecType03( FSystemRecord ).ConceptoOp := TEdit( Sender ).Text;
end;

procedure TOpDivRecType03Form.conceptoComplementarioEditExit(
  Sender: TObject);
begin
  inherited;
  TOpDivRecType03( FSystemRecord).ConceptoComplementa := TEdit( Sender ).Text;
end;

procedure TOpDivRecType03Form.nominaInicialEditExit(Sender: TObject);
begin
  inherited;
  TOpDivRecType03( FSystemRecord).NominalInicial := TRxCalcEdit( Sender ).Value;
end;

procedure TOpDivRecType03Form.ComisionesDevolucionEditExit(
  Sender: TObject);
begin
  inherited;
  TOpDivRecType03( FSystemRecord ).ComisionInicial := TRxCalcEdit( Sender ).Value;
end;

procedure TOpDivRecType03Form.ComisionesReclamacionEditExit(
  Sender: TObject);
begin
  inherited;
  TOpDivRecType03( FSystemRecord ).ComisionReclamacion := TRxCalcEdit( Sender ).Value;
end;

procedure TOpDivRecType03Form.Sumar2ImporteOpButtonClick(Sender: TObject);
begin
  inherited;
  // lo que hacemos es poner como importe principal de la operación la suma de las comisiones...
  with TOpDivRecType03(FSystemRecord) do
  begin
    ImportePrinOp := NominalInicial + ComisionInicial + ComisionReclamacion;
    if DivisaOperacion = kDivisaPta then
      ImporteOrigOp := Round(ImportePrinOp * 166.386);
  end
end;

procedure TOpDivRecType03Form.IndicadorSubsistemaEditChange(
  Sender: TObject);
begin
  inherited;
  if Trim(TEdit(Sender).Text) <> EmptyStr then
    TOpDivRecType03( FSystemRecord ).IndicadorSubsistema := TEdit( Sender ).Text;
end;

end.

