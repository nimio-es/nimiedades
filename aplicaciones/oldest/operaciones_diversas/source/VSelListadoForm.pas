unit VSelListadoForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, ToolEdit, ExtCtrls;

type
  TSelListadoForm = class(TForm)
    Label1: TLabel;
    tiposOperacionesRadioButton: TRadioButton;
    soportesRadioButton: TRadioButton;
    Bevel1: TBevel;
    Label2: TLabel;
    Label3: TLabel;
    fechaDesdeEdit: TDateEdit;
    Label4: TLabel;
    fechaHastaEdit: TDateEdit;
    Label5: TLabel;
    Label6: TLabel;
    AceptarButton: TButton;
    CancelarButton: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SelListadoForm: TSelListadoForm;

implementation

{$R *.dfm}

end.
