unit VShowListadoText;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Mask;

type
  TShowListadoTextForm = class(TForm)
    Panel1: TPanel;
    listadoMemo: TMemo;
    terminarButton: TButton;
    imprimirButton: TButton;
    selImpresoraButton: TButton;
    PrintDialog1: TPrintDialog;
    Label1: TLabel;
    numCopiasEdit: TMaskEdit;
    numCopiasUpDown: TUpDown;
    procedure terminarButtonClick(Sender: TObject);
    procedure selImpresoraButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ShowListadoTextForm: TShowListadoTextForm;

implementation

{$R *.dfm}

procedure TShowListadoTextForm.terminarButtonClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TShowListadoTextForm.selImpresoraButtonClick(Sender: TObject);
begin
  PrintDialog1.Execute();
end;

end.
