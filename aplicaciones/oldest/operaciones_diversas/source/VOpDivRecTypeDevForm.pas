unit VOpDivRecTypeDevForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, VCustomRecordForm, Menus, ToolEdit, CurrEdit, StdCtrls, Mask,
  ExtCtrls, COpDivSystemRecord, COpDivRecTypeDEV, Buttons;

type
  TOpDivRecTypeDevForm = class(TCustomRecordForm)
    Label1: TLabel;
    FechaPresentaEdit: TDateEdit;
    DevParcialCheckBox: TCheckBox;
    ImporteInicialEdit: TRxCalcEdit;
    ImporteInicialLabel: TLabel;
    Label3: TLabel;
    MotivoDevEdit: TMaskEdit;
    Label4: TLabel;
    ConceptoEdit: TEdit;
    Label5: TLabel;
    TipoOperacionEdit: TMaskEdit;
    Label6: TLabel;
    ReferenciaInicialEdit: TMaskEdit;
    MotivoDevDescLabel: TLabel;
    procedure TipoOperacionEditExit(Sender: TObject);
    procedure ReferenciaInicialEditExit(Sender: TObject);
    procedure DevParcialCheckBoxClick(Sender: TObject);
    procedure ImporteInicialEditExit(Sender: TObject);
    procedure MotivoDevEditExit(Sender: TObject);
    procedure ConceptoEditExit(Sender: TObject);
    procedure FechaPresentaEditExit(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure onGeneralChange( SystemRecord: TOpDivSystemRecord ); override;
    procedure setErrorControlPos(const FieldWithError: String); override;
  public
    { Public declarations }
  end;

var
  OpDivRecTypeDevForm: TOpDivRecTypeDevForm;

implementation

{$R *.dfm}

(*************
 MÉTODOS PROTEGIDOS
 *************)

  procedure TOpDivRecTypeDevForm.onGeneralChange( SystemRecord: TOpDivSystemRecord );
  const
    kValDocumental: array [boolean] of String = ( 'No', 'Si' );
  begin
    inherited;

    with TOpDivRecTypeDEV( SystemRecord ) do
    begin
      TipoOperacionEdit.Text := TipoOpOriginal;
      ReferenciaInicialEdit.Text := OpRef;
      if FechaPresenta = 0.0 then
        FechaPresentaEdit.Text := EmptyStr
      else
        FechaPresentaEdit.Date := FechaPresenta;
      DevParcialCheckBox.Checked := DevParcial;
      ImporteInicialEdit.Value := ImporteInicial;
      MotivoDevEdit.Text := MotivoDev;
      MotivoDevDescLabel.Caption := MotivoDevDesc;
      ConceptoEdit.Text := ConceptoComplementa;

      // dado que también cambian algunas cosas sobre el general (escrita en los
      // paneles auxiliares) se invoca a la rutina que reescribe esa información.
      updateRecordInfo();
      // pero como sea que no se puede usar la función de clase genérica para obtener si es o no es tipo documental
      // procedemos a informarlo directamente desde aquí
      CaracterDocumentalLabel.Caption := kValDocumental[ TOpDivRecTypeDEV(FSystemRecord).isDocumentable() ];

      // se activan o desactivan ciertas entradas
      ImporteInicialLabel.Enabled := DevParcialCheckBox.Checked;
      ImporteInicialEdit.Enabled  := DevParcialCheckBox.Checked;
      cobroRadioBtn.Enabled := isOfThisNatOp(TipoOpOriginal, '1');
      pagoRadioBtn.Enabled  := isOfThisNatOp(TipoOpOriginal, '2');
    end;
  end;

  procedure TOpDivRecTypeDevForm.setErrorControlPos(const FieldWithError: String);
  begin
    inherited setErrorControlPos(FieldWithError);

    if FieldWithError <> k_GenericFieldError then
    begin

      if      FieldWithError = kDEV_TipoOpOriginalItem then
        TipoOperacionEdit.SetFocus()
      else if FieldWithError = kDEV_ImporteInicialItem then
        ImporteInicialEdit.SetFocus()
      else if FieldWithError = kDEV_MotivoDevolucionItem then
        MotivoDevEdit.SetFocus();

    end;
  end;


(*************
 EVENTOS
 *************)


procedure TOpDivRecTypeDevForm.TipoOperacionEditExit(Sender: TObject);
begin
  inherited;
  TOpDivRecTypeDEV(SystemRecord).TipoOpOriginal := Trim(TEdit(Sender).Text);
end;

procedure TOpDivRecTypeDevForm.ReferenciaInicialEditExit(Sender: TObject);
begin
  inherited;
  TOpDivRecTypeDEV(SystemRecord).OpRef := Trim(TEdit(Sender).Text);
end;

procedure TOpDivRecTypeDevForm.DevParcialCheckBoxClick(Sender: TObject);
begin
  inherited;
  TOpDivRecTypeDEV(SystemRecord).DevParcial := TCheckBox(Sender).Checked;
end;

procedure TOpDivRecTypeDevForm.ImporteInicialEditExit(Sender: TObject);
begin
  inherited;
  TOpDivRecTypeDEV(SystemRecord).ImporteInicial := TRxCalcEdit(Sender).Value;
end;

procedure TOpDivRecTypeDevForm.MotivoDevEditExit(Sender: TObject);
begin
  inherited;
  TOpDivRecTypeDEV(SystemRecord).MotivoDev := Trim(Tedit(Sender).Text);
end;

procedure TOpDivRecTypeDevForm.ConceptoEditExit(Sender: TObject);
begin
  inherited;
  TOpDivRecTypeDEV(SystemRecord).ConceptoComplementa := Trim(TEdit(Sender).Text);
end;

procedure TOpDivRecTypeDevForm.FechaPresentaEditExit(Sender: TObject);
begin
  inherited;
  TOpDivRecTypeDEV(FSystemRecord).FechaPresenta := TDateEdit(Sender).Date;
end;

end.
