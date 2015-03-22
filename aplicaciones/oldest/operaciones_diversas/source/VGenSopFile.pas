unit VGenSopFile;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, ToolEdit, ExtCtrls;

type
  TGenSopFileForm = class(TForm)
    Label1: TLabel;
    DirectorioDestinoEdit: TDirectoryEdit;
    ShowFileMemo: TMemo;
    procederBtn: TButton;
    cancelarBtn: TButton;
    Label2: TLabel;
    NombreFicheroResultanteEdit: TEdit;
    Panel1: TPanel;
    Label3: TLabel;
    fechaCompensacionEdit: TDateEdit;
    procedure fechaCompensacionEditAcceptDate(Sender: TObject;
      var ADate: TDateTime; var Action: Boolean);
  protected
    
    // -- soporte a las propiedades
    function  getDirectorioDestino: String;
    procedure setDirectorioDestino(const aDir: String);
    function  getNombreFichero:String;
    procedure setNombreFichero( const aName: String);
    function  getDepurar: Boolean;

  public
    property DirectorioDestino: String read getDirectorioDestino write setDirectorioDestino;
    property NombreFichero: String read getNombreFichero write setNombreFichero;
    property Depurar: Boolean read getDepurar;
  end;

implementation

{$R *.dfm}

(************
 MÉTODOS PROTEGIDOS
 ************)

function TGenSopFileForm.getDirectorioDestino: String;
begin
  Result := DirectorioDestinoEdit.Text;
end;

procedure TGenSopFileForm.setDirectorioDestino(const aDir:String);
begin
  DirectorioDestinoEdit.Text := aDir;
end;

function TGenSopFileForm.getNombreFichero: String;
begin
  Result := NombreFicheroResultanteEdit.Text;
end;

procedure TGenSopFileForm.setNombreFichero(const aName:String);
begin
  NombreFicheroResultanteEdit.Text := aName;
end;

function  TGenSopFileForm.getDepurar: Boolean;
begin
//  Result := depurarCheckBox.Checked;
  // Se ha eliminado el control de depuración, por lo que símplemente devolvermos falso
  Result := FALSE;
end;

procedure TGenSopFileForm.fechaCompensacionEditAcceptDate(Sender: TObject;
  var ADate: TDateTime; var Action: Boolean);
var
  hoy: TDateTime;
begin
  hoy := date();
  if ADate < hoy then
  begin
    ADate := hoy;
    Action := false;
  end;
end;

end.

