unit VOpDivRecType12Form;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  VCustomRecordForm, ToolEdit, CurrEdit, StdCtrls, Mask, ExtCtrls,
  COpDivSystemRecord, COpDivRecType12, Menus, Buttons;

type
  TOpDivRecType12Form = class(TCustomRecordForm)
    ConceptoRadioGroup: TRadioGroup;
    numTarjetaLabel: TLabel;
    numTarjetaEdit: TMaskEdit;
    Label4: TLabel;
    ImporteComisionEdit: TRxCalcEdit;
    TipoImpuestoRadioGroup: TRadioGroup;
    ImporteImpuestoLabel: TLabel;
    importeImpuestoEdit: TRxCalcEdit;
    ImporteRecompensaLabel: TLabel;
    ImporteRecompensaEdit: TRxCalcEdit;
    Label8: TLabel;
    conceptoComplementarioEdit: TEdit;
    procedure ConceptoRadioGroupClick(Sender: TObject);
    procedure OficinaOrigenEditExit(Sender: TObject);
    procedure EntidadOficinaDestinoEditExit(Sender: TObject);
    procedure numTarjetaEditExit(Sender: TObject);
    procedure ImporteComisionEditExit(Sender: TObject);
    procedure DivisaOperacionComboBoxChange(Sender: TObject);
    procedure ImporteOrigenOperacionEditExit(Sender: TObject);
    procedure TipoImpuestoRadioGroupClick(Sender: TObject);
    procedure importeImpuestoEditExit(Sender: TObject);
    procedure ImporteRecompensaEditExit(Sender: TObject);
    procedure conceptoComplementarioEditExit(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure onGeneralChange( SystemRecord: TOpDivSystemRecord ); override;
  public
    { Public declarations }
  end;

var
  OpDivRecType12Form: TOpDivRecType12Form;

implementation

{$R *.DFM}

(*************
 MÉTODOS PROTEGIDOS
 *************)

  procedure TOpDivRecType12Form.onGeneralChange( SystemRecord: TOpDivSystemRecord );
  var
    enabled12,
    enabled2,
    enabledImpuesto : boolean;
  begin
    inherited;

    with TOpDivRecType12( SystemRecord ) do
    begin
      EntidadOrigenEdit.Text         := trim( copy( EntOficOrigen, 1, 4 ) );
      OficinaOrigenEdit.Text         := trim( copy( EntOficOrigen, 5, 4 ) );
      EntidadOficinaDestinoEdit.Text        := trim( EntOficDestino );
      DivisaOperacionComboBox.ItemIndex := DivisaOperacion ;
      if DivisaOperacion = 0 then // euros
      begin
        ImporteOrigenOperacionEdit.Value := ImportePrinOp ;
        ImportePrincipalOperacionEurosEdit.Text := EmptyStr;
      end
      else
      begin
        ImporteOrigenOperacionEdit.Value := ImporteOrigOp ;
        ImportePrincipalOperacionEurosEdit.Text := floatToStrF( ImportePrinOp, ffNumber, 11, 3 );
      end;

      ConceptoRadioGroup.ItemIndex := ConceptoIndex ;

      enabled12 := ( ConceptoIndex in [ 0, 1 ] );
      enabled2  := ( ConceptoIndex = 1 );

      numTarjetaLabel.Enabled := enabled12;
      numTarjetaEdit.Enabled := enabled12;
      tipoImpuestoRadioGroup.Enabled := enabled12;
      importeRecompensaLabel.Enabled := enabled2;
      importeRecompensaEdit.Enabled := enabled2;

      numTarjetaEdit.Text := NumTarjeta ;
      ImporteComisionEdit.Value := ImporteComision;
      TipoImpuestoRadioGroup.ItemIndex := ImpuestoIndex ;
      enabledImpuesto := ( ImpuestoIndex <> -1 );
      importeImpuestoLabel.Enabled := enabledImpuesto;
      importeImpuestoEdit.Enabled := enabledImpuesto;

      importeImpuestoEdit.Value := ImporteImpuesto;
      importeRecompensaEdit.Value := importeRecompensa;

      conceptoComplementarioEdit.Text := ConceptoComplementario;
    end;
  end;


(*************
 EVENTOS
 *************)

procedure TOpDivRecType12Form.ConceptoRadioGroupClick(Sender: TObject);
begin
  inherited;
  TOpDivRecType12( FSystemRecord ).ConceptoIndex := TRadioGroup( Sender ).ItemIndex;
end;

procedure TOpDivRecType12Form.OficinaOrigenEditExit(Sender: TObject);
begin
  inherited;
  TOpDivRecType12( FSystemRecord ).EntOficOrigen := trim( EntidadOrigenEdit.Text ) + trim( OficinaOrigenEdit.Text );
end;

procedure TOpDivRecType12Form.EntidadOficinaDestinoEditExit(
  Sender: TObject);
begin
  inherited;
  TOpDivRecType12( FSystemRecord ).EntOficDestino := trim( TEdit( Sender ).Text );
end;

procedure TOpDivRecType12Form.numTarjetaEditExit(Sender: TObject);
begin
  inherited;
  TOpDivRecType12( FSystemRecord ).NumTarjeta := Trim( TEdit( Sender ).Text );
end;

procedure TOpDivRecType12Form.ImporteComisionEditExit(Sender: TObject);
begin
  inherited;
  TOpDivRecType12( FSystemRecord ).ImporteComision := TRxCalcEdit( Sender ).Value; 
end;

procedure TOpDivRecType12Form.DivisaOperacionComboBoxChange(
  Sender: TObject);
begin
  inherited;
  TOpDivRecType12( FSystemRecord ).DivisaOperacion := TComboBox( Sender ).ItemIndex ;
end;

procedure TOpDivRecType12Form.ImporteOrigenOperacionEditExit(
  Sender: TObject);
begin
  inherited;
  if DivisaOperacionComboBox.ItemIndex = 0 then //euros
    TOpDivRecType12( FSystemRecord ).ImportePrinOp := TRxCalcEdit( Sender ).Value
  else
    TOpDivRecType12( FSystemRecord ).ImporteOrigOp := TRxCalcEdit( Sender ).Value;
end;

procedure TOpDivRecType12Form.TipoImpuestoRadioGroupClick(Sender: TObject);
begin
  inherited;
  TOpDivRecType12( FSystemRecord ).ImpuestoIndex := TRadioGroup( Sender ).ItemIndex;
end;

procedure TOpDivRecType12Form.importeImpuestoEditExit(Sender: TObject);
begin
  inherited;
  TOpDivRecType12( FSystemRecord ).ImporteImpuesto := TRxCalcEdit( Sender ).Value
end;

procedure TOpDivRecType12Form.ImporteRecompensaEditExit(Sender: TObject);
begin
  inherited;
  TOpDivRecType12( FSystemRecord ).ImporteRecompensa := TRxCalcEdit( Sender ).Value
end;

procedure TOpDivRecType12Form.conceptoComplementarioEditExit(
  Sender: TObject);
begin
  inherited;
  TOpDivRecType12( FSystemRecord ).ConceptoComplementario := Trim( TEdit( Sender ).Text );
end;

end.
