unit VCustomRecordForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls,
  COpDivSystemRecord, StdCtrls, ToolEdit, CurrEdit, Mask, Menus, Buttons;

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
    ConversionPopupMenu: TPopupMenu;
    aEuros1: TMenuItem;
    aPesetas1: TMenuItem;
    IncluirSoporteCheckBox: TCheckBox;
    buscarEntidadSpeedButton: TSpeedButton;
    observacionesLabel: TLabel;
    observacionesMemo: TMemo;
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
    procedure aEuros1Click(Sender: TObject);
    procedure aPesetas1Click(Sender: TObject);
    procedure IncluirSoporteCheckBoxClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure buscarEntidadSpeedButtonClick(Sender: TObject);
    procedure observacionesMemoExit(Sender: TObject);
  protected
    FSystemRecord: TOpDivSystemRecord;

    //*** métodos de soporte para las propiedades
    procedure setSystemRecord( aSystemRecord: TOpDivSystemRecord ); virtual;

    //*** otros métodos de utilidad
    procedure updateRecordInfo; virtual;
    procedure onGeneralChange( SystemRecord: TOpDivSystemRecord ); virtual;
    procedure setErrorControlPos(const FieldWithError: String); virtual;
    procedure onDateErrorEvent(SystemRecord: TOpDivSystemRecord; const FieldWithError, ErrorMsg: String); virtual;
  public
    property SystemRecord: TOpDivSystemRecord read FSystemRecord write setSystemRecord;
  end;

var
  CustomRecordForm: TCustomRecordForm;

implementation

{$R *.DFM}

  uses
    CDBMiddleEngine,
    CQueryEngine,
    CPrintOpAgent;

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
    FSystemRecord.DataErrorEvent := Self.onDateErrorEvent;
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
    IncluirSoporteCheckBox.Checked := FSystemRecord.IncluirSoporte;
    if FSystemRecord.DivisaOperacion = 0 then // euros
    begin
      ImporteOrigenOperacionEdit.DecimalPlaces := 2;
      ImporteOrigenOperacionEdit.DisplayFormat := ',0.##';
      ImporteOrigenOperacionEdit.Value := FSystemRecord.ImportePrinOp ;
      ImportePrincipalOperacionEurosEdit.Text := EmptyStr;
    end
    else
    begin
      ImporteOrigenOperacionEdit.DecimalPlaces := 0;
      ImporteOrigenOperacionEdit.DisplayFormat := ',0';
      ImporteOrigenOperacionEdit.Value := FSystemRecord.ImporteOrigOp ;
      ImportePrincipalOperacionEurosEdit.Text := floatToStrF( FSystemRecord.ImportePrinOp, ffNumber, 12, 2 );
    end;
    claveAutorizaEdit.Text          := FSystemRecord.ClaveAutoriza ;

    // 07.05.02 - mostramos las observaciones
    FSystemRecord.getObservaciones( observacionesMemo.Lines );

  end;

  procedure TCustomRecordForm.setErrorControlPos(const FieldWithError: String);
  begin
    if FieldWithError <> k_GenericFieldError then
    begin
      if FieldWithError = k00_EntOficOrigenItem then
        OficinaOrigenEdit.SetFocus()
      else if FieldWithError = k00_EntOficDestinoItem then
        EntidadOficinaDestinoEdit.SetFocus()
      else if FieldWithError = k00_NumCtaDestinoItem then
        numCtaDestinoEdit.SetFocus()
      else if FieldWithError = k00_DivisaOperacionItem then
        DivisaOperacionComboBox.SetFocus()
      else if (FieldWithError = k00_ImportePrinOpItem)
                or (FieldWithError = k00_ImporteOrigOpItem) then
        ImporteOrigenOperacionEdit.SetFocus()
      else if (FieldWithError = k00_ClaveAutorizaItem) then
        claveAutorizaEdit.SetFocus()

    end; // FieldWithError <> k_GenericFieldError
  end;

  procedure TCustomRecordForm.onDateErrorEvent(SystemRecord: TOpDivSystemRecord; const FieldWithError, ErrorMsg: String);
  var
    launchExcep: Boolean;
  begin
    launchExcep := True;
    setErrorControlPos(FieldWithError);
    if launchExcep then
      raise Exception.Create(ErrorMsg);
  end;

//********************** EVENTOS *******************
procedure TCustomRecordForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
  begin
    // $ 27/10/2001 -- queremos que cuando pulsemos ESC, el campo recupere su valor original,
    //                 para ello podemos usar el evento de "actualización" del campo...
    onGeneralChange(FSystemRecord);
  end
  else if Key = #13 then
  begin
// 07.05.02 -- debido a que hace falta un Memo para las Observaciones y que quiero que
//             siga la tónica general de saltar de campo con el Enter, se deshabilita
//             esta condición.
//    if not( Screen.ActiveControl is TMemo ) then
//    begin
      Perform( WM_NEXTDLGCTL, 0, 0 );
      Key := #0;
//    end
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
var
  prnOpAgent: TPrintOpAgent;
begin
  FSystemRecord.TestData;  // se fuerza a comprobar que toda la información introducida es válida
  // ahora se guarda el registro
  TheDBMiddleEngine.writeRecord( FSystemRecord );
  // $ 30/10/2001 -- a partir de ahora es "obligatorio" imprimir el registro después de grabarse
  prnOpAgent := TPrintOpAgent.Create();
  try
    prnOpAgent.Execute(FSystemRecord);
  finally
    prnOpAgent.Free();
  end;
  // si no ha saltado ninguna excepción se procede a cerrar la ventana (y borramos el registro)
  FSystemRecord.Free;
  Self.Close;
end;

procedure TCustomRecordForm.cobroRadioBtnClick(Sender: TObject);
begin
  if cobroRadioBtn.Checked then FSystemRecord.OpNat := '1'
  else                          FSystemRecord.OpNat := '2';
end;

(****
  $ 27/10/2001 -- después de insertar el evento de notificación de error,
      se dispone de una rutina "general" para realizar el posicionamiento
      dentro del campo que produjo el error. Esto libera a cada rutina de
      actualización de datos a no tener que interrumpir la excepción,
      reposicionarse y luego volver a lanzar la excepción.
****)

procedure TCustomRecordForm.OficinaOrigenEditExit(Sender: TObject);
begin
//  try
    FSystemRecord.EntOficOrigen := trim( entidadOrigenEdit.Text ) + trim( oficinaOrigenEdit.Text ) ;
//  except
//    TWinControl( Sender ).SetFocus ;
//    raise;
//  end
end;

procedure TCustomRecordForm.EntidadOficinaDestinoEditExit(Sender: TObject);
begin
//  try
    FSystemRecord.EntOficDestino := TEdit( Sender ).Text;
//  except
//    TWinControl( Sender ).SetFocus ;
//    raise;
//  end;
end;

procedure TCustomRecordForm.numCtaDestinoEditExit(Sender: TObject);
begin
//  try
    FSystemRecord.NumCtaDestino := TEdit( Sender ).Text;
//  except
//    TWinControl( Sender ).SetFocus ;
//    raise;
//  end;
end;

procedure TCustomRecordForm.DivisaOperacionComboBoxChange(Sender: TObject);
begin
//  try
    FSystemRecord.DivisaOperacion := TComboBox( Sender ).ItemIndex ;
//  except
//    TWinControl( Sender ).SetFocus ;
//    raise;
//  end;
end;

procedure TCustomRecordForm.ImporteOrigenOperacionEditExit(
  Sender: TObject);
begin
//  try
    FSystemRecord.ImporteOperacion := TRxCalcEdit( Sender ).Value ;
//  except
//    TWinControl( Sender ).SetFocus;
//    raise;
//  end;
end;

procedure TCustomRecordForm.claveAutorizaEditExit(Sender: TObject);
begin
//  try
    FSystemRecord.ClaveAutoriza := TEdit( Sender ).Text;
//  except
//    TWinControl( Sender ).SetFocus;
//    raise;
//  end;
end;

procedure TCustomRecordForm.aEuros1Click(Sender: TObject);
var
  selectedControl: TWinControl;
begin
  selectedControl := Screen.ActiveControl;
  if selectedControl is TRxCalcEdit then
    TRxCalcEdit(selectedControl).Value := TRxCalcEdit(selectedControl).Value / 166.386
  else
    raise Exception.Create('PRECONDICIÓN: Este menú pop-up no puede ser asociado a una entrada que no sea numérica.');
end;

procedure TCustomRecordForm.aPesetas1Click(Sender: TObject);
var
  selectedControl: TWinControl;
begin
  selectedControl := Screen.ActiveControl;
  if selectedControl is TRxCalcEdit then
    TRxCalcEdit(selectedControl).Value := Round(TRxCalcEdit(selectedControl).Value * 166.386)
  else
    raise Exception.Create('PRECONDICIÓN: Este menú pop-up no puede ser asociado a una entrada que no sea numérica.');
end;

procedure TCustomRecordForm.IncluirSoporteCheckBoxClick(Sender: TObject);
begin
  FSystemRecord.IncluirSoporte := TCheckBox(Sender).Checked;
end;

procedure TCustomRecordForm.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  prnRecAgent: TPrintOpAgent;
begin
  if Key = 114 then  // cuando se pulsa F3 se puede imprimir el registro
  begin
    prnRecAgent := TPrintOpAgent.Create();
    try
      prnRecAgent.Execute(FSystemRecord);
    finally
      prnRecAgent.Free();
    end
  end;
end;

procedure TCustomRecordForm.buscarEntidadSpeedButtonClick(Sender: TObject);
var
  oldEntidad,
  oldOficina,
  newEntidad: String;
begin
  oldEntidad := Copy(FSystemRecord.EntOficDestino, 1, 4);
  oldOficina := Copy(FSystemRecord.EntOficDestino, 5, 4);
  newEntidad := theQueryEngine.searchEntidad(oldEntidad) ;
  if oldEntidad <> newEntidad then
    FSystemRecord.EntOficDestino := newEntidad + oldOficina;
end;

procedure TCustomRecordForm.observacionesMemoExit(Sender: TObject);
begin
  FSystemRecord.setObservaciones( TMemo(Sender).Lines );
end;

end.
