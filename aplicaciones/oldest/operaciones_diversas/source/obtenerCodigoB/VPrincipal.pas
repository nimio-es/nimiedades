unit VPrincipal;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TPrincipal = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    CodigoAEdit: TEdit;
    codigoBEdit: TEdit;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Principal: TPrincipal;

implementation

{$R *.DFM}

uses
  CCriptografiaCutre ;  (* TCutreCriptoEngine *)

procedure TPrincipal.Button1Click(Sender: TObject);
begin
  codigoBEdit.Text := theCutreCriptoEngine.getCodeB( trim( codigoAEdit.Text ) ); 
end;

end.
