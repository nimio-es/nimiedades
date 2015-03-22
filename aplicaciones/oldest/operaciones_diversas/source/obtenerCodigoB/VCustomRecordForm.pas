unit VCustomRecordForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls,
  COpDivSystemRecord, StdCtrls, ToolEdit, CurrEdit, Mask;

type
  TCustomRecordForm = class(TForm)
    ReferencePanel: TPanel;
    bottomPanel: TPanel;
    OIDPanel: TPanel;
    OpRefPanel: TPanel;
    OpNatPanel: TPanel;
    DateCreationPanel: TPanel;
    AceptarButton: TButton;
    CancelarButton: TButton;
    registroLabel: TLabel;
    cobroRadioBtn: TRadioButton;
    pagoRadioBtn: TRadioButton;
    EntOficOrigenLabel: TLabel;
    EntidadOrigenEdit: TEdit;
    OficinaOrigenEdit: TMaskEdit;
    EntOficDestinoLabel: TLabel;
    EntidadOficinaDestinoEdit: TMaskEdit;
    DivisaOperacionComboBox: TComboBox;
    DivisaImporteOpLabel: TLabel;
    ImporteOrigenOperacionEdit: TRxCalcEdit;
    ImporteOpEurosLabel: TLabel;
    ImportePrincipalOperacionEurosEdit: TEdit;
    NumCtaDestinoLabel: TLabel;
    numCtaDestinoEdit: TMaskEdit;
    DestinoLabel: TLabel;
    DCEntOficDestinoLabel: TLabel;
    DCNumCtaDestinoLabel: TLabel;
    ClaveAutorizaLabel: TLabel;
    claveAutorizaEdit: TMaskEdit;
    leftDocumentalLabel: TLabel;
    CaracterDocumentalLabel: TLabel;
    NombreOficinaCajaLabel: TLabel;
    NombreEntidadDestinoLabel: TLabel;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure CancelarButtonClick(Sender: TObject);
    procedure AceptarButtonClick(Sender: TObject);
    procedure cobroRadioBtnClick(Sender: TObject);
    procedure OficinaOrigenEditExit(Sender: TObject);
    procedure EntidadOficinaDestinoEditExit(Sender: TObject);
    procedure numCtaDestinoEditExit(Sender: TObject);
    procedure DivisaOperacionComboBoxChange(Sender: TObject);
    procedure ImporteOrigenOperacionEditExit(Sender: TObject);
    procedure claveAutorizaEditExit(Sender: TObject);
  protected
    FSystemRecord: TOpDivSystemRecord;

    //*** métodos de soporte para las propiedades
    procedure setSystemRecord( aSystemRecord: TOpDivSystemRecord ); virtual;

    //*** otros métodos de utilidad
    procedure updateRecordInfo; virtual;
    procedure onGeneralChange( SystemRecord: TOpDivSystemRecord ); virtual;
  public
    property SystemRecord: TOpDivSystemRecord read FSystemRecord write setSystemRecord;
  end;

var
  CustomRecordForm: TCustomRecordForm;

implementation

{$R *.DFM}

  uses
    CDBMiddleEngine;

(**********
  MÉTODOS PRIVADOS
 **********)

  //***** Soporte a las propiedades *******
  procedure TCustomRecordForm.setSystemRecord( aSystemRecord: TOpDivSystemRecord );
  begin
    if assigned( FSystemRecord ) then
      FSystemRecord.GeneralChange := nil;
    FSystemRecord := aSystemRecord;
    FSystemRecord.GeneralChange := Self.onGeneralChange;
    updateRecordInfo();
  end;  // -- TCustomRecordForm.setSystemRecord()

  //***** Otros métodos de utilidad
  procedure TCustomRecordForm.updateRecordInfo;
  const
    kValDocumental: array [boolean] of String = ( 'No', 'Si' );
  begin
    OIDPanel.Caption := 'ID:' + FSystemRecord.OID;
    OpRefPanel.Caption := 'Ref:' + FSystemRecord.OpRef;
    OpNatPanel.Caption := FSystemRecord.getOpNatDesc( FSystemRecord.OpNat );
    DateCreationPanel.Caption := dateTimeToStr( FSystemRecord.DateCreation );

    CaracterDocumentalLabel.Caption := kValDocumental[ FSystemRecord.isDocumentable() ];
    registroLabel.Caption := FSystemRecord.getDataAsFileRecord();
  end; // -- TCustomRecordForm.updateRecordInfo()

  //:: se encarga de responder ante los cambios generales del objeto-dato
  procedure TCustomRecordForm.onGeneralChange( SystemRecord: TOpDivSystemRecord );
  begin
    registroLabel.Caption := SystemRecord.getDataAsFileRecord();
    registroLabel.Hint    := registroLabel.Caption ;

    OpNatPanel.Caption             := FSystemRecord.getOpNatDesc( FSystemRecord.OpNat );

    // se muestran los datos comunes
    cobroRadioBtn.Checked          := (FSystemRecord.OpNat = '1');
    pagoRadioBtn.Checked           := (FSystemRecord.OpNat = '2');
    EntidadOrigenEdit.Text         := trim( copy( FSystemRecord.EntOficOrigen, 1, 4 ) );
    OficinaOrigenEdit.Text         := trim( copy( FSystemRecord.EntOficOrigen, 5, 4 ) );
    NombreOficinaCajaLabel.Caption := trim( FSystemRecord.OficOrigenName );
    EntidadOficinaDestinoEdit.Text     := trim( FSystemRecord.EntOficDestino );
    NombreEntidadDestinoLabel.Caption := trim( FSystemRecord.EntDestinoName );
    DCEntOficDestinoLabel.Caption  := FSystemRecord.DCEntOficDestino ;
    DCNumCtaDestinoLabel.Caption   := FSystemRecord.DCNumCtaDestino;
    numCtaDestinoEdit.Text         := trim( FSystemRecord.NumCtaDestino );
    DivisaOperacionComboBox.ItemIndex := FSystemRecord.DivisaOperacion ;
    if FSystemRecord.DivisaOperacion = 0 then // euros
    begin
      ImporteOrigenOperacionEdit.DecimalPlaces := 3;
      ImporteOrigenOperacionEdit.DisplayFormat := ',0.###';
      ImporteOrigenOperacionEdit.Value := FSystemRecord.ImportePrinOp ;
      ImportePrincipalOperacionEurosEdit.Text := EmptyStr;
    end
    else
    begin
      ImporteOrigenOperacionEdit.DecimalPlaces := 0;
      ImporteOrigenOperacionEdit.DisplayFormat := ',0';
      ImporteOrigenOperacionEdit.Value := FSystemRecord.ImporteOrigOp ;
      ImportePrincipalOperacionEurosEdit.Text := floatToStrF( FSystemRecord.ImportePrinOp, ffNumber, 12, 3 );
    end;
    claveAutorizaEdit.Text          := FSystemRecord.ClaveAutoriza ;
  end;

//********************** EVENTOS *******************
procedure TCustomRecordForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    if not( Screen.ActiveControl is TMemo ) then
    begin
      Perform( WM_NEXTDLGCTL, 0, 0 );
      Key := #0;
    end
  end
  else if Key = '.' then
  begin
    if ( Screen.ActiveControl is TRxCalcEdit ) then
      Key := ',';
  end
end;

procedure TCustomRecordForm.CancelarButtonClick(Sender: TObject);
begin
  // símplemente cerramos la ventana
  Self.Close;
end;

procedure TCustomRecordForm.AceptarButtonClick(Sender: TObject);
begin
  FSystemRecord.TestData;  // se fuerza a comprobar que toda la información introducida es válida
  // ahora se guarda el registro
  TheDBMiddleEngine.writeRecord( FSystemRecord );
  // si no ha saltado ninguna excepción se procede a cerrar la ventana (y borramos el registro)
  FSystemRecord.Free;
  Self.Close;
end;

procedure TCustomRecordForm.cobroRadioBtnClick(Sender: TObject);
begin
  if cobroRadioBtn.Checked then FSystemRecord.OpNat := '1'
  else                          FSystemRecord.OpNat := '2';
end;

procedure TCustomRecordForm.OficinaOrigenEditExit(Sender: TObject);
begin
  try
    FSystemRecord.EntOficOrigen := trim( entidadOrigenEdit.Text ) + trim( oficinaOrigenEdit.Text ) ;
  except
    TWinControl( Sender ).SetFocus ;
    raise;
  end
end;

procedure TCustomRecordForm.EntidadOficinaDestinoEditExit(Sender: TObject);
begin
  try
    FSystemRecord.EntOficDestino := TEdit( Sender ).Text;
  except
    TWinControl( Sender ).SetFocus ;
    raise;
  end;
end;

procedure TCustomRecordForm.numCtaDestinoEditExit(Sender: TObject);
begin
  try
    FSystemRecord.NumCtaDestino := TEdit( Sender ).Text;
  except
    TWinControl( Sender ).SetFocus ;
    raise;
  end;
end;

procedure TCustomRecordForm.DivisaOperacionComboBoxChange(Sender: TObject);
begin
  try
    FSystemRecord.DivisaOperacion := TComboBox( Sender ).ItemIndex ;
  except
    TWinControl( Sender ).SetFocus ;
    raise;
  end;
end;

procedure TCustomRecordForm.ImporteOrigenOperacionEditExit(
  Sender: TObject);
begin
  try
    FSystemRecord.ImporteOperacion := TRxCalcEdit( Sender ).Value ;
  except
    TWinControl( Sender ).SetFocus;
    raise;
  end;
end;

procedure TCustomRecordForm.claveAutorizaEditExit(Sender: TObject);
begin
  try
    FSystemRecord.ClaveAutoriza := TEdit( Sender ).Text;
  except
    TWinControl( Sender ).SetFocus;
    raise;
  end;
end;

end.
