unit VGenConfigForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Mask, ToolEdit;

type
  TGenConfigForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    StationIDEdit: TEdit;
    opTipo05CheckBox: TCheckBox;
    opTipo06CheckBox: TCheckBox;
    opTipo07CheckBox: TCheckBox;
    opTipo08CheckBox: TCheckBox;
    opTipo09CheckBox: TCheckBox;
    opTipo10CheckBox: TCheckBox;
    opTipo11CheckBox: TCheckBox;
    opTipo12CheckBox: TCheckBox;
    opTipo13CheckBox: TCheckBox;
    opTipo14CheckBox: TCheckBox;
    opFLECheckBox: TCheckBox;
    opLSTCheckBox: TCheckBox;
    canReadEdit: TEdit;
    codigoAEdit: TEdit;
    codigoBEdit: TEdit;
    GuardarConfButton: TButton;
    SalirButton: TButton;
    opTipo01CheckBox: TCheckBox;
    opTipo02CheckBox: TCheckBox;
    opTipo03CheckBox: TCheckBox;
    opTipo04CheckBox: TCheckBox;
    opTipoDevCheckBox: TCheckBox;
    Label7: TLabel;
    nombreEquipoEdit: TEdit;
    CargarConfButton: TButton;
    PathToDBFilesEdit: TDirectoryEdit;
    procedure nombreEquipoEditChange(Sender: TObject);
    procedure StationIDEditChange(Sender: TObject);
    procedure PathToDBFilesEditChange(Sender: TObject);
    procedure opTipo02CheckBoxClick(Sender: TObject);
    procedure canReadEditChange(Sender: TObject);
    procedure SalirButtonClick(Sender: TObject);
    procedure GuardarConfButtonClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure CargarConfButtonClick(Sender: TObject);
  private
    FPathToExe: String;

    procedure refreshData;
    function canDo: String;
    procedure setCanDo(const canDoString: String);
    function ValidateData: Boolean;
  public
    { Public declarations }
  end;

var
  GenConfigForm: TGenConfigForm;

implementation

{$R *.dfm}

  uses
    FileCtrl,   (* rutinas de directorios *)
    CCriptografiaCutre,  (* theCutreCriptoEngine *)
    IniFiles;

  (*****
     CONSTANTES PRIVADAS DEL MÓDULOS
   *****)
  const
    kCodeOpTipo01  = 'T01';
    kCodeOpTipo02  = 'T02';
    kCodeOpTipo03  = 'T03';
    kCodeOpTipo04  = 'T04';
    kCodeOpTipo05  = 'T05';
    kCodeOpTipo06  = 'T06';
    kCodeOpTipo07  = 'T07';
    kCodeOpTipo08  = 'T08';
    kCodeOpTipo09  = 'T09';
    kCodeOpTipo10  = 'T10';
    kCodeOpTipo11  = 'T11';
    kCodeOpTipo12  = 'T12';
    kCodeOpTipo13  = 'T13';
    kCodeOpTipo14  = 'T14';
    kCodeOpDev     = 'DEV';
    kCodeOpListado = 'LST';
    kCodeOpSoporte = 'FLE';

    kDefConfigFileName = 'config.ini' ;
    kExtConfigFileName = '.ini';
    // constantes para la rutina de lectura del archivo de configuración
    kSectionINIFile = 'WORKSTATION' ;
    kIdentStationID = 'STATIONID' ;
    kIdentPathToDBFile = 'PATHTODBFILES' ;
    kIdentCanDo = 'CANDO' ;
    kIdentCanRead = 'CANREAD' ;
    kIdentControlCode = 'CODEB';

    kRetOK = 0;
    kRetFileNotExists = -6;
    kRetWrongCodeB = -5;
    kRetSectionNotExists = -1;
    kRetIdentStationIDNotExists = -2;
    kRetIdentPathToDBFilesNotExists = -3;
    kRetIdentCanDoNotExists = -4;



(*************
  MÉTODOS PROTEGIDOS
 *************)

 procedure TGenConfigForm.refreshData;
 const
   klSeparadorCampos = '^CODE^';
 var
   theStrCode: String;
 begin
   //  se genera la cadena sobre la que se calculará el código A a partir de los valores introducidos
   theStrCode := klSeparadorCampos;
   theStrCode := theStrCode + trim(StationIDEdit.Text) ;
   theStrCode := theStrCode + klSeparadorCampos;
   theStrCode := theStrCode + trim(PathToDBFilesEdit.Text) ;
   theStrCode := theStrCode + klSeparadorCampos;
   theStrCode := theStrCode + CanDo() ;
   theStrCode := theStrCode + klSeparadorCampos;
   theStrCode := theStrCode + trim(canReadEdit.Text);
   theStrCode := theStrCode + klSeparadorCampos;
   if trim(nombreEquipoEdit.Text) <> EmptyStr then
   begin
     theStrCode := theStrCode + trim(nombreEquipoEdit.Text);
     theStrCode := theStrCode + klSeparadorCampos;
   end;

   // se obtiene el código A de control
   codigoAEdit.Text := theCutreCriptoEngine.getCodeA( theStrCode );
   codigoBEdit.Text := theCutreCriptoEngine.getCodeB(codigoAEdit.Text);
 end;

 function TGenConfigForm.canDo: String;
 const
   klSeparador = ',';

   function separa( const strToSeparate, strToAdd: String ): String;
   begin
     if Trim(strToSeparate) <> EmptyStr then
       Result := strToSeparate + klSeparador + strToAdd
     else
       Result := strToAdd;
   end;

 begin
   Result := EmptyStr;
   if opTipo01CheckBox.Checked then Result := kCodeOpTipo01;
   if opTipo02CheckBox.Checked then Result := separa(Result, kCodeOpTipo02);
   if opTipo03CheckBox.Checked then Result := separa(Result, kCodeOpTipo03);
   if opTipo04CheckBox.Checked then Result := separa(Result, kCodeOpTipo04);
   if opTipo05CheckBox.Checked then Result := separa(Result, kCodeOpTipo05);
   if opTipo06CheckBox.Checked then Result := separa(Result, kCodeOpTipo06);
   if opTipo07CheckBox.Checked then Result := separa(Result, kCodeOpTipo07);
   if opTipo08CheckBox.Checked then Result := separa(Result, kCodeOpTipo08);
   if opTipo09CheckBox.Checked then Result := separa(Result, kCodeOpTipo09);
   if opTipo10CheckBox.Checked then Result := separa(Result, kCodeOpTipo10);
   if opTipo11CheckBox.Checked then Result := separa(Result, kCodeOpTipo11);
   if opTipo12CheckBox.Checked then Result := separa(Result, kCodeOpTipo12);
   if opTipo13CheckBox.Checked then Result := separa(Result, kCodeOpTipo13);
   if opTipo14CheckBox.Checked then Result := separa(Result, kCodeOpTipo14);
   if opTipoDevCheckBox.Checked then Result := separa(Result, kCodeOpDev);
   if opLSTCheckBox.Checked    then Result := separa(Result, kCodeOpListado);
   if opFLECheckBox.Checked    then Result := separa(Result, kCodeOpSoporte);
 end;

 procedure TGenConfigForm.setCanDo(const canDoString: String);
 begin
   opTipo01CheckBox.Checked := (Pos(kCodeOpTipo01, canDoString) > 0);
   opTipo02CheckBox.Checked := (Pos(kCodeOpTipo02, canDoString) > 0);
   opTipo03CheckBox.Checked := (Pos(kCodeOpTipo03, canDoString) > 0);
   opTipo04CheckBox.Checked := (Pos(kCodeOpTipo04, canDoString) > 0);
   opTipo05CheckBox.Checked := (Pos(kCodeOpTipo05, canDoString) > 0);
   opTipo06CheckBox.Checked := (Pos(kCodeOpTipo06, canDoString) > 0);
   opTipo07CheckBox.Checked := (Pos(kCodeOpTipo07, canDoString) > 0);
   opTipo08CheckBox.Checked := (Pos(kCodeOpTipo08, canDoString) > 0);
   opTipo09CheckBox.Checked := (Pos(kCodeOpTipo09, canDoString) > 0);
   opTipo10CheckBox.Checked := (Pos(kCodeOpTipo10, canDoString) > 0);
   opTipo11CheckBox.Checked := (Pos(kCodeOpTipo11, canDoString) > 0);
   opTipo12CheckBox.Checked := (Pos(kCodeOpTipo12, canDoString) > 0);
   opTipo13CheckBox.Checked := (Pos(kCodeOpTipo13, canDoString) > 0);
   opTipo14CheckBox.Checked := (Pos(kCodeOpTipo14, canDoString) > 0);
   opTipoDevCheckBox.Checked := (Pos(kCodeOpDev, canDoString) > 0);
   opLSTCheckBox.Checked    := (Pos(kCodeOpListado, canDoString) > 0);
   opFLECheckBox.Checked    := (Pos(kCodeOpSoporte, canDoString) > 0);
 end;

 function TGenConfigForm.ValidateData: Boolean;
 begin
    // se debe comprobar que los datos necesarios existen y que son correctos
    Result := true ;
    // debe existir el valor ID Estación
    if Trim(StationIDEdit.Text) = EmptyStr then
    begin
      MessageDlg( 'Debe indicar un valor para ID-Estación', mtError, [mbOK], 0 );
      StationIDEdit.SetFocus ;
      result := false;
      exit;
    end;
    // se comprueba el PATH a los archivos de datos
    if trim(PathToDBFilesEdit.Text) = EmptyStr then
    begin
      MessageDlg( 'Debe indicar una via de acceso a los ficheros de datos.', mtError, [mbOK], 0 );
      PathToDBFilesEdit.SetFocus;
      result := false;
      exit;
    end;
    // se comprueba que al menos hay una operación marcada
    if not ( opTipo01CheckBox.Checked
         or opTipo02CheckBox.Checked
         or opTipo03CheckBox.Checked
         or opTipo04CheckBox.Checked
         or opTipo05CheckBox.Checked
         or opTipo06CheckBox.Checked
         or opTipo07CheckBox.Checked
         or opTipo08CheckBox.Checked
         or opTipo09CheckBox.Checked
         or opTipo10CheckBox.Checked
         or opTipo11CheckBox.Checked
         or opTipo12CheckBox.Checked
         or opTipo13CheckBox.Checked
         or opTipo14CheckBox.Checked
         or opTipoDevCheckBox.Checked
         or opLSTCheckBox.Checked
         or opFLECheckBox.Checked ) then
    begin
      MessageDlg( 'Debe marcar al menos una operación a realizar', mtError, [mbOK], 0 );
      opTipo02CheckBox.SetFocus ;
      result := false;
      exit;
    end;
 end;

(*************
  EVENTOS
 *************)

procedure TGenConfigForm.FormCreate(Sender: TObject);
begin
  FPathToExe := ExtractFilePath( ParamStr(0) );
end;

procedure TGenConfigForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
  begin
    Perform(WM_NEXTDLGCTL, 0, 0);
    key := #0;
  end
end;

procedure TGenConfigForm.nombreEquipoEditChange(Sender: TObject);
begin
  refreshData();
end;

procedure TGenConfigForm.StationIDEditChange(Sender: TObject);
begin
  refreshData();
end;

procedure TGenConfigForm.PathToDBFilesEditChange(Sender: TObject);
begin
  refreshData();
end;

procedure TGenConfigForm.opTipo02CheckBoxClick(Sender: TObject);
begin
  refreshData();
end;

procedure TGenConfigForm.canReadEditChange(Sender: TObject);
begin
  refreshData();
end;

procedure TGenConfigForm.SalirButtonClick(Sender: TObject);
begin
  Self.Close();
end;

procedure TGenConfigForm.GuardarConfButtonClick(Sender: TObject);
var
  GuardarDialog: TSaveDialog;
  configFile: TIniFile;
begin
  if ValidateData() then
  begin
    // creamos el archivo....
    GuardarDialog := TSaveDialog.Create(Self);
    try
      GuardarDialog.InitialDir := FPathToExe;
      GuardarDialog.DefaultExt := 'ini';
      GuardarDialog.Options := [ofDontAddToRecent, ofOverwritePrompt, ofPathMustExist];
      GuardarDialog.OptionsEx := [ofExNoPlacesBar];
      if Trim(nombreEquipoEdit.Text) <> EmptyStr then
        GuardarDialog.FileName := Trim(nombreEquipoEdit.Text)
      else
        GuardarDialog.FileName := 'CONFIG.ini';
      if GuardarDialog.Execute() then
      begin
        // se procede a crear el fichero de configuración a partir de los datos
        // introducidos en el diálogo
        configFile := TIniFile.Create(GuardarDialog.FileName);
        try
          configFile.WriteString(kSectionINIFile, kIdentStationID, Trim(StationIDEdit.Text));
          configFile.WriteString(kSectionINIFile, kIdentPathToDBFile, Trim(PathToDBFilesEdit.Text));
          configFile.WriteString(kSectionINIFile, kIdentCanDo, CanDo());
          configFile.WriteString(kSectionINIFile, kIdentCanRead, Trim(canReadEdit.Text));
          configFile.WriteString(kSectionINIFile, kIdentControlCode, Trim(codigoBEdit.Text));
          configFile.UpdateFile();
        finally
          configFile.Free();
        end;
        // lo señalamos en el caption del form...
        Self.Caption := 'Generar archivo de configuración (' + ExtractFileName(GuardarDialog.FileName) + ')';
      end
    finally
      GuardarDialog.Free();
    end
  end
end;

procedure TGenConfigForm.CargarConfButtonClick(Sender: TObject);
var
  abrirDialog: TOpenDialog;
  archivoConfiguracion: TIniFile;
begin
  abrirDialog := TOpenDialog.Create(Self);
  try
    abrirDialog.InitialDir := FPathToExe;
    abrirDialog.DefaultExt := 'ini';
    abrirDialog.Options := [ofDontAddToRecent, ofPathMustExist];
    abrirDialog.OptionsEx := [ofExNoPlacesBar];
    if abrirDialog.Execute() then
    begin
      if UpperCase(abrirDialog.FileName) <> 'CONFIG.INI' then
        nombreEquipoEdit.Text := ChangeFileExt(ExtractFileName(abrirDialog.FileName), EmptyStr)
      else
        nombreEquipoEdit.Text := EmptyStr;
      Self.Caption := 'Generar archivo de configuración (' + ExtractFileName(abrirDialog.FileName) + ')';
      archivoConfiguracion := TIniFile.Create(abrirDialog.FileName);
      try
        StationIDEdit.Text := Trim(archivoConfiguracion.ReadString(kSectionINIFile, kIdentStationID, EmptyStr));
        PathToDBFilesEdit.Text := Trim(archivoConfiguracion.ReadString(kSectionINIFile, kIdentPathToDBFile, EmptyStr));
        setCanDo(archivoConfiguracion.ReadString(kSectionINIFile, kIdentCanDo, EmptyStr));
        canReadEdit.Text := Trim(archivoConfiguracion.ReadString(kSectionINIFile, kIdentCanRead, EmptyStr));
        refreshData();
        if Trim(codigoBEdit.Text) <> Trim(archivoConfiguracion.ReadString(kSectionINIFile, kIdentControlCode, EmptyStr)) then
          MessageDlg('Es muy posible que este archivo fuera modificado manualmente por alguien.',mtWarning,[mbOK],0);
      finally
        archivoConfiguracion.Free();
      end
    end
  finally
    abrirDialog.Free();
  end;
end;

end.
