unit VConfigSystemForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TConfigSystemForm = class(TForm)
    Label1: TLabel;
    StationIDEdit: TEdit;
    Label2: TLabel;
    pathToDBFilesEdit: TEdit;
    BuscaDirSpeedBtn: TSpeedButton;
    Label3: TLabel;
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
    Label4: TLabel;
    canReadEdit: TEdit;
    Label5: TLabel;
    codigoAEdit: TEdit;
    Label6: TLabel;
    codigoBEdit: TEdit;
    Label7: TLabel;
    AceptarBtn: TButton;
    CancelarBtn: TButton;
    opTipo01CheckBox: TCheckBox;
    opTipo02CheckBox: TCheckBox;
    opTipo03CheckBox: TCheckBox;
    opTipo04CheckBox: TCheckBox;
    opTipoDevCheckBox: TCheckBox;
    systemNameLabel: TLabel;
    procedure StationIDEditChange(Sender: TObject);
    procedure BuscaDirSpeedBtnClick(Sender: TObject);
    procedure codigoBEditChange(Sender: TObject);
    procedure AceptarBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);

  private
    theComputerName: String;
    theStrCode: String ;  // cadena sobre la que se calculará el código A y el B

    (******
      FUNCIONES Y PROCEDIMIENTOS DE SOPORTE PARA LAS PROPIEDADES
      Son las funciones get y set.
     *****)
    function getStationID: String ;
    function getPathToDBFiles: String ;
    function getCanDo: String;
    function getCanRead: String;
    function getCodeControl: String;
    procedure setStationID( const aStationID: String );
    procedure setPathToDBFiles( const aPathToDBFiles: String );
    procedure setCanDo( const aCanDo: String );
    procedure setCanRead( const aCanRead: String );
    procedure setCodeControl( const aCodeControl: String );
    procedure setComputerName( const aComputerName: String );

    (*****
      OTRAS FUNCIONES DE SOPORTE
     *****)
    function  ValidateData: boolean;
    procedure TestCodigoB;
    procedure RefreshData;

  public
    (******
      PROPIEDADES DE LA VENTANA
     ******)
    property StationID: String read getStationID write setStationID ;
    property PathToDbFiles: String read getPathToDBFiles write setPathToDBFiles ;
    property CanDo: String read getCanDo write setCanDo ;
    property CanRead: String read getCanRead write setCanRead ;
    property CodeControl: String read getCodeControl write setCodeControl;
    property ComputerName: String write setComputerName;
  end;

implementation

{$R *.DFM}
  uses
    FileCtrl,   (* rutinas de directorios *)
    CCriptografiaCutre;  (* theCutreCriptoEngine *)

  (*****
     CONSTANTES PRIVADAS DEL MÓDULOS
   *****)
  const
    kCodeOpTipo01 = 'T01';
    kCodeOpTipo02 = 'T02';
    kCodeOpTipo03 = 'T03';
    kCodeOpTipo04 = 'T04';
    kCodeOpTipo05 = 'T05';
    kCodeOpTipo06 = 'T06';
    kCodeOpTipo07 = 'T07';
    kCodeOpTipo08 = 'T08';
    kCodeOpTipo09 = 'T09';
    kCodeOpTipo10 = 'T10';
    kCodeOpTipo11 = 'T11';
    kCodeOpTipo12 = 'T12';
    kCodeOpTipo13 = 'T13';
    kCodeOpTipo14 = 'T14';
    kCodeOpDev    = 'DEV';
    kCodeOpListado = 'LST';
    kCodeOpSoporte = 'FLE';

  (*****
    IMPLEMENTACIÓN DE MÉTODOS PRIVADOS.
   *****)

  (**** PROCEDIMIENTOS Y FUNCIONES DE SOPORTE A LAS PROPIEDADES ****)

  // para la propiead StatioID
  function TConfigSystemForm.getStationID: string ;
  begin
    result := trim( StationIDEdit.Text );
  end;  // -- TConfigSystemForm.getIDStation()

  procedure TConfigSystemForm.setStationID( const aStationID: string );
  begin
    StationIDEdit.Text := trim( aStationID );
    refreshData;
  end;  // -- TConfigSystemForm.setIDStation()

  // para la propiedad PathToDBFiles
  function TConfigSystemForm.getPathToDBFiles: String;
  begin
    result := trim( pathToDBFilesEdit.Text );
  end;  // -- TConfigSystemForm.getPathToDBFiles()

  procedure TConfigSystemForm.setPathToDBFiles( const aPathToDBFiles: String );
  begin
    pathToDBFilesEdit.Text := trim( aPathToDBFiles );
    refreshData;
  end; // -- TConfigSystemForm.setPathToDBFiles()

  // para la propiedad CanDO.
  // Esta propiedad tiene la salvedad de que es necesario montar una cadena a partir de los valores y
  // que para establecerlos se le pasa una cadena que hay que descomponer
  function TConfigSystemForm.getCanDo: String;
    const
      klSeparador = ',';
    // añade un separador a la cadena para separar un nuevo valor, siempre que esta no sea nula. Este es el caso cuando se va
    // a insertar el primer valor
    function addSep( const cadenaSinSeparador: String ): String;
    begin
      if trim( cadenaSinSeparador ) <> '' then
        result := trim( cadenaSinSeparador ) + klSeparador;
    end;
  begin
    result := '';
    if opTipo01CheckBox.Checked then result := kCodeOpTipo01;
    if opTipo02CheckBox.Checked then result := addSep( result ) + kCodeOpTipo02;
    if opTipo03CheckBox.Checked then result := addSep( result ) + kCodeOpTipo03;
    if opTipo04CheckBox.Checked then result := addSep( result ) + kCodeOpTipo04;
    if opTipo05CheckBox.Checked then result := addSep( result ) + kCodeOpTipo05;
    if opTipo06CheckBox.Checked then result := addSep( result ) + kCodeOpTipo06;
    if opTipo07CheckBox.Checked then result := addSep( result ) + kCodeOpTipo07;
    if opTipo08CheckBox.Checked then result := addSep( result ) + kCodeOpTipo08;
    if opTipo09CheckBox.Checked then result := addSep( result ) + kCodeOpTipo09;
    if opTipo10CheckBox.Checked then result := addSep( result ) + kCodeOpTipo10;
    if opTipo11CheckBox.Checked then result := addSep( result ) + kCodeOpTipo11;
    if opTipo12CheckBox.Checked then result := addSep( result ) + kCodeOpTipo12;
    if opTipo13CheckBox.Checked then result := addSep( result ) + kCodeOpTipo13;
    if opTipo14CheckBox.Checked then result := addSep( result ) + kCodeOpTipo14;
    if opTipoDevCheckBox.Checked then result := addSep( result ) + kCodeOpDev;
    if opLSTCheckBox.Checked    then result := addSep( result ) + kCodeOpListado;
    if opFLECheckBox.Checked    then result := addSep( result ) + kCodeOpSoporte;
  end; // -- TConfigSystemForm.getCanDo()

  procedure TConfigSystemForm.setCanDo( const aCanDo: String );
  begin
    // se debe ir comprobando uno a uno los valores que se incluyen en la cadena para ir activando las casillas
    // Se espera que la cadena esté correctamente normalizada (códigos separados por coma)
    opTipo01CheckBox.Checked := ( Pos( kCodeOpTipo01, aCanDo ) > 0 ) ;
    opTipo02CheckBox.Checked := ( Pos( kCodeOpTipo02, aCanDo ) > 0 ) ;
    opTipo03CheckBox.Checked := ( Pos( kCodeOpTipo03, aCanDo ) > 0 ) ;
    opTipo04CheckBox.Checked := ( Pos( kCodeOpTipo04, aCanDo ) > 0 ) ;
    opTipo05CheckBox.Checked := ( Pos( kCodeOpTipo05, aCanDo ) > 0 ) ;
    opTipo06CheckBox.Checked := ( Pos( kCodeOpTipo06, aCanDo ) > 0 ) ;
    opTipo07CheckBox.Checked := ( Pos( kCodeOpTipo07, aCanDo ) > 0 ) ;
    opTipo08CheckBox.Checked := ( Pos( kCodeOpTipo08, aCanDo ) > 0 ) ;
    opTipo09CheckBox.Checked := ( Pos( kCodeOpTipo09, aCanDo ) > 0 ) ;
    opTipo10CheckBox.Checked := ( Pos( kCodeOpTipo10, aCanDo ) > 0 ) ;
    opTipo11CheckBox.Checked := ( Pos( kCodeOpTipo11, aCanDo ) > 0 ) ;
    opTipo12CheckBox.Checked := ( Pos( kCodeOpTipo12, aCanDo ) > 0 ) ;
    opTipo13CheckBox.Checked := ( Pos( kCodeOpTipo13, aCanDo ) > 0 ) ;
    opTipo14CheckBox.Checked := ( Pos( kCodeOpTipo14, aCanDo ) > 0 ) ;
    opTipoDevCheckBox.Checked := ( Pos( kCodeOpDev, aCanDo ) > 0 );
    opLSTCheckBox.Checked    := ( Pos( kCodeOpListado, aCanDo ) > 0 ) ;
    opFLECheckBox.Checked    := ( Pos( kCodeOpSoporte, aCanDo ) > 0 ) ;

    refreshData;
  end; // -- TConfigSystemForm.setCanDo()

  // para la propiedad CanRead
  function TConfigSystemForm.getCanRead: String;
  begin
    result := trim( canReadEdit.Text );
  end; // -- TConfigSystemForm.getCanRead()

  procedure TConfigSystemForm.setCanRead( const aCanRead: String );
  begin
    canReadEdit.Text := trim( aCanRead );
    refreshData;
  end;

  // para la propiedad CodeControl
  function TConfigSystemForm.getCodeControl: String;
  begin
    result := trim( codigoBEdit.Text );
  end;

  procedure TConfigSystemForm.setCodeControl( const aCodeControl: String );
  begin
    codigoBEdit.Text := trim( aCodeControl );
    refreshData;
  end;

  procedure TConfigSystemForm.setComputerName( const aComputerName: String );
  begin
    theComputerName := trim( aComputerName );
    refreshData;
  end;

  (**** OTROS PROCEDIMIENTOS DE SOPORTE ****)

  // --- se encarga de comprobar que los datos introducidos son válidos y que no falta ninguno
  function TConfigSystemForm.ValidateData: boolean;
  begin
    // se debe comprobar que los datos necesarios existen y que son correctos
    result := true ;
    // debe existir el valor ID Estación
    if trim( StationID ) = '' then
    begin
      MessageDlg( 'Debe indicar un valor para ID-Estación', mtError, [mbOK], 0 );
      StationIDEdit.SetFocus ;
      result := false;
      exit;
    end;
    // se comprueba el PATH a los archivos de datos
    if trim( PathToDBFiles ) = '' then
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
      opTipo05CheckBox.SetFocus ;
      result := false;
      exit;
    end;
  end;

  // --- se encarga de comprobar que el código B es el acertado para el código A resultande
  // --- de ser así, procede a activar el botón de Aceptar
  procedure TConfigSystemForm.TestCodigoB;
  begin
    AceptarBtn.Enabled := ( theCutreCriptoEngine.isCodeBValid( trim( codigoAEdit.Text ), trim( codigoBedit.Text ) ) );
  end; // -- TConfigSystemForm.TestCodigoB()

  // --- se encarga de refrescar los valores de los campos...
  procedure TConfigSystemForm.refreshData;
  const
    klSeparadorCampos = '^CODE^';
  begin
    //  se genera la cadena sobre la que se calculará el código A a partir de los valores introducidos
    theStrCode := klSeparadorCampos;
    theStrCode := theStrCode + StationID ;
    theStrCode := theStrCode + klSeparadorCampos;
    theStrCode := theStrCode + PathToDBFiles ;
    theStrCode := theStrCode + klSeparadorCampos;
    theStrCode := theStrCode + CanDo ;
    theStrCode := theStrCode + klSeparadorCampos;
    theStrCode := theStrCode + CanRead ;
    theStrCode := theStrCode + klSeparadorCampos;
    if theComputerName <> EmptyStr then
    begin
      theStrCode := theStrCode + theComputerName;
      theStrCode := theStrCode + klSeparadorCampos;
    end;

    // se muestra el nombre del ordenador... si es que lo tiene
    systemNameLabel.Caption := 'Nombre del sistema: ' + theComputerName;
    systemNameLabel.Visible := ( theComputerName <> EmptyStr );

    // se obtiene el código A de control
    codigoAEdit.Text := theCutreCriptoEngine.getCodeA( theStrCode );

    // en última instancia se comprueba a ver si el código B es correcto y se activa el botón aceptar
    testCodigoB;
  end;  // TConfigSystemForm.refreshData()


(***********)
procedure TConfigSystemForm.StationIDEditChange(Sender: TObject);
begin
  refreshData;
end;

procedure TConfigSystemForm.BuscaDirSpeedBtnClick(Sender: TObject);
var
  nuevoDirectorio: String;
begin
  if SelectDirectory( 'Seleccione el directorio de datos', '', nuevoDirectorio ) then
  begin
    pathToDBFilesEdit.Text := trim( nuevoDirectorio );
    refreshData;
  end;
end;

procedure TConfigSystemForm.codigoBEditChange(Sender: TObject);
begin
  TestCodigoB;
end;

procedure TConfigSystemForm.AceptarBtnClick(Sender: TObject);
begin
  if ValidateData then
    ModalResult := mrOk ;
end;

procedure TConfigSystemForm.FormCreate(Sender: TObject);
begin
  StationID       := EmptyStr;
  
  theComputerName := EmptyStr;
end;

end.
