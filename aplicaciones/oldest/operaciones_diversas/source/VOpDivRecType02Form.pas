unit VOpDivRecType02Form;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  VCustomRecordForm, ToolEdit, CurrEdit, StdCtrls, Mask, ExtCtrls,
  COpDivSystemRecord, COpDivRecType02, Menus, Buttons;

type
  TOpDivRecType02Form = class(TCustomRecordForm)
    Label1: TLabel;
    TipoDocumentoEdit: TMaskEdit;
    Label2: TLabel;
    ClausulaGastosEdit: TMaskEdit;
    Label3: TLabel;
    Label4: TLabel;
    CodigoDocumentoLabel: TLabel;
    NumDocumentoEdit: TMaskEdit;
    residenteCheckBox: TCheckBox;
    JustificacionCobroExteriorCheckBox: TCheckBox;
    PresentacionParcialCheckBox: TCheckBox;
    ImporteOriginalLabel: TLabel;
    ImporteOriginalEdit: TRxCalcEdit;
    ProvTomadoraLabel: TLabel;
    ProvTomadoraEdit: TMaskEdit;
    ProvinciaTomadoraLabel: TLabel;
    CodigoIdentificaLabel: TLabel;
    CodigoIdentificaEdit: TMaskEdit;
    CeroInterNumDocLabel: TLabel;
    NumDocLabel: TLabel;
    procedure TipoDocumentoEditExit(Sender: TObject);
    procedure ClausulaGastosEditExit(Sender: TObject);
    procedure NumDocumentoEditExit(Sender: TObject);
    procedure residenteCheckBoxClick(Sender: TObject);
    procedure JustificacionCobroExteriorCheckBoxClick(Sender: TObject);
    procedure PresentacionParcialCheckBoxClick(Sender: TObject);
    procedure ImporteOriginalEditExit(Sender: TObject);
    procedure ProvTomadoraEditExit(Sender: TObject);
    procedure CodigoIdentificaEditExit(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure onGeneralChange( SystemRecord: TOpDivSystemRecord ); override;
    procedure setErrorControlPos(const FieldWithError: String); override;
  public
    { Public declarations }
  end;

var
  OpDivRecType02Form: TOpDivRecType02Form;

implementation

{$R *.DFM}

(*************
 MÉTODOS PROTEGIDOS
 *************)

  procedure TOpDivRecType02Form.onGeneralChange( SystemRecord: TOpDivSystemRecord );
  var
    meterNumDoc: Boolean;
  begin
    inherited;

    with TOpDivRecType02( SystemRecord ) do
    begin
      TipoDocumentoEdit.Text    := TipoDocumento;
      ClausulaGastosEdit.Text   := ClausulaGastos;
      CodigoIdentificaEdit.Text := CodigoIdentifica;
      NumDocumentoEdit.Text     := NumDocumento;
      residenteCheckBox.Checked := Residente;
      JustificacionCobroExteriorCheckBox.Checked := JustificaCobroExt;
      PresentacionParcialCheckBox.Checked := PresentaParcial;
      ImporteOriginalEdit.Value := ImporteOriginal ;
      ProvTomadoraEdit.Text     := ProvinciaTomadora;
      ProvinciaTomadoraLabel.Caption := DescProvTomadora;

      // activar/desactivar controles
      meterNumDoc := ((TipoDocumento = '01') or (TipoDocumento = '04'));
      CodigoIdentificaEdit.Enabled  := meterNumDoc;
      NumDocumentoEdit.Enabled      := meterNumDoc;
      CodigoDocumentoLabel.Enabled  := meterNumDoc;
      CodigoIdentificaLabel.Enabled := meterNumDoc;
      NumDocLabel.Enabled           := meterNumDoc;
      CeroInterNumDocLabel.Enabled  := meterNumDoc;
      // 05.05.02 - se añade la condición de que el importe de la op. sea superior a 12500 para que se pueda activar
      //            la entrada del campo Justificación de cobro del exterior
      JustificacionCobroExteriorCheckBox.Enabled := residenteCheckBox.Checked and (ImportePrinOp >= 12500);
      ImporteOriginalLabel.Enabled := PresentaParcial;
      ImporteOriginalEdit.Enabled := PresentaParcial;
      ProvTomadoraLabel.Enabled := TipoDocumento = '04';
      ProvTomadoraEdit.Enabled := TipoDocumento = '04';
    end;
  end;

  procedure TOpDivRecType02Form.setErrorControlPos(const FieldWithError: String);
  begin
    inherited setErrorControlPos(FieldWithError);

    if FieldWithError <> k_GenericFieldError then
     begin
       if      FieldWithError = k02_TipoDocumentoItem then
         TipoDocumentoEdit.SetFocus()
       else if FieldWithError = k02_ClausulaGastosItem then
         ClausulaGastosEdit.SetFocus()
       else if FieldWithError = k02_CodigoIdentificaItem then
         CodigoIdentificaEdit.SetFocus()
       else if FieldWithError = k02_NumDocumentoItem then
         NumDocumentoEdit.SetFocus()
       else if FieldWithError = k02_ClaveCtaAbonoItem then
         residenteCheckBox.SetFocus()
       else if FieldWithError = k02_JustificaCobroExtItem then
         JustificacionCobroExteriorCheckBox.SetFocus()
       else if FieldWithError = k02_PresentaParcialItem then
         PresentacionParcialCheckBox.SetFocus()
       else if FieldWithError = k02_ImporteOriginalItem then
         ImporteOriginalEdit.SetFocus()
       else if FieldWithError = k02_ProvinciaTomadoraItem then
         ProvTomadoraEdit.SetFocus();
     end
  end;

(*************
 EVENTOS
 *************)

procedure TOpDivRecType02Form.TipoDocumentoEditExit(Sender: TObject);
begin
  TOpDivRecType02( FSystemRecord ).TipoDocumento := TEdit( Sender ).Text;
end;

procedure TOpDivRecType02Form.ClausulaGastosEditExit(Sender: TObject);
begin
  TOpDivRecType02( FSystemRecord ).ClausulaGastos := TEdit( Sender ).Text;
end;

procedure TOpDivRecType02Form.NumDocumentoEditExit(Sender: TObject);
begin
  TOpDivRecType02( FSystemRecord ).NumDocumento := TEdit( Sender ).Text;
end;

procedure TOpDivRecType02Form.residenteCheckBoxClick(Sender: TObject);
begin
  TOpDivRecType02( FSystemRecord ).Residente := TCheckBox( Sender ).Checked ;
end;

procedure TOpDivRecType02Form.JustificacionCobroExteriorCheckBoxClick(
  Sender: TObject);
begin
  TOpDivRecType02( FSystemRecord ).JustificaCobroExt := TCheckBox( Sender ).Checked;
end;

procedure TOpDivRecType02Form.PresentacionParcialCheckBoxClick(
  Sender: TObject);
begin
  TOpDivRecType02( FSystemRecord ).PresentaParcial := TCheckBox( Sender ).Checked ;
end;

procedure TOpDivRecType02Form.ImporteOriginalEditExit(Sender: TObject);
begin
  TOpDivRecType02( FSystemRecord ).ImporteOriginal := TRxCalcEdit( Sender ).Value;
end;

procedure TOpDivRecType02Form.ProvTomadoraEditExit(Sender: TObject);
begin
  TOpDivRecType02( FSystemRecord ).ProvinciaTomadora := TEdit( Sender ).Text;
end;

procedure TOpDivRecType02Form.CodigoIdentificaEditExit(Sender: TObject);
begin
  inherited;
  TOpDivRecType02(FSystemRecord).CodigoIdentifica := TEdit(Sender).Text;
end;

end.
